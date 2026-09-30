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

## Live Workbook Repair After Second Reversion

The Teams save at `2026-09-30T14:04:33Z` again contained the old formulas, superseding the earlier verified file replacements. The responsible saving session or automation was not established. Wes explicitly authorized updating only `Carrying!D4:E24` in his open Pond workbook. Earlier completion claims describe those delivered snapshots, not the subsequently reverted content.

- Confirmed the exact open Pond workbook and its signed-in ChatGPT add-in. Connected Excel tools read the old formulas directly from that workbook before editing.
- Fresh Teams rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-live-mortgage-20260930-1427.xlsm`, based on the save at `2026-09-30T14:26:23Z`.
- Wrote only the 42 formulas in `D4:E24`, removing the same inappropriate `DATEVALUE` wrapper. No source table values or formatting were written. The command reported a timeout, but subsequent complete range reads proved all 42 edits applied; no duplicate write was issued.
- Verified every one of the 19 displayed date/amount pairs against the live included Mortgage Payment table records, preserving equal-date order and zero-dollar records. `D23:E24` remained blank. Native range-image verification showed readable dates from June 18, 2025 through September 9, 2026.
- Mortgage total remained $14,421.92; live and saved Profit carrying cost remained $33,770.25. Saved `Docs!E39` remained `Profit!C9`, value $1,825.
- Excel AutoSave, not another full-file replacement, saved the correction to Teams at `2026-09-30T14:31:08Z`. A fresh connector download verified the fixed formulas and cached dates. ETag: `"{29C35775-DC91-47CF-AC62-F0054399FE81},49"`. SHA-256: `F0D88FC1F574CF266B44D97F05E70026C2A4FCC8A60084D321C468D4C2B5D110`.
- Across all worksheets, saved-file comparison found exactly the 42 approved formula substitutions, no other formula or constant-value changes, and no cell-style changes. Defined names were unchanged. Table, style, drawing, control, and external-link package parts were byte-identical. Saved calculation mode was the default Automatic (no manual override).
- Native saving changed workbook metadata, Carrying XML, calculation chain, core properties, and the same-sized VBA binary. No macro editing command was used; VBA source equivalence was not independently established, so this is not a byte-identical macro-preservation claim. The rollback remains available. No unrelated package parts were replaced to suppress native-save changes.
- Other category date blocks remain outside this approved repair. No other project was updated.

Lesson: repair and verify the actual authorized live session when repeated file replacements are being superseded. Treat a write timeout as uncertain until a read establishes its outcome, and verify both the live display and the subsequent Teams save before reporting completion.

## Seven Remaining Date Blocks

Wes reported the same symptom in G, J, M, Y, and AB. Inspection also found the same defect in V and AE. Wes approved repairing all seven date/payment blocks together, preserving source values, totals, formatting, and tax-escrow logic.

- Fresh Teams baseline saved at `2026-09-30T14:45:16Z`. Rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-seven-dates-20260930-1448.xlsm`.
- Independently inspected all 294 target formulas and the matching source records. No manual overrides existed in those ranges. Removed only `DATEVALUE` around `tblCarryingExpenses[Date]`; retained each formula's existing selection, counters, sorting, amount conversion, and blank behavior.
- Applied through the connected open Pond workbook, not a whole-file replacement. No other project was changed.

| Repaired range | Category | Source pairs verified | Unchanged category total |
| --- | --- | ---: | ---: |
| G4:H24 | Private Money | 19 | 5,500.00 |
| J4:K24 | Casa Lending | 19 | 5,921.56 |
| M4:N24 | Insurance Payments | 19 | 0.00 |
| V4:W24 | HOA | 19 | 0.00 |
| Y4:Z24 | Property Taxes | 19 | 0.00 net of existing escrow |
| AB4:AC24 | Excavator Rental | 19 | 6,000.00 |
| AE4:AF24 | Lawn | 0 | 0.00 |

- All 114 populated date/payment pairs matched the source table in chronological order. Lawn remained blank; unused tail rows stayed blank. Dated zero-dollar schedules remained visible. Source schedule dates were not corrected or reinterpreted as actual payments.
- Complete live checks confirmed unchanged source table records, number formats, totals and total formulas, and `AA4:AA24` escrow formulas, values, and number formats. Profit carrying cost remained $33,770.25. Calculation mode was Automatic. Native range images confirmed readable dates in all six populated blocks.
- Downstream Carrying references found in Profit were category outputs; the archived Docs mortgage reference was outside this repair. No downstream formula was rewritten.
- The first connector download captured an intermediate AutoSave at `2026-09-30T14:49:30Z` with only 210 of 294 changes. The last two blocks were already correct live. Did not repeat writes; retrieved the subsequent save at `2026-09-30T14:51:48Z` instead.
- Final Teams verification found all 294 exact substitutions, no remaining `DATEVALUE(tblCarryingExpenses[Date])` formulas in Carrying, no unexpected formula or constant-value changes across worksheets, no cell-style changes, unchanged defined names, and no saved-versus-live result mismatches in the repaired ranges.
- Verified final SHA-256: `BC0E7389FFF0B3A36649CF9DC3E6AB24402649CEDD9A87F20F288CB6C1F7B9D2`. Observed ETag: `"{29C35775-DC91-47CF-AC62-F0054399FE81},53"`. Rollback retained in Teams; temporary local verification copies removed after completion. Macros were not function-tested.

