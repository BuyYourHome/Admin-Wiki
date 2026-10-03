# Profit Mode Rules

## Carrying Labor Integration - September 30, 2026

For the authorized Carrying rollout, independently locate the carrying-expense block and add Labor immediately before Lawn when absent. Use native whole-row insertion so downstream formulas, controls and names follow. Include Labor in both monthly cost and the full carrying subtotal and use the existing mode-dependent J-column allocation pattern. Do not copy Pond's amounts or replace the entire Profit worksheet for this supporting change.

Repair return formulas referencing Start Date/End Date headings to point to the actual dated cells. Preserve the target's existing numerator and business logic. In Tensity, old L82 becomes L83 after inserting row 41; its J83 profit numerator stays J83 and the denominator becomes DAYS(J75,H75). Pond's current H75 numerator is a separate owner-specific formula, not authorization to substitute a date serial for Tensity's profit value. Test all three mode controls and retain project inputs and checkbox states.

Use these rules when designing, repairing, or rolling out the `Profit` worksheet in Buy Your Home project-management spreadsheets.

## Mode Scope

Profit mode includes the `Profit` worksheet layout, project-specific Profit inputs, mode selector controls, formula links from Profit to `Amortization`, `Trade Properties`, `Docs`, and expense worksheets, and any Profit-specific controls or helper areas.

When working in Profit mode, the template-change audit is inclusive to the `Profit` worksheet. Compare the approved template's `Profit` tab to each target workbook's `Profit` tab and propagate all intentional `Profit`-tab changes. Do not treat changes on other tabs as part of the Profit-mode rollout unless Wes explicitly expands the scope. Cross-sheet checks in Profit mode are validation checks only: confirm that `Profit` formulas, names, and outputs still connect correctly to supporting tabs such as `Amortization`, `Trade Properties`, `Docs`, `Carrying`, and `Gnatt Chart`.

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

Not every TRUE/FALSE Profit input has a visible form control. Map and verify direct boolean cells by label as well. Known Britton example: the old `Finalized` value at `Profit - Old 0703!K13` belongs in new `Profit!M13`; if it is skipped, the destination can retain a copied label such as `Min Profit:` instead of a usable TRUE/FALSE value.

## Merged Cells And Zero Values

When writing mapped Profit values through Excel automation:

- Do not treat numeric `0` as blank.
- Zero-dollar, zero-percent, and false/disabled control values are real project values and must be written when mapped.
- For merged destination cells, resolve the merge area's top-left row and column before writing.
- When a mapped source value is blank and the destination is merged, do not blindly clear the merged target if it is already blank; Excel automation may reject the clear operation. Skip the write or handle the whole merge area deliberately.
- Clear the whole merge area only when the source is truly blank or an unmapped template residue.
- Verify at least one zero-valued mapped field after save.

Known Rosebrooks failure: `Profit!B9` monthly rent was initially cleared instead of written as `0` because zero was treated like blank. That must not recur.

When old Profit detail blocks shift rows in the approved template, map by label and business purpose, not by row number. Known Cool Springs example: old `F72:J72` carried `Days Invested`, `Start Date`, and `End Date`, while old `G74:J74` carried investor-distribution headers. In the new layout, `Profit!F74:J74` is the days/start/end row, so it must receive the old start/end date values, not the old investor headers.

When an old Profit sheet stores a project value as a calculated output rather than in the matching input cell, map the value by business meaning and document the source used. Known Pond example: old `Profit - Old 0703!C15` was blank, but old `E15` held the subject-to balance output; new `Profit!C15` needed that balance input instead of a blank copied from the old input position.

For Profit formulas that reconnect to `Gnatt Chart` totals, also read `Gnatt Chart Mode Rules.md`.

Some older project workbooks have pre-redesign Profit source sheets that do not share the modern row structure. In those cases, map by visible label and business meaning instead of modern source coordinates. Known Banks example: old `B8` Rent mapped to new `C9`, old `C35` Number of Rent Payments mapped to new `B9`, old `K4` Finalized `No` mapped to new `M13=FALSE`, old private-lender text `yes` mapped to the new boolean/control field, and old realtor toggles in `B32:B34` mapped to the new `W3:W5` helper controls.

