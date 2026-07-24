[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Options", "Status", "Enable", "Disable", "Configure", "Test", "TestAlert")]
    [string]$Action,

    [int]$ExpectedIntervalMinutes,
    [int]$WarningAfterMinutes,
    [int]$CriticalAfterMinutes,
    [int]$WatchdogIntervalMinutes,
    [string]$ActiveWindowStart,
    [string]$ActiveWindowEnd,
    [switch]$AllowUnhealthy
)

$ErrorActionPreference = "Stop"

function Read-JsonFile {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
}

function Write-JsonAtomic {
    param(
        [string]$Path,
        [object]$Value
    )

    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    $temporaryPath = "$Path.tmp"
    $jsonLines = ($Value | ConvertTo-Json -Depth 8) -split "\r?\n" | ForEach-Object {
        if ($_ -match '^(\s+)(.*)$') {
            (' ' * ([int]($matches[1].Length / 2))) + $matches[2]
        } else {
            $_
        }
    }
    $json = (($jsonLines -join [Environment]::NewLine) -replace '":  ', '": ') + [Environment]::NewLine
    [System.IO.File]::WriteAllText($temporaryPath, $json, [System.Text.UTF8Encoding]::new($false))
    Move-Item -Force -LiteralPath $temporaryPath -Destination $Path
}

function Get-TaskState {
    param([string]$TaskName)

    $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($null -eq $task) {
        return "NotInstalled"
    }

    return [string]$task.State
}

function Get-HealthSummary {
    param([object]$Config)

    $health = Read-JsonFile -Path $Config.health_file
    if ($null -eq $health) {
        return [ordered]@{
            healthy = $false
            reason = "Health state is missing."
            state = $null
        }
    }

    $referenceValue = if ($health.last_success_at_utc) {
        $health.last_success_at_utc
    } elseif ($health.run_completed_at_utc) {
        $health.run_completed_at_utc
    } else {
        $null
    }
    $ageMinutes = if ($referenceValue) {
        ([DateTime]::UtcNow - [DateTime]::Parse([string]$referenceValue).ToUniversalTime()).TotalMinutes
    } else {
        [double]::PositiveInfinity
    }
    $healthy = $health.status -ne "failed" -and $ageMinutes -le [double]$Config.warning_after_minutes
    $reason = if ($health.status -eq "failed") {
        "The latest heartbeat reported failure."
    } elseif ([double]::IsPositiveInfinity($ageMinutes)) {
        "No completed heartbeat is recorded."
    } elseif (-not $healthy) {
        "The last successful heartbeat is $([math]::Round($ageMinutes)) minutes old."
    } else {
        "The last successful heartbeat is $([math]::Round($ageMinutes, 1)) minutes old."
    }

    return [ordered]@{
        healthy = $healthy
        reason = $reason
        age_minutes = if ([double]::IsPositiveInfinity($ageMinutes)) { $null } else { [math]::Round($ageMinutes, 2) }
        state = $health
    }
}

function Assert-LocalAssignment {
    param([object]$Config)

    if ($env:COMPUTERNAME -ne $Config.assigned_machine) {
        throw "Workflow '$($Config.workflow_id)' is assigned to '$($Config.assigned_machine)', not '$env:COMPUTERNAME'. Machine reassignment requires destination-machine verification before changing this config."
    }
}

function Assert-HealthyForChange {
    param(
        [object]$Config,
        [switch]$Override
    )

    if ($Override) {
        return
    }

    $summary = Get-HealthSummary -Config $Config
    if (-not $summary.healthy) {
        throw "Health Check configuration was not changed because the workflow is unhealthy: $($summary.reason) Diagnose or explicitly authorize the AllowUnhealthy override."
    }
}

function Assert-TimeValue {
    param(
        [string]$Name,
        [string]$Value
    )

    $parsed = [TimeSpan]::Zero
    if (-not [TimeSpan]::TryParseExact($Value, "hh\:mm", $null, [ref]$parsed)) {
        throw "$Name must use 24-hour HH:mm format."
    }
}

$ConfigPath = (Resolve-Path -LiteralPath $ConfigPath).Path
$config = Read-JsonFile -Path $ConfigPath
if ($null -eq $config) {
    throw "Health Check config not found: $ConfigPath"
}
if ($null -eq $config.watchdog_enabled) {
    $config | Add-Member -NotePropertyName watchdog_enabled -NotePropertyValue $true
}

$healthSummary = Get-HealthSummary -Config $config
$effective = [ordered]@{
    workflow = [string]$config.display_name
    workflow_id = [string]$config.workflow_id
    assigned_machine = [string]$config.assigned_machine
    watchdog_enabled = [bool]$config.watchdog_enabled
    scheduled_task = [string]$config.scheduled_task_name
    scheduled_task_state = Get-TaskState -TaskName ([string]$config.scheduled_task_name)
    active_window = "$($config.active_window_start)-$($config.active_window_end)"
    expected_interval_minutes = [int]$config.expected_interval_minutes
    watchdog_interval_minutes = [int]$config.watchdog_interval_minutes
    warning_after_minutes = [int]$config.warning_after_minutes
    critical_after_minutes = [int]$config.critical_after_minutes
    workflow_healthy = [bool]$healthSummary.healthy
    health_reason = [string]$healthSummary.reason
}

