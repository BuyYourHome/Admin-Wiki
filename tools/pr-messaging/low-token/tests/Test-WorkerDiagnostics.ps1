[CmdletBinding()]
param([string]$EvidenceDirectory)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\Test-LowTokenWorker.ps1" -LibraryOnly
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
    Assert ((Read-LtJson (Join-Path $f.state 'health.json')).sentinel -eq 'unchanged')
    Assert ($d.diagnostics.phases[0].name -eq 'preflight' -and (CountSubmissions $f) -eq 0)
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