When a project has a real `Carrying` sheet, do not use the copied template carrying formulas blindly. Locate the project's own carrying summary row and map each Profit carrying category from that row by label. Known Pleasant Garden example: the actual carrying totals were on `Carrying!B47:Z47`, while copied formulas pointed to row 25 and produced errors.

When a field exists in the approved Profit template but has no equivalent in an older source sheet, do not leave copied template errors in place. Set the field to a neutral value when the business meaning is clearly absent and verify downstream totals. Known Banks example: the newer `STR Expense` row had copied `#REF!` in `Profit!B29`; Banks had no old STR expense source, so `B29` was set to `0`, which cleared downstream `J29`, `J53`, and `J54` errors.

Some older project workbooks can reject direct Excel automation writes to percentage, boolean, or text constants even when the same cells are ordinary inputs. In those cases, write mapped constants through the cell formula interface, using invariant numeric text such as `0.1`, `TRUE`, or `FALSE`, then recalculate and re-read the saved workbook. Known Pinetree example: direct writes to `Profit!C5` failed, while formula-constant writes preserved the intended 10% value.

When a sheet has no visible `#REF!` cells but the package still contains `#REF!` strings on the migrated Profit worksheet, inspect conditional formatting rules before treating the workbook as clean. Remove stale conditional-format rules only when they reference deleted helper cells and do not drive business values. Known Pinetree example: old conditional formatting on `Profit!D11` and `Profit!H12:H13` retained `#REF!` references after formulas were otherwise valid.

## Profit Formula Rules

### Tensity Rent Prototype, October 3, 2026

- Wes authorized a Tensity-only minimal-layout connection from Carrying Rent to Profit. Preserve the current monthly rent and modeled-month inputs, loan/CFD formulas, expense model and existing worksheet geometry. Do not transplant another project's rent records.
- `rentTotalCollected` feeds the existing historical rent income line in all three scenarios. `rentMonthsRented` counts distinct included, positive rental months through the current month with Scheduled, Collected or Reported Collected status; it does not count transactions or assert independently verified occupancy. In Tensity the new labeled Rent history block is Q18:W25, total is V19, months V20, and income line E9. Resolve labels/names during later approved migration, not these coordinates.
- Keep B9 as the existing total modeled rental horizon and C9 as the monthly-rent assumption. They also feed expenses, appreciation, loan lookup and MOG. Do not replace B9 with an actual-month count without tracing those dependencies independently.
- Avoid counting historical rent twice in Hold: preserve the full-horizon expense calculations and monthly cash-flow input, but remove the monthly-rent estimate for already elapsed/collected rental periods from the modeled aggregate before adding actual collections. Tensity K57 subtracts `(MAX(0,B9)-rentMonthsProjected)*C9` in Hold only. `rentMonthsProjected` is the nonnegative remainder of the existing horizon after distinct accounted-for rental months, including prepaid future months but excluding unpaid future schedules. Slow Flip keeps the existing CFD cash-flow logic and replaces the old B9*C9 historical-rent estimate with actual collected rent. Flip gains that historical income once.
- The Hold aggregate is an adjusted full-horizon cash-flow amount, not a forecast of future expenses alone. Past unpaid lease months must not remain projected as if collected; no payment is inferred merely because a due date passed. Preserve existing cost assumptions and disclose rather than silently repair unrelated modeling defects.
- Test all three scenarios, no-rent state, partial/split receipts, credits, inclusion/status changes and future prepayments. With the Tensity source's 12 months at $1,850, adding $22,200 reported historical collections increases Flip total profit by $22,200; Hold and Slow Flip overall totals stay unchanged because their former equivalent rent estimates are replaced, not added twice. Source-supported collected amounts may differ from the former estimate in other projects.

### Pond Labor Design, September 30, 2026

