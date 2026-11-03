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

- November 3, 2026 Pond header repair: `Contract_Edits` column 6 at `Gnatt Chart!Q24` was named `0` instead of `Paid`. A structured reference such as `Contract_Edits[0]` refers to that literal header, not a zero-value fallback. Rename the native table column and verify all dependent formulas across every worksheet, not just Gnatt Chart. In Pond, 222 formulas across Depends, Glasgow, Tim, Others and Gnatt Chart followed the rename; 279 source rows were retained.
- Check VBA, defined names and Power Query separately: Excel's native table rename is not proof that references inside code or text strings were updated. Do not globally replace the number zero. Preserve query logic and do not trigger an unrelated data refresh for a header-only repair. Compare recalculated source and result values in the same engine, then recheck the saved/downloaded file; old cached results alone are not a reliable baseline.

At completion of every Gnatt Chart-mode workbook update, write new reusable lessons to this file before marking the work complete. If there were no Gnatt Chart-specific lessons, say that in the final response.
