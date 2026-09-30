# Pond Carrying Repair - 2026-09-30

Owner: Template to Project. Scope: approved repair of grid-only Carrying expenses in Pond. No other project was migrated.

## Source and Delivery

- Live workbook: [Pond in Teams](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D).
- Latest baseline: Teams save at `2026-09-30T13:31:56Z`; compared with the initial download, with no cell-value/formula differences. Used the newer package to preserve its saved state.
- Rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-carrying-repair-20260930-133156.xlsm`.
- Teams replacement downloaded and verified at approximately `2026-09-30T13:36Z`.
- Verified SHA-256: `57736216028206E6B2DA2BE57DEC7AD45774F3181B954427BD23231499740094`.
- Additional record: `Property/Project Template/Validation Evidence/Pond Carrying Repair and Migration Lesson - 2026-09-30.md`. Its note about pending canonical documentation describes the earlier Git blocker; this canonical log and [[Carrying Mode Rules]] now record the repair and lesson.

## Project-Specific Mapping

| Source in Carrying | Category | Date | Amount |
| --- | --- | --- | ---: |
| A14/B14 | Duke Electric | 2026-06-09 | 20.68 |
| A15/B15 | Duke Electric | 2026-07-10 | 109.49 |
| P15/Q15 | Water | 2026-06-15 | 22.52 |
| P16/Q16 | Water | 2026-07-14 | 65.77 |
| S4/T4 | Natural Gas | 2025-12-05 | 12.41 |
| S5/T5 | Natural Gas | 2026-01-07 | 14.24 |
| S6/T6 | Natural Gas | 2026-02-05 | 27.62 |
| S7/T7 | Natural Gas | 2026-03-05 | 333.34 |
| S8/T8 | Natural Gas | 2026-04-06 | 195.04 |
| S9/T9 | Natural Gas | 2026-05-05 | 64.84 |
| S10/T10 | Natural Gas | 2026-06-04 | 25.05 |
| S11/T11 | Natural Gas | 2026-07-07 | 12.84 |
| S12/T12 | Natural Gas | 2026-08-05 | 12.84 |

- Added these 13 existing grid bills to `tblCarryingExpenses`, with original grid-cell references in its Notes field. No matching category/date/amount duplicates were found.
- Replaced ten $1 Natural Gas placeholders with the nine actual gas bills after Wes directed that table rows reflect the bills replacing the grid entries. Did not count both sets.
- Preserved the corrected date from `A10` in table cell `AN9`: February 9, 2026 rather than February 9, 2025, for the uniquely matched $46.16 electric bill.
- Restored calculated date/amount displays in `A4:B24`, `P4:Q24`, and `S4:T24`, reading typed dates directly and sorting ascending. Other date blocks were not changed.
- Changed `Docs!E39` from `=Carrying!E5` to `=Profit!C9`, yielding $1,825, as directed by Wes. This is a Pond-specific mapping; other projects require independent label-based verification.
- Final table: `AL2:AV195`, with 193 data records. All other source records, including dated zero/blank schedules, were preserved.

## Reconciled Outputs

| Output | Before | After |
| --- | ---: | ---: |
| Electric | 608.30 | 738.47 |
| Water | 401.79 | 490.08 |
| Natural Gas | 10.00 | 698.22 |
| Profit carrying cost, B42 | 32,863.57 | 33,770.25 |

## Verification and Remaining Work

- Every recovered bill appears exactly once in its calculated grid, with the source date and amount. Grid, table, category, and Profit totals reconcile.
- Final workbook reopened normally in a hidden, read-only Excel session. An unsaved $1 increase to an electric table amount increased its subtotal by $1; restoring the input restored the subtotal. The test was discarded without saving.
- Automatic calculation is explicitly saved. Saved category caches were checked as well as formulas and live recalculation.
- Original formulas outside approved cells, cell styles, defined names, VBA binary, drawings, controls, rich-data parts, and external-link parts were preserved. Unrelated native-save churn was removed and the final package revalidated.
- The exact Teams replacement matched the validated file by SHA-256. Rollback copies remain in Teams; superseded local workbook copies were removed.
- Other date blocks, property-tax escrow assumptions, and unrelated pre-existing worksheet errors remain for discussion. No complete Carrying redesign or migration to other projects was approved by this repair.

## Lesson

The visible grid may contain newer actual bills and corrected dates that are absent from its source table. Reconcile these records before restoring formulas; otherwise a seemingly successful redesign can erase project data or leave costs out of Profit. Apply this check independently on every future authorized Carrying migration. See [[Carrying Mode Rules]].

## Mortgage Date Follow-Up

Completed September 30, 2026, approximately 13:56 UTC, after Wes approved the mortgage-payment date fix and confirmed Pond was closed.

- Fresh Teams baseline: saved at `2026-09-30T13:47:30Z`.
- Rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-mortgage-dates-20260930-1352.xlsm`.
- Changed only the 42 display formulas and their saved results in `Carrying!D4:E24`. Replaced `DATEVALUE(tblCarryingExpenses[Date])` with the typed table date column in both halves of the paired display. All category selection, anchored counters, and amount conversion logic were retained.
- All 19 included mortgage records now display chronologically with their corresponding amounts. Six records have nonzero payments; zero/blank schedule records and the two records dated October 10, 2025 remain intact.
- No table records or source payment values were changed. Mortgage subtotal remains $14,421.92; Profit carrying costs remain $33,770.25; current Docs output remains $1,825.
- The archived `Docs - Old 0704!B62` still references positional cell `Carrying!E5`, but its current condition yields zero. No archived formula was changed. Current `Docs!E39` uses `Profit!C9` and is independent of the reordered mortgage grid.
- Only the Carrying worksheet package part changed. All other package parts, tables, names, macros, controls, and styles were byte-identical; all cell styles and formulas outside the approved display cells were verified unchanged.
- Hidden, read-only Excel opened the workbook normally in Automatic calculation. All 19 displayed pairs matched the table after recalculation. A temporary unsaved date change updated its display with the correct payment still paired; the test was restored and discarded.
- Live Teams source was unchanged immediately before replacement. The downloaded replacement matched the validated file at SHA-256 `7624B4CC1DD33A29970468721894B70E18E6DB8C44B28158E277D8515C44EA01`.
- This supersedes the earlier open mortgage-date issue only. Date formulas in other unrepaired category blocks, escrow assumptions, and further design changes remain for review. No other project was updated.

