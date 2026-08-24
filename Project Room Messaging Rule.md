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
