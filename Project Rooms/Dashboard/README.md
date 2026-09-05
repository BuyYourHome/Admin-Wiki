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

The local dashboard provides search, codified functional-group filters, status counts, Project Room summaries, skill visibility, documented-mode selection, and extensible side-panel Quick actions. Every card has a README action and, when it has fewer than two actions, an unassigned future-action slot. The Entity Relationship card also opens its SVG diagram, and Gracious Millionaire opens its website. Dashboard action links use the browser's normal separate-tab/window behavior. The deletion control presents a one-confirmation, exact-resource workflow preview and can record a structured deletion request for `Create PR`, but Dashboard still does not delete, archive, rename, or alter anything itself. Group remains a displayed side-panel property with a preview-only selector. The two SOP viewer combo boxes remain scoped to the SOPs Project Room only. A section heading can count as a documented mode either by using a recognized `Modes` section or by beginning that section with `Use this mode ...`; the mode name itself does not need to end with `Mode`. Wes will review the design and decide what to alter.

The top bar also opens `Transaction Attention`, a Dashboard-owned read-only mode. Its host endpoint reads the authoritative central Project Room queue and returns only sanitized attention fields for transaction-related records in `Delivery Ambiguous`, `Blocked`, or `Needs Wes`. It omits payloads, mailbox identifiers, source links, credentials, and superseded synthetic records. The view separates automatic recovery, system blockers, workflow blockers, and decisions that require Wes; it never retries, edits, accepts, completes, or otherwise processes a transaction.

When a documented mode has a Dashboard-keyed action in `config\dashboard-actions.json`, selecting that mode now invokes the configured safe action immediately. The current seeded example is `Create PR` -> `Diagram`, which opens the canonical `outputs\Project Room Relationship Diagram.svg`. Modes without a keyed action remain review-only and say so truthfully.

For the SOPs Project Room, the side panel reads the authoritative `outputs\SOP Index.md` during Dashboard refresh. It lists the index entries without changing them and enables `View selected SOP` only when a corresponding clean Markdown page exists. The viewer opens that canonical page using normal separate-tab/window behavior.

For the Manager Project Room, the `Tasks` mode now loads a Dashboard-owned helper panel. It shows open tasks parsed from `Project Rooms\Manager\working\task-register.md`, including each task's priority and current status. The full local Dashboard on WesStudio can change the selected task's status and write that update back to the canonical Manager register; LAN-host views remain read-only and show the editor as unavailable.

For the Invoice Entry Project Room, the `Reconcile` mode now loads a Dashboard-owned request panel. It shows active projects parsed from `Project Rooms\Invoice Entry\working\project-spreadsheet-register.md`. Because Dashboard must remain a request interface rather than directly activating another Project Room, the local WesStudio button prepares the exact Reconcile request, tries to copy it, and tries to open the Invoice Entry task for paste-in activation. The mode panel now keeps a visible `Latest Reconcile action` card plus the exact request text so Wes can see whether copy/open succeeded and what to paste next. LAN-host views show the project list but leave the request button unavailable.

For the Dashboard Project Room itself, the `Bridge Test` mode now records one local bridge-test request aimed at `Create PR` and shows the current returned status from the shared Dashboard action-request store. The full local Dashboard host can create or reuse that request record; LAN-host views remain read-only and can only inspect the current state. The actual task-message delivery still happens through the active Dashboard Codex task, which writes the returned status back to that shared action-request record. A `prepared` bridge-test state means the request is only queued locally and has not yet been delivered.

For every Project Room card, `Review deletion` now uses the same delegated-transport pattern. The full local Dashboard host can record a structured deletion request for `Create PR` and show the latest returned status for that exact Project Room in both the side panel and the dialog. The WesStudio machine may also record that same deletion request while using the LAN URL locally, but remote LAN clients may only inspect the existing request record and status. Dashboard still performs no deletion itself; the active Dashboard Codex task performs the actual task-message send and writes the returned status back to the shared action-request store. A `prepared` deletion state means the request is only queued locally on Dashboard and still awaits delivery by the Dashboard task; `sent` means delivery was attempted and Dashboard is waiting on the target PR to return a status.

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

## Mode Map

Use this mode when Wes wants Dashboard mode mappings defined or revised in plain English.

When the selected Project Room is `Dashboard` and the selected mode is `Mode Map`, the side panel loads a Dashboard-owned helper panel instead of pretending the mode is only one immediate link. That helper shows the canonical request structures for:

- one keyed mode action, and
- one keyed mode panel containing several side-panel controls.

Interpretation rules for plain-English requests in this mode:

