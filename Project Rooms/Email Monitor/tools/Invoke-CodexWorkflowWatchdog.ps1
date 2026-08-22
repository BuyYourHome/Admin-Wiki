[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath,

    [switch]$TestOnly,
    [switch]$TestAlert,
    [switch]$ForceEvaluation
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
    $Value | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $temporaryPath -Encoding UTF8
    Move-Item -Force -LiteralPath $temporaryPath -Destination $Path
}

function Write-WatchdogLog {
    param([object]$Config, [string]$Message)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Config.watchdog_log_file) | Out-Null
    Add-Content -LiteralPath $Config.watchdog_log_file -Encoding UTF8 -Value ("{0}`t{1}" -f [DateTime]::UtcNow.ToString("o"), $Message)
}

function Show-WindowsToast {
    param([object]$Config, [string]$Title, [string]$Message)
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
    $escapedTitle = [System.Security.SecurityElement]::Escape($Title)
    $escapedMessage = [System.Security.SecurityElement]::Escape($Message)
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml("<toast><visual><binding template='ToastGeneric'><text>$escapedTitle</text><text>$escapedMessage</text></binding></visual></toast>")
    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier([string]$Config.toast_app_id).Show($toast)
}

function Publish-Alert {
    param([object]$Config, [string]$Level, [string]$Message, [switch]$SuppressNotification)
    $title = "Codex $($Config.display_name) Health: $Level"
    $alert = "{0}`r`n{1}`r`nUTC: {2}" -f $title, $Message, [DateTime]::UtcNow.ToString("o")
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Config.current_alert_file) | Out-Null
    Set-Content -LiteralPath $Config.current_alert_file -Value $alert -Encoding UTF8
    Write-WatchdogLog -Config $Config -Message "Alert transition: $Level - $Message"
    if ($SuppressNotification) { return }
    try { Show-WindowsToast -Config $Config -Title $title -Message $Message } catch { Write-WatchdogLog -Config $Config -Message "Toast failed: $($_.Exception.Message)" }
    try {
        $entryType = if ($Level -eq "CRITICAL") { "Error" } elseif ($Level -eq "WARNING") { "Warning" } else { "Information" }
        Write-EventLog -LogName Application -Source "Windows PowerShell" -EntryType $entryType -EventId 4101 -Message $alert
    } catch { Write-WatchdogLog -Config $Config -Message "Event Log write failed: $($_.Exception.Message)" }
}

function Test-WithinActiveWindow {
    param([object]$Config, [datetime]$Now)
    $start = [TimeSpan]::Parse([string]$Config.active_window_start)
    $end = [TimeSpan]::Parse([string]$Config.active_window_end)
    if ($start -le $end) { return $Now.TimeOfDay -ge $start -and $Now.TimeOfDay -le $end }
    return $Now.TimeOfDay -ge $start -or $Now.TimeOfDay -le $end
}

function Get-MarkdownField {
    param([string]$Content, [string]$Name)
    $pattern = '(?im)^\s*-\s*' + [regex]::Escape($Name) + ':\s*`?([^`\r\n]+?)`?\s*$'
    $match = [regex]::Match($Content, $pattern)
    if (-not $match.Success) { return $null }
    return $match.Groups[1].Value.Trim()
}

function ConvertTo-OptionalInt {
    param([string]$Value)
    if (-not $Value -or $Value -match '^(unavailable|unknown|none)$') { return $null }
    $parsed = 0
    if ([int]::TryParse($Value, [ref]$parsed)) { return $parsed }
    return $null
}

function ConvertTo-StatusBool {
    param([string]$Value)
    if (-not $Value) { return $null }
    if ($Value -match '^(yes|true)$') { return $true }
    if ($Value -match '^(no|false|none)$') { return $false }
    return $null
}

function ConvertTo-UtcDateTime {
    param([object]$Value)
    if ($Value -is [DateTime]) {
        return ([DateTime]$Value).ToUniversalTime()
    }
    return [DateTimeOffset]::Parse(
        [string]$Value,
        [Globalization.CultureInfo]::InvariantCulture,
        [Globalization.DateTimeStyles]::RoundtripKind
    ).UtcDateTime
}

