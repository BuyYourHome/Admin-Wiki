# Project Room Messaging Rule

This rule governs durable messages between Buy Your Home Project Rooms across one or more computers.

## Authority And Host

- Central host: `WES-VIDEOEDITOR`.
- Shared queue: `\\WES-VIDEOEDITOR\BYH-PRMessaging$`.
- Canonical configuration: `C:\Codex\Wiki Files\config\pr-messaging.json`.
- Canonical message tool: `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1`.
- Live message records remain outside Git. Git contains rules, schemas, manifests, tools, tests, and deployment instructions only.

The shared queue became authoritative for production Project Room messages after host installation, client registration, legacy reconciliation, and automatic end-to-end validation on 2026-08-21. `legacy_queue_remains_authoritative` in `config\pr-messaging.json` is the rollback control. The former Email Monitor queue is preserved read-only as legacy history.

## Message Contract

1. Save the durable message before sending a Codex task notification.
2. Treat task notification as a wake-up signal, not proof of delivery.
3. The destination verifies its Project Room, task id, message id, and payload hash before accepting.
4. The destination writes `Accepted` before substantive work, then `Processing`, meaningful updates, and exactly one final result.
5. Valid final states are `Completed`, `Blocked`, `Needs Wes`, and `Rejected as Wrong Room`.
6. Reconcile `Delivery Ambiguous` against the central record and task history before retrying the same immutable message.
7. A missing task id, unavailable host, or inaccessible source is a blocker. It is not permission to execute another PR's work locally.
8. Corrections use a new linked message. Do not overwrite the immutable payload of the original message.

## Multi-Machine Behavior

- PR ownership belongs to the Project Room, not the computer running it.
- Every approved computer registers its PR/task identities as a messaging client.
- The central record on `WES-VIDEOEDITOR` is authoritative for delivery and processing state.
- If the host is unavailable, a sender may create a local `Pending Host` spool record. It must report that the message is not delivered.
- A spooled message becomes authoritative only after synchronization to the central host and hash verification.
- Cross-machine updates use the shared file lock in the canonical message tool. Do not hand-edit runtime JSON records.

## Machine-Local Dispatcher Requirement

The shared queue is cross-machine, but Codex task notification is host-local. A durable central record does not by itself wake a task on another computer.

- Every computer that hosts dispatchable Project Room tasks must have one active machine-local PR Messaging Dispatcher capability.
- Use one dispatcher task and heartbeat per computer, not one heartbeat per destination Project Room.
- Each scheduled dispatcher invocation is a new operational run. A one-turn diagnostic, read-only, or no-claim instruction from an earlier dispatcher task turn expires with that turn and must not suppress a later scheduled run. Only an explicit persistent pause or disable instruction from Wes may suppress an active dispatcher automation.
- The OfficeAssist Email Monitor heartbeat may satisfy this requirement for `OFFICEASSIST` while its dispatcher stage remains active and verified. Other computers should use a dedicated `PR Messaging Dispatcher - <COMPUTERNAME>` task unless a documented local heartbeat already provides the same bounded behavior.
- The local dispatcher polls only central records whose `destination.machine` exactly matches its own computer name and whose state is `Queued` or `Delivery Ambiguous`.
- Use `tools\pr-messaging\Claim-ProjectRoomDispatch.ps1` to select and claim one eligible record deterministically. The helper must access and change the authoritative queue only through `Manage-ProjectRoomMessage.ps1`; the model must not redo or override its eligibility decision.
- Before notification, it reconciles the current central state, immutable payload hash, destination manifest, exact task id, local client registration, prior attempts, and final-state history. It writes `StartAttempt` before exactly one same-ID task notification.
- It must never execute destination work, alter an immutable payload, create substitute tasks, broaden authorization, or treat notification as delivery proof.
- The destination must write `Accepted`, `Processing`, and a valid final state under its exact identity. Missing acknowledgment after a bounded wait is `Delivery Ambiguous`; a definitive local notification failure is `NotDelivered`.
- A `Delivery Ambiguous` record requires a bounded same-ID retry when it has no accepted receipt or final result, no prior attempt remains pending, its attempt count is below the immutable maximum, and the destination currently passes its manifest gate. The dispatcher must write `StartAttempt` and notify in that run. Existing immutable authorization is sufficient; do not require a new authorization, approval, payload change, state change, or user instruction. Never create a replacement.
- A tool-wrapper parse or syntax failure before PowerShell starts is not a helper run and not a delivery attempt. Retry the identical wrapper once in the same heartbeat. If the second wrapper also fails, report the exact underlying error and leave the record unchanged.
- The deterministic claim result must include candidate and skip counts. Empty polls remain silent when those counts reconcile; an internally inconsistent no-claim result is an actionable dispatcher blocker.
- After notification, allow up to 120 seconds for destination startup and reconcile the authoritative record again immediately before marking delivery `NotDelivered` or `Delivery Ambiguous`.
- Machine-local dispatcher health may record run status and claim metadata outside the central queue. Health is observability only and never proves notification, acceptance, processing, or completion.
- Empty polls are strictly silent. Notify Wes only for newly delivered consequential work, a new actionable blocker, or a new decision.

