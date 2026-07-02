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

### 2026-05-12 - v023

Changed the Cost Analysis selected project cost display so only the selected scenario appears: Low displays in `B17`, High displays in `C17`, and helper cell `D17` carries the single selected project cost for downstream formulas.

### 2026-05-12 - v024

Updated the workbook and relevant Markdown files for the revised capital structure. Class A and Class B member capital are now the only modeled development/build capital sources. Existing debt is tracked separately as a 119,000 first mortgage plus 75,000 private debt at 10.0% interest-only. The only new loan in the model is the stabilization refinance/takeout loan, with proceeds paying existing debt first, then flowing through the waterfall to Class A before Class B.

### 2026-05-12 - v025

Added the existing first mortgage interest rate of 3.25% to the workbook debt assumptions, named ranges, Cost Analysis tab, and relevant Markdown files.

### 2026-05-14 - v026

Added existing-debt service to the workbook and Markdown files. The model now shows first mortgage annual payment excluding escrow, private debt annual interest, and total existing annual debt service before refinance. Property taxes and insurance remain in operating expenses. The first mortgage payment is currently an interest-only placeholder until the actual P&I payment is provided.

### 2026-05-14 - v027

Replaced the first mortgage placeholder with the actual principal-and-interest payment of 526 per month, or 6,312 per year, excluding escrow. Total existing annual debt service before refinance is now 13,812. Added an Annual Model cash roll-forward with cash available before distributions, Waterfall distributions, ending cash balance, and total cash available.

### 2026-05-14 - v028

Updated the waterfall so residual distributions after capital return priorities are shared proportionally among Class A, Class B, and Sponsor. Current formula-based residual shares are Class A 33.33%, Class B 50.00%, and Sponsor 16.67%, based on Class A capital of 300,000, Class B capital of 450,000, and Sponsor basis of 150,000.

### 2026-05-14 - v029

Revised residual sharing to use an adjustable Sponsor/Class pool split. Sponsor residual share is now editable and currently set to 60.00%. Class A and Class B split the remaining 40.00% residual pool in proportion to contributed capital, resulting in current residual shares of Class A 16.00% and Class B 24.00%.

### 2026-05-15 - v030

Removed the redundant `Total Cash Available` column from the Annual Model. The model now uses `Cash Available Before Distributions`, `Waterfall Distributions`, and `Ending Cash Balance` without duplicating the pre-distribution cash column. Updated Annual Model formulas to preserve the Waterfall's formatted layout by summing Class A total distributions, Class B total distributions, and Sponsor total distributions from their formatted columns.

### 2026-05-15 - v031

Updated Wake County Environmental Services - Well & Septic contact information to include phone menu Option 3 and email `Waste.Water@Wake.gov`.

### 2026-05-15 - v032

Added Keith Lankford's email, `Keith.Lankford@Wake.gov`, to the Wake County Planning & Zoning contact section.

### 2026-05-15 - v033

Converted the `Annual Model` and `Waterfall` model ranges into structured Excel Tables named `AnnualModelTable` and `WaterfallTable`. Updated Annual Model and Returns formulas to use table column names with `INDEX/MATCH` instead of fixed Waterfall cell references such as `Waterfall!S6`. Preserved the formatted Waterfall layout and repaired table formulas after conversion.

### 2026-05-15 - v034

Removed the confusing intermediate `A Cash After` column from the Waterfall table. Class B capital return and Class A/Class B/Sponsor residual formulas now calculate directly from cash available less Class A preferred return, Class A capital return, and Class B capital return. Verified no formula errors after the table shrank to `WaterfallTable` columns A:R.

### 2026-05-15 - v035

Converted the `Returns` tab range into a structured table named `ReturnsTable`. Added a live `ReturnsSummaryTable` under the `WaterfallTable` on the Waterfall tab so returns can be reviewed directly beneath the waterfall. Both tables use formulas tied to `WaterfallTable` and were verified with no formula errors.

### 2026-05-15 - v036

Made the Waterfall tab's embedded returns table the primary `ReturnsTable` and hid the old standalone `Returns` sheet as a legacy reference. The primary `ReturnsTable` now sits directly below `WaterfallTable` on the Waterfall tab and remains formula-driven from `WaterfallTable`.

### 2026-05-15 - v037

After the Cost Analysis `A6:C11` summary section was removed, repaired the broken funding-gap reference and added a specific sponsor property payment to the sponsor-controlled bridge. The sponsor property payment is currently 150,000, increases the selected sponsor-controlled low case to 900,000, increases Class B completion capital to 600,000, and is shown as a Year 0 Sponsor distribution in the Waterfall.

### 2026-05-15 - v038

Added Wake County wastewater contacts Jill Perkins, (919) 856-7342, and Allen Alcock, (919) 868-2560, to the Wake County Environmental Services - Well & Septic section.

### 2026-05-15 - v039

Separated Sponsor property payment from Sponsor residual in the Waterfall. Added a dedicated Sponsor `Property Payment` column, kept Sponsor `Residual` for true residual proceeds only, and made Sponsor `Total Dist.` equal property payment plus residual. Updated ReturnsTable so Sponsor Year 0 shows the 150,000 property payment as a distribution rather than a negative basis cash flow.

