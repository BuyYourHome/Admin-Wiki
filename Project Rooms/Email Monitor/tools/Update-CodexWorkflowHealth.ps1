[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Started", "Completed", "Failed")]
    [string]$Status,

    [string]$Mode = "Unknown",
    [string]$FailureStage,
    [string]$FailureMessage
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

$config = Read-JsonFile -Path $ConfigPath
if ($null -eq $config) {
    throw "Health Check config not found: $ConfigPath"
}

if ($env:COMPUTERNAME -ne $config.assigned_machine) {
    throw "Workflow '$($config.workflow_id)' is assigned to '$($config.assigned_machine)', not '$env:COMPUTERNAME'."
}

$now = [DateTime]::UtcNow.ToString("o")
$previous = Read-JsonFile -Path $config.health_file
$consecutiveFailures = if ($null -ne $previous -and $null -ne $previous.consecutive_failures) {
    [int]$previous.consecutive_failures
} else {
    0
}

$health = [ordered]@{
    schema_version       = 1
    workflow_id          = [string]$config.workflow_id
    display_name         = [string]$config.display_name
    assigned_machine     = [string]$config.assigned_machine
    observed_machine     = [string]$env:COMPUTERNAME
    status               = if ($Status -eq "Started") { "running" } else { $Status.ToLowerInvariant() }
    mode                 = $Mode
    run_started_at_utc   = if ($Status -eq "Started") { $now } elseif ($null -ne $previous) { $previous.run_started_at_utc } else { $null }
    run_completed_at_utc = if ($Status -eq "Started") { $null } else { $now }
    last_success_at_utc  = if ($Status -eq "Completed") { $now } elseif ($null -ne $previous) { $previous.last_success_at_utc } else { $null }
    last_update_at_utc   = $now
    consecutive_failures = if ($Status -eq "Completed") { 0 } elseif ($Status -eq "Failed") { $consecutiveFailures + 1 } else { $consecutiveFailures }
    failure_stage        = if ($Status -eq "Failed") { $FailureStage } else { $null }
    failure_message      = if ($Status -eq "Failed") { $FailureMessage } else { $null }
}

Write-JsonAtomic -Path $config.health_file -Value $health
$health | ConvertTo-Json -Depth 8
