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

1. Save the durable message before sending a Codex task notification. `Send` requires an exact nonblank `destination.machine` resolved from the active destination manifest; never serialize a missing, wildcard, inferred, or `null` destination machine.
2. Treat task notification as a wake-up signal, not proof of delivery.
3. The destination verifies its Project Room, task id, message id, and payload hash before accepting.
4. The destination writes `Accepted` before substantive work, then `Processing`, meaningful updates, and exactly one final result. Authorization is evaluated from the verified same-ID central record, not from the task that relayed its wake-up. A dispatcher or another task may carry the wake-up without becoming the source or authorization authority.
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
- The target architecture is one deterministic Windows worker and one dedicated dispatcher task per computer, not one heartbeat per destination Project Room. The dispatcher task id must not be reused as an operational destination task id; otherwise that destination cannot be safely notified without self-notification. The worker polls every 60 seconds, 24/7, without starting a model on empty polls. A destination model turn starts only after an eligible central record is atomically claimed.
- A legacy five-minute model heartbeat is a temporary fallback only. Keep it paused after that machine's deterministic worker takes exclusive transport ownership. Never run the worker and legacy heartbeat as concurrent owners for the same destination machine.
- Dispatcher health consumers must honor the health file's operating-window metadata and `next_scheduled_run_at_utc`. Expected inactivity outside the operating window is not stale or failed dispatcher health.
- Each scheduled dispatcher invocation is a new operational run. A one-turn diagnostic, read-only, or no-claim instruction from an earlier dispatcher task turn expires with that turn and must not suppress a later scheduled run. Only an explicit persistent pause or disable instruction from Wes may suppress an active dispatcher automation.
- During staged migration, the OfficeAssist Email Monitor dispatcher stage remains the fallback until OFFICEASSIST has a separate dispatcher task and its deterministic worker passes validation. After cutover, remove only the dispatcher stage from Email Monitor; mailbox monitoring and summaries retain their own schedule.
- During the OFFICEASSIST validation interval, Email Monitor may remain ACTIVE only through the installer's explicit active-embedded-fallback exception. The machine-scoped Validation owner must be written before the worker is enabled, causing any legacy dispatcher `StartAttempt` to fail closed. This exception does not authorize overlapping claims and applies only to the exact OfficeAssist Email Monitor automation.
- The worker uses a machine-scoped ownership record under `.transport-owners`. While that record exists, legacy `StartAttempt` calls for the owned destination machine must fail closed. This permits one computer at a time to migrate without disabling transport on the others.
- The local dispatcher polls only central records whose `destination.machine` exactly matches its own computer name and whose state is `Queued` or `Delivery Ambiguous`.
- Use `tools\pr-messaging\low-token\Invoke-LowTokenWorker.ps1` for deterministic production polling after validated installation. Its atomic `ConditionalClaim` and reconciliation operations must access the queue only through `Manage-ProjectRoomMessage.ps1`. `Claim-ProjectRoomDispatch.ps1` remains the legacy-heartbeat fallback until that machine is migrated.
- Run the claim helper through an approved unrestricted/escalated PowerShell execution under the normal Windows identity so the machine's saved SMB credential is available. The offline Codex sandbox intentionally lacks that credential; sandbox `Access is denied` is not evidence that the central host is unavailable.
- Before notification, it reconciles the current central state, immutable payload hash, destination manifest, exact task id, local client registration, prior attempts, and final-state history. It writes `StartAttempt` before exactly one same-ID task notification.
- It must never execute destination work, alter an immutable payload, create substitute tasks, broaden authorization, or treat notification as delivery proof.
- The destination must write `Accepted`, `Processing`, and a valid final state under its exact identity. Missing acknowledgment after a bounded wait is `Delivery Ambiguous`; a definitive local notification failure is `NotDelivered`.
- Do not automatically retry a `Delivery Ambiguous` attempt merely because its attempt count is below the immutable maximum. Retry the same immutable message only after authoritative reconciliation proves the prior attempt `NotDelivered`. Existing immutable authorization then remains sufficient; do not require a new payload, replacement record, or repeated user instruction.
- A tool-wrapper parse or syntax failure before PowerShell starts is not a helper run and not a delivery attempt. Retry the identical wrapper once in the same heartbeat. If the second wrapper also fails, report the exact underlying error and leave the record unchanged.
- The deterministic claim result must include candidate and skip counts. Empty polls remain silent when those counts reconcile; an internally inconsistent no-claim result is an actionable dispatcher blocker.
- A successful CLI queue acknowledgment is not recipient acceptance. Retain the durable destination slot until exact `Accepted` and terminal evidence arrives. Never retry a possibly submitted attempt automatically.
- Release `0.4.1` writes a permanent marker immediately before invoking the Codex queue command. A non-timeout, nonzero adapter exit with no marker is proven pre-submission failure and must be reconciled as `NotDelivered`. A timeout, queue acknowledgment, existing marker, receipt, or conflicting evidence remains ambiguous and must not be retried automatically.
- Release `0.4.2` must launch recurring worker ticks through its hash-pinned `wscript.exe` wrapper with window style `0`. Direct scheduled execution of `powershell.exe`, including `-WindowStyle Hidden`, is prohibited because it may briefly display a console and interrupt the interactive user.
- An authorized administrative closure may release an exhausted, old `Delivery Ambiguous` transport hold only after verifying the immutable hash, full-record version, absent receipt/result, completed attempt history, exact live owner, dispatcher task, Windows identity, machine, generation, and a recorded Wes authorization reference. It preserves the ambiguous state and attempt history, claims neither delivery nor business completion, and is not a destination final result.
- Wes may explicitly cancel an old, non-exhausted `Delivery Ambiguous` status-only record when it authorized no business action or production claims and evidence confirms no business action, live automation call, forced run, receipt, or result. The canonical manager must verify the immutable hash, full-record version, completed attempt history, exact live owner and attempt ownership, dispatcher task, Windows identity, machine, generation, and Wes authorization reference. Preserve the ambiguous state and attempt history, record delivery as unresolved, release only the transport hold, and reject any later acceptance of the administratively closed record.
- Wes may separately authorize cancellation of an old `Delivery Attempted` status-only record whose one exact Pending attempt has a successful durable queue acknowledgment but no recipient receipt or result. Use only `AdministrativeCancelAcknowledgedStatus`. It must verify the cross-runtime immutable hash, full-record version, exact Pending attempt, live owner and attempt ownership, release `0.4.6` config and pinned adapter/CLI hashes, journal identity, successful queue acknowledgment, permanent submission marker, exact notification text, adapter result, destination identity, and Wes authorization reference. Preserve the Pending attempt and all evidence, record delivery as unresolved, claim neither delivery nor business completion, release only the transport hold, and reject later acceptance.
- Immutable verification may accept a legacy Windows PowerShell round-trip serialization candidate for values that PowerShell 7 materializes as `DateTime`. This compatibility is read-only: it converts only typed date values in the verification copy to the seven-digit UTC round-trip form, never reparses arbitrary strings, and never changes the stored payload or hash.
- A queued CLI submission may remain pending while its existing destination task is `notLoaded`. Opening that exact task may allow the original queued request to run. Do not create or send a second wake-up solely because the task was unloaded; reconcile the original central attempt.
- Machine-local dispatcher health may record run status and claim metadata outside the central queue. Health is observability only and never proves notification, acceptance, processing, or completion.
- Empty worker polls consume no model tokens and are strictly silent. Notify Wes only through an explicit attention workflow for a new actionable blocker or decision; the transport worker itself performs no destination or business work.
- Run the one-minute PowerShell worker with hidden-window mode. Its scheduled tick must not open a visible console, take keyboard focus, or interrupt typing on an interactive workstation.
- Worker installation, scheduled-task state, profile-local packages, health files, and `.transport-owners` records are runtime state outside Git. Git records tools, policy, manifests, and verified deployment status. A runtime-only change does not require an empty commit on that machine.
- If a worker source hotfix is published after `Stage`, refresh the machine's staged profile-local package from the pulled source before validation or promotion. Pulling Git alone does not update an already staged package.

