---
name: property-trade-evaluation
description: Use for Buy Your Home property trade evaluations, trade/equity term sheets, transaction-structure comparisons, inspection or financing notes tied to a trade proposal, and English/Spanish review outputs under `Project Rooms\Property Trade Evaluation`.
---

# Property Trade Evaluation

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Property Trade Evaluation`
- Admin wiki source: `C:\Codex\Wiki Files`

Use this skill to keep trade proposal work separated from general property files and from project spreadsheet redesign work.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, and `Project Rooms\Property Trade Evaluation\README.md`.
3. Read `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check `git status --short --branch`.

## Workflow

1. Identify the active property, parties, proposed structure, and requested output.
2. Inventory the controlling source files or source notes before drafting.
3. Keep assumptions, unsupported values, and missing deal terms in `working\missing-context.md`.
4. Draft analyses and term-sheet experiments in `working\`.
5. Render and visually verify formal document outputs when the document format requires it.
6. Put review-ready deliverables in `outputs\`.
7. Copy files to Teams only when Wes asks for a final deliverable there or an existing workflow explicitly requires that delivery.

## Boundaries

- Do not treat prior trade-term examples as current terms for a new property.
- Do not infer legal, tax, financing, or ownership facts without source support.
- Do not commit `node_modules`, render folders, or generated previews unless Wes explicitly asks to preserve them as durable source.
- If the request becomes a property report/CMA, use the `cma-report` skill instead.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
