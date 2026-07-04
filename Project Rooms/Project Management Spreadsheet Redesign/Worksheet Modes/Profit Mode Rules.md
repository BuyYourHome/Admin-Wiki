# Profit Mode Rules

Use these rules when designing, repairing, or rolling out the `Profit` worksheet in Buy Your Home project-management spreadsheets.

## Mode Scope

Profit mode includes the `Profit` worksheet layout, project-specific Profit inputs, mode selector controls, formula links from Profit to `Amortization`, `Trade Properties`, `Docs`, and expense worksheets, and any Profit-specific controls or helper areas.

Before touching a project workbook in Profit mode:

1. Confirm the exact target workbook and project with Wes.
2. Confirm the workbook is closed.
3. Create a rollback copy.
4. Identify the source Profit sheet for that project, usually an archived sheet such as `Profit - Old 0703`.
5. Build a full value map for that project only.
6. Verify mapped values against that same project's old/source Profit sheet after saving.

Do not assume another project's Profit map applies, even if the visible layout looks similar.

## Source And Template Roles

- Treat the approved Tensity Profit sheet as the design source for layout, formulas, formatting, controls, and intended behavior.
- Treat each target project's old/source Profit sheet as the source for project-specific values.
- Treat copied template values as untrusted until each value is proven to come from the target project's source or from an explicitly approved standard default.

## Full Value Map Requirement

For every project, build a worksheet-specific Profit map before setting values.

The map must identify:

- mode selector value and mode-control state
- address fields
- CMA and sale-price inputs
- rent and cash-flow inputs
- subject-to loan balances and rates
- refinance inputs
- partner/seller payout inputs
- carrying-cost and expense-driving inputs
- private-lender controls and values
- realtor-fee controls and values
- closing-cost detail rows and totals
- charitable contribution, capital gain, and investor/partner inputs
- any project-specific fields that exist in the old/source Profit sheet but not in the template

After save, verify the important mapped values against the same workbook's old/source Profit sheet, not against Tensity or another project.

## Mode Selector Controls

The Profit mode selector uses `Profit!E1`:

- `1` = Flip
- `2` = Hold
- `3` = Slow Flip

`Profit!B1:D1` should remain formula labels driven by `E1`, such as:

- `B1`: `=IF(E1=1,"Flip","")`
- `C1`: `=IF(E1=2,"Hold","")`
- `D1`: `=IF(E1=3,"Slow Flip","")`

For mode selector option buttons such as the `Profit!B1:D1` Flip/Hold/Slow Flip group, verify the full option-button set, not just the linked mode value. The target sheet must have one option button for each approved choice, each linked to `Profit!E1`, and the selected button must match the migrated mode.

A correct `E1` value with missing, unlinked, or wrong selected buttons is not a successful Profit migration.

When recreating form-control option buttons, preserve creation order. Excel assigns the linked-cell numeric value by option-button group order, not by the cell the button visually covers. If one button is missing, do not simply append it after the existing controls; rebuild or copy the whole `B1:D1` group so `B1=1`, `C1=2`, and `D1=3`.

## Checkbox And Control Values

Treat in-cell checkboxes, option buttons, and other controls as part of the Profit design, not as ordinary text values.

When an old workbook uses text such as `yes`, `no`, `1`, or `0` for a field that is a checkbox or option-control field in the approved template, map the old value into the control's TRUE/FALSE or selected-state value and preserve or recreate the approved control display.

Do not leave visible text such as `yes` in a checkbox cell.

Known example:

- In Tensity, `Profit!C43` is an in-cell checkbox-style field with visible blank display and underlying value `TRUE` or `FALSE`.
- If an old Profit sheet has `yes` in the corresponding private-lender active field, map it to checked/`TRUE`, not literal text `yes`.

After save, verify both the underlying linked/value cell and the visible control behavior or display.

When writing form-control checkboxes, set both the linked helper cell and the control state, then re-read the helper cells after saving. Excel can overwrite helper cells from control state during save or recalculation if the sequencing is wrong.

If a checkbox disables a related amount, confirm whether formulas still include the amount independently. Known example: if `Profit!C43` is `FALSE`, `Profit!B44` must not retain a copied private-lender debt amount if downstream formulas such as total debt still include `B44`.

## Merged Cells And Zero Values

When writing mapped Profit values through Excel automation:

- Do not treat numeric `0` as blank.
- Zero-dollar, zero-percent, and false/disabled control values are real project values and must be written when mapped.
- For merged destination cells, resolve the merge area's top-left row and column before writing.
- Clear the whole merge area only when the source is truly blank or an unmapped template residue.
- Verify at least one zero-valued mapped field after save.

Known Rosebrooks failure: `Profit!B9` monthly rent was initially cleared instead of written as `0` because zero was treated like blank. That must not recur.

When old Profit detail blocks shift rows in the approved template, map by label and business purpose, not by row number. Known Cool Springs example: old `F72:J72` carried `Days Invested`, `Start Date`, and `End Date`, while old `G74:J74` carried investor-distribution headers. In the new layout, `Profit!F74:J74` is the days/start/end row, so it must receive the old start/end date values, not the old investor headers.

## Profit Formula Rules

When rewiring Profit mode logic to a numeric selector such as `Profit!E1`, change only formulas that actually depend on mode labels like `B1`, `C1`, or `D1`.

Do not blindly replace nearby cells such as `B2` property address, and do not treat substring matches such as `C15` as `C1`. Verify exact cell references and business meaning before editing.

For `Profit` formulas that need the five-year subject-to payoff balance in option 3 / Slow Flip, align the subject-to loan schedule to the Contract for Deed timeline before looking up the balance. Do not use subject-to period `60` directly; first find the subject-to period containing `cfdContractDate`, add `cfdFirstRateMonths`, then return `tblSubjectToLoan[Balance]` for that aligned period.

## Cross-Sheet Reconnect Rules

When reconnecting `Profit` to a redesigned `Amortization` sheet, update both direct Amortization links and dependent fields derived from those links.

Do not stop after replacing old sheet names. Verify no outside formulas still point to an old `Amortization` sheet, and check key Profit values after save/upload.

When formulas outside a source sheet depend on summary/output cells in that source sheet, prefer workbook-level names over direct cell addresses once the business meaning is stable.

## Required Profit Validation

Before marking a Profit migration complete, verify:

- workbook opens cleanly in Excel
- full worksheet list is unchanged except intended archived/replacement sheets
- `Profit!B1:D1` formulas are intact
- mode option buttons exist as a complete group and are linked to `Profit!E1`
- `Profit!E1` matches the project mode
- checkbox/control fields display and calculate like the approved template
- key mapped values match the project source Profit sheet
- zero-valued mapped fields remain zero, not blank
- closing-cost totals match the old/source detail where applicable
- workbook links count is zero
- workbook-level and sheet-scoped names do not point to external workbooks
- the package has zero `xl/externalLinks` parts

## Lesson Capture

At completion of every Profit-mode workbook update, write new reusable lessons to this file before marking the work complete. If there were no new Profit-specific lessons, say that in the final response.
