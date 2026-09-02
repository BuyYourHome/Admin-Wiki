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

## 2026-08-04 - Reconcile Paste Guidance

- Kept the existing `Invoice Entry` -> `Reconcile` manual paste-in design rather than converting it into direct submission.
- Added a visible `Latest Reconcile action` card that records whether Dashboard copied the request text and whether it opened the Invoice Entry task.
- Added explicit `Next step` guidance, plus `Copy request text` and `Open Invoice Entry task` retry buttons inside the mode panel.
- Clarified in the panel that the displayed request text is the exact text Wes pastes into the Invoice Entry Codex task.

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

## 2026-08-04 - Invoice Entry Reconcile Request Panel

- Added a keyed `modePanels` entry for `Invoice Entry` -> `Reconcile`.
- Dashboard refresh now parses active projects from `Project Rooms\Invoice Entry\working\project-spreadsheet-register.md`.
- The Reconcile panel shows a project selector from the canonical active workbook register and the exact Reconcile request text for the selected project.
- The local WesStudio button copies that request and opens the Invoice Entry task for paste-in activation.
- LAN-host views keep the active-project list visible but leave the request button unavailable so Dashboard remains a request interface rather than directly activating another Project Room.

## 2026-08-04 - Topbar Title Swap

- Swapped the two header lines in the Dashboard top panel.
- The small first line now reads `Jean Wright, Admin`.
- The large second line now reads `Buy Your Home Dashboard`.

## 2026-08-04 - Search Auto-Open And Reconcile Panel Cleanup

- Updated Dashboard search behavior so when the typed search narrows the visible Project Rooms to exactly one result, Dashboard selects that room and opens the side panel automatically.
- Simplified `Invoice Entry` -> `Reconcile` intro copy to `Choose a property, then prepare the Reconcile request for Invoice Entry.`
- Renamed the project selector label to `What Property`.
- Removed the extra `Invoice Entry task link`, the browser/task-id fallback note, and the inline `Button result` status line from the Reconcile mode panel.

## 2026-08-04 - Larger Jean Portrait

- Doubled the Dashboard topbar portrait size in the site CSS.
- Increased the small-screen portrait size proportionally so Jean's image remains visibly larger on mobile as well.

## 2026-08-04 - Single-Click Group Selection Fix

- Removed the extra card-grid rerender from `selectRoom()`.
- Added an in-place selected-card highlight sync so the selected room still gets the visual active state without rebuilding the grid during the click.
- This is intended to make a room open its sidebar on the first click after a group filter is chosen.

## 2026-08-04 - Hidden Reconcile Request Text

- Restored a primary `Reconcile` button in the `Invoice Entry` -> `Reconcile` panel.
- Kept the generated request text hidden by default so the side panel stays visually quiet.
- Added a `Show request text` / `Hide request text` toggle for voluntary inspection.
- When automatic copy fails, the panel now reveals the exact request text as the manual fallback instead of showing it all the time.
- Bumped the Dashboard asset cache-buster query strings so a normal browser refresh pulls the new UI code.

## 2026-08-04 - First Search Click Fix

- Identified that the search field's blur/change path could fire after typing and rebuild the Project Room cards even when the query text had not changed.
- Updated the search handler to ignore duplicate query values, so the first click on a filtered Project Room is not lost to a redundant rerender.

## 2026-08-04 - LAN Copy Fallback

- Identified that the LAN-hosted Dashboard was running on HTTP, so the secure clipboard API path returned `false` before trying any fallback copy behavior.
- Added a temporary-textarea fallback that uses `document.execCommand('copy')` when the secure clipboard API is unavailable or fails.
- Bumped the Dashboard asset cache-buster query strings again so a normal browser refresh loads the copy fix.

## 2026-08-04 - Deletion Plan Copy Action

- Replaced the deletion-preview dialog action label `Download audit record` with `Copy Code`.
- Changed the action to copy the prepared deletion plan JSON for Codex instead of downloading a file.
- Left the prepared deletion plan visible in the dialog as the manual fallback when copy does not complete automatically.

## 2026-08-04 - Deletion Plan Textarea Copy

- Updated `Copy Code` to copy directly from the visible deletion-plan textarea instead of relying only on a generated-string clipboard path.
- If automatic copy still fails, the deletion plan now remains selected in the textarea so Wes can copy it manually immediately.
- Bumped the Dashboard asset cache-buster query strings again so a normal refresh loads the updated copy behavior.

## 2026-08-05 - Bridge-First Spec

