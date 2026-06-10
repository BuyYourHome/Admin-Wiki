param(
    [ValidateSet("live", "all")]
    [string]$Source = "live",
    [datetime]$Now = (Get-Date)
)

$ErrorActionPreference = "Stop"

function Get-WeekStart([datetime]$Date) {
    $daysSinceMonday = (([int]$Date.DayOfWeek + 6) % 7)
    return $Date.Date.AddDays(-$daysSinceMonday)
}

function New-Usage() {
    @{
        input_tokens = [int64]0
        cached_input_tokens = [int64]0
        output_tokens = [int64]0
        reasoning_output_tokens = [int64]0
        total_tokens = [int64]0
        event_count = [int64]0
        session_count = [int64]0
    }
}

function Add-Usage($target, $usage) {
    $target.input_tokens += [int64]$usage.input_tokens
    $target.cached_input_tokens += [int64]$usage.cached_input_tokens
    $target.output_tokens += [int64]$usage.output_tokens
    $target.reasoning_output_tokens += [int64]$usage.reasoning_output_tokens
    $target.total_tokens += [int64]$usage.total_tokens
    $target.event_count += 1
}

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
$roots = @((Join-Path $codexHome "sessions"))
if ($Source -eq "all") {
    $roots += (Join-Path $codexHome "archived_sessions")
}

$yesterdayStart = $Now.Date.AddDays(-1)
$yesterdayEnd = $Now.Date
$weekStart = Get-WeekStart $Now
$weekEnd = $Now

$yesterdayUsage = New-Usage
$weekUsage = New-Usage
$yesterdaySessions = [System.Collections.Generic.HashSet[string]]::new()
$weekSessions = [System.Collections.Generic.HashSet[string]]::new()

$files = foreach ($root in $roots) {
    if (Test-Path $root) {
        Get-ChildItem -Path $root -Recurse -File -Filter *.jsonl -ErrorAction SilentlyContinue
    }
}

foreach ($file in $files) {
    $sessionKey = $file.FullName.Substring($codexHome.Length).TrimStart('\')
    try {
        $lines = Get-Content -LiteralPath $file.FullName -ErrorAction Stop
    } catch {
        continue
    }

    foreach ($line in $lines) {
        if (-not $line.Contains('"type":"token_count"')) {
            continue
        }

        try {
            $entry = $line | ConvertFrom-Json
        } catch {
            continue
        }

        if ($entry.type -ne "event_msg" -or $entry.payload.type -ne "token_count") {
            continue
        }

        $usage = $entry.payload.info.last_token_usage
        if (-not $usage) {
            continue
        }

        $timestampUtc = [datetime]::Parse($entry.timestamp, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
        $timestampLocal = $timestampUtc.ToLocalTime()

        if ($timestampLocal -ge $yesterdayStart -and $timestampLocal -lt $yesterdayEnd) {
            Add-Usage $yesterdayUsage $usage
            [void]$yesterdaySessions.Add($sessionKey)
        }

        if ($timestampLocal -ge $weekStart -and $timestampLocal -lt $weekEnd) {
            Add-Usage $weekUsage $usage
            [void]$weekSessions.Add($sessionKey)
        }
    }
}

$yesterdayUsage.session_count = $yesterdaySessions.Count
$weekUsage.session_count = $weekSessions.Count

$result = [pscustomobject]@{
    generated_at = $Now.ToString("o")
    timezone = [System.TimeZoneInfo]::Local.Id
    source = $Source
    roots = $roots
    yesterday = [pscustomobject]@{
        start = $yesterdayStart.ToString("o")
        end = $yesterdayEnd.ToString("o")
        usage = [pscustomobject]$yesterdayUsage
    }
    week_to_date = [pscustomobject]@{
        start = $weekStart.ToString("o")
        end = $weekEnd.ToString("o")
        usage = [pscustomobject]$weekUsage
    }
}

$result | ConvertTo-Json -Depth 6
