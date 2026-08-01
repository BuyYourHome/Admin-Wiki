[CmdletBinding()]
param(
    [string]$ConfigPath = "C:\Codex\Wiki Files\Project Rooms\Email Monitor\config\workflow-health-registry.json",

    [Parameter(Mandatory = $true)]
    [ValidateSet("Options", "Status", "Enable", "Disable", "Configure", "Test", "TestAlert")]
    [string]$Action,

    [string]$WorkflowId = "All",
    [int]$ExpectedIntervalMinutes,
    [int]$WarningAfterMinutes,
    [int]$CriticalAfterMinutes,
    [int]$WatchdogIntervalMinutes,
    [int]$EvaluationIntervalMinutes,
    [string]$ActiveWindowStart,
    [string]$ActiveWindowEnd,
    [switch]$AllowUnhealthy
)

$ErrorActionPreference = "Stop"

function Read-JsonFile {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
}

function Write-JsonAtomic {
    param([string]$Path, [object]$Value)
    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    $temporaryPath = "$Path.tmp"
    $json = ($Value | ConvertTo-Json -Depth 12) + [Environment]::NewLine
    [System.IO.File]::WriteAllText($temporaryPath, $json, [System.Text.UTF8Encoding]::new($false))
    Move-Item -Force -LiteralPath $temporaryPath -Destination $Path
}

function Get-TaskState {
    param([string]$TaskName)
    $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($null -eq $task) { return "NotInstalled" }
    return [string]$task.State
}

function Assert-TimeValue {
    param([string]$Name, [string]$Value)
    $parsed = [TimeSpan]::Zero
    if (-not [TimeSpan]::TryParseExact($Value, "hh\:mm", $null, [ref]$parsed)) { throw "$Name must use 24-hour HH:mm format." }
}

function Get-WorkflowSummary {
    param([object]$Entry)
    $config = Read-JsonFile -Path $Entry.config_path
    if ($null -eq $config) {
        return [ordered]@{ workflow_id = [string]$Entry.workflow_id; enabled = [bool]$Entry.enabled; configuration_error = "Missing config: $($Entry.config_path)" }
    }
    return [ordered]@{
        workflow = [string]$config.display_name
        workflow_id = [string]$config.workflow_id
        enabled = [bool]$Entry.enabled
        check_type = [string]$config.check_type
        assigned_machine = [string]$config.assigned_machine
        active_window = "$($config.active_window_start)-$($config.active_window_end)"
        polling_interval_minutes = if ($config.polling_interval_minutes) { [int]$config.polling_interval_minutes } else { [int]$config.watchdog_interval_minutes }
        evaluation_interval_minutes = if ($config.evaluation_interval_minutes) { [int]$config.evaluation_interval_minutes } else { [int]$config.watchdog_interval_minutes }
        warning_after_minutes = [int]$config.warning_after_minutes
        critical_after_minutes = [int]$config.critical_after_minutes
        config_path = [string]$Entry.config_path
        health = Read-JsonFile -Path $config.health_file
        watchdog = Read-JsonFile -Path $config.watchdog_state_file
    }
}

$inputPath = (Resolve-Path -LiteralPath $ConfigPath).Path
$inputObject = Read-JsonFile -Path $inputPath
if ($null -eq $inputObject) { throw "Health Check configuration not found: $inputPath" }
if ($null -eq $inputObject.workflows) {
    $legacyWorkflowId = [string]$inputObject.workflow_id
    $registryPath = Join-Path (Split-Path -Parent $inputPath) "workflow-health-registry.json"
    if (-not (Test-Path -LiteralPath $registryPath)) { throw "Shared workflow health registry not found: $registryPath" }
    if ($WorkflowId -eq "All") { $WorkflowId = $legacyWorkflowId }
} else {
    $registryPath = $inputPath
}

