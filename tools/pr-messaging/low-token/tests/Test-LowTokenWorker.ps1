[CmdletBinding()]
param([string]$EvidenceDirectory,[string]$NameFilter='*',[string]$NameRegex='',[switch]$LibraryOnly)
$ErrorActionPreference='Stop'
$release=Split-Path $PSScriptRoot -Parent
. "$release\Common.ps1"
. "$release\Process.ps1"
. "$release\Canary.Guards.ps1"
$manager=Join-Path $release 'Manage-ProjectRoomMessage.Development.ps1'
$legacy=Join-Path (Split-Path $release -Parent) 'Manage-ProjectRoomMessage.ps1'
$worker=Join-Path $release 'Invoke-LowTokenWorker.ps1'
$ps=(Get-Command powershell.exe).Source
$script:results=@()
$script:roots=@()
function Check([string]$Name,[scriptblock]$Test) {
    if($Name -notlike $NameFilter){return}
    if($NameRegex -and $Name -notmatch $NameRegex){return}
    try { & $Test; $script:results+=@{name=$Name;passed=$true};Write-Host ('PASS '+$Name) }
    catch {$script:results+=@{name=$Name;passed=$false;error=$_.Exception.Message};Write-Host ('FAIL '+$Name+': '+$_.Exception.Message)}
}
function Assert($Value,[string]$Message='Assertion failed') {if(!$Value){throw $Message}}
function Fixture {
    $root=Join-Path ([IO.Path]::GetTempPath()) ('byh-lowtoken-'+[guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $root|Out-Null
    Write-LtJson (Join-Path $root '.lowtoken-fixture') @{fixture=$true}
    foreach($dir in @('queue','queue\records','manifests','state')){New-Item -ItemType Directory -Path (Join-Path $root $dir)|Out-Null}
    $f=@{root=$root;queue=(Join-Path $root 'queue');client=(Join-Path $root 'client.json');manifests=(Join-Path $root 'manifests');state=(Join-Path $root 'state');id='test-synthetic-001';task='11111111-1111-4111-8111-111111111111';source='22222222-2222-4222-8222-222222222222'}
    $client=@{machine=$env:COMPUTERNAME;registrations=@(@{project_room='Test Recipient';task_id=$f.task})}
    $manifest=@{project_room='Test Recipient';task_id=$f.task;execution_machine=$env:COMPUTERNAME;dispatchable=$true;accepted_message_types=@('status');messaging_readiness=@{status='ready';validation_message_id=$f.id}}
    Write-LtJson $f.client $client;Write-LtJson (Join-Path $f.manifests 'test.json') $manifest
    $a=@{authorized_by='Wes';instruction='Isolated synthetic fixture only';business_action_authorized=$false}|ConvertTo-Json -Compress
    $p=@{synthetic_test=$true;business_action_authorized=$false;business_action_performed=$false}|ConvertTo-Json -Compress
    & $manager -FixtureRoot $root -Action Send -QueuePath $f.queue -MessageId $f.id -DispatchId $f.id -MessageType status -SourceProjectRoom 'Fixture Source' -SourceTaskId $f.source -SourceMachine $env:COMPUTERNAME -DestinationProjectRoom 'Test Recipient' -DestinationTaskId $f.task -DestinationMachine $env:COMPUTERNAME -AuthorizationJson $a -PayloadJson $p -MaxAttempts 1 | Out-Null
    $owner=@{owner='fixture-worker';generation='g1';mode='Validation';machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;task_id=$f.source;validation_message_id=$f.id}
    Write-LtJson (Join-Path $f.queue '.transport-owner.json') $owner
    $adapter=Join-Path $root 'FakeAdapter.ps1'
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'FakeAdapter.ps1') -Destination $adapter
    Write-LtJson (Join-Path $root 'adapter-control.json') @{behavior='success'}
    Write-LtJson (Join-Path $root 'busy.json') @{task_ids=@()}
    $config=[ordered]@{schema_version=1;release='0.2.0';expected_machine=$env:COMPUTERNAME;expected_sid=$owner.sid;owner=$owner.owner;generation=$owner.generation;dispatcher_task_id=$f.source;fixture_root=$root;queue_path=$f.queue;manager_path=$manager;manager_sha256=(Get-FileHash $manager).Hash;client_path=$f.client;manifest_directory=$f.manifests;state_directory=$f.state;powershell_path=$ps;max_tick_seconds=50;queued_receipt_warning_seconds=1;adapter_kind='Fixture';adapter_path=$adapter;adapter_sha256=(Get-FileHash $adapter).Hash;busy_tasks_path=(Join-Path $root 'busy.json');validation_message_id=$f.id}
    $config.package_sha256=Get-LtPackageHash $release
    $f.config=Join-Path $root 'config.json';Write-LtJson $f.config $config
    $script:roots+=@($root)
    return $f
}
function Record($f){(& $manager -FixtureRoot $f.root -Action Get -QueuePath $f.queue -MessageId $f.id)|ConvertFrom-Json}
function SaveRecord($f,$r){Write-LtJson (Join-Path $f.queue ('records\'+$f.id+'.json')) $r}
function ClaimArgs($f,[string]$Attempt='fixture-attempt-1'){
    $r=Record $f
    @{FixtureRoot=$f.root;Action='ConditionalClaim';QueuePath=$f.queue;MessageId=$f.id;AttemptId=$Attempt;TransportOwner='fixture-worker';Generation='g1';Mode='Validation';ExpectedHash=$r.payload_hash;ExpectedVersion=(Get-LtVersion $r);ExpectedConfigHash=(Get-LtConfigHash (Read-LtJson $f.client) @((Read-LtJson (Join-Path $f.manifests 'test.json'))));ClientConfigPath=$f.client;ManifestDirectory=$f.manifests;ActorTaskId=$f.source}
}
function Claim($f){$args=ClaimArgs $f;(& $manager @args)|ConvertFrom-Json}
function Tick($f,[string]$Mode='Validation',[string]$Failure='None'){
    $argv=@('-NoProfile','-ExecutionPolicy','Bypass','-File',$worker,'-ConfigPath',$f.config,'-Mode',$Mode,'-FailurePoint',$Failure)
    if($Mode -eq 'Validation'){$argv+=@('-MessageId',$f.id)}
    $p=Invoke-LtProcess $ps $argv 55
    if($p.timed_out -or $p.exit_code -ne 0){throw ('Worker process: '+$p.stderr)}
    $p.stdout|ConvertFrom-Json
}
function CountSubmissions($f){return @(Get-ChildItem -LiteralPath $f.root -Filter 'submission-*.json' -File).Count}
function Reconcile($f,$Outcome='DeliveryAmbiguous'){
    $r=Record $f
    & $manager -FixtureRoot $f.root -Action ReconcileAttempt -QueuePath $f.queue -MessageId $f.id -AttemptId $r.attempts[0].attempt_id -ActorTaskId $f.source -TransportOwner 'fixture-worker' -Generation 'g1' -ExpectedHash $r.payload_hash -AttemptOutcome $Outcome -Detail 'Fixture recovery'|ConvertFrom-Json
}
if($LibraryOnly){return}
Check 'valid conditional claim' {$f=Fixture;$r=Claim $f;Assert $r.claimed;Assert ((Record $f).attempt_count -eq 1)}
Check 'idempotent same attempt never permits a second submission' {$f=Fixture;Claim $f|Out-Null;$r=Claim $f;Assert ($r.claimed -and $r.idempotent -and !$r.may_submit);Assert ((Record $f).attempt_count -eq 1)}
Check 'expected-version CAS conflict' {$f=Fixture;$a=ClaimArgs $f;$r=Record $f;$r.updated_at_utc=[DateTime]::UtcNow.AddSeconds(1).ToString('o');SaveRecord $f $r;$x=(& $manager @a)|ConvertFrom-Json;Assert ($x.reason -eq 'VersionConflict')}
Check 'configuration drift inside manager lock' {$f=Fixture;$a=ClaimArgs $f;$c=Read-LtJson $f.client;$c.registrations=@();Write-LtJson $f.client $c;$x=(& $manager @a)|ConvertFrom-Json;Assert ($x.reason -eq 'ConfigurationConflict')}
Check 'ownership generation mismatch' {$f=Fixture;$a=ClaimArgs $f;$a.Generation='old';try{& $manager @a|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -eq 'TransportOwnershipMismatch')}}
Check 'legacy claimer rejected with exclusive owner' {$f=Fixture;try{& $manager -FixtureRoot $f.root -Action StartAttempt -QueuePath $f.queue -MessageId $f.id|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -eq 'LegacyTransportNotOwner')}}
Check 'staged manager refuses real share' {try{& $manager -Action Get -MessageId 'test-synthetic-001'|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -eq 'FixtureRootRequired')}}
Check 'legacy operations compatible when no owner installed' {$f=Fixture;Remove-Item -LiteralPath (Join-Path $f.queue '.transport-owner.json');& $manager -FixtureRoot $f.root -Action StartAttempt -QueuePath $f.queue -MessageId $f.id|Out-Null;Assert ((Record $f).attempt_count -eq 1)}
foreach($case in @('hash','task','machine','registration','authorization','synthetic','budget','terminal','manifest-validation')){
    Check ('reject '+$case) {
        $f=Fixture;$r=Record $f
        switch($case){
            hash {$r.payload.synthetic_test=$false}
            task {$r.destination.task_id='33333333-3333-4333-8333-333333333333'}
            machine {$r.destination.machine='OTHER'}
            registration {$c=Read-LtJson $f.client;$c.registrations=@();Write-LtJson $f.client $c}
            authorization {$r.authorization.instruction=''}
            synthetic {$r.payload.synthetic_test='true'}
            budget {$r.max_attempts=2}
            terminal {$r.state='Completed'}
            manifest-validation {$m=Read-LtJson (Join-Path $f.manifests 'test.json');$m.dispatchable=$false;$m.messaging_readiness.status='validation_ready';$m.messaging_readiness.validation_message_id='other';Write-LtJson (Join-Path $f.manifests 'test.json') $m}
        }
        if($case -ne 'hash'){$r.payload_hash=Get-LtPayloadHash $r};SaveRecord $f $r
        if($case -eq 'hash'){try{Claim $f|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -eq 'ImmutableHashMismatch')}}else{Assert (!(Claim $f).claimed)}
        Assert ((Record $f).attempt_count -eq 0)
    }
}
Check 'blank filter no fallback' {$f=Fixture;$a=ClaimArgs $f;$a.MessageId='';try{& $manager @a|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -match 'MessageId|message')} ; Assert ((Record $f).attempt_count -eq 0)}
Check 'missing exact target no fallback' {$f=Fixture;$a=ClaimArgs $f;$a.MessageId='missing-target';$r=(& $manager @a)|ConvertFrom-Json;Assert (!$r.claimed -and $r.reason -eq 'MissingTarget')}
Check 'worker validation requires explicit filter' {$f=Fixture;$r=& $worker -ConfigPath $f.config -Mode Validation|ConvertFrom-Json;Assert ($r.error -eq 'ValidationFilterRequired')}
Check 'ready destination permits fresh worker validation id' {$f=Fixture;$m=Read-LtJson (Join-Path $f.manifests 'test.json');$m.messaging_readiness.validation_message_id='historical-validation';Write-LtJson (Join-Path $f.manifests 'test.json') $m;$r=Tick $f;Assert ($r.claims -eq 1 -and $r.submissions -eq 1)}
Check 'JSON owner replacement uses restricted-share-compatible overwrite' {$f=Fixture;$p=Join-Path $f.root 'owner-replacement.json';Write-LtJson $p @{mode='Validation'};Write-LtJson $p @{mode='Live'};Assert ((Read-LtJson $p).mode -ceq 'Live');Assert (@(Get-ChildItem -LiteralPath $f.root -Filter '.*.tmp' -File).Count -eq 0)}
Check 'active embedded fallback exception is OFFICEASSIST Email Monitor only' {Assert (Test-LtActiveEmbeddedFallbackException 'OFFICEASSIST' 'officeassist-morning-email-summary-and-instruction-monitor' $true);Assert (!(Test-LtActiveEmbeddedFallbackException 'WES-VIDEOEDITOR' 'officeassist-morning-email-summary-and-instruction-monitor' $true));Assert (!(Test-LtActiveEmbeddedFallbackException 'OFFICEASSIST' 'other-automation' $true));Assert (!(Test-LtActiveEmbeddedFallbackException 'OFFICEASSIST' 'officeassist-morning-email-summary-and-instruction-monitor' $false))}
Check 'live fails closed' {$f=Fixture;$r=Tick $f Live;Assert ($r.error -eq 'LiveDisabledInDevelopmentRelease');Assert ((CountSubmissions $f) -eq 0)}
Check 'paused makes no queue read or submission' {$f=Fixture;$r=Tick $f Paused;Assert ($r.status -eq 'Paused' -and !$r.queue_reachable -and $r.submissions -eq 0)}
Check 'empty shadow no central change or model call' {$f=Fixture;$c=Read-LtJson $f.config;$c.manager_path=$legacy;$c.manager_sha256=(Get-FileHash $legacy).Hash;Write-LtJson $f.config $c;Remove-Item -LiteralPath (Join-Path $f.queue ('records\'+$f.id+'.json'));$r=Tick $f Shadow;Assert ($r.status -eq 'ShadowComplete' -and @($r.candidates).Count -eq 0 -and $r.claims -eq 0 -and $r.model_requests -eq 0 -and $r.submissions -eq 0)}
Check 'one fake submission then restart never resubmits' {$f=Fixture;$r=Tick $f;Assert ($r.claims -eq 1 -and $r.submissions -eq 1);Tick $f|Out-Null;Assert ((CountSubmissions $f) -eq 1);Assert ((Record $f).state -eq 'Delivery Attempted')}
Check 'closed journal backlog is retained but skipped before eligible claim' {
    $f=Fixture
    $closed=@(1..750|ForEach-Object{
        [pscustomobject]@{
            message_id=('closed-message-{0:D4}' -f $_);dispatch_id=('closed-message-{0:D4}' -f $_)
            destination_task_id=$f.task;payload_hash=('a'*64);attempt_id=('closed-attempt-{0:D4}' -f $_)
            phase='closed';outcome='Delivered';created_at_utc='2026-01-01T00:00:00Z'
            submission_started_at_utc='2026-01-01T00:00:01Z';submission_completed_at_utc='2026-01-01T00:00:02Z'
            adapter_release='0.4.2';adapter_sha256=('b'*64);submission_evidence=$null
        }
    })
    Write-LtJson (Join-Path $f.state 'journal.json') ([pscustomobject]@{
        schema_version=2;machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value
        owner='fixture-worker';generation='g1';created_at_utc='2026-01-01T00:00:00Z';entries=$closed
    })
    $r=Tick $f
    $j=Read-LtJson (Join-Path $f.state 'journal.json')
    Assert ($r.status -eq 'TickComplete' -and $r.claims -eq 1 -and $r.submissions -eq 1) ('Worker result: '+($r|ConvertTo-Json -Depth 8 -Compress))
    Assert ($r.journal_closed_skipped -eq 750 -and $r.elapsed_ms -lt 25000) ('Backlog metrics: skipped='+$r.journal_closed_skipped+' elapsed_ms='+$r.elapsed_ms)
    Assert (@($j.entries|Where-Object phase -ceq 'closed').Count -eq 750) ('Closed count: '+@($j.entries|Where-Object phase -ceq 'closed').Count)
    Assert (@($j.entries).Count -eq 751) ('Journal count: '+@($j.entries).Count)
    Assert ((CountSubmissions $f) -eq 1) ('Submission count: '+(CountSubmissions $f))
}
foreach($fault in @('AfterPlan','AfterClaim','BeforeAdapter','AfterAdapter')){
    Check ('restart recovery '+$fault) {
        $f=Fixture;$r=Tick $f Validation $fault;Assert ($r.status -eq 'Blocked');Tick $f|Out-Null
        if($fault -eq 'AfterPlan'){Assert ((CountSubmissions $f) -eq 1)}
        elseif($fault -eq 'AfterClaim'){Assert ((CountSubmissions $f) -eq 0);Assert ((Record $f).state -eq 'Queued')}
        elseif($fault -eq 'BeforeAdapter'){Assert ((CountSubmissions $f) -eq 0);Assert ((Record $f).state -eq 'Delivery Ambiguous')}
        else{Assert ((CountSubmissions $f) -eq 1);Assert ((Record $f).state -eq 'Delivery Ambiguous')}
    }
}
Check 'late exact acceptance preserves completed state' {$f=Fixture;Tick $f|Out-Null;Tick $f|Out-Null;& $manager -FixtureRoot $f.root -Action Accept -QueuePath $f.queue -MessageId $f.id -ActorTaskId $f.task -ActorProjectRoom 'Test Recipient'|Out-Null;& $manager -FixtureRoot $f.root -Action StartProcessing -QueuePath $f.queue -MessageId $f.id|Out-Null;& $manager -FixtureRoot $f.root -Action Complete -QueuePath $f.queue -MessageId $f.id -ResultJson '{"fixture":true}'|Out-Null;$x=Reconcile $f;Assert ($x.outcome -eq 'Delivered' -and $x.record.state -eq 'Completed')}
Check 'wrong receipt never proves delivery' {$f=Fixture;Claim $f|Out-Null;$r=Record $f;$r.receipt=@{project_room='Test Recipient';task_id=$f.source;machine=$env:COMPUTERNAME};SaveRecord $f $r;try{Reconcile $f|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -eq 'ReceiptIdentityMismatch')}}
Check 'busy inventory is not required for queue submission' {$f=Fixture;Remove-Item -LiteralPath (Join-Path $f.root 'busy.json');$r=Tick $f;Assert ($r.claims -eq 1 -and (CountSubmissions $f) -eq 1)}
Check 'delayed destination does not suppress other candidate' {$f=Fixture;$r=Record $f;$other=$r|ConvertTo-Json -Depth 30|ConvertFrom-Json;$other.message_id='other-pending';$other.attempts=@(@{outcome='Pending'});$c=Read-LtJson $f.client;$m=@(Read-LtJson (Join-Path $f.manifests 'test.json'));Assert ((Test-LtRecord $r $c $m $env:COMPUTERNAME 'Shadow' '' @($other)) -eq 'DestinationOutstanding');$other.destination.task_id=$f.source;Assert ((Test-LtRecord $r $c $m $env:COMPUTERNAME 'Shadow' '' @($other)) -eq 'Eligible')}
Check 'offline queue fails closed then recovers' {$f=Fixture;Move-Item -LiteralPath $f.queue -Destination (Join-Path $f.root 'offline-queue');$r=Tick $f;Assert ($r.status -eq 'Blocked' -and $r.claims -eq 0);Move-Item -LiteralPath (Join-Path $f.root 'offline-queue') -Destination $f.queue;$r=Tick $f;Assert ($r.claims -eq 1)}
Check 'corrupt journal blocks without overwriting evidence' {$f=Fixture;Write-LtJson (Join-Path $f.state 'journal.json') @{schema_version=99};$before=(Get-FileHash (Join-Path $f.state 'journal.json')).Hash;$r=Tick $f;Assert ($r.status -eq 'Blocked' -and $r.claims -eq 0);Assert ((Get-FileHash (Join-Path $f.state 'journal.json')).Hash -eq $before)}
Check 'missing journal plus pending attempt never resubmits' {$f=Fixture;Claim $f|Out-Null;Start-Sleep -Seconds 2;$r=Tick $f;Assert ((CountSubmissions $f) -eq 0 -and (Record $f).state -eq 'Delivery Ambiguous')}
Check 'adapter failure becomes ambiguity not retry' {$f=Fixture;Write-LtJson (Join-Path $f.root 'adapter-control.json') @{behavior='error'};Tick $f|Out-Null;Tick $f|Out-Null;Assert ((CountSubmissions $f) -eq 1 -and (Record $f).state -eq 'Delivery Ambiguous')}
Check 'adapter timeout is bounded and ambiguous' {$f=Fixture;Write-LtJson (Join-Path $f.root 'adapter-control.json') @{behavior='timeout'};$r=Tick $f;Assert ($r.elapsed_ms -lt 55000);Tick $f|Out-Null;Assert ((CountSubmissions $f) -eq 1 -and (Record $f).state -eq 'Delivery Ambiguous')}
Check 'singleton prevents concurrent worker' {$f=Fixture;$s=[IO.File]::Open((Join-Path $f.state 'worker.lock'),[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None);try{$r=Tick $f;Assert ($r.error -eq 'WorkerAlreadyRunning')}finally{$s.Dispose()}}
Check 'CLI adapter refuses real submission' {$cli=(Get-Command codex.exe).Source;try{& (Join-Path $release 'Invoke-CodexQueueAdapter.ps1') -ThreadId '11111111-1111-4111-8111-111111111111' -DispatcherTaskId '22222222-2222-4222-8222-222222222222' -MessageId 'fixture-test' -PayloadHash ('a'*64) -CliPath $cli -ExpectedCliHash (Get-FileHash $cli).Hash|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -eq 'RealSubmissionDisabledInDevelopmentRelease')}}
Check 'production adapter source recognizes release 0.4.3' {
    $text=Get-Content -Raw -LiteralPath (Join-Path $release 'Invoke-CodexQueueAdapter.ps1')
    Assert ($text -match "'0\.4\.0','0\.4\.1','0\.4\.2','0\.4\.3'" -and $text -match "'0\.3\.0-assisted','0\.4\.0','0\.4\.1','0\.4\.2','0\.4\.3'")
}
Check 'only nonzero marker-free adapter exit proves no submission' {
    $missing=Join-Path ([IO.Path]::GetTempPath()) ('missing-'+[guid]::NewGuid().ToString('N'))
    Assert (Test-LtProvenPreSubmissionFailure ([pscustomobject]@{timed_out=$false;exit_code=1}) $missing)
    Assert (!(Test-LtProvenPreSubmissionFailure ([pscustomobject]@{timed_out=$true;exit_code=$null}) $missing))
    $present=$missing+'.json';Set-Content -LiteralPath $present -Value '{}'
    Assert (!(Test-LtProvenPreSubmissionFailure ([pscustomobject]@{timed_out=$false;exit_code=1}) $present))
    Remove-Item -LiteralPath $present -Force
}
Check 'Windows argv quoting round trip' {$p=Invoke-LtProcess $ps @('-NoProfile','-ExecutionPolicy','Bypass','-File',(Join-Path $PSScriptRoot 'Echo-Arguments.ps1'),'with spaces','quote"inside','trailing\','$(do not execute); & text') 5;$a=$p.stdout|ConvertFrom-Json;Assert ($a[0] -ceq 'with spaces' -and $a[1] -ceq 'quote"inside' -and $a[2] -ceq 'trailing\' -and $a[3] -ceq '$(do not execute); & text')}
Check 'unresolved journal reconciles late receipt on worker restart' {$f=Fixture;Write-LtJson (Join-Path $f.root 'adapter-control.json') @{behavior='error'};Tick $f|Out-Null;Tick $f|Out-Null;& $manager -FixtureRoot $f.root -Action Accept -QueuePath $f.queue -MessageId $f.id -ActorTaskId $f.task -ActorProjectRoom 'Test Recipient'|Out-Null;Tick $f|Out-Null;Assert ((Record $f).attempts[0].outcome -eq 'Delivered');Assert ((CountSubmissions $f) -eq 1)}
Check 'valid administrative closure closes unresolved journal without resubmission' {
    $f=Fixture;Write-LtJson (Join-Path $f.root 'adapter-control.json') @{behavior='error'};Tick $f|Out-Null;Tick $f|Out-Null
    $r=Record $f;$r.attempts[0].completed_at_utc=[DateTime]::UtcNow.AddMinutes(-60).ToString('o')
    $r|Add-Member administrative_closure ([pscustomobject][ordered]@{
        schema_version=1;message_id=$r.message_id;payload_hash=$r.payload_hash
        disposition='ExhaustedAmbiguousUndelivered';authorized_by='Wes';authorization_reference='Fixture authorization'
        actor_project_room='PR Messaging Dispatcher';actor_task_id=$f.source;actor_machine=$env:COMPUTERNAME
        transport_owner='low-token-fixture';transport_generation='g1';transport_owner_task_id=$f.source
        closed_at_utc=[DateTime]::UtcNow.ToString('o');delivery_claimed=$false;business_completion_claimed=$false;detail='Fixture closure.'
    })
    SaveRecord $f $r;Tick $f|Out-Null
    $j=Read-LtJson (Join-Path $f.state 'journal.json')
    Assert ($j.entries[0].phase -ceq 'closed' -and $j.entries[0].outcome -ceq 'ExhaustedAmbiguousUndelivered')
    Assert ((CountSubmissions $f) -eq 1)
}
Check 'package drift fails closed' {$f=Fixture;$c=Read-LtJson $f.config;$c.package_sha256='bad';Write-LtJson $f.config $c;$r=Tick $f;Assert ($r.error -eq 'PackageReleaseMismatch' -and $r.claims -eq 0)}
Check 'rollback flag cannot enable unfiltered validation' {$f=Fixture;$c=Read-LtJson $f.config;$c|Add-Member legacy_queue_remains_authoritative $true;Write-LtJson $f.config $c;$r=& $worker -ConfigPath $f.config -Mode Validation|ConvertFrom-Json;Assert ($r.error -eq 'ValidationFilterRequired')}
Check 'duplicate registration rejected' {$f=Fixture;$c=Read-LtJson $f.client;$c.registrations=@($c.registrations)+@($c.registrations);Write-LtJson $f.client $c;Assert ((Claim $f).reason -eq 'RegistrationMismatch')}
Check 'unauthorized synthetic authority rejected' {$f=Fixture;$r=Record $f;$r.authorization.authorized_by='unknown';$r.payload_hash=Get-LtPayloadHash $r;SaveRecord $f $r;Assert ((Claim $f).reason -eq 'ValidationAuthorizationMissing')}
Check 'fixture drain never claims' {$f=Fixture;$r=Tick $f Drain;Assert ($r.status -eq 'DrainComplete' -and $r.claims -eq 0 -and (Record $f).attempt_count -eq 0)}
Check 'installer plan stages generalized production release' {$x=& (Join-Path $release 'Install-LowTokenWorker.ps1') -Action Plan|ConvertFrom-Json;Assert ($x.release -eq '0.4.3' -and !$x.stage_changes_transport -and $x.schedule -eq 'Every 60 seconds, 24/7' -and $x.validation -match 'synthetic' -and $x.launcher -eq 'wscript.exe hidden window host')}
Check 'installer upgrade recognizes current 0.4.2 source' {$text=Get-Content -Raw -LiteralPath (Join-Path $release 'Install-LowTokenWorker.ps1');Assert ($text -match '@\(\$release,''0\.4\.2'',''0\.4\.1'',''0\.4\.0''\)')}
Check 'scheduled worker uses a console-free launcher' {
    $installer=Get-Content -Raw -LiteralPath (Join-Path $release 'Install-LowTokenWorker.ps1')
    $launcher=Get-Content -Raw -LiteralPath (Join-Path $release 'Invoke-LowTokenWorkerHidden.vbs')
    Assert ($installer -match [regex]::Escape("C:\Windows\System32\wscript.exe") -and $installer -match 'New-LtWorkerTaskAction')
    Assert ($installer -notmatch 'New-ScheduledTaskAction -Execute \$ps')
    Assert ($launcher -match 'shell\.Run\(command, 0, True\)' -and $launcher -match 'arguments\.Count < 4')
}
Check 'stage manifest requires explicit readiness evidence' {
    $reg=@{project_room='Test Recipient';task_id='11111111-1111-4111-8111-111111111111'}
    $m=@{project_room=$reg.project_room;task_id=$reg.task_id;execution_machine=$env:COMPUTERNAME;dispatchable=$true}
    Assert (!(Test-LtStageManifest $m $reg $env:COMPUTERNAME))
    $m.messaging_readiness=@{status='ready'};Assert (Test-LtStageManifest $m $reg $env:COMPUTERNAME)
    $m.dispatchable=$false;$m.messaging_readiness=@{status='validation_ready';validation_message_id='synthetic-validation'};Assert (Test-LtStageManifest $m $reg $env:COMPUTERNAME)
    $m.messaging_readiness.validation_message_id='';Assert (!(Test-LtStageManifest $m $reg $env:COMPUTERNAME))
    [void]$m.Remove('dispatchable');$m.messaging_readiness.validation_message_id='synthetic-validation';Assert (!(Test-LtStageManifest $m $reg $env:COMPUTERNAME))
}
Check 'machine-scoped live owner permits one atomic claim' {
    $f=Fixture
    Remove-Item -LiteralPath (Join-Path $f.queue '.transport-owner.json')
    $ownerPath=Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME
    Write-LtJson $ownerPath @{owner='fixture-worker';generation='g1';mode='Live';machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;task_id=$f.source}
    $a=ClaimArgs $f;$a.Mode='Live'
    $x=(& $manager @a)|ConvertFrom-Json
    Assert ($x.claimed -and $x.may_submit -and (Record $f).attempt_count -eq 1)
}
Check 'machine-scoped owner blocks legacy claimer only for owned destination machine' {
    $f=Fixture
    Remove-Item -LiteralPath (Join-Path $f.queue '.transport-owner.json')
    Write-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME) @{owner='fixture-worker';generation='g1';mode='Live';machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;task_id=$f.source}
    try{& $manager -FixtureRoot $f.root -Action StartAttempt -QueuePath $f.queue -MessageId $f.id|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -eq 'LegacyTransportNotOwner')}
    Assert ((Record $f).attempt_count -eq 0)
}
Check 'canonical manager honors machine-scoped owner on isolated queue' {
    $f=Fixture
    Remove-Item -LiteralPath (Join-Path $f.queue '.transport-owner.json')
    Write-LtJson (Get-LtTransportOwnerPath $f.queue $env:COMPUTERNAME) @{owner='fixture-worker';generation='g1';mode='Live';machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;task_id=$f.source}
    try{& $legacy -Action StartAttempt -QueuePath $f.queue -MessageId $f.id|Out-Null;throw 'not rejected'}catch{Assert ($_.Exception.Message -eq 'LegacyTransportNotOwner')}
    Assert ((Record $f).attempt_count -eq 0)
}
Check 'submission markers are permanent and scoped per message attempt' {
    $root=Join-Path ([IO.Path]::GetTempPath()) ('byh-marker-'+[guid]::NewGuid().ToString('N'))
    $one=Get-LtSubmissionMarkerPath $root 'message-one' 'attempt-one'
    $two=Get-LtSubmissionMarkerPath $root 'message-two' 'attempt-one'
    New-Item -ItemType Directory -Path (Split-Path -Parent $one) -Force|Out-Null
    New-LtCanarySubmissionMarker $one @{message_id='message-one';attempt_id='attempt-one'}
    New-LtCanarySubmissionMarker $two @{message_id='message-two';attempt_id='attempt-one'}
    Assert ((Test-Path $one) -and (Test-Path $two) -and $one -cne $two)
    try{New-LtCanarySubmissionMarker $one @{duplicate=$true};throw 'duplicate accepted'}catch{Assert ($_.Exception.Message -ne 'duplicate accepted')}
}
Check 'production destination pin requires one exact room task and machine' {
    $d=[pscustomobject]@{project_room='One';task_id='11111111-1111-4111-8111-111111111111';machine=$env:COMPUTERNAME}
    $cfg=[pscustomobject]@{destinations=@($d)}
    Assert (Test-LtPinnedDestination $cfg $d)
    foreach($field in @('project_room','task_id','machine')){$changed=$d|ConvertTo-Json|ConvertFrom-Json;$changed.$field='Other';Assert (!(Test-LtPinnedDestination $cfg $changed))}
    $cfg.destinations=@($d,$d);Assert (!(Test-LtPinnedDestination $cfg $d))
}
Check 'Unicode JSON survives manager subprocess round trip' {$f=Fixture;$r=Record $f;$r.payload|Add-Member note ('Unicode '+[char]0x2014+' '+[char]0x201c+'quoted'+[char]0x201d);$r.payload_hash=Get-LtPayloadHash $r;SaveRecord $f $r;$x=Tick $f;Assert ($x.claims -eq 1 -and $x.submissions -eq 1);Assert ((Record $f).payload.note -ceq $r.payload.note)}
Check 'journal preserves dispatch identity and submission evidence' {$f=Fixture;Tick $f|Out-Null;$j=Read-LtJson (Join-Path $f.state 'journal.json');$e=$j.entries[0];Assert ($e.dispatch_id -ceq $f.id -and $e.adapter_release -eq '0.2.0' -and $e.submission_started_at_utc -and $e.submission_completed_at_utc -and $e.submission_evidence.exit_code -eq 0 -and !$e.submission_evidence.accepted)}
Check 'two process claimers one winner' {
    $f=Fixture;$common=ClaimArgs $f;$processes=@()
    foreach($i in 1..2){$argv=@('-NoProfile','-ExecutionPolicy','Bypass','-File',$manager);$common.AttemptId='concurrent-'+$i;foreach($k in $common.Keys){$argv+=@("-$k",[string]$common[$k])};$psi=[Diagnostics.ProcessStartInfo]::new();$psi.FileName=$ps;$psi.Arguments=($argv|ForEach-Object{ConvertTo-LtWindowsArgument $_}) -join ' ';$psi.UseShellExecute=$false;$psi.CreateNoWindow=$true;$psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true;$p=[Diagnostics.Process]::new();$p.StartInfo=$psi;$p.Start()|Out-Null;$processes+=@{p=$p;out=$p.StandardOutput.ReadToEndAsync();err=$p.StandardError.ReadToEndAsync()}}
    $wins=0;$responses=@();foreach($item in $processes){try{Assert ($item.p.WaitForExit(15000));$raw=$item.out.GetAwaiter().GetResult();$stderr=$item.err.GetAwaiter().GetResult();$responses+=@{out=$raw;err=$stderr};$x=$raw|ConvertFrom-Json;if($x.claimed){$wins++}}finally{$item.p.Dispose()}};Assert ($wins -eq 1 -and (Record $f).attempt_count -eq 1) ($responses|ConvertTo-Json -Depth 5 -Compress)
}
$summary=[ordered]@{release='0.2.0';completed_at_utc=[DateTime]::UtcNow.ToString('o');passed=@($results|Where-Object passed -eq $true).Count;failed=@($results|Where-Object passed -eq $false).Count;tests=$results;fixture_roots=$roots;production_actions=0;real_cli_submissions=0}
if($EvidenceDirectory){Write-LtJson (Join-Path $EvidenceDirectory 'test-results.json') $summary}
$summary|ConvertTo-Json -Depth 8
if($summary.failed){exit 1}
