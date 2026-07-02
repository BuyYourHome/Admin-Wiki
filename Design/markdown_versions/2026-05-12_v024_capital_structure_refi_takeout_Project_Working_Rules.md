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

## Operating Expense Budget

* `Assumptions!B15` should pull from the `Operating Expense Budget` tab.
* The `Operating Expense Budget` tab should show:
  * assumed operating expense ratio,
  * calculated operating expense ratio,
  * selected operating expense ratio,
  * stabilized effective gross income,
  * detailed annual operating expense budget,
  * and total annual operating expense budget.
* Use the workbook-safe toggle on the operating expense sheet to choose between assumed-ratio mode and calculated-budget mode.
* Keep the assumed ratio visible even when the calculated budget is used.
* Treat the calculated operating expense budget as a detailed underwriting input that should be reviewed before it controls the return model.

## Cost Analysis Logic

* Keep the sponsor-controlled working case separate from the outside-market benchmark.
* The sponsor-controlled case reflects post-frame construction, sponsor-owned equipment, sponsor-controlled crew capacity, and disciplined finish scope.
* Outside-market rows are benchmark/stress-case rows and should not control Class B capitalization unless intentionally changed.
* The controlling sponsor-controlled total project cost should link to the controlling line-item bridge.
* The Cost Analysis case summary should clearly show:
  * Sponsor-Controlled Case linked to its line-item bridge.
  * Outside-Market Benchmark linked to outside-market subtotals.
  * Selected Total Project Cost linked to the selected underwriting case.
* Keep the controlling sponsor-controlled line-item bridge directly below the project cost case summary so the selected project cost is easy to audit.
* Use the dropdown in `Cost Analysis!C12` to choose either `Low` or `High`.
* Use the dropdown in `Cost Analysis!D15` to choose either `Sponsor-Controlled` or `Outside-Market Benchmark`.
* Only one case and one scenario should drive capitalization at a time.
* `Cost Analysis!B17` should display the selected Low value only when Low is selected.
* `Cost Analysis!C17` should display the selected High value only when High is selected.
* `Cost Analysis!D17` is the single selected project cost helper used by downstream formulas and named range `SelectedProjectCost`.
* Cost per SF metrics should calculate from the selected total project cost, not from a duplicate static row.
* Class B completion capital should be calculated as the single selected total project cost less Class A capital.

## Capitalization And Refinance Logic

* All design, development, build, and delivery capital should be raised from Class A and Class B members.
* Do not model a development loan or construction loan unless the user explicitly changes this instruction.
* Existing debt should be tracked separately from member capitalization:
  * existing first mortgage: 119,000,
  * existing private debt principal: 75,000,
  * private debt rate: 10.0% interest-only.
* Existing debt payoff at refinance should equal existing first mortgage plus private debt principal, currently 194,000.
* The only new loan currently contemplated in the workbook is the stabilization refinance/takeout loan.
* Refinance loan amount should be modeled as the lesser of:
  * 70% of stabilized value, or
  * total existing debt plus Class A and Class B capitalization.
* Net refinance proceeds should first pay existing debt, then flow through the waterfall where Class A is paid before Class B.
* Class B receives/payback is from remaining refinance, operating, and sale proceeds according to the Class B waterfall terms.

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
