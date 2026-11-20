# Credit Cards Table and Rollover Payoff

## Scope and Source

- Authorized by Wes on 2026-11-19: convert Cards columns A:AE into a table and place a final payoff-date formula to its right, using highest-interest-first payment rollover.
- Wes confirmed the workbook saved and closed and moved the existing summaries to the right himself. Preserve those summaries in their new locations.
- Source: [Credit Cards Sheet.xlsx in Teams](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BC92BCFBD-D418-473F-821A-4725718FBE42%7D&action=default), saved 11:27:30 AM Eastern.
- Rollback: `Property/Project Template/Rollback Copies/Credit Cards Sheet - before Cards table and rollover 2026-11-19 1127 ET.xlsx`. Cloud hash verified against the source.
- Published and freshly downloaded/verified at 11:46:57 AM Eastern.
- Published SHA256: `2EBFE006B21DE6317D10DFFC028C1E21B37F6C3EB7783B7712371F73CAF19010`.

## Design

- Native Excel table `tblCards`: `Cards!A1:AE56`. Includes the existing final partial row; no whole-column or summary-row table expansion.
- Preserve existing values, formulas, colors, widths, merged areas, workbook links, and the relocated summaries. Native table creation turns the numeric percentage headers into equivalent text headers `35%` and `50%`. Their existing dependent formulas retain their results.
- `Cards!AL1` links to `Payoff Plan!B2`. The new summary occupies the previously unused `AH1:AM8` area.
- A separate formula-based Payoff Plan supports 100 table records and 600 months. Exceeding capacity or horizon produces a warning, not a false date.
- All positive balances in the table participate, including listed credit lines and home loans. Blank balances are excluded and their count is displayed; this is an estimate for recorded balances, not proof those accounts owe nothing.
- Maintain the initial combined payment budget. Each month, accrue each account's APR/12 interest, pay its existing regular payment capped at its amount due, then allocate unused payment funds by descending APR. Any remaining funds continue to the next account in the same month. Ties use source table order.
- Assumptions: no new charges or fees, unchanged rates, fixed total monthly payment, monthly end-of-period payments. Dates run from TODAY(); they are estimates, not actual contractual payment dates or lender payoff quotes. No macros added.
- No invented APR or payment values. Missing required inputs on positive balances block the final date. No payment budget and all-zero balances have explicit outcomes.

## Result and Verification

- Recorded positive balances: $542,617.41.
- Current monthly budget: $21,914.058333333327, displayed as $21,914.06.
- Final payoff: 28 monthly payments, March 19, 2029, using November 19, 2026 as the estimate date.
- Two blank-balance accounts excluded; no missing APR/payment inputs for the positive balances in this source.
- Native Excel opened normally; automatic calculation enabled in the saved workbook.
- Independent month-by-month simulation reconciled all 28 monthly interest, payment, and ending-balance totals within $0.00001.
- Passed native Excel tests: table sorting; adding a new table record; zero-interest debt; single interest-bearing debt; partial final payments rolling within the same month; equal-rate ties; zero base payment with eventual rollover; missing APR; zero payment budget; no debt; and the 100-record capacity guard.
- Full native recalculation measured approximately 0.8-1.1 seconds in the isolated test instance.
- Compared all pre-existing worksheet values and formulas by sheet name, expanding shared formulas through a read-only parser. No changes except the required equivalent percentage-header text conversion. All pre-existing cached results and merged areas preserved.
- All operational tests used a disposable, isolated Excel instance. Test transactions and input changes were discarded. No linked project workbook was updated.

## Reusable Lessons