$registry = Read-JsonFile -Path $registryPath
if ($env:COMPUTERNAME -ne $registry.assigned_machine) {
    throw "Supervisor is assigned to '$($registry.assigned_machine)', not '$env:COMPUTERNAME'."
}
$selected = if ($WorkflowId -eq "All") { @($registry.workflows) } else { @($registry.workflows | Where-Object { $_.workflow_id -eq $WorkflowId }) }
if (@($selected).Count -eq 0) { throw "Workflow '$WorkflowId' is not registered." }

switch ($Action) {
    "Options" {
        [ordered]@{
            mode = "Health Check"
            scope = "Shared workflow-health supervisor"
            options = @("Options", "Status", "Enable", "Disable", "Configure", "Test", "TestAlert")
            targeting = "Use -WorkflowId <id> for one workflow or -WorkflowId All for Options, Status, Enable, Disable, and Test."
            safeguards = @(
                "Routine healthy checks are diagnostic-only and do not notify.",
                "Warning, critical, and recovery notifications occur only on state transitions.",
                "A failed workflow configuration does not stop evaluation of other registered workflows.",
                "Task rollover is never automatic and requires Wes approval."
            )
            supervisor = [ordered]@{
                task = [string]$registry.scheduled_task_name
                task_state = Get-TaskState -TaskName ([string]$registry.scheduled_task_name)
                assigned_machine = [string]$registry.assigned_machine
                polling_interval_minutes = [int]$registry.polling_interval_minutes
                registry_path = $registryPath
            }
            workflows = @($selected | ForEach-Object { Get-WorkflowSummary -Entry $_ })
        } | ConvertTo-Json -Depth 12
    }
    "Status" {
        [ordered]@{
            supervisor = [ordered]@{
                enabled = [bool]$registry.enabled
                scheduled_task = [string]$registry.scheduled_task_name
                scheduled_task_state = Get-TaskState -TaskName ([string]$registry.scheduled_task_name)
                polling_interval_minutes = [int]$registry.polling_interval_minutes
                state = Read-JsonFile -Path $registry.supervisor_state_file
            }
            workflows = @($selected | ForEach-Object { Get-WorkflowSummary -Entry $_ })
        } | ConvertTo-Json -Depth 12
    }
    "Enable" {
        foreach ($entry in $selected) {
            $entry.enabled = $true
            $config = Read-JsonFile -Path $entry.config_path
            if ($config) { $config.watchdog_enabled = $true; Write-JsonAtomic -Path $entry.config_path -Value $config }
        }
        $registry.enabled = $true
        Write-JsonAtomic -Path $registryPath -Value $registry
        & (Join-Path $PSScriptRoot "Install-CodexWorkflowWatchdog.ps1") -RegistryPath $registryPath | Out-Null
        Enable-ScheduledTask -TaskName ([string]$registry.scheduled_task_name) | Out-Null
        & $PSCommandPath -ConfigPath $registryPath -Action Status -WorkflowId $WorkflowId
    }
    "Disable" {
        foreach ($entry in $selected) {
            if (-not $AllowUnhealthy) {
                $summary = Get-WorkflowSummary -Entry $entry
                if (-not $summary.watchdog -or $summary.watchdog.level -ne "HEALTHY") { throw "Workflow '$($entry.workflow_id)' is not confirmed healthy. Diagnose it or explicitly authorize -AllowUnhealthy before disabling it." }
            }
            $entry.enabled = $false
            $config = Read-JsonFile -Path $entry.config_path
            if ($config) { $config.watchdog_enabled = $false; Write-JsonAtomic -Path $entry.config_path -Value $config }
        }
        if (@($registry.workflows | Where-Object { [bool]$_.enabled }).Count -eq 0) { $registry.enabled = $false }
        Write-JsonAtomic -Path $registryPath -Value $registry
        if (-not [bool]$registry.enabled) {
            $task = Get-ScheduledTask -TaskName ([string]$registry.scheduled_task_name) -ErrorAction SilentlyContinue
            if ($task) { Disable-ScheduledTask -TaskName ([string]$registry.scheduled_task_name) | Out-Null }
        }
        & $PSCommandPath -ConfigPath $registryPath -Action Status -WorkflowId $WorkflowId
    }
    "Configure" {
        if (@($selected).Count -ne 1) { throw "Configure must target one workflow with -WorkflowId." }
        $entry = @($selected)[0]
        if (-not $AllowUnhealthy) {
            $summary = Get-WorkflowSummary -Entry $entry
            if (-not $summary.watchdog -or $summary.watchdog.level -ne "HEALTHY") { throw "Workflow '$($entry.workflow_id)' is not confirmed healthy. Diagnose it or explicitly authorize -AllowUnhealthy before changing configuration." }
        }
        $config = Read-JsonFile -Path $entry.config_path
        if ($ExpectedIntervalMinutes -gt 0) { $config.expected_interval_minutes = $ExpectedIntervalMinutes }
        if ($WarningAfterMinutes -gt 0) { $config.warning_after_minutes = $WarningAfterMinutes }
        if ($CriticalAfterMinutes -gt 0) { $config.critical_after_minutes = $CriticalAfterMinutes }
        if ($EvaluationIntervalMinutes -gt 0) { $config.evaluation_interval_minutes = $EvaluationIntervalMinutes }
        if ($WatchdogIntervalMinutes -gt 0) { $config.polling_interval_minutes = $WatchdogIntervalMinutes; $config.watchdog_interval_minutes = $WatchdogIntervalMinutes }
        if ($ActiveWindowStart) { Assert-TimeValue -Name "ActiveWindowStart" -Value $ActiveWindowStart; $config.active_window_start = $ActiveWindowStart }
        if ($ActiveWindowEnd) { Assert-TimeValue -Name "ActiveWindowEnd" -Value $ActiveWindowEnd; $config.active_window_end = $ActiveWindowEnd }
        if ($config.expected_interval_minutes -and [int]$config.warning_after_minutes -le [int]$config.expected_interval_minutes) { throw "WarningAfterMinutes must be greater than ExpectedIntervalMinutes." }
        if ([int]$config.critical_after_minutes -le [int]$config.warning_after_minutes) { throw "CriticalAfterMinutes must be greater than WarningAfterMinutes." }
        if ([int]$config.polling_interval_minutes -ge [int]$config.warning_after_minutes) { throw "WatchdogIntervalMinutes must be less than WarningAfterMinutes." }
        Write-JsonAtomic -Path $entry.config_path -Value $config
        $enabledConfigs = @($registry.workflows | Where-Object { [bool]$_.enabled } | ForEach-Object { Read-JsonFile -Path $_.config_path })
        $registry.polling_interval_minutes = [int](($enabledConfigs | ForEach-Object { if ($_.polling_interval_minutes) { [int]$_.polling_interval_minutes } else { [int]$_.watchdog_interval_minutes } } | Measure-Object -Minimum).Minimum)
        Write-JsonAtomic -Path $registryPath -Value $registry
        & (Join-Path $PSScriptRoot "Install-CodexWorkflowWatchdog.ps1") -RegistryPath $registryPath | Out-Null
        & $PSCommandPath -ConfigPath $registryPath -Action Status -WorkflowId $WorkflowId
    }
    "Test" {
        $arguments = @{ RegistryPath = $registryPath; TestOnly = $true; ForceEvaluation = $true }
        if ($WorkflowId -ne "All") { $arguments.WorkflowId = $WorkflowId }
        & ([string]$registry.supervisor_script) @arguments
    }
    "TestAlert" {
        if (@($selected).Count -ne 1) { throw "TestAlert must target one workflow with -WorkflowId." }
        & ([string]$registry.supervisor_script) -RegistryPath $registryPath -WorkflowId ([string](@($selected)[0].workflow_id)) -TestAlert
    }
}
