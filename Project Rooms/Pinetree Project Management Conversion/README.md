# Pinetree Project Management Conversion

## Purpose

Convert the Pinetree project management workbook into the newer Pond St project-management workbook structure while preserving Pinetree's project-specific data.

## Intended Output

- Review-ready converted Pinetree workbook in `Need Verification\`.
- A source-to-output reconciliation showing that values migrated correctly.
- Notes documenting any Pinetree-specific rules learned during the conversion.
- A conversion process that can be reused as a template for future complicated project conversions.

## Current Scope

Included:

- Source workbook: `sources\17_Project Management - 3413 Pinetree Ln - source.xlsx`
- Template workbook: `template-reference\26_Project Management - 908 Pond St 3 - template.xlsm`
- Carrying reference workbook: `template-reference\19_Project Management - 1426 Pleasant Garden Ln - Carrying reference.xlsx`
- Authoritative conversion rules: `Project Spreadsheet Expense Placement Rules.md`

Excluded unless Wes explicitly approves:

- Editing the live Teams/property workbook.
- Moving the finished file back to Teams.
- Deleting or overwriting source workbooks.

## Operating Rules

- Before workbook edits, confirm the relevant workbook is closed.
- Make timestamped backups in `working\backups\` before structural edits.
- Build the converted workbook in `Need Verification\`.
- Use the Pond St workbook as the structure/template reference.
- Use Pleasant Garden's clean Carrying rebuild approach for the Carrying tab.
- Do not migrate subtotal/total rows into tables.
- Rebuild table rows completely from source data.
- Expand visible grids so they show all migrated source rows, not just the old fixed display height.
- Reconcile source totals to output totals before calling a conversion ready for review.

## Current Status

Project room created. Conversion has not started.

## Next Actions

1. Start a new chat with the prompt in `prompts\start-pinetree-conversion.md`.
2. Inspect source and template workbook structures.
3. Draft a tab-by-tab migration map before editing.
4. Convert one area at a time and verify totals before moving on.
