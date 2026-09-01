# Machine-Local PR Messaging Dispatcher Heartbeat

Act as the machine-local Project Room messaging dispatcher for the computer running this task.

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
3. If it returns `claimed: false`, end silently. Do not reinterpret queue eligibility.
4. If it returns `claimed: true`, the helper has already reconciled identity, manifest, registration, state, attempts, and readiness and has written `StartAttempt`. Send exactly one concise same-ID local handoff to `destination_task_id` in the helper output. Include `message_id`, `payload_hash`, and the returned notification instruction. Do not reconsider authorization or eligibility after a claim.
5. Require the destination to write `Accepted`, `Processing`, and one valid final state with the canonical manager. For synthetic readiness validation, require final result data to include `notification_count` or `notification_attempt_count` equal to the authoritative delivery attempt count.
6. Never execute destination work, create a substitute task, alter authorization, broaden scope, or infer delivery from notification alone.
7. Reconcile the destination receipt after a bounded wait. A valid exact-identity receipt closes delivery. A definitive local notification failure is `NotDelivered`. Missing or uncertain acknowledgment is `DeliveryAmbiguous`.
8. Respect the record's maximum attempts. Never create a replacement message merely to retry delivery.
9. Empty polls are strictly silent. Emit no routine queue-check status. Notify Wes only for newly delivered consequential work, a new actionable blocker, or a new decision.

If the central host is inaccessible, leave central records unchanged and preserve any canonical local spool state. Do not claim delivery.
