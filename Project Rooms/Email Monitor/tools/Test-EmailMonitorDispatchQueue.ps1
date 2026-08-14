[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$manager = Join-Path $PSScriptRoot "Manage-EmailMonitorDispatch.ps1"
$queue = Join-Path $env:TEMP ("email-monitor-dispatch-test-" + [guid]::NewGuid().ToString("N"))
$dispatchId = "test-dispatch-001"

try {
    $source = '{"mailbox":"OfficeAssist@example.com","outlook_message_id":"message-1","outlook_link":"https://example.invalid/message-1"}'
    $payload = '{"attachments":"none","summary":"Test invoice","requested_operation":"Create Vendor Invoice","unique_warning":"none"}'

    $created = & $manager -Action Create -QueuePath $queue -DispatchId $dispatchId -Mode "Route Vendor Invoice" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "task-1" -SourceJson $source -PayloadJson $payload | ConvertFrom-Json
    if ($created.state -ne "Queued" -or $created.attempt_count -ne 0) { throw "Create assertion failed." }

    $duplicate = & $manager -Action Create -QueuePath $queue -DispatchId $dispatchId -Mode "Route Vendor Invoice" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "task-1" -SourceJson $source -PayloadJson $payload | ConvertFrom-Json
    if ($duplicate.payload_hash -ne $created.payload_hash) { throw "Idempotent create assertion failed." }

    $attempt = & $manager -Action StartAttempt -QueuePath $queue -DispatchId $dispatchId -AttemptId "attempt-1" | ConvertFrom-Json
    if ($attempt.state -ne "Send Attempted" -or $attempt.attempt_count -ne 1) { throw "StartAttempt assertion failed." }

    $ambiguous = & $manager -Action MarkAttempt -QueuePath $queue -DispatchId $dispatchId -AttemptId "attempt-1" -AttemptOutcome DeliveryAmbiguous -Detail "Simulated busy destination" | ConvertFrom-Json
    if ($ambiguous.state -ne "Delivery Ambiguous") { throw "DeliveryAmbiguous assertion failed." }

    $alerted = & $manager -Action MarkAlertSent -QueuePath $queue -DispatchId $dispatchId -MessageId "sent-1" -Detail "Test alert" | ConvertFrom-Json
    if ($alerted.alert_message_id -ne "sent-1") { throw "MarkAlertSent assertion failed." }

    $accepted = & $manager -Action Accept -QueuePath $queue -DispatchId $dispatchId -ReceiptTaskId "task-1" -Detail "Test receipt" | ConvertFrom-Json
    if ($accepted.state -ne "Accepted" -or $accepted.receipt.status -ne "accepted") { throw "Accept assertion failed." }

    $processing = & $manager -Action StartProcessing -QueuePath $queue -DispatchId $dispatchId | ConvertFrom-Json
    if ($processing.state -ne "Processing") { throw "StartProcessing assertion failed." }

    $completed = & $manager -Action Complete -QueuePath $queue -DispatchId $dispatchId -Detail "Test complete" | ConvertFrom-Json
    if ($completed.state -ne "Completed") { throw "Complete assertion failed." }

    $conflictDetected = $false
    try {
        & $manager -Action Create -QueuePath $queue -DispatchId $dispatchId -Mode "Route Vendor Invoice" -DestinationProjectRoom "Invoice Entry" -DestinationTaskId "task-1" -SourceJson $source -PayloadJson '{"summary":"Different content"}' | Out-Null
    }
    catch {
        $conflictDetected = $true
    }
    if (-not $conflictDetected) { throw "Conflicting duplicate assertion failed." }

    [pscustomobject]@{
        result = "PASS"
        dispatch_id = $dispatchId
        final_state = $completed.state
        attempts = $completed.attempt_count
        conflict_detected = $conflictDetected
    } | ConvertTo-Json
}
finally {
    if (Test-Path -LiteralPath $queue) {
        Remove-Item -LiteralPath $queue -Recurse -Force
    }
}
