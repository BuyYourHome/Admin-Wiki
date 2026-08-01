[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Failure", "Critical", "Recovery", "Routing", "Delivery", "Decision", "Significant Action")]
    [string]$Category,

    [Parameter(Mandatory = $true)]
    [string]$Summary,

    [string]$Details,

    [DateTime]$TimestampUtc = [DateTime]::UtcNow
)

$ErrorActionPreference = "Stop"

function Read-JsonFile {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Log configuration was not found: $Path"
    }

    Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
}

function Get-RollingEntries {
    param(
        [string]$Content,
        [DateTime]$CutoffUtc
    )

    if ([string]::IsNullOrWhiteSpace($Content)) {
        return @()
    }

    $blocks = [regex]::Split($Content, '(?m)(?=^## \d{4}-\d{2}-\d{2}T)')
    $entries = foreach ($block in $blocks) {
        if ($block -match '(?m)^## (?<timestamp>\d{4}-\d{2}-\d{2}T[^ ]+) \|') {
            $parsed = [DateTime]::MinValue
            if ([DateTime]::TryParse($Matches.timestamp, [ref]$parsed)) {
                $utc = $parsed.ToUniversalTime()
                if ($utc -ge $CutoffUtc) {
                    [pscustomobject]@{
                        TimestampUtc = $utc
                        Content = $block.Trim()
                    }
                }
            }
        }
    }

    @($entries)
}

function Format-RollingFile {
    param([object[]]$Entries)

    $header = @(
        '# Email Monitor - Rolling 7 Days',
        '',
        'This Teams file is maintained automatically. It contains meaningful Email Monitor failures, recoveries, routing actions, deliveries, and decisions from the most recent seven days. Routine no-activity checks are excluded.',
        ''
    ) -join "`r`n"

    if ($Entries.Count -eq 0) {
        return "$header`r`n"
    }

    $body = ($Entries | Sort-Object TimestampUtc | ForEach-Object { $_.Content }) -join "`r`n`r`n"
    "$header`r`n$body`r`n"
}

function Write-AtomicText {
    param(
        [string]$Path,
        [string]$Content
    )

    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
    $tempPath = Join-Path $directory ((Split-Path -Leaf $Path) + '.tmp')
    Set-Content -LiteralPath $tempPath -Value $Content -Encoding UTF8
    Move-Item -LiteralPath $tempPath -Destination $Path -Force
}

function Limit-PendingEntries {
    param(
        [object[]]$Entries,
        [int64]$MaximumBytes
    )

    $kept = @($Entries | Sort-Object TimestampUtc)
    while ($kept.Count -gt 1) {
        $candidate = Format-RollingFile -Entries $kept
        if ([Text.Encoding]::UTF8.GetByteCount($candidate) -le $MaximumBytes) {
            break
        }
        $kept = @($kept | Select-Object -Skip 1)
    }
    $kept
}

$config = Read-JsonFile -Path $ConfigPath
$cutoffUtc = [DateTime]::UtcNow.AddDays(-[double]$config.retention_days)
$timestamp = $TimestampUtc.ToUniversalTime()
$entryLines = @(
    "## $($timestamp.ToString('o')) | $Category",
    '',
    "- $($Summary.Trim())"
)
if (-not [string]::IsNullOrWhiteSpace($Details)) {
    $entryLines += "- $($Details.Trim())"
}
$newEntry = [pscustomobject]@{
    TimestampUtc = $timestamp
    Content = ($entryLines -join "`r`n")
}

$teamsPath = [string]$config.teams_log_path
$pendingPath = [string]$config.pending_log_path

try {
    $existingContent = if (Test-Path -LiteralPath $teamsPath) { Get-Content -LiteralPath $teamsPath -Raw } else { '' }
    $entries = @(Get-RollingEntries -Content $existingContent -CutoffUtc $cutoffUtc)

    if (Test-Path -LiteralPath $pendingPath) {
        $pendingContent = Get-Content -LiteralPath $pendingPath -Raw
        $entries += @(Get-RollingEntries -Content $pendingContent -CutoffUtc $cutoffUtc)
    }

    $entries += $newEntry
    $deduplicated = @($entries | Sort-Object TimestampUtc, Content -Unique)
    Write-AtomicText -Path $teamsPath -Content (Format-RollingFile -Entries $deduplicated)

    if (Test-Path -LiteralPath $pendingPath) {
        Remove-Item -LiteralPath $pendingPath -Force
    }

    [pscustomobject]@{
        status = 'WrittenToTeams'
        path = $teamsPath
        retained_entries = $deduplicated.Count
        cutoff_utc = $cutoffUtc.ToString('o')
    } | ConvertTo-Json
} catch {
    $pendingContent = if (Test-Path -LiteralPath $pendingPath) { Get-Content -LiteralPath $pendingPath -Raw } else { '' }
    $pendingEntries = @(Get-RollingEntries -Content $pendingContent -CutoffUtc $cutoffUtc)
    $pendingEntries += $newEntry
    $pendingEntries = @(Limit-PendingEntries -Entries $pendingEntries -MaximumBytes ([int64]$config.max_pending_bytes))
    Write-AtomicText -Path $pendingPath -Content (Format-RollingFile -Entries $pendingEntries)

    [pscustomobject]@{
        status = 'QueuedLocally'
        path = $pendingPath
        retained_entries = $pendingEntries.Count
        cutoff_utc = $cutoffUtc.ToString('o')
        teams_error = $_.Exception.Message
    } | ConvertTo-Json
}
