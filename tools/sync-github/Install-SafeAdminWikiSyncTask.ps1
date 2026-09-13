[CmdletBinding()]
param(
    [string]$TaskName = 'BuyYourHome-SyncGithub',
    [string]$RepositoryPath = 'C:\Codex\Wiki Files',
    [string]$ExpectedComputer = 'OFFICEASSIST',
    [string]$ExpectedUser = 'OfficeAssistLogin'
)

$ErrorActionPreference = 'Stop'

if ($env:COMPUTERNAME -ne $ExpectedComputer) {
    throw "Wrong computer: $env:COMPUTERNAME"
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent().Name
$userName = $identity.Split('\\')[-1]
if ($userName -ne $ExpectedUser) {
    throw "Wrong Windows user: $identity"
}

$repository = [IO.Path]::GetFullPath($RepositoryPath).TrimEnd('\\')
$syncScript = Join-Path $repository 'tools\sync-github\Invoke-SafeAdminWikiSync.ps1'
if (-not (Test-Path -LiteralPath $syncScript -PathType Leaf)) {
    throw "Safe-sync script is missing: $syncScript"
}

$actionArguments = '-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "{0}"' -f $syncScript
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $actionArguments -WorkingDirectory $repository
$logonTrigger = New-ScheduledTaskTrigger -AtLogOn -User $identity
$scheduledTrigger = New-ScheduledTaskTrigger -Daily -At '5:30 AM'
$principal = New-ScheduledTaskPrincipal -UserId $identity -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 10) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger @($logonTrigger, $scheduledTrigger) -Principal $principal -Settings $settings -Description 'Safely fetches and fast-forwards the Buy Your Home Admin Wiki. Never commits, pushes, merges, rebases, resets, stashes, cleans, or discards work.' -Force | Out-Null

$task = Get-ScheduledTask -TaskName $TaskName
if ($task.Principal.UserId.Split('\\')[-1] -ne $ExpectedUser -or $task.Principal.RunLevel -ne 'Limited') {
    throw "Scheduled-task principal verification failed: $($task.Principal.UserId), $($task.Principal.RunLevel)"
}
if ($task.Triggers.Count -ne 2) {
    throw "Scheduled-task trigger verification failed: expected 2, found $($task.Triggers.Count)"
}
$installedLogonTrigger = @($task.Triggers | Where-Object { $_.CimClass.CimClassName -eq 'MSFT_TaskLogonTrigger' })
$installedDailyTrigger = @($task.Triggers | Where-Object { $_.CimClass.CimClassName -eq 'MSFT_TaskDailyTrigger' })
if ($installedLogonTrigger.Count -ne 1 -or $installedLogonTrigger[0].UserId.Split('\\')[-1] -ne $ExpectedUser) {
    throw 'Scheduled-task logon-trigger verification failed.'
}
if ($installedDailyTrigger.Count -ne 1) {
    throw 'Scheduled-task daily-trigger verification failed.'
}
$dailyStart = [datetime]$installedDailyTrigger[0].StartBoundary
if ($installedDailyTrigger[0].DaysInterval -ne 1 -or $dailyStart.Hour -ne 5 -or $dailyStart.Minute -ne 30 -or $installedDailyTrigger[0].Repetition.Interval) {
    throw 'Scheduled-task daily-trigger verification failed.'
}

[pscustomobject]@{
    task_name = $TaskName
    computer = $env:COMPUTERNAME
    principal = $task.Principal.UserId
    run_level = $task.Principal.RunLevel
    logon_trigger = $true
    daily_start = $dailyStart.ToString('o')
    state = $task.State
} | ConvertTo-Json
