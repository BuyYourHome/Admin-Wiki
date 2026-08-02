param(
    [int]$Port = 8765,
    [string]$RepositoryRoot = 'C:\Codex\Wiki Files'
)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath($RepositoryRoot)
$refreshScript = Join-Path $root 'Project Rooms\Dashboard\tools\Refresh-DashboardData.ps1'
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
        '.svg' { 'image/svg+xml' }
        '.png' { 'image/png' }
        '.jpg' { 'image/jpeg' }
        '.jpeg' { 'image/jpeg' }
        '.pdf' { 'application/pdf' }
        default { 'application/octet-stream' }
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
            if (-not $path) { $path = 'Project Rooms/Dashboard/site/index.html' }
            $target = [System.IO.Path]::GetFullPath((Join-Path $root $path))
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