Lesson: repair both date and amount formulas when their shared sort array contains the defect. Validate pairings, not only total amounts or the presence of dates.

## Mortgage Repair Reapplied After Later Save

Wes reported missing dates after reopening. A fresh Teams inspection found the old `DATEVALUE` formulas restored in the save at `2026-09-30T13:57:51Z`, after the previously hash-verified repair. The saving session responsible was not established; this was not evidence of a date-formatting problem.

After Wes again confirmed closure, fetched the latest baseline saved at `2026-09-30T13:59:06Z` and reapplied only the same `D4:E24` date/amount formula repair. Preserved the newer workbook's other content rather than uploading an older whole-workbook copy.

- Rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-mortgage-reapply-20260930-1400.xlsm`.
- Hidden Excel verified all 19 pairs and nonblank date display text. Representative displayed values: `D4 = 6/18/2025`, `D5 = 7/18/2025`, `D22 = 9/9/2026`. The temporary unsaved date-change test passed again.
- Mortgage total remained $14,421.92; Profit carrying costs remained $33,770.25; current Docs remained $1,825. Only the Carrying worksheet package part changed; source records and other package parts were preserved.
- Teams replacement was downloaded and hash-verified at approximately `2026-09-30T14:02Z`: `EDE2700D37A26AEE593D0C0A2AC7B81E387E11B76957D877DA55C9FCD9A51629`. This is the newer delivered version, superseding the earlier mortgage-repair hash.
- Completion handoff directs Wes to open the authoritative Teams link after verification. If old formulas reappear, inspect the latest saved version before retrying or assigning a cause.
