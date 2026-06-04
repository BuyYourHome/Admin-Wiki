We are starting a new project-room conversion. Use the Spreadsheets skill.

Project room:
`C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion`

Goal:
Convert the Pinetree project management workbook into the newer Pond St project-management workbook structure. The two workbooks are widely different. Use the Pond St project as the template, and migrate Pinetree values into the new version. Do not edit the live Teams/property workbook.

Authoritative files:
- Pinetree source workbook:
  `C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion\sources\17_Project Management - 3413 Pinetree Ln - source.xlsx`
- Pond St template workbook:
  `C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion\template-reference\26_Project Management - 908 Pond St 3 - template.xlsm`
- Pleasant Garden Carrying reference:
  `C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion\template-reference\19_Project Management - 1426 Pleasant Garden Ln - Carrying reference.xlsx`
- Authoritative conversion rules:
  `C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion\Project Spreadsheet Expense Placement Rules.md`

Required process:
1. First confirm the relevant Excel files are closed. If any project workbook is open, stop and ask me to close it.
2. Do not make edits until you have inspected both the Pinetree source and Pond template structure.
3. Create a tab-by-tab migration map before editing. Note which Pond tabs will receive Pinetree values and which Pinetree tabs do not have a clear destination.
4. Make timestamped backups in:
   `C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion\working\backups`
5. Build the converted workbook only in:
   `C:\Codex\Wiki Files\Project Rooms\Pinetree Project Management Conversion\Need Verification`
6. Use the Pond St workbook as the target structure/template.
7. For the Carrying tab, follow the Pleasant Garden clean rebuild approach:
   - Rebuild table rows completely from the Pinetree source.
   - Do not migrate total or subtotal rows into the table.
   - Use only real source entries that should count; exclude projections unless explicitly approved.
   - Expand the visible grid so it has enough rows to show all migrated rows.
   - Clear old structure below the rebuilt grid.
   - Make the grid read from the table.
   - Reconcile source totals to output totals.
8. Preserve Pinetree project-specific values, but prefer Pond's structure, formatting, formulas, and table design where the two conflict.
9. After each major tab or group, verify source-vs-output totals and document anything learned in the Project Room before continuing.
10. Stop for Wes review before moving the converted workbook anywhere outside `Need Verification`.

Expected output:
- A review-ready converted Pinetree workbook in `Need Verification`.
- A concise conversion summary.
- A reconciliation report showing key source totals matched output totals.
- Updated project-room notes for any Pinetree-specific rules learned.

Start by inspecting the room files and reporting the proposed tab-by-tab migration map before making workbook changes.
