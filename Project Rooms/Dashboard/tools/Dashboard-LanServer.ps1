param(
    [int]$Port = 8765,
    [string]$HostIp = '10.0.0.105',
    [string]$RepositoryRoot = 'C:\Codex\Wiki Files'
)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath($RepositoryRoot)
$projectRoomsRoot = Join-Path $root 'Project Rooms'
$dashboardSiteRoot = Join-Path $projectRoomsRoot 'Dashboard\site'
$refreshScript = Join-Path $root 'Project Rooms\Dashboard\tools\Refresh-DashboardData.ps1'
$actionRequestStatePath = Join-Path $root 'Project Rooms\Dashboard\working\tmp\dashboard-action-requests.json'
$bridgeTestStatePath = Join-Path $root 'Project Rooms\Dashboard\working\tmp\dashboard-bridge-test-state.json'
$deletionRequestStatePath = Join-Path $root 'Project Rooms\Dashboard\working\tmp\dashboard-deletion-requests.json'
$serverErrorLogPath = Join-Path $root 'Project Rooms\Dashboard\working\tmp\dashboard-server-errors.log'
$actionsConfigPath = Join-Path $root 'Project Rooms\Dashboard\config\dashboard-actions.json'
$actionsConfig = if (Test-Path -LiteralPath $actionsConfigPath) {
    Get-Content -LiteralPath $actionsConfigPath -Raw | ConvertFrom-Json
} else {
    $null
}

& 'C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe' -NoProfile -ExecutionPolicy Bypass -File $refreshScript -RepositoryRoot $root | Out-Null

$listener = [System.Net.HttpListener]::new()
$prefixes = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
[void]$prefixes.Add("http://127.0.0.1:$Port/")
[void]$prefixes.Add("http://$HostIp`:$Port/")
foreach ($prefix in $prefixes) {
    $listener.Prefixes.Add($prefix)
}

function Send-Response {
    param(
        [System.Net.HttpListenerResponse]$Response,
        [int]$StatusCode,
        [byte[]]$Body,
        [string]$ContentType
    )
    $Response.StatusCode = $StatusCode
    $Response.ContentType = $ContentType
    $Response.ContentLength64 = $Body.Length
    $Response.Headers['Cache-Control'] = 'no-store'
    $Response.OutputStream.Write($Body, 0, $Body.Length)
    $Response.Close()
}

function Get-ContentType {
    param([string]$Path)
    switch ([System.IO.Path]::GetExtension($Path).ToLowerInvariant()) {
        '.css' { 'text/css; charset=utf-8' }
        '.js' { 'application/javascript; charset=utf-8' }
        '.json' { 'application/json; charset=utf-8' }
        '.html' { 'text/html; charset=utf-8' }
        '.md' { 'text/markdown; charset=utf-8' }
        '.svg' { 'image/svg+xml' }
        '.png' { 'image/png' }
        default { 'application/octet-stream' }
    }
}

function Get-ContextScript {
    param([System.Net.HttpListenerRequest]$Request)
    $payload = @{
        hostMode = 'lan-readonly'
        clientAccess = if ($Request.IsLocal) { 'local' } else { 'remote' }
        readOnly = $true
        allowAskJean = [bool]$Request.IsLocal
        allowHostActions = $false
        allowDeletionRequestWrites = [bool]$Request.IsLocal
    } | ConvertTo-Json -Compress
    return "window.DASHBOARD_CONTEXT = $payload;"
}

function Read-JsonBody {
    param([System.Net.HttpListenerRequest]$Request)

    $reader = [System.IO.StreamReader]::new($Request.InputStream, $Request.ContentEncoding)
    try {
        $body = $reader.ReadToEnd()
    } finally {
        $reader.Dispose()
    }
    if (-not $body) { throw 'Request body is required.' }
    return $body | ConvertFrom-Json
}

