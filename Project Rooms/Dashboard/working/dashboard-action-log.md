# Dashboard Action Log

| Date | Source | Action | Result | Status | Notes |
| --- | --- | --- | --- | --- | --- |
| 2026-08-02 | Wes voice request | Created Dashboard Project Room and initial local dashboard design | Searchable Project Room functionality directory with local refresh and launch tools | Completed | No external publication or dedicated task creation. |
| 2026-08-02 | Wes voice request | Added first Project Room card side-panel quick action | Entity Relationship card opens the canonical SVG diagram in its owning Project Room | Completed | The diagram Markdown has a stale reference to a missing Estate Documents path; Dashboard uses the existing owning-room SVG. |
| 2026-08-02 | Wes voice request | Standardized side-panel starter actions | Every card offers `Open Project Room README`; room-specific actions remain additive | Completed | Action list supports several future buttons. |
| 2026-08-02 | Wes voice request | Added safeguarded deletion-request design | Exact-name confirmation prepares a copyable owner-review request | Completed | No deletion, archive, rename, routing, or filesystem action occurs in Dashboard. |
| 2026-08-02 | Wes voice request | Added documented-mode selector | Side panel lists modes parsed from the selected room's README and matching skill | Completed | Selecting a mode does not activate it or change canonical state. |
| 2026-08-02 | Wes voice request | Codified functional grouping and added Group property selector | Current assignments and group purposes moved to structured JSON; property control supports unsaved previews | Completed | No Project Room was reclassified. |
| 2026-08-02 | Wes voice request | Redesigned Project Room deletion workflow preview | One-confirmation scope review identifies the exact selected room, derived Dashboard entry, documented matching skill, and documented task/chat status; it can download a JSON audit-plan record | Completed | No Project Room, chat/task, skill, registry entry, automation, or Dashboard card was changed. Unavailable chat deletion is a future execution blocker, not a reason for partial deletion. |
| 2026-08-02 | Wes voice request | Added consistent available Quick action slots | Rooms with fewer than two actions display a disabled `Future action available` slot; rooms already having two actions remain at two | Completed | The slot has no assigned behavior or external target. |
| 2026-08-02 | Wes voice request | Open Dashboard document actions in a separate tab/window context | All action links now use the browser's normal new-tab/window behavior | Completed | Browser configuration controls whether a separate tab or window is used. |
| 2026-08-02 | Wes voice request | Assigned Gracious Millionaire's second action | `Open GraciousMillionaire.com` links to the existing public website | Completed | Dashboard remains local-only; no website was changed or published. |
| 2026-08-02 | Wes voice request | Added prominent local Dashboard refresh control | Top-level button requests the local Dashboard server to run the canonical refresh script, then reloads the index with success/failure feedback | Completed | The server binds only to `127.0.0.1`; no external network action is used. |
| 2026-08-02 | Wes voice request | Renamed Dashboard display title | Large header now reads `Jean Wright Dashboard`; small `Buy Your Home Admin` label remains | Completed | Presentation-only change. |
| 2026-08-02 | Wes voice request | Added explicit approval/confirmation badge pattern | Project Room cards and selected-room detail panel can show distinct `Confirmation needed` or `Approval needed` indicators from Dashboard-owned structured state | Completed | No current attention states were invented or added. |
| 2026-08-02 | Wes voice request | Added clear deletion-dialog dismissal controls | X close control and `Close dialog` action use the dialog cancel path | Completed | Closing does not create a plan or alter any Project Room. |
| 2026-08-02 | Wes voice request | Added top-level Ask Jean control | Opens the documented `codex://threads/<thread-id>` link for the active Jean's Voice task | Completed | Opens the task only; it does not claim to start a voice session automatically. |
| 2026-08-02 | Wes voice request | Made selected-room sidebar independently scrollable | Desktop sidebar now scrolls within its viewport-bound sticky panel while the card section remains on page scroll | Completed | Mobile retains the stacked single-scroll layout. |
# Dashboard Action Log

## 2026-08-02 - SOPs Viewer Selector

