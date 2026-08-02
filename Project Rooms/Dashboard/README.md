# Dashboard Project Room

## Purpose

Build and maintain a locally hosted dashboard showing Buy Your Home Project Rooms and the functionality each room owns.

## Scope

In scope:

- Inventory canonical Project Rooms from `C:\Codex\Wiki Files\Project Rooms`.
- Summarize each room's purpose, status, matching skill, and functional group.
- Provide a searchable, filterable local dashboard for navigating the operating system.
- Refresh dashboard data from canonical Project Room README files.

Out of scope:

- Publishing the dashboard externally.
- Editing another Project Room's README or skill to improve its dashboard entry.
- Treating the dashboard as the source of truth for another workflow.
- Starting, stopping, or changing another Project Room's automation or task.

## Folder Map

- `sources\` - source notes and inventory guidance; canonical PR content remains in each room.
- `working\source-inventory.md` - dashboard source inventory.
- `working\duplicate-and-conflict-log.md` - duplicate or unclear room metadata.
- `working\missing-context.md` - decisions needed from Wes.
- `working\dashboard-action-log.md` - durable refresh and design outcomes.
- `outputs\` - review-ready dashboard reports or exports.
- `site\` - local dashboard interface and generated Project Room index.
- `tools\` - local refresh and launch scripts.

## Current Status

Status: active initial design.

The initial local dashboard provides search, functional-group filters, status counts, Project Room summaries, skill visibility, and canonical README links. Wes will review the design and decide what to alter.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\dashboard\SKILL.md`

## Dedicated Task

- Task/thread id: pending until Wes explicitly requests a dedicated Dashboard task.

## Local Access

Run `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Start-Dashboard.ps1` to refresh the Project Room index, start the local-only server, and open the dashboard.

The local URL defaults to `http://127.0.0.1:8765/Project%20Rooms/Dashboard/site/`.

## Start PR Pointer

Start PR: Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Next Actions

1. Review the initial layout and functional grouping with Wes.
2. Record requested changes in `working\missing-context.md` or the action log.
3. Keep dashboard data derived from canonical Project Room READMEs.
