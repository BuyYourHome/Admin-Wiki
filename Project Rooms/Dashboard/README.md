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
- `working\dashboard-change-list.md` - requested Dashboard improvements and implementation status.
- `working\dashboard-change-list-2.md` - pending future Dashboard design items awaiting Wes authorization.
- `working\dashboard-action-log.md` - durable refresh and design outcomes.
- `working\project-room-deletion-workflow.md` - future deletion execution gate and audit requirements.
- `config\project-room-groups.json` - explicit group definitions, basis, and current default assignments.
- `config\project-room-attention.json` - explicit, Dashboard-owned pending confirmation/approval states for card badges.
- `config\dashboard-actions.json` - local Dashboard action targets, including the active Jean's Voice task reference.
- `outputs\` - review-ready dashboard reports or exports.
- `site\` - local dashboard interface and generated Project Room index.
- `tools\` - local refresh, localhost-server, and launch scripts.

## Current Status

Status: active initial design.

The local dashboard provides search, codified functional-group filters, status counts, Project Room summaries, skill visibility, documented-mode selection, and extensible side-panel Quick actions. Every card has a README action and, when it has fewer than two actions, an unassigned future-action slot. The Entity Relationship card also opens its SVG diagram, and Gracious Millionaire opens its website. Dashboard action links use the browser's normal separate-tab/window behavior. The deletion control presents a one-confirmation, exact-resource workflow preview and can download an audit-plan record, but does not delete or alter anything. Group is a displayed side-panel property whose selector previews, but does not save, a future group change. Wes will review the design and decide what to alter.

## Attention Badges

The Dashboard shows a card badge only when `config\project-room-attention.json` contains a valid explicit state for that exact room. Valid types are `confirmation-needed` and `approval-needed`; each state must include a reason and source. Empty or invalid entries create no alert. The Dashboard does not infer approvals or confirmations from ordinary Project Room text, status, or chat activity.

## Ask Jean

The top-level `Ask Jean` control reads the active Jean's Voice task from `config\dashboard-actions.json` and opens the documented Codex deep link `codex://threads/<thread-id>`. It opens the existing task only; it does not claim to begin a voice session automatically.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\dashboard\SKILL.md`

## Dedicated Task

- Task/thread id: pending until Wes explicitly requests a dedicated Dashboard task.

## Local Access

Run `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Start-Dashboard.ps1` to start the local-only Dashboard server and open the dashboard. The prominent top-level `Refresh Dashboard` control runs the same local rescan process and provides success or failure feedback.

The launch tool prefers `http://127.0.0.1:8765/Project%20Rooms/Dashboard/site/`. If that port is occupied by a different local process, it selects an available localhost port through `8775` and prints the URL it opened.

## Start PR Pointer

Start PR: Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Next Actions

1. Review the initial layout and functional grouping with Wes.
2. Record requested changes in `working\missing-context.md` or the action log.
3. Keep dashboard data derived from canonical Project Room READMEs.