1. If Wes describes one target to open for a mode, normalize the request into a keyed `modeActions` entry.
2. If Wes describes several buttons, helper notes, or other side-panel controls for one mode, normalize the request into a keyed `modePanels` entry.
3. Use the exact Project Room name and exact documented mode name as shown in Dashboard.
4. Default availability to `lan-readonly` unless Wes clearly wants the control to stay `local-only` on the host machine.
5. Keep room-level Quick actions separate from mode-specific helper controls.

The current Dashboard mode helper is driven from `config\dashboard-actions.json` under `modePanels`.

Example keyed mode panel request:

```text
Key mode panel
Project Room: Dashboard
Mode: Mode Map
Controls:
- Type: open-url
  Label: Open Dashboard README
  Target: C:\Codex\Wiki Files\Project Rooms\Dashboard\README.md
  Availability: lan-readonly
- Type: message
  Label: Notes
  Text: Explain how plain-English requests become mode mappings.
  Availability: lan-readonly
```

## Bridge Test

Use this mode when Wes wants to verify the Dashboard-to-Project-Room delivery path before building delegated Dashboard actions such as deletion.

When the selected Project Room is `Dashboard` and the selected mode is `Bridge Test`, the side panel loads a Dashboard-owned helper panel that reads and, on the full local host only, records the canonical bridge-test request state.

Current bridge-test rules:

1. The request is recorded in the shared Dashboard action-request store `Project Rooms\Dashboard\working\tmp\dashboard-action-requests.json`.
2. The request is always targeted to the canonical `Create PR` task/thread id `019fdc5e-a1da-7e10-b388-a3be3830ac89`.
3. The LAN host may show the recorded state, but it may not create or alter it.
4. The active Dashboard Codex task performs the actual `send_message_to_thread` delivery and writes the returned status back to that same shared record.
5. The legacy bridge-test and deletion JSON files remain mirrored from the shared store so existing views stay compatible while Dashboard actions move onto the single bridge path.

## Generic Bridge

Dashboard now has one shared delegated-action transport store at `Project Rooms\Dashboard\working\tmp\dashboard-action-requests.json`.

Rules:

1. Every delegated Dashboard action records one structured request in that shared store with a target Project Room and target task/thread id.
2. The local host exposes generic request-read, request-create, and request-status-update endpoints for Dashboard-owned actions.
3. The LAN host exposes the same read surface to all clients, but only WesStudio itself may create or update requests while using the LAN URL.
4. The active Dashboard Codex task is the bridge processor. It reads prepared requests from the shared store, sends the task message to the target PR, and writes the returned status back to the same request record.
5. Action-specific interfaces such as `Bridge Test` and `Review deletion` are now thin views over this one shared bridge instead of owning separate transport files.

Status interpretation:

- `prepared` - queued locally on Dashboard; not yet delivered to the target PR.
- `sent` - delivered by the Dashboard task; waiting for the target PR to return a status.
- `accepted`, `done`, `blocked`, `needs Wes`, `rejected as wrong room` - returned by the target PR and written back by the Dashboard task.

## Transaction Attention

Use this mode when Wes wants one safe list of transactions that need attention or automatic recovery visibility.

Rules:

1. Read live records through `tools\Get-TransactionAttention.ps1`, which uses the canonical Project Room message manager.
2. Include only transaction-related records in `Delivery Ambiguous`, `Blocked`, or `Needs Wes`.
3. Exclude synthetic tests and records explicitly finalized as superseded.
4. Return only safe summary fields: record id, state, owning/destination Project Room, machine, timestamps, attempt counts, safe amount/company/project/reference fields, blocker, next action, and exact Wes decision when applicable.
5. Never expose the message payload, authorization sender, mailbox identifiers, source links, attachment paths, credentials, or hashes.
6. Treat the view as display-only. Dashboard never retries delivery, changes central state, performs transaction work, or substitutes for the owning Project Room.
7. `Delivery Ambiguous` shows the next bounded automatic-recovery action. `Needs Wes` shows the exact recorded decision. `Blocked` is classified as a system or workflow blocker for owning-PR follow-up.

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

The LAN host is read-only for remote clients. It serves the Dashboard site plus approved read-only document views only, rejects refresh writes, and disables host-only actions for remote clients. On WesStudio itself, the LAN-host view may still open the deletion workflow and record a delegated deletion request because that request does not execute deletion. See `working\dashboard-lan-hosting.md` for architecture, validation, and rollback.

## Start PR Pointer

Start PR: Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Next Actions

1. Review the initial layout and functional grouping with Wes.
2. Record requested changes in `working\missing-context.md` or the action log.
3. Keep dashboard data derived from canonical Project Room READMEs.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; the PR must accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
