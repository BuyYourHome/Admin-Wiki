[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$root = Join-Path $env:TEMP ('invoice-entry-run-closure-' + [guid]::NewGuid().ToString('N'))
$helper = Join-Path $PSScriptRoot 'Test-InvoiceEntryRunClosure.ps1'
. 'C:\Codex\Wiki Files\tools\pr-messaging\Message-Integrity.ps1'
function Write-Fixture([string]$Id, [string]$State, [string]$Variant = '') {
    $immutable = [ordered]@{
        message_type = 'request'; parent_message_id = ''
        source = [ordered]@{project_room='Fixture';task_id='fixture';machine='OFFICEASSIST'}
        destination = [ordered]@{project_room='Invoice Entry';task_id='01a03956-fa4f-77c1-9ab7-f709e5f1174e';machine='OFFICEASSIST'}
        authorization = [ordered]@{authorized_by='Fixture';instruction='Read-only test';scope='No business action';evidence_reference='fixture';business_action_authorized=$false}
        references = @(); payload = [ordered]@{fixture=$true}
    }
    if ($Variant -eq 'wrong-destination') { $immutable.destination.task_id = 'other-task' }
    $hash = Get-PrMessageDigest ($immutable | ConvertTo-Json -Depth 30 -Compress)
    $record = [ordered]@{message_id=$Id;dispatch_id=$Id;payload_hash=$hash;state=$State;authoritative=$true}
    foreach ($key in $immutable.Keys) { $record[$key] = $immutable[$key] }
    $record.receipt = [ordered]@{message_id=$Id;payload_hash=$hash;project_room='Invoice Entry';task_id=$immutable.destination.task_id;machine='OFFICEASSIST';accepted_at_utc='2026-01-01T01:00:00Z'}
    $record.result = $null
    if ($State -in @('Completed','Needs Wes','Blocked')) {
        $record.result = [ordered]@{state=$State;detail='Fixture verified outcome';machine='OFFICEASSIST';completed_at_utc='2026-01-01T01:01:00Z';data=[ordered]@{}}
        if ($Variant -eq 'owned-blocker') { $record.result.data = [ordered]@{blocker_owner='Fixture Owner';next_action='Resolve the exact fixture question.'} }
    }
    if ($Variant -eq 'no-result') { $record.result = $null }
    if ($Variant -eq 'tampered') { $record.payload.fixture = $false }
    if ($Variant -eq 'not-authoritative') { $record.authoritative = $false }
    if ($Variant -eq 'bad-receipt') { $record.receipt.payload_hash = '0' * 64 }
    $record | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath (Join-Path $root "records\$Id.json") -Encoding UTF8
}
try {
    New-Item -ItemType Directory -Path (Join-Path $root 'records') -Force | Out-Null
    New-Item -ItemType File -Path (Join-Path $root '.invoice-entry-run-closure-fixture') | Out-Null
    $cases = @(
        @('accepted','Accepted','',$false),
        @('idle-processing','Processing','',$false),
        @('bare-needs-wes','Needs Wes','',$false),
        @('owned-needs-wes','Needs Wes','owned-blocker',$true),
        @('completed','Completed','',$true),
        @('false-completion','Completed','no-result',$false),
        @('changed-payload','Completed','tampered',$false),
        @('non-authoritative','Completed','not-authoritative',$false),
        @('wrong-task','Completed','wrong-destination',$false),
        @('wrong-receipt','Completed','bad-receipt',$false)
    )
    foreach ($case in $cases) {
        Write-Fixture $case[0] $case[1] $case[2]
        $actual = (& $helper -QueuePath $root -MessageId $case[0]) | ConvertFrom-Json
        if ($actual.can_end_run -ne $case[3]) { throw "Unexpected closure decision: $($case[0])" }
    }
    $stopped = $false
    try { $null = & $helper -QueuePath $root -MessageId 'idle-processing' -FailIfUnfinished }
    catch { if ($_.Exception.Message -like 'InvoiceEntryRunIncomplete:*') { $stopped = $true } else { throw } }
    if (!$stopped) { throw 'The required run-ending failure did not stop idle Processing.' }
    $attention = (& $helper -QueuePath $root -MessageId 'owned-needs-wes') | ConvertFrom-Json
    if (!$attention.attention_items[0].requires_user_attention -or $attention.attention_items[0].owner -ne 'Fixture Owner') { throw 'Owned user attention was lost.' }
    [pscustomobject]@{passed=$true;cases=$cases.Count;idle_processing_stops_run=$stopped;owned_attention_preserved=$true;production_queue_touched=$false} | ConvertTo-Json
} finally {
    $absolute = [IO.Path]::GetFullPath($root)
    $allowed = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    if (!$absolute.StartsWith($allowed,[StringComparison]::OrdinalIgnoreCase) -or
        (Split-Path -Leaf $absolute) -notlike 'invoice-entry-run-closure-*') { throw 'Refusing unsafe fixture cleanup.' }
    if (Test-Path -LiteralPath $absolute) { Remove-Item -LiteralPath $absolute -Recurse -Force }
}
