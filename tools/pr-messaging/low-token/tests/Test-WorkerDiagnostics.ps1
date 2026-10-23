[CmdletBinding()]
param([string]$EvidenceDirectory)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Test-LowTokenWorker.ps1" -LibraryOnly
Check 'literal runs preserve exact escape bytes and literal backslash sequences' {
    $plain='{"text":"long uninterrupted text A&B <tag> can''t \\u0027"}'
    $html='{"text":"long uninterrupted text A\u0026B \u003ctag\u003e can\u0027t \\u0027"}'
    Assert ((Convert-PrMessageJsonEscaping $plain $true) -ceq $html)
    Assert ((Convert-PrMessageJsonEscaping $html $false) -ceq $plain)
}
Check 'diagnostics preserve successful phase and claim evidence' {
    $f=Fixture;$h=Tick $f
    Assert ($h.status -eq 'TickComplete' -and $h.claims -eq 1 -and (CountSubmissions $f) -eq 1)
    foreach($name in @('preflight','List','journal_reconciliation','candidate_evaluation','claim_and_submission')){Assert (@($h.diagnostics.phases|Where-Object name -eq $name).Count -ge 1) ('Missing '+$name)}
    Assert ($h.diagnostics.hash_checks.calls -gt 0)
    Assert ($h.diagnostics.before_conditional_claim.Count -eq 1)
    Assert (@($h.diagnostics.manager_calls|Where-Object action -eq 'ConditionalClaim').Count -eq 1)
    Assert (!(($h.diagnostics|ConvertTo-Json -Depth 15) -match 'synthetic_test|stdout|stderr|authorization'))
}
Check 'diagnostics preserve failed preflight without overwriting tick health' {
    $f=Fixture;$c=Read-LtJson $f.config;$c.manager_sha256='0'*64;Write-LtJson $f.config $c
    Write-LtJson (Join-Path $f.state 'health.json') @{sentinel='unchanged'}
    $h=Tick $f
    $d=Read-LtJson (Join-Path $f.state 'preflight-health.json')
    Assert ($h.status -eq 'Blocked' -and $d.error_code -eq 'ManagerReleaseMismatch')
    Assert ($h.failure_before_claim -eq $true -and $h.failure_phase -eq 'preflight' -and $h.claim_attempts -eq 0)
    Assert ((Read-LtJson (Join-Path $f.state 'health.json')).sentinel -eq 'unchanged')
    Assert ($d.diagnostics.phases[0].name -eq 'preflight' -and (CountSubmissions $f) -eq 0)
}
Check 'canonical manager reads BOM-less UTF-8 without changing immutable text' {
    $f=Fixture;$r=Record $f
    $r.payload|Add-Member note ('Rule '+[char]0x00a7+' '+[char]0x2014+' '+[char]0x201c+'quoted'+[char]0x201d)
    $r.payload_hash=Get-LtPayloadHash $r
    SaveRecord $f $r
    $x=(& $legacy -Action Get -QueuePath $f.queue -MessageId $f.id)|ConvertFrom-Json
    Assert ($x.payload.note -ceq $r.payload.note) 'Canonical manager changed UTF-8 text'
    Assert ((Get-PrMessageHashEvidence $x).valid) 'Canonical manager returned hash-invalid text'
}
Check 'terminal UTF-8 record closes orphan plan without claim or submission' {
    $f=Fixture;$r=Record $f
    $r.payload|Add-Member evidence_reference ('Invoice Entry skill '+[char]0x00a7+' approved delivery')
    $r.payload_hash=Get-LtPayloadHash $r
    $r.state='Needs Wes'
    $r.receipt=[pscustomobject]@{message_id=$r.message_id;dispatch_id=$r.dispatch_id;payload_hash=$r.payload_hash;accepted_at_utc='2026-10-08T11:35:07Z';project_room=$r.destination.project_room;task_id=$r.destination.task_id;machine=$r.destination.machine;detail='Fixture acceptance'}
    $r.result=[pscustomobject]@{state='Needs Wes';completed_at_utc='2026-10-08T11:35:42Z';detail='Fixture preserves unresolved recipient decision';data=[pscustomobject]@{submitted=$false}}
    SaveRecord $f $r
    $recordBefore=Get-LtVersion (Record $f)
    $entry=[pscustomobject]@{message_id=$r.message_id;dispatch_id=$r.dispatch_id;destination_task_id=$r.destination.task_id;payload_hash=$r.payload_hash;attempt_id='lt-8be621d704e74884a01c8085669c7a87';phase='planned';outcome=$null;created_at_utc='2026-10-08T00:00:00Z';submission_started_at_utc=$null;submission_completed_at_utc=$null;adapter_release='0.4.8';adapter_sha256=('a'*64);submission_evidence=$null}
    Write-LtJson (Join-Path $f.state 'journal.json') ([pscustomobject]@{schema_version=2;machine=$env:COMPUTERNAME;sid=[Security.Principal.WindowsIdentity]::GetCurrent().User.Value;owner='fixture-worker';generation='g1';created_at_utc='2026-10-08T00:00:00Z';entries=@($entry)})
    $h=Tick $f
    $after=Record $f;$j=Read-LtJson (Join-Path $f.state 'journal.json')
    Assert ($h.status -eq 'TickComplete' -and $h.claims -eq 0 -and $h.submissions -eq 0 -and $h.claim_attempts -eq 0)
    Assert ((CountSubmissions $f) -eq 0 -and $after.attempt_count -eq 0 -and @($after.attempts).Count -eq 0)
    Assert ((Get-LtVersion $after) -ceq $recordBefore) 'Central record changed during orphan-plan recovery'
    Assert (@($j.entries).Count -eq 1 -and $j.entries[0].phase -ceq 'closed' -and $j.entries[0].outcome -ceq 'NotClaimed')
    Assert ($after.state -ceq 'Needs Wes' -and $after.receipt.payload_hash -ceq $r.payload_hash -and $after.result.data.submitted -eq $false)
}
Check 'diagnostics survive post-claim failure without duplicate submission' {
    $f=Fixture;$h=Tick $f 'Validation' 'AfterClaim'
    Assert ($h.error -eq 'InjectedAfterClaim' -and $h.diagnostics.before_conditional_claim.Count -eq 1)
    $h=Tick $f
    Assert ((CountSubmissions $f) -eq 0 -and (Record $f).attempt_count -eq 1)
}
Check 'snapshot reuses unchanged evidence and rejects altered immutable content' {
    $f=Fixture;$r=Record $f;$script:PrHashMetrics=@{calls=0;calculations=0;cache_hits=0;elapsed_ms=0.0}
    Start-PrIntegritySnapshot
    Assert (Get-PrMessageHashEvidence $r).valid
    Assert (Get-PrMessageHashEvidence $r).valid
    Assert ($script:PrHashMetrics.calculations -eq 1 -and $script:PrHashMetrics.cache_hits -eq 1)
    $r.payload.synthetic_test=$false
    Assert (!(Get-PrMessageHashEvidence $r).valid)
    Assert ($script:PrHashMetrics.calculations -eq 2)
    Stop-PrIntegritySnapshot
    Start-PrIntegritySnapshot
    Assert (!(Get-PrMessageHashEvidence $r).valid)
    Assert ($script:PrHashMetrics.calculations -eq 3) 'Cache crossed snapshot boundary'
    Stop-PrIntegritySnapshot;$script:PrHashMetrics=$null
}
Check 'atomic claim rereads altered state and payload after cached validation' {
    foreach($fault in @('payload','state')){
        $f=Fixture;$r=Record $f;$args=ClaimArgs $f
        Start-PrIntegritySnapshot;Assert (Get-PrMessageHashEvidence $r).valid
        if($fault -eq 'payload'){$r.payload.synthetic_test=$false}else{$r.state='Blocked'}
        SaveRecord $f $r
        $rejected=$false
        try{$answer=(& $manager @args|Out-String)|ConvertFrom-Json;$rejected=(!$answer.claimed)}catch{$rejected=$_.Exception.Message -eq 'ImmutableHashMismatch'}
        Stop-PrIntegritySnapshot
        Assert $rejected ('Cached evidence accepted altered '+$fault)
        Assert ((Record $f).attempt_count -eq 0)
    }
}
$summary=@{passed=@($results|Where-Object passed).Count;failed=@($results|Where-Object {!$_.passed}).Count;tests=$results}
if($EvidenceDirectory){Write-LtJson (Join-Path $EvidenceDirectory 'diagnostics-tests.json') $summary}
$summary|ConvertTo-Json -Depth 7
if($summary.failed){exit 1}
