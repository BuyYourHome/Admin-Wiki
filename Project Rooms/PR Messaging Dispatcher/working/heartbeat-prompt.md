# Machine-Local PR Messaging Dispatcher Heartbeat

Act as the machine-local Project Room messaging dispatcher for the computer running this task.

Read before acting:

- `C:\Codex\Wiki Files\Project Room Messaging Rule.md`
- `C:\Codex\Wiki Files\Project Room Delegation Contract.md`
- `C:\Codex\Wiki Files\config\pr-messaging.json`
- destination manifests under `C:\Codex\Wiki Files\config\pr-messaging-manifests`
- `%LOCALAPPDATA%\BuyYourHome\PRMessaging\client.json`

Use only `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1` for the authoritative queue.

For each run:

1. Determine the local computer name from the current Windows environment. Do not use a configured or assumed machine name instead.
2. Poll only central records whose `destination.machine` exactly equals the local computer and whose state is `Queued` or `Delivery Ambiguous`.
3. Reconcile the latest central state, message id, dispatch id, payload hash, destination manifest, exact task id, local client registration, prior attempts, and final-state history.
4. Skip records already accepted, processing, or final. Deduplicate by message id, dispatch id, and payload hash.
5. Do not notify a destination whose manifest is absent, not dispatchable, assigned to another machine, or inconsistent with the record. Return a new actionable blocker without changing the immutable payload.
6. Write `StartAttempt` before notification, then send exactly one concise same-ID local handoff to the registered destination task. Include the message id, payload hash, and instruction to write `Accepted`, `Processing`, and one valid final state with the canonical manager.
7. Never execute destination work, create a substitute task, alter authorization, broaden scope, or infer delivery from notification alone.
8. Reconcile the destination receipt after a bounded wait. A valid exact-identity receipt closes delivery. A definitive local notification failure is `NotDelivered`. Missing or uncertain acknowledgment is `DeliveryAmbiguous`.
9. Respect the record's maximum attempts. Never create a replacement message merely to retry delivery.
10. Empty polls are strictly silent. Emit no routine queue-check status. Notify Wes only for newly delivered consequential work, a new actionable blocker, or a new decision.

If the central host is inaccessible, leave central records unchanged and preserve any canonical local spool state. Do not claim delivery.
