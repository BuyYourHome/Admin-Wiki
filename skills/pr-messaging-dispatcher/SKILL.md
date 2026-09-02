---
name: pr-messaging-dispatcher
description: Run one machine-local Buy Your Home Project Room messaging dispatcher heartbeat per computer, bridging the authoritative shared queue to exact local Codex destination tasks without performing destination work.
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

1. Read the canonical heartbeat prompt and messaging rules at every run.
2. Treat each scheduler invocation as a new operational run. Do not carry forward a prior one-turn diagnostic, read-only, or no-claim instruction after that earlier turn ends. Only an explicit persistent pause or disable instruction from Wes suppresses an active scheduled run.
3. Determine the actual local computer name.
4. Run the deterministic claim helper once through `powershell.exe -NoProfile -ExecutionPolicy Bypass -File`. It owns queue selection, exact manifest and registration checks, bounded retry eligibility, structured skip diagnostics, local dispatcher-health output, and `StartAttempt` through the canonical manager. Do not invoke the script directly on a host whose execution policy blocks scripts.
5. If the tool wrapper fails before PowerShell starts, retry the identical wrapper once. A pre-execution wrapper retry is not another helper run or delivery attempt. Report the exact underlying error after a second wrapper failure.
6. When the helper returns a claim, notify the returned exact destination once without reinterpreting eligibility or authorization. Identify the notification as a wake-up signal and require canonical-record verification.
7. When the helper returns no claim, end silently when its candidate and skip counts are consistent. Report an internally inconsistent result as an actionable helper blocker.
8. Require `dispatchable: true`, except for one exact manifest-authorized `validation_ready` synthetic record that authorizes and performs no business action. Never use that exception for production work.
9. `StartAttempt` must already exist before exactly one local notification.
10. Require the destination to write `Accepted`, `Processing`, and one valid final state.
11. Wait up to 120 seconds for destination progress and reconcile the authoritative record again immediately before marking a definitive failure `NotDelivered` or uncertainty `DeliveryAmbiguous`.
12. Remain silent on empty polls and unchanged conditions.

## Boundaries

- Never execute destination work.
- Never change payloads, authorization, destination, or source references.
- Never create substitute tasks or replacement records as a retry.
- Never notify tasks assigned to another machine.
- Never claim delivery without an exact central receipt.
- Never exceed the record's attempt limit.

## Deployment

- Use one task and heartbeat per computer.
- WES-VIDEOEDITOR task: `PR Messaging Dispatcher - WES-VIDEOEDITOR`, task `01a05d0c-8031-7d92-9474-ab2330008ddb`.
- WES-VIDEOEDITOR automation id: `pr-messaging-dispatcher-wes-videoeditor`.
- OFFICEASSIST may use its existing Email Monitor dispatcher stage instead of a duplicate task.
- A cross-machine Project Room is not dispatchable until an unattended remote-source lifecycle passes without manual pasting.
- Store only a short pointer in the automation prompt requiring every run to reread `Project Rooms\PR Messaging Dispatcher\working\heartbeat-prompt.md` and `Project Room Messaging Rule.md`. Never copy the full policy into the automation prompt; copied policy becomes stale after repository updates.

## Start PR Pointer

Start PR: Before durable work, follow `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Wake only the exact owning task; never perform its work.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
