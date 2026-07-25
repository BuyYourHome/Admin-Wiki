# Jean Dispatcher Implementation Plan

Date: 2026-07-24

Prepared from the Jean Wright / Admin Operations chat.

## Objective

Create a lightweight operating model where Wes can speak to Jean as the front desk for Admin wiki work, and Jean can route work to the correct dedicated Project Room task without overwhelming the Jean chat, mixing project-room ownership, or creating unsafe Git activity.

The intended model is not for Jean to do all specialized work. Jean should classify the request, identify the owning Project Room, send a concise handoff to that room when a dedicated task exists, and either return control to Wes or monitor only when Wes asks Jean to monitor.

## Current State From Poll

- Canonical repository: `C:\Codex\Wiki Files`.
- Current branch: `main`.
- Project Rooms found: 35.
- Every Project Room has a `README.md`.
- Most Project Rooms have `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
- No Project Room currently has `working\work-status.md`.
- Several Project Rooms do not have a one-to-one matching skill.
- Several dedicated task/thread ids are documented, but many are missing or only implied.
- Existing unrelated dirty worktree change at poll time: `Project Rooms\Email Monitor\working\routing-action-log.md`. Do not include it in dispatcher commits unless it is intentionally part of that work.

## Reversible Checkpoint

Before implementation, create a single rollback point:

1. Confirm `git status --short --branch`.
2. Make sure all existing intended work has been committed and pushed or deliberately left out.
3. Create and push a checkpoint tag, suggested name: `checkpoint-before-jean-dispatcher-2026-07-24`.
4. Keep the dispatcher rollout in focused commits so it can be reverted by commit or by returning to the checkpoint tag.

This checkpoint protects the Admin wiki source. Installed local skills under `%USERPROFILE%\.codex\skills` may also need resync/reinstall reversal if the rollout syncs skills.

## Common Changes Needed

These changes should be applied in priority order:

1. Add a Jean Dispatcher mode to Jean Wright.
   - Define request classification, routing, handoff format, and when Jean should monitor versus return control to Wes.
   - Add `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`.
   - Add `Project Rooms\Jean Wright\working\dispatcher-action-log.md`.
   - Add a standard `dispatch_id` format.

2. Complete a central dispatch map.
   - For each Project Room, record owning room, skill, thread/task id, routing rule, email-delivery authority, and status.
   - Use the map as Jean's first lookup before sending a handoff.

3. Add a small standard intake/return section to Project Room rules.
   - Each PR should be able to accept a Jean handoff.
   - Each PR should return one of: `accepted`, `done`, `blocked`, `needs Wes`, `rejected as wrong room`, or `routed onward with approval`.
   - Each PR should report files changed, commits made, push status, and any decision needed.

4. Add or defer `work-status.md`.
   - Because no PR currently has this file, do not force it into every room at once unless Wes approves the overhead.
   - Recommended minimum: create it first for high-traffic PRs and any PR receiving active routed work.

5. Update Create PR.
   - New Project Rooms should be created dispatcher-ready by default.
   - Create PR should include the standard README intake/return section, registry entry, skill entry, thread id handling, and Teams/source-file handling.

6. Validate with dry runs.
   - Test one simple Jean-to-PR handoff.
   - Test one multi-PR handoff where Jean routes to more than one owner but does not wait in queue unless asked.
   - Test one rejected handoff where the receiving PR says it is the wrong room.

## Priority Plan

### Phase 0 - Checkpoint And Scope Guard

Priority: Critical

Changes:
- Confirm clean or intentionally scoped Git state.
- Create/push checkpoint tag.
- Document that dispatcher implementation must remain in focused commits.

Estimated unattended time: 15 to 30 minutes.

### Phase 1 - Jean Dispatcher Core

Priority: Critical

Changes:
- Update Jean Wright README and skill with Dispatcher mode.
- Create Jean dispatcher routing map and dispatcher action log.
- Add standard handoff template and return template.
- Define when Jean stops after handoff and when Jean waits or monitors.

Estimated unattended time: 45 to 75 minutes.

### Phase 2 - Registry And Thread Id Audit

Priority: High

Changes:
- Update `Agents and Automations Registry.md` with a complete dispatcher table.
- Mark unknown thread ids as `pending`.
- Record known task ids from README, skills, and registry.
- Do not create new tasks unless Wes explicitly asks.

Estimated unattended time: 45 to 90 minutes.

### Phase 3 - High-Traffic PR Rollout

Priority: High

Project Rooms:
- Email Monitor
- Invoice Entry
- Doc Scan
- Manager
- Gracious Millionaire
- REI BlackBook
- Contract for Deed
- Credit Worthiness Evaluator
- Template to Project
- Create PR

Changes:
- Add standard intake/return language.
- Confirm routing to Email Monitor Email Delivery mode where email is involved.
- Confirm thread ids or mark pending.
- Add `work-status.md` only if Wes approves or the PR is actively receiving routed work.

Estimated unattended time: 2 to 3.5 hours.

### Phase 4 - Medium-Traffic PR Rollout

Priority: Medium

Project Rooms:
- Brynda Suit
- LD Evans
- Jennys Drawings
- Computers
- Codex Environment
- SOPs
- Operating Agreements
- Property Trade Evaluation
- Estate Documents
- New Project
- Voices
- Entity Relationship
- Confidential

Changes:
- Add standard intake/return language.
- Add missing skill or mark PR as source-only/manual where appropriate.
- Record special restrictions, especially Confidential.

Estimated unattended time: 2 to 4 hours.

### Phase 5 - Low-Traffic, Support, And Legacy Rooms

Priority: Medium-Low

Project Rooms:
- Admin Wiki Maintenance
- AIOS
- Amortization
- CMA Report
- CMA Report - 5009 Sunnyfield Dr
- CMA Report - 5021 Sunnyfield Dr
- CMA Report - 5512 Desert Willow Ln
- Geico Insurance Claim
- Investigate Computer
- Lowes Order
- Project Management Spreadsheet Rewrite

Changes:
- Decide whether each room needs a dedicated skill, a shared skill, or a legacy/archive classification.
- For per-property CMA rooms, route through the shared CMA Report skill unless Wes wants separate dedicated tasks.
- For Project Management Spreadsheet Rewrite, route through Template to Project unless Wes revives it as a separate active room.

Estimated unattended time: 1.5 to 3 hours.

### Phase 6 - Sync And Dry-Run Validation

Priority: High

Changes:
- Sync updated wiki-managed skills only after source changes are committed.
- Run one or more dry-run dispatches without changing external files.
- Confirm no unexpected Git branch switching or cross-PR writes.
- Confirm Email Monitor remains the email-delivery authority.

Estimated unattended time: 1 to 2 hours.

## Total Estimate

Minimum viable dispatcher:
- Phase 0 through Phase 2 plus one high-traffic dry run.
- Estimated unattended time: 2 to 4 hours.

Complete careful rollout:
- Phase 0 through Phase 6 across all rooms.
- Estimated unattended time: 8 to 14 hours.

The estimate assumes the Codex task/thread tools and Outlook/Teams connectors are available when needed. Connector stalls, missing task ids, dirty worktree conflicts, or user decisions about whether to create missing skills can extend the timeline.

## Project Room Change Inventory

| Project Room | Current Readiness | Needed Changes |
| --- | --- | --- |
| Admin Wiki Maintenance | README exists; no matching skill; missing standard working ledgers. | Classify as shared governance room or create skill. Add dispatcher intake rules if kept active. |
| AIOS | README and matching skill exist; thread id not found; no work-status. | Add dispatcher intake/return section, record thread id or pending, decide if active. |
| Amortization | README and matching skill exist; thread id not found; no work-status. | Add dispatcher intake/return section and clarify support relationship to Contract for Deed and spreadsheet work. |
| Brynda Suit | README, skill, and thread id found. | Add standard dispatcher intake/return section and status response format. |
| CMA Report | README and shared skill exist; no thread id found. | Add dispatcher intake/return section and clarify that per-property CMA rooms route through this shared workflow. |
| CMA Report - 5009 Sunnyfield Dr | README exists; no separate skill. | Classify as per-property output room under CMA Report. Do not create separate skill unless Wes asks. |
| CMA Report - 5021 Sunnyfield Dr | README exists; no separate skill. | Classify as per-property output room under CMA Report. Do not create separate skill unless Wes asks. |
| CMA Report - 5512 Desert Willow Ln | README exists; no separate skill. | Classify as per-property output room under CMA Report. Do not create separate skill unless Wes asks. |
| Codex Environment | README, skill, and thread id found. | Add dispatcher intake/return section and preserve machine-setup boundaries. |
| Computers | README, skill, and thread id found. | Add dispatcher intake/return section and preserve inventory/update boundaries. |
| Confidential | README, skill, and thread id found. | Add dispatcher intake/return section with restricted handoff detail and no unnecessary source copying. |
| Contract for Deed | README and skill exist; no dedicated thread id found in poll; uses Email Monitor for delivery. | Add dispatcher intake/return section, record thread id or pending, preserve Wes-only email package restrictions. |
| Create PR | README, skill, and thread id found. | Update templates so future PRs are dispatcher-ready. Add dispatcher setup checklist. |
| Credit Worthiness Evaluator | README and skill exist; no thread id found. | Add dispatcher intake/return section, record thread id or pending, clarify Contract for Deed handoff boundary. |
| Doc Scan | README and skill exist; no direct thread id found; routes Invoice Entry. | Add dispatcher intake/return section, scanned-document return format, and optional work-status for active runs. |
| Email Monitor | README, skill, and status thread id found. | Add dispatcher-specific handoff handling and confirm Email Delivery remains centralized. |
| Entity Relationship | README and skill exist; no thread id found. | Add dispatcher intake/return section and record thread id or pending. |
| Estate Documents | README exists; no matching skill. | Decide whether to create skill or classify as source/manual room. Add dispatcher intake if active. |
| Geico Insurance Claim | README exists; no matching skill. | Decide whether to create skill or classify as source/manual room. Add dispatcher intake if active. |
| Gracious Millionaire | README, skill, and thread id found; has routing rules. | Add dispatcher return format and avoid duplicating OfficeAssist email-routing rules. |
| Investigate Computer | README and skill exist; no thread id found. | Add dispatcher intake/return section and record thread id or pending. |
| Invoice Entry | README, skill, and thread id found; already uses Email Monitor for delivery. | Add dispatcher return format and keep invoice source handling in Teams/outside Git. |
| Jean Wright | README and skill exist; this is the dispatcher owner. | Add Dispatcher mode, routing map, action log, handoff template, return template, and monitoring rule. |
| Jennys Drawings | README, skill, and thread id found; uses Email Monitor for delivery. | Add dispatcher intake/return section. |
| LD Evans | README, skill, and thread id found; uses Email Monitor for delivery. | Add dispatcher intake/return section. |
| Lowes Order | README, skill, and thread id found. | Add dispatcher intake/return section and determine whether room remains active. |
| Manager | README, skill, and thread id found; owns task register. | Add dispatcher intake/return section and clarify when Jean creates Manager tasks versus routing work to Manager. |
| New Project | README and skill exist; no thread id found. | Add dispatcher intake/return section, record thread id or pending, and align with Create PR defaults. |
| Operating Agreements | README exists; skill folder appears singular as `operating-agreement`. | Align registry naming, add dispatcher intake/return section, and decide whether to rename skill only with explicit authorization. |
| Project Management Spreadsheet Rewrite | README exists; no matching skill; likely covered by Template to Project. | Classify as legacy or route through Template to Project. Do not revive without Wes approval. |
| Property Trade Evaluation | README and skill exist; no thread id found. | Add dispatcher intake/return section and record thread id or pending. |
| REI BlackBook | README, skill, and thread id found; uses Email Monitor for delivery. | Add dispatcher return format and preserve GM Site routing boundary. |
| SOPs | README and skill exist; no thread id found. | Add dispatcher intake/return section and record thread id or pending. |
| Template to Project | README and skill exist; no thread id found. | Add dispatcher intake/return section and record thread id or pending. |
| Voices | README and skill exist; no thread id found. | Add dispatcher intake/return section and record thread id or pending. |

## Open Decisions For Wes

- Whether every active PR should get `working\work-status.md`, or only high-traffic PRs and PRs with active routed work.
- Whether source/manual rooms without matching skills should receive new skills.
- Whether legacy or per-property support rooms should remain separate PRs or be classified as children of shared PRs.
- Whether Jean should ever monitor routed work by default, or only when Wes explicitly says to monitor.
- Whether task/thread ids should be completed before rollout or allowed to remain `pending` until first use.

## Recommendation

Implement the dispatcher in two steps:

1. Build the Jean dispatcher core and central routing map first.
2. Roll the intake/return rules into PRs in priority order, starting only with the high-traffic PRs.

This avoids a large all-at-once rules change while still giving Wes a usable dispatcher model quickly. The work remains reversible because the checkpoint tag and focused commits separate dispatcher rules from unrelated PR work.
