# Markdown Versioning Guide

## Working Rule

The Markdown files should stay in sync with `3325_Banks_Rd_Investor_ROI.xlsx`.

When changes are requested:

1. Update the relevant Markdown file or files.
2. Update the Excel workbook when the change affects assumptions, rents, revenue, operating expenses, returns, capitalization, or other model inputs/outputs.
3. Save a dated version copy of each changed Markdown file in `markdown_versions`.
4. Add a short note to this guide describing what changed.

## Current Working Files

* `Project_Working_Rules.md`
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

Created an updated workbook copy named `3325_Banks_Rd_Investor_ROI_with_Cost_Analysis.xlsx` with a new `Cost Analysis` worksheet aligned to `04_Design_Development_and_Build_Cost_Analysis.md`.

### 2026-05-11 - v004

Updated the original workbook `3325_Banks_Rd_Investor_ROI.xlsx` so it also contains the new `Cost Analysis` worksheet. A pre-update workbook backup is preserved in `excel_versions`.

### 2026-05-11 - v005

Rebuilt the workbook update from a clean pre-cost-tab backup after the first `Cost Analysis` worksheet opened blank in Excel. Replaced both active workbook files with a corrected version whose worksheet XML contains the visible cost-analysis rows.

### 2026-05-11 - v006

Rebuilt both active workbook files from a clean pre-cost-tab backup after Excel showed a content-recovery warning in the synced Teams folder. The issue was traced to malformed internal workbook package paths from the prior direct edit. The active workbooks now use standard Excel package paths and contain the visible `Cost Analysis` worksheet.

### 2026-05-11 - v007

Fixed a workbook-level relationship ID conflict that caused Excel to report: "Removed Records: Worksheet properties from /xl/workbook.xml part (Workbook)." The `Cost Analysis` worksheet now uses `rId13`, avoiding the original workbook's existing `rId6` theme relationship.

### 2026-05-11 - v008

Updated the workbook and relevant Markdown files so project debt payoff is modeled as the lesser of 70% stabilized value or total Class A plus Class B capitalization. Class B capitalization is now modeled as the completion-capital amount required to cover the high-end project cost after Class A capital.

### 2026-05-11 - v009

Revised cost framing to reflect sponsor-controlled post-frame construction, sponsor-owned equipment, and sponsor-controlled crew capacity. Kept the outside-market benchmark analysis, but changed the controlling working case to the sponsor's prior total package estimate of 700,000-1,300,000.

### 2026-05-11 - v010

Formatted workbook numeric/currency values with comma separators and no dollar signs.

### 2026-05-11 - v011

Added justification for the 700,000-1,300,000 sponsor-controlled cost range. The range is now presented as a target underwriting case, not gospel, and is supported by a line-item bridge, required conditions, and risk factors that could move costs above the range.

### 2026-05-11 - v012

Read sponsor confirmations in the workbook's `Cost Analysis` tab. Confirmed cost-saving assumptions support the post-frame/owner-crew case, but unresolved wastewater risk and confirmed risk factors increased the working sponsor-controlled range to 750,000-1,500,000. Class B completion capital increased to 1,200,000.

### 2026-05-11 - v013

Linked the Cost Analysis tab's selected total project cost row to the controlling sponsor-controlled line-item bridge. Relabeled rows 24-50 as Outside Market benchmark sections.

### 2026-05-12 - v014

Renamed the active workbook from `3325_Banks_Rd_Class_Return_Model.xlsx` to `3325_Banks_Rd_Investor_ROI.xlsx` and updated Markdown references.

### 2026-05-12 - v015

Added `Project_Working_Rules.md` to track source-of-truth rules, workbook/Markdown sync expectations, spreadsheet formatting conventions, cost-analysis logic, Teams folder handling, and file hygiene.

### 2026-05-12 - v016

Cleaned up the Cost Analysis case summary rows. Row 14 now links to the Sponsor-Controlled Case from rows 61-68, row 15 links to the Outside-Market Benchmark subtotals, row 16 identifies the selected underwriting case, and row 17 links to the selected total project cost.

### 2026-05-12 - v017

Added workbook-level named ranges for key Assumptions tab cells and converted formulas to use readable names such as `ClassACapital`, `ClassBCapital`, `OperatingExpenseRatio`, `StabilizedMonthlyGrossRent`, and `ProjectDebtPayoffAtRefi`.

### 2026-05-12 - v018

Added an `Operating Expense Budget` worksheet with detailed annual operating expense line items, assumed ratio, calculated budget ratio, selected ratio, and a workbook-safe toggle. `Assumptions!B15` now pulls from the selected operating expense ratio on that tab.

### 2026-05-12 - v019

Moved the sponsor-controlled metrics and controlling line-item bridge on the Cost Analysis tab so it sits directly below the project cost case summary. Updated labels to avoid stale row-number references.

### 2026-05-12 - v020

Added case selection controls beside the Sponsor-Controlled Case and Outside-Market Benchmark on the Cost Analysis tab. Removed the redundant static total project cost metric row and linked cost-per-SF metrics to the selected total project cost.

### 2026-05-12 - v021

Replaced independent case/scenario checkboxes with mutually exclusive option-button groups. The Cost Analysis tab now selects exactly one cost case and one scenario, and Class B completion capital is based on the single selected total project cost.

### 2026-05-12 - v022

Replaced unreliable option-button controls with dropdown selectors. `Cost Analysis!C12` selects Low or High, and `Cost Analysis!D15` selects Sponsor-Controlled or Outside-Market Benchmark. The selected project cost and Class B completion capital flow from those dropdowns.

