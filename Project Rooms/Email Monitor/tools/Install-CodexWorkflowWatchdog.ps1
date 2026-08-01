[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [Alias("ConfigPath")]
    [string]$RegistryPath
)

$ErrorActionPreference = "Stop"

$inputPath = (Resolve-Path -LiteralPath $RegistryPath).Path
$inputObject = Get-Content -Raw -LiteralPath $inputPath | ConvertFrom-Json
if ($null -eq $inputObject.workflows) {
    $RegistryPath = Join-Path (Split-Path -Parent $inputPath) "workflow-health-registry.json"
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        throw "Shared workflow health registry was not found beside legacy config: $RegistryPath"
    }
} else {
    $RegistryPath = $inputPath
}

$registry = Get-Content -Raw -LiteralPath $RegistryPath | ConvertFrom-Json
if ($env:COMPUTERNAME -ne $registry.assigned_machine) {
    throw "Supervisor is assigned to '$($registry.assigned_machine)', not '$env:COMPUTERNAME'."
}

$supervisorPath = [string]$registry.supervisor_script
$arguments = "-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$supervisorPath`" -RegistryPath `"$RegistryPath`""
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arguments
$trigger = New-ScheduledTaskTrigger `
    -Once `
    -At ((Get-Date).AddMinutes(1)) `
    -RepetitionInterval (New-TimeSpan -Minutes ([int]$registry.polling_interval_minutes)) `
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
    -TaskName ([string]$registry.scheduled_task_name) `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Principal $principal `
    -Description "Runs the shared Codex workflow-health supervisor on $($registry.assigned_machine)." `
    -Force | Out-Null

if (-not [bool]$registry.enabled -or @($registry.workflows | Where-Object { [bool]$_.enabled }).Count -eq 0) {
    Disable-ScheduledTask -TaskName ([string]$registry.scheduled_task_name) | Out-Null
}

Get-ScheduledTask -TaskName ([string]$registry.scheduled_task_name) |
    Select-Object TaskName, State, Author, Description
