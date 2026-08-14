# Durable Project Room Dispatch Queue

## Purpose

Use a durable runtime record as the authoritative cross-Project-Room handoff. Codex task messaging is a best-effort wake-up signal and never the sole copy of a dispatch.

## Runtime Location

`C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\dispatch-queue\records\<dispatch_id>.json`

Do not place operational queue records in Git. Keep queue tools and this specification in the Admin wiki.

## States

- `Queued`: durable record exists and no notification attempt is active.
- `Send Attempted`: one bounded task-message attempt is active.
- `Delivery Ambiguous`: the attempt timed out, blocked, or ended without independent delivery proof.
- `Accepted`: the destination wrote an `accepted` receipt using the same dispatch ID.
- `Processing`: the owning Project Room started substantive work.
- `Completed`: the owning Project Room recorded its final result.
- `Failed`: the dispatch or destination workflow reached a meaningful failure.

## Sender Contract

1. Create the durable record before calling a task-message tool.
2. Use one stable dispatch ID and immutable payload. A duplicate ID with different content is a conflict.
3. Verify that the registered destination task is idle before starting a notification attempt. If idle state cannot be established, leave the record queued.
4. Mark `StartAttempt` immediately before the task-message call.
5. Include the dispatch ID, queue-record path, concise source pointer, and instruction to write `accepted` before substantive work.
6. Reconcile a timeout by reading destination history and the durable record. Mark `Delivery Ambiguous` when neither proves acceptance.
7. Retry only when the destination is idle, the exact dispatch ID is absent from destination history, the durable record is not accepted, and the attempt limit is not exhausted. Reuse the same dispatch ID.
8. Send one OfficeAssist email to Wes before the routing run ends whenever a dispatch remains unacknowledged. Record the verified Sent Items message ID with `MarkAlertSent`. Do not suppress the first email because the workflow health state was already warning or critical.

## Receiver Contract

1. On every Invoice Entry startup and backup-monitor run, inspect queue records addressed to the registered Invoice Entry task.
2. Deduplicate by dispatch ID and payload hash.
3. Confirm the source pointer is accessible and the request belongs to Invoice Entry.
4. Run `Accept` with the registered Invoice Entry task ID before substantive work, then reply `accepted: <dispatch_id>` when the task channel is available.
5. Run `StartProcessing` before durable processing and `Complete` or `Fail` when the outcome is known.
6. Treat queue presence as intake authority only. It does not authorize approval, payment, filing, workbook posting, vendor contact, or another gated action.

## Tool

Use `Project Rooms\Email Monitor\tools\Manage-EmailMonitorDispatch.ps1` for all queue mutations. The script uses a process-safe mutex, atomic record replacement, payload hashing, idempotent creation and acceptance, bounded attempts, and explicit state transitions.
