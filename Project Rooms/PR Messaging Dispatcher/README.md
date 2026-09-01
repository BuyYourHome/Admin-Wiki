# PR Messaging Dispatcher Project Room

## Purpose

Provide one machine-local dispatcher heartbeat on each computer that hosts dispatchable Buy Your Home Project Room tasks. The dispatcher bridges the cross-machine durable queue to Codex task notifications that are local to its own computer.

## Scope

In scope:

- Poll the authoritative queue with `Manage-ProjectRoomMessage.ps1`.
- Process only records addressed to the dispatcher computer.
- Reconcile immutable identity, payload hash, manifest, task id, local registration, state, and prior attempts.
- Write `StartAttempt` before one concise same-ID local task notification.
- Require destination receipts and preserve uncertain delivery honestly.
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

## Status

Status: `Active and unattended validation complete on WES-VIDEOEDITOR`.

The task and five-minute heartbeat are active on `WES-VIDEOEDITOR`. It delivered the exact Quickbooks Invoice synthetic lifecycle without manual activation, and the destination completed the required receipt lifecycle with no business action.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\pr-messaging-dispatcher\SKILL.md`

## Dedicated Tasks

- WES-VIDEOEDITOR task name: `PR Messaging Dispatcher - WES-VIDEOEDITOR`
- WES-VIDEOEDITOR task id: `01a05d0c-8031-7d92-9474-ab2330008ddb`
- WES-VIDEOEDITOR automation id: `pr-messaging-dispatcher-wes-videoeditor`
- OFFICEASSIST exception: its active Email Monitor heartbeat may provide the local dispatcher stage; do not create a duplicate dispatcher heartbeat while that stage remains verified.

## Schedule

- Every five minutes, continuously.
- Empty polls are strictly silent.
- Notify Wes only for newly delivered consequential work, a new actionable blocker, or a new decision.

## Automation Prompt Contract

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
