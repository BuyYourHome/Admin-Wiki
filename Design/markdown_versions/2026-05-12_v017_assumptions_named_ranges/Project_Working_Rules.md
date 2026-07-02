# 3325 Banks Rd Project Working Rules

## Source Of Truth

* The Excel workbook `3325_Banks_Rd_Investor_ROI.xlsx` is the source of truth for financial model numbers, assumptions, formulas, and outputs.
* Markdown files should stay in sync with the Excel workbook.
* If a requested change affects rents, revenue, expenses, capitalization, project costs, debt payoff, returns, or investor distributions, update the Excel workbook first and then update the relevant Markdown files.

## Active Working Files

* `3325_Banks_Rd_Investor_ROI.xlsx`
* `01_Project_Program_and_Market.md`
* `02_Financial_Capitalization_and_Returns.md`
* `03_Entitlements_Utilities_and_Contacts.md`
* `04_Design_Development_and_Build_Cost_Analysis.md`
* `Markdown_Versioning_Guide.md`

## Versioning

* Keep dated Markdown snapshots in `markdown_versions`.
* Before material workbook changes, preserve a workbook backup in `excel_versions`.
* Do not overwrite user spreadsheet edits without reading the current workbook first.
* When the user makes spreadsheet changes, treat those edits as intentional unless there is a clear conflict.

## Spreadsheet Formatting

* Format currency-like workbook values with comma separators and no dollar signs.
* Example: use `1,500,000`, not `$1,500,000`.
* Percentages should remain formatted as percentages.
* Keep formulas linked where possible instead of duplicating hardcoded values.
* Use named ranges for key Assumptions tab inputs and outputs so formulas remain readable.
* Prefer names such as `ClassACapital`, `ClassBCapital`, `OperatingExpenseRatio`, and `ProjectDebtPayoffAtRefi` over direct references such as `Assumptions!$B$28`.

## Cost Analysis Logic

* Keep the sponsor-controlled working case separate from the outside-market benchmark.
* The sponsor-controlled case reflects post-frame construction, sponsor-owned equipment, sponsor-controlled crew capacity, and disciplined finish scope.
* Outside-market rows are benchmark/stress-case rows and should not control Class B capitalization unless intentionally changed.
* The controlling sponsor-controlled total project cost should link to the controlling line-item bridge.
* The Cost Analysis case summary should clearly show:
  * Sponsor-Controlled Case linked to its line-item bridge.
  * Outside-Market Benchmark linked to outside-market subtotals.
  * Selected Total Project Cost linked to the selected underwriting case.
* Class B completion capital should be calculated as selected high total project cost less Class A capital.
* Project debt payoff should be modeled as the lesser of:
  * 70% of stabilized value, or
  * Class A plus Class B capitalization.

## Teams Folder Handling

* This project is in a synced Teams/SharePoint folder.
* Folder names may contain spaces; use quoted/full literal paths when scripting or automating.
* Prefer Excel automation for workbook edits when available.
* Avoid direct `.xlsx` package edits unless Excel automation is unavailable and a backup has been made.

## File Hygiene

* Keep one active Excel model unless a duplicate is intentionally needed.
* Remove temporary workbook repair/rebuild files after verification.
* Keep backups in `excel_versions` rather than cluttering the main folder.

## Current Naming

* Active workbook: `3325_Banks_Rd_Investor_ROI.xlsx`
* Version history file: `Markdown_Versioning_Guide.md`
