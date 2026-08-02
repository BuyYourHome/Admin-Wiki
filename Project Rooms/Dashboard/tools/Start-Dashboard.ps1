param([int]$Port = 8765)

$ErrorActionPreference = 'Stop'
$repo = 'C:\Codex\Wiki Files'
$refresh = Join-Path $repo 'Project Rooms\Dashboard\tools\Refresh-DashboardData.ps1'
$server = Join-Path $repo 'Project Rooms\Dashboard\tools\Dashboard-LocalServer.ps1'
& $refresh -RepositoryRoot $repo

function Test-DashboardServer {
    param([int]$CandidatePort)
    try {
        $response = Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 "http://127.0.0.1:$CandidatePort/__dashboard-health"
        return $response.StatusCode -eq 200 -and $response.Content -match 'dashboard-local'
    } catch { return $false }
}

$selectedPort = $Port
if (-not (Test-DashboardServer -CandidatePort $selectedPort)) {
    $candidatePorts = @($Port) + (($Port + 1)..($Port + 10))
    foreach ($candidate in $candidatePorts) {
        if (Test-DashboardServer -CandidatePort $candidate) {
            $selectedPort = $candidate
            break
        }
        $client = [System.Net.Sockets.TcpClient]::new()
        try {
            $attempt = $client.BeginConnect('127.0.0.1', $candidate, $null, $null)
            if ($attempt.AsyncWaitHandle.WaitOne(250)) { $client.EndConnect($attempt); continue }
        } catch {} finally { $client.Dispose() }
        $serverArguments = "-NoProfile -ExecutionPolicy Bypass -File `"$server`" -Port $candidate -RepositoryRoot `"$repo`""
        Start-Process -FilePath 'C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe' -ArgumentList $serverArguments -WindowStyle Hidden
        Start-Sleep -Milliseconds 500
        if (Test-DashboardServer -CandidatePort $candidate) {
            $selectedPort = $candidate
            break
        }
    }
}
$url = "http://127.0.0.1:$selectedPort/Project%20Rooms/Dashboard/site/"
Start-Process $url
Write-Output "Dashboard opened at $url"
