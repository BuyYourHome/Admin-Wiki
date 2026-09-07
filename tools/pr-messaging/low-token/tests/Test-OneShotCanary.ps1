[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$EvidenceDirectory)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Test-LowTokenWorker.ps1" -LibraryOnly -EvidenceDirectory $EvidenceDirectory
. "$release\Canary.Guards.ps1"
function CanaryFixture {
    $f=Fixture
    $r=Record $f
    $r.message_id=Get-LtCanaryId;$r.dispatch_id=$r.message_id
    $r.source=[pscustomobject]@{project_room='PR Messaging Dispatcher';task_id='01a05d0c-8031-7d92-9474-ab2330008ddb';machine='WES-VIDEOEDITOR'}
    $r.destination=[pscustomobject]@{project_room='Quickbooks';task_id='01a05967-9a05-7081-a62e-616b2d8e61fd';machine='WES-VIDEOEDITOR'}
    $r.authorization.instruction='authorize one real synthetic worker canary'
    $r.authorization|Add-Member submission_expires_at_utc ([DateTime]::UtcNow.AddMinutes(60).ToString('o'))
    $r.payload|Add-Member test_kind 'serialized-worker-one-shot-20260907'
    $r.payload_hash=Get-LtPayloadHash $r
    return @{f=$f;r=$r}
}
function Rejects([scriptblock]$Work,[string]$Pattern){try{& $Work;throw 'NOT_REJECTED'}catch{Assert ($_.Exception.Message -match $Pattern) $_.Exception.Message}}
Check 'canonical JSON list is enumerated by record in Windows PowerShell' {
    $r=@(ConvertFrom-LtCanaryRecordList '[{"message_id":"one","destination":{"task_id":"first"}},{"message_id":"two","destination":{"task_id":"second"}}]')
    Assert ($r.Count -eq 2 -and @($r|Where-Object {$_.destination.task_id -ceq 'second'}).Count -eq 1)
    Assert (@(ConvertFrom-LtCanaryRecordList '[]').Count -eq 0)
    Assert (@(ConvertFrom-LtCanaryRecordList '[{"message_id":"only"}]').Count -eq 1)
}
Check 'canary exact synthetic permitted by pure guard' {$x=CanaryFixture;Assert-LtCanaryRecord $x.r -ForSubmission}
foreach($case in @('id','dispatch','destination','source','machine','authority','instruction','hash','budget','business','synthetic-string','kind','expired','expiry-too-long')){
    Check ('canary rejects '+$case){
        $x=CanaryFixture;$r=$x.r
        switch($case){
            id{$r.message_id='other-test'} dispatch{$r.dispatch_id='other-test'} destination{$r.destination.task_id=$r.source.task_id}
            source{$r.source.project_room='Other'} machine{$r.destination.machine='OTHER'} authority{$r.authorization.authorized_by='Other'}
            instruction{$r.authorization.instruction='different'} hash{$r.payload_hash='a'*64} budget{$r.max_attempts=2}
            business{$r.payload.business_action_performed=$true} 'synthetic-string'{$r.payload.synthetic_test='true'}
            kind{$r.payload.test_kind='production'} expired{$r.created_at_utc=[DateTime]::UtcNow.AddMinutes(-10).ToString('o');$r.authorization.submission_expires_at_utc=[DateTime]::UtcNow.AddMinutes(-1).ToString('o')}
            'expiry-too-long'{$r.authorization.submission_expires_at_utc=[DateTime]::UtcNow.AddHours(2).ToString('o')}
        }
        if($case -ne 'hash'){$r.payload_hash=Get-LtPayloadHash $r}
        Rejects {Assert-LtCanaryRecord $r -ForSubmission} 'Canary'
    }
}
Check 'expired canary can be reconciled but never submitted' {$x=CanaryFixture;$r=$x.r;$r.created_at_utc=[DateTime]::UtcNow.AddMinutes(-10).ToString('o');$r.authorization.submission_expires_at_utc=[DateTime]::UtcNow.AddMinutes(-1).ToString('o');$r.payload_hash=Get-LtPayloadHash $r;Assert-LtCanaryRecord $r;Rejects {Assert-LtCanaryRecord $r -ForSubmission} 'CanarySubmissionExpired'}
function AdapterFixture {
    $x=CanaryFixture;$r=$x.r
    $cfg=@{owner=$r.message_id;generation='one-shot-1';payload_hash=$r.payload_hash}
    $r.state='Delivery Attempted';$r.attempt_count=1;$r.attempts=@([pscustomobject]@{attempt_id='test-attempt';outcome='Pending';transport_owner=$cfg.owner;transport_generation=$cfg.generation})
    $j=[pscustomobject]@{schema_version=2;owner=$cfg.owner;generation=$cfg.generation;entries=@([pscustomobject]@{message_id=$r.message_id;attempt_id='test-attempt';phase='submission_started';payload_hash=$r.payload_hash})}
    @{r=$r;j=$j;cfg=$cfg}
}
Check 'adapter requires exact pending claim and flushed journal phase' {$x=AdapterFixture;Assert-LtCanaryAdapterState $x.r $x.j $x.cfg 'test-attempt'}
foreach($case in @('attempt','owner','generation','outcome','receipt','count','state','journal-phase','journal-id','journal-count','journal-generation','pinned-hash')){
    Check ('adapter refuses '+$case){
        $x=AdapterFixture
        switch($case){
            attempt{$x.r.attempts[0].attempt_id='other'} owner{$x.r.attempts[0].transport_owner='other'} generation{$x.r.attempts[0].transport_generation='other'} outcome{$x.r.attempts[0].outcome='Delivered'}
            receipt{$x.r.receipt=@{task_id='other'}} count{$x.r.attempt_count=0} state{$x.r.state='Queued'}
            'journal-phase'{$x.j.entries[0].phase='claimed'} 'journal-id'{$x.j.entries[0].message_id='other'} 'journal-count'{$x.j.entries+=@($x.j.entries[0])} 'journal-generation'{$x.j.generation='other'} 'pinned-hash'{$x.cfg.payload_hash='a'*64}
        }
        Rejects {Assert-LtCanaryAdapterState $x.r $x.j $x.cfg 'test-attempt'} 'CanaryAdapter'
    }
}
Check 'durable one-shot marker refuses duplicate without overwriting' {
    $x=CanaryFixture;$p=Join-Path $x.f.root 'once.json'
    New-LtCanarySubmissionMarker $p @{attempt='first'}
    $hash=(Get-FileHash -LiteralPath $p).Hash
    Rejects {New-LtCanarySubmissionMarker $p @{attempt='second'}} 'exist'
    Assert ((Get-FileHash -LiteralPath $p).Hash -ceq $hash)
}
Check 'canonical legacy StartAttempt cannot steal exact canary' {
    $x=CanaryFixture;$r=$x.r
    Write-LtJson (Join-Path $x.f.queue ('records\'+$r.message_id+'.json')) $r
    Rejects {& $legacy -Action StartAttempt -QueuePath $x.f.queue -MessageId $r.message_id|Out-Null} 'ExactCanaryReservedForAtomicWorkerClaim'
    Assert ((Read-LtJson (Join-Path $x.f.queue ('records\'+$r.message_id+'.json'))).attempt_count -eq 0)
}
Check 'canonical conditional claim refuses noncanonical fixture even in Canary mode' {
    $x=CanaryFixture;$r=$x.r;Write-LtJson (Join-Path $x.f.queue ('records\'+$r.message_id+'.json')) $r
    Rejects {& $legacy -Action ConditionalClaim -Mode Canary -QueuePath $x.f.queue -MessageId $r.message_id|Out-Null} 'CanonicalMutationRequiresExactCanary'
}
Check 'canary mode cannot reinterpret ordinary fixture configuration' {
    $f=Fixture
    $p=Invoke-LtProcess $ps @('-NoProfile','-ExecutionPolicy','Bypass','-File',$worker,'-ConfigPath',$f.config,'-Mode','Canary','-MessageId',$f.id) 10
    $h=$p.stdout|ConvertFrom-Json;Assert ($h.status -eq 'Blocked' -and $h.claims -eq 0 -and $h.submissions -eq 0)
}
$summary=@{completed_at_utc=[DateTime]::UtcNow.ToString('o');package_sha256=(Get-LtPackageHash $release);passed=@($script:results|Where-Object passed).Count;failed=@($script:results|Where-Object {!$_.passed}).Count;tests=$script:results;fixture_roots=$script:roots}
Write-LtJson (Join-Path $EvidenceDirectory 'canary-guard-results.json') $summary
$summary|ConvertTo-Json -Depth 10
if($summary.failed){exit 1}
