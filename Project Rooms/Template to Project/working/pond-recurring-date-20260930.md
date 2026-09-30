# Pond Recurring Date Enhancement - September 30, 2026

## Authorization And Source

Wes approved suggested next dates, inclusion in the migration plan, and Pond first. Pond was confirmed saved/closed. Wes separately authorized filling its 74 blank Vendor cells from Category while preserving the existing Josh Kennedy LLC Vendor. Tensity's closure notice was not treated as authorization to change it in this request.

- Current workbook: `Property/26_Project Management - 908 Pond St 3.xlsm`.
- Item: `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`.
- Fresh Teams source: save `2026-09-30T19:17:32Z`, version 78.
- Source SHA-256: `3B15EB7E5D4BA5287DD4CA54894B82BC076E4BC883270563BEDF3A9F7D6C7E02`.
- Rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-recurring-date-20260930-2117.xlsm`.
- Rollback item: `01ZGFUBDNMY4LISDD2IFD3EHEK2DAOJC34`.
- [Open Pond](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&file=26_Project%20Management%20-%20908%20Pond%20St%203.xlsm&action=default).

## Project Mapping

Table `tblCarryingExpenses`, AL2:AV77, 75 records. Headers: Include, Category, Date, Vendor, Description, Amount, Source, Invoice #, Source File, Status, Notes. All records are retained; only 74 approved blank Vendors become Category labels. Josh Kennedy LLC and all original dates/amounts/provenance remain unchanged. No numeric-zero cleanup or new invoice entry is part of this narrow enhancement.

Named form fields already match the prefill design. Added hidden AX dynamic Vendor list and G2:K2 dropdown, permitting new typed vendors. Added Recurring Bill beneath Insert Record with equal 119.25 by 31.5 point dimensions; native save rounds its left anchor by one pixel. Feedback name and existing message move W3 to Z3 without changing form formatting. Prior macro source is verified unchanged during import.

## Date Rule

Prefill reads the three latest distinct numeric dates from the same trimmed, case-insensitive Vendor/Category/Description, independent of filters and Include. Weekly intervals must be exact. Monthly, quarterly or annual intervals use calendar months, allow at most three days' billing-date deviation, and handle fixed-day February clamping and all-month-end histories. Insufficient, irregular or missing-period histories leave Date blank. Existing entered dates and formulas remain unchanged.

Suggestions advance the latest matching record, not today. They may be historical or future dates and are not a determination of due date, payment status or recurring obligation. Wes reviews the suggested Date/Amount before Insert Record. The button does not add a record or save the file. Earlier invoice/source-file/notes are cleared to avoid reusing provenance.

Pond's Duke Electric and Water rows have two different provenance descriptions. The existing bill-type guard requires selecting a source record; it does not silently combine those descriptions. Two recovered records alone are insufficient to infer a date. The one-off Josh Kennedy LLC Labor row must leave Date blank.

## Validation Status

Local installation and raw-cell/style/table/name audit passed: 75 records remain, Profit B43 remains $33,864.65, Labor remains $94.40, and category totals are unchanged. Existing insertion tests passed including automatic recalculation, duplicate checks, credits, filtered/excluded rows and Include control. Preview inspected; no overlap. Pond has 110 pre-existing error cells outside this enhancement; no new errors or external links introduced. Unrelated financial assumptions are not certified.

All 14 synthetic date cases passed: monthly, variable monthly billing, weekly, quarterly, annual, month end, February clamping, leap month end, leap annual, irregular, insufficient, duplicate day, unsorted/duplicate and missing month. Dates/formulas already entered were preserved. Real Pond examples: Natural Gas suggests September 5, 2026; Property Taxes suggests September 1, 2026; Josh Kennedy LLC leaves Date blank. Different Duke Electric descriptions require selection. All tests used unsaved copies.

Teams replacement saved `2026-09-30T21:25:47Z` to the same live item/name after confirming source version 78 remained unchanged. Delivered and downloaded SHA-256: `89503106CFF3FD884060C14B82F391180D7B9D9FBAB2EB10573A54635D7B1448`. Download matched exactly; native post-download real-history, dropdown/geometry, ambiguous/unknown Vendor and full insertion tests passed without saving. Rollback remains in Teams. Ready for Wes to inspect; no other project changed. Documentation/code/tests committed locally, not pushed.

## Migration And Lessons

See [[carrying-migration-plan]] and [[Carrying Mode Rules#Next Logical Date]]. The new behavior is required for subsequent authorized Carrying migrations, with independent project mapping and verification. No batch rollout is authorized here. Existing Tensity prefill requires a separate scoped module upgrade; the fresh-install script deliberately refuses an existing module.

Preserve an existing feedback message when moving its named anchor. Native form-control positions may round one pixel during save; verify exact size, safe placement and rendered appearance rather than assuming coordinate identity. Compare real Vendor values before any fill. Keep source dates unmodified and the proposed date separate in the manual-entry form.
