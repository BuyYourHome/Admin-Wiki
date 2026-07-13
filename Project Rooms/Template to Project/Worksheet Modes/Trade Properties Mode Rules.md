# Trade Properties Mode Rules

Use these rules when designing, repairing, or rolling out the `Trade Properties` worksheet in Buy Your Home project-management spreadsheets.

If Wes says "Trader Properties," treat that as this same `Trade Properties` worksheet unless he explicitly names a different sheet.

## Formula And Name Rules

- When formulas outside a source sheet depend on summary/document-output cells in that source sheet, prefer workbook-level names over direct cell addresses once the business meaning is stable. In the Tensity trade-property cleanup, formulas were changed from direct `Trade Properties` cell references to names such as `tradeNetCreditIncluded`, `tradeMonthlyGrossSpread`, `tradePropertyListForDocs`, and `tradePropertyConditionsForDocs`, then verified by scanning for zero remaining direct `Trade Properties` formula references.
- When copying `Trade Properties` from the approved template, preserve the old target sheet for rollback, but rebuild every trade-related workbook name after the copy. Excel may redirect existing names such as `tradeNetCreditIncluded`, `tradePropertyListForDocs`, and `tradePropertyConditionsForDocs` to the renamed old sheet when the active sheet is replaced. Before upload, verify the names point to the active `Trade Properties` sheet, scan for formulas still pointing to the preserved old sheet, and confirm the package has zero `xl/externalLinks` parts.

## Expense And Cash-Flow Rules

- For Trade Properties cash-flow analysis, itemize recurring property-level expenses in the support/detail table and aggregate them in the top contract-facing table. In the Tensity pattern, the detail table keeps `Lot Rent / Mo` plus user-input columns for `Property Tax / Mo` and `Insurance / Mo`; the top table shows one `Monthly Expenses` rollup, and all spread, annual spread, yield, and cap-based value formulas use net spread after those expenses.

## Worksheet Replacement Validation

- Before uploading any workbook after a Trade Properties worksheet copy, replacement, or rollback rebuild, compare the full before-and-after worksheet list against the rollback/source workbook. The only allowed sheet-list changes are the exact intended ones, such as adding a preserved `Trade Properties - Old 0703` sheet and replacing the active `Trade Properties` sheet. If any unrelated sheet is missing, renamed, hidden unexpectedly, or displaced, stop and restore from rollback.
- Converting a workbook to `.xlsm` does not by itself make external whole-worksheet copy operations safe. In the July 2026 Trade Properties rollout, the same Excel `Worksheet.Copy` pattern that removed adjacent sheets in `.xlsx` files also failed validation after those files were converted to `.xlsm`. For Trade Properties and similar non-table sheets, prefer keeping the target sheet in place, archiving the old target sheet separately, and copying the approved template's cell formulas, formatting, row heights, column widths, and shapes into the existing target sheet. Accept the result only after the full sheet-list comparison, workbook-link check, defined-name check, and package external-link check pass.

## Lesson Capture

At completion of every Trade Properties-mode workbook update, write new reusable lessons to this file before marking the work complete. If there were no Trade Properties-specific lessons, say that in the final response.