function Write-Utf8JsonFile {
    param(
        [string]$Path,
        [object]$Value,
        [int]$Depth = 8
    )

    $directory = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $directory)) {
        [void](New-Item -ItemType Directory -Path $directory -Force)
    }

    $json = $Value | ConvertTo-Json -Depth $Depth
    [System.IO.File]::WriteAllText($Path, $json, [System.Text.UTF8Encoding]::new($false))
}

function Write-ServerErrorLog {
    param(
        [string]$LogPath,
        [string]$RequestPath,
        [System.Exception]$Exception
    )

    $directory = Split-Path -Parent $LogPath
    if (-not (Test-Path -LiteralPath $directory)) {
        [void](New-Item -ItemType Directory -Path $directory -Force)
    }

    $line = '{0}`t{1}`t{2}' -f [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'), $RequestPath, $Exception.Message
    [System.IO.File]::AppendAllLines($LogPath, @($line), [System.Text.UTF8Encoding]::new($false))
}

function Convert-ToRequestList {
    param([object]$Payload)

    if ($null -eq $Payload) { return @() }
    if ($Payload.PSObject.Properties.Name -contains 'requests') { return @($Payload.requests) }
    return @($Payload)
}

function Get-ActionRequests {
    param(
        [string]$StatePath,
        [string]$LegacyBridgeTestStatePath,
        [string]$LegacyDeletionStatePath
    )

    $requests = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    $paths = @($StatePath, $LegacyBridgeTestStatePath, $LegacyDeletionStatePath)
    foreach ($path in $paths) {
        if (-not (Test-Path -LiteralPath $path)) { continue }
        $source = Convert-ToRequestList -Payload (Get-Content -LiteralPath $path -Raw | ConvertFrom-Json)
        foreach ($request in $source) {
            if ($null -eq $request) { continue }
            $requestId = [string]$request.requestId
            if (-not $requestId -or $seen.Contains($requestId)) { continue }
            [void]$seen.Add($requestId)
            [void]$requests.Add($request)
        }
    }

    return @($requests)
}

function Save-ActionRequests {
    param(
        [string]$StatePath,
        [object[]]$Requests,
        [string]$LegacyBridgeTestStatePath,
        [string]$LegacyDeletionStatePath
    )

    Write-Utf8JsonFile -Path $StatePath -Value ([ordered]@{ requests = @($Requests) }) -Depth 8

    $latestBridgeTest = @(
        $Requests |
        Where-Object { [string]$_.requestType -eq 'bridge-test' } |
        Sort-Object { [DateTimeOffset]::Parse($_.createdAt) } -Descending |
        Select-Object -First 1
    )[0]
    if ($latestBridgeTest) {
        Write-Utf8JsonFile -Path $LegacyBridgeTestStatePath -Value $latestBridgeTest -Depth 8
    } elseif (Test-Path -LiteralPath $LegacyBridgeTestStatePath) {
        Remove-Item -LiteralPath $LegacyBridgeTestStatePath -Force
    }

    $deletionRequests = @($Requests | Where-Object { [string]$_.requestType -eq 'project-room-deletion-request' })
    Write-Utf8JsonFile -Path $LegacyDeletionStatePath -Value ([ordered]@{ requests = $deletionRequests }) -Depth 8
}

function Start-ActionRequest {
    param(
        [string]$StatePath,
        [hashtable]$Request,
        [string]$LegacyBridgeTestStatePath,
        [string]$LegacyDeletionStatePath
    )

    if (-not $Request) { throw 'Action request payload is required.' }
    if (-not $Request.requestType) { throw 'Action request type is required.' }
    if (-not $Request.targetThreadId) { throw 'Target thread id is required.' }

    $timestamp = [DateTime]::UtcNow
    if (-not $Request.requestId) {
        $requestPrefix = ([string]$Request.requestType).ToLowerInvariant() -replace '[^a-z0-9]+', '-'
        $Request.requestId = '{0}-{1}' -f $requestPrefix.Trim('-'), $timestamp.ToString('yyyyMMdd-HHmmss')
    }
    if (-not $Request.createdAt) { $Request.createdAt = $timestamp.ToString('yyyy-MM-ddTHH:mm:ssZ') }
    if (-not $Request.status) { $Request.status = 'prepared' }
    if (-not $Request.PSObject.Properties.Name.Contains('deliveryAttemptedAt')) { $Request.deliveryAttemptedAt = $null }
    if (-not $Request.PSObject.Properties.Name.Contains('deliveredAt')) { $Request.deliveredAt = $null }
    if (-not $Request.PSObject.Properties.Name.Contains('returnedAt')) { $Request.returnedAt = $null }

    $requests = [System.Collections.Generic.List[object]]::new()
    foreach ($existing in (Get-ActionRequests -StatePath $StatePath -LegacyBridgeTestStatePath $LegacyBridgeTestStatePath -LegacyDeletionStatePath $LegacyDeletionStatePath)) {
        [void]$requests.Add($existing)
    }
    [void]$requests.Add([pscustomobject]$Request)
    Save-ActionRequests -StatePath $StatePath -Requests @($requests) -LegacyBridgeTestStatePath $LegacyBridgeTestStatePath -LegacyDeletionStatePath $LegacyDeletionStatePath
    return @($requests | Where-Object { [string]$_.requestId -eq [string]$Request.requestId } | Select-Object -First 1)[0]
}

function Set-ActionRequestStatus {
    param(
        [string]$StatePath,
        [string]$RequestId,
        [string]$Status,
        [string]$Message,
        [string]$DeliveryAttemptedAt,
        [string]$DeliveredAt,
        [string]$ReturnedAt,
        [string]$LegacyBridgeTestStatePath,
        [string]$LegacyDeletionStatePath
    )

    $allowedStatuses = @('prepared', 'sent', 'accepted', 'done', 'blocked', 'needs Wes', 'rejected as wrong room')
    if (-not $RequestId) { throw 'Action request id is required.' }
    if ($allowedStatuses -notcontains $Status) { throw "Status must be one of: $($allowedStatuses -join ', ')." }

    $updated = $false
    $requests = foreach ($request in (Get-ActionRequests -StatePath $StatePath -LegacyBridgeTestStatePath $LegacyBridgeTestStatePath -LegacyDeletionStatePath $LegacyDeletionStatePath)) {
        if ([string]$request.requestId -ne $RequestId) {
            $request
            continue
        }

        $updated = $true
        $state = [ordered]@{}
        foreach ($property in $request.PSObject.Properties) {
            $state[$property.Name] = $property.Value
        }
        $state.status = $Status
        if ($PSBoundParameters.ContainsKey('Message') -and $null -ne $Message -and $Message -ne '') { $state.message = $Message }
        if ($DeliveryAttemptedAt) { $state.deliveryAttemptedAt = $DeliveryAttemptedAt }
        if ($DeliveredAt) { $state.deliveredAt = $DeliveredAt }
        if ($ReturnedAt) { $state.returnedAt = $ReturnedAt }
        [pscustomobject]$state
    }

    if (-not $updated) { throw "Action request $RequestId was not found." }

    Save-ActionRequests -StatePath $StatePath -Requests @($requests) -LegacyBridgeTestStatePath $LegacyBridgeTestStatePath -LegacyDeletionStatePath $LegacyDeletionStatePath
    return @($requests | Where-Object { [string]$_.requestId -eq $RequestId } | Select-Object -First 1)[0]
}

function Get-RootDashboardHtml {
    $indexPath = Join-Path $dashboardSiteRoot 'index.html'
    $projectRoomsPath = Join-Path $dashboardSiteRoot 'project-rooms.js'
    $html = [System.IO.File]::ReadAllText($indexPath, [Text.Encoding]::UTF8)
    $baseTag = '<base href="/Project%20Rooms/Dashboard/site/">'
    $projectRoomsVersion = if (Test-Path -LiteralPath $projectRoomsPath) {
        [System.IO.File]::GetLastWriteTimeUtc($projectRoomsPath).Ticks
    } else {
        [DateTime]::UtcNow.Ticks
    }
    if ($html -notmatch '<base\s+') {
        $html = $html -replace '<head>', "<head>`r`n  $baseTag"
    }
    return $html -replace 'project-rooms\.js\?v=[^"]+', ("project-rooms.js?v={0}" -f $projectRoomsVersion)
}

function Get-BridgeTestState {
    param([string]$StatePath)

    return @(
        Get-ActionRequests -StatePath $actionRequestStatePath -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath |
        Where-Object { [string]$_.requestType -eq 'bridge-test' } |
        Sort-Object { [DateTimeOffset]::Parse($_.createdAt) } -Descending |
        Select-Object -First 1
    )[0]
}

function Get-DeletionRequests {
    param([string]$StatePath)

    return @(
        Get-ActionRequests -StatePath $actionRequestStatePath -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath |
        Where-Object { [string]$_.requestType -eq 'project-room-deletion-request' }
    )
}

function Save-DeletionRequests {
    param(
        [string]$StatePath,
        [object[]]$Requests
    )

    $otherRequests = @(
        Get-ActionRequests -StatePath $actionRequestStatePath -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath |
        Where-Object { [string]$_.requestType -ne 'project-room-deletion-request' }
    )
    Save-ActionRequests -StatePath $actionRequestStatePath -Requests @($otherRequests + @($Requests)) -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath
}

function New-DeletionRequestRecord {
    param([psobject]$Payload)

    if (-not $Payload) { throw 'Deletion request payload is required.' }
    if (-not $Payload.roomName) { throw 'Deletion request room name is required.' }
    if (-not $Payload.roomPath) { throw 'Deletion request room path is required.' }

    $timestamp = [DateTime]::UtcNow
    $requestId = 'dashboard-delete-request-{0}' -f $timestamp.ToString('yyyyMMdd-HHmmss')
    return [ordered]@{
        requestId = $requestId
        requestType = 'project-room-deletion-request'
        createdAt = $timestamp.ToString('yyyy-MM-ddTHH:mm:ssZ')
        sourcePr = 'Dashboard'
        sourceThreadId = '019fc52f-858a-72e1-926b-a0f6fbf0fd89'
        targetPr = 'Create PR'
        targetThreadId = '019fdc5e-a1da-7e10-b388-a3be3830ac89'
        requestedBy = 'Wes'
        requestedAction = if ($Payload.requestedAction) { [string]$Payload.requestedAction } else { 'Review this Project Room deletion request and return accepted, done, blocked, needs Wes, or rejected as wrong room. Do not delete, archive, or rename anything unless separately authorized.' }
        confirmation = if ($Payload.confirmation) { [string]$Payload.confirmation } else { "One explicit Dashboard confirmation for $($Payload.roomName); Dashboard executed no deletion." }
        projectRoom = [ordered]@{
            name = [string]$Payload.roomName
            path = [string]$Payload.roomPath
        }
        dashboardEntry = [string]$Payload.dashboardEntry
        matchingSkill = if ($Payload.matchingSkill) { $Payload.matchingSkill } else { $null }
        associatedTask = if ($Payload.associatedTask) { $Payload.associatedTask } else { $null }
        limits = @($Payload.limits)
        status = 'prepared'
        deliveryAttemptedAt = $null
        deliveredAt = $null
        returnedAt = $null
        message = 'Deletion request queued locally on the WesStudio LAN host view. The active Dashboard Codex task still needs to deliver it to Create PR and write the returned status back here.'
    }
}

function Start-DeletionRequest {
    param(
        [string]$StatePath,
        [psobject]$Payload
    )

    $record = New-DeletionRequestRecord -Payload $Payload
    return Start-ActionRequest -StatePath $actionRequestStatePath -Request $record -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath
}

function Set-DeletionRequestStatus {
    param(
        [string]$StatePath,
        [string]$RequestId,
        [string]$Status,
        [string]$Message,
        [string]$DeliveryAttemptedAt,
        [string]$DeliveredAt,
        [string]$ReturnedAt
    )

    return Set-ActionRequestStatus -StatePath $actionRequestStatePath -RequestId $RequestId -Status $Status -Message $Message -DeliveryAttemptedAt $DeliveryAttemptedAt -DeliveredAt $DeliveredAt -ReturnedAt $ReturnedAt -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath
}

function Get-AllowedModeActionRequestPaths {
    param($ActionsConfig)

    $allowed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if (-not $ActionsConfig -or -not $ActionsConfig.modeActions) { return $allowed }

    $dashboardBase = [System.Uri]::new('http://dashboard.local/Project%20Rooms/Dashboard/site/')
    $allowedExtensions = @('.md', '.svg', '.html', '.png', '.jpg', '.jpeg', '.pdf')

    foreach ($roomProperty in $ActionsConfig.modeActions.PSObject.Properties) {
        foreach ($modeProperty in $roomProperty.Value.PSObject.Properties) {
            $action = $modeProperty.Value
            $type = if ($action.type) { [string]$action.type } else { 'open-url' }
            if ($type -ne 'open-url' -or -not $action.href) { continue }
            if ([string]$action.href -match '^[a-z][a-z0-9+.-]*:') { continue }

            $requestPath = [System.Uri]::new($dashboardBase, [string]$action.href).AbsolutePath.TrimStart('/')
            $normalizedRequestPath = [System.Uri]::UnescapeDataString($requestPath)
            $targetPath = [System.IO.Path]::GetFullPath((Join-Path $root $normalizedRequestPath))
            $extension = [System.IO.Path]::GetExtension($targetPath).ToLowerInvariant()

            if ($targetPath.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -and
                $allowedExtensions -contains $extension -and
                (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
                [void]$allowed.Add(($normalizedRequestPath -replace '\\', '/'))
            }
        }
    }

    return $allowed
}

$allowedModeActionRequestPaths = Get-AllowedModeActionRequestPaths -ActionsConfig $actionsConfig

function Resolve-AllowedTarget {
    param([string]$RelativePath)

    if (-not $RelativePath) {
        return '__dashboard_root__'
    }

    $normalized = $RelativePath -replace '\\', '/'
    if ($normalized -eq 'index.html') { return '__dashboard_root__' }
    if ($normalized -eq 'Project Rooms/Dashboard/site/__dashboard-context.js') { return '__dashboard_context__' }
    if ($normalized -eq 'Project Rooms/Dashboard/site/__dashboard-refresh') { return '__dashboard_refresh__' }
    if ($normalized -eq 'Project Rooms/Dashboard/site/__dashboard-bridge-test') { return '__dashboard_bridge_test__' }
    if ($normalized -eq 'Project Rooms/Dashboard/site/__dashboard-deletion-request') { return '__dashboard_deletion_request__' }
    if ($normalized -eq 'Project Rooms/Dashboard/site/__dashboard-action-requests') { return '__dashboard_action_requests__' }

    if ($normalized.StartsWith('Project Rooms/Dashboard/site/', [System.StringComparison]::OrdinalIgnoreCase)) {
        $target = [System.IO.Path]::GetFullPath((Join-Path $root $RelativePath))
        if ($target.StartsWith($dashboardSiteRoot, [System.StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $target -PathType Leaf)) {
            return $target
        }
        return $null
    }

    if ($normalized -match '^Project Rooms/[^/]+/README\.md$') {
        $target = [System.IO.Path]::GetFullPath((Join-Path $root $RelativePath))
        if ($target.StartsWith($projectRoomsRoot, [System.StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $target -PathType Leaf)) {
            return $target
        }
        return $null
    }

    if ($normalized.StartsWith('Project Rooms/SOPs/outputs/SOPs/', [System.StringComparison]::OrdinalIgnoreCase) -and $normalized.EndsWith('.md', [System.StringComparison]::OrdinalIgnoreCase)) {
        $target = [System.IO.Path]::GetFullPath((Join-Path $root $RelativePath))
        $allowedRoot = [System.IO.Path]::GetFullPath((Join-Path $root 'Project Rooms\SOPs\outputs\SOPs'))
        if ($target.StartsWith($allowedRoot, [System.StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $target -PathType Leaf)) {
            return $target
        }
        return $null
    }

    if ($normalized -eq 'Project Rooms/Entity Relationship/outputs/entity-relationship-chart.svg') {
        $target = [System.IO.Path]::GetFullPath((Join-Path $root $RelativePath))
        if (Test-Path -LiteralPath $target -PathType Leaf) {
            return $target
        }
    }

    if ($allowedModeActionRequestPaths.Contains($normalized)) {
        $target = [System.IO.Path]::GetFullPath((Join-Path $root $normalized))
        if ($target.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $target -PathType Leaf)) {
            return $target
        }
    }

    return $null
}

$listener.Start()
try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        try {
            $path = [uri]::UnescapeDataString($context.Request.Url.AbsolutePath).TrimStart('/')
            if ($context.Request.HttpMethod -eq 'GET' -and $path -eq '__dashboard-health') {
                $body = [Text.Encoding]::UTF8.GetBytes("{""ok"":true,""service"":""dashboard-lan"",""hostIp"":""$HostIp"",""port"":$Port}")
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                continue
            }

            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-deletion-request') {
                if (-not $context.Request.IsLocal) {
                    $body = [Text.Encoding]::UTF8.GetBytes('{"ok":false,"message":"Deletion request creation is available only from WesStudio itself."}')
                    Send-Response -Response $context.Response -StatusCode 403 -Body $body -ContentType 'application/json; charset=utf-8'
                    continue
                }
                try {
                    $payload = Read-JsonBody -Request $context.Request
                    $record = Start-DeletionRequest -StatePath $deletionRequestStatePath -Payload $payload
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        state = $record
                        message = "Dashboard deletion request $($record.requestId) is queued locally for $($record.projectRoom.name). The active Dashboard Codex task still needs to deliver it to Create PR."
                    } | ConvertTo-Json -Depth 8 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 400 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }

            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-action-request') {
                if (-not $context.Request.IsLocal) {
                    $body = [Text.Encoding]::UTF8.GetBytes('{"ok":false,"message":"Action request creation is available only from WesStudio itself."}')
                    Send-Response -Response $context.Response -StatusCode 403 -Body $body -ContentType 'application/json; charset=utf-8'
                    continue
                }
                try {
                    $payload = Read-JsonBody -Request $context.Request
                    $request = [ordered]@{}
                    foreach ($property in $payload.PSObject.Properties) {
                        $request[$property.Name] = $property.Value
                    }
                    $state = Start-ActionRequest -StatePath $actionRequestStatePath -Request $request -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        state = $state
                        message = "Dashboard action request $($state.requestId) is queued locally for the Dashboard bridge processor."
                    } | ConvertTo-Json -Depth 8 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 400 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }

            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-deletion-request-status') {
                if (-not $context.Request.IsLocal) {
                    $body = [Text.Encoding]::UTF8.GetBytes('{"ok":false,"message":"Deletion request status updates are available only from WesStudio itself."}')
                    Send-Response -Response $context.Response -StatusCode 403 -Body $body -ContentType 'application/json; charset=utf-8'
                    continue
                }
                try {
                    $payload = Read-JsonBody -Request $context.Request
                    $state = Set-DeletionRequestStatus `
                        -StatePath $deletionRequestStatePath `
                        -RequestId ([string]$payload.requestId) `
                        -Status ([string]$payload.status) `
                        -Message ([string]$payload.message) `
                        -DeliveryAttemptedAt ([string]$payload.deliveryAttemptedAt) `
                        -DeliveredAt ([string]$payload.deliveredAt) `
                        -ReturnedAt ([string]$payload.returnedAt)
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        state = $state
                        message = "Dashboard deletion request $($state.requestId) updated to $($state.status)."
                    } | ConvertTo-Json -Depth 8 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 400 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }

            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-action-request-status') {
                if (-not $context.Request.IsLocal) {
                    $body = [Text.Encoding]::UTF8.GetBytes('{"ok":false,"message":"Action request status updates are available only from WesStudio itself."}')
                    Send-Response -Response $context.Response -StatusCode 403 -Body $body -ContentType 'application/json; charset=utf-8'
                    continue
                }
                try {
                    $payload = Read-JsonBody -Request $context.Request
                    $state = Set-ActionRequestStatus `
                        -StatePath $actionRequestStatePath `
                        -RequestId ([string]$payload.requestId) `
                        -Status ([string]$payload.status) `
                        -Message ([string]$payload.message) `
                        -DeliveryAttemptedAt ([string]$payload.deliveryAttemptedAt) `
                        -DeliveredAt ([string]$payload.deliveredAt) `
                        -ReturnedAt ([string]$payload.returnedAt) `
                        -LegacyBridgeTestStatePath $bridgeTestStatePath `
                        -LegacyDeletionStatePath $deletionRequestStatePath
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        state = $state
                        message = "Dashboard action request $($state.requestId) updated to $($state.status)."
                    } | ConvertTo-Json -Depth 8 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 400 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }

            if ($context.Request.HttpMethod -notin @('GET', 'HEAD')) {
                $body = [Text.Encoding]::UTF8.GetBytes('Method not allowed')
                Send-Response -Response $context.Response -StatusCode 405 -Body $body -ContentType 'text/plain; charset=utf-8'
                continue
            }

            $target = Resolve-AllowedTarget -RelativePath $path
            if ($target -eq '__dashboard_root__') {
                $body = [Text.Encoding]::UTF8.GetBytes((Get-RootDashboardHtml))
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'text/html; charset=utf-8'
                continue
            }
            if ($target -eq '__dashboard_context__') {
                $body = [Text.Encoding]::UTF8.GetBytes((Get-ContextScript -Request $context.Request))
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/javascript; charset=utf-8'
                continue
            }
            if ($target -eq '__dashboard_refresh__') {
                $body = [Text.Encoding]::UTF8.GetBytes('{"ok":false,"message":"Refresh is disabled in LAN read-only host mode."}')
                Send-Response -Response $context.Response -StatusCode 403 -Body $body -ContentType 'application/json; charset=utf-8'
                continue
            }
            if ($target -eq '__dashboard_bridge_test__') {
                $body = [Text.Encoding]::UTF8.GetBytes((@{
                    ok = $true
                    state = (Get-BridgeTestState -StatePath $bridgeTestStatePath)
                } | ConvertTo-Json -Depth 6 -Compress))
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                continue
            }
            if ($target -eq '__dashboard_deletion_request__') {
                $body = [Text.Encoding]::UTF8.GetBytes((@{
                    ok = $true
                    requests = @(Get-DeletionRequests -StatePath $deletionRequestStatePath)
                } | ConvertTo-Json -Depth 8 -Compress))
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                continue
            }
            if ($target -eq '__dashboard_action_requests__') {
                try {
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        requests = @(Get-ActionRequests -StatePath $actionRequestStatePath -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath)
                    } | ConvertTo-Json -Depth 8 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 500 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }
            if (-not $target) {
                $body = [Text.Encoding]::UTF8.GetBytes('Not found')
                Send-Response -Response $context.Response -StatusCode 404 -Body $body -ContentType 'text/plain; charset=utf-8'
                continue
            }

            $body = if ($context.Request.HttpMethod -eq 'HEAD') { [byte[]]@() } else { [System.IO.File]::ReadAllBytes($target) }
            Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType (Get-ContentType -Path $target)
        } catch {
            Write-ServerErrorLog -LogPath $serverErrorLogPath -RequestPath $path -Exception $_.Exception
            if ($context.Response.OutputStream.CanWrite) {
                $body = [Text.Encoding]::UTF8.GetBytes('Dashboard LAN host error')
                Send-Response -Response $context.Response -StatusCode 500 -Body $body -ContentType 'text/plain; charset=utf-8'
            }
        }
    }
} finally {
    $listener.Stop()
    $listener.Close()
}