switch ($Action) {
    "Options" {
        [ordered]@{
            mode = "Health Check"
            options = @(
                "Show options",
                "Show current status and configuration",
                "Enable the watchdog",
                "Disable the watchdog",
                "Change the expected heartbeat interval",
                "Change the watchdog polling interval",
                "Change warning and critical thresholds",
                "Change the active monitoring window",
                "Run a non-notifying diagnostic test",
                "Send a visible test alert",
                "Move monitoring to another machine (guided; destination verification required)"
            )
            examples = @(
                "Health Check, what are my options?",
                "Health Check, show the current status.",
                "Health Check, turn the watchdog off.",
                "Health Check, run every 5 minutes.",
                "Health Check, warn after 45 minutes and go critical after 75 minutes.",
                "Health Check, test the watchdog.",
                "Health Check, send a test alert."
            )
            safeguards = @(
                "Configuration changes require a healthy workflow unless Wes explicitly authorizes an unhealthy override.",
                "Disabling monitoring leaves heartbeat health-state updates active but stops independent watchdog alerts.",
                "Machine reassignment is not applied until the destination machine and its scheduled task are verified."
            )
            current = $effective
        } | ConvertTo-Json -Depth 8
        break
    }
    "Status" {
        [ordered]@{
            current = $effective
            health = $healthSummary.state
            watchdog = Read-JsonFile -Path $config.watchdog_state_file
        } | ConvertTo-Json -Depth 8
        break
    }
    "Enable" {
        Assert-LocalAssignment -Config $config
        $config.watchdog_enabled = $true
        Write-JsonAtomic -Path $ConfigPath -Value $config
        & (Join-Path $PSScriptRoot "Install-CodexWorkflowWatchdog.ps1") -ConfigPath $ConfigPath | Out-Null
        Enable-ScheduledTask -TaskName ([string]$config.scheduled_task_name) | Out-Null
        & $PSCommandPath -ConfigPath $ConfigPath -Action Status
        break
    }
    "Disable" {
        Assert-LocalAssignment -Config $config
        Assert-HealthyForChange -Config $config -Override:$AllowUnhealthy
        $task = Get-ScheduledTask -TaskName ([string]$config.scheduled_task_name) -ErrorAction SilentlyContinue
        if ($null -ne $task) {
            Disable-ScheduledTask -TaskName ([string]$config.scheduled_task_name) | Out-Null
        }
        $config.watchdog_enabled = $false
        Write-JsonAtomic -Path $ConfigPath -Value $config
        & $PSCommandPath -ConfigPath $ConfigPath -Action Status
        break
    }
    "Configure" {
        Assert-LocalAssignment -Config $config
        Assert-HealthyForChange -Config $config -Override:$AllowUnhealthy

        if ($ExpectedIntervalMinutes -gt 0) { $config.expected_interval_minutes = $ExpectedIntervalMinutes }
        if ($WarningAfterMinutes -gt 0) { $config.warning_after_minutes = $WarningAfterMinutes }
        if ($CriticalAfterMinutes -gt 0) { $config.critical_after_minutes = $CriticalAfterMinutes }
        if ($WatchdogIntervalMinutes -gt 0) { $config.watchdog_interval_minutes = $WatchdogIntervalMinutes }
        if ($ActiveWindowStart) {
            Assert-TimeValue -Name "ActiveWindowStart" -Value $ActiveWindowStart
            $config.active_window_start = $ActiveWindowStart
        }
        if ($ActiveWindowEnd) {
            Assert-TimeValue -Name "ActiveWindowEnd" -Value $ActiveWindowEnd
            $config.active_window_end = $ActiveWindowEnd
        }

        if ([int]$config.warning_after_minutes -le [int]$config.expected_interval_minutes) {
            throw "WarningAfterMinutes must be greater than ExpectedIntervalMinutes."
        }
        if ([int]$config.critical_after_minutes -le [int]$config.warning_after_minutes) {
            throw "CriticalAfterMinutes must be greater than WarningAfterMinutes."
        }
        if ([int]$config.watchdog_interval_minutes -ge [int]$config.warning_after_minutes) {
            throw "WatchdogIntervalMinutes must be less than WarningAfterMinutes."
        }

        Write-JsonAtomic -Path $ConfigPath -Value $config
        if ([bool]$config.watchdog_enabled) {
            & (Join-Path $PSScriptRoot "Install-CodexWorkflowWatchdog.ps1") -ConfigPath $ConfigPath | Out-Null
        }
        & $PSCommandPath -ConfigPath $ConfigPath -Action Status
        break
    }
    "Test" {
        Assert-LocalAssignment -Config $config
        & (Join-Path $PSScriptRoot "Invoke-CodexWorkflowWatchdog.ps1") -ConfigPath $ConfigPath -TestOnly
        break
    }
    "TestAlert" {
        Assert-LocalAssignment -Config $config
        & (Join-Path $PSScriptRoot "Invoke-CodexWorkflowWatchdog.ps1") -ConfigPath $ConfigPath -TestAlert
        break
    }
}