- Re-fetch the latest Teams save after Wes rearranges a sheet. The prior bottom summaries had moved; old coordinates were not authoritative.
- Do not estimate pooled payoff by taking the maximum individual payoff date or using an average APR. Allocate the fixed monthly budget account by account and reconcile monthly results independently.
- Show omitted/unknown balances and missing inputs. Do not present an unconditional all-debt payoff date when some balances are blank.
- Test structured-reference dependencies after table sorting and row addition, not only on the initial arrangement.
- Native table headers are text. Verify formulas using numeric percentage headers still evaluate equivalently after conversion.
- The general spreadsheet exporter could not safely round-trip this workbook's existing hyperlinks. An assembled candidate also failed normal native opening and was rejected. Use native Excel for final table creation and integration of the authored formulas when existing features cannot be preserved through export; never publish a candidate requiring repair.
- Shared-formula serialization and worksheet file numbering can change on native save. Compare expanded formulas by worksheet name, not raw `<f>` text or fixed sheet XML file numbers.
- Large previews must not replace native calculation tests. Use a lightweight render of native-saved summary values and formatting if importing the full calculation model stalls.

No rollout to project workbooks was performed. No Git push was authorized for this change.

## Summary Column References - 2026-11-19

- Wes authorized converting `Cards!AV8:BA24` summary ranges to table-column references and confirmed the workbook saved and closed.
- Fresh Teams baseline: 1:12:55 PM Eastern, eTag ending `5446`. Wes's latest layout has `tblCards` at `A2:AE57`; preserve that layout rather than the earlier table position above.
- Replaced 60 SUMIF formulas across rows 8-14, 18-20, 22, and 24. Match `tblCards[Name]` against the existing `$AO` row label, and sum the corresponding `Current Balance`, `Credit Limit`, `Available Credit`, `Interest Paid`, or `Monthly Payment` column.
- Example: `=SUMIF(tblCards[Name],$AO8,tblCards[Current Balance])`.
- Preserved AZ utilization formulas and the existing `BA10` subtraction of `U43`. Preserved all other cell contents/formulas, merged areas, styles, table structure, calculation settings, and external links. No linked project workbook was edited.
- The old fixed ranges omitted the final First Citizens loan row. `AV22` and `AW22` now include $14,134.88; `AY22` includes $73.03 monthly interest; `AZ22` now calculates 100% instead of division by zero.
- Passed native Excel checks for all 60 formula results, the first table data row, an appended table row, and reopening the final saved candidate. All temporary test edits were discarded. Recalculated dependent totals without changing their formulas; the existing `Private Lenders!G31` timestamp also advanced during recalculation.
- Rollback: `Property/Project Template/Rollback Copies/Credit Cards Sheet - before summary column references 2026-11-19 1312 ET.xlsx`. Its cloud hash matches the fetched baseline.
- Rechecked unchanged Teams eTag immediately before publication. Published at 1:25:33 PM Eastern and verified a fresh Teams download against the tested candidate.
- Published SHA256: `0073DBFB17BAE54C00E33511BFD62477DCD35B949C26BE838F5BE8C2A1EE1D15`.

### Separate Issue Not Changed

`AV29 = SUM(AV18:AV28)` includes the individual lines of credit and their subtotal at AV27, plus Personal Home at AV24 and its repeated summary at AV28. This double-counting predates the requested correction. Review row 29 separately; do not treat its recalculated balance as a validated unique-debt total. Its formula was deliberately left unchanged, as were the analogous row-29 formulas.

### Summary Migration Lesson

After converting a source range into a table, audit summaries outside that table for full-column and fixed-body references. Map each source by its actual header and preserve criteria, adjustments, and ratios. Test first, last, and newly appended table rows: matching an old total is insufficient when that old total omitted a valid row. Keep unrelated aggregation defects separate from the approved reference conversion.

## Property Cash Flow Conditional Fill - 2026-11-20

