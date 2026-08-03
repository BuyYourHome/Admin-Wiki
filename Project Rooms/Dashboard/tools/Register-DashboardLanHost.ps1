param(
    [string]$HostIp = '10.0.0.105',
    [string]$RemoteSubnet = '10.0.0.0/24',
    [int]$Port = 8765,
    [string]$RepositoryRoot = 'C:\Codex\Wiki Files',
    [switch]$SkipFirewallUpdate
)

$ErrorActionPreference = 'Stop'
$taskName = 'BYH Dashboard LAN Host'
$firewallRuleName = 'BYH Dashboard LAN Host TCP 8765'
$serverScript = Join-Path $RepositoryRoot 'Project Rooms\Dashboard\tools\Dashboard-LanServer.ps1'
$hiddenLauncher = Join-Path $RepositoryRoot 'Project Rooms\Dashboard\tools\Start-DashboardLanHostHidden.vbs'
$userId = '{0}\{1}' -f $env:USERDOMAIN, $env:USERNAME

if (-not $SkipFirewallUpdate) {
    $existingRule = Get-NetFirewallRule -DisplayName $firewallRuleName -ErrorAction SilentlyContinue
    if ($existingRule) { $existingRule | Remove-NetFirewallRule }

    New-NetFirewallRule `
        -DisplayName $firewallRuleName `
        -Direction Inbound `
        -Action Allow `
        -Profile Private `
        -Protocol TCP `
        -LocalPort $Port `
        -RemoteAddress $RemoteSubnet | Out-Null
}

if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

$action = New-ScheduledTaskAction -Execute 'C:\WINDOWS\System32\wscript.exe' -Argument "`"$hiddenLauncher`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $userId
$principal = New-ScheduledTaskPrincipal -UserId $userId -LogonType Interactive -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description "Runs the Buy Your Home Dashboard LAN read-only host on ${HostIp}:$Port after sign-in through a hidden launcher with the privilege required to bind the LAN listener."
Register-ScheduledTask -TaskName $taskName -InputObject $task | Out-Null
Start-ScheduledTask -TaskName $taskName

Write-Output "Registered $taskName and firewall rule $firewallRuleName for http://$HostIp`:$Port/"
