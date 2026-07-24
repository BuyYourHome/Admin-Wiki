[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath
)

$ErrorActionPreference = "Stop"

$config = Get-Content -Raw -LiteralPath $ConfigPath | ConvertFrom-Json
if ($env:COMPUTERNAME -ne $config.assigned_machine) {
    throw "Workflow '$($config.workflow_id)' is assigned to '$($config.assigned_machine)', not '$env:COMPUTERNAME'."
}

$watchdogPath = Join-Path $PSScriptRoot "Invoke-CodexWorkflowWatchdog.ps1"
$arguments = "-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$watchdogPath`" -ConfigPath `"$ConfigPath`""
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arguments
$trigger = New-ScheduledTaskTrigger `
    -Once `
    -At ((Get-Date).AddMinutes(1)) `
    -RepetitionInterval (New-TimeSpan -Minutes ([int]$config.watchdog_interval_minutes)) `
    -RepetitionDuration (New-TimeSpan -Days 3650)
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -MultipleInstances IgnoreNew `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 5)
$principal = New-ScheduledTaskPrincipal `
    -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) `
    -LogonType Interactive `
    -RunLevel Limited

Register-ScheduledTask `
    -TaskName ([string]$config.scheduled_task_name) `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Principal $principal `
    -Description "Monitors the $($config.display_name) Codex workflow health state on $($config.assigned_machine)." `
    -Force | Out-Null

if ($null -ne $config.watchdog_enabled -and -not [bool]$config.watchdog_enabled) {
    Disable-ScheduledTask -TaskName ([string]$config.scheduled_task_name) | Out-Null
}

Get-ScheduledTask -TaskName ([string]$config.scheduled_task_name) |
    Select-Object TaskName, State, Author, Description