- Wes requested formatting only on `Projects!C24` and confirmed the workbook saved and closed. Fresh Teams source: 8:42:37 AM Eastern, eTag ending `5470`.
- Negative values use the same `#FF0000` background as adjacent debt-payment cells. Positive values use `#000000`. Zero retains the existing black background. Existing white text and `#,##0` number format remain unchanged.
- Preserved `=+C8-C7` and all other formulas, cached values, tables, external links, calculation settings, and workbook features. No financial-model change or project-workbook edit was included.
- Authored the two conditional-format rules in an isolated spreadsheet model. Integrated only their differential fills and the C24 rules into the original workbook package because full re-export previously could not preserve this workbook's links reliably. Verified that reversing those exact additions restores both XML trees and that every other package part is byte-identical to the source.
- Compared before/after and positive-state previews. The final candidate opened normally in hidden native Excel; negative, positive, and zero display tests passed with white text. Temporary test values were discarded without saving.
- Rollback: `Property/Project Template/Rollback Copies/Credit Cards Sheet - before C24 conditional fill 2026-11-20.xlsx`. Verified its cloud hash against the source and rechecked the live eTag before replacement.
- Published to the same Teams file at 8:51:32 AM Eastern and verified the fresh download against the tested candidate.
- Lesson: for a single-cell conditional-format change, match the actual neighboring fill and preserve the existing font/number format. Test both signs and zero in native Excel. Avoid recalculating or rewriting unrelated financial data just to change a background color.
- No Git push authorized. Unrelated Dashboard changes remain untouched.

## Annual Liquidation Funding - 2026-11-20

- Historical initial implementation: the limited-sale-pool runway in this section was superseded by the Portfolio Resource Split correction below. The final overall runway uses the entire combined resource estimate, not only planned annual liquidation.
- Wes added row 24, requested annual cash needed in E24, whole-property surplus in C24, and a property-count description in F24. He approved using C24 plus E24 instead of E23 for runway and confirmed the workbook saved and closed.
- Fresh Teams source: 9:02:10 AM Eastern, eTag ending `5475`. Existing property-cash-flow conditional formatting had shifted to C25 with Wes's row insertion; preserved it there.
- Only four cells changed: `Projects!E24`, `C24`, `F24`, and `D38`. Existing profit/reserve totals, expense formulas, table structures, links, styles, merged cells, and calculation settings were preserved. No project workbook was edited.
- E24 annualizes the current net monthly outflow in B38: `=MAX(0,-$B$38*12)`. It is a current annual run-rate estimate, not a forecast of individual closing dates or a declining-debt annual schedule.
- C24 uses the whole number of properties required at the current C16 average expected profit, less E24. F24 displays that whole count and explicitly identifies the average-profit basis. Missing/nonpositive average profit is flagged instead of inventing sale proceeds.
- Current results: E24 $344,193.79; C24 $156,149.21; F24 three properties; combined modeled funding $500,343.01. Existing $28,400 cash reserves and the E23 portfolio total remain unchanged and are not included in this new funding pool.
- D38 now estimates depletion of C24 plus E24, using current ongoing net cash costs and the existing Payoff Plan debt payments. It accounts for depletion before payoff, during the partial final payment month, or after debt payoff; debt payments stop at payoff and ongoing business/personal/property cash costs continue. Current result: 1.453666555 years, approximately 17.44 months (existing one-decimal display shows 1.5 years).
- Verified monthly debt budget $20,942.535 matches the three central debt-payment categories; ongoing net monthly costs are $7,740.281248. A future payment-budget mismatch, invalid Payoff Plan, invalid average, no current cash shortfall, and no debt have explicit handling.
- This is a conditional funding estimate based on realizing three average-profit properties. It is not a validated net-liquidation valuation, proof of cash availability before closing, the entire portfolio's runway, or a resolution of the separate profit/equity/card-principal reconciliation question. Do not add these proceeds to a portfolio total that already includes the same properties.
- Authored formulas in an isolated spreadsheet model, integrated through hidden native Excel, and tested against an independent monthly cash-depletion simulation. Eleven native scenarios passed: current case, before payoff, final payoff month, after payoff, zero ongoing cost, ongoing income, invalid average, no shortfall, mismatched debt payments, invalid payoff, and no debt. Disposable test edits were discarded.
- Reopened the final package read-only in native Excel and recalculated the four cells successfully. Transferred only the four calculated cell formula/cache nodes to the source package; all other package parts are byte-identical, and all other cells and worksheet settings are unchanged. Reviewed before/after previews.
- Rollback: `Property/Project Template/Rollback Copies/Credit Cards Sheet - before liquidation funding 2026-11-20 0902 ET.xlsx`. Its cloud hash matches the baseline. Confirmed the live source eTag remained unchanged immediately before publishing.
- Published to the same Teams item at 9:12:57 AM Eastern. Fresh download matches tested SHA256 `55B0EE744ABEBE1C6548DCCEA06A770F388E8C73F882FBF3447190833507F8FC`.

