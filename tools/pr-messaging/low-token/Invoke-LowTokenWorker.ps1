[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$ConfigPath,
    [ValidateSet('Shadow','Validation','Live','Drain','Paused')][string]$Mode='Shadow',
    [string]$MessageId,
    [ValidateSet('None','AfterPlan','AfterClaim','BeforeAdapter','AfterAdapter')][string]$FailurePoint='None'
)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Common.ps1"
. "$PSScriptRoot\Process.ps1"
$started=[DateTime]::UtcNow; $watch=[Diagnostics.Stopwatch]::StartNew()
$lock=$null; $cfg=$null; $journal=$null
$health=[ordered]@{schema_version=1;release='0.1.0';mode=$Mode;machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;started_at_utc=$started.ToString('o');status='Starting';queue_reachable=$false;claims=0;submissions=0;model_requests=0;reconciled=@();attention=@();candidates=@();next_tick_at_utc=$started.AddSeconds(60).ToString('o')}
function Save-Journal {
    $script:journal | Add-Member updated_at_utc ([DateTime]::UtcNow.ToString('o')) -Force
    Write-LtJson (Join-Path $cfg.state_directory 'journal.json') $script:journal
}
function New-JournalEntry($Record,[string]$AttemptId,[string]$Phase) {
    [pscustomobject]@{message_id=$Record.message_id;dispatch_id=$Record.dispatch_id;payload_hash=$Record.payload_hash;attempt_id=$AttemptId;phase=$Phase;outcome=$null;created_at_utc=[DateTime]::UtcNow.ToString('o');submission_started_at_utc=$null;submission_completed_at_utc=$null;adapter_release='0.1.0';adapter_sha256=$cfg.adapter_sha256;submission_evidence=$null}
}
function Invoke-Manager([string]$Action,[hashtable]$Extra=@{}) {
    $left=[Math]::Floor($cfg.max_tick_seconds-$watch.Elapsed.TotalSeconds)
    if ($left -le 0) { throw 'TickBudgetExhausted' }
    $argv=@('-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $PSScriptRoot 'Invoke-ManagerCommand.ps1'),'-ManagerPath',$cfg.manager_path,'-ExpectedManagerHash',$cfg.manager_sha256,'-Action',$Action,'-QueuePath',$cfg.queue_path)
    if ($Mode -in @('Validation','Drain')) {
        $argv+=@('-FixtureRoot',$cfg.fixture_root,'-TransportOwner',$cfg.owner,'-Generation',$cfg.generation,'-Mode','Validation','-ClientConfigPath',$cfg.client_path,'-ManifestDirectory',$cfg.manifest_directory,'-ActorTaskId',$cfg.dispatcher_task_id,'-ActorProjectRoom','PR Messaging Dispatcher')
    }
    foreach($k in $Extra.Keys){$argv+=@("-$k",[string]$Extra[$k])}
    $p=Invoke-LtProcess $cfg.powershell_path $argv ([Math]::Min(15,$left))
    if($p.timed_out){throw 'ManagerTimeoutUncertain'}
    if($p.exit_code -ne 0){throw ('ManagerFailed: '+$p.stderr)}
    $parsed=$p.stdout | ConvertFrom-Json
    foreach($item in $parsed){$item}
}
function Recover-Entry($Entry,$Record) {
    if (!$Record) { $health.attention+=@{message_id=$Entry.message_id;reason='JournalRecordMissing'}; return }
    if ($Record.payload_hash -cne $Entry.payload_hash -or (Get-LtPayloadHash $Record) -cne $Entry.payload_hash) { throw 'JournalHashMismatch' }
    $a=@($Record.attempts | Where-Object attempt_id -CEQ $Entry.attempt_id)
    if (!$a.Count) { $Entry.phase='closed'; $Entry.outcome='NotClaimed'; Save-Journal; return }
    if ($a.Count -ne 1) { throw 'JournalAttemptMismatch' }
    $outcome=$null; $detail=$null
    if (Test-LtReceipt $Record) { $outcome='DeliveryAmbiguous'; $detail='Receipt reconciliation takes precedence' }
    elseif ($Record.receipt -or $Record.result) { $health.attention+=@{message_id=$Entry.message_id;reason='RecipientStateRequiresReview'}; return }
    elseif ($a[0].outcome -ne 'Pending') { $Entry.phase='closed'; $Entry.outcome=$a[0].outcome; Save-Journal; return }
    elseif ($Entry.phase -in @('planned','claimed')) { $outcome='NotDelivered'; $detail='Journal proves submission-start marker was never written; do not submit recovered attempt.' }
    elseif (([DateTime]::UtcNow-[DateTime]::Parse($a[0].started_at_utc).ToUniversalTime()).TotalSeconds -ge $cfg.acceptance_deadline_seconds) { $outcome='DeliveryAmbiguous'; $detail='Submission may have occurred; no exact receipt at deadline. Never resubmit this attempt.' }
    else { $health.attention+=@{message_id=$Entry.message_id;reason='AwaitingReceipt'}; return }
    $answer=Invoke-Manager 'ReconcileAttempt' @{MessageId=$Entry.message_id;ExpectedHash=$Entry.payload_hash;AttemptId=$Entry.attempt_id;AttemptOutcome=$outcome;Detail=$detail}
    $Entry.phase='closed'; $Entry.outcome=$answer.outcome; Save-Journal
    $health.reconciled+=@{message_id=$Entry.message_id;outcome=$answer.outcome}
}
try {
    $cfg=Read-LtJson $ConfigPath
    if ($cfg.schema_version -ne 1 -or $cfg.release -cne '0.1.0') { throw 'UnsupportedConfigRelease' }
    if((Get-LtPackageHash $PSScriptRoot) -cne $cfg.package_sha256){throw 'PackageReleaseMismatch'}
    if($cfg.expected_machine -cne $env:COMPUTERNAME -or $cfg.expected_sid -cne $health.sid){throw 'WorkerIdentityMismatch'}
    if ($cfg.max_tick_seconds -lt 5 -or $cfg.max_tick_seconds -gt 55 -or $cfg.acceptance_deadline_seconds -lt 1 -or $cfg.acceptance_deadline_seconds -gt 120) { throw 'InvalidTimeBounds' }
    Assert-LtUuid $cfg.dispatcher_task_id
    if($Mode -eq 'Live'){throw 'LiveDisabledInDevelopmentRelease'}
    if($PSBoundParameters.ContainsKey('MessageId')){Assert-LtId $MessageId}
    if($Mode -eq 'Validation' -and [string]::IsNullOrWhiteSpace($MessageId)){throw 'ValidationFilterRequired'}
    if($Mode -in @('Validation','Drain')){
        Assert-LtFixture $cfg.fixture_root @($cfg.queue_path,$cfg.state_directory,$cfg.client_path,$cfg.manifest_directory,$cfg.adapter_path)
        if($cfg.adapter_kind -cne 'Fixture'){throw 'RealAdapterDisabledInDevelopmentRelease'}
        if($Mode -eq 'Validation' -and $cfg.validation_message_id -cne $MessageId){throw 'ValidationConfigMismatch'}
    } elseif($FailurePoint -ne 'None') { throw 'FailureInjectionRequiresFixture' }
    if($Mode -eq 'Shadow' -and !$cfg.fixture_root){
        if($cfg.manager_path -cne 'C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1' -or $cfg.queue_path -cne '\\WES-VIDEOEDITOR\BYH-PRMessaging$'){throw 'ShadowCanonicalManagerRequired'}
        Assert-LtUnder $cfg.state_directory (Join-Path $env:LOCALAPPDATA 'BuyYourHome\PRMessaging\low-token')
    }
    if ((Get-FileHash -LiteralPath $cfg.manager_path).Hash -ine $cfg.manager_sha256){throw 'ManagerReleaseMismatch'}
    if (!(Test-Path -LiteralPath $cfg.state_directory)){New-Item -ItemType Directory -Path $cfg.state_directory -Force|Out-Null}
    try{$lock=[IO.File]::Open((Join-Path $cfg.state_directory 'worker.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)}catch{throw 'WorkerAlreadyRunning'}
    $health.config_sha256=(Get-FileHash -LiteralPath $ConfigPath).Hash
    if($Mode -eq 'Paused'){$health.status='Paused';return}
    $records=@(Invoke-Manager 'List'); $health.queue_reachable=$true
    $client=Read-LtJson $cfg.client_path
    $manifests=@(Get-ChildItem -LiteralPath $cfg.manifest_directory -Filter '*.json' -File|ForEach-Object{Read-LtJson $_.FullName})
    $configurationHash=Get-LtConfigHash $client $manifests
    if($Mode -in @('Validation','Drain')){
        $jp=Join-Path $cfg.state_directory 'journal.json'
        if(Test-Path -LiteralPath $jp){$journal=Read-LtJson $jp}else{$journal=[pscustomobject]@{schema_version=1;machine=$env:COMPUTERNAME;sid=$health.sid;owner=$cfg.owner;generation=$cfg.generation;created_at_utc=[DateTime]::UtcNow.ToString('o');entries=@()}}
        if($journal.schema_version -ne 1 -or $journal.machine -cne $env:COMPUTERNAME -or $journal.sid -cne $health.sid -or $journal.owner -cne $cfg.owner -or $journal.generation -cne $cfg.generation -or $null -eq $journal.entries){throw 'JournalIdentityOrSchemaMismatch'}
        $keys=@{};foreach($entry in @($journal.entries)){if($entry.phase -notin @('planned','claimed','submission_started','submitted','closed') -or $keys.ContainsKey($entry.attempt_id)){throw 'JournalCorrupt'};$keys[$entry.attempt_id]=$true}
        foreach($entry in @($journal.entries)){
            if($entry.phase -eq 'closed'){
                $late=@($records|Where-Object message_id -CEQ $entry.message_id)
                if($entry.outcome -eq 'Delivered' -or $late.Count -ne 1 -or !(Test-LtReceipt $late[0])){continue}
            }
            if($watch.Elapsed.TotalSeconds -gt $cfg.max_tick_seconds-5){throw 'TickBudgetExhausted'}
            $match=@($records|Where-Object message_id -CEQ $entry.message_id)
            if($match.Count -gt 1){throw 'DuplicateRecord'}
            Recover-Entry $entry ($match|Select-Object -First 1)
        }
        foreach($r in $records){foreach($a in @($r.attempts|Where-Object {$_.outcome -eq 'Pending' -and $_.transport_owner -ceq $cfg.owner})){
            if(!@($journal.entries|Where-Object attempt_id -CEQ $a.attempt_id).Count){
                $health.attention+=@{message_id=$r.message_id;reason='UnjournaledPendingAttempt'}
                # Unknown journal is uncertainty, never proof that submission did not happen.
                $entry=New-JournalEntry $r $a.attempt_id 'submission_started'
                $journal.entries+=@($entry);Save-Journal;Recover-Entry $entry $r
            }
        }}
        $records=@(Invoke-Manager 'List')
    }
    $scoped=@(if($MessageId){$records|Where-Object message_id -CEQ $MessageId}else{$records|Where-Object {$_.destination.machine -ceq $env:COMPUTERNAME -and $_.state -in @('Queued','Delivery Ambiguous')}})
    if($MessageId -and $scoped.Count -ne 1){$health.attention+=@{message_id=$MessageId;reason='MissingOrDuplicateTarget'}}
    foreach($r in @($scoped|Sort-Object created_at_utc,message_id)){
        $evaluationMode=if($Mode -eq 'Validation'){'Validation'}else{'Shadow'}
        $reason=Test-LtRecord $r $client $manifests $env:COMPUTERNAME $evaluationMode $MessageId $records
        if($r.destination.task_id -ceq $cfg.dispatcher_task_id){$reason='SelfNotificationForbidden'}
        $health.candidates+=@{message_id=$r.message_id;state=$r.state;reason=$reason}
        if($Mode -ne 'Validation' -or $reason -cne 'Eligible' -or $health.claims -ge 1){continue}
        if($watch.Elapsed.TotalSeconds -gt $cfg.max_tick_seconds-20){throw 'TickBudgetExhausted'}
        if((Get-FileHash -LiteralPath $cfg.adapter_path).Hash -ine $cfg.adapter_sha256){throw 'AdapterReleaseMismatch'}
        # Fixture busy inventory stands in for a future validated read-only desktop busy probe.
        $busy=Read-LtJson $cfg.busy_tasks_path
        if($r.destination.task_id -cin @($busy.task_ids)){$health.attention+=@{message_id=$r.message_id;reason='DestinationBusy'};continue}
        $entry=New-JournalEntry $r ('lt-'+[guid]::NewGuid().ToString('N')) 'planned'
        $journal.entries+=@($entry);Save-Journal
        if($FailurePoint -eq 'AfterPlan'){throw 'InjectedAfterPlan'}
        $claim=Invoke-Manager 'ConditionalClaim' @{MessageId=$r.message_id;ExpectedHash=$r.payload_hash;ExpectedVersion=(Get-LtVersion $r);ExpectedConfigHash=$configurationHash;AttemptId=$entry.attempt_id}
        if(!$claim.claimed){$entry.phase='closed';$entry.outcome=$claim.reason;Save-Journal;continue}
        $health.claims++
        if($FailurePoint -eq 'AfterClaim'){throw 'InjectedAfterClaim'}
        if(!$claim.may_submit){$entry.phase='submission_started';Save-Journal;continue}
        $entry.phase='claimed';Save-Journal
        if((Get-LtPackageHash $PSScriptRoot) -cne $cfg.package_sha256 -or (Get-FileHash -LiteralPath $cfg.adapter_path).Hash -ine $cfg.adapter_sha256){throw 'ReleaseChangedBeforeSubmission'}
        $entry.phase='submission_started';$entry.submission_started_at_utc=[DateTime]::UtcNow.ToString('o');Save-Journal
        if($FailurePoint -eq 'BeforeAdapter'){throw 'InjectedBeforeAdapter'}
        $argv=@('-NoProfile','-ExecutionPolicy','Bypass','-File',$cfg.adapter_path,'-FixtureRoot',$cfg.fixture_root,'-MessageId',$r.message_id,'-ThreadId',$r.destination.task_id,'-AttemptId',$entry.attempt_id)
        $health.submissions++
        $answer=Invoke-LtProcess $cfg.powershell_path $argv ([Math]::Min(10,[Math]::Max(1,[int]($cfg.max_tick_seconds-$watch.Elapsed.TotalSeconds))))
        if($FailurePoint -eq 'AfterAdapter'){throw 'InjectedAfterAdapter'}
        # Any exit after submission began is uncertain, including nonzero and timeout.
        $entry.phase='submitted'; $entry.outcome=if($answer.timed_out){'AdapterTimeout'}elseif($answer.exit_code -ne 0){'AdapterError'}else{'SubmittedNotAccepted'}
        $entry.submission_completed_at_utc=[DateTime]::UtcNow.ToString('o')
        $entry.submission_evidence=@{timed_out=$answer.timed_out;exit_code=$answer.exit_code;stdout_sha256=(Get-LtSha256 $answer.stdout);stderr_sha256=(Get-LtSha256 $answer.stderr);accepted=$false}
        Save-Journal
        $health.attention+=@{message_id=$r.message_id;reason=$entry.outcome}
    }
    $health.status=if($Mode -eq 'Shadow'){'ShadowComplete'}elseif($Mode -eq 'Drain'){'DrainComplete'}else{'TickComplete'}
}catch{
    $health.status='Blocked';$health.error=$_.Exception.Message
}finally{
    if($journal){$health.outstanding_attempts=@($journal.entries|Where-Object phase -ne 'closed'|ForEach-Object{@{message_id=$_.message_id;attempt_id=$_.attempt_id;phase=$_.phase;acceptance_deadline_seconds=$cfg.acceptance_deadline_seconds}})}
    $health.completed_at_utc=[DateTime]::UtcNow.ToString('o');$health.elapsed_ms=$watch.ElapsedMilliseconds
    if($cfg -and $lock){try{Write-LtJson (Join-Path $cfg.state_directory 'health.json') $health}catch{$health.health_write_error=$_.Exception.Message}}
    if($lock){$lock.Dispose()}
    $health|ConvertTo-Json -Depth 15
}
