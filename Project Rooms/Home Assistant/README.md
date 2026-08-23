# Home Assistant Project Room

## Purpose

Maintain the Buy Your Home Home Assistant environment running on a non-Windows mini computer, including integrations, dashboards, automations, backups, updates, diagnostics, and approved configuration changes.

## Status

- Project Room: `Home Assistant`
- Setup status: Active discovery
- Dedicated task ID: `01a02e53-5f75-7103-b5e7-17b842547cef`
- Dispatchable: Yes
- Current phase: Discovery and secure remote-access planning

## Default Workflow

Use `Manage` unless Wes names another mode.

## Modes

### Manage

Review or change Home Assistant integrations, dashboards, helpers, entities, users, and configuration after the required backup and approval checks.

### Automate

Design, test, document, and deploy Home Assistant automations and scripts with explicit trigger, condition, action, failure, and rollback behavior.

### Diagnose

Perform read-only health, log, integration, network, storage, update, and availability diagnostics before proposing a change.

### Backup And Recovery

Verify backup coverage, create approved backups, test recovery planning, and document restoration procedures.

### Update

Review Home Assistant Core, Supervisor, OS, add-on, and integration updates and apply them only after compatibility, backup, timing, and rollback checks.

## Scope

- Home Assistant configuration and administration.
- Integrations, entities, helpers, dashboards, automations, scripts, scenes, and add-ons.
- Home Assistant backups, updates, logs, and recovery planning.
- Coordination of secure remote access with Network Roadmap.
- Coordination of mini-computer inventory with Computers.

## Out Of Scope Without Exact Approval

- Opening router ports or exposing Home Assistant directly to the internet.
- Installing or changing VPN, tunnel, DNS, certificate, firewall, account, or authentication services.
- Changing credentials, tokens, recovery codes, users, administrators, or multifactor authentication.
- Deleting entities, integrations, automations, backups, or historical data.
- Updating, restarting, or shutting down Home Assistant or its host when production service may be interrupted.
- Changing safety, security, access-control, alarm, lock, camera, HVAC, electrical, or water-control behavior without Wes's exact approval.

## Operating Rules

- Begin configuration work with a current backup and a rollback plan when a change could affect service.
- Prefer the Home Assistant web interface for supported administration.
- Use SSH only when necessary and only through an approved secure path with key-based authentication.
- Do not store passwords, tokens, private keys, recovery codes, or full configuration secrets in Git, the wiki, task messages, or logs.
- Test automations with bounded scope before enabling production actions.
- Record durable outcomes in `working/home-assistant-action-log.md`.
- Work on `main` unless Wes explicitly asks for a branch.

## Ownership

- Home Assistant owns Home Assistant configuration and operating records.
- Computers owns the mini computer's hardware, operating-system, and device inventory.
- Network Roadmap owns the remote-access architecture and must ask Wes how remote access should be established before implementing it.

## Folder Map

- `sources/`: source notes and approved exports or references.
- `working/`: inventories, missing context, configuration plans, and action outcomes.
- `outputs/`: review-ready configuration plans, diagrams, backup plans, and operating documentation.

## Required Pointers

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

## Next Actions

1. Record the mini computer in Computers after its identity and specifications are verified.
2. Have Network Roadmap ask Wes the remote-access decision questions.
3. Inventory Home Assistant installation type, version, URL, backup state, add-ons, integrations, and critical automations.
4. Establish the approved remote path before configuration work.
