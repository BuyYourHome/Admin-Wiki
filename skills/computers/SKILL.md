---
name: computers
description: Use for Buy Your Home Computers project-room work, including business computer inventory, hardware/software specs, configuration tracking, Codex/Admin wiki readiness, remote-access status, and maintaining materials under `Project Rooms\Computers`.
---

# Computers

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Computers`
- Skill source: `C:\Codex\Wiki Files\skills\computers\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Main register: `C:\Codex\Wiki Files\Project Rooms\Computers\working\computer-register.md`
- Outcome log: `C:\Codex\Wiki Files\Project Rooms\Computers\working\computer-inventory-action-log.md`

Use this skill when Wes asks Codex to track business computers, document specs, record configuration, compare machines, receive computer setup handoffs, or maintain the Computers Project Room.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before Computers file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\Computers\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, `Git Work Scope Rule.md`, and `Codex Skill Source Rule.md`.
5. Check `git status --short --branch`.

## Workflow

1. Identify whether the request is computer inventory, spec/configuration update, comparison, readiness review, handoff intake, report generation, or routing to another Project Room.
2. Use `working\computer-register.md` as the durable list of business computers and their current known status.
3. Use `working\computer-inventory-action-log.md` to record final outcomes: inventory completed, configuration verified, app status changed, setup handoff received, blocker found, or report delivered.
4. Record source support in `working\source-inventory.md` when new source documents, inspection reports, screenshots, vendor reports, or Project Room handoffs become authoritative.
5. Record duplicate names, conflicting specs, stale machine facts, and unclear ownership in `working\duplicate-and-conflict-log.md`.
6. Record missing specs, access decisions, purchase/support details, and verification needs in `working\missing-context.md`.
7. Mark unsupported or unverified computer facts as `unverified`; do not smooth them into confirmed specs.
8. For setup or install work, route to Codex Environment by default unless Wes explicitly assigns that setup run to Computers.
9. For suspected compromise or active remote-control concerns, route to Investigate Computer and record the handoff.
10. Preserve review-ready reports and handoffs under `outputs\`.
11. Commit only scoped Computers room, matching skill, registry, and index changes.

## Inventory Fields

When inventorying a computer, collect as available:

- computer name/hostname,
- primary user,
- business role,
- physical or business location,
- operating system and edition,
- CPU,
- RAM,
- storage devices and capacity,
- serial number or service tag,
- warranty/support status,
- installed business apps,
- Office/Outlook/Teams/SharePoint readiness,
- Chrome/browser readiness,
- Git/Admin wiki readiness,
- Codex readiness,
- remote-access method and status,
- security posture summary,
- lifecycle status,
- last verified date,
- notes and blockers.

## Boundaries

- Do not store passwords, tokens, recovery codes, license keys, payment details, MFA secrets, or other live secrets in the wiki, Project Room, skill, git history, scripts, or chat handoff notes.
- Do not buy hardware, software, support, warranties, or subscriptions unless Wes explicitly approves that exact purchase.
- Do not disable antivirus, firewall, BitLocker, endpoint protection, or other Windows security features unless Wes explicitly approves that exact change.
- Do not install paid apps, trials that create billing risk, browser extensions, remote-control tools, VPNs, credential managers, or system-level agents unless Wes explicitly approves that exact item.
- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Do not use Teams-synced wiki folders as the working repo.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Computers\outputs` for review-ready computer inventory reports, comparison tables, setup-state summaries, and handoffs.
