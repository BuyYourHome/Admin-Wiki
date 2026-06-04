# Source Inventory

| Source | Location | Status | Use |
| --- | --- | --- | --- |
| Pinetree source workbook | `sources\17_Project Management - 3413 Pinetree Ln - source.xlsx` | authoritative | Source values and project-specific data to migrate. |
| Pond St template workbook | `template-reference\26_Project Management - 908 Pond St 3 - template.xlsm` | authoritative template | Target workbook structure and formatting reference. |
| Pleasant Garden Carrying reference | `template-reference\19_Project Management - 1426 Pleasant Garden Ln - Carrying reference.xlsx` | authoritative for Carrying method | Clean Carrying tab rebuild pattern: expanded grid, table-driven values, totals reconciliation. |
| Conversion rules | `Project Spreadsheet Expense Placement Rules.md` | authoritative | Rules and lessons learned from Pond, Tensity, 7001, and Pleasant Garden conversions. |

## Notes

- The Pinetree and Pond workbooks are expected to be widely different.
- Do not assume same tab layout, row positions, categories, or formulas.
- Build a source-to-template migration map before editing.
