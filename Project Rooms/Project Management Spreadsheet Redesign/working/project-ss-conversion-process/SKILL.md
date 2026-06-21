---
name: project-spreadsheet-conversion-draft
description: Draft workflow for turning Buy Your Home project-management workbooks into clean reusable templates and converting active project spreadsheets into that template. Use inside the Project Management Spreadsheet Redesign project room while proving the process; do not install as a Codex skill until validated.
---

# Project Spreadsheet Conversion Draft

This draft stays in the project room until the process is proven. Do not copy it to the Codex skills folder until Wes approves promotion.

## Operating Rules

- Stop if any Excel process or project workbook is open, even if the user believes spreadsheets are closed. Report the process and get it closed first.
- Before any connector search, local synced-file inspection, workbook open, read-only review, backup, edit, migration, upload, or validation run, confirm the exact target workbook and project with Wes in the thread. If the target has not already been confirmed in the current turn, pause and wait for confirmation. Do not switch to a source/template workbook or another project workbook during design discussion unless Wes confirms that workbook as the target.
- Use the SharePoint/Teams connector as the authoritative discovery and transfer path for active project workbooks. Do not assume a local Teams-synced workbook is current merely because it exists or has a recent timestamp.
- Before converting or swapping sheets in an active project workbook, fetch or verify the exact current workbook through the SharePoint/Teams connector, record the connector URL/item used, and stage a working copy in the project room.
- After a workbook edit is validated, write the updated workbook back through the SharePoint/Teams connector to the same authoritative Teams/SharePoint item unless Wes explicitly asks for a project-room-only review copy.
- Treat local Teams-synced paths under `C:\Users\wesbr\Buy Your Home\...` as convenience working paths only after connector verification. If the connector is unavailable, cannot locate the workbook, or cannot write back safely, stop and report the blocker instead of falling back silently to the local sync folder.
- For `.xlsm` table-driven project workbooks, prefer Excel-native automation for edits and saves. Do not rewrite the workbook through libraries that strip table/query/external-data metadata.
- Treat the template as structure, formatting, formulas, tables, queries, relationships, and VBA.
- Treat the source workbook as project values and project-specific table rows.
- At completion of every workbook conversion, migration, or sheet-swap run, write any new lesson, failure mode, validation requirement, connector behavior, formula drift, or rollback issue discovered during that run into the appropriate durable rule file before marking the work complete. If there were no new reusable lessons, say that in the final response.
- Do not allow constants from a real project template to survive unless explicitly approved as defaults.
- After every generated workbook, reopen with Excel before delivery. If Excel reports repair/recovery, discard that output and diagnose before continuing.

## Mode 1: Make Template From Project Workbook

Goal: create a clean reusable template from any current project-management spreadsheet.

Process:
1. Confirm Excel is closed.
2. Copy the candidate workbook to the project room output area.
3. Open the copy with Excel automation.
4. Clear constants from project-specific input/data/table-body ranges while preserving formulas.
5. Restore known current formulas that the base workbook lacks or has stale versions.
6. Save through Excel.
7. Reopen read-only through Excel to validate there is no repair prompt.
8. Record a report with cleared ranges, key formula checks, package/table counts, and remaining visual-review areas.

Minimum formula checks:
- `Profit!B6` should support Flip/Hold/Slow Flip logic and reference `Amortization!O3` where appropriate.
- `Profit!F15` should use the modern Amortization-aware subject-to formula.
- `Profit!D19` should be formula-driven from `C19`.
- `Profit!D20` should be formula-driven from `C20` where seller payout maps there.
- `Gnatt Chart!I2` should keep the structured reference to `qryContractsToGnatt`.

## Mode 2: Convert Active Project Workbook Into Template

Goal: populate an approved clean template with values from an active or older project workbook.

Process:
1. Confirm Excel is closed.
2. Locate the active workbook through the SharePoint/Teams connector and fetch or verify the current item before using any local synced path.
3. Use only an approved clean template, not a real project workbook with residual values.
4. Inspect source workbook structure and map tabs before editing.
5. Open a copy of the clean template with Excel automation.
6. Clear target input/table areas that will receive source data.
7. Populate only mapped source values and rows.
8. Preserve target formulas unless a documented rule says to replace them.
9. Recalculate/save/reopen in Excel.
10. Run formula drift and template-residue audits.
11. Write the verified workbook back through the SharePoint/Teams connector when the request is to update the live Teams workbook.
12. Produce reconciliation notes before review.

Required audits:
- Formula audit: known formula cells match the approved formula map.
- Template-residue audit: constant/input cells either came from source mapping or are intentionally blank/defaulted.
- Table integrity audit: key structured-reference formulas still resolve to table names, not `#REF!`.
- Excel open audit: no repair/recovery prompt.

## Known Failure Modes

- Saving table-heavy `.xlsm` files through unsupported workbook libraries can cause Excel to remove external data ranges and table records on open.
- Rewriting whole worksheet XML can strip Excel extension metadata even when package part counts match.
- Using a real project workbook as a template leaves residual values such as Pond-specific seller note values.
- Copying evaluated source values into formula cells creates inconsistent formula preservation.

## Current Status

Draft only. Validated enough to guide the next experiments, not yet promoted to a Codex skill.
