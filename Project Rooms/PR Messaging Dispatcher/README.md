# PR Messaging Dispatcher Project Room

## Purpose

Provide one machine-local dispatcher heartbeat on each computer that hosts dispatchable Buy Your Home Project Room tasks. The dispatcher bridges the cross-machine durable queue to Codex task notifications that are local to its own computer.

## Scope

In scope:

- Poll the authoritative queue with `Manage-ProjectRoomMessage.ps1`.
- Select and claim one eligible record with `Claim-ProjectRoomDispatch.ps1`, which uses the canonical manager for every queue operation.
- Process only records addressed to the dispatcher computer.
- Reconcile immutable identity, payload hash, manifest, task id, local registration, state, and prior attempts.
- Write `StartAttempt` before one concise same-ID local task notification.
- Require destination receipts and preserve uncertain delivery honestly.
- Record deterministic candidate/skip diagnostics and machine-local dispatcher health without treating health as delivery evidence.
- Retry one tool-wrapper failure only when PowerShell never started and no queue state changed.
- Remain silent on empty polls.

Out of scope:

- Performing destination Project Room work.
- Editing message payloads or authorization.
- Creating substitute tasks.
- Email, browser, accounting, file-processing, or business actions.
- Dispatching records addressed to another computer.

## Folder Map

- `sources\` - source references when needed.
- `working\heartbeat-prompt.md` - canonical machine-local heartbeat behavior.
- `working\source-inventory.md` - governing sources.
- `working\duplicate-and-conflict-log.md` - superseded assumptions and duplicate controls.
- `working\missing-context.md` - deployment blockers and unresolved machine details.
- `working\dispatcher-action-log.md` - material deployment and failure outcomes only.
- `outputs\WES-VIDEOEDITOR Deployment.md` - machine-specific deployment handoff.
- `C:\Codex\Wiki Files\tools\pr-messaging\Claim-ProjectRoomDispatch.ps1` - deterministic machine-local eligibility and `StartAttempt` helper.

## Status

Status: `Release 0.4.6 developed for controlled in-place upgrade after an OFFICEASSIST Codex update removed the worker's pinned CLI executable`.

WES-VIDEOEDITOR promoted release `0.4.0` after exact synthetic `prmsg-wve-low-token-worker-validation-20260913-001` completed with one delivered attempt and no business action, then upgraded in place to `0.4.1`. Scheduled task `BYH PR Messaging Worker - WES-VIDEOEDITOR` runs every 60 seconds in `Live` mode for its pinned Quickbooks destination. The old assisted QuickBooks task is disabled and the model-driven dispatcher heartbeat remains paused. OFFICEASSIST promoted after exact synthetic `prmsg-officeassist-low-token-worker-docscan-validation-20260914-001` completed through one delivered attempt, then upgraded in place to `0.4.1`. Its worker runs every 60 seconds in `Live` mode for Email Monitor, Doc Scan, and Invoice Entry, and Email Monitor's embedded dispatcher stage has been removed while its mailbox heartbeat remains active.

WESSTUDIO promoted after replacement synthetic `prmsg-officeassist-wesstudio-low-token-worker-validation-20260914-002` completed through one delivered attempt to Bathroom Fixtures with no business action or manual intervention. It then upgraded in place to release `0.4.1`. The original exhausted ambiguous validation `prmsg-officeassist-wesstudio-low-token-worker-validation-20260914-001` received an identity-bound administrative transport closure without a delivery or completion claim. A separate adapter-version rejection was proven to have occurred before submission, corrected to `NotDelivered`, retried once under the same immutable record, and then completed through Create PR's exact receipt and result. Scheduled task `BYH PR Messaging Worker - WESSTUDIO` remains Live every 60 seconds for Bathroom Fixtures and Create PR, and the model-driven heartbeat remains paused.

Release `0.4.2` changes only the recurring task launcher. It uses the release-pinned Windows Script Host wrapper to start the same PowerShell worker with window style `0`, preventing the one-minute console flash that `powershell.exe -WindowStyle Hidden` could not prevent. The guarded in-place upgrade preserves worker ownership, generation, state, journal, schedule, identity, destination pins, and transport logic.

Release `0.4.3` preserves those controls and corrects routine journal traversal. Closed history remains validated and retained but is no longer reconciled or rewritten on every tick; only active entries are recovered, attempt lookups are indexed, and traversal stops after the one permitted claim. This prevents a large historical journal from consuming the 50-second tick budget before eligible work is reached.

