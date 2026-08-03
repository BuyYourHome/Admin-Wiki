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
    } | ConvertTo-Json -Compress
    return "window.DASHBOARD_CONTEXT = $payload;"
}

function Resolve-AllowedTarget {
    param([string]$RelativePath)

    if (-not $RelativePath) {
        return Join-Path $dashboardSiteRoot 'index.html'
    }

    $normalized = $RelativePath -replace '\\', '/'
    if ($normalized -eq 'Project Rooms/Dashboard/site/__dashboard-context.js') { return '__dashboard_context__' }
    if ($normalized -eq 'Project Rooms/Dashboard/site/__dashboard-refresh') { return '__dashboard_refresh__' }

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

            if ($context.Request.HttpMethod -notin @('GET', 'HEAD')) {
                $body = [Text.Encoding]::UTF8.GetBytes('Method not allowed')
                Send-Response -Response $context.Response -StatusCode 405 -Body $body -ContentType 'text/plain; charset=utf-8'
                continue
            }

            $target = Resolve-AllowedTarget -RelativePath $path
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
            if (-not $target) {
                $body = [Text.Encoding]::UTF8.GetBytes('Not found')
                Send-Response -Response $context.Response -StatusCode 404 -Body $body -ContentType 'text/plain; charset=utf-8'
                continue
            }

            $body = if ($context.Request.HttpMethod -eq 'HEAD') { [byte[]]@() } else { [System.IO.File]::ReadAllBytes($target) }
            Send-Response -Response $context.Response -StatusCode 200 -Body $body -ContentType (Get-ContentType -Path $target)
        } catch {
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
