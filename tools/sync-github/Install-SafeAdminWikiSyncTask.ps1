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
$scheduleStart = (Get-Date).Date.AddMinutes(1)
$scheduledTrigger = New-ScheduledTaskTrigger -Once -At $scheduleStart -RepetitionInterval (New-TimeSpan -Minutes 15) -RepetitionDuration (New-TimeSpan -Days 3650)
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

[pscustomobject]@{
    task_name = $TaskName
    computer = $env:COMPUTERNAME
    principal = $task.Principal.UserId
    run_level = $task.Principal.RunLevel
    logon_trigger = $true
    interval = $task.Triggers[1].Repetition.Interval
    state = $task.State
} | ConvertTo-Json
