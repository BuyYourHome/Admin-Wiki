[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath,

    [switch]$TestOnly
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
    $Value | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $temporaryPath -Encoding UTF8
    Move-Item -Force -LiteralPath $temporaryPath -Destination $Path
}

function Write-WatchdogLog {
    param(
        [object]$Config,
        [string]$Message
    )

    $directory = Split-Path -Parent $Config.watchdog_log_file
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    $line = "{0}`t{1}" -f [DateTime]::UtcNow.ToString("o"), $Message
    Add-Content -LiteralPath $Config.watchdog_log_file -Value $line -Encoding UTF8
}

function Show-WindowsToast {
    param(
        [object]$Config,
        [string]$Title,
        [string]$Message
    )

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
    param(
        [object]$Config,
        [string]$Level,
        [string]$Message,
        [switch]$SuppressNotification
    )

    $title = "Codex $($Config.display_name) Health: $Level"
    $alert = "{0}`r`n{1}`r`nUTC: {2}" -f $title, $Message, [DateTime]::UtcNow.ToString("o")
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Config.current_alert_file) | Out-Null
    Set-Content -LiteralPath $Config.current_alert_file -Value $alert -Encoding UTF8
    Write-WatchdogLog -Config $Config -Message "$Level - $Message"

    if ($SuppressNotification) {
        return
    }

    try {
        Show-WindowsToast -Config $Config -Title $title -Message $Message
    } catch {
        Write-WatchdogLog -Config $Config -Message "Toast failed: $($_.Exception.Message)"
    }

    try {
        $entryType = if ($Level -eq "CRITICAL") { "Error" } elseif ($Level -eq "WARNING") { "Warning" } else { "Information" }
        Write-EventLog -LogName Application -Source "Windows PowerShell" -EntryType $entryType -EventId 4101 -Message $alert
    } catch {
        Write-WatchdogLog -Config $Config -Message "Event Log write failed: $($_.Exception.Message)"
    }
}

$config = Read-JsonFile -Path $ConfigPath
if ($null -eq $config) {
    throw "Health Check config not found: $ConfigPath"
}

if ($env:COMPUTERNAME -ne $config.assigned_machine) {
    Write-WatchdogLog -Config $config -Message "Skipped: assigned to $($config.assigned_machine), running on $env:COMPUTERNAME."
    exit 0
}

$nowLocal = Get-Date
$start = [TimeSpan]::Parse([string]$config.active_window_start)
$end = [TimeSpan]::Parse([string]$config.active_window_end)
if ($nowLocal.TimeOfDay -lt $start -or $nowLocal.TimeOfDay -gt $end) {
    Write-WatchdogLog -Config $config -Message "Outside active window; no evaluation."
    exit 0
}

$health = Read-JsonFile -Path $config.health_file
$previousState = Read-JsonFile -Path $config.watchdog_state_file
$nowUtc = [DateTime]::UtcNow
$ageMinutes = [double]::PositiveInfinity
$level = "CRITICAL"
$reason = "Health state is missing."

if ($null -ne $health) {
    $referenceValue = if ($health.status -eq "running" -and $health.run_started_at_utc) {
        $health.run_started_at_utc
    } elseif ($health.run_completed_at_utc) {
        $health.run_completed_at_utc
    } elseif ($health.last_update_at_utc) {
        $health.last_update_at_utc
    } else {
        $null
    }

    if ($referenceValue) {
        $referenceUtc = [DateTime]::Parse([string]$referenceValue).ToUniversalTime()
        $ageMinutes = ($nowUtc - $referenceUtc).TotalMinutes
        if ($health.status -eq "failed") {
            $level = if ([int]$health.consecutive_failures -ge 3) { "CRITICAL" } else { "WARNING" }
            $reason = "Heartbeat reported failure at '$($health.failure_stage)': $($health.failure_message)"
        } elseif ($ageMinutes -gt [double]$config.critical_after_minutes) {
            $level = "CRITICAL"
            $reason = "No completed heartbeat for $([math]::Round($ageMinutes)) minutes; last status is '$($health.status)'."
        } elseif ($ageMinutes -gt [double]$config.warning_after_minutes) {
            $level = "WARNING"
            $reason = "No completed heartbeat for $([math]::Round($ageMinutes)) minutes; last status is '$($health.status)'."
        } else {
            $level = "HEALTHY"
            $reason = "Last heartbeat state is '$($health.status)' and $([math]::Round($ageMinutes)) minutes old."
        }
    }
}

$previousLevel = if ($null -ne $previousState) { [string]$previousState.level } else { "UNKNOWN" }
$stateChanged = $previousLevel -ne $level
$state = [ordered]@{
    schema_version    = 1
    workflow_id       = [string]$config.workflow_id
    assigned_machine  = [string]$config.assigned_machine
    observed_machine  = [string]$env:COMPUTERNAME
    level             = $level
    previous_level    = $previousLevel
    reason            = $reason
    evaluated_at_utc  = $nowUtc.ToString("o")
    age_minutes       = if ([double]::IsPositiveInfinity($ageMinutes)) { $null } else { [math]::Round($ageMinutes, 2) }
}

Write-JsonAtomic -Path $config.watchdog_state_file -Value $state
Write-WatchdogLog -Config $config -Message "$level - $reason"

if ($stateChanged -and $level -ne "HEALTHY") {
    Publish-Alert -Config $config -Level $level -Message $reason -SuppressNotification:$TestOnly
} elseif ($stateChanged -and $level -eq "HEALTHY" -and $previousLevel -in @("WARNING", "CRITICAL")) {
    Publish-Alert -Config $config -Level "RECOVERED" -Message $reason -SuppressNotification:$TestOnly
} elseif ($level -eq "HEALTHY" -and (Test-Path -LiteralPath $config.current_alert_file)) {
    Remove-Item -LiteralPath $config.current_alert_file -Force
}

$state | ConvertTo-Json -Depth 8
