# Template to Project

## Purpose

This project room owns the process of moving approved worksheet, workbook, and mode designs from a prototype workbook into the active Buy Your Home project-management spreadsheets.

Use this room for template development, worksheet-mode rules, active-project target lists, workbook migration plans, rollback/validation procedures, lessons learned, and rollout logs.

This room began with the Pinetree-to-Pond conversion and the later project-management spreadsheet redesign work. Keep that history as source material, but treat the current room purpose as template-to-active-project migration and controlled workbook design rollout.

## Scope

Included:

- Prototype-to-project workbook migration planning.
- Worksheet-mode design rules and lessons learned.
- Active project spreadsheet candidate lists and exclusions.
- Workbook source/target mapping, rollback copies, migration logs, validation logs, and review handoffs.
- Rollout of approved worksheet designs such as `Amortization`, `Profit`, `Trade Properties`, `Docs`, `Gnatt Chart`, and Vendor Tabs Mode.
- Authoritative conversion rules: `Project Spreadsheet Expense Placement Rules.md`.
- Worksheet-mode rules: `Worksheet Modes\`.

Excluded unless Wes explicitly expands scope:

- Inserting individual invoices, receipts, or statement-line records into project spreadsheets. That belongs to `Invoice Entry`.
- Scan inspection/OCR, document splitting, invoice-file routing, or scan logs. That belongs to `Doc Scan`.
- Paying invoices, approving invoices, contacting vendors, or changing accounting systems.
- Editing another project room's files or skill source without exact Wes approval.

## Operating Rules

- Before workbook edits, confirm the exact target workbook and the active worksheet mode.
- Use Teams/SharePoint as the source of truth for active project-management workbooks when the workbook is Teams-backed.
- Project-management spreadsheets live directly under the Teams/SharePoint `Property` drive root, not inside individual property folders.
- Before each worksheet-specific redesign or rollout task, read the matching file under `Worksheet Modes\`.
- Make timestamped rollback copies before structural workbook edits.
- Reconnect formulas by meaning, named ranges, table names, labels, and expected business purpose, not by blind cell-position copying.
- Migrate project-specific values with a full map for each project. Do not assume one project maps the same as another.
- Preserve formulas, formatting, widths, tables, checkboxes/selectors, names, print settings, macros, and helper areas unless the approved mode design intentionally changes them.
- Reconcile source totals to output totals before calling a workbook ready for review.
- Stop after each approved worksheet or mode milestone when Wes has asked to review between steps.
- Record new reusable lessons in the matching worksheet-mode file before treating a rollout iteration as complete.

## Current Status

Active. `Template to Project` is the canonical name for this project room and matching skill.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\template-to-project\SKILL.md`

## Next Actions

1. Confirm the active worksheet mode and approved prototype/template workbook.
2. Confirm the active project workbook list and exclusions.
3. Draft or update the project-specific migration map before editing.
4. Roll out one worksheet or mode milestone at a time and verify totals before moving on.

## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
