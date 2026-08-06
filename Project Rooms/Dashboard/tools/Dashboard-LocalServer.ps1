param(
    [int]$Port = 8765,
    [string]$RepositoryRoot = 'C:\Codex\Wiki Files'
)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath($RepositoryRoot)
$refreshScript = Join-Path $root 'Project Rooms\Dashboard\tools\Refresh-DashboardData.ps1'
$managerTaskRegisterPath = Join-Path $root 'Project Rooms\Manager\working\task-register.md'
$actionRequestStatePath = Join-Path $root 'Project Rooms\Dashboard\working\tmp\dashboard-action-requests.json'
$bridgeTestStatePath = Join-Path $root 'Project Rooms\Dashboard\working\tmp\dashboard-bridge-test-state.json'
$deletionRequestStatePath = Join-Path $root 'Project Rooms\Dashboard\working\tmp\dashboard-deletion-requests.json'
$serverErrorLogPath = Join-Path $root 'Project Rooms\Dashboard\working\tmp\dashboard-server-errors.log'
$bridgeTestSourceThreadId = '019fc52f-858a-72e1-926b-a0f6fbf0fd89'
$createPrTargetThreadId = '019f583e-7f14-7ae2-aa24-4e991544e306'
$bridgeTestTargetThreadId = $createPrTargetThreadId
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://127.0.0.1:$Port/")

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
        '.jpg' { 'image/jpeg' }
        '.jpeg' { 'image/jpeg' }
        '.pdf' { 'application/pdf' }
        default { 'application/octet-stream' }
    }
}

