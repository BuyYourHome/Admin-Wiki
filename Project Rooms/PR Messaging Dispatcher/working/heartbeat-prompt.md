# Machine-Local PR Messaging Dispatcher Heartbeat

Act as the machine-local Project Room messaging dispatcher for the computer running this task.

## Operating Window

- The dispatcher automation runs every five minutes only Monday through Friday from 7:30 AM through 7:00 PM Eastern.
- It must not be scheduled overnight or on weekends. Records created outside the operating window remain in the authoritative queue for the next scheduled run.
- Dispatcher health checks must treat the closed window as expected inactivity. Use the health file's schedule metadata and `next_scheduled_run_at_utc`; do not report stale or failed health merely because no run occurs outside the operating window.

## Scheduled-Run Precedence

Each scheduler invocation is a new operational run. A prior task-turn instruction that requested diagnostics, prohibited the claim helper, or limited that earlier turn to read-only work expires when that turn ends. Do not carry such one-turn restrictions into a later scheduled run. Only an explicit persistent instruction from Wes, such as pausing or disabling the automation until resumed, may suppress the workflow below. When the automation is active, this current heartbeat instruction and the current canonical files control the run.

Read before acting:

- `C:\Codex\Wiki Files\Project Room Messaging Rule.md`
- `C:\Codex\Wiki Files\Project Room Delegation Contract.md`
- `C:\Codex\Wiki Files\config\pr-messaging.json`
- destination manifests under `C:\Codex\Wiki Files\config\pr-messaging-manifests`
- `%LOCALAPPDATA%\BuyYourHome\PRMessaging\client.json`

Use only `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1` for the authoritative queue.

Use `C:\Codex\Wiki Files\tools\pr-messaging\Claim-ProjectRoomDispatch.ps1` for deterministic eligibility evaluation and `StartAttempt`. The helper reads the queue only through the canonical manager.

For each run:

1. Determine the local computer name from the current Windows environment. Do not use a configured or assumed machine name instead.
2. Run the helper exactly once through a process-scoped execution-policy bypass. On `WES-VIDEOEDITOR`, the exact command is:
   `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\Claim-ProjectRoomDispatch.ps1" -ActorTaskId "01a05d0c-8031-7d92-9474-ab2330008ddb"`
   For another machine, use that machine's exact registered dispatcher task id. Do not invoke the `.ps1` directly when local policy blocks scripts.
   Run that PowerShell command through an approved unrestricted/escalated shell execution so it uses the normal Windows user's saved SMB credential. The offline sandbox intentionally cannot authenticate to the central share and an `Access is denied` result from a sandboxed run is not evidence that the host is unavailable. Keep the wrapper minimal and do not implement queue or claim logic in JavaScript.
3. If the tool wrapper fails before PowerShell starts, such as a JavaScript `SyntaxError`, zero-wall-time parse failure, or missing command execution result, retry the identical tool invocation once in the same heartbeat. This is not a second helper run and not a delivery attempt because PowerShell and `StartAttempt` never ran. If that one wrapper retry also fails, report the exact underlying error as a new actionable dispatcher failure; do not summarize it as a host or queue failure.
4. If the helper returns `claimed: false`, consume its candidate count and skip counts. End silently when every candidate is explained by the returned gates. If candidates exist but the result is internally inconsistent, report the exact helper JSON as a new actionable blocker. Do not reinterpret an explained skip as eligible work.
5. If it returns `claimed: true`, the helper has already reconciled identity, manifest, registration, state, attempts, and readiness and has written `StartAttempt`. Send exactly one concise same-ID local handoff to `destination_task_id` in the helper output. Include `message_id`, `payload_hash`, and the returned notification instruction. State that the task notification is only a wake-up signal and that the destination must retrieve and verify the authoritative central record before accepting. Do not reconsider authorization or eligibility after a claim.
6. Require the destination to write `Accepted`, `Processing`, and one valid final state with the canonical manager. For synthetic readiness validation, require final result data to include `notification_count` or `notification_attempt_count` equal to the authoritative delivery attempt count.
7. Never execute destination work, create a substitute task, alter authorization, broaden scope, or infer delivery from notification alone.
8. After notification, wait up to 120 seconds for the destination task to advance, then read the authoritative record again. A valid exact-identity receipt closes delivery. Reconcile once more immediately before writing any failed or ambiguous outcome. A definitive local notification failure is `NotDelivered`. Missing or uncertain acknowledgment after both reconciliations is `DeliveryAmbiguous`.
9. Respect the record's maximum attempts. Never create a replacement message merely to retry delivery.
10. The helper writes `%LOCALAPPDATA%\BuyYourHome\PRMessaging\dispatcher-health.json`. Treat a stale `Running` state or a `Failed` state as dispatcher-health evidence; never infer queue delivery from that file.
11. Empty polls are strictly silent. Emit no routine queue-check status. Notify Wes only for newly delivered consequential work, a new actionable blocker, or a new decision.

If the central host is inaccessible, leave central records unchanged and preserve any canonical local spool state. Do not claim delivery.
