[CmdletBinding()]
param([string]$EvidencePath)
$ErrorActionPreference='Stop'
. "$PSScriptRoot\..\CodexReadOnlyProbe.ps1"
. "$PSScriptRoot\..\..\low-token\Common.ps1"
$task='11111111-1111-4111-8111-111111111111';$cwd='C:\fixture';$results=@()
function Assert($Condition){if(!$Condition){throw 'Assertion failed'}}
function ReadResult([string]$Status='idle'){[pscustomobject]@{thread=[pscustomobject]@{id=$task;cwd=$cwd;status=[pscustomobject]@{type=$Status}}}}
function Check([string]$Name,[scriptblock]$Body){try{& $Body;$script:results+=@{name=$Name;passed=$true}}catch{$script:results+=@{name=$Name;passed=$false;error=$_.Exception.Message}}}
$empty=[pscustomobject]@{data=@();nextCursor=$null}
Check 'two idle reads and empty pending page' {$r=Get-CpDisposition (ReadResult) $empty (ReadResult) $task $cwd;Assert (!$r.defer -and $r.disposition -eq 'IdleObserved')}
Check 'active destination deferred without pending lookup' {$r=Get-CpDisposition (ReadResult 'active') $null $null $task $cwd;Assert ($r.defer -and $r.reason -eq 'ActiveTask')}
Check 'pending submission deferred' {$q=[pscustomobject]@{data=@(@{id='pending-1'});nextCursor=$null};$r=Get-CpDisposition (ReadResult) $q (ReadResult) $task $cwd;Assert ($r.defer -and $r.reason -eq 'QueuedSubmissionExists')}
foreach($status in @('notLoaded','systemError','unknown','Idle','')){Check ('unknown runtime status '+$status) {$r=Get-CpDisposition (ReadResult $status) $empty (ReadResult) $task $cwd;Assert $r.defer}}
Check 'missing thread snapshot' {Assert (Get-CpDisposition $null $empty $null $task $cwd).defer}
Check 'wrong thread identity' {$b=ReadResult;$b.thread.id='other';Assert ((Get-CpDisposition $b $empty $b $task $cwd).reason -eq 'IdentityOrRepositoryMismatch')}
Check 'wrong repository' {$b=ReadResult;$b.thread.cwd='C:\other';Assert (Get-CpDisposition $b $empty $b $task $cwd).defer}
Check 'missing pending result' {Assert (Get-CpDisposition (ReadResult) $null (ReadResult) $task $cwd).defer}
Check 'missing pending data is not empty' {Assert (Get-CpDisposition (ReadResult) ([pscustomobject]@{}) (ReadResult) $task $cwd).defer}
Check 'pending data wrong type' {Assert (Get-CpDisposition (ReadResult) ([pscustomobject]@{data='empty'}) (ReadResult) $task $cwd).defer}
Check 'pagination cannot hide pending work' {$q=[pscustomobject]@{data=@();nextCursor='next'};Assert (Get-CpDisposition (ReadResult) $q (ReadResult) $task $cwd).defer}
Check 'second read absent' {Assert (Get-CpDisposition (ReadResult) $empty $null $task $cwd).defer}
Check 'destination became active' {$r=Get-CpDisposition (ReadResult) $empty (ReadResult 'active') $task $cwd;Assert ($r.defer -and $r.reason -eq 'BecameActive')}
Check 'second read unknown' {Assert (Get-CpDisposition (ReadResult) $empty (ReadResult 'notLoaded') $task $cwd).defer}
Check 'second read identity drift' {$a=ReadResult;$a.thread.id='other';Assert (Get-CpDisposition (ReadResult) $empty $a $task $cwd).defer}
Check 'only allowlisted read-only protocol calls' {
    $seen=[Collections.Generic.List[string]]::new()
    $exchange={param($request) $seen.Add($request.method);switch($request.method){initialize {return @{userAgent='fixture'}} initialized {return} 'thread/read' {Assert (!$request.params.includeTurns);return (ReadResult)} 'thread/queue/list' {Assert ($request.params.limit -eq 1);return $empty} default {throw 'Unexpected mutation'}}}.GetNewClosure()
    $s=Invoke-CpProtocol $exchange $task
    Assert (($seen -join ',') -ceq 'initialize,initialized,thread/read,thread/queue/list,thread/read')
    Assert (!(Get-CpDisposition $s.before $s.queue $s.after $task $cwd).defer)
}
Check 'busy protocol never sends a task mutation or queue request' {
    $seen=[Collections.Generic.List[string]]::new()
    $exchange={param($request) $seen.Add($request.method);switch($request.method){initialize {return @{userAgent='fixture'}} initialized {return} 'thread/read' {return (ReadResult 'active')} default {throw 'Unexpected call'}}}.GetNewClosure()
    $s=Invoke-CpProtocol $exchange $task
    Assert (($seen -join ',') -ceq 'initialize,initialized,thread/read');Assert (Get-CpDisposition $s.before $s.queue $s.after $task $cwd).defer
}
Check 'unavailable process is unknown and deferred' {$r=Invoke-CpRuntime 'C:\nonexistent-byh-probe\codex.exe' $task $cwd 1;Assert ($r.defer -and $r.disposition -eq 'Unknown' -and !$r.canary_gate_satisfied -and $r.submissions -eq 0)}
$summary=[ordered]@{completed_at_utc=[DateTime]::UtcNow.ToString('o');passed=@($results|Where-Object passed -eq $true).Count;failed=@($results|Where-Object passed -eq $false).Count;tests=$results;real_cli_submissions=0;central_mutations=0}
if($EvidencePath){Assert-LtUnder $EvidencePath ([IO.Path]::GetTempPath());Write-LtJson $EvidencePath $summary}
$summary|ConvertTo-Json -Depth 6
if($summary.failed){exit 1}
