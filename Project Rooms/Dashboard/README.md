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
- `Project Rooms\SOPs\outputs\SOP Index.md` - authoritative SOP list used by the SOPs side-panel selector; the Dashboard only opens matching clean pages in `outputs\SOPs\`.
- `outputs\` - review-ready dashboard reports or exports.
- `site\` - local dashboard interface and generated Project Room index.
- `tools\` - local refresh, localhost-server, and launch scripts.

## Current Status

Status: active initial design.

The local dashboard provides search, codified functional-group filters, status counts, Project Room summaries, skill visibility, documented-mode selection, and extensible side-panel Quick actions. Every card has a README action and, when it has fewer than two actions, an unassigned future-action slot. The Entity Relationship card also opens its SVG diagram, and Gracious Millionaire opens its website. Dashboard action links use the browser's normal separate-tab/window behavior. The deletion control presents a one-confirmation, exact-resource workflow preview and can download an audit-plan record, but does not delete or alter anything. Group remains a displayed side-panel property with a preview-only selector. The two SOP viewer combo boxes remain scoped to the SOPs Project Room only. A section heading can count as a documented mode either by using a recognized `Modes` section or by beginning that section with `Use this mode ...`; the mode name itself does not need to end with `Mode`. Wes will review the design and decide what to alter.

When a documented mode has a Dashboard-keyed action in `config\dashboard-actions.json`, selecting that mode now invokes the configured safe action immediately. The current seeded example is `Create PR` -> `Diagram`, which opens the canonical `outputs\Project Room Relationship Diagram.svg`. Modes without a keyed action remain review-only and say so truthfully.

For the SOPs Project Room, the side panel reads the authoritative `outputs\SOP Index.md` during Dashboard refresh. It lists the index entries without changing them and enables `View selected SOP` only when a corresponding clean Markdown page exists. The viewer opens that canonical page using normal separate-tab/window behavior.

## Attention Badges

The Dashboard shows a card badge only when `config\project-room-attention.json` contains a valid explicit state for that exact room. Valid types are `confirmation-needed` and `approval-needed`; each state must include a reason and source. Empty or invalid entries create no alert. The Dashboard does not infer approvals or confirmations from ordinary Project Room text, status, or chat activity.

## Ask Jean

The top-level `Ask Jean` control reads the active Jean's Voice task from `config\dashboard-actions.json` and opens the documented Codex deep link `codex://threads/<thread-id>`. It opens the existing task only; it does not claim to begin a voice session automatically.

## Mode Actions

Dashboard-owned mode actions live in `config\dashboard-actions.json` under `modeActions`, keyed first by exact Project Room name and then by exact documented mode name.

Current supported action type:

- `open-url` - opens a safe target URL when the mode is selected.

Example:

```json
"modeActions": {
  "Create PR": {
    "Diagram": {
      "type": "open-url",
      "label": "Open Project Room Relationship Diagram",
      "href": "../../Create%20PR/outputs/Project%20Room%20Relationship%20Diagram.svg"
    }
  }
}
```

When Wes wants to key a new mode action, the request should state:

1. Project Room name.
2. Exact mode name.
3. Action type.
4. Exact target path or URL.
5. Whether it should remain available in the LAN read-only view or stay local-only.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\dashboard\SKILL.md`

## Dedicated Task

- Task/thread id: `019fc52f-858a-72e1-926b-a0f6fbf0fd89`
- Task title: `Start the Buy Your Home Dashboard Project Room.`
- This is the canonical Dashboard task. It owns only the local Dashboard source, configuration, refresh tools, and Dashboard documentation.

## Local Access

Run `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Start-Dashboard.ps1` to start one local-only Dashboard server and open the dashboard. The prominent top-level `Refresh Dashboard` control runs the same local rescan process and provides success or failure feedback. The local server resolves the Dashboard site directory to its `index.html` page.

The launch tool prefers `http://127.0.0.1:8765/Project%20Rooms/Dashboard/site/`. If that port is occupied by a different local process, it selects an available localhost port through `8775` and prints the URL it opened.

## LAN Host

WesStudio may also host a LAN read-only Dashboard at `http://10.0.0.105:8765/` for private-network access on `10.0.0.0/24`.

- Host listener: `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Dashboard-LanServer.ps1`
- Hidden startup wrapper: `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Start-DashboardLanHostHidden.vbs`
- Install/start script: `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Register-DashboardLanHost.ps1`
- Rollback script: `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Remove-DashboardLanHost.ps1`
- Firewall scope: Private profile only, TCP `8765`, remote address `10.0.0.0/24`
- Startup method: Windows Task Scheduler task `BYH Dashboard LAN Host`

When the firewall rule already matches the approved scope and only the startup action needs to be refreshed, rerun `C:\Codex\Wiki Files\Project Rooms\Dashboard\tools\Register-DashboardLanHost.ps1 -SkipFirewallUpdate`.

The LAN host is read-only. It serves the Dashboard site plus approved read-only document views only, rejects refresh writes, and disables host-only actions for remote clients. On WesStudio itself, the LAN-host view may still open the deletion-preview workflow because that preview does not execute deletion. See `working\dashboard-lan-hosting.md` for architecture, validation, and rollback.

## Start PR Pointer

Start PR: Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Next Actions

1. Review the initial layout and functional grouping with Wes.
2. Record requested changes in `working\missing-context.md` or the action log.
3. Keep dashboard data derived from canonical Project Room READMEs.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; the PR must accept and return the same `dispatch_id` under the central contract.
