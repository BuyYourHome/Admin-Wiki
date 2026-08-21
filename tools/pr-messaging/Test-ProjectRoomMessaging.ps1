[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$manager = Join-Path $PSScriptRoot "Manage-ProjectRoomMessage.ps1"
$testRoot = Join-Path $env:TEMP ("pr-messaging-test-" + [guid]::NewGuid().ToString("N"))
$queue = Join-Path $testRoot "queue"
$spool = Join-Path $testRoot "spool"

try {
    & $manager -Action Initialize -QueuePath $queue | Out-Null
    $sent = & $manager -Action Send -QueuePath $queue -SpoolPath $spool -MessageId "test-message-001" -DispatchId "test-dispatch-001" -MessageType request -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "invoice-task" -AuthorizationJson '{"authorized_by":"Wes"}' -ReferencesJson '[{"kind":"test","value":"source-1"}]' -PayloadJson '{"requested_action":"test"}' | ConvertFrom-Json
    if ($sent.state -ne "Queued" -or -not $sent.authoritative) { throw "Send assertion failed." }

    $duplicate = & $manager -Action Send -QueuePath $queue -SpoolPath $spool -MessageId "test-message-001" -DispatchId "test-dispatch-001" -MessageType request -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "invoice-task" -AuthorizationJson '{"authorized_by":"Wes"}' -ReferencesJson '[{"kind":"test","value":"source-1"}]' -PayloadJson '{"requested_action":"test"}' | ConvertFrom-Json
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

    $spooled = & $manager -Action Send -QueuePath $queue -SpoolPath $spool -ForceOffline -MessageId "test-message-002" -MessageType improvement -SourceProjectRoom "Doc Scan" -SourceTaskId "doc-task" -DestinationProjectRoom "Jean Wright" -DestinationTaskId "jean-task" -PayloadJson '{"problem":"test"}' | ConvertFrom-Json
    if ($spooled.state -ne "Pending Host" -or $spooled.authoritative) { throw "Offline spool assertion failed." }
    $synced = & $manager -Action SyncSpool -QueuePath $queue -SpoolPath $spool | ConvertFrom-Json
    if ($synced.count -ne 1) { throw "Spool sync assertion failed." }

    $conflict = $false
    try {
        & $manager -Action Send -QueuePath $queue -MessageId "test-message-001" -MessageType request -SourceProjectRoom "Jean Wright" -SourceTaskId "jean-task" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "invoice-task" -PayloadJson '{"different":true}' | Out-Null
    }
    catch { $conflict = $true }
    if (-not $conflict) { throw "Immutable conflict assertion failed." }

    $health = & $manager -Action Health -QueuePath $queue -SpoolPath $spool | ConvertFrom-Json
    if (-not $health.available -or $health.total_messages -ne 2) { throw "Health assertion failed." }

    [pscustomobject]@{ result = "PASS"; messages = $health.total_messages; offline_spool_synced = $synced.count; conflict_detected = $conflict } | ConvertTo-Json
}
finally {
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot -Recurse -Force }
}
