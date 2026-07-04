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

function Get-PercentRemaining($usedPercent) {
    if ($null -eq $usedPercent) {
        return $null
    }

    $remaining = 100.0 - [double]$usedPercent
    if ($remaining -lt 0) { $remaining = 0.0 }
    return [math]::Round($remaining, 2)
}

function Add-SessionTimestamp($spans, [string]$SessionKey, [datetime]$TimestampLocal) {
    if (-not $spans.ContainsKey($SessionKey)) {
        $spans[$SessionKey] = @{
            first = $TimestampLocal
            last = $TimestampLocal
        }
        return
    }

    if ($TimestampLocal -lt $spans[$SessionKey].first) {
        $spans[$SessionKey].first = $TimestampLocal
    }
    if ($TimestampLocal -gt $spans[$SessionKey].last) {
        $spans[$SessionKey].last = $TimestampLocal
    }
}

function Get-SessionElapsed($spans) {
    $totalSeconds = 0.0
    foreach ($key in $spans.Keys) {
        $span = $spans[$key]
        $seconds = ($span.last - $span.first).TotalSeconds
        if ($seconds -gt 0) {
            $totalSeconds += $seconds
        }
    }

    $roundedSeconds = [int64][math]::Round($totalSeconds, 0)
    $timeSpan = [TimeSpan]::FromSeconds($roundedSeconds)
    $parts = @()
    if ($timeSpan.Days -gt 0) { $parts += "$($timeSpan.Days)d" }
    if ($timeSpan.Hours -gt 0) { $parts += "$($timeSpan.Hours)h" }
    if ($timeSpan.Minutes -gt 0) { $parts += "$($timeSpan.Minutes)m" }
    if ($parts.Count -eq 0) { $parts += "$($timeSpan.Seconds)s" }

    return [pscustomobject]@{
        seconds = $roundedSeconds
        human = ($parts -join " ")
    }
}

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
$roots = @((Join-Path $codexHome "sessions"))
if ($Source -eq "all") {
    $roots += (Join-Path $codexHome "archived_sessions")
}

$configPath = Join-Path $PSScriptRoot "codex-token-summary.config.json"
$weeklyTokenBudget = $null
if (Test-Path $configPath) {
    try {
        $config = Get-Content -Raw -LiteralPath $configPath | ConvertFrom-Json
        if ($null -ne $config.weekly_token_budget -and [string]$config.weekly_token_budget -ne "") {
            $weeklyTokenBudget = [int64]$config.weekly_token_budget
        }
    } catch {
    }
}

$yesterdayStart = $Now.Date.AddDays(-1)
$yesterdayEnd = $Now.Date
$weekStart = Get-WeekStart $Now
$weekEnd = $Now

$yesterdayUsage = New-Usage
$weekUsage = New-Usage
$yesterdaySessions = [System.Collections.Generic.HashSet[string]]::new()
$weekSessions = [System.Collections.Generic.HashSet[string]]::new()
$yesterdaySessionSpans = @{}
$weekSessionSpans = @{}
$latestRateLimit = $null
$latestRateLimitTimestamp = $null

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

        if ($null -eq $latestRateLimitTimestamp -or $timestampUtc -gt $latestRateLimitTimestamp) {
            $latestRateLimitTimestamp = $timestampUtc
            $latestRateLimit = $entry.payload.rate_limits
        }

        if ($timestampLocal -ge $yesterdayStart -and $timestampLocal -lt $yesterdayEnd) {
            Add-Usage $yesterdayUsage $usage
            [void]$yesterdaySessions.Add($sessionKey)
            Add-SessionTimestamp $yesterdaySessionSpans $sessionKey $timestampLocal
        }

        if ($timestampLocal -ge $weekStart -and $timestampLocal -lt $weekEnd) {
            Add-Usage $weekUsage $usage
            [void]$weekSessions.Add($sessionKey)
            Add-SessionTimestamp $weekSessionSpans $sessionKey $timestampLocal
        }
    }
}

$yesterdayUsage.session_count = $yesterdaySessions.Count
$weekUsage.session_count = $weekSessions.Count

$weeklyBudgetSummary = if ($null -ne $weeklyTokenBudget -and $weeklyTokenBudget -gt 0) {
    $remainingTokens = $weeklyTokenBudget - [int64]$weekUsage.total_tokens
    if ($remainingTokens -lt 0) { $remainingTokens = 0 }
    $usedPercent = [math]::Round((([double]$weekUsage.total_tokens / [double]$weeklyTokenBudget) * 100.0), 2)
    if ($usedPercent -gt 100.0) { $usedPercent = 100.0 }
    [pscustomobject]@{
        configured = $true
        weekly_token_budget = $weeklyTokenBudget
        used_tokens = [int64]$weekUsage.total_tokens
        remaining_tokens = [int64]$remainingTokens
        used_percent = $usedPercent
        remaining_percent = [math]::Round((100.0 - $usedPercent), 2)
    }
} else {
    [pscustomobject]@{
        configured = $false
        weekly_token_budget = $null
        used_tokens = [int64]$weekUsage.total_tokens
        remaining_tokens = $null
        used_percent = $null
        remaining_percent = $null
    }
}

$rateLimitSummary = if ($null -ne $latestRateLimit) {
    [pscustomobject]@{
        captured_at = $latestRateLimitTimestamp.ToLocalTime().ToString("o")
        primary = [pscustomobject]@{
            window_minutes = $latestRateLimit.primary.window_minutes
            used_percent = $latestRateLimit.primary.used_percent
            remaining_percent = (Get-PercentRemaining $latestRateLimit.primary.used_percent)
            resets_at = if ($latestRateLimit.primary.resets_at) { ([DateTimeOffset]::FromUnixTimeSeconds([int64]$latestRateLimit.primary.resets_at)).ToLocalTime().ToString("o") } else { $null }
        }
        secondary = [pscustomobject]@{
            window_minutes = $latestRateLimit.secondary.window_minutes
            used_percent = $latestRateLimit.secondary.used_percent
            remaining_percent = (Get-PercentRemaining $latestRateLimit.secondary.used_percent)
            resets_at = if ($latestRateLimit.secondary.resets_at) { ([DateTimeOffset]::FromUnixTimeSeconds([int64]$latestRateLimit.secondary.resets_at)).ToLocalTime().ToString("o") } else { $null }
        }
    }
} else {
    $null
}

$result = [pscustomobject]@{
    generated_at = $Now.ToString("o")
    timezone = [System.TimeZoneInfo]::Local.Id
    source = $Source
    roots = $roots
    config_path = $configPath
    yesterday = [pscustomobject]@{
        start = $yesterdayStart.ToString("o")
        end = $yesterdayEnd.ToString("o")
        usage = [pscustomobject]$yesterdayUsage
        elapsed = Get-SessionElapsed $yesterdaySessionSpans
    }
    week_to_date = [pscustomobject]@{
        start = $weekStart.ToString("o")
        end = $weekEnd.ToString("o")
        usage = [pscustomobject]$weekUsage
        elapsed = Get-SessionElapsed $weekSessionSpans
    }
    rate_limit_remaining = $rateLimitSummary
    weekly_budget_remaining = $weeklyBudgetSummary
}

$result | ConvertTo-Json -Depth 6
