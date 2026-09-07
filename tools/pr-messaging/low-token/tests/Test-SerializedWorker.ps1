[CmdletBinding()]
param([string]$EvidenceDirectory,[string]$NameFilter='*',[string]$NameRegex='')
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Test-LowTokenWorker.ps1" -LibraryOnly -NameFilter $NameFilter -NameRegex $NameRegex -EvidenceDirectory $EvidenceDirectory
$script:processChecks=@()
function LaunchTick($f,[string]$Pause='None') {
    Assert-LtFixture $f.root @($f.config,$f.state,$f.queue)
    $argv=@('-NoProfile','-ExecutionPolicy','Bypass','-File',$worker,'-ConfigPath',$f.config,'-Mode','Validation','-MessageId',$f.id,'-CrashTestPauseAt',$Pause)
    $psi=[Diagnostics.ProcessStartInfo]::new()
    $psi.FileName=$ps;$psi.Arguments=($argv|ForEach-Object{ConvertTo-LtWindowsArgument $_}) -join ' '
    $psi.UseShellExecute=$false;$psi.CreateNoWindow=$true;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
    $p=[Diagnostics.Process]::new();$p.StartInfo=$psi
    $p.Start()|Out-Null
    @{p=$p;out=$p.StandardOutput.ReadToEndAsync();err=$p.StandardError.ReadToEndAsync();started=[DateTime]::UtcNow.ToString('o')}
}
function FinishTick($child) {
    try {
        Assert ($child.p.WaitForExit(55000)) 'Fixture worker exceeded bound'
        $stdout=$child.out.GetAwaiter().GetResult();$stderr=$child.err.GetAwaiter().GetResult()
        Assert ($child.p.ExitCode -eq 0) $stderr
        $stdout|ConvertFrom-Json
    } finally {
        if(!$child.p.HasExited){$child.p.Kill();$child.p.WaitForExit(2000)|Out-Null}
        $child.p.Dispose()
    }
}
function AcceptFixture($f,[switch]$Complete) {
    & $manager -FixtureRoot $f.root -Action Accept -QueuePath $f.queue -MessageId $f.id -ActorTaskId $f.task -ActorProjectRoom 'Test Recipient'|Out-Null
    & $manager -FixtureRoot $f.root -Action StartProcessing -QueuePath $f.queue -MessageId $f.id -ActorTaskId $f.task -ActorProjectRoom 'Test Recipient'|Out-Null
    if($Complete){& $manager -FixtureRoot $f.root -Action Complete -QueuePath $f.queue -MessageId $f.id -ActorTaskId $f.task -ActorProjectRoom 'Test Recipient' -ResultJson '{"fixture":true,"execution_count":1}'|Out-Null}
}
function OtherRecord($f,[string]$State='Processing') {
    $r=Record $f
    $r.message_id='other-synthetic-002';$r.dispatch_id=$r.message_id;$r.state=$State
    $r.attempt_count=1;$r.attempts=@([pscustomobject]@{attempt_id='other-attempt';outcome='Delivered';started_at_utc=[DateTime]::UtcNow.AddMinutes(-10).ToString('o');completed_at_utc=[DateTime]::UtcNow.AddMinutes(-9).ToString('o')})
    $r.receipt=[pscustomobject]@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME;accepted_at_utc=[DateTime]::UtcNow.AddMinutes(-9).ToString('o')}
    $r.result=$null
    if($State -eq 'Completed'){$r.result=[pscustomobject]@{state='Completed';machine=$env:COMPUTERNAME;completed_at_utc=[DateTime]::UtcNow.AddMinutes(-1).ToString('o')}}
    if($State -eq 'Delivery Ambiguous'){$r.receipt=$null;$r.attempts[0].outcome='DeliveryAmbiguous'}
    $r
}
function SaveOther($f,$r) {Write-LtJson (Join-Path $f.queue ('records\'+$r.message_id+'.json')) $r}

foreach($point in @('AfterPlan','AfterClaim','BeforeAdapter','AfterAdapter')) {
    Check ('hard process termination and restart '+$point) {
        $f=Fixture;$child=LaunchTick $f $point;$pidUnderTest=$child.p.Id
        $marker=Join-Path $f.state 'crash-ready.json'
        try {
            $watch=[Diagnostics.Stopwatch]::StartNew()
            while(!(Test-Path -LiteralPath $marker) -and !$child.p.HasExited -and $watch.Elapsed.TotalSeconds -lt 20){Start-Sleep -Milliseconds 100}
            Assert (Test-Path -LiteralPath $marker) 'Crash rendezvous absent'
            $ready=Read-LtJson $marker
            Assert ($ready.pid -eq $pidUnderTest -and $ready.point -eq $point) 'Wrong process rendezvous'
            $child.p.Kill();Assert ($child.p.WaitForExit(3000)) 'Fixture worker did not terminate'
            $exitResult=$child.p.ExitCode
        } finally {
            if(!$child.p.HasExited){$child.p.Kill();$child.p.WaitForExit(2000)|Out-Null}
            $child.p.Dispose()
        }
        $after=Tick $f;Tick $f|Out-Null
        $expected=if($point -in @('AfterPlan','AfterAdapter')){1}else{0}
        Assert ((CountSubmissions $f) -eq $expected) 'Recovery duplicated or unexpectedly submitted'
        if($point -in @('BeforeAdapter','AfterAdapter')){Assert ((Record $f).state -eq 'Delivery Ambiguous')}
        if($point -eq 'AfterClaim'){Assert ((Record $f).state -eq 'Queued')}
        $script:processChecks+=@{test=$point;pid=$pidUnderTest;started_at_utc=$child.started;terminated_exit_code=$exitResult;recovered_at_utc=[DateTime]::UtcNow.ToString('o');submissions=(CountSubmissions $f);state=(Record $f).state}
    }
}
foreach($separateState in @($false,$true)) {
    Check ('concurrent workers one submission separate_state='+$separateState) {
        $f=Fixture;Write-LtJson (Join-Path $f.root 'adapter-control.json') @{behavior='delay'}
        $f2=$f.Clone()
        if($separateState){
            $f2.state=Join-Path $f.root 'state-2';New-Item -ItemType Directory -Path $f2.state|Out-Null
            $f2.config=Join-Path $f.root 'config-2.json';$c=Read-LtJson $f.config;$c.state_directory=$f2.state;Write-LtJson $f2.config $c
        }
        $one=LaunchTick $f;$two=LaunchTick $f2
        $ids=@($one.p.Id,$two.p.Id)
        $a=FinishTick $one;$b=FinishTick $two
        Assert (($a.submissions+$b.submissions) -eq 1) 'Concurrent submissions exceeded one'
        Assert ((CountSubmissions $f) -eq 1 -and (Record $f).attempt_count -eq 1)
        $again=Tick $f;$again2=Tick $f2
        Assert ($again.status -eq 'TickComplete' -and $again2.status -eq 'TickComplete') 'Race loser could not reconcile safely'
        Assert ((CountSubmissions $f) -eq 1) 'Concurrent restart replayed'
        $script:processChecks+=@{test='concurrent';separate_state=$separateState;pids=$ids;worker_status=@($a.status,$b.status);worker_error=@($a.error,$b.error);submissions=(CountSubmissions $f);at_utc=[DateTime]::UtcNow.ToString('o')}
    }
}
Check 'delayed queued receipt warns without failure or slot release' {
    $f=Fixture;Tick $f|Out-Null;$r=Record $f
    $r.attempts[0].started_at_utc=[DateTime]::UtcNow.AddMinutes(-20).ToString('o');SaveRecord $f $r
    $h=Tick $f
    Assert ((Record $f).state -eq 'Delivery Attempted' -and $h.attention[0].reason -eq 'QueuedReceiptOverdue')
    Assert ($h.outstanding_attempts.Count -eq 1 -and (CountSubmissions $f) -eq 1)
}
Check 'acceptance retains slot until verified completion' {
    $f=Fixture;Tick $f|Out-Null;AcceptFixture $f;$h=Tick $f
    Assert ($h.outstanding_attempts[0].phase -eq 'awaiting_completion' -and (Record $f).attempts[0].outcome -eq 'Delivered')
    & $manager -FixtureRoot $f.root -Action Complete -QueuePath $f.queue -MessageId $f.id -ActorTaskId $f.task -ResultJson '{"fixture":true}'|Out-Null
    $h=Tick $f;Assert ($h.outstanding_attempts.Count -eq 0 -and (CountSubmissions $f) -eq 1)
}
foreach($state in @('Accepted','Processing','Delivery Ambiguous','Blocked','Needs Wes','Rejected as Wrong Room')) {
    Check ('atomic claim holds other same-destination '+$state) {
        $f=Fixture;$other=OtherRecord $f $state;SaveOther $f $other
        Assert ((Claim $f).reason -eq 'DestinationOutstanding')
        Assert ((Record $f).attempt_count -eq 0)
    }
}
Check 'completed other message releases destination and submits next once' {
    $f=Fixture;SaveOther $f (OtherRecord $f 'Processing');Assert ((Tick $f).claims -eq 0)
    SaveOther $f (OtherRecord $f 'Completed');Assert ((Tick $f).submissions -eq 1);Tick $f|Out-Null;Assert ((CountSubmissions $f) -eq 1)
}
Check 'other destination does not block target' {
    $f=Fixture;$other=OtherRecord $f;$other.destination.task_id='33333333-3333-4333-8333-333333333333';$other.payload_hash=Get-LtPayloadHash $other;SaveOther $f $other
    Assert ((Tick $f).submissions -eq 1)
}
foreach($fault in @('wrong-receipt','wrong-result-machine','missing-result','bad-time','hash')) {
    Check ('invalid completion retains destination '+$fault) {
        $f=Fixture;$other=OtherRecord $f 'Completed'
        switch($fault){
            wrong-receipt {$other.receipt.task_id=$f.source}
            wrong-result-machine {$other.result.machine='OTHER'}
            missing-result {$other.result=$null}
            bad-time {$other.result.completed_at_utc='invalid'}
            hash {$other.payload_hash='f'*64}
        }
        SaveOther $f $other;Assert ((Claim $f).reason -eq 'DestinationOutstanding')
    }
}
foreach($behavior in @('error','timeout','malformed','wrong-target')) {
    Check ('uncertain adapter retains slot and never retries '+$behavior) {
        $f=Fixture;Write-LtJson (Join-Path $f.root 'adapter-control.json') @{behavior=$behavior}
        Tick $f|Out-Null;$h=Tick $f;Tick $f|Out-Null
        Assert ((CountSubmissions $f) -eq 1 -and (Record $f).state -eq 'Delivery Ambiguous' -and $h.outstanding_attempts[0].phase -eq 'unresolved')
        AcceptFixture $f -Complete;$h=Tick $f
        Assert ((Record $f).attempts[0].outcome -eq 'Delivered' -and $h.outstanding_attempts.Count -eq 0 -and (CountSubmissions $f) -eq 1)
    }
}
Check 'queue outage after submission preserves journal and does not replay' {
    $f=Fixture;Tick $f|Out-Null;$journalPath=Join-Path $f.state 'journal.json';$digest=(Get-FileHash $journalPath).Hash
    $offline=Join-Path $f.root 'offline-queue';Assert-LtUnder $f.queue $f.root;Assert-LtUnder $offline $f.root
    Move-Item -LiteralPath $f.queue -Destination $offline
    try {$h=Tick $f;Assert ($h.status -eq 'Blocked' -and $h.submissions -eq 0 -and (Get-FileHash $journalPath).Hash -eq $digest)}
    finally {Move-Item -LiteralPath $offline -Destination $f.queue}
    Tick $f|Out-Null;AcceptFixture $f -Complete;Tick $f|Out-Null
    Assert ((CountSubmissions $f) -eq 1 -and (Record $f).state -eq 'Completed')
}
Check 'queue lock outage is bounded and restart submits at most once' {
    $f=Fixture;$lock=[IO.File]::Open((Join-Path $f.queue '.queue.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
    try {$h=Tick $f;Assert ($h.status -eq 'Blocked' -and $h.submissions -eq 0 -and $h.elapsed_ms -lt 55000)}finally{$lock.Dispose()}
    Tick $f|Out-Null;Tick $f|Out-Null;Assert ((CountSubmissions $f) -le 1 -and (Record $f).attempt_count -le 1)
}
Check 'lost journal after ambiguous submission reconstructs hold' {
    $f=Fixture;Write-LtJson (Join-Path $f.root 'adapter-control.json') @{behavior='error'};Tick $f|Out-Null;Tick $f|Out-Null
    $jp=Join-Path $f.state 'journal.json';Assert-LtUnder $jp $f.root;Remove-Item -LiteralPath $jp
    $h=Tick $f;Assert ($h.outstanding_attempts[0].phase -eq 'unresolved' -and (CountSubmissions $f) -eq 1)
}
Check 'lost journal after acceptance reconstructs completion hold' {
    $f=Fixture;Tick $f|Out-Null;AcceptFixture $f
    $jp=Join-Path $f.state 'journal.json';Assert-LtUnder $jp $f.root;Remove-Item -LiteralPath $jp
    $h=Tick $f;Assert ($h.outstanding_attempts[0].phase -eq 'awaiting_completion' -and (CountSubmissions $f) -eq 1)
}
Check 'restored stale queue cannot replay journaled submission' {
    $f=Fixture;$before=Record $f;Tick $f|Out-Null;SaveRecord $f $before
    $h=Tick $f;Assert ($h.error -eq 'JournalAttemptMissing' -and $h.submissions -eq 0 -and (CountSubmissions $f) -eq 1)
}
Check 'missing canonical record blocks instead of releasing journal slot' {
    $f=Fixture;Tick $f|Out-Null;$rp=Join-Path $f.queue ('records\'+$f.id+'.json');Assert-LtUnder $rp $f.root;Remove-Item -LiteralPath $rp
    $h=Tick $f;Assert ($h.error -eq 'JournalRecordMissing' -and (CountSubmissions $f) -eq 1)
}
Check 'old journal schema fails closed and is preserved' {
    $f=Fixture;Tick $f|Out-Null;$jp=Join-Path $f.state 'journal.json';$j=Read-LtJson $jp;$j.schema_version=1;Write-LtJson $jp $j;$hash=(Get-FileHash $jp).Hash
    $h=Tick $f;Assert ($h.error -eq 'JournalIdentityOrSchemaMismatch' -and (Get-FileHash $jp).Hash -eq $hash -and (CountSubmissions $f) -eq 1)
}
Check 'repeated completion receipt and restart do not duplicate lifecycle' {
    $f=Fixture;Tick $f|Out-Null;AcceptFixture $f -Complete
    & $manager -FixtureRoot $f.root -Action Accept -QueuePath $f.queue -MessageId $f.id -ActorTaskId $f.task|Out-Null
    1..3|ForEach-Object{Tick $f|Out-Null};$r=Record $f
    Assert ((CountSubmissions $f) -eq 1 -and @($r.events|Where-Object event -eq 'Accepted').Count -eq 1 -and @($r.events|Where-Object event -eq 'FinalResult').Count -eq 1)
}
Check 'uncertain target cannot retry even with larger historical budget' {
    $f=Fixture;$r=Record $f;$r.max_attempts=3;$r.state='Delivery Ambiguous';$r.attempt_count=1
    $r.attempts=@([pscustomobject]@{attempt_id='older-attempt';outcome='DeliveryAmbiguous';started_at_utc=[DateTime]::UtcNow.AddHours(-2).ToString('o');completed_at_utc=[DateTime]::UtcNow.AddHours(-1).ToString('o')})
    $r.payload_hash=Get-LtPayloadHash $r
    Assert ((Test-LtRecord $r (Read-LtJson $f.client) @((Read-LtJson (Join-Path $f.manifests 'test.json'))) $env:COMPUTERNAME 'Shadow' '' @()) -eq 'SubmissionUnresolved')
}
Check 'journaled claim denial recovers without an invented attempt' {
    $f=Fixture;$h=Tick $f Validation AfterPlan;$jp=Join-Path $f.state 'journal.json';$j=Read-LtJson $jp
    $j.entries[0].phase='closed';$j.entries[0].outcome='NotClaimed';Write-LtJson $jp $j
    Assert ((Tick $f).submissions -eq 1);Tick $f|Out-Null;Assert ((CountSubmissions $f) -eq 1)
}
$summary=[ordered]@{release='0.2.0';completed_at_utc=[DateTime]::UtcNow.ToString('o');passed=@($results|Where-Object passed -eq $true).Count;failed=@($results|Where-Object passed -eq $false).Count;tests=$results;process_evidence=$processChecks;fixture_roots=$roots;production_actions=0;real_cli_submissions=0;actual_machine_reboots=0;live_network_changes=0}
if($EvidenceDirectory){Write-LtJson (Join-Path $EvidenceDirectory 'serialized-results.json') $summary}
$summary|ConvertTo-Json -Depth 10
if($summary.failed){exit 1}
