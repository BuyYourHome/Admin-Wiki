---
name: home-assistant
description: Use for Buy Your Home Home Assistant work, including integrations, dashboards, automations, scripts, diagnostics, backups, updates, recovery planning, and approved configuration of the non-Windows mini running Home Assistant, with materials under `Project Rooms\Home Assistant`.
---

# Home Assistant

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\Home Assistant`
- README: `C:\Codex\Wiki Files\Project Rooms\Home Assistant\README.md`
- Action log: `C:\Codex\Wiki Files\Project Rooms\Home Assistant\working\home-assistant-action-log.md`

## Required Startup

1. Read the Project Room README.
2. Read `working\missing-context.md` and `working\home-assistant-action-log.md`.
3. Confirm the requested work belongs to Home Assistant rather than Computers or Network Roadmap.
4. Check backup and rollback readiness before changes.

## Default Workflow

Use `Manage` unless Wes names another mode.

## Modes

- `Manage`: Administer supported Home Assistant configuration.
- `Automate`: Design, test, and deploy bounded automations, scripts, and scenes.
- `Diagnose`: Perform read-only health and configuration diagnostics.
- `Backup And Recovery`: Verify, create, and document approved backups and recovery plans.
- `Update`: Review and apply approved Home Assistant or add-on updates after compatibility and rollback checks.

## Workflow

1. Identify the exact instance, installation type, version, request, and affected integrations or automations.
2. Prefer read-only inspection before proposing a change.
3. Confirm remote access is approved and available.
4. Confirm a current backup and rollback plan when service could be affected.
5. Explain consequential changes and obtain exact approval when required.
6. Make the smallest supported change.
7. Validate the intended behavior and check logs for regressions.
8. Record the durable outcome without secrets.

## Boundaries

- Computers owns mini-computer inventory and host hardware facts.
- Network Roadmap owns remote-access architecture.
- Do not open router ports, expose Home Assistant publicly, change security or credentials, delete data, restart services, or alter safety/security controls without exact approval.
- Never store passwords, tokens, private keys, recovery codes, or secret configuration values in Git, the wiki, task messages, or logs.

## Required Pointers

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

## Completion

Report what was inspected, what changed, validation results, backup and rollback status, remaining blockers, Git status, and total request time.

