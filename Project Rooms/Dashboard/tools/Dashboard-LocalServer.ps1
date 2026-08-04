param(
    [int]$Port = 8765,
    [string]$RepositoryRoot = 'C:\Codex\Wiki Files'
)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath($RepositoryRoot)
$refreshScript = Join-Path $root 'Project Rooms\Dashboard\tools\Refresh-DashboardData.ps1'
$managerTaskRegisterPath = Join-Path $root 'Project Rooms\Manager\working\task-register.md'
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
            Send-Response -Response $context.Response -StatusCode 200 -Body ([System.IO.File]::ReadAllBytes($target)) -ContentType (Get-ContentType -Path $target)
        } catch {
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