- Wes inserted `Labor(not in Vendor Tabs)` in the Pond Profit prototype. The targeted read-only inspection verified `B41 = +Carrying!AI25/Profit!$B$28`, Lawn moved to row 42, and `B43 = +B28*SUM(B31:B42)` includes Labor. Preserve Wes's current layout during the later approved migration; resolve the row and source subtotal by labels rather than assuming these coordinates in other projects.
- Verify both model paths: Flip's `D43 = IF(E1=1,-B43,0)` feeds its expense/net-result sums; Hold/Slow Flip's `J41` uses the same carrying-period weighting as adjacent expense rows and is included in `J54`/`J55`. Read the current formulas and period inputs independently for each project. Do not copy Pond's costs or month assumptions.
- Expected controlled-test result for a new included Labor amount X: Carrying Labor subtotal and total Profit carrying costs rise by X; Flip's net result falls by X if all other inputs remain unchanged. No live invoice test or mode toggle was performed during the initial inspection.
- The inspection found Profit `L83` using `DAYS(J74,H74)` on text headings instead of the dates below; `L85` inherited its `#VALUE!`. Wes subsequently reported correcting the date references and explicitly required the same correction in migration. Retrieve and inspect his latest saved Pond formulas before rollout; the correction has not yet been independently reverified. Include it in the approved Profit design map, resolve each target's actual Start Date and End Date value cells by label, preserve the rest of the calculation, and verify the return-rate formula and dependent averages recalculate without the date-reference error. Do not copy heading references or assume Pond's row numbers apply to every project.

When rewiring Profit mode logic to a numeric selector such as `Profit!E1`, change only formulas that actually depend on mode labels like `B1`, `C1`, or `D1`.

Do not blindly replace nearby cells such as `B2` property address, and do not treat substring matches such as `C15` as `C1`. Verify exact cell references and business meaning before editing.

For `Profit` formulas that need the five-year subject-to payoff balance in option 3 / Slow Flip, align the subject-to loan schedule to the Contract for Deed timeline before looking up the balance. Do not use subject-to period `60` directly; first find the subject-to period containing `cfdContractDate`, add `cfdFirstRateMonths`, then return `tblSubjectToLoan[Balance]` for that aligned period.

For `Profit!H15` subject-to payoff logic, treat a positive `Profit!B34` refinance proceeds value as evidence that the Subject To loan has been refinanced/paid off in the Flip scenario. In Flip mode (`Profit!E1=1`), return `0` when `B34>0`; otherwise return the negative current Subject To balance. Preserve the Hold and Slow Flip lookup behavior against the Amortization schedule.

## Cross-Sheet Reconnect Rules

When reconnecting `Profit` to a redesigned `Amortization` sheet, update both direct Amortization links and dependent fields derived from those links.

Do not stop after replacing old sheet names. Verify no outside formulas still point to an old `Amortization` sheet, and check key Profit values after save/upload.

When formulas outside a source sheet depend on summary/output cells in that source sheet, prefer workbook-level names over direct cell addresses once the business meaning is stable.

When a Profit-mode template comparison shows a formula difference that points into a supporting worksheet, do not copy the template's supporting-sheet cell address until the target supporting sheet has been checked. Keep target-specific source cells when the supporting tab layout differs but the business meaning is already correct. Known Outrigger example: Pond's `Profit!B66` used `'Gnatt Chart'!I6`, while Outrigger's `Gnatt Chart` total was still at `J5`, so the Profit-template rollout kept Outrigger's `Profit!B66 = +'Gnatt Chart'!J5` while applying Profit-tab layout changes elsewhere.

When Profit uses workbook-level names that point into `Trade Properties`, validate the name target as part of the migration. The visible Profit formula can look correct while the name itself points to `#REF!`. Known Cool Springs example: `Profit!O9` used `tradeMonthlyNetSpread`, but the name pointed to `#REF!`; it needed to point to `'Trade Properties'!$S$8`, the `Total Monthly Net Spread` output.

When validating the investor/annualized-return block, confirm formulas use the actual start/end date row, not the header labels. Known Pleasant Garden example: `Profit!L78:L82` referenced `DAYS(J73,H73)`, where row 73 contained headers; the formulas needed `DAYS(J$74,H$74)` to avoid visible `#VALUE!` errors.

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
- workbook-level names used by Profit do not point to `#REF!`
- the package has zero `xl/externalLinks` parts

For batch rollouts, run a focused open-clean validation first: reopen each saved workbook in Excel and check the changed Profit cells, key cross-sheet formulas, workbook-link count, and package external-link parts. Avoid starting with a full cell-by-cell scan of every used Profit cell across many workbooks; that can hang Excel automation and obscure which workbook is at issue. Run deeper formula-error scans only after the focused validation identifies a problem or when the workbook has a known risk area.

## Lesson Capture

At completion of every Profit-mode workbook update, write new reusable lessons to this file before marking the work complete. If there were no new Profit-specific lessons, say that in the final response.
