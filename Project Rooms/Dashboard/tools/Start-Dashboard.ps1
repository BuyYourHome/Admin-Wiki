param([int]$Port = 8765)

$ErrorActionPreference = 'Stop'
$repo = 'C:\Codex\Wiki Files'
$python = 'C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
$refresh = Join-Path $repo 'Project Rooms\Dashboard\tools\Refresh-DashboardData.ps1'
& $refresh -RepositoryRoot $repo
if (-not (Test-Path -LiteralPath $python)) { throw "Codex Python runtime not found at $python" }
$client = [System.Net.Sockets.TcpClient]::new()
try {
    $attempt = $client.BeginConnect('127.0.0.1', $Port, $null, $null)
    $serverRunning = $attempt.AsyncWaitHandle.WaitOne(250)
    if ($serverRunning) { $client.EndConnect($attempt) }
} catch {
    $serverRunning = $false
} finally {
    $client.Dispose()
}
if (-not $serverRunning) {
    Start-Process -FilePath $python -ArgumentList '-m', 'http.server', $Port, '--bind', '127.0.0.1' -WorkingDirectory $repo -WindowStyle Hidden
    Start-Sleep -Milliseconds 800
}
$url = "http://127.0.0.1:$Port/Project%20Rooms/Dashboard/site/"
Start-Process $url
Write-Output "Dashboard opened at $url"
