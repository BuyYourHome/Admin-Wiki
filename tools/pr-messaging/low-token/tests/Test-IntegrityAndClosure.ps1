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
# Read canonical snapshots once; all closure mutations below target a fresh temp fixture.
$oldId='prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-001'
$newId='prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-002'
$original=(& $canonicalManager -Action Get -MessageId $oldId)|ConvertFrom-Json
$successor=(& $canonicalManager -Action Get -MessageId $newId)|ConvertFrom-Json
# Reconstruct only the isolated fixture's pre-closure snapshot on later test runs.
# Never remove the real canonical disposition or its audit event.
if(Test-PrAdministrativeClosure $original){
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