- Added `working\dashboard-bridge-test-spec.md` as the gate for delegated Dashboard actions.
- The spec limits the first test to a transport proof from `Dashboard` to `Create PR` using the canonical `Create PR` task/thread id `019f583e-7f14-7ae2-aa24-4e991544e306`.
- It requires a structured request id, exact targeting, one truthful returned status, and no browser popup or manual paste dependency.
- It explicitly blocks queue-wide or deletion-specific implementation until the bridge test passes end-to-end.

## 2026-08-05 - Bridge Test Panel

- Added a Dashboard-owned `Bridge Test` mode panel for the `Dashboard` Project Room.
- The full local Dashboard host can now record or reuse the canonical bridge-test request in `working\tmp\dashboard-bridge-test-state.json`.
- Both the local host and the LAN read-only host can read and display the current bridge-test status from that same runtime state record.
- The panel states the current transport truthfully: Codex task-message delivery is performed by the active Dashboard Codex task, not by browser deep links or manual paste.

## 2026-08-05 - Delegated Deletion Request

- Replaced the deletion dialog's copy-only outcome with a Dashboard-owned delegated deletion-request record targeted to `Create PR`.
- Added local host endpoints to create and update deletion request state and LAN-host read access to the same request state.
- The selected-room side panel now shows the latest deletion request status for that room, and the dialog can refresh that status explicitly.
- The deletion flow remains truthful: Dashboard records and displays the request, but the active Dashboard Codex task performs the actual task-message send and writes the returned status back.

## 2026-08-06 - Local LAN Deletion Request Creation

- Updated the LAN host context so WesStudio local access through `http://10.0.0.105:8765/` can create and update delegated deletion requests without changing the remote LAN read-only posture.
- Added local-only LAN-host `POST` handlers for deletion-request create and status update paths while continuing to refuse those writes for remote clients.
- Updated the Dashboard UI copy so remote clients are told truthfully that they can review existing deletion requests but cannot create them.

## 2026-08-06 - Generic Dashboard Bridge Store

- Replaced the split bridge-test/deletion transport design with one shared Dashboard action-request store at `working\tmp\dashboard-action-requests.json`.
- Updated both the localhost server and the LAN host so Dashboard-owned actions can read one shared queue and update one shared returned-status path.
- Kept the legacy bridge-test and deletion JSON files mirrored from the shared store so the current UI and existing status surfaces remain compatible during the transition.

## 2026-08-06 - Delegated Deletion Authorization Policy

- Added a narrow central delegated-authorization rule so a documented Dashboard exact-scope deletion request can carry Wes's already-captured authorization to `Create PR`.
- Updated the shared ownership rule, `Create PR` documentation, the canonical `create-pr` skill, and the Dashboard deletion workflow so the same policy is described consistently.
- Kept the exception narrow: it applies only when scope is exact, the request class is documented, and no archive/delete substitution, scope broadening, or partial deletion is required.

## 2026-08-07 - Delegated Deletion Follow-Through Lessons

- Verified that `CMA Report - 5021 Sunnyfield Dr` was actually deleted by `Create PR`, but the Dashboard card persisted until `Refresh-DashboardData.ps1` regenerated `site\project-rooms.js`.
- Confirmed that Dashboard-owned stale metadata can survive deletion outside the generated card index; removed obsolete deleted-room assignments from `config\project-room-groups.json`.
- Confirmed that the generic bridge path was healthy only after every canonical `Create PR` thread-id reference was rerouted to the replacement task `019fdc5e-a1da-7e10-b388-a3be3830ac89`.
- Recorded that the local PowerShell execution policy may block direct script invocation from an ordinary shell; the documented `powershell.exe -ExecutionPolicy Bypass -File ...` refresh path remains the reliable fallback on WesStudio.

## 2026-09-02 - Transaction Attention Requirement Recorded

- Received centralized improvement message `prmsg-jean-dashboard-transaction-recovery-attention-20260902-001` with dispatch id `jean-dispatch-20260902-transaction-recovery-attention-v1`.
- Added `DASH-046` to the Dashboard change list for a consolidated transaction-attention view and automatic recovery coordination driven by authoritative PR messaging records.
- Kept the boundary explicit: Dashboard may display safe transaction attention and next-step context, but it must not execute another Project Room's transaction work.

## 2026-09-02 - Transaction Attention View Implemented

- Completed `DASH-046` with a top-bar shortcut and Dashboard `Transaction Attention` mode.
- Added a live, read-only host endpoint backed by the canonical Project Room message manager for both local and LAN views.
- Sanitized output excludes payloads, authorization senders, mailbox identifiers, links, attachment paths, credentials, hashes, synthetic tests, and superseded records.
- Classified current transaction attention as `Needs Wes`, automatic recovery, system blocker, or workflow blocker and displayed safe ownership, context, attempts, next action, and decision fields.
- Kept Dashboard display-only; it performs no retry, state transition, acceptance, completion, or destination work.