function Evaluate-Heartbeat {
    param([object]$Config, [datetime]$NowUtc)
    $health = Read-JsonFile -Path $Config.health_file
    $ageMinutes = [double]::PositiveInfinity
    $level = "CRITICAL"
    $reason = "Health state is missing."
    if ($null -ne $health) {
        $referenceValue = if ($health.status -eq "running" -and $health.run_started_at_utc) { $health.run_started_at_utc } elseif ($health.run_completed_at_utc) { $health.run_completed_at_utc } elseif ($health.last_update_at_utc) { $health.last_update_at_utc } else { $null }
        if ($referenceValue) {
            $ageMinutes = ($NowUtc - (ConvertTo-UtcDateTime -Value $referenceValue)).TotalMinutes
            if ($health.status -eq "failed") {
                $level = if ([int]$health.consecutive_failures -ge 3) { "CRITICAL" } else { "WARNING" }
                $reason = "Heartbeat reported failure at '$($health.failure_stage)': $($health.failure_message)"
            } elseif ($ageMinutes -gt [double]$Config.critical_after_minutes) {
                $level = "CRITICAL"; $reason = "No completed heartbeat for $([math]::Round($ageMinutes)) minutes; last status is '$($health.status)'."
            } elseif ($ageMinutes -gt [double]$Config.warning_after_minutes) {
                $level = "WARNING"; $reason = "No completed heartbeat for $([math]::Round($ageMinutes)) minutes; last status is '$($health.status)'."
            } else {
                $level = "HEALTHY"; $reason = "Last heartbeat state is '$($health.status)' and $([math]::Round($ageMinutes)) minutes old."
            }
        }
    }
    return [ordered]@{
        level = $level
        reason = $reason
        age_minutes = if ([double]::IsPositiveInfinity($ageMinutes)) { $null } else { [math]::Round($ageMinutes, 2) }
        substantive_evaluation = $true
        health_snapshot = $health
    }
}

