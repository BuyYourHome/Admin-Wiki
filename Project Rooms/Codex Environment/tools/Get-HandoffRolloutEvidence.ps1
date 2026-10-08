[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('WESSTUDIO','OFFICEASSIST','WES-VIDEOEDITOR')]
    [string]$ExpectedComputer
)

# Read-only deployment evidence. No fetch, install, task launch, queue write,
# credential inspection, invoice processing, email submission, or workbook edit.
$ErrorActionPreference = 'Stop'
$repo = 'C:\Codex\Wiki Files'
if ($env:COMPUTERNAME -ine $ExpectedComputer) { throw 'ComputerMismatch' }
if (-not (Test-Path -LiteralPath (Join-Path $repo '.git'))) { throw 'CanonicalRepositoryMissing' }
$skillNames = @('codex-environment','create-pr','pr-messaging-dispatcher','doc-scan','email-monitor','email-delivery','invoice-entry','quickbooks')
$skillEvidence = foreach ($name in $skillNames) {
    $source = Join-Path (Join-Path $repo 'skills') $name
    $installed = Join-Path (Join-Path $env:USERPROFILE '.codex\skills') $name
    $sourceFiles = @(Get-ChildItem -LiteralPath $source -File -Recurse)
    $expected = @{}
    $checks = foreach ($file in $sourceFiles) {
        $relative = $file.FullName.Substring($source.Length).TrimStart('\')
        $expected[$relative] = $true
        $target = Join-Path $installed $relative
        $sourceHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        $installedHash = if (Test-Path -LiteralPath $target -PathType Leaf) { (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash } else { $null }
        [pscustomobject]@{ file=$relative; source_sha256=$sourceHash; installed_sha256=$installedHash; matches=($sourceHash -ceq $installedHash) }
    }
    $extras = if (Test-Path -LiteralPath $installed -PathType Container) {
        @(Get-ChildItem -LiteralPath $installed -File -Recurse | ForEach-Object {
            $relative = $_.FullName.Substring($installed.Length).TrimStart('\')
            if (-not $expected.ContainsKey($relative)) { $relative }
        })
    } else { @() }
    [pscustomobject]@{ skill=$name; installed_path=$installed; files=@($checks); extra_files=@($extras); matches=(@($checks | Where-Object { -not $_.matches }).Count -eq 0 -and @($extras).Count -eq 0) }
}
$runtimeRoot = Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging'
$clientPath = Join-Path $runtimeRoot 'client.json'
$registrations = if (Test-Path -LiteralPath $clientPath) { (Get-Content -Raw -LiteralPath $clientPath | ConvertFrom-Json).registrations } else { @() }
$workerTaskName = 'BYH PR Messaging Worker - ' + $ExpectedComputer
$task = $null
$taskError = $null
try { $task = Get-ScheduledTask -TaskName $workerTaskName -ErrorAction Stop } catch { $taskError = $_.Exception.Message }
$workerConfigs = @()
$releaseRoot = Join-Path $runtimeRoot 'low-token\releases'
if (Test-Path -LiteralPath $releaseRoot) {
    $workerConfigs = @(Get-ChildItem -LiteralPath $releaseRoot -Filter config.json -File -Recurse | ForEach-Object {
        $configPath = $_.FullName
        $config = Get-Content -Raw -LiteralPath $configPath | ConvertFrom-Json
        if ($config.expected_machine -ine $ExpectedComputer) { throw 'WorkerConfigComputerMismatch' }
        $package = Split-Path -Parent $configPath
        $fileChecks = @(Get-ChildItem -LiteralPath $package -File | Where-Object Extension -In @('.ps1','.vbs') | ForEach-Object {
            $canonical = Join-Path (Join-Path $repo 'tools\pr-messaging\low-token') $_.Name
            $sourceHash = if (Test-Path -LiteralPath $canonical) { (Get-FileHash -LiteralPath $canonical).Hash } else { $null }
            $installedHash = (Get-FileHash -LiteralPath $_.FullName).Hash
            [pscustomobject]@{file=$_.Name; installed_sha256=$installedHash; source_sha256=$sourceHash; matches=($null -ne $sourceHash -and $sourceHash -ceq $installedHash)}
        })
        $healthPath = Join-Path $config.state_directory 'health.json'
        $health = if (Test-Path -LiteralPath $healthPath) { Get-Content -Raw -LiteralPath $healthPath | ConvertFrom-Json } else { $null }
        [pscustomobject]@{
            config_path=$configPath; config_sha256=(Get-FileHash -LiteralPath $configPath).Hash
            release=$config.release; dispatcher_task_id=$config.dispatcher_task_id
            selected_by_scheduled_task=($null -ne $task -and @($task.Actions | Where-Object { $_.Arguments -like ('*"'+$configPath+'"*') }).Count -gt 0)
            manager_pin_matches=(Test-Path -LiteralPath $config.manager_path) -and ($config.manager_sha256 -ceq (Get-FileHash -LiteralPath $config.manager_path).Hash)
            adapter_pin_matches=(Test-Path -LiteralPath $config.adapter_path) -and ($config.adapter_sha256 -ceq (Get-FileHash -LiteralPath $config.adapter_path).Hash)
            cli_exists=(Test-Path -LiteralPath $config.cli_path)
            cli_pin_matches=if (Test-Path -LiteralPath $config.cli_path) { $config.cli_sha256 -ceq (Get-FileHash -LiteralPath $config.cli_path).Hash } else { $false }
            files=$fileChecks; destinations=$config.destinations
            health=if ($null -ne $health) { [pscustomobject]@{status=$health.status; completed_at_utc=$health.completed_at_utc; claims=$health.claims; submissions=$health.submissions; attention=$health.attention; outstanding_attempts=$health.outstanding_attempts} } else { $null }
        }
    })
}
[pscustomobject][ordered]@{
    observed_at_utc=[DateTime]::UtcNow.ToString('o')
    computer=$env:COMPUTERNAME; windows_identity=[Security.Principal.WindowsIdentity]::GetCurrent().Name
    profile=$env:USERPROFILE; canonical_repo=$repo
    branch=(& git -C $repo branch --show-current)
    git_status=(& git -C $repo status --short --branch)
    head=(& git -C $repo rev-parse HEAD)
    cached_origin_comparison=(& git -C $repo rev-list --left-right --count main...origin/main)
    live_remote_checked=$false
    skills=@($skillEvidence); client_registrations=@($registrations)
    scheduled_task_name=$workerTaskName; scheduled_task_state=if ($null -ne $task) { [string]$task.State } else { $null }
    scheduled_task_read_error=$taskError
    worker_configs=$workerConfigs
    overall_verified=$false
    remaining_gate='Evidence inventory only. Verify exact manifests/pins, synthetic producer contracts, unattended acceptance/continuation/returns, and business-result evidence separately.'
} | ConvertTo-Json -Depth 12