### Liquidation Formula Lessons

- Find the current layout after user row changes; preserve merged-cell anchors and existing conditional formatting rather than applying stale coordinates.
- Keep annual funding and whole-property surplus outside the monthly-expense sum to avoid circular references and double-counting the funding.
- Do not subtract all future scheduled debt payments upfront from a short-lived funding pool. Model cash depletion through payoff and test the final partial payment month independently.
- Label average-profit-based property counts as estimates. Expected profit is not automatically net sale cash, and a formula test cannot certify the accounting basis or closing timing.
- For a narrow formula edit, native calculation can be combined with exact-cell package integration to retain unrelated external-link caches and timestamps. Reopen the final integrated package, not just its native intermediate, before publishing.
- No Git push authorized. Unrelated Dashboard changes remain untouched.

## Portfolio Resource Split Correction - 2026-11-20

- Wes clarified that overall runway must reflect all modeled portfolio resources. Planned liquidation is a transfer out of the remaining resource total, not new value and not the entire runway funding pool. He added the row-23 description, authorized the proposed split, and confirmed the workbook saved and closed.
- Fresh Teams source: 9:23:12 AM Eastern, eTag ending `5479`. Preserved his exact `F23` description and all row-24 formulas.
- Changed only `Projects!E23` and `D38`. E23 is now `=SUM(C22:D23)-SUM(C24,E24)`. D38 uses `SUM($E$23:$E$24,$C$24)` as funding, preserving the payoff-aware debt logic. Its no-shortfall test now reads B38 directly so a zero planned liquidation allocation does not suppress the portfolio runway.
- Reconciliation: E23 $1,195,867.02 + E24 $344,193.79 + C24 $156,149.21 = $1,696,210.03 combined resources. The full modeled liquidation amount is removed from E23, including surplus. Existing $28,400 reserves are unchanged and counted once.
- Runway is 11.8772609344 years, displayed as 11.9 under the existing format. This restores the portfolio scope, not a certification of true net sale proceeds, sale timing, or the separate profit/equity/debt accounting assumptions.
- Eleven native checks passed, including independent monthly depletion before/during/after payoff, ongoing cost/income scenarios, mismatched debt-payment warning, no-shortfall handling, and three different liquidation allocations (including zero). Changing only the allocation leaves combined resources and runway invariant.
- Final integrated workbook reopened and recalculated normally in hidden read-only Excel. Verified only the two formula/cache cells changed; all other package parts, sheet cells/settings, styles, links, names, and the new description are preserved. Compared before/after previews.
- Rollback: `Property/Project Template/Rollback Copies/Credit Cards Sheet - before portfolio runway split 2026-11-20 0923 ET.xlsx`. Its cloud hash matches the source. Rechecked unchanged live eTag before publication.
- Published at 9:28:37 AM Eastern. Fresh Teams download matches the tested candidate SHA256 `2D88A3A01CBA6704F7DA7ECFB20A8C914C7D58D69A16D682F58A8073509D8B93`.
- Lesson: distinguish whole-portfolio runway from the duration of a planned-sale funding pool before reconnecting inputs. A presentation split must reconcile to the original resource base. Test allocation invariance explicitly; include whole-property surplus on both sides of the transfer and keep annual sales planning out of the monthly expense sum.
- No Git push authorized. No other project room or shared Admin rule changed.
