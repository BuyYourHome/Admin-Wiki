[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$manager = Join-Path $PSScriptRoot "Manage-ProjectRoomMessage.ps1"
$testRoot = Join-Path $env:TEMP ("pr-messaging-test-" + [guid]::NewGuid().ToString("N"))
$queue = Join-Path $testRoot "queue"
$spool = Join-Path $testRoot "spool"

try {
    & $manager -Action Initialize -QueuePath $queue | Out-Null
    $sent = & $manager -Action Send -QueuePath $queue -SpoolPath $spool -MessageId "test-message-001" -DispatchId "test-dispatch-001" -MessageType request -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "invoice-task" -DestinationMachine $env:COMPUTERNAME -AuthorizationJson '{"authorized_by":"Wes"}' -ReferencesJson '[{"kind":"test","value":"source-1"}]' -PayloadJson '{"requested_action":"test"}' | ConvertFrom-Json
    if ($sent.state -ne "Queued" -or -not $sent.authoritative) { throw "Send assertion failed." }

    $duplicate = & $manager -Action Send -QueuePath $queue -SpoolPath $spool -MessageId "test-message-001" -DispatchId "test-dispatch-001" -MessageType request -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "invoice-task" -DestinationMachine $env:COMPUTERNAME -AuthorizationJson '{"authorized_by":"Wes"}' -ReferencesJson '[{"kind":"test","value":"source-1"}]' -PayloadJson '{"requested_action":"test"}' | ConvertFrom-Json
    if ($duplicate.payload_hash -ne $sent.payload_hash) { throw "Idempotent send assertion failed." }

    & $manager -Action StartAttempt -QueuePath $queue -MessageId "test-message-001" -AttemptId "attempt-1" -ActorProjectRoom "Jean Wright" -ActorTaskId "jean-task" | Out-Null
    & $manager -Action MarkAttempt -QueuePath $queue -MessageId "test-message-001" -AttemptId "attempt-1" -AttemptOutcome DeliveryAmbiguous -Detail "simulated timeout" -ActorProjectRoom "Jean Wright" -ActorTaskId "jean-task" | Out-Null
    & $manager -Action StartAttempt -QueuePath $queue -MessageId "test-message-001" -AttemptId "attempt-2" -ActorProjectRoom "Jean Wright" -ActorTaskId "jean-task" | Out-Null
    & $manager -Action Accept -QueuePath $queue -MessageId "test-message-001" -ActorProjectRoom "Invoice Entry" -ActorTaskId "invoice-task" -Detail "accepted test" | Out-Null
    $accepted = & $manager -Action Get -QueuePath $queue -MessageId "test-message-001" | ConvertFrom-Json
    if ($accepted.attempts[-1].outcome -ne "Delivered" -or -not $accepted.attempts[-1].completed_at_utc) { throw "Accepted delivery attempt was not closed as Delivered." }
    & $manager -Action StartProcessing -QueuePath $queue -MessageId "test-message-001" -ActorProjectRoom "Invoice Entry" -ActorTaskId "invoice-task" | Out-Null
    & $manager -Action Update -QueuePath $queue -MessageId "test-message-001" -ActorProjectRoom "Invoice Entry" -ActorTaskId "invoice-task" -Detail "halfway" | Out-Null
    $completed = & $manager -Action Complete -QueuePath $queue -MessageId "test-message-001" -ActorProjectRoom "Invoice Entry" -ActorTaskId "invoice-task" -Detail "complete" -ResultJson '{"rows":1}' | ConvertFrom-Json
    if ($completed.state -ne "Completed" -or $completed.status_updates.Count -ne 1) { throw "Lifecycle assertion failed." }

    $spooled = & $manager -Action Send -QueuePath $queue -SpoolPath $spool -ForceOffline -MessageId "test-message-002" -MessageType improvement -SourceProjectRoom "Doc Scan" -SourceTaskId "doc-task" -DestinationProjectRoom "Jean Wright" -DestinationTaskId "jean-task" -DestinationMachine $env:COMPUTERNAME -PayloadJson '{"problem":"test"}' | ConvertFrom-Json
    if ($spooled.state -ne "Pending Host" -or $spooled.authoritative) { throw "Offline spool assertion failed." }
    $synced = & $manager -Action SyncSpool -QueuePath $queue -SpoolPath $spool | ConvertFrom-Json
    if ($synced.count -ne 1) { throw "Spool sync assertion failed." }

    & $manager -Action Send -QueuePath $queue -MessageId "test-message-003" -MessageType question -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "invoice-task" -DestinationMachine $env:COMPUTERNAME -PayloadJson '{"question":"test"}' | Out-Null
    & $manager -Action Accept -QueuePath $queue -MessageId "test-message-003" -ActorProjectRoom "Invoice Entry" -ActorTaskId "invoice-task" | Out-Null
    $needsWes = & $manager -Action NeedsWes -QueuePath $queue -MessageId "test-message-003" -ActorProjectRoom "Invoice Entry" -ActorTaskId "invoice-task" -Detail "test decision" | ConvertFrom-Json
    if ($needsWes.state -ne "Needs Wes") { throw "Needs Wes assertion failed." }

    & $manager -Action Send -QueuePath $queue -MessageId "test-message-004" -MessageType request -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Marketplace" -DestinationTaskId "marketplace-task" -DestinationMachine $env:COMPUTERNAME -PayloadJson '{"requested_action":"wrong room test"}' | Out-Null
    & $manager -Action Accept -QueuePath $queue -MessageId "test-message-004" -ActorProjectRoom "Marketplace" -ActorTaskId "marketplace-task" | Out-Null
    $rejected = & $manager -Action Reject -QueuePath $queue -MessageId "test-message-004" -ActorProjectRoom "Marketplace" -ActorTaskId "marketplace-task" -Detail "owned elsewhere" | ConvertFrom-Json
    if ($rejected.state -ne "Rejected as Wrong Room") { throw "Wrong-room rejection assertion failed." }

    & $manager -Action Send -QueuePath $queue -MessageId "test-message-005" -MessageType request -ParentMessageId "test-message-001" -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "invoice-task" -DestinationMachine $env:COMPUTERNAME -PayloadJson '{"correction":"linked test"}' | Out-Null
    $correction = & $manager -Action Get -QueuePath $queue -MessageId "test-message-005" | ConvertFrom-Json
    if ($correction.parent_message_id -ne "test-message-001") { throw "Linked correction assertion failed." }

    & $manager -Action Send -QueuePath $queue -MessageId "test-message-006" -MessageType request -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Doc Scan" -DestinationTaskId "doc-task" -DestinationMachine $env:COMPUTERNAME -PayloadJson '{"requested_action":"blocked test"}' | Out-Null
    & $manager -Action Accept -QueuePath $queue -MessageId "test-message-006" -ActorProjectRoom "Doc Scan" -ActorTaskId "doc-task" | Out-Null
    $blocked = & $manager -Action Block -QueuePath $queue -MessageId "test-message-006" -ActorProjectRoom "Doc Scan" -ActorTaskId "doc-task" -Detail "test blocker" | ConvertFrom-Json
    if ($blocked.state -ne "Blocked") { throw "Blocked assertion failed." }

    $conflict = $false
    try {
        & $manager -Action Send -QueuePath $queue -MessageId "test-message-001" -MessageType request -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "invoice-task" -DestinationMachine $env:COMPUTERNAME -PayloadJson '{"different":true}' | Out-Null
    }
    catch { $conflict = $true }
    if (-not $conflict) { throw "Immutable conflict assertion failed." }

    $health = & $manager -Action Health -QueuePath $queue -SpoolPath $spool | ConvertFrom-Json
    if (-not $health.available -or $health.total_messages -ne 6 -or $health.attention_messages -ne 3) { throw "Health assertion failed." }

    [pscustomobject]@{ result = "PASS"; messages = $health.total_messages; offline_spool_synced = $synced.count; conflict_detected = $conflict } | ConvertTo-Json
}
finally {
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot -Recurse -Force }
}
