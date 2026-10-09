[CmdletBinding()]
param([string]$EvidenceDirectory,[string]$ChildFixture,[switch]$WaitForStart)
$ErrorActionPreference='Stop'
$enrollmentEvidenceDirectory=$EvidenceDirectory
. "$PSScriptRoot\Test-LowTokenWorker.ps1" -LibraryOnly
. "$PSScriptRoot\..\installer\Enrollment.ps1"

function EnrollmentArgs([string]$Root){
    Assert-LtFixture $Root @((Join-Path $Root 'enrollment-args.json'))
    $a=Read-LtJson (Join-Path $Root 'enrollment-args.json')
    $p=@{};foreach($prop in $a.PSObject.Properties){$p[$prop.Name]=$prop.Value}
    $schedulePath=Join-Path $Root 'schedule.json'
    $p.GetScheduleEvidence={Read-LtJson $schedulePath}.GetNewClosure()
    $p.ReadValidationRecord={param($c,$id) Read-LtJson (Join-Path $c.queue_path ('records\'+$id+'.json'))}
    return $p
}
if($ChildFixture){
    $a=EnrollmentArgs $ChildFixture
    if($WaitForStart){
        [IO.File]::WriteAllText((Join-Path $ChildFixture ('ready-'+$PID)), 'ready')
        $deadline=[DateTime]::UtcNow.AddSeconds(20)
        while(!(Test-Path -LiteralPath (Join-Path $ChildFixture 'start')) -and [DateTime]::UtcNow -lt $deadline){Start-Sleep -Milliseconds 50}
        if(!(Test-Path -LiteralPath (Join-Path $ChildFixture 'start'))){throw 'FixtureStartTimeout'}
        $a.ReadValidationRecord={param($c,$id) Start-Sleep -Milliseconds 500;Read-LtJson (Join-Path $c.queue_path ('records\'+$id+'.json'))}
    }
    try{Invoke-LtValidationEnrollment @a|ConvertTo-Json -Compress}catch{[pscustomobject]@{error=$_.Exception.Message}|ConvertTo-Json -Compress}
    return
}
function EnrollmentFixture {
    $f=Fixture
    $pkg=Join-Path $f.root 'package\low-token';New-Item -ItemType Directory -Path $pkg -Force|Out-Null
    Copy-Item -LiteralPath "$PSScriptRoot\..\..\Message-Integrity.ps1" -Destination (Join-Path $f.root 'package\Message-Integrity.ps1')
    Copy-Item -LiteralPath (Join-Path $f.root 'FakeAdapter.ps1') -Destination (Join-Path $pkg 'FakeAdapter.ps1')
    $cli=Join-Path $f.root 'fixture-cli.exe';[IO.File]::WriteAllBytes($cli,[byte[]](1,2,3))
    $r=Record $f;$r.source.machine='WES-VIDEOEDITOR';$r.payload_hash=Get-LtPayloadHash $r;SaveRecord $f $r
    $manifest=Read-LtJson (Join-Path $f.manifests 'test.json')
    $manifest|Add-Member schema_version 2
    $manifest.dispatchable=$false;$manifest.messaging_readiness.status='validation_ready'
    $manifest.messaging_readiness|Add-Member dispatcher_task_id $f.source
    $manifest.messaging_readiness|Add-Member cross_machine_source 'WES-VIDEOEDITOR'
    Write-LtJson (Join-Path $f.manifests 'test.json') $manifest
    $cfg=Read-LtJson $f.config;$cfg.release='0.4.7';$cfg.adapter_kind='CodexQueue'
    $cfg.adapter_path=Join-Path $pkg 'FakeAdapter.ps1';$cfg.adapter_sha256=(Get-FileHash $cfg.adapter_path).Hash
    $cfg|Add-Member cli_path $cli;$cfg|Add-Member cli_sha256 (Get-FileHash $cli).Hash
    $cfg|Add-Member destinations @(@{project_room='Existing A';task_id='33333333-3333-4333-8333-333333333333';machine=$env:COMPUTERNAME},@{project_room='Existing B';task_id='44444444-4444-4444-8444-444444444444';machine=$env:COMPUTERNAME})
    $cfg.package_sha256=Get-LtPackageHash $pkg;$f.config=Join-Path $pkg 'config.json';Write-LtJson $f.config $cfg
    $ownerPath=Join-Path $f.queue '.transport-owner.json';$o=Read-LtJson $ownerPath;$o.mode='Live';Write-LtJson $ownerPath $o
    Write-LtJson (Join-Path $f.state 'journal.json') @{schema_version=2;machine=$env:COMPUTERNAME;sid=$o.sid;owner=$o.owner;generation=$o.generation;entries=@(@{destination_task_id='33333333-3333-4333-8333-333333333333';phase='closed';message_id='old-evidence'})}
    Write-LtJson (Join-Path $f.root 'schedule.json') @{enabled=$true;principal_sid=$o.sid;actions=@(@{execute='fixture-wscript.exe';arguments='exact hidden Live action'});snapshot_hash='unchanged-schedule'}
    $args=[ordered]@{ConfigPath=$f.config;StateDirectory=$f.state;ManifestPath=(Join-Path $f.manifests 'test.json');OwnerPath=$ownerPath;
        Machine=$env:COMPUTERNAME;Sid=$o.sid;DispatcherTaskId=$f.source;ProjectRoom='Test Recipient';DestinationTaskId=$f.task;
        ValidationMessageId=$f.id;ExpectedLiveConfigHash=(Get-FileHash $f.config).Hash;ExpectedOwnerGeneration='g1';
        ExpectedManifestHash=(Get-FileHash (Join-Path $f.manifests 'test.json')).Hash;ExpectedSyntheticPayloadHash=$r.payload_hash;
        CurrentCliPath=$cli;CurrentCliHash=(Get-FileHash $cli).Hash;ExpectedActionExecute='fixture-wscript.exe';ExpectedActionArguments='exact hidden Live action'}
    Write-LtJson (Join-Path $f.root 'enrollment-args.json') $args
    return $f
}
function RefreshFixtureHash($f,$a){
    $a.ExpectedLiveConfigHash=(Get-FileHash $f.config).Hash
    $a.ExpectedManifestHash=(Get-FileHash $a.ManifestPath).Hash
    $r=Record $f;$r.payload_hash=Get-LtPayloadHash $r;SaveRecord $f $r;$a.ExpectedSyntheticPayloadHash=$r.payload_hash
}
function MustReject($a,[string]$Expected){
    $before=(Get-FileHash $a.ConfigPath).Hash
    $errorText=$null
    try{Invoke-LtValidationEnrollment @a|Out-Null}catch{$errorText=$_.Exception.Message}
    Assert ($errorText -ceq $Expected) ('Expected '+$Expected+' got '+$errorText)
    Assert ((Get-FileHash $a.ConfigPath).Hash -ceq $before) 'Rejected enrollment changed config'
}

Check 'enrollment appends exactly one pin and preserves all prior config and runtime evidence' {
    $f=EnrollmentFixture;$a=EnrollmentArgs $f.root
    $before=Read-LtJson $f.config;$pins=$before.destinations|ConvertTo-Json -Depth 20 -Compress
    $jh=(Get-FileHash (Join-Path $f.state 'journal.json')).Hash;$oh=(Get-FileHash $a.OwnerPath).Hash
    $sh=(Get-FileHash (Join-Path $f.root 'schedule.json')).Hash
    $x=Invoke-LtValidationEnrollment @a;$after=Read-LtJson $f.config
    Assert ($x.changed -and $x.status -ceq 'EnrolledValidationDestination' -and @($after.destinations).Count -eq 3)
    Assert (($after.destinations[0..1]|ConvertTo-Json -Depth 20 -Compress) -ceq $pins)
    $after.destinations=$before.destinations
    Assert (($after|ConvertTo-Json -Depth 30 -Compress) -ceq ($before|ConvertTo-Json -Depth 30 -Compress)) 'Non-destination config changed'
    Assert ((Get-FileHash (Join-Path $f.state 'journal.json')).Hash -ceq $jh)
    Assert ((Get-FileHash $a.OwnerPath).Hash -ceq $oh)
    Assert ((Get-FileHash (Join-Path $f.root 'schedule.json')).Hash -ceq $sh)
    Assert ((Get-FileHash $x.backup_path).Hash -ceq $a.ExpectedLiveConfigHash)
    Assert ((Record $f).attempt_count -eq 0 -and !(Record $f).receipt)
}
Check 'repeat enrollment is byte-stable and does not reset an unresolved submission' {
    $f=EnrollmentFixture;$a=EnrollmentArgs $f.root;$x=Invoke-LtValidationEnrollment @a
    $r=Record $f;$r.state='Delivery Ambiguous';$r.attempt_count=1;$r.attempts=@(@{attempt_id='uncertain-1';outcome='Pending'});SaveRecord $f $r
    $rh=(Get-FileHash (Join-Path $f.queue ('records\'+$f.id+'.json'))).Hash
    $again=Invoke-LtValidationEnrollment @a
    Assert ($again.status -ceq 'AlreadyEnrolled' -and !$again.changed -and $again.config_hash -ieq $x.config_hash)
    Assert ((Get-FileHash (Join-Path $f.queue ('records\'+$f.id+'.json'))).Hash -ceq $rh)
}
foreach($guard in @('ExpectedLiveConfigHash','ExpectedManifestHash','ExpectedSyntheticPayloadHash','CurrentCliHash')){
    Check ('mismatched '+$guard+' fails closed') {
        $f=EnrollmentFixture;$a=EnrollmentArgs $f.root;$a[$guard]='0'*64
        $expect=@{ExpectedLiveConfigHash='EnrollmentLiveConfigHashMismatch';ExpectedManifestHash='EnrollmentManifestHashMismatch';ExpectedSyntheticPayloadHash='EnrollmentSyntheticIdentityMismatch';CurrentCliHash='EnrollmentCurrentCliMismatch'}
        MustReject $a $expect[$guard]
    }
}
Check 'missing required guard fails closed' {$f=EnrollmentFixture;$a=EnrollmentArgs $f.root;$a.ExpectedLiveConfigHash='';MustReject $a 'EnrollmentExpectedHashRequired'}
Check 'wrong expected owner generation fails closed' {$f=EnrollmentFixture;$a=EnrollmentArgs $f.root;$a.ExpectedOwnerGeneration='other';MustReject $a 'EnrollmentLiveConfigIdentityMismatch'}
foreach($fault in @('owner','schedule','registration','manifest','cli','record','source','production','journal','package')){
    Check ('reject '+$fault+' drift without changing config') {
        $f=EnrollmentFixture;$a=EnrollmentArgs $f.root
        switch($fault){
            owner {$o=Read-LtJson $a.OwnerPath;$o.mode='Validation';Write-LtJson $a.OwnerPath $o;$expected='EnrollmentLiveOwnerMismatch'}
            schedule {$p=Join-Path $f.root 'schedule.json';$s=Read-LtJson $p;$s.actions[0].arguments='wrong';Write-LtJson $p $s;$expected='EnrollmentScheduledActionMismatch'}
            registration {$c=Read-LtJson $f.client;$c.registrations=@();Write-LtJson $f.client $c;$expected='EnrollmentRegistrationMismatch'}
            manifest {$m=Read-LtJson $a.ManifestPath;$m.dispatchable=$true;Write-LtJson $a.ManifestPath $m;$expected='EnrollmentValidationManifestMismatch'}
            cli {[IO.File]::WriteAllBytes($a.CurrentCliPath,[byte[]](9));$expected='EnrollmentExecutablePinMismatch'}
            record {$r=Record $f;$r.attempt_count=1;$r.attempts=@(@{outcome='Pending'});SaveRecord $f $r;$expected='EnrollmentSyntheticNotPristine'}
            source {$r=Record $f;$r.source.machine=$env:COMPUTERNAME;SaveRecord $f $r;$expected='EnrollmentNotCrossMachineSynthetic'}
            production {$r=Record $f;$r.payload.business_action_authorized=$true;SaveRecord $f $r;$expected='EnrollmentNotCrossMachineSynthetic'}
            journal {$p=Join-Path $f.state 'journal.json';$j=Read-LtJson $p;$j.entries[0].destination_task_id=$f.task;Write-LtJson $p $j;$expected='EnrollmentDestinationHasJournalHistory'}
            package {[IO.File]::AppendAllText((Join-Path (Split-Path $f.config -Parent) 'FakeAdapter.ps1'),'# drift');$expected='EnrollmentPackageMismatch'}
        }
        RefreshFixtureHash $f $a;MustReject $a $expected
    }
}
Check 'worker lock contention makes no mutation' {
    $f=EnrollmentFixture;$a=EnrollmentArgs $f.root
    $l=[IO.File]::Open((Join-Path $f.state 'worker.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
    try{MustReject $a 'WorkerAlreadyRunning'}finally{$l.Dispose()}
    Assert (Invoke-LtValidationEnrollment @a).changed
}
Check 'guard drift while reading canonical record is rejected' {
    $f=EnrollmentFixture;$a=EnrollmentArgs $f.root
    $ownerPath=$a.OwnerPath
    $a.ReadValidationRecord={param($c,$id) $o=Read-LtJson $ownerPath;$o.generation='changed';Write-LtJson $ownerPath $o;Read-LtJson (Join-Path $c.queue_path ('records\'+$id+'.json'))}.GetNewClosure()
    MustReject $a 'EnrollmentGuardChanged'
}
Check 'two competing enrollment processes append once only' {
    $f=EnrollmentFixture;$testPath=$PSCommandPath
    $children=@()
    try{
        foreach($index in 1..2){
            $info=[Diagnostics.ProcessStartInfo]::new()
            $info.FileName=$ps
            $info.Arguments=(@('-NoProfile','-ExecutionPolicy','Bypass','-File',$testPath,'-ChildFixture',$f.root,'-WaitForStart')|ForEach-Object{ConvertTo-LtWindowsArgument $_}) -join ' '
            $info.UseShellExecute=$false;$info.CreateNoWindow=$true;$info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true
            $p=[Diagnostics.Process]::new();$p.StartInfo=$info;Assert $p.Start()
            $children+=@{process=$p;output=$p.StandardOutput.ReadToEndAsync();error=$p.StandardError.ReadToEndAsync()}
        }
        $deadline=[DateTime]::UtcNow.AddSeconds(20)
        while(@(Get-ChildItem -LiteralPath $f.root -Filter 'ready-*').Count -ne 2 -and [DateTime]::UtcNow -lt $deadline){Start-Sleep -Milliseconds 50}
        Assert (@(Get-ChildItem -LiteralPath $f.root -Filter 'ready-*').Count -eq 2) 'Fixture children not ready'
        [IO.File]::WriteAllText((Join-Path $f.root 'start'),'go')
        $answers=@(foreach($child in $children){
            Assert ($child.process.WaitForExit(20000)) 'Concurrent enrollment did not finish'
            Assert ($child.process.ExitCode -eq 0) ($child.error.GetAwaiter().GetResult())
            $child.output.GetAwaiter().GetResult()|ConvertFrom-Json
        })
        Assert (@($answers|Where-Object status -eq 'EnrolledValidationDestination').Count -eq 1)
        Assert (@($answers|Where-Object {$_.error -and $_.error -cne 'WorkerAlreadyRunning'}).Count -eq 0)
        $a=EnrollmentArgs $f.root;Assert ((Invoke-LtValidationEnrollment @a).status -ceq 'AlreadyEnrolled')
        Assert (@((Read-LtJson $f.config).destinations).Count -eq 3)
    }finally{foreach($child in $children){if(!$child.process.HasExited){$child.process.Kill();[void]$child.process.WaitForExit(2000)};$child.process.Dispose()}}
}
Check 'validation-ready worker rejects production and any different synthetic ID' {
    $f=EnrollmentFixture;$a=EnrollmentArgs $f.root;Invoke-LtValidationEnrollment @a|Out-Null
    $r=Record $f;$c=Read-LtJson $f.client;$m=@((Read-LtJson $a.ManifestPath))
    Assert ((Test-LtRecord $r $c $m $env:COMPUTERNAME 'Live' '') -ceq 'Eligible')
    $r.payload.synthetic_test=$false;$r.payload_hash=Get-LtPayloadHash $r
    Assert ((Test-LtRecord $r $c $m $env:COMPUTERNAME 'Live' '') -ceq 'NotDispatchable')
    $r=Record $f;$r.message_id='different-synthetic-001';$r.dispatch_id=$r.message_id
    Assert ((Test-LtRecord $r $c $m $env:COMPUTERNAME 'Live' '') -ceq 'NotDispatchable')
    Assert ((Record $f).attempt_count -eq 0)
}
Check 'atomic claim independently rejects production for validation-ready endpoint' {
    $f=EnrollmentFixture;$a=EnrollmentArgs $f.root;Invoke-LtValidationEnrollment @a|Out-Null
    Write-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME) (Read-LtJson $a.OwnerPath)
    $r=Record $f;$r.payload.synthetic_test=$false;$r.payload_hash=Get-LtPayloadHash $r;SaveRecord $f $r
    $claim=ClaimArgs $f;$claim.Mode='Live'
    $reply=(& $manager @claim)|ConvertFrom-Json
    Assert (!$reply.claimed -and $reply.reason -ceq 'NotDispatchable') ('Atomic gate returned '+($reply|ConvertTo-Json -Compress))
    Assert ((Record $f).attempt_count -eq 0 -and !(Record $f).receipt)
}
$summary=@{passed=@($results|Where-Object passed).Count;failed=@($results|Where-Object {!$_.passed}).Count;tests=$results;fixture_roots=$roots;real_notifications=0;production_changes=0}
if($enrollmentEvidenceDirectory){Write-LtJson (Join-Path $enrollmentEvidenceDirectory 'enrollment-tests.json') $summary}
$summary|ConvertTo-Json -Depth 8
if($summary.failed){exit 1}