A Project Room created on or moved to another computer is not dispatchable until an unattended cross-machine validation starts on a different computer, is discovered by the destination computer's local dispatcher, and reaches `Accepted`, `Processing`, and `Completed` without manual pasting or direct user activation. A manually pasted synthetic lifecycle proves queue and task identity only; it does not prove dispatcher readiness.

To avoid a circular readiness gate, Create PR may place one destination in `validation_ready` while keeping `dispatchable: false`. The destination manifest must name one exact pending validation message id, the verified dispatcher task and automation ids, and the source and destination machines. A machine-local dispatcher may bypass `dispatchable: false` only for that exact record when its payload explicitly contains `synthetic_test: true` and authorizes and performs no business action. It must skip all production records until the validation completes and Create PR records `manual_intervention: false` and sets `dispatchable: true`.

## Message Types

- `request`: owned work.
- `question`: bounded clarification or source context.
- `status`: meaningful progress or changed blocker.
- `decision`: the smallest choice needed from Wes.
- `result`: a final return.
- `improvement`: a failure, workaround, unclear ownership, missing rule, or repeated problem that needs correction.

## Security And Privacy

- The host share must require authenticated Windows access, SMB encryption, NTFS restrictions, and a Private-profile firewall rule scoped to the approved subnet.
- Use a separate host-local transport account for each remote client computer. Name it `PRMsg-<ComputerName>`, grant only `Change` on the messaging share and `Modify` on its backing folder, and store its SMB credential only in that computer's normal Windows profile. The transport account is not an interactive Windows login and must not be shared across computers.
- On `WES-VIDEOEDITOR`, authorize the normal host identity explicitly for local queue work. As verified on 2026-08-24, the host identity is `WES-VIDEOEDITOR\IRAMa`; the approved remote transport identities are `WES-VIDEOEDITOR\PRMsg-OfficeAssist` and `WES-VIDEOEDITOR\PRMsg-WesStudio`.
- New computers require their own restricted `PRMsg-*` account, share and NTFS entries, persistent authenticated SMB connection, machine-local client registration, and canonical read/write validation before they may process messages. Do not restore a shared Microsoft-account credential or grant a remote computer's ordinary Windows login direct access as a shortcut.
- Keep machine-local client configuration under `%LOCALAPPDATA%\BuyYourHome\PRMessaging\client.json` for the normal Windows profile that runs Codex. Register only PR/task identities authorized to execute on that computer, and remove stale registrations after a task moves to another computer.
- Back up the share and NTFS ACLs before access changes. Remove superseded principals only after every replacement client completes a canonical lifecycle test and successfully reauthenticates after its SMB session is closed.
- Do not place passwords, tokens, full email bodies, unnecessary personal data, financial credentials, or document copies in queue records.
- Store source references and authoritative paths instead of duplicating source files.
- Dashboard may show counts, age, state, and attention flags, but not sensitive payloads.

## Recovery

- If `WES-VIDEOEDITOR` is unavailable, preserve local spool records and do not claim delivery.
- Host removal must preserve message data by default.
- Restore the share and validate payload hashes before resuming clients.
- During rollback, set `live_migration_status` to `not_migrated`, set `legacy_queue_remains_authoritative` to `true`, pause the PR Messaging Dispatcher, and continue using the existing Email Monitor queue without copying or replaying completed records.

## PR Pointer

Every PR README and matching skill should use this short pointer:

`PR Messaging: Follow C:\Codex\Wiki Files\Project Room Messaging Rule.md. The central message record is authoritative; task messages are wake-up signals, not delivery proof.`
