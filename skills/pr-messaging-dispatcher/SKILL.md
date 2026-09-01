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

## Purpose

Provide the host-local wake-up layer for Project Room messages addressed to tasks on the computer running this dispatcher. The shared SMB queue is authoritative and cross-machine; Codex task notification is local to the destination host.

## Required Behavior

1. Read the canonical heartbeat prompt and messaging rules at every run.
2. Determine the actual local computer name.
3. Poll only records addressed to that computer in `Queued` or `Delivery Ambiguous` state.
4. Reconcile immutable identity, hash, manifest, exact task id, registration, attempts, and current state.
5. Treat a `Delivery Ambiguous` record as eligible for a bounded same-ID retry when no receipt or final state exists, prior attempts are complete, attempts remain, and the destination currently passes its manifest gate. A newly dispatchable destination is a new actionable condition, not a deduplication stop.
6. Require `dispatchable: true`, except for one exact manifest-authorized `validation_ready` synthetic record that authorizes and performs no business action. Never use that exception for production work.
7. Write `StartAttempt` before exactly one local notification.
8. Require the destination to write `Accepted`, `Processing`, and one valid final state.
9. Mark definitive failure `NotDelivered` and uncertainty `DeliveryAmbiguous`.
10. Remain silent on empty polls and unchanged conditions.

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
