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
