---
name: new-project
description: Create and track Buy Your Home New Project property folder/file packages under the New Project project room. Use when Wes asks to create a new property project, use/develop the New Project room, inventory New Project property setups, or produce work from `Project Rooms\New Project`.
---

# New Project

Use this skill to create new Buy Your Home property project folders/files and track all properties handled by the `New Project` project room.

## Required Context

Read these files first:

- `C:\Codex\Wiki Files\Admin Home.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\Project Room Workflow.md`
- `C:\Codex\Wiki Files\Codex Skill Source Rule.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\README.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\working\source-inventory.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\working\duplicate-and-conflict-log.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\working\missing-context.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\working\property-tracker.md`

## Workflow

1. Work only from `C:\Codex\Wiki Files`.
2. Keep New Project materials under `C:\Codex\Wiki Files\Project Rooms\New Project`.
3. Track every property setup request in `working\property-tracker.md`.
4. When Wes says to create a new project, suggest an existing project to use as the template for the new project spreadsheet and associated folders, then wait for Wes to confirm that template or name another one.
5. Expect Wes to provide the new project address. Use that address for the new project spreadsheet and associated folders after the template project is confirmed.
6. Create an address-specific output folder under `outputs\` for the property files.
7. Create any needed address-specific working folder under `working\` for cleanup notes, review questions, validation notes, or setup logs.
8. When the new project spreadsheet is created, review the `Profit` sheet and blank out specific values that came from the prototype/template project and should not carry into the new project. Preserve formulas, labels, structural formatting, and reusable assumptions unless Wes says to change them.
9. If it is unclear whether a `Profit` sheet value is template-specific or a reusable formula/assumption, record it for review instead of deleting it.
10. Update `working\property-tracker.md` with the confirmed template, output folder, spreadsheet path, cleanup status, blockers, and final setup status.
11. If Wes has not provided the minimum address, template, or setup scope needed to create files safely, record the missing context in `working\missing-context.md` and ask only for the minimum needed next decision.
12. Put raw source files or source notes in `sources\`.
13. Update `working\source-inventory.md` before drafting from sources.
14. Record duplicate, outdated, conflicting, or unclear sources in `working\duplicate-and-conflict-log.md`.
15. Keep analysis, experiments, and drafts in `working\`.
16. Put created property files, review-ready drafts, and final deliverables in `outputs\`.
17. Mark unsupported factual claims instead of smoothing over gaps.
18. Commit durable wiki changes locally. Push only under the Admin wiki push rules.

## Boundaries

- Do not move unrelated project-room materials into New Project unless Wes explicitly says they belong there.
- Do not treat New Project as a substitute for an existing specialized room when a better room already exists.
- Do not create final deliverables from unclear or missing source context.
- Do not treat property tracking as authority to edit live project workbooks, invoice workflows, contract packages, or another PR's files.
- Preserve original source files.
## Start PR Pointer

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