Release `0.4.4` retains that optimization and permits a bounded 180-second production tick because OFFICEASSIST's authoritative remote-SMB scan was measured at 64–78 seconds. It also adds an owner-bound administrative quarantine for a structurally terminal record with an invalid immutable hash. Quarantine preserves the bad hash and all record evidence, records both recomputed hashes, releases only the transport hold, and never claims delivery or business completion.

Release `0.4.5` retains every `0.4.4` control and aligns the canonical manager subprocess bounds with the 180-second tick. List calls may use up to 60 seconds and atomic mutation calls may use up to 120 seconds, always capped by the time remaining in the tick. This addresses OFFICEASSIST `ManagerTimeoutUncertain` results caused by the prior 15-second conditional-claim limit without permitting an unbounded manager call.

Release `0.4.6` retains every `0.4.5` control and refreshes the reviewed Codex CLI path/hash during `UpgradeLive`. This addresses Codex application updates that replace the versioned CLI directory. Ordinary worker ticks remain unable to discover or trust a new executable automatically, and a missing pinned CLI now produces the safe diagnostic code `CliExecutableMissing` before any submission marker or task notification.

The dispatcher now distinguishes a pre-PowerShell tool-wrapper failure from a helper or queue failure. It retries one pre-execution wrapper failure, records deterministic skip counts, writes machine-local health to `%LOCALAPPDATA%\BuyYourHome\PRMessaging\dispatcher-health.json`, and allows up to 120 seconds for destination startup before final delivery reconciliation.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\pr-messaging-dispatcher\SKILL.md`

## Dedicated Tasks

- WES-VIDEOEDITOR task name: `PR Messaging Dispatcher - WES-VIDEOEDITOR`
- WES-VIDEOEDITOR task id: `01a05d0c-8031-7d92-9474-ab2330008ddb`
- WES-VIDEOEDITOR automation id: `pr-messaging-dispatcher-wes-videoeditor`
- WESSTUDIO task name: `PR Messaging Dispatcher - WESSTUDIO`
- WESSTUDIO task id: `01a06337-1b59-7dc2-9586-6660eb7b5da7`
- WESSTUDIO automation id: `pr-messaging-dispatcher`
- OFFICEASSIST task name: `PR Messaging Dispatcher - OFFICEASSIST`
- OFFICEASSIST task id: `01a09d84-a309-7591-a790-e770fcb53dee`
- OFFICEASSIST has no Codex dispatcher heartbeat or recurring dispatcher automation. Its deterministic worker is live, and Email Monitor no longer contains the embedded dispatcher fallback.

## Target Schedule

- Deterministic Windows worker every 60 seconds, 24/7.
- Empty polls start no model and consume no model tokens.
- Only an eligible claimed record queues one wake-up to the exact destination task.
- Legacy five-minute heartbeat schedules remain fallback-only and must be paused at machine cutover.
- Notify Wes only for newly delivered consequential work, a new actionable blocker, or a new decision.

## Legacy Automation Prompt Contract

The stored automation prompt must be a short pointer, not a copied snapshot of dispatcher policy. At every run it must read and follow the current contents of:

- `C:\Codex\Wiki Files\Project Rooms\PR Messaging Dispatcher\working\heartbeat-prompt.md`
- `C:\Codex\Wiki Files\Project Room Messaging Rule.md`

Do not embed the full heartbeat instructions in the automation prompt. Repository updates must take effect after a safe pull without separately rewriting the automation.

## Deployment Gate

Do not mark a destination Project Room on a remote computer dispatchable until:

1. The machine-local dispatcher task and heartbeat are active.
2. The dispatcher can access the central queue under the normal Codex Windows profile.
3. The destination task is registered locally and its manifest is either dispatchable or names one exact `validation_ready` synthetic record under the central exception.
4. A synthetic message created on another computer is discovered locally without manual pasting.
5. The destination writes `Accepted`, `Processing`, and `Completed` under its exact identity.
6. The manifest records the dispatcher task id, automation id, source and destination machines, and `manual_intervention: false`.

## Start PR Pointer

Start PR: Before durable work, follow `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. This dispatcher wakes the exact owning task and never performs destination work.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
