# Computers Project Room

## Purpose

This Project Room keeps track of Buy Your Home business computers, including each computer's owner or primary user, hardware specifications, operating system, installed business applications, security and remote-access posture, Codex/Admin wiki readiness, and configuration notes.

Use this room when Wes asks to inventory a business computer, compare computer specs, document configuration, track app installation status, record remote-access readiness, or maintain the current list of company machines.

## Scope

In scope:

- Maintaining the authoritative business computer register.
- Recording machine identity, owner/user, location, operating system, hardware specs, serial/service tag when available, warranty/support notes, and lifecycle status.
- Tracking installed business apps, Office/Outlook/Teams/SharePoint readiness, Chrome/browser state, Git/Admin wiki readiness, Codex readiness, and remote-access method.
- Recording configuration changes, inventory updates, and setup/verification outcomes.
- Receiving handoffs from Codex Environment or other Project Rooms when a setup run changes a computer's known state.

Out of scope:

- Remoting into a computer to install apps or replicate the Codex environment unless Wes explicitly routes that setup work here. Default remote setup belongs to the Codex Environment Project Room.
- Investigating suspected compromise or active remote-control threats; that belongs to Investigate Computer unless Wes explicitly routes it here.
- Storing passwords, tokens, recovery codes, license keys, payment details, or other live secrets.
- Buying hardware, paid software, subscriptions, warranties, or support plans unless Wes explicitly approves that exact purchase.
- Disabling antivirus, firewall, BitLocker, endpoint protection, or other Windows security features unless Wes explicitly approves that exact change.

## Folder Map

- `sources\` - source notes, screenshots, vendor/spec references, external inventory exports, and Wes-provided computer information.
- `working\source-inventory.md` - inventory of source documents and where each computer fact came from.
- `working\duplicate-and-conflict-log.md` - conflicting computer names, duplicate devices, stale specs, or unclear ownership.
- `working\missing-context.md` - missing specs, access decisions, purchase/support details, or verification needs.
- `working\computer-register.md` - durable list of business computers and their current known configuration.
- `working\computer-inventory-action-log.md` - durable log of inventory updates, configuration checks, handoffs, and final outcomes.
- `outputs\` - review-ready computer inventory reports, setup summaries, comparison tables, and handoffs.

## Current Status

Status: draft.

Wes asked for a Project Room whose job is to keep track of the computers in the business, including specs and configuration.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\computers\SKILL.md`

## Dedicated Chat

- Chat name: `Computers`
- Thread id: `019f96e9-c663-7550-bf20-5829f6cb6c88`

## Start PR

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Ownership And Git

- Working branch: `main`.
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and the current branch is `main`.
- Follow `Project Room File Ownership And Git Coordination Rule.md` for Project Room ownership, shared Admin files, cross-PR edits, fetch/pull safety, and push safety.
- Commit only scoped Computers room, matching skill, registry, and index changes.
- Push only when Wes explicitly asks, says the work is finished, or the applicable Admin wiki rules define the deliverable as final and ready to publish.

## Operating Rules

- `working\computer-register.md` is the source of truth for the list of business computers, machine specs, assigned roles, lifecycle status, and overall readiness summary.
- When another Project Room, including Codex Environment, creates a setup report or verification output for a computer, treat that output as a source/handoff and update the Computers register rather than maintaining a competing machine list elsewhere.
- When Wes asks what computers are listed, answer from `working\computer-register.md` first.
- Record facts only from authoritative sources, direct machine inspection, user-provided details, vendor/system reports, or named Project Room handoffs.
- Mark unsupported or unverified machine facts as `unverified`.
- Do not store live secrets in the register, source files, logs, scripts, git history, or chat handoffs.
- Use the outcome log for what happened: inventory completed, configuration verified, app status changed, missing info found, or handoff sent. Do not log every intermediate command.
- If a setup run belongs to Codex Environment, record only the final setup outcome or handoff reference here unless Wes explicitly authorizes Computers to perform the setup.
- If a security concern appears, route investigation to Investigate Computer and record the handoff without performing cleanup from this room.

## Next Actions

1. Seed `working\computer-register.md` with known business computers.
2. Define the minimum inventory fields to collect during each computer inspection.
3. Receive handoffs from Codex Environment setup runs when a target computer's configuration changes.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; the PR must accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
