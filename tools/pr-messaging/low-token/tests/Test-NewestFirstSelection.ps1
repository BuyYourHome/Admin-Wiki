[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Test-LowTokenWorker.ps1') -LibraryOnly
$script:passed=0;$script:failed=0
function Run([string]$Name,[scriptblock]$Body){try{& $Body;$script:passed++;Write-Host ('PASS '+$Name)}catch{$script:failed++;Write-Host ('FAIL '+$Name+': '+$_.Exception.Message)}}
function Clone($Value){$Value|ConvertTo-Json -Depth 30|ConvertFrom-Json}

Run 'newest eligible record is selected from a 371-record destination queue' {
    $f=Fixture
    $newest=Record $f
    $newest.created_at_utc='2026-11-17T12:00:00.0000000Z';$newest.updated_at_utc=$newest.created_at_utc
    SaveRecord $f $newest
    $records=[System.Collections.Generic.List[object]]::new()
    foreach($i in 1..250){
        $r=Clone $newest;$r.message_id=('older-queued-{0:D3}' -f $i);$r.dispatch_id=$r.message_id
        $r.created_at_utc=('2026-11-{0:D2}T00:00:00.0000000Z' -f (1+(($i-1)%15)));$r.updated_at_utc=$r.created_at_utc
        Write-LtJson (Join-Path $f.queue ('records\'+$r.message_id+'.json')) $r;$records.Add($r)
    }
    foreach($i in 1..120){
        $r=Clone $newest;$r.message_id=('older-accepted-{0:D3}' -f $i);$r.dispatch_id=$r.message_id
        $r.created_at_utc='2026-11-01T00:00:00.0000000Z';$r.updated_at_utc='2026-11-02T00:00:00.0000000Z';$r.state='Accepted'
        $r.receipt=[pscustomobject]@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME;accepted_at_utc='2026-11-02T00:00:00Z';message_id=$r.message_id;dispatch_id=$r.dispatch_id;payload_hash=$r.payload_hash}
        $r.events=@($r.events)+@([pscustomobject]@{event='Accepted';actor=[pscustomobject]@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME}})
        Write-LtJson (Join-Path $f.queue ('records\'+$r.message_id+'.json')) $r;$records.Add($r)
    }
    $records.Add($newest)
    $ordered=Get-LtOrderedCandidates $records
    Assert ($ordered.Count -eq 371 -and $ordered[0].message_id -ceq $f.id)
    $cachePath=Join-Path $f.state 'integrity-cache.json'
    $first=Get-LtIntegrityValidityIndex $records $cachePath $env:COMPUTERNAME ([Security.Principal.WindowsIdentity]::GetCurrent().User.Value)
    $second=Get-LtIntegrityValidityIndex $records $cachePath $env:COMPUTERNAME ([Security.Principal.WindowsIdentity]::GetCurrent().User.Value)
    Assert ($first.calculations -eq 120 -and $second.calculations -eq 0 -and $second.cache_hits -eq 120)
    $holds=Get-LtDestinationHoldIndex $records $second.validity
    $reason=Test-LtRecord $ordered[0] (Read-LtJson $f.client) @((Read-LtJson (Join-Path $f.manifests 'test.json'))) $env:COMPUTERNAME 'Validation' $f.id $records $second.validity $holds
    Assert ($reason -ceq 'Eligible') $reason
}

Run 'large-queue atomic claim permits one submission only' {
    $f=Fixture;$newest=Record $f;$newest.created_at_utc='2026-11-17T12:00:00.0000000Z';$newest.updated_at_utc=$newest.created_at_utc;SaveRecord $f $newest
    foreach($i in 1..370){
        $r=Clone $newest;$r.message_id=('historical-{0:D3}' -f $i);$r.dispatch_id=$r.message_id;$r.created_at_utc='2026-11-01T00:00:00.0000000Z';$r.updated_at_utc=$r.created_at_utc
        if($i -le 120){
            $r.state='Accepted';$r.updated_at_utc='2026-11-02T00:00:00.0000000Z'
            $r.receipt=[pscustomobject]@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME;accepted_at_utc='2026-11-02T00:00:00Z';message_id=$r.message_id;dispatch_id=$r.dispatch_id;payload_hash=$r.payload_hash}
            $r.events=@($r.events)+@([pscustomobject]@{event='Accepted';actor=[pscustomobject]@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME}})
        }
        Write-LtJson (Join-Path $f.queue ('records\'+$r.message_id+'.json')) $r
    }
    $args=ClaimArgs $f 'newest-large-queue-attempt'
    $watch=[Diagnostics.Stopwatch]::StartNew()
    $one=(& $manager @args)|ConvertFrom-Json
    $two=(& $manager @args)|ConvertFrom-Json
    Assert ($one.claimed -and $one.may_submit -and $two.claimed -and $two.idempotent -and !$two.may_submit)
    Assert ((Record $f).attempt_count -eq 1)
    Assert ($watch.Elapsed.TotalSeconds -lt 30) ('Atomic large-queue claims took '+$watch.Elapsed.TotalSeconds+' seconds')
}

Run 'atomic claim ignores a stale local cache and preserves an invalid-hash hold' {
    $f=Fixture;$target=Record $f;$target.created_at_utc='2026-11-17T12:00:00.0000000Z';$target.updated_at_utc=$target.created_at_utc;SaveRecord $f $target
    $bad=Clone $target;$bad.message_id='historical-invalid-accepted';$bad.dispatch_id=$bad.message_id;$bad.state='Accepted';$bad.created_at_utc='2026-11-01T00:00:00.0000000Z';$bad.updated_at_utc='2026-11-02T00:00:00.0000000Z'
    $bad.receipt=[pscustomobject]@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME;accepted_at_utc='2026-11-02T00:00:00Z';message_id=$bad.message_id;dispatch_id=$bad.dispatch_id;payload_hash=$bad.payload_hash}
    $bad.events=@($bad.events)+@([pscustomobject]@{event='Accepted';actor=[pscustomobject]@{project_room='Test Recipient';task_id=$f.task;machine=$env:COMPUTERNAME}})
    $bad.payload.synthetic_test=$false
    Write-LtJson (Join-Path $f.queue ('records\'+$bad.message_id+'.json')) $bad
    Write-LtJson (Join-Path $f.state 'integrity-cache.json') ([pscustomobject]@{schema_version=1;machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;authoritative=$false;entries=@([pscustomobject]@{message_id=$bad.message_id;fingerprint=(Get-LtIntegrityFingerprint $bad);valid=$true})})
    $args=ClaimArgs $f 'invalid-hold-attempt'
    $answer=(& $manager @args)|ConvertFrom-Json
    Assert (!$answer.claimed -and $answer.reason -ceq 'DestinationOutstanding')
    Assert ((Record $f).attempt_count -eq 0)
}

$summary=[ordered]@{release='0.4.12';passed=$script:passed;failed=$script:failed;large_queue_records=371;production_actions=0;real_submissions=0}
$summary|ConvertTo-Json -Depth 5
if($script:failed){exit 1}
