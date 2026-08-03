param(
    [switch]$StopRunningServer
)

$ErrorActionPreference = 'Stop'
$taskName = 'BYH Dashboard LAN Host'
$firewallRuleName = 'BYH Dashboard LAN Host TCP 8765'

if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

$existingRule = Get-NetFirewallRule -DisplayName $firewallRuleName -ErrorAction SilentlyContinue
if ($existingRule) { $existingRule | Remove-NetFirewallRule }

if ($StopRunningServer) {
    Get-CimInstance Win32_Process |
        Where-Object { $_.CommandLine -like '*Dashboard-LanServer.ps1*' } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
}

Write-Output "Removed Dashboard LAN host task and firewall rule."
