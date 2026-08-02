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