A Project Room created on or moved to another computer is not dispatchable until an unattended cross-machine validation starts on a different computer, is discovered by the destination computer's local dispatcher, and reaches `Accepted`, `Processing`, and `Completed` without manual pasting or direct user activation. A manually pasted synthetic lifecycle proves queue and task identity only; it does not prove dispatcher readiness.

To avoid a circular readiness gate, Create PR may place one destination in `validation_ready` while keeping `dispatchable: false`. The destination manifest must name one exact pending validation message id, the verified dispatcher task and automation ids, and the source and destination machines. A machine-local dispatcher may bypass `dispatchable: false` only for that exact record when its payload explicitly contains `synthetic_test: true` and authorizes and performs no business action. It must skip all production records until the validation completes and Create PR records `manual_intervention: false` and sets `dispatchable: true`.

Worker staging must reject a local registration unless its one exact manifest explicitly records either `dispatchable: true` with `messaging_readiness.status: ready`, or `dispatchable: false` with `messaging_readiness.status: validation_ready` and one exact nonblank validation message id. A legacy bare `dispatchable: true` value is not sufficient staging evidence.

## Message Types

- `request`: owned work.
- `question`: bounded clarification or source context.
- `status`: meaningful progress or changed blocker.
- `decision`: the smallest choice needed from Wes.
- `result`: a final return.
- `improvement`: a failure, workaround, unclear ownership, missing rule, or repeated problem that needs correction.

## Monitored Completion Returns

- When a source PR remains the completion owner after delegating a child action, the source records a durable waiting state and the destination returns its terminal outcome through exactly one immutable `result` message.
- Set the result record's `parent_message_id` to the child request message id. Preserve the originating dispatch id when the manager permits the same immutable correlation; otherwise use a unique return dispatch id that includes or references the parent dispatch id in the payload.
- Address the result to the source PR's exact registered task and machine. The source manifest must accept `result`; a missing registration, non-dispatchable source, or unsupported message type is an infrastructure blocker.
- The result payload should contain the destination final state, concise result, evidence references, exact blocker or decision when any, and whether a business or external action occurred. Do not copy source documents, secrets, full email bodies, or unrelated history into the return.
- The normal dispatcher delivers the result record. The receiving source verifies the link, identity, payload hash, and destination's terminal central state before resuming. A result wake-up carries outcome evidence, not fresh authority and not permission to repeat an ambiguous or completed external action.
- Deduplicate monitored returns by result message id, parent message id, dispatch correlation, and payload hash. Never create repeated return records merely because a wake-up was delayed or ambiguous.

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
