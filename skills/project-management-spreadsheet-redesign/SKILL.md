---
name: project-management-spreadsheet-redesign
description: Use for Buy Your Home project-management spreadsheet redesign, worksheet-mode rules, workbook migration planning, Profit/Amortization/Carrying tab rollout, validation notes, and work under `Project Rooms\Project Management Spreadsheet Redesign` or `Project Rooms\Project Management Spreadsheet Rewrite`.
---

# Project Management Spreadsheet Redesign

## Branch And Push Mode

- Project branch: `project/project-management-spreadsheet-redesign`.
- At startup for durable Project Room work, verify `C:\Codex\Wiki Files` and use the matching Project Room branch when it is safe to switch.
- When Wes says `Push`, follow `C:\Codex\Wiki Files\Project Room Branch and Push Mode Rule.md`: commit and push only this room's intentional durable work, this skill source when changed, and directly related registry or rule updates.
- Do not update GitHub `main` unless Wes explicitly says `Push to main` or `promote to main`.

## Source Of Truth

- Primary room: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign`
- Earlier rewrite room: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite`
- Authoritative redesign rules: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Project Spreadsheet Expense Placement Rules.md`
- Admin wiki source: `C:\Codex\Wiki Files`

Use the Redesign room for current worksheet rollout and migration work. Treat the Rewrite room as planning/history unless Wes specifically asks to work there.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, and `Codex Skill Source Rule.md`.
3. Read the active room README and `Project Spreadsheet Expense Placement Rules.md`.
4. Before editing spreadsheets, use the spreadsheet skill/runtime and confirm the target workbook is closed when required.
5. Check `git status --short --branch`.

## Workflow

1. Identify the worksheet mode or spreadsheet area being changed.
2. Read the matching worksheet-mode rule file when one exists.
3. Verify the current workbook through SharePoint/Teams connector when the workbook is Teams/SharePoint-backed and the workflow requires current-file confidence.
4. Make timestamped backups before structural workbook edits.
5. Reconnect formulas by meaning, not only by cell address, when migrating or replacing sheets.
6. Reconcile source totals to output totals before declaring a workbook ready for review.
7. Record reusable lessons in the relevant worksheet-mode rule file and the project-room working notes.
8. Put review-ready workbook outputs or specs in `outputs\`.

## Boundaries

- Do not edit live Teams/property workbooks unless Wes explicitly asks for that specific workbook change.
- Do not overwrite source workbooks silently.
- Do not move finished files back to Teams unless Wes asks or an established workflow explicitly requires that final delivery.
- Do not commit generated backups or rendered checks unless they are intentionally durable evidence.
