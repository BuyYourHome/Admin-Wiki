---
name: template-to-project
description: Use for Buy Your Home Template to Project work: migrating approved prototype workbook, worksheet, and worksheet-mode designs into active project-management spreadsheets; maintaining worksheet-mode rules, rollout target lists, rollback/validation logs, and lessons learned. Do not use for inserting individual invoice, receipt, or statement-line records.
---

# Template to Project

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Template to Project`
- Skill source: `C:\Codex\Wiki Files\skills\template-to-project\SKILL.md`
- Worksheet-mode rules: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Worksheet Modes`
- Authoritative project spreadsheet rules: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Project Spreadsheet Expense Placement Rules.md`
- Earlier rewrite room for planning/history only: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Rewrite`
- Admin wiki source: `C:\Codex\Wiki Files`

Use this skill for current template-to-project worksheet rollout and migration work. Treat the Rewrite room as planning/history unless Wes specifically asks to work there.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, and `Codex Skill Source Rule.md`.
3. Read the active room README and `Project Spreadsheet Expense Placement Rules.md`.
4. Identify the active worksheet mode and read the matching file under `Worksheet Modes\` before worksheet-specific work.
5. Before editing spreadsheets, use the spreadsheet skill/runtime and confirm the exact target workbook is closed when required.
6. Check `git status --short --branch`.

## Workflow

1. Confirm the prototype/template workbook, target project workbook, and worksheet mode.
2. Verify the current workbook through SharePoint/Teams connector when the workbook is Teams/SharePoint-backed.
3. Make timestamped backups before structural workbook edits.
4. Build a full project-specific value map for the worksheet or mode being migrated.
5. Reconnect formulas by meaning, named ranges, table names, labels, and business purpose, not only by cell address.
6. Preserve formulas, formatting, widths, tables, checkboxes/selectors, names, print settings, macros, and helper areas unless the approved mode design intentionally changes them.
7. Reconcile source totals to output totals before declaring a workbook ready for review.
8. Record reusable lessons in the relevant worksheet-mode rule file and the project-room working notes.
9. Put review-ready workbook outputs or specs in `outputs\`.

## Boundaries

- Do not edit live Teams/property workbooks unless Wes explicitly asks for that specific workbook change.
- Do not overwrite source workbooks silently.
- Do not move finished files back to Teams unless Wes asks or an established workflow explicitly requires that final delivery.
- Do not commit generated backups or rendered checks unless they are intentionally durable evidence.
- Do not insert individual invoice, receipt, or statement-line records into project spreadsheets; that belongs to `Invoice Entry`.
- Do not scan invoices, split documents, OCR scans, or route invoice files; that belongs to `Doc Scan`.
- Do not edit another project room's files or skill source without exact Wes approval.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
