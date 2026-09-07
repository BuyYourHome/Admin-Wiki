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
    [string]$CanaryConfigPath
)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Common.ps1"
. "$PSScriptRoot\Process.ps1"
Assert-LtUuid $ThreadId; Assert-LtUuid $DispatcherTaskId; Assert-LtId $MessageId
if ($ThreadId -ceq $DispatcherTaskId) { throw 'SelfNotificationForbidden' }
if ($PayloadHash -cnotmatch '^[0-9a-f]{64}$') { throw 'InvalidPayloadHash' }
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
# Hard safety barrier for development release. Remove only in a reviewed canary release.
throw 'RealSubmissionDisabledInDevelopmentRelease'
# A reviewed canary release may replace the hard stop with Invoke-ReviewedQueueSubmission.
