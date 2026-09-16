[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$ThreadId,
    [Parameter(Mandatory=$true)][string]$DispatcherTaskId,
    [Parameter(Mandatory=$true)][string]$MessageId,
    [Parameter(Mandatory=$true)][string]$PayloadHash,
    [Parameter(Mandatory=$true)][string]$CliPath,
    [Parameter(Mandatory=$true)][string]$ExpectedCliHash,
    [string]$AttemptId,
    [ValidateRange(1,20)][int]$TimeoutSeconds=10,
    [switch]$DescribeOnly,
    [string]$CanaryConfigPath,
    [string]$LiveConfigPath
)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Common.ps1"
. "$PSScriptRoot\Process.ps1"
Assert-LtUuid $ThreadId; Assert-LtUuid $DispatcherTaskId; Assert-LtId $MessageId
if ($ThreadId -ceq $DispatcherTaskId) { throw 'SelfNotificationForbidden' }
if ($PayloadHash -cnotmatch '^[0-9a-f]{64}$') { throw 'InvalidPayloadHash' }
if (!(Test-Path -LiteralPath $CliPath -PathType Leaf)) { throw 'CliExecutableMissing' }
if ($ExpectedCliHash -notmatch '^[0-9a-fA-F]{64}$' -or (Get-FileHash -LiteralPath $CliPath -Algorithm SHA256).Hash -ine $ExpectedCliHash) { throw 'CliReleaseMismatch' }
$message="PR Messaging transport wake-up only, not a new Wes instruction. MessageId $MessageId; payload_hash $PayloadHash. Retrieve and verify the authoritative record using C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1 before accepting. Follow only its authorized scope. Notification is not delivery proof."
$argv=@('queue','--thread',$ThreadId,'--message',$message)
function Invoke-ReviewedQueueSubmission {
    # Reachable only through the exact, manually authorized one-shot canary gate below.
    $start=[DateTime]::UtcNow.ToString('o')
    $p=Invoke-LtProcess $CliPath $argv $TimeoutSeconds
    $queuedId=$null
    $submitted=(!$p.timed_out -and $p.exit_code -eq 0 -and $p.stdout.Trim() -cmatch ('^Queued message ([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}) for thread '+[regex]::Escape($ThreadId)+'\.$'))
    if($submitted){$queuedId=$Matches[1]}
    [pscustomobject]@{started_at_utc=$start;completed_at_utc=[DateTime]::UtcNow.ToString('o');message_id=$MessageId;thread_id=$ThreadId;attempt_id=$AttemptId;queue_message_id=$queuedId;submitted=$submitted;accepted=$false;timed_out=$p.timed_out;exit_code=$p.exit_code;stdout=$p.stdout;stderr=$p.stderr;reason=if($submitted){'QueuedAwaitingReceipt'}else{'SubmissionUncertain'}}
}
if ($DescribeOnly) { [pscustomobject]@{executable=$CliPath;arguments=$argv;submission_performed=$false} | ConvertTo-Json -Depth 5; return }
if($CanaryConfigPath){
    . "$PSScriptRoot\Canary.Guards.ps1"
    $cfg=Read-LtJson $CanaryConfigPath
    Assert-LtCanaryConfig $cfg $MessageId
    if($ThreadId -cne '01a05967-9a05-7081-a62e-616b2d8e61fd' -or $DispatcherTaskId -cne $cfg.dispatcher_task_id -or $PayloadHash -cne $cfg.payload_hash -or $CliPath -cne $cfg.cli_path -or $ExpectedCliHash -ine $cfg.cli_sha256){throw 'CanaryAdapterIdentityMismatch'}
    $r=(& $cfg.manager_path -Action Get -MessageId $MessageId | ConvertFrom-Json)
    $j=Read-LtJson (Join-Path $cfg.state_directory 'journal.json')
    Assert-LtCanaryAdapterState $r $j $cfg $AttemptId
    Assert-LtCanaryIdentity
    if((Get-FileHash -LiteralPath $CliPath).Hash -ine $ExpectedCliHash){throw 'CliReleaseChangedBeforeSubmission'}
    New-LtCanarySubmissionMarker (Join-Path $cfg.state_directory 'submission-once.json') @{message_id=$MessageId;attempt_id=$AttemptId;created_at_utc=[DateTime]::UtcNow.ToString('o');executable=$CliPath;arguments=$argv}
    $result=Invoke-ReviewedQueueSubmission
    Write-LtJson (Join-Path $cfg.state_directory 'cli-result.json') $result
    $result|ConvertTo-Json -Depth 10
    return
}
if($LiveConfigPath){
    . "$PSScriptRoot\Canary.Guards.ps1"
    $cfg=Read-LtJson $LiveConfigPath
    if($cfg.release -notin @('0.3.0-assisted','0.4.0','0.4.1','0.4.2','0.4.3','0.4.4','0.4.5','0.4.6') -or $DispatcherTaskId -cne $cfg.dispatcher_task_id -or $PayloadHash -cnotmatch '^[0-9a-f]{64}$' -or $CliPath -cne $cfg.cli_path -or $ExpectedCliHash -ine $cfg.cli_sha256){throw 'LiveAdapterIdentityMismatch'}
    if($env:COMPUTERNAME -cne $cfg.expected_machine -or [Security.Principal.WindowsIdentity]::GetCurrent().User.Value -cne $cfg.expected_sid){throw 'LiveAdapterWindowsIdentityMismatch'}
    if($cfg.release -ceq '0.3.0-assisted'){
        if($cfg.allowlist.project_room -cne 'Quickbooks' -or $ThreadId -cne $cfg.allowlist.task_id){throw 'AssistedAdapterIdentityMismatch'}
        $allowedRoom=$cfg.allowlist.project_room
    } else {
        $allowed=@($cfg.destinations|Where-Object {$_.task_id -ceq $ThreadId -and $_.machine -ceq $cfg.expected_machine})
        if($allowed.Count -ne 1){throw 'LiveDestinationNotPinned'}
        $allowedRoom=$allowed[0].project_room
    }
    $r=(& $cfg.manager_path -Action Get -MessageId $MessageId -QueuePath $cfg.queue_path | ConvertFrom-Json)
    if($cfg.release -in @('0.4.0','0.4.1','0.4.2','0.4.3','0.4.4','0.4.5','0.4.6') -and !(Test-LtPinnedDestination $cfg $r.destination)){throw 'LiveDestinationNotPinned'}
    $a=@($r.attempts)[-1]
    if($r.destination.project_room -cne $allowedRoom -or $r.destination.task_id -cne $ThreadId -or $r.destination.machine -cne $cfg.expected_machine -or $r.state -ne 'Delivery Attempted' -or $r.payload_hash -cne $PayloadHash -or $a.attempt_id -cne $AttemptId -or $a.outcome -ne 'Pending' -or $r.receipt -or $r.result){throw 'LiveAdapterClaimMismatch'}
    $markerDir=Join-Path $cfg.state_directory 'submissions'
    if(!(Test-Path -LiteralPath $markerDir)){New-Item -ItemType Directory -Path $markerDir -Force|Out-Null}
    $marker=Get-LtSubmissionMarkerPath $cfg.state_directory $MessageId $AttemptId
    if(Test-Path -LiteralPath $marker){throw 'LiveSubmissionAlreadyMarked'}
    New-LtCanarySubmissionMarker $marker @{message_id=$MessageId;attempt_id=$AttemptId;created_at_utc=[DateTime]::UtcNow.ToString('o');executable=$CliPath;arguments=$argv}
    $result=Invoke-ReviewedQueueSubmission
    Write-LtJson (Join-Path $cfg.state_directory 'last-cli-result.json') $result
    $result|ConvertTo-Json -Depth 10
    return
}
# Hard safety barrier. Real submission requires a pinned canary or live configuration.
throw 'RealSubmissionDisabledInDevelopmentRelease'
# A reviewed canary release may replace the hard stop with Invoke-ReviewedQueueSubmission.
