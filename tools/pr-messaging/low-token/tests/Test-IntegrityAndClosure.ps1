[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$EvidenceDirectory,[string]$NameRegex='')
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Test-LowTokenWorker.ps1" -LibraryOnly -EvidenceDirectory $EvidenceDirectory -NameRegex $NameRegex
$canonicalManager=$legacy
$actor='01a05d0c-8031-7d92-9474-ab2330008ddb'
function Clone($value){$value|ConvertTo-Json -Depth 30|ConvertFrom-Json}
function ImmutableText($r){[ordered]@{source=$r.source;destination=$r.destination;authorization=$r.authorization;references=$r.references;payload=$r.payload;message_type=$r.message_type;parent_message_id=$r.parent_message_id;payload_hash=$r.payload_hash}|ConvertTo-Json -Depth 30 -Compress}
foreach($s in @('{"text":"A&B <tag> can''t \"quote\""}','{"text":"\\u0027 \\\\u003c \\"}','{"text":"line\n\t","number":1.0,"null":null,"bool":true}','{"apostrophe''key":"value","date":"2026-09-07T13:00:00.000Z"}')){
    Check ('escape token roundtrip '+$s) { $h=Convert-PrMessageJsonEscaping $s $true;Assert ((Convert-PrMessageJsonEscaping $h $false) -ceq $s);Assert (($h|ConvertFrom-Json|ConvertTo-Json -Compress) -ceq ($s|ConvertFrom-Json|ConvertTo-Json -Compress)) }
}
Check 'both legacy encodings verify and changed content fails' {
    $f=Fixture;$r=Record $f;$r.payload|Add-Member text 'A&B <tag> can''t "quote" literal \u0027'
    $e=Get-PrMessageHashEvidence $r
    foreach($hash in @($e.default_hash,$e.html_hash)){$r.payload_hash=$hash;Assert (Get-PrMessageHashEvidence $r).valid}
    $r.payload.text+='changed';Assert (!(Get-PrMessageHashEvidence $r).valid)
}
foreach($state in @('Completed','Blocked','Needs Wes','Rejected as Wrong Room')){
    Check ('verified final releases atomic destination '+$state) {
        $f=Fixture;$other=Record $f;$other.message_id='older-final';$other.state=$state;$other.attempt_count=1;$other.attempts=@(@{attempt_id='old-attempt';outcome='Delivered'})
        $other.receipt=@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME;accepted_at_utc='2026-09-01T00:00:00Z'}
        $other.result=@{state=$state;machine=$env:COMPUTERNAME;completed_at_utc='2026-09-01T00:01:00Z'}
        Write-LtJson (Join-Path $f.queue 'records\older-final.json') $other
        Assert (Test-PrMessageTerminal $other);Assert (!(Test-LtDestinationOutstanding $other));Assert (Claim $f).may_submit
    }
    Check ('own journal closes transport without changing final '+$state) {
        $f=Fixture;Tick $f|Out-Null
        & $manager -FixtureRoot $f.root -QueuePath $f.queue -Action Accept -MessageId $f.id -ActorTaskId $f.task -ActorProjectRoom 'Test Recipient'|Out-Null
        $action=switch($state){Completed{'Complete'}Blocked{'Block'}'Needs Wes'{'NeedsWes'}default{'Reject'}}
        & $manager -FixtureRoot $f.root -QueuePath $f.queue -Action $action -MessageId $f.id -ActorTaskId $f.task -ActorProjectRoom 'Test Recipient' -ResultJson '{"synthetic":true}'|Out-Null
        $h=Tick $f;Assert ($h.outstanding_attempts.Count -eq 0 -and (Record $f).state -ceq $state -and (CountSubmissions $f) -eq 1)
    }
}
foreach($fault in @('receipt','result','state','time','hash')){
    Check ('invalid terminal held '+$fault){
        $f=Fixture;$r=Record $f;$r.state='Blocked';$r.receipt=@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME;accepted_at_utc='2026-09-01T00:00:00Z'};$r.result=@{state='Blocked';machine=$env:COMPUTERNAME;completed_at_utc='2026-09-01T00:01:00Z'}
        switch($fault){receipt{$r.receipt=$null}result{$r.result=$null}state{$r.result.state='Completed'}time{$r.result.completed_at_utc='2026-08-01T00:00:00Z'}hash{$r.payload_hash='0'*64}}
        Assert (!(Test-PrMessageTerminal $r));Assert (Test-LtDestinationOutstanding $r)
    }
}
Check 'exhausted ambiguous predicate requires complete old no-receipt evidence' {
    $f=Fixture;$r=Record $f;$old=[DateTime]::UtcNow.AddMinutes(-60).ToString('o')
    $r.state='Delivery Ambiguous';$r.attempt_count=1;$r.max_attempts=1
    $r.attempts=@(@{attempt_id='ambiguous-attempt';started_at_utc=$old;completed_at_utc=$old;outcome='DeliveryAmbiguous'})
    Assert (Test-PrExhaustedAmbiguousRecord $r 30)
    foreach($fault in @('receipt','pending','unexhausted','recent')){
        $x=Clone $r
        switch($fault){
            receipt {$x.receipt=@{task_id=$f.task}}
            pending {$x.attempts[0].outcome='Pending';$x.attempts[0].completed_at_utc=$null}
            unexhausted {$x.max_attempts=2}
            recent {$x.attempts[0].completed_at_utc=[DateTime]::UtcNow.ToString('o')}
        }
        Assert (!(Test-PrExhaustedAmbiguousRecord $x 30))
    }
}
Check 'exhausted ambiguity closure releases transport without claiming delivery' {
    $f=Fixture;$r=Record $f;$old=[DateTime]::UtcNow.AddMinutes(-60).ToString('o')
    $r.state='Delivery Ambiguous';$r.attempt_count=1;$r.max_attempts=1
    $r.attempts=@(@{attempt_id='ambiguous-attempt';started_at_utc=$old;completed_at_utc=$old;outcome='DeliveryAmbiguous'})
    $immutable=ImmutableText $r
    $r|Add-Member administrative_closure ([pscustomobject][ordered]@{
        schema_version=1;message_id=$r.message_id;payload_hash=$r.payload_hash
        disposition='ExhaustedAmbiguousUndelivered';authorized_by='Wes'
        authorization_reference='Fixture authorization';actor_project_room='PR Messaging Dispatcher'
        actor_task_id=$f.source;actor_machine=$env:COMPUTERNAME
        transport_owner='low-token-fixture';transport_generation='g1';transport_owner_task_id=$f.source
        closed_at_utc=[DateTime]::UtcNow.ToString('o');delivery_claimed=$false
        business_completion_claimed=$false;detail='Administrative transport closure only.'
    })
    Assert (Test-PrAdministrativeClosure $r) 'Closure evidence was not valid.'
    Assert (!(Test-LtDestinationOutstanding $r)) 'Valid closure did not release destination.'
    Assert ((ImmutableText $r) -ceq $immutable) 'Closure changed immutable content.'
    Assert (!$r.receipt -and !$r.result -and $r.state -ceq 'Delivery Ambiguous') 'Closure claimed recipient state.'
}
function NewIntegrityFailureFixture {
    $f=Fixture;$r=Record $f
    $r.state='Completed'
    $r.receipt=[pscustomobject]@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME;accepted_at_utc='2026-09-01T00:00:00Z'}
    $r.result=[pscustomobject]@{state='Completed';machine=$env:COMPUTERNAME;completed_at_utc='2026-09-01T00:01:00Z';detail='Fixture completed before corruption was detected.'}
    $r.payload|Add-Member changed_after_creation $true
    SaveRecord $f $r
    Write-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME) @{schema_version=1;owner='low-token-fixture';generation='g1';mode='Live';machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;task_id=$f.source}
    return $f
}
function QuarantineIntegrityFixture($f,[string]$Version,[string]$Hash,[string]$Task=$f.source,[string]$Reference='Wes authorized fixture integrity quarantine') {
    & $manager -FixtureRoot $f.root -Action AdministrativeQuarantineIntegrityFailure -QueuePath $f.queue -MessageId $f.id `
        -ActorProjectRoom 'PR Messaging Dispatcher' -ActorTaskId $Task -ExpectedRecordVersion $Version -ExpectedHash $Hash `
        -TransportOwner 'low-token-fixture' -Generation 'g1' -Mode Live -AuthorizationReference $Reference `
        -Detail 'Quarantine the immutable-hash failure and release only the transport slot.'|ConvertFrom-Json
}
Check 'integrity quarantine preserves corrupt terminal record and releases transport' {
    $f=NewIntegrityFailureFixture;$before=Record $f;$immutable=ImmutableText $before
    Assert (!(Get-PrMessageHashEvidence $before).valid)
    $version=Get-PrMessageDigest ($before|ConvertTo-Json -Depth 30 -Compress)
    $r=QuarantineIntegrityFixture $f $version $before.payload_hash
    Assert (Test-PrAdministrativeClosure $r)
    Assert (!(Test-LtDestinationOutstanding $r))
    Assert ((ImmutableText $r) -ceq $immutable)
    Assert ($r.state -ceq 'Completed' -and $r.receipt -and $r.result -and $r.administrative_closure.delivery_claimed -eq $false -and $r.administrative_closure.business_completion_claimed -eq $false)
}
Check 'integrity quarantine rejects wrong actor and valid record' {
    $f=NewIntegrityFailureFixture;$r=Record $f;$version=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress);$caught=$false
    try{QuarantineIntegrityFixture $f $version $r.payload_hash '33333333-3333-4333-8333-333333333333'|Out-Null}catch{$caught=$true};Assert $caught
    $f=Fixture;$r=Record $f;$r.state='Completed';$r.receipt=@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME;accepted_at_utc='2026-09-01T00:00:00Z'};$r.result=@{state='Completed';machine=$env:COMPUTERNAME;completed_at_utc='2026-09-01T00:01:00Z'};SaveRecord $f $r
    Write-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME) @{schema_version=1;owner='low-token-fixture';generation='g1';mode='Live';machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;task_id=$f.source}
    $version=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress);$caught=$false
    try{QuarantineIntegrityFixture $f $version $r.payload_hash|Out-Null}catch{$caught=$true};Assert $caught
}
function NewAmbiguousFixture {
    $f=Fixture;$r=Record $f;$old=[DateTime]::UtcNow.AddMinutes(-60).ToString('o')
    $r.state='Delivery Ambiguous';$r.attempt_count=1;$r.max_attempts=1
    $r.attempts=@(@{attempt_id='ambiguous-attempt';started_at_utc=$old;completed_at_utc=$old;outcome='DeliveryAmbiguous';transport_owner='fixture-worker';transport_generation='g1'})
    SaveRecord $f $r
    $ownerPath=Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME
    Write-LtJson $ownerPath @{schema_version=1;owner='low-token-fixture';generation='g1';mode='Live';machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;task_id=$f.source}
    return $f
}
function CloseAmbiguousFixture($f,[string]$Version,[string]$Hash,[string]$Task,[string]$Reference='Wes authorized fixture closure') {
    & $manager -FixtureRoot $f.root -Action AdministrativeCloseExhaustedAmbiguous -QueuePath $f.queue -MessageId $f.id `
        -ActorProjectRoom 'PR Messaging Dispatcher' -ActorTaskId $Task -ExpectedRecordVersion $Version -ExpectedHash $Hash `
        -TransportOwner 'low-token-fixture' -Generation 'g1' -Mode Live -AuthorizationReference $Reference `
        -Detail 'Administrative transport closure only; no delivery or business completion claimed.'|ConvertFrom-Json
}
function NewStatusCancellationFixture {
    $f=NewAmbiguousFixture
    $r=Record $f
    $r.message_type='status'
    $r.max_attempts=3
    $old=[DateTime]::UtcNow.AddHours(-6).ToString('o')
    $r.attempts[0].started_at_utc=$old
    $r.attempts[0].completed_at_utc=$old
    $r.attempts[0].transport_owner='low-token-fixture'
    $r.authorization|Add-Member business_action_authorized $false -Force
    $r.authorization|Add-Member production_claims_authorized $false -Force
    $r.payload|Add-Member status 'Blocked' -Force
    $r.payload|Add-Member business_action_performed $false -Force
    $r.payload|Add-Member production_claims 0 -Force
    $r.payload|Add-Member forced_runs 0 -Force
    $r.payload|Add-Member live_automation_calls 0 -Force
    $r.payload_hash=(Get-PrMessageHashEvidence $r).default_hash
    SaveRecord $f $r
    return $f
}
function CancelStatusFixture($f,[string]$Version,[string]$Hash,[string]$Task,[string]$Reference='Wes explicitly cancelled the fixture status') {
    & $manager -FixtureRoot $f.root -Action AdministrativeCancelAuthorizedStatus -QueuePath $f.queue -MessageId $f.id `
        -ActorProjectRoom 'PR Messaging Dispatcher' -ActorTaskId $Task -ExpectedRecordVersion $Version -ExpectedHash $Hash `
        -TransportOwner 'low-token-fixture' -Generation 'g1' -Mode Live -AuthorizationReference $Reference `
        -Detail 'Cancel obsolete status transport only; delivery remains unresolved and no business completion is claimed.'|ConvertFrom-Json
}
function NewPreSubmissionFailureFixture {
    $f=NewAmbiguousFixture
    $r=Record $f
    $r.max_attempts=3
    $r.attempts[0]|Add-Member detail 'Submission may have happened.' -Force
    SaveRecord $f $r
    $cfg=[pscustomobject][ordered]@{
        schema_version=1;release='0.4.1';expected_machine=$env:COMPUTERNAME
        expected_sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value
        owner='low-token-fixture';generation='g1';dispatcher_task_id=$f.source
        state_directory=$f.state;destinations=@([pscustomobject]@{
            project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME
        })
    }
    $f.workerConfig=Join-Path $f.root 'worker-config.json'
    Write-LtJson $f.workerConfig $cfg
    $entry=[pscustomobject][ordered]@{
        message_id=$f.id;dispatch_id=$f.id;destination_task_id=$f.task
        payload_hash=$r.payload_hash;attempt_id='ambiguous-attempt';phase='unresolved'
        outcome='DeliveryAmbiguous';adapter_release='0.4.1'
        submission_evidence=[pscustomobject]@{
            timed_out=$false;exit_code=1;queue_acknowledged=$false
        }
    }
    Write-LtJson (Join-Path $f.state 'journal.json') ([pscustomobject][ordered]@{
        schema_version=2;machine=$env:COMPUTERNAME;sid=$cfg.expected_sid
        owner=$cfg.owner;generation=$cfg.generation;entries=@($entry)
    })
    return $f
}
function RepairPreSubmissionFixture($f,[string]$Version,[string]$Hash,[string]$Task,[string]$Reference='Wes authorized fixture repair') {
    & $manager -FixtureRoot $f.root -Action ReconcileProvenPreSubmissionFailure -QueuePath $f.queue -MessageId $f.id `
        -AttemptId 'ambiguous-attempt' -ActorProjectRoom 'PR Messaging Dispatcher' -ActorTaskId $Task `
        -ExpectedRecordVersion $Version -ExpectedHash $Hash -TransportOwner 'low-token-fixture' -Generation 'g1' `
        -Mode Live -AuthorizationReference $Reference -WorkerConfigPath $f.workerConfig `
        -Detail 'Pinned adapter exited before creating its permanent submission marker; no notification occurred.'|ConvertFrom-Json
}
Check 'manager closes only exact exhausted ambiguity and is idempotent' {
    $f=NewAmbiguousFixture;$before=Record $f;$version=Get-PrMessageDigest ($before|ConvertTo-Json -Depth 30 -Compress)
    $r=CloseAmbiguousFixture $f $version $before.payload_hash $f.source
    Assert (Test-PrAdministrativeClosure $r) 'Manager closure evidence invalid.'
    Assert (!(Test-LtDestinationOutstanding $r)) 'Manager closure did not release destination.'
    Assert ((ImmutableText $r) -ceq (ImmutableText $before)) 'Manager closure changed immutable content.'
    Assert (!$r.receipt -and !$r.result -and $r.state -ceq 'Delivery Ambiguous') 'Manager closure claimed recipient state.'
    $file=Join-Path $f.queue ('records\'+$f.id+'.json');$afterHash=(Get-FileHash $file).Hash
    CloseAmbiguousFixture $f $version $before.payload_hash $f.source|Out-Null
    Assert ((Get-FileHash $file).Hash -ceq $afterHash) 'Idempotent call rewrote record.'
    Assert (@((Record $f).events|Where-Object event -eq 'AdministrativelyClosed').Count -eq 1) 'Closure event count was not one.'
}
Check 'authorized status cancellation preserves ambiguity and rejects late acceptance' {
    $f=NewStatusCancellationFixture;$before=Record $f;$immutable=ImmutableText $before
    Assert (Test-PrAuthorizedStatusCancellationRecord $before 30) 'Fixture did not qualify for status cancellation.'
    $version=Get-PrMessageDigest ($before|ConvertTo-Json -Depth 30 -Compress)
    $r=CancelStatusFixture $f $version $before.payload_hash $f.source
    Assert (Test-PrAdministrativeClosure $r) 'Cancellation closure did not validate.'
    Assert (!(Test-LtDestinationOutstanding $r)) 'Cancellation did not release destination transport.'
    Assert ((ImmutableText $r) -ceq $immutable) 'Cancellation changed immutable content.'
    Assert ($r.state -ceq 'Delivery Ambiguous' -and !$r.receipt -and !$r.result) 'Cancellation changed ambiguous recipient state.'
    Assert ($r.administrative_closure.disposition -ceq 'AuthorizedStatusCancelled' -and
        $r.administrative_closure.delivery_status -ceq 'Unresolved' -and
        $r.administrative_closure.delivery_claimed -eq $false -and
        $r.administrative_closure.business_completion_claimed -eq $false) 'Cancellation closure claims were not fail-closed.'
    $file=Join-Path $f.queue ('records\'+$f.id+'.json');$afterHash=(Get-FileHash $file).Hash
    CancelStatusFixture $f $version $before.payload_hash $f.source|Out-Null
    Assert ((Get-FileHash $file).Hash -ceq $afterHash) 'Idempotent cancellation rewrote record.'
    $caught=$false
    try{& $manager -FixtureRoot $f.root -QueuePath $f.queue -Action Accept -MessageId $f.id -ActorTaskId $f.task -ActorProjectRoom 'Test Recipient'|Out-Null}catch{$caught=$true}
    Assert $caught 'Late acceptance of cancelled status was not rejected.'
}
foreach($fault in @('actor','version','hash','receipt','business','production','live','recent','owner','attempt-owner','authorization')){
    Check ('authorized status cancellation rejects '+$fault) {
        $f=NewStatusCancellationFixture;$r=Record $f;$task=$f.source;$reference='Wes explicitly cancelled the fixture status'
        switch($fault){
            actor {$task='33333333-3333-4333-8333-333333333333'}
            receipt {$r.receipt=@{task_id=$f.task}}
            business {$r.authorization.business_action_authorized=$true}
            production {$r.payload.production_claims=1}
            live {$r.payload.live_automation_calls=1}
            recent {$r.attempts[0].completed_at_utc=[DateTime]::UtcNow.ToString('o')}
            owner {$o=Read-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME);$o.owner='foreign';Write-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME) $o}
            'attempt-owner' {$r.attempts[0].transport_owner='foreign'}
            authorization {$reference=''}
        }
        if($fault -in @('business','production','live')){$r.payload_hash=(Get-PrMessageHashEvidence $r).default_hash}
        SaveRecord $f $r;$version=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress);$hash=$r.payload_hash
        if($fault -eq 'version'){$version='a'*64};if($fault -eq 'hash'){$hash='b'*64}
        $path=Join-Path $f.queue ('records\'+$f.id+'.json');$beforeHash=(Get-FileHash $path).Hash;$caught=$false
        try{CancelStatusFixture $f $version $hash $task $reference|Out-Null}catch{$caught=$true}
        Assert $caught;Assert ((Get-FileHash $path).Hash -ceq $beforeHash)
    }
}
foreach($fault in @('actor','version','hash','receipt','recent','owner','authorization')){
    Check ('exhausted ambiguity closure rejects '+$fault) {
        $f=NewAmbiguousFixture;$r=Record $f;$task=$f.source;$reference='Wes authorized fixture closure'
        switch($fault){
            actor {$task='33333333-3333-4333-8333-333333333333'}
            receipt {$r.receipt=@{task_id=$f.task}}
            recent {$r.attempts[0].completed_at_utc=[DateTime]::UtcNow.ToString('o')}
            owner {$o=Read-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME);$o.owner='foreign';Write-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME) $o}
            authorization {$reference=''}
        }
        SaveRecord $f $r;$version=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress);$hash=$r.payload_hash
        if($fault -eq 'version'){$version='a'*64};if($fault -eq 'hash'){$hash='b'*64}
        $path=Join-Path $f.queue ('records\'+$f.id+'.json');$before=(Get-FileHash $path).Hash;$caught=$false
        try{CloseAmbiguousFixture $f $version $hash $task $reference|Out-Null}catch{$caught=$true}
        Assert $caught;Assert ((Get-FileHash $path).Hash -ceq $before)
    }
}
Check 'manager repairs only proven marker-free pre-submission ambiguity' {
    $f=NewPreSubmissionFailureFixture;$before=Record $f
    $version=Get-PrMessageDigest ($before|ConvertTo-Json -Depth 30 -Compress)
    $r=RepairPreSubmissionFixture $f $version $before.payload_hash $f.source
    Assert ($r.state -ceq 'Queued' -and $r.attempts[0].outcome -ceq 'NotDelivered')
    Assert ($r.attempts[0].correction.reason -ceq 'ProvenPreSubmissionFailure')
    Assert (!$r.receipt -and !$r.result -and $r.attempt_count -eq 1)
    Assert ((ImmutableText $r) -ceq (ImmutableText $before)) 'Repair changed immutable content.'
    Assert (@($r.events|Where-Object event -eq 'DeliveryAmbiguityCorrected').Count -eq 1)
    $nextVersion=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress)
    $file=Join-Path $f.queue ('records\'+$f.id+'.json');$afterHash=(Get-FileHash $file).Hash
    RepairPreSubmissionFixture $f $nextVersion $r.payload_hash $f.source|Out-Null
    Assert ((Get-FileHash $file).Hash -ceq $afterHash) 'Idempotent repair rewrote record.'
}
foreach($fault in @('actor','version','hash','receipt','timeout','exit','ack','marker','owner','authorization','config')){
    Check ('pre-submission repair rejects '+$fault) {
        $f=NewPreSubmissionFailureFixture;$r=Record $f;$task=$f.source;$reference='Wes authorized fixture repair'
        switch($fault){
            actor {$task='33333333-3333-4333-8333-333333333333'}
            receipt {$r.receipt=@{task_id=$f.task}}
            timeout {$j=Read-LtJson (Join-Path $f.state 'journal.json');$j.entries[0].submission_evidence.timed_out=$true;Write-LtJson (Join-Path $f.state 'journal.json') $j}
            exit {$j=Read-LtJson (Join-Path $f.state 'journal.json');$j.entries[0].submission_evidence.exit_code=0;Write-LtJson (Join-Path $f.state 'journal.json') $j}
            ack {$j=Read-LtJson (Join-Path $f.state 'journal.json');$j.entries[0].submission_evidence.queue_acknowledged=$true;Write-LtJson (Join-Path $f.state 'journal.json') $j}
            marker {$marker=Get-LtSubmissionMarkerPath $f.state $f.id 'ambiguous-attempt';New-Item -ItemType Directory -Path (Split-Path -Parent $marker) -Force|Out-Null;Write-LtJson $marker @{submitted=$true}}
            owner {$o=Read-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME);$o.owner='foreign';Write-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME) $o}
            authorization {$reference=''}
            config {$c=Read-LtJson $f.workerConfig;$c.release='0.4.0';Write-LtJson $f.workerConfig $c}
        }
        SaveRecord $f $r;$version=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress);$hash=$r.payload_hash
        if($fault -eq 'version'){$version='a'*64};if($fault -eq 'hash'){$hash='b'*64}
        $path=Join-Path $f.queue ('records\'+$f.id+'.json');$beforeHash=(Get-FileHash $path).Hash;$caught=$false
        try{RepairPreSubmissionFixture $f $version $hash $task $reference|Out-Null}catch{$caught=$true}
        Assert $caught;Assert ((Get-FileHash $path).Hash -ceq $beforeHash)
    }
}
# Read canonical snapshots once; all closure mutations below target a fresh temp fixture.
$oldId='prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-001'
$newId='prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-002'
$original=(& $canonicalManager -Action Get -MessageId $oldId)|ConvertFrom-Json
$successor=(& $canonicalManager -Action Get -MessageId $newId)|ConvertFrom-Json
$canonicalClosureValid=Test-PrAdministrativeClosure $original
# Reconstruct only the isolated fixture's pre-closure snapshot on later test runs.
# Never remove the real canonical disposition or its audit event.
if($canonicalClosureValid){
    $original.PSObject.Properties.Remove('administrative_closure')
    $original.events=@($original.events|Where-Object event -cne 'AdministrativelyClosed')
}
$root=Join-Path ([IO.Path]::GetTempPath()) ('byh-adminclosure-'+[guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path (Join-Path $root 'records')|Out-Null
Write-LtJson (Join-Path $root '.administrative-closure-fixture') @{fixture=$true}
$oldPath=Join-Path $root ('records\'+$oldId+'.json');$newPath=Join-Path $root ('records\'+$newId+'.json')
function ResetClosureFixture{Write-LtJson $oldPath $original;Write-LtJson $newPath $successor}
function CloseFixture($Version,$Task=$actor){& $canonicalManager -Action AdministrativeCloseSuperseded -QueuePath $root -MessageId $oldId -ActorProjectRoom 'PR Messaging Dispatcher' -ActorTaskId $Task -ExpectedRecordVersion $Version|ConvertFrom-Json}
Check 'exact administrative closure preserves history and is idempotent' {
    if($env:COMPUTERNAME -cne 'WES-VIDEOEDITOR'){
        Assert $canonicalClosureValid 'Existing canonical closure lost backward compatibility.'
        return
    }
    ResetClosureFixture;$before=Read-LtJson $oldPath;$v=Get-PrMessageDigest ($before|ConvertTo-Json -Depth 30 -Compress);$r=CloseFixture $v
    Assert (Test-PrAdministrativeClosure $r);Assert (!(Test-LtDestinationOutstanding $r))
    Assert ($r.state -ceq 'Blocked' -and !$r.receipt -and !$r.result -and $r.attempt_count -eq 1)
    Assert ((ImmutableText $r) -ceq (ImmutableText $before));Assert (($r.attempts|ConvertTo-Json -Depth 10 -Compress) -ceq ($before.attempts|ConvertTo-Json -Depth 10 -Compress))
    $hash=(Get-FileHash $oldPath).Hash;CloseFixture $v|Out-Null;Assert ((Get-FileHash $oldPath).Hash -ceq $hash)
    Assert (@($r.events|Where-Object event -eq 'AdministrativelyClosed').Count -eq 1)
}
foreach($fault in @('actor','version','payload','receipt','successor','foreign-closure')){
    Check ('administrative closure rejects '+$fault){
        ResetClosureFixture;$r=Read-LtJson $oldPath;$task=$actor
        switch($fault){actor{$task='22222222-2222-4222-8222-222222222222'}payload{$r.payload_hash='a'*64}receipt{$r.receipt=@{task_id=$actor}}successor{$s=Clone $successor;$s.state='Blocked';Write-LtJson $newPath $s}'foreign-closure'{$r|Add-Member administrative_closure @{disposition='Completed'}}}
        Write-LtJson $oldPath $r;$v=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress);if($fault -eq 'version'){$v='a'*64}
        $before=(Get-FileHash $oldPath).Hash;$caught=$false;try{CloseFixture $v $task|Out-Null}catch{$caught=$true}
        Assert $caught;Assert ((Get-FileHash $oldPath).Hash -ceq $before)
    }
}
$summary=[ordered]@{completed_at_utc=[DateTime]::UtcNow.ToString('o');passed=@($results|Where-Object passed).Count;failed=@($results|Where-Object {!$_.passed}).Count;tests=$results;fixture_roots=@($roots)+@($root);canonical_writes=0;real_submissions=0}
Write-LtJson (Join-Path $EvidenceDirectory 'integrity-closure-results.json') $summary
$summary|ConvertTo-Json -Depth 8
if($summary.failed){exit 1}