function Get-ContextScript {
    $payload = @{
        hostMode = 'local-full'
        clientAccess = 'local'
        readOnly = $false
        allowAskJean = $true
        allowHostActions = $true
        allowDeletionRequestWrites = $true
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

function Get-RootDashboardHtml {
    param([string]$IndexPath)

    $siteRoot = Split-Path -Parent $IndexPath
    $projectRoomsPath = Join-Path $siteRoot 'project-rooms.js'
    $html = [System.IO.File]::ReadAllText($IndexPath, [Text.Encoding]::UTF8)
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

function Get-BridgeTestState {
    param([string]$StatePath)

    return @(
        Get-ActionRequests -StatePath $actionRequestStatePath -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath |
        Where-Object { [string]$_.requestType -eq 'bridge-test' } |
        Sort-Object { [DateTimeOffset]::Parse($_.createdAt) } -Descending |
        Select-Object -First 1
    )[0]
}

function Save-BridgeTestState {
    param(
        [string]$StatePath,
        [hashtable]$State
    )

    $requests = @(
        Get-ActionRequests -StatePath $actionRequestStatePath -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath |
        Where-Object { [string]$_.requestId -ne [string]$State.requestId }
    )
    Save-ActionRequests -StatePath $actionRequestStatePath -Requests @($requests + [pscustomobject]$State) -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath
}

function New-BridgeTestState {
    $timestamp = [DateTime]::UtcNow
    $requestId = 'dashboard-bridge-test-{0}' -f $timestamp.ToString('yyyyMMdd-HHmmss')
    return [ordered]@{
        requestId = $requestId
        requestType = 'bridge-test'
        createdAt = $timestamp.ToString('yyyy-MM-ddTHH:mm:ssZ')
        sourcePr = 'Dashboard'
        sourceThreadId = $bridgeTestSourceThreadId
        targetPr = 'Create PR'
        targetThreadId = $bridgeTestTargetThreadId
        requestedBy = 'Wes'
        requestedAction = 'Acknowledge this bridge test and return accepted or done without performing any PR creation or deletion.'
        notes = 'Transport proof only. No filesystem or governance action is authorized by this test.'
        status = 'prepared'
        deliveryAttemptedAt = $null
        deliveredAt = $null
        returnedAt = $null
        message = 'Prepared on the local Dashboard host. Delivery must be completed by the active Dashboard Codex task.'
    }
}

function Start-BridgeTestRequest {
    param([string]$StatePath)

    $existing = Get-BridgeTestState -StatePath $StatePath
    if ($existing) { return $existing }

    $state = New-BridgeTestState
    return Start-ActionRequest -StatePath $actionRequestStatePath -Request $state -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath
}

function Set-BridgeTestStatus {
    param(
        [string]$StatePath,
        [string]$RequestId,
        [string]$Status,
        [string]$Message,
        [string]$DeliveryAttemptedAt,
        [string]$DeliveredAt,
        [string]$ReturnedAt
    )

    $existing = Get-BridgeTestState -StatePath $StatePath
    if (-not $existing) { throw 'No Dashboard bridge test request is currently recorded.' }
    if (-not $RequestId -or $existing.requestId -ne $RequestId) { throw 'Bridge test request id does not match the recorded state.' }
    return Set-ActionRequestStatus -StatePath $actionRequestStatePath -RequestId $RequestId -Status $Status -Message $Message -DeliveryAttemptedAt $DeliveryAttemptedAt -DeliveredAt $DeliveredAt -ReturnedAt $ReturnedAt -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath
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
        sourceThreadId = $bridgeTestSourceThreadId
        targetPr = 'Create PR'
        targetThreadId = $createPrTargetThreadId
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
        message = 'Deletion request recorded on the local Dashboard host. The active Dashboard Codex task performs the actual task-message send and writes the returned status back here.'
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

function Set-ManagerTaskStatus {
    param(
        [string]$TaskRegisterPath,
        [string]$TaskId,
        [string]$Status
    )

    $allowedStatuses = @('New', 'Delivered', 'Acknowledged', 'In Progress', 'Waiting', 'Completed', 'Cancelled')
    if (-not $TaskId) { throw 'Task id is required.' }
    if ($allowedStatuses -notcontains $Status) { throw "Status must be one of: $($allowedStatuses -join ', ')." }
    if (-not (Test-Path -LiteralPath $TaskRegisterPath)) { throw 'Manager task register was not found.' }

    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($line in (Get-Content -LiteralPath $TaskRegisterPath)) { [void]$lines.Add($line) }

    $rowIndex = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^\|\s*$([regex]::Escape($TaskId))\s*\|") {
            $rowIndex = $i
            break
        }
    }
    if ($rowIndex -lt 0) { throw "Task $TaskId was not found in the Manager register." }

    $parts = @($lines[$rowIndex].Trim().Split('|'))
    if ($parts.Count -lt 12) { throw "Task $TaskId has an invalid register row format." }
    $values = @($parts[1..($parts.Count - 2)] | ForEach-Object { $_.Trim() })
    if ($values.Count -lt 10) { throw "Task $TaskId has an incomplete register row." }

    $timestamp = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')
    $values[5] = $Status
    $values[8] = $timestamp
    $lines[$rowIndex] = '| ' + ($values -join ' | ') + ' |'
    [System.IO.File]::WriteAllLines($TaskRegisterPath, $lines, [System.Text.UTF8Encoding]::new($false))

    return [ordered]@{
        taskId = $TaskId
        status = $Status
        lastUpdated = $timestamp
    }
}

$listener.Start()
try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        try {
            $path = [uri]::UnescapeDataString($context.Request.Url.AbsolutePath).TrimStart('/')
            if ($context.Request.HttpMethod -eq 'GET' -and $path -eq '__dashboard-health') {
                $body = [Text.Encoding]::UTF8.GetBytes('{"ok":true,"service":"dashboard-local"}')
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                continue
            }
            if ($context.Request.HttpMethod -eq 'GET' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-context.js') {
                $body = [Text.Encoding]::UTF8.GetBytes((Get-ContextScript))
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/javascript; charset=utf-8'
                continue
            }
            if ($context.Request.HttpMethod -eq 'GET' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-bridge-test') {
                $state = Get-BridgeTestState -StatePath $bridgeTestStatePath
                $body = [Text.Encoding]::UTF8.GetBytes((@{
                    ok = $true
                    state = $state
                } | ConvertTo-Json -Depth 6 -Compress))
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                continue
            }
            if ($context.Request.HttpMethod -eq 'GET' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-deletion-request') {
                $requests = Get-DeletionRequests -StatePath $deletionRequestStatePath
                $body = [Text.Encoding]::UTF8.GetBytes((@{
                    ok = $true
                    requests = @($requests)
                } | ConvertTo-Json -Depth 8 -Compress))
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                continue
            }
            if ($context.Request.HttpMethod -eq 'GET' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-action-requests') {
                try {
                    $requests = Get-ActionRequests -StatePath $actionRequestStatePath -LegacyBridgeTestStatePath $bridgeTestStatePath -LegacyDeletionStatePath $deletionRequestStatePath
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        requests = @($requests)
                    } | ConvertTo-Json -Depth 8 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 500 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }
            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-refresh') {
                try {
                    & $refreshScript -RepositoryRoot $root | Out-Null
                    $body = [Text.Encoding]::UTF8.GetBytes('{"ok":true,"message":"Local Project Room data refreshed."}')
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 500 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }
            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-bridge-test') {
                try {
                    $state = Start-BridgeTestRequest -StatePath $bridgeTestStatePath
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        state = $state
                        message = "Dashboard bridge test request $($state.requestId) is recorded."
                    } | ConvertTo-Json -Depth 6 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 400 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }
            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-action-request') {
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
                        message = "Dashboard action request $($state.requestId) is recorded."
                    } | ConvertTo-Json -Depth 8 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 400 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }
            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-bridge-test-status') {
                try {
                    $payload = Read-JsonBody -Request $context.Request
                    $state = Set-BridgeTestStatus `
                        -StatePath $bridgeTestStatePath `
                        -RequestId ([string]$payload.requestId) `
                        -Status ([string]$payload.status) `
                        -Message ([string]$payload.message) `
                        -DeliveryAttemptedAt ([string]$payload.deliveryAttemptedAt) `
                        -DeliveredAt ([string]$payload.deliveredAt) `
                        -ReturnedAt ([string]$payload.returnedAt)
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        state = $state
                        message = "Dashboard bridge test request $($state.requestId) updated to $($state.status)."
                    } | ConvertTo-Json -Depth 6 -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 400 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }
            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-action-request-status') {
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
            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-deletion-request') {
                try {
                    $payload = Read-JsonBody -Request $context.Request
                    $record = Start-DeletionRequest -StatePath $deletionRequestStatePath -Payload $payload
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        state = $record
                        message = "Dashboard deletion request $($record.requestId) is recorded for $($record.projectRoom.name)."
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
            if ($context.Request.HttpMethod -eq 'POST' -and $path -eq 'Project Rooms/Dashboard/site/__dashboard-manager-task-status') {
                try {
                    $payload = Read-JsonBody -Request $context.Request
                    $result = Set-ManagerTaskStatus -TaskRegisterPath $managerTaskRegisterPath -TaskId ([string]$payload.taskId) -Status ([string]$payload.status)
                    & $refreshScript -RepositoryRoot $root | Out-Null
                    $body = [Text.Encoding]::UTF8.GetBytes((@{
                        ok = $true
                        taskId = $result.taskId
                        status = $result.status
                        lastUpdated = $result.lastUpdated
                        message = "Manager task $($result.taskId) updated to $($result.status)."
                    } | ConvertTo-Json -Compress))
                    Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'application/json; charset=utf-8'
                } catch {
                    $payload = @{ ok = $false; message = $_.Exception.Message } | ConvertTo-Json -Compress
                    $body = [Text.Encoding]::UTF8.GetBytes($payload)
                    Send-Response -Response $context.Response -StatusCode 400 -Body $body -ContentType 'application/json; charset=utf-8'
                }
                continue
            }
            if (-not $path) { $path = 'Project Rooms/Dashboard/site/index.html' }
            $target = [System.IO.Path]::GetFullPath((Join-Path $root $path))
            if (Test-Path -LiteralPath $target -PathType Container) {
                $target = Join-Path $target 'index.html'
            }
            if (-not $target.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $target -PathType Leaf)) {
                $body = [Text.Encoding]::UTF8.GetBytes('Not found')
                Send-Response -Response $context.Response -StatusCode 404 -Body $body -ContentType 'text/plain; charset=utf-8'
                continue
            }
            if ($target.EndsWith('\Project Rooms\Dashboard\site\index.html', [System.StringComparison]::OrdinalIgnoreCase)) {
                $body = [Text.Encoding]::UTF8.GetBytes((Get-RootDashboardHtml -IndexPath $target))
                Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType 'text/html; charset=utf-8'
                continue
            }
            Send-Response -Response $context.Response -StatusCode 200 -Body ([System.IO.File]::ReadAllBytes($target)) -ContentType (Get-ContentType -Path $target)
        } catch {
            Write-ServerErrorLog -LogPath $serverErrorLogPath -RequestPath $path -Exception $_.Exception
            if ($context.Response.OutputStream.CanWrite) {
                $body = [Text.Encoding]::UTF8.GetBytes('Local Dashboard server error')
                Send-Response -Response $context.Response -StatusCode 500 -Body $body -ContentType 'text/plain; charset=utf-8'
            }
        }
    }
} finally {
    $listener.Stop()
    $listener.Close()
}
