[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
$release=Split-Path $PSScriptRoot -Parent
. (Join-Path $release 'installer\CliReview.ps1')
$script:passed=0
$script:failed=0
function Assert($Value,[string]$Message='Assertion failed'){if(!$Value){throw $Message}}
function Check([string]$Name,[scriptblock]$Body){
    try{& $Body;$script:passed++;Write-Host ('PASS '+$Name)}catch{$script:failed++;Write-Host ('FAIL '+$Name+': '+$_.Exception.Message)}
}
function Evidence {
    [pscustomobject]@{
        exists=$true
        path='C:\Program Files\WindowsApps\OpenAI.Codex_26.1111.2228.0_x64__2p2nqsd0c76g0\app\resources\codex.exe'
        file_name='codex.exe';is_reparse=$false
        package_name='OpenAI.Codex';package_publisher='CN=50BDFD77-8903-4850-9FFE-6E8522F64D5B'
        package_family_name='OpenAI.Codex_2p2nqsd0c76g0';package_architecture='X64';package_version='26.1111.2228.0'
        package_full_name='OpenAI.Codex_26.1111.2228.0_x64__2p2nqsd0c76g0'
        install_location='C:\Program Files\WindowsApps\OpenAI.Codex_26.1111.2228.0_x64__2p2nqsd0c76g0'
        manifest_name='OpenAI.Codex';manifest_publisher='CN=50BDFD77-8903-4850-9FFE-6E8522F64D5B'
        manifest_architecture='x64';manifest_version='26.1111.2228.0'
        signature_status='Valid';signer_subject='CN="OpenAI OpCo, LLC", O="OpenAI OpCo, LLC", L=San Francisco, S=California, C=US'
        sha256_before=('A'*64);version_exit_code=0;version_output='codex-cli 0.169.0-alpha.11.1';sha256_after=('A'*64)
    }
}
function Reject($Evidence,[string]$Expected){
    try{Assert-LtPackagedCliEvidence $Evidence;throw 'accepted'}catch{Assert ($_.Exception.Message -ceq $Expected) ('Expected '+$Expected+', got '+$_.Exception.Message)}
}
Check 'accept exact registered signed packaged CLI evidence' {Assert-LtPackagedCliEvidence (Evidence)}
Check 'reject a different WindowsApps executable location' {$e=Evidence;$e.path=$e.install_location+'\app\other\codex.exe';Reject $e 'UnreviewedCliLocation'}
Check 'reject a different package family' {$e=Evidence;$e.package_family_name='Other.Package_2p2nqsd0c76g0';Reject $e 'UnreviewedCliPackageIdentity'}
Check 'reject a package leaf that does not match registration' {$e=Evidence;$e.install_location='C:\Program Files\WindowsApps\Other.Package';Reject $e 'UnreviewedCliPackageLocation'}
Check 'reject an invalid executable signature' {$e=Evidence;$e.signature_status='HashMismatch';Reject $e 'UnreviewedCliSignature'}
Check 'reject a changed binary during review' {$e=Evidence;$e.sha256_after=('B'*64);Reject $e 'CliChangedDuringReview'}
Check 'reject a missing executable' {$e=Evidence;$e.exists=$false;Reject $e 'CliExecutableMissing'}
Check 'reject failed executable behavior' {$e=Evidence;$e.version_exit_code=1;Reject $e 'UnreviewedCliBehavior'}
Check 'review helper accepts the installed normal-user Codex CLI' {
    $x=Get-LtReviewedCli
    Assert ($x.path -ceq (Get-Command codex.exe -ErrorAction Stop).Source)
    Assert ($x.sha256 -ceq (Get-FileHash -LiteralPath $x.path -Algorithm SHA256).Hash)
    Assert ($x.trust_model -in @('ReviewedLocalCodexBin','RegisteredSignedOpenAICodexPackage'))
}
Check 'UpgradeLive preflights before disabling and preserves guarded runtime structures' {
    $text=Get-Content -Raw -LiteralPath (Join-Path $release 'Install-LowTokenWorker.ps1')
    $start=$text.IndexOf("if(`$Action -eq 'UpgradeLive')")
    $end=$text.IndexOf("if(`$Action -eq 'Rollback')",$start)
    $block=$text.Substring($start,$end-$start)
    Assert ($block.IndexOf('$reviewedCli=Get-LtReviewedCli') -lt $block.IndexOf('Disable-ScheduledTask'))
    Assert ($block.Contains('LiveSourceWindowsIdentityMismatch'))
    Assert ($block.Contains("foreach(`$field in @('triggers','principal','settings'))"))
    Assert ($block.Contains('generation_preserved=$owner.generation') -and $block.Contains('journal_preserved=$true'))
    Assert ($block.Contains('$cfg=$oldCfg') -and $block.Contains('$cfg.state_directory'))
    Assert ($block.Contains('Set-ScheduledTask -TaskName $task -Action $taskAction'))
    Assert ($block.Contains('Set-ScheduledTask -TaskName $task -Action $scheduled.Actions'))
    Assert ($block -notmatch '-Action (Send|StartAttempt|ConditionalClaim|Accept|StartProcessing|Complete|Fail)')
}
$summary=[ordered]@{release='0.4.11';passed=$script:passed;failed=$script:failed;production_actions=0;queue_mutations=0;worker_runs=0}
$summary|ConvertTo-Json -Depth 4
if($script:failed){exit 1}
