# Gnatt Chart Mode Rules

Use these rules when designing, repairing, or rolling out the `Gnatt Chart` worksheet in Buy Your Home project-management spreadsheets.

The workbook sheet is currently named `Gnatt Chart`. Keep that spelling unless Wes explicitly approves a sheet rename.

## Profit Reconnect Rules

- When reconnecting Profit to `Gnatt Chart` expense totals, do not assume the approved template's source cell applies to every project. Map the `Gnatt Chart` total by label and old/source formula for each workbook. Known Pond example: Tensity used `Gnatt Chart!J5` for `Profit!B66`, but Pond's old Profit used `Gnatt Chart!I6`, where `F6` is labeled `Grand Total`; copying `J5` left the expense at zero.
- When a migrated Profit row feeds an adjacent percentage or payout row, remap and validate the paired downstream formula at the same time. Known Pond example: fixing new `Profit!B66` to the correct `Gnatt Chart` grand total was not enough; new `Profit!B68` still used the copied template formula `=IF(M13,0,+B67*SUM(B66:C66))`, while old Pond calculated Murphy's Cut from the Gantt total because old `Q12` was blank. The corrected Pond formula was `=+B67*SUM(B66:C66)`, matching the old Murphy's Cut value.

## Name And Link Validation

- For every Gnatt Chart worksheet update, scan sheet-scoped defined names for unintended external references before upload. Copied worksheets can carry source-workbook names even when the copied cells look clean.
- Verify Excel's workbook-link list and break unintended project-workbook links before uploading the cleaned workbook.

## Lesson Capture

At completion of every Gnatt Chart-mode workbook update, write new reusable lessons to this file before marking the work complete. If there were no Gnatt Chart-specific lessons, say that in the final response.
