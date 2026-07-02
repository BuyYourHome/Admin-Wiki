# Markdown Versioning Guide

## Working Rule

The Markdown files should stay in sync with `3325_Banks_Rd_Class_Return_Model.xlsx`.

When changes are requested:

1. Update the relevant Markdown file or files.
2. Update the Excel workbook when the change affects assumptions, rents, revenue, operating expenses, returns, capitalization, or other model inputs/outputs.
3. Save a dated version copy of each changed Markdown file in `markdown_versions`.
4. Add a short note to this guide describing what changed.

## Current Working Files

* `01_Project_Program_and_Market.md`
* `02_Financial_Capitalization_and_Returns.md`
* `03_Entitlements_Utilities_and_Contacts.md`
* `04_Design_Development_and_Build_Cost_Analysis.md`

## Version History

### 2026-05-11 - v001

Initial split from `3325_Banks_Rd_Co-Living_Development.md` into three focused Markdown files. No financial assumptions were changed, so the Excel workbook did not need to be modified.

### 2026-05-11 - v002

Added a separate design, development, and build cost analysis file. This introduced planning cost ranges that are not yet included as a detailed cost tab in the Excel workbook, and identifies the workbook update needed before investor-facing use.

### 2026-05-11 - v003

Created an updated workbook copy named `3325_Banks_Rd_Class_Return_Model_with_Cost_Analysis.xlsx` with a new `Cost Analysis` worksheet aligned to `04_Design_Development_and_Build_Cost_Analysis.md`.

### 2026-05-11 - v004

Updated the original workbook `3325_Banks_Rd_Class_Return_Model.xlsx` so it also contains the new `Cost Analysis` worksheet. A pre-update workbook backup is preserved in `excel_versions`.

### 2026-05-11 - v005

Rebuilt the workbook update from a clean pre-cost-tab backup after the first `Cost Analysis` worksheet opened blank in Excel. Replaced both active workbook files with a corrected version whose worksheet XML contains the visible cost-analysis rows.

### 2026-05-11 - v006

Rebuilt both active workbook files from a clean pre-cost-tab backup after Excel showed a content-recovery warning in the synced Teams folder. The issue was traced to malformed internal workbook package paths from the prior direct edit. The active workbooks now use standard Excel package paths and contain the visible `Cost Analysis` worksheet.

### 2026-05-11 - v007

Fixed a workbook-level relationship ID conflict that caused Excel to report: "Removed Records: Worksheet properties from /xl/workbook.xml part (Workbook)." The `Cost Analysis` worksheet now uses `rId13`, avoiding the original workbook's existing `rId6` theme relationship.

### 2026-05-11 - v008

Updated the workbook and relevant Markdown files so project debt payoff is modeled as the lesser of 70% stabilized value or total Class A plus Class B capitalization. Class B capitalization is now modeled as the completion-capital amount required to cover the high-end project cost after Class A capital.
