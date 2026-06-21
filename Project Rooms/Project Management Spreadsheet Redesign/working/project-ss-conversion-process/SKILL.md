---
name: project-spreadsheet-conversion-draft
description: Draft workflow for turning Buy Your Home project-management workbooks into clean reusable templates and converting active project spreadsheets into that template. Use inside the Project Management Spreadsheet Redesign project room while proving the process; do not install as a Codex skill until validated.
---

# Project Spreadsheet Conversion Draft

This draft stays in the project room until the process is proven. Do not copy it to the Codex skills folder until Wes approves promotion.

## Operating Rules

- Stop if any Excel process or project workbook is open, even if the user believes spreadsheets are closed. Report the process and get it closed first.
- For `.xlsm` table-driven project workbooks, prefer Excel-native automation for edits and saves. Do not rewrite the workbook through libraries that strip table/query/external-data metadata.
- Treat the template as structure, formatting, formulas, tables, queries, relationships, and VBA.
- Treat the source workbook as project values and project-specific table rows.
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
2. Use only an approved clean template, not a real project workbook with residual values.
3. Inspect source workbook structure and map tabs before editing.
4. Open a copy of the clean template with Excel automation.
5. Clear target input/table areas that will receive source data.
6. Populate only mapped source values and rows.
7. Preserve target formulas unless a documented rule says to replace them.
8. Recalculate/save/reopen in Excel.
9. Run formula drift and template-residue audits.
10. Produce reconciliation notes before review.

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