- Added a Dashboard-only SOP selector for the SOPs Project Room.
- Source: `C:\Codex\Wiki Files\Project Rooms\SOPs\outputs\SOP Index.md`.
- The refresh tool derives 110 valid index entries and identifies matching clean pages under `Project Rooms\SOPs\outputs\SOPs\`.
- The viewer does not alter SOP material and enables opening only for a matching canonical clean page, in a separate browser tab/window context.
- Corrected the local server's directory handling so the documented Dashboard launch URL serves the site `index.html` page.
- Corrected launch readiness polling so one Dashboard launch does not leave duplicate local server processes while waiting for the selected port to respond.

## 2026-08-03 - Jean Portrait In Topbar

- Added the provided Jean portrait image to `Project Rooms\Dashboard\site\assets\jean-wright-topbar.png`.
- Updated the Dashboard topbar so the portrait appears to the left of the `Buy Your Home Admin` eyebrow and `Jean Wright Dashboard` title.
- Styled the portrait as a circular topbar image with responsive sizing so the header still fits on mobile.

## 2026-08-03 - Compressed Summary Strip And Reordered Side Panel

- Reduced the summary count strip height by tightening metric padding and count typography.
- Reordered the selected-room panel so functional controls appear first: documented mode, SOP viewer when applicable, quick actions, and Project Room controls.
- Moved Group, Status, and Skill into a bottom metadata section so reference fields no longer interrupt the action flow.

## 2026-08-03 - Inline Metrics And SOP Group Filter

- Reduced the summary strip again by placing each metric count to the right of its label.
- Changed the SOP refresh data so the Dashboard includes only SOP entries that have a canonical clean Markdown page under `Project Rooms\SOPs\outputs\SOPs\`.
- Added an SOP group selector above the SOP selector so Wes can narrow the displayed documented SOP pages by the canonical SOP Index category column.

## 2026-08-03 - LAN Read-Only Host

- Added a dedicated LAN host listener at `Project Rooms\Dashboard\tools\Dashboard-LanServer.ps1`.
- Restricted the LAN host to approved Dashboard site assets, Project Room README views, SOP Markdown pages, and the Entity Relationship SVG document view.
- Added `Register-DashboardLanHost.ps1` and `Remove-DashboardLanHost.ps1` for scheduled-task and firewall-rule management on WesStudio.
- Added host-context handling in the Dashboard UI so LAN read-only mode disables refresh, deletion review, and remote Codex deep links truthfully.
- Documented architecture, validation, and rollback in `working\dashboard-lan-hosting.md` and the Dashboard README.

## 2026-08-03 - Hidden LAN Host Startup

- Confirmed the active listener remained available while investigating the visible blank PowerShell window report.
- Updated the normal startup design so the scheduled task launches the LAN host through `Start-DashboardLanHostHidden.vbs` instead of attaching the host directly to a visible PowerShell console.
- Documented the hidden-launch wrapper in the Dashboard README and LAN hosting notes.
- Confirmed after the reboot that the live `http://10.0.0.105:8765/` listener remained healthy, but replacing the already registered scheduled task action still required an elevated Windows session; documented the exact `-SkipFirewallUpdate` rerun command for that admin follow-up.

## 2026-08-03 - Local LAN Delete Preview

- Updated the Dashboard UI so the LAN-host view keeps the deletion workflow preview enabled on WesStudio local access while leaving refresh disabled.
- Remote LAN clients still have deletion review disabled, preserving the read-only remote restrictions.

## 2026-08-04 - Scoped SOP Combo Boxes

- Removed the general Project Room combo-box treatment for documented mode and group metadata.
- Kept the two selector controls only in the SOPs Project Room side panel so the SOP group and SOP page can be chosen there without adding the same UI pattern to other rooms.

## 2026-08-04 - Restore General Mode And Group Selectors

- Restored the general `Documented mode` and `Group` selectors for every Project Room.
- Kept only the SOP group and SOP page selectors scoped to the SOPs Project Room side panel.

## 2026-08-04 - Flexible Mode Detection

- Updated the Dashboard refresh parser so a heading can count as a documented mode when its section explicitly begins with `Use this mode ...`, even if the heading itself does not end with `Mode`.
- This allows rooms such as Create PR to expose `Diagram` in the `Documented mode` selector without renaming the section to `Diagram Mode`.

## 2026-08-04 - Mobile Search Events

- Expanded the Dashboard search box listeners beyond `input` so the Project Room filter reacts to mobile-browser search behaviors, including Android Chrome event patterns.

## 2026-08-04 - Hide Detail Panel Until Selection

- Removed the automatic first-card selection when the Dashboard loads.
- The selected-room side panel now stays hidden until Wes actually chooses a Project Room.
- If search or group filtering removes the selected room from the visible card set, the side panel clears and hides again.

## 2026-08-04 - Keyed Mode Actions

- Added Dashboard-owned `modeActions` configuration to `config\dashboard-actions.json`, keyed by exact Project Room name and exact documented mode name.
- Selecting a documented mode now immediately invokes its configured safe action when one exists; otherwise the Dashboard says no action is keyed.
- Seeded the first action for `Create PR` -> `Diagram`, which opens the canonical Project Room relationship diagram SVG.
- Extended the LAN read-only host allowlist so explicitly configured internal mode-action files can be opened remotely without exposing arbitrary repo paths.

## 2026-08-04 - Dashboard Mode Map Helper

- Added a documented `Mode Map` mode to the Dashboard Project Room rules.
- Extended the side-panel mode system so a mode can load a helper panel with several Dashboard-owned controls instead of only triggering one immediate action.
- Seeded the first helper panel for `Dashboard` -> `Mode Map`, including the canonical single-action and multi-control mapping patterns for plain-English requests.
- Updated the Mode Map normalization rule so plain-English mapping requests default to `lan-readonly` availability unless Wes explicitly keeps a control host-only.

## 2026-08-04 - Manager Tasks Mode Panel

- Added a keyed `modePanels` entry for `Manager` -> `Tasks`.
- Dashboard refresh now parses `Project Rooms\Manager\working\task-register.md` and publishes the canonical task rows into the generated Dashboard data.
- The `Tasks` side panel now shows open Manager tasks with their visible priority and current status.
- The full local Dashboard can update the selected task's status through a Dashboard-local write endpoint that updates the canonical Manager task register and refreshes Dashboard data.
- LAN-host views keep the task list visible but leave the status editor unavailable so the hosted Dashboard remains read-only.

## 2026-08-04 - Manager Task Display Numbers

- Updated the Manager task panel to show the user-facing three-digit task display number instead of the full canonical `MGR-YYYYMMDD-NNN` id.
- The Dashboard still preserves the full canonical id internally for status updates to the Manager register.
