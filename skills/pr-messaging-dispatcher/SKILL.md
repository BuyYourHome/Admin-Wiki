---
name: pr-messaging-dispatcher
description: Run one machine-local Buy Your Home Project Room messaging transport per computer, using the 24/7 deterministic low-token worker where validated and a model heartbeat only as a temporary fallback.
---

# PR Messaging Dispatcher

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\PR Messaging Dispatcher`
- Heartbeat prompt: `C:\Codex\Wiki Files\Project Rooms\PR Messaging Dispatcher\working\heartbeat-prompt.md`
- Messaging rule: `C:\Codex\Wiki Files\Project Room Messaging Rule.md`
- Manager: `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1`
- Deterministic claim helper: `C:\Codex\Wiki Files\tools\pr-messaging\Claim-ProjectRoomDispatch.ps1`

## Purpose

Provide the host-local wake-up layer for Project Room messages addressed to tasks on the computer running this dispatcher. The shared SMB queue is authoritative and cross-machine; Codex task notification is local to the destination host.

## Required Behavior

1. Prefer the validated deterministic worker: poll every 60 seconds, 24/7, and start no model turn on an empty poll. Use the five-minute weekday model heartbeat only as a temporary fallback on a machine not yet migrated.
2. Read the canonical heartbeat prompt and messaging rules at every run.
3. Treat each scheduler invocation as a new operational run. Do not carry forward a prior one-turn diagnostic, read-only, or no-claim instruction after that earlier turn ends. Only an explicit persistent pause or disable instruction from Wes suppresses an active scheduled run.
4. Determine the actual local computer name.
5. In worker mode, use the installed hash-pinned release under the normal Windows identity so its saved SMB credential and local Codex CLI are available. The worker owns queue selection, atomic claim, exact manifest and registration checks, durable journal recovery, duplicate prevention, and local health. In fallback mode, run the legacy claim helper once through `powershell.exe -NoProfile -ExecutionPolicy Bypass -File` using the approved unrestricted path.
   - Normal scheduled runs omit `-MessageId` and retain oldest-first selection.
   - When Wes explicitly limits one run to one immutable record, pass `-MessageId "<exact-message-id>"`. The helper must scope the record set before candidate selection and fail closed if that exact record is missing or ineligible. Do not carry a one-run filter into later scheduled runs.
6. If the tool wrapper fails before PowerShell starts, retry the identical wrapper once. A pre-execution wrapper retry is not another helper run or delivery attempt. Report the exact underlying error after a second wrapper failure.
7. When the helper returns a claim, notify the returned exact destination once without reinterpreting eligibility or authorization. Identify the notification as a wake-up signal and require canonical-record verification.
8. When the helper returns no claim, end silently when its candidate and skip counts are consistent. Report an internally inconsistent result as an actionable helper blocker.
9. Require `dispatchable: true`, except for one exact manifest-authorized `validation_ready` synthetic record that authorizes and performs no business action. Never use that exception for production work.
10. `StartAttempt` must already exist before exactly one local notification.
11. Require the destination to write `Accepted`, `Processing`, and one valid final state.
12. Wait up to 120 seconds for destination progress and reconcile the authoritative record again immediately before marking a definitive failure `NotDelivered` or uncertainty `DeliveryAmbiguous`.
13. Remain silent on empty polls and unchanged conditions.
14. Dispatcher health consumers must honor the schedule metadata and `next_scheduled_run_at_utc` written by the claim helper. Closed nights and weekends are expected inactivity, not stale health.
15. A successful CLI queue submission to a destination reported as `notLoaded` may remain pending until that existing task is opened. Preserve the original submission and reconcile it; do not send a second wake-up merely because the task was unloaded.
16. Configure every scheduled worker action through the release-pinned `wscript.exe` hidden launcher so the one-minute poll creates no console and never steals focus from the interactive user. `powershell.exe -WindowStyle Hidden` is insufficient because its console may appear before PowerShell processes that option.
17. Never retry a `Delivery Ambiguous` attempt automatically. Release `0.4.1` may classify a non-timeout, nonzero adapter exit as `NotDelivered` only when the permanent submission marker is absent. Timeouts, acknowledgments, existing markers, receipts, or conflicting evidence remain unresolved.
18. Use the guarded administrative closure only for an exhausted, old no-receipt ambiguity after exact owner, identity, hash, record-version, attempt-history, and Wes-authorization checks. Closure releases only the transport slot and never claims recipient delivery or business completion.

## Boundaries

- Never execute destination work.
- Never change payloads, authorization, destination, or source references.
- Never create substitute tasks or replacement records as a retry.
- Never notify tasks assigned to another machine.
- Never claim delivery without an exact central receipt.
- Never exceed the record's attempt limit.

## Deployment

- Use one dedicated dispatcher task and one deterministic Windows worker per computer. The dispatcher task id must be separate from every operational destination task id on that computer so each destination, including Email Monitor, remains eligible for notification and self-notification is impossible.
- WES-VIDEOEDITOR task: `PR Messaging Dispatcher - WES-VIDEOEDITOR`, task `01a05d0c-8031-7d92-9474-ab2330008ddb`.
- WES-VIDEOEDITOR automation id: `pr-messaging-dispatcher-wes-videoeditor`.
- WESSTUDIO task: `PR Messaging Dispatcher - WESSTUDIO`, task `01a06337-1b59-7dc2-9586-6660eb7b5da7`.
- WESSTUDIO automation id: `pr-messaging-dispatcher`.
- OFFICEASSIST may retain its Email Monitor dispatcher stage only until its separate worker and dispatcher task pass unattended validation. Then remove only that embedded stage.
- For OFFICEASSIST validation, use `-AllowActiveEmbeddedFallback` only with automation `officeassist-morning-email-summary-and-instruction-monitor`. The machine-scoped Validation owner blocks its embedded dispatcher before the deterministic worker starts; the exception keeps mailbox monitoring active but never permits overlapping claims.
- Install release `0.4.5` through `tools\pr-messaging\low-token\Install-LowTokenWorker.ps1`: `Stage`, one exact synthetic `StartValidation`, and `PromoteLive` only after verified completion. Existing live `0.4.0` or later machines use `UpgradeLive`, which preserves the owner generation, journal, state directory, task identity, schedule, and destination pins while replacing the hash-pinned package and task launcher. Release `0.4.5` retains the closed-history and integrity-quarantine controls, permits a bounded 180-second tick, and gives the canonical manager up to 60 seconds for list calls and 120 seconds for atomic mutation calls, always capped by the remaining tick budget. A hash-invalid terminal record remains blocking unless Wes explicitly authorizes the exact machine-local owner to apply `AdministrativeQuarantineIntegrityFailure`; that action preserves the corrupted record and releases only its transport hold. `Rollback` preserves journals and central records.
- Staging admits only an explicit `ready` and dispatchable manifest, or one explicit `validation_ready`, non-dispatchable manifest with an exact validation message id. Never stage from a legacy bare `dispatchable: true` declaration.
- If source files change after `Stage`, pull the corrective commit and refresh the staged package before continuing. Never assume the profile-local installed package changed merely because the Git repository changed.
- Machine-scoped ownership must block the legacy dispatcher for only the migrated destination machine. Never activate overlapping transport owners.
- Scheduled tasks, profile-local packages, health files, and central transport-owner records are runtime state outside Git. Record verified deployment status in the canonical repository from the coordinating task; do not require a runtime-only machine to create an empty commit.
- A cross-machine Project Room is not dispatchable until an unattended remote-source lifecycle passes without manual pasting.
- Store only a short pointer in the automation prompt requiring every run to reread `Project Rooms\PR Messaging Dispatcher\working\heartbeat-prompt.md` and `Project Room Messaging Rule.md`. Never copy the full policy into the automation prompt; copied policy becomes stale after repository updates.

## Start PR Pointer

Start PR: Before durable work, follow `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Wake only the exact owning task; never perform its work.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
