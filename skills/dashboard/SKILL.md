---
name: dashboard
description: Use for the Buy Your Home Dashboard Project Room, including refreshing, reviewing, and improving the locally hosted directory of Project Room functionality.
---

# Dashboard

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\Dashboard`
- Local site: `C:\Codex\Wiki Files\Project Rooms\Dashboard\site`
- Refresh tool: `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Refresh-DashboardData.ps1`
- Launch tool: `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Start-Dashboard.ps1`
- Group configuration: `C:\Codex\Wiki Files\Project Rooms\Dashboard\config\project-room-groups.json`
- Canonical Project Room definitions: `C:\Codex\Wiki Files\Project Rooms\*\README.md`

## Required Startup

1. Confirm `C:\Codex\Wiki Files` is the working repository and `main` is active.
2. Read `AGENTS.md`, `Project Room Chat Startup Rule.md`, and `Project Room File Ownership And Git Coordination Rule.md`.
3. Read the Dashboard README and working files.
4. Check Git status and leave unrelated work alone.

## Workflow

1. Treat each Project Room's canonical README as the source for functionality and status.
2. Run the refresh tool after Project Rooms are created, explicitly renamed, or materially repurposed.
3. Review generated `site\project-rooms.js` for missing rooms and neutral fallbacks.
4. Maintain search, filters, status/skill visibility, and canonical README navigation.
5. Give every selected Project Room a truthful default Quick action that opens its canonical README. Append room-specific Quick actions only when each action has one clear canonical local target.
6. Keep the action list compatible with several future buttons. Never label a control as launching, routing, deleting, or changing something unless it actually performs that function.
7. A deletion control may only prepare an owner-review request after exact-name confirmation. It must not delete, archive, rename, move, edit a registry, change a skill or task, or claim final authorization. The owning workflow must identify every affected path/system and obtain Wes's exact explicit authorization before action.
8. Populate the side-panel Mode selector only from headings or numbered mode names documented in the room's canonical README and matching skill. A selection is interface-only unless a separate safe action is explicitly implemented.
9. Treat `config\project-room-groups.json` as the Dashboard source for group names, their basis, and current default assignments. Display Group as a selected-room property. A different selection may preview its basis but must not reclassify or rewrite the room until Wes explicitly selects and authorizes an implemented save workflow.
10. Keep the interface local-only unless Wes explicitly authorizes publication.
11. Record requested improvements in `working\dashboard-change-list.md` and substantive outcomes in `working\dashboard-action-log.md`.

## Boundaries

- Do not edit another Project Room or its matching skill to improve dashboard data.
- Dashboard grouping does not change ownership or routing.
- Do not expose confidential source content; use only room-level purposes recorded in READMEs.
- Do not publish, deploy, open firewall access, or bind beyond `127.0.0.1` without Wes's explicit authorization.
- Do not create or change automations unless Wes asks.

## Local Launch

Run `Project Rooms\Dashboard\tools\Start-Dashboard.ps1`. It refreshes the index, serves the canonical repo only on `127.0.0.1`, and opens the dashboard.

## Git Rules

- Commit only Dashboard Project Room, matching skill, and authorized shared registry/index/routing changes.
- Leave generated scratch and unrelated PR work unstaged.
- Push only under current Admin wiki rules.

## Start PR Pointer

Start PR: Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.
