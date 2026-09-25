[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
$source=Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$root=Join-Path ([IO.Path]::GetTempPath()) ('byh-retirement-test-'+[guid]::NewGuid().ToString('N'))
$queue=Join-Path $root 'queue';$code=Join-Path $root 'code'
foreach($dir in @($queue,(Join-Path $queue 'records'),(Join-Path $queue '.transport-owners'),$code,(Join-Path $code 'low-token'))){New-Item -ItemType Directory -Path $dir -Force|Out-Null}
New-Item -ItemType File -Path (Join-Path $queue '.administrative-closure-fixture')|Out-Null
foreach($file in @('Manage-ProjectRoomMessage.ps1','Message-Integrity.ps1','low-token\Common.ps1','low-token\Manager.Extensions.ps1')){Copy-Item -LiteralPath (Join-Path $source $file) -Destination (Join-Path $code $file)}
. (Join-Path $source 'Message-Integrity.ps1')
$id='prmsg-doc-scan-rollback-review-20260824-001'
$actor='01a09d84-a309-7591-a790-e770fcb53dee'
$reference='Wes explicitly cancelled and authorized administrative retirement in Jean Wright on September 25, 2026.'
$old=[DateTime]::UtcNow.AddDays(-2).ToString('o')
$seed=[pscustomobject][ordered]@{
    message_id=$id;dispatch_id=$id;message_type='request';parent_message_id=''
    source=@{project_room='Fixture';task_id='22222222-2222-4222-8222-222222222222';machine='FIXTURE'}
    destination=@{project_room='Doc Scan';task_id='01a029bf-8534-7b73-a330-55015eb2a722';machine='OFFICEASSIST'}
    authorization=@{authorized_by='Wes';instruction='Isolated fixture only'};references=@();payload=@{synthetic_test=$true}
    authoritative=$true;state='Queued';attempt_count=3;max_attempts=3;receipt=$null;result=$null;events=@();payload_hash='';updated_at_utc=$old
    attempts=@(
        @{attempt_id='49e711c01d79407f9c4f1e7409f42d71';outcome='DeliveryAmbiguous';started_at_utc=$old;completed_at_utc=$old},
        @{attempt_id='dispatcher-officeassist-prmsg-doc-scan-rollback-review-20260824-001-2';outcome='NotDelivered';started_at_utc=$old;completed_at_utc=$old},
        @{attempt_id='dispatcher-officeassist-prmsg-doc-scan-rollback-review-20260824-001-3';outcome='NotDelivered';started_at_utc=$old;completed_at_utc=$old})
}
$seed.payload_hash=(Get-PrMessageHashEvidence $seed).default_hash
# Replace ONLY the immutable digest in an isolated copy for synthetic integration tests.
# Production has no fixture override parameter and retains the exact authorized digest.
$integrity=Join-Path $code 'Message-Integrity.ps1'
$text=Get-Content -Raw $integrity
$pinned='dc03b0ab70b657a77dcd0df7327c5e5cca5bbef6529232c5b186fd2ec48289b9'
if(!$text.Contains($pinned)){throw 'Production exact hash pin missing'}
[IO.File]::WriteAllText($integrity,$text.Replace($pinned,$seed.payload_hash))
. $integrity
. (Join-Path $code 'low-token\Common.ps1')
$manager=Join-Path $code 'Manage-ProjectRoomMessage.ps1'
$path=Join-Path $queue ('records\'+$id+'.json')
$ownerPath=Join-Path $queue '.transport-owners\OFFICEASSIST.json'
$owner=@{owner='low-token-officeassist';generation='0.4.0';mode='Live';machine='OFFICEASSIST';task_id=$actor;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value}
function Reset-Fixture {
    Write-LtJson $path $seed;Write-LtJson $ownerPath $owner
}
function Args {
    $r=Read-LtJson $path
    @{Action='AdministrativeRetireObsoleteRollback';QueuePath=$queue;MessageId=$id;ActorProjectRoom='PR Messaging Dispatcher';ActorTaskId=$actor;TransportOwner='low-token-officeassist';Generation='0.4.0';Mode='Live';ExpectedHash=$r.payload_hash;ExpectedRecordVersion=(Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress));AuthorizationReference=$reference;Detail='Retirement fixture; no delivery or business completion.'}
}
function Assert($condition,$detail){if(!$condition){throw $detail}}
$passed=0
Reset-Fixture
$before=Read-LtJson $path;$args=Args
$after=(& $manager @args|Out-String)|ConvertFrom-Json
Assert (Test-PrAdministrativeClosure $after) 'Closure invalid'
Assert (!(Test-LtDestinationOutstanding $after)) 'Transport hold not released'
Assert ((Test-LtRecord $after $null @() 'OFFICEASSIST' 'Live' '') -ceq 'AdministrativelyRetired') 'Dispatch not blocked'
Assert (!(Test-PrExhaustedAmbiguousRecord $before 30)) 'Original guard weakened'
Assert ($after.state -ceq 'Queued' -and !$after.receipt -and !$after.result) 'Recipient state changed'
Assert (($after.attempts|ConvertTo-Json -Depth 10 -Compress) -ceq ($before.attempts|ConvertTo-Json -Depth 10 -Compress)) 'Attempts changed'
$copy=$after|ConvertTo-Json -Depth 30|ConvertFrom-Json
$copy.PSObject.Properties.Remove('administrative_closure');$copy.events=@();$copy.updated_at_utc=$before.updated_at_utc
Assert (($copy|ConvertTo-Json -Depth 30 -Compress) -ceq ($before|ConvertTo-Json -Depth 30 -Compress)) 'Original content changed'
$passed++;Write-Host 'PASS exact retirement preserves history and blocks dispatch'
foreach($action in @('StartAttempt','ConditionalClaim','Accept','StartProcessing','Update','Complete','Block','NeedsWes','Reject','MarkAttempt','ReconcileAttempt')){
    $hash=(Get-FileHash $path).Hash;$caught=$false
    try{& $manager -Action $action -QueuePath $queue -MessageId $id -ActorProjectRoom 'Doc Scan' -ActorTaskId $seed.destination.task_id|Out-Null}catch{$caught=$_.Exception.Message -eq 'MessageAdministrativelyRetired'}
    Assert $caught ('Late action not rejected: '+$action);Assert ((Get-FileHash $path).Hash -eq $hash) 'Late action mutated record'
    $passed++;Write-Host ('PASS retired rejection '+$action)
}
foreach($fault in @('actor','owner','generation','mode','sid','machine','hash','version','id','payload','pending','incomplete','attempt-id','attempt-count','receipt','result','recipient-event','reference')){
    Reset-Fixture;$a=Args;$r=Read-LtJson $path;$o=Read-LtJson $ownerPath
    switch($fault){
        actor {$a.ActorTaskId='33333333-3333-4333-8333-333333333333'}
        owner {$a.TransportOwner='low-token-other'}
        generation {$a.Generation='wrong'}
        mode {$a.Mode='Validation'}
        sid {$o.sid='S-1-0-0'}
        machine {$o.machine='OTHER'}
        hash {$a.ExpectedHash='0'*64}
        version {$a.ExpectedRecordVersion='0'*64}
        id {$r.message_id='wrong-message-id'}
        payload {$r.payload.synthetic_test=$false}
        pending {$r.attempts[2].outcome='Pending'}
        incomplete {$r.attempts[2].completed_at_utc=$null}
        attempt-id {$r.attempts[1].attempt_id='other-attempt'}
        attempt-count {$r.attempt_count=2}
        receipt {$r.receipt=@{task_id=$seed.destination.task_id}}
        result {$r.result=@{state='Completed'}}
        recipient-event {$r.events=@(@{event='Accepted'})}
        reference {$a.AuthorizationReference=''}
    }
    Write-LtJson $path $r;Write-LtJson $ownerPath $o
    if($fault -ne 'version'){$a.ExpectedRecordVersion=Get-PrMessageDigest ($r|ConvertTo-Json -Depth 30 -Compress)}
    $hash=(Get-FileHash $path).Hash;$caught=$false
    try{& $manager @a|Out-Null}catch{$caught=$true}
    Assert $caught ('Guard accepted '+$fault);Assert ((Get-FileHash $path).Hash -eq $hash) ('Guard mutated '+$fault)
    $passed++;Write-Host ('PASS guard '+$fault)
}
[pscustomobject]@{passed=$passed;failed=0;fixture_root=$root;production_queue_accessed=$false}|ConvertTo-Json
