---
name: sops
description: Use for Buy Your Home Standard Operating Procedure work, including creating, reconciling, reviewing, updating, indexing, or routing SOP source emails, SOP workbook rows, SOP Markdown pages, SOP review questions, and SOP project-room materials under `Project Rooms\SOPs`.
---

# SOPs

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\SOPs`
- SOP index: `C:\Codex\Wiki Files\Project Rooms\SOPs\outputs\SOP Index.md`
- SOP source map: `C:\Codex\Wiki Files\Project Rooms\SOPs\working\Source Map.md`
- SOP spreadsheet rule: `C:\Codex\Wiki Files\SOP Spreadsheet Maintenance Rule.md`
- Admin wiki source: `C:\Codex\Wiki Files`

Use the SOPs Project Room for SOP source material, extracted notes, review questions, SOP pages, and SOP maintenance outputs.

## Required Startup

Before SOP file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, `Codex Skill Source Rule.md`, and `SOP Spreadsheet Maintenance Rule.md`.
3. Read `Project Rooms\SOPs\README.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check `git status --short --branch`.

## Workflow

1. Identify whether the request is intake, reconciliation, SOP drafting, SOP page update, workbook maintenance, or final delivery.
2. Put raw SOP source material in `sources\` or summarize it there before drafting from it.
3. Update `working\source-inventory.md` or `working\Source Map.md` when adding or changing sources.
4. Record duplicate, outdated, conflicting, or unclear sources in `working\duplicate-and-conflict-log.md`.
5. Record unresolved decisions in `working\missing-context.md` or `working\Questions for Review.md`.
6. Keep clean SOP pages under `outputs\SOPs\`.
7. Update `outputs\SOP Index.md` when SOP pages are added, renamed, or materially changed.
8. Follow the SOP spreadsheet rule before editing any workbook.

## Boundaries

- Do not use Teams as the working SOP source unless Wes explicitly asks for a final deliverable there.
- Do not blend conflicting SOP instructions. Mark conflicts and ask for a decision when the conflict changes the procedure.
- Do not treat general Admin rules as SOP pages unless Wes asks to reconcile them into the SOP corpus.
- Commit durable SOP updates locally. Push only under the Admin wiki push rules.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