function Evaluate-ProjectRoomTask {
    param([object]$Config, [datetime]$NowUtc)
    $signals = [System.Collections.Generic.List[string]]::new()
    $reviewTriggers = [System.Collections.Generic.List[string]]::new()
    $level = "HEALTHY"
    $statusPath = [string]$Config.work_status_file
    if (-not (Test-Path -LiteralPath $statusPath)) {
        return [ordered]@{ level = "CRITICAL"; reason = "Canonical work-status.md is missing."; age_minutes = $null; substantive_evaluation = $true; metrics = $null; health_snapshot = $null }
    }

    $item = Get-Item -LiteralPath $statusPath
    $ageMinutes = ($NowUtc - $item.LastWriteTimeUtc).TotalMinutes
    $content = Get-Content -Raw -LiteralPath $statusPath
    if ($ageMinutes -gt [double]$Config.critical_after_minutes) { $level = "CRITICAL"; $signals.Add("work-status.md is $([math]::Round($ageMinutes)) minutes old") }
    elseif ($ageMinutes -gt [double]$Config.warning_after_minutes) { $level = "WARNING"; $signals.Add("work-status.md is $([math]::Round($ageMinutes)) minutes old") }

    $operationInFlight = ConvertTo-StatusBool (Get-MarkdownField -Content $content -Name "Operation in flight")
    $operationStarted = Get-MarkdownField -Content $content -Name "Operation started at UTC"
    if ($operationInFlight -eq $true) {
        if ($operationStarted -and $operationStarted -notmatch '^(none|unavailable)$') {
            $operationAge = ($NowUtc - (ConvertTo-UtcDateTime -Value $operationStarted)).TotalMinutes
            if ($operationAge -gt [double]$Config.operation_critical_after_minutes) { $level = "CRITICAL"; $signals.Add("operation has remained in flight for $([math]::Round($operationAge)) minutes") }
            elseif ($operationAge -gt [double]$Config.operation_warning_after_minutes -and $level -ne "CRITICAL") { $level = "WARNING"; $signals.Add("operation has remained in flight for $([math]::Round($operationAge)) minutes") }
        } elseif ($level -ne "CRITICAL") { $level = "WARNING"; $signals.Add("operation is in flight but its start time is unavailable") }
    }

    $timeouts = ConvertTo-OptionalInt (Get-MarkdownField -Content $content -Name "Recent task timeouts")
    $stalls = ConvertTo-OptionalInt (Get-MarkdownField -Content $content -Name "Recent stalled final responses")
    $duplicates = ConvertTo-OptionalInt (Get-MarkdownField -Content $content -Name "Recent duplicate external-action attempts")
    if ($timeouts -ge 3 -or $stalls -ge 2 -or $duplicates -ge 1) { $level = "CRITICAL" }
    elseif (($timeouts -gt 0 -or $stalls -gt 0) -and $level -eq "HEALTHY") { $level = "WARNING" }
    if ($timeouts -gt 0) { $signals.Add("$timeouts recent task timeout(s)") }
    if ($stalls -gt 0) { $signals.Add("$stalls recent stalled final response(s)") }
    if ($duplicates -gt 0) { $signals.Add("$duplicates duplicate external-action attempt(s)") }

    $turns = ConvertTo-OptionalInt (Get-MarkdownField -Content $content -Name "Task turns observed")
    $compactions = ConvertTo-OptionalInt (Get-MarkdownField -Content $content -Name "Context compactions observed")
    if ($null -ne $turns -and $turns -gt [int]$Config.turn_review_threshold) { $reviewTriggers.Add("turn review threshold exceeded: $turns") }
    if ($null -ne $compactions -and $compactions -ge [int]$Config.compaction_review_threshold) { $reviewTriggers.Add("compaction review threshold reached: $compactions") }

    $gitClassified = ConvertTo-StatusBool (Get-MarkdownField -Content $content -Name "Git and working-file state classified")
    $projectRelative = [string]$Config.project_room
    if ($projectRelative.StartsWith([string]$Config.repository_root, [StringComparison]::OrdinalIgnoreCase)) {
        $projectRelative = $projectRelative.Substring(([string]$Config.repository_root).Length).TrimStart('\')
    }
    $gitChanges = @(& git -C ([string]$Config.repository_root) status --porcelain -- $projectRelative 2>$null)
    if ($gitChanges.Count -gt 0 -and $gitClassified -ne $true) {
        if ($level -eq "HEALTHY") { $level = "WARNING" }
        $signals.Add("$($gitChanges.Count) Invoice Entry Git path(s) are uncommitted and not classified")
    }

    $durable = ConvertTo-StatusBool (Get-MarkdownField -Content $content -Name "Current work durably recorded")
    $delivery = ConvertTo-StatusBool (Get-MarkdownField -Content $content -Name "External delivery evidence recorded")
    $packets = ConvertTo-StatusBool (Get-MarkdownField -Content $content -Name "Open packets and blockers current")
    $rolloverReady = $operationInFlight -eq $false -and $durable -eq $true -and $delivery -eq $true -and $packets -eq $true -and $gitClassified -eq $true
    $reliabilitySignals = ($timeouts -gt 0) -or ($stalls -gt 0) -or ($duplicates -gt 0) -or ($ageMinutes -gt [double]$Config.warning_after_minutes)
    $rolloverRecommended = $reviewTriggers.Count -ge 2 -and $reliabilitySignals
    if ($rolloverRecommended -and $level -eq "HEALTHY") { $level = "WARNING" }
    if ($rolloverRecommended) { $signals.Add("controlled rollover review recommended; Wes approval required") }

    $metrics = [ordered]@{
        task_id = [string]$Config.task_id
        task_turns = $turns
        task_turns_available = $null -ne $turns
        context_compactions = $compactions
        context_compactions_available = $null -ne $compactions
        recent_task_timeouts = $timeouts
        recent_stalled_final_responses = $stalls
        recent_duplicate_external_action_attempts = $duplicates
        operation_in_flight = $operationInFlight
        uncommitted_project_room_paths = $gitChanges.Count
        git_state_classified = $gitClassified
        review_triggers = @($reviewTriggers)
        rollover_recommended = $rolloverRecommended
        rollover_ready = $rolloverReady
        actual_rollover_requires_wes_approval = $true
    }
    $reason = if ($signals.Count -gt 0) { $signals -join "; " } else { "Project Room status is current and no reliability signal requires attention." }
    $snapshot = [ordered]@{
        schema_version = 1
        workflow_id = [string]$Config.workflow_id
        status = $level.ToLowerInvariant()
        evaluated_at_utc = $NowUtc.ToString("o")
        work_status_last_write_at_utc = $item.LastWriteTimeUtc.ToString("o")
        reason = $reason
        metrics = $metrics
    }
    Write-JsonAtomic -Path $Config.health_file -Value $snapshot
    return [ordered]@{ level = $level; reason = $reason; age_minutes = [math]::Round($ageMinutes, 2); substantive_evaluation = $true; metrics = $metrics; health_snapshot = $snapshot }
}

$ConfigPath = (Resolve-Path -LiteralPath $ConfigPath).Path
$config = Read-JsonFile -Path $ConfigPath
if ($null -eq $config) { throw "Health Check config not found: $ConfigPath" }
if ($env:COMPUTERNAME -ne $config.assigned_machine) {
    Write-WatchdogLog -Config $config -Message "Skipped: assigned to $($config.assigned_machine), running on $env:COMPUTERNAME."
    [ordered]@{ workflow_id = [string]$config.workflow_id; level = "SKIPPED"; status = "WRONG_MACHINE" } | ConvertTo-Json
    exit 0
}
if ($TestAlert) {
    Publish-Alert -Config $config -Level "TEST" -Message "This is a Health Check test alert. Workflow health was not changed."
    if (Test-Path -LiteralPath $config.current_alert_file) { Remove-Item -LiteralPath $config.current_alert_file -Force }
    [ordered]@{ workflow_id = [string]$config.workflow_id; level = "TEST"; status = "TEST_ALERT_SENT"; health_changed = $false; evaluated_at_utc = [DateTime]::UtcNow.ToString("o") } | ConvertTo-Json
    exit 0
}

$nowLocal = Get-Date
$nowUtc = [DateTime]::UtcNow
if (-not (Test-WithinActiveWindow -Config $config -Now $nowLocal)) {
    Write-WatchdogLog -Config $config -Message "Outside active window; no evaluation."
    [ordered]@{ workflow_id = [string]$config.workflow_id; level = "SKIPPED"; status = "OUTSIDE_ACTIVE_WINDOW" } | ConvertTo-Json
    exit 0
}

$previousState = Read-JsonFile -Path $config.watchdog_state_file
$checkType = if ($config.check_type) { [string]$config.check_type } else { "heartbeat_liveness" }
if ($checkType -eq "project_room_task_health" -and -not $ForceEvaluation) {
    $lastSubstantive = if ($previousState -and $previousState.substantive_evaluated_at_utc) { ConvertTo-UtcDateTime -Value $previousState.substantive_evaluated_at_utc } else { $null }
    $due = $null -eq $lastSubstantive -or ($nowUtc - $lastSubstantive).TotalMinutes -ge [double]$config.evaluation_interval_minutes
    $statusContent = if (Test-Path -LiteralPath $config.work_status_file) { Get-Content -Raw -LiteralPath $config.work_status_file } else { "" }
    $operationActive = ConvertTo-StatusBool (Get-MarkdownField -Content $statusContent -Name "Operation in flight")
    $explicitFollowUp = ConvertTo-StatusBool (Get-MarkdownField -Content $statusContent -Name "Health follow-up required")
    $followUp = $operationActive -eq $true -or $explicitFollowUp -eq $true -or ($previousState -and $previousState.level -eq "CRITICAL")
    if (-not $due -and -not $followUp) {
        Write-WatchdogLog -Config $config -Message "Skipped substantive evaluation: next daily evaluation is not due."
        [ordered]@{ workflow_id = [string]$config.workflow_id; level = [string]$previousState.level; status = "SKIPPED_NOT_DUE"; substantive_evaluation = $false; last_substantive_evaluation_at_utc = [string]$previousState.substantive_evaluated_at_utc } | ConvertTo-Json
        exit 0
    }
}

$evaluation = if ($checkType -eq "project_room_task_health") { Evaluate-ProjectRoomTask -Config $config -NowUtc $nowUtc } else { Evaluate-Heartbeat -Config $config -NowUtc $nowUtc }
$level = [string]$evaluation.level
$previousLevel = if ($previousState) { [string]$previousState.level } else { "UNKNOWN" }
$stateChanged = $previousLevel -ne $level
$state = [ordered]@{
    schema_version = 2
    workflow_id = [string]$config.workflow_id
    check_type = $checkType
    assigned_machine = [string]$config.assigned_machine
    observed_machine = [string]$env:COMPUTERNAME
    level = $level
    previous_level = $previousLevel
    reason = [string]$evaluation.reason
    evaluated_at_utc = $nowUtc.ToString("o")
    substantive_evaluated_at_utc = $nowUtc.ToString("o")
    age_minutes = $evaluation.age_minutes
    metrics = $evaluation.metrics
}
Write-JsonAtomic -Path $config.watchdog_state_file -Value $state
Write-WatchdogLog -Config $config -Message "Evaluation: $level - $($evaluation.reason)"

if ($stateChanged -and $level -ne "HEALTHY") {
    Publish-Alert -Config $config -Level $level -Message ([string]$evaluation.reason) -SuppressNotification:$TestOnly
} elseif ($stateChanged -and $level -eq "HEALTHY" -and $previousLevel -in @("WARNING", "CRITICAL")) {
    Publish-Alert -Config $config -Level "RECOVERED" -Message ([string]$evaluation.reason) -SuppressNotification:$TestOnly
    if (Test-Path -LiteralPath $config.current_alert_file) { Remove-Item -LiteralPath $config.current_alert_file -Force }
} elseif ($level -eq "HEALTHY" -and (Test-Path -LiteralPath $config.current_alert_file)) {
    Remove-Item -LiteralPath $config.current_alert_file -Force
}

[ordered]@{
    workflow_id = [string]$config.workflow_id
    display_name = [string]$config.display_name
    level = $level
    status = "EVALUATED"
    state_changed = $stateChanged
    notification_emitted = $stateChanged -and ($level -ne "HEALTHY" -or $previousLevel -in @("WARNING", "CRITICAL")) -and -not $TestOnly
    reason = [string]$evaluation.reason
    evaluated_at_utc = $nowUtc.ToString("o")
    substantive_evaluation = $true
    metrics = $evaluation.metrics
} | ConvertTo-Json -Depth 12
