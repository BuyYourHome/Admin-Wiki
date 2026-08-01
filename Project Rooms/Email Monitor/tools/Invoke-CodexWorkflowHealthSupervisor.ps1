[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$RegistryPath,

    [string]$WorkflowId,
    [switch]$TestOnly,
    [switch]$ForceEvaluation,
    [switch]$TestAlert
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
    param([string]$Path, [object]$Value)

    $directory = Split-Path -Parent $Path
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
    $temporaryPath = "$Path.tmp"
    $Value | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $temporaryPath -Encoding UTF8
    Move-Item -Force -LiteralPath $temporaryPath -Destination $Path
}

function Write-SupervisorLog {
    param([object]$Registry, [string]$Message)

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Registry.supervisor_log_file) | Out-Null
    Add-Content -LiteralPath $Registry.supervisor_log_file -Encoding UTF8 -Value ("{0}`t{1}" -f [DateTime]::UtcNow.ToString("o"), $Message)
}

$RegistryPath = (Resolve-Path -LiteralPath $RegistryPath).Path
$registry = Read-JsonFile -Path $RegistryPath
if ($null -eq $registry) {
    throw "Workflow health registry not found: $RegistryPath"
}
if ($env:COMPUTERNAME -ne $registry.assigned_machine) {
    throw "Supervisor is assigned to '$($registry.assigned_machine)', not '$env:COMPUTERNAME'."
}

$createdNew = $false
$mutex = [Threading.Mutex]::new($false, [string]$registry.mutex_name, [ref]$createdNew)
$lockAcquired = $false
try {
    $lockAcquired = $mutex.WaitOne(0)
    if (-not $lockAcquired) {
        Write-SupervisorLog -Registry $registry -Message "Skipped: another supervisor run holds the registry lock."
        exit 0
    }

    $results = @()
    $workflows = @($registry.workflows)
    if ($WorkflowId) {
        $workflows = @($workflows | Where-Object { $_.workflow_id -eq $WorkflowId })
        if ($workflows.Count -eq 0) {
            throw "Workflow '$WorkflowId' is not registered."
        }
    }

    foreach ($workflow in $workflows) {
        if (-not [bool]$workflow.enabled) {
            $results += [ordered]@{ workflow_id = [string]$workflow.workflow_id; status = "DISABLED" }
            continue
        }

        try {
            if (-not (Test-Path -LiteralPath $workflow.config_path)) {
                throw "Configuration file not found: $($workflow.config_path)"
            }

            $arguments = @{
                ConfigPath = [string]$workflow.config_path
            }
            if ($TestOnly) { $arguments.TestOnly = $true }
            if ($ForceEvaluation) { $arguments.ForceEvaluation = $true }
            if ($TestAlert) { $arguments.TestAlert = $true }

            $raw = & ([string]$registry.workflow_evaluator_script) @arguments | Out-String
            $result = if ($raw.Trim()) { $raw | ConvertFrom-Json } else { [ordered]@{ status = "NO_OUTPUT" } }
            $results += $result
            Write-SupervisorLog -Registry $registry -Message "$($workflow.workflow_id): $($result.level) $($result.status)"
        } catch {
            $message = $_.Exception.Message
            $results += [ordered]@{
                workflow_id = [string]$workflow.workflow_id
                level = "ERROR"
                status = "CONFIGURATION_OR_EVALUATION_FAILURE"
                reason = $message
            }
            Write-SupervisorLog -Registry $registry -Message "$($workflow.workflow_id): ERROR - $message"
        }
    }

    $state = [ordered]@{
        schema_version = 1
        supervisor_id = [string]$registry.supervisor_id
        assigned_machine = [string]$registry.assigned_machine
        observed_machine = [string]$env:COMPUTERNAME
        evaluated_at_utc = [DateTime]::UtcNow.ToString("o")
        test_only = [bool]$TestOnly
        results = $results
    }
    Write-JsonAtomic -Path $registry.supervisor_state_file -Value $state
    $state | ConvertTo-Json -Depth 12
} finally {
    if ($lockAcquired) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
}
