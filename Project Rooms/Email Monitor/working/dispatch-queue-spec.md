# Durable Project Room Dispatch Queue

## Purpose

Use a durable runtime record as the authoritative cross-Project-Room handoff. Codex task messaging is a best-effort wake-up signal and never the sole copy of a dispatch.

## Runtime Location

`\\WES-VIDEOEDITOR\BYH-PRMessaging$\records\<message_id>.json`

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

1. Build every Email Monitor Project Room handoff through `Project Rooms\Email Monitor\tools\Send-EmailMonitorProjectRoomHandoff.ps1`. Do not call the shared manager's `Send` action directly from Email Monitor.
2. Before central creation, the builder must validate the exact message type, manifest-resolved destination Project Room/task/machine, nonempty payload, and at least one immutable source reference. It must reject an incomplete package without calling the shared manager.
3. The authorization object must contain nonblank `authorized_by`, exact `instruction`, explicit `scope`, matching `evidence_reference`, and Boolean `business_action_authorized`. The referenced evidence must name the same actual authorizer or sender. Never label Wes as the authorizer from another sender's message, inherit authority from the wake-up task, or insert authorization merely to pass validation.
4. For email-originated authority, preserve the authorizing mailbox message as a reference with a stable `reference_id`, Outlook message id or link, exact sender, received time, and subject. For task-originated authority, preserve the task/thread and turn reference plus the exact authorizer. Additional source references may preserve the routed invoice, attachment, or prior record separately.
5. Create the durable record before calling a task-message tool.
6. Use one stable dispatch ID and immutable payload. A duplicate ID with different content is a conflict.
7. Verify that the registered destination task is idle before starting a notification attempt. If idle state cannot be established, leave the record queued.
8. Mark `StartAttempt` immediately before the task-message call.
9. Include the dispatch ID, queue-record path, concise source pointer, and instruction to write `accepted` before substantive work.
10. Reconcile a timeout by reading destination history and the durable record. Mark `Delivery Ambiguous` when neither proves acceptance.
11. Retry only when the destination is idle, the exact dispatch ID is absent from destination history, the durable record is not accepted, and the attempt limit is not exhausted. Reuse the same dispatch ID.
12. Send one OfficeAssist email to Wes before the routing run ends whenever a dispatch remains unacknowledged. Record the verified Sent Items message ID with `MarkAlertSent`. Do not suppress the first email because the workflow health state was already warning or critical.

## Receiver Contract

1. On every Invoice Entry startup and backup-monitor run, inspect queue records addressed to the registered Invoice Entry task.
2. Deduplicate by dispatch ID and payload hash.
3. Confirm the source pointer is accessible and the request belongs to Invoice Entry.
4. Run `Accept` with the registered Invoice Entry task ID before substantive work, then reply `accepted: <dispatch_id>` when the task channel is available.
5. Run `StartProcessing` before durable processing and `Complete` or `Fail` when the outcome is known.
6. Treat queue presence as intake authority only. It does not authorize approval, payment, filing, workbook posting, vendor contact, or another gated action.

## Tool

Email Monitor creates new records only through `C:\Codex\Wiki Files\Project Rooms\Email Monitor\tools\Send-EmailMonitorProjectRoomHandoff.ps1`, which validates authorization, evidence, destination, and message type before it delegates to the shared manager. Use `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1` for later queue lifecycle mutations. The shared manager provides locking, atomic record replacement, payload hashing, idempotent creation and acceptance, bounded attempts, offline spooling, and explicit state transitions; it does not currently enforce Email Monitor's complete authorization schema. The former Email Monitor queue is preserved read-only as legacy history; do not create new records there.
