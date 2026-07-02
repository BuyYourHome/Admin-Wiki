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
* Prefer Excel Table structured references for model areas where formulas refer to columns on another sheet.
* Active structured tables:
  * `AnnualModelTable` on the `Annual Model` tab.
  * `WaterfallTable` on the `Waterfall` tab.
  * `ReturnsTable` under the Waterfall table on the `Waterfall` tab.
* The old standalone `Returns` sheet is hidden and retained only as a legacy reference.
* `ReturnsTable[Total Profit]` should sum the annual cash-flow columns from Year 0 through Year 10.
* `ReturnsTable` should not include a `Net Profit` column unless specifically requested.
* In `ReturnsTable`, keep the ending columns after `Year 10` in this order: `Total Profit`, `Total Distributions`, `Equity Multiple`, `ROI %`.
* `Total Profit` should equal the sum of Year 0 through Year 10 cash flows; `Total Distributions` should equal Total Profit plus Capital / Basis.
* `ReturnsTable` should include a `Management` row that calculates management income dynamically as `ManagementFeeRate * AnnualModelTable[Effective Gross Income]` by year.
* Avoid formulas like `Waterfall!S6` when the intent is to refer to a Waterfall column. Use structured references such as `WaterfallTable[Sponsor Total Dist.]` with `INDEX/MATCH` by year.
* Preserve the user's formatted Waterfall layout. Do not broad auto-fit or rewrite Waterfall headers unless specifically requested.
* Do not add an intermediate Waterfall column for cash remaining after Class A priority payments. Calculate Class B capital return and residual distributions directly from cash available less Class A preferred return, Class A capital return, and Class B capital return.
* Waterfall capital balance columns should carry forward directly:
  * `A Capital Balance` should equal prior-year `A Capital Balance` less prior-year `A Capital Returned`.
  * `B Capital Balance` should equal prior-year `B Capital Balance` less prior-year `B Capital Returned`.
* Do not reintroduce separate `A End Capital` or `B End Capital` columns unless specifically requested.

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
* Keep completed-property insurance in the operating expense budget. It should be separate from construction-period insurance.
* Property management / administration should be calculated as 6.00% of stabilized effective gross income, not gross potential rent.

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
* The sponsor property payment should be itemized in the sponsor-controlled line-item bridge.
* The sponsor property payment should use the `SponsorPropertyPayment` named range, currently tied to Sponsor property payment / basis.
* Construction-period insurance should be itemized separately in the sponsor-controlled line-item bridge.

## Capitalization And Refinance Logic

* All design, development, build, and delivery capital should be raised from Class A and Class B members.
* Do not model a development loan or construction loan unless the user explicitly changes this instruction.
* Existing debt should be tracked separately from member capitalization:
  * existing first mortgage: 119,000,
  * existing first mortgage rate: 3.25%,
  * existing private debt principal: 75,000,
  * private debt rate: 10.0% interest-only.
* Existing debt payoff at refinance should equal existing first mortgage plus private debt principal, currently 194,000.
* Existing debt service before refinance should be modeled separately from operating expenses.
* First mortgage debt service should exclude escrow, property taxes, and insurance because property taxes and insurance are already in operating expenses.
* First mortgage debt service should use the actual principal-and-interest payment of 526 per month, or 6,312 per year, excluding escrow.
* Private debt service should be modeled as interest-only at 10.0%, currently 7,500 per year.
* Total existing annual debt service before refinance is currently 13,812.
* The only new loan currently contemplated in the workbook is the stabilization refinance/takeout loan.
* Refinance loan amount should be modeled as the lesser of:
  * 70% of stabilized value, or
  * total existing debt plus Class A and Class B capitalization.
* Net refinance proceeds should first pay existing debt, then flow through the waterfall where Class A is paid before Class B.
* The sponsor property payment is a Year 0 Sponsor distribution and should not be treated as Class A capital return, Class B capital return, or Sponsor residual.
* Waterfall should keep Sponsor property payment in a separate Sponsor column from Sponsor residual.
* Class A should receive accrued preferred return and return of Class A capital before Class B capital return.
* Class B should receive return of Class B capital before residual splits when `ClassBReturnPriority` is active.
* After capital return priorities are satisfied, residual distributions should use an adjustable Sponsor/Class pool split.
* Sponsor residual share should be editable in the workbook; current default is 60.00%.
* Class A and Class B should split the remaining non-sponsor residual pool in proportion to their contributed capital.
* Current residual-share formulas:
  * Sponsor: editable Sponsor residual share,
  * Class A: `(1 - SponsorResidualShare) * Class A capital / (Class A capital + Class B capital)`,
  * Class B: `(1 - SponsorResidualShare) * Class B capital / (Class A capital + Class B capital)`.

## Annual Model Cash Roll-Forward

* The Annual Model should not treat annual cash as isolated.
* It should show current-year cash before refinance/sale, net refinance/sale proceeds, cash available before distributions, waterfall distributions, ending cash balance, loan balance, and property/refinance value.
* Cash available before distributions should include prior-year ending cash.
* Waterfall distributions should be pulled from the Waterfall tab.
* Ending cash balance should equal cash available before distributions less Waterfall distributions, floored at zero.
* If future reserve assumptions are added, retained cash should carry forward through the ending cash balance.

## Rent Scenario Timing

* Keep the low, medium, and high rent cases on the Assumptions tab.
* Show rent scenarios left to right so prices increase from low to medium to high.
* Each rent case should have an editable effective year.
* Stabilized monthly gross rent should use the average of the low, medium, and high monthly gross rent cases.
* The Annual Model should use the rent case with the latest effective year that is less than or equal to the model year.
* Current effective years:
  * Low rent: Year 1,
  * Medium rent: Year 2,
  * High rent: Year 4.
* Under the current schedule, the low rent scenario ends after Year 1.

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