Lesson: a correct live display and a newer cloud timestamp are insufficient by themselves. Multi-block AutoSave can be intermediate; compare the complete approved repair against the saved Teams content before declaring delivery complete.

## Approved Zero-Dollar Row Cleanup

Wes explicitly requested deletion of zero-dollar table rows. Completed September 30, 2026 through the connected Pond workbook; no other project was edited.

- Fresh Teams rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-zero-rows-20260930-1519.xlsm`, from the save at `2026-09-30T14:51:48Z`.
- Deleted 119 numeric-zero records from `tblCarryingExpenses`, using bottom-up native table-row deletion. None of those amounts was a formula. Table changed from `AL2:AV195` (193 records) to `AL2:AV76` (74 records).
- Deleted counts by category: Duke Electric 9; Mortgage Payment 10; Private Money 4; Casa Lending 12; Insurance Payments 19; Water 8; Natural Gas 9; HOA 19; Property Taxes 16; Excavator Rental 13.
- Preserved all 62 nonzero records, including credits, and all 12 blank-amount records (Mortgage Payment 3, Private Money 9). Blank amounts were not included in the deletion authorization; current display formulas still show those blanks as $0.00 alongside their dates.
- All surviving source values, formulas, number formats, and order match the baseline. Grid formulas and formats, escrow formulas, category totals, Profit outputs, and Docs output are unchanged. Profit carrying costs remain $33,770.25; Docs remains $1,825. Calculation mode is Automatic; the live grid has no displayed formula errors. Native range-image inspection confirmed the shortened display lists.
- First cloud save was intermediate, with 103 records. Did not repeat the deletion. Final connector download saved at `2026-09-30T15:23:45Z` contains exactly the expected 74 records. Saved comparisons found no surviving-record value/formula/style differences, no formula/constant/style changes outside the table data area, unchanged defined names, and unchanged category totals.
- Final SHA-256: `F2EB98BC0EEEBA3CEAAD4B4AFF9140FB6E2E951FFEE10A9B80FB55F3FB42F066`. Macro behavior was not function-tested. Rollback remains in Teams.

Lesson: blank amounts and zero-dollar amounts are different source states. Apply explicit deletion criteria to table rows only, preserve credits, verify surviving records rather than only totals, and disclose blank-to-zero display behavior. This cleanup does not establish a global policy to delete dated schedules.

## Labor Section Addition

Wes authorized three new Labor display columns starting at AH and consultation with Invoice Entry about Review-to-vendor/Carrying routing. Scope for this iteration was the new Carrying section only, not moving operational records.

- Retrieved current Pond through Teams and preserved `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-labor-20260930-1536.xlsm`, from the save at `2026-09-30T15:23:45Z`.
- Confirmed `AH1:AJ26` was empty. Copied the neighboring Lawn presentation from `AE1:AG25` into `AH1:AJ25` through connected Excel tools. Changed `AH1` to `Labor`, and matched AJ's width to AG. Did not insert entire worksheet columns, shift the source table, alter row heights or change existing categories.
- Verified all 43 formulas against the Lawn pattern with only relative A1 references translated: 21 date/amount pairs in `AH4:AI24` and a full-category subtotal in `AI25`. Structured table references stayed correct. Category selection is `Labor`, Include is `Yes`, and dates sort ascending. No source Labor rows currently exist, so display rows are blank and subtotal is $0.00. The source Category column has no list validation blocking Labor.
- All 74 source records and their formulas stayed unchanged; table remains `AL2:AV76`. Profit and existing totals stayed unchanged at this step; carrying cost remains $33,770.25. Automatic calculation verified. Native image inspection confirmed the Labor section matches Lawn's formatting and fits before the spacer/source table.
- First fetched AutoSave contained the copied formulas but the intermediate Lawn label. Final saved Teams content at `2026-09-30T15:39:31Z` contains Labor and all expected formulas. Saved comparison found no existing formula/constant/style changes outside `AH1:AJ25`, and defined names were unchanged. SHA-256: `F8E64EDEBE1ADC7211F93A396C063C416B68C0CA69ABB96C2C1586EB39CD127A`.
- No real or test invoices were inserted; no end-to-end posting or macro function test was performed. Profit does not yet include Labor and must be connected before operational use. Review controls, status semantics and posting behavior were not changed.
- Consultation saved in the authoritative central queue as `prmsg-template-invoice-labor-consult-20260930-001`, addressed to Invoice Entry on OFFICEASSIST. As of this close-out it is Queued with no delivery attempt, accepted receipt or result. Questions cover approval/destination semantics, category mapping, source traceability, duplicates, splitting and retained Posted audit records. No Invoice Entry files were edited. See [[work-status]] for exact identities and hash; consultation completion remains pending.

Lesson: copy a verified neighboring category block into confirmed empty space, validate every translated structured-reference formula, and distinguish a completed display addition from operational posting readiness. Adding Carrying presentation alone does not connect Profit or authorize Invoice Entry movement.

## Review Destination Dropdown

On September 30, 2026, Wes authorized adding Carrying to Pond's Review destination selector. Wes will implement the related Profit row himself; inspect and map those current changes for the later coordinated migration, without overwriting them or assuming their final location.

- Resumed after the Excel connection was restored, using the newly discovered Pond session. Fresh Teams baseline saved at `2026-09-30T16:37:19Z`; rollback retained as `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-review-destination-20260930-1638.xlsm`.
- Confirmed `Destination Worksheet` is column B of `tblInvoiceReview`, header row 4, with 32 records through row 36. Existing dropdown validation extends through `B234`. Appended `Carrying` once to that same `B5:B234` list, retaining all 13 prior choices and existing dropdown, blank-entry, prompt and Stop-alert settings.
- Live read-back verified unchanged Review records/formulas, Status choices, unchecked `B1`, and `invoiceEntryReviewRequest = Review!$B$1`. Calculation mode remains Automatic. No invoices moved and no Profit cells were written.
- Final Teams save at `2026-09-30T16:39:35Z` contains the updated dropdown. Saved Review cell data is identical; other validations and table parts are unchanged. Review is the only changed worksheet XML part. SHA-256: `E3CB2FE599C0EB2570A2703896A2E20A2F68A290B0719A505D2A457150C992B1`.
- Existing destination-type validation also occurs on `C5:C234` and `D37:D234`; these are outside the approved column-B edit and were preserved, not corrected. Reassess their intended roles during the broader Review design rather than copying them blindly.

Lesson: validation coverage may extend beyond a populated table. Preserve that coverage when adding a destination, and keep destination availability separate from operational posting approval and accounting integration.

## Wes's Profit Integration Inspection

September 30, 2026: Wes authorized a read-only inspection and migration documentation, then plans to request a test record from the invoice workflow himself. Fresh Teams version obtained at `2026-09-30T16:47:40Z`; inspected the confirmed connected Pond workbook. No workbook edits, mode toggles, record insertions, or posting instructions were performed.

- New label: `Profit!A41 = Labor(not in Vendor Tabs)`.
- `B41 = +Carrying!AI25/Profit!$B$28`; current Labor subtotal and this average are zero. Months carried is 12.9520052596976, shown rounded to 13.
- Lawn is now row 42. `B43 = +B28*SUM(B31:B42)` includes the new Labor row; current total is $33,770.25.
- In current Flip mode (`E1=1`), `D43 = IF(E1=1,-B43,0)` feeds `D54 = SUM(D14:D53)` and `E55 = SUM(D10:E53)`. Each additional included Labor dollar therefore increases carrying cost and decreases the Flip result by one dollar, with other inputs unchanged.
- For Hold/Slow Flip, `J41 = IF(OR($E$1=2,$E$1=3),-B41,0)*$B$28/($B$28+$B$9)`. Both `J54 = SUM(J15:J53)` and `J55 = SUM(J10:K53)` include it. `M42` uses `B43/B28` except in Slow Flip, where it uses `-J54`. These were formula-trace checks, not executed scenario tests.
- Profit error search found `L83` and `L85` with `#VALUE!`. `L83` uses `DAYS(J74,H74)`, but those cells hold End Date/Start Date headings; actual dates are in `J75`/`H75`. `L85` averages a range containing L83. Their origin was not established. Reported without repairing; they do not block the traced Labor subtotal/carrying-cost calculation, but the entire Profit sheet is not clean.
- This was a targeted Labor integration review, not a complete audit of all Profit changes. Later migration still requires the full template comparison and project-specific mapping required by Profit Mode.

Invoice Entry's exact central consultation record completed at `2026-09-30T16:37:44Z` and its identity/hash were verified. Recommendations: one Review row per time-card source line/project/work category; use an appropriate vendor destination first, Carrying/Labor otherwise; append by table header with Include Yes; preserve source work date, payee, supported description, allocated amount, invoice identity, canonical PDF reference, Review Row ID and source-line identity. Retain the Review row and mark Posted only after insertion validation. Reconcile split allocations exactly and prevent duplicates using source-line identity across destinations, not amount alone. These are consultation findings, not edits to Invoice Entry's rules. The response's Profit-not-connected blocker predates and is resolved by the inspected Wes changes; end-to-end posting remains unproven until the controlled test.

Test baseline: `Carrying!AI25 = 0`, `Profit!B41 = 0`, `Profit!B43 = 33770.25`, `Profit!D43 = -33770.25`, `E1 = 1`. For an included test expense X, verify the source row once, its date/amount display, Labor subtotal X, Profit B41 X/B28, B43 33770.25+X, D43 -(33770.25+X), and retained Review audit status. No other project is approved for this test or rollout.
