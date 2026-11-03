# Pond Others Indexed Pricing

## Authority And Source

Wes authorized the repair after confirming Pond closed. Scope: correct Others price displacement and prevent recurrence; preserve Tim's different pricing formula and all unrelated workbook behavior.

- Live Teams workbook: [908 Pond](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&action=default).
- Source item: `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`, ETag suffix 232, saved November 3 at 6:07:08 PM Eastern.
- Source SHA256: `DF11DF327697FC89C72FAEC8EA0CB4E8F1260CF90ECE21EB17D330EC12847C2D`.
- Source retrieved through SharePoint; unchanged ETag verified immediately before replacement. No local synced source used.
- Historical recovery: Teams rollback `26_Project Management - 908 Pond St 3.before-Tim-IE-TF-20261010-POND-001-20261011-2013.xlsm` plus `26 Pond before Paid column rename 20261103-0935.xlsm` to distinguish later owner edits from existing displacement.
- Rollback: [26 Pond before Others indexed pricing 20261103-1839.xlsm](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B85866B99-1403-487E-AB7B-778A46D19582%7D&action=default), in `Property/Project Template/Rollback Copies`. Downloaded hash matched source before edits.

## Diagnosis And Repair

The Others query brings columns A:G from Contract, filtered by Assigned = Buy Your Home. Unit Price 2 was an unbound manual column. Contract reassignments inserted different items into the query output while its literal prices remained in their old cells. Multiple same-address comparisons establish the displacement between the October 11 backup and the November 3 pre-repair source; the exact triggering save is not identified.

Added `tblOthersPriceOverrides` at `Others!AA4:AD57`, separate from the refreshable table. Columns: Index, Item, Unit Price Override, Mapping Note. Index and override inputs are yellow. The existing Unit Price 2 column is orange and calculated by Index. Missing/blank overrides use the item's Contract unit price, explicit zero is retained, and duplicate override indexes produce a visible #N/A rather than silently selecting one.

Mapped all 53 current Others items independently. Restored older values by Index only where the latest value had not changed from the pre-today baseline. Preserved all later owner values, including explicit zeros. New-to-Others items without a historical override use their Contract price. No values on Tim were changed.

| Index | Item | Before | After | Basis |
| --- | --- | ---: | ---: | --- |
| 29 | Drywall repair | 0 | 4,060 | Contract fallback; quantity zero |
| 37 | Framing Materials | 1,181.75 | 0 | Historical override by Index |
| 42 | Drywall | 7,155 | 1,181.75 | Historical override by Index |
| 44 | Tile Floor | 0 | 26.10 | Contract fallback |
| 45 | Tile Shower | 4,640 | 26.10 | Contract fallback |
| 53 | Water Remidaition | 36.25 | 7,155 | Historical override by Index |
| 59 | Drywall | 0 | 4,640 | Historical override by Index |
| 60 | Drywall | 145 | 36.25 | Historical override by Index |
| 63 | Interior Trim material | 870 | 0 | Historical override by Index |
| 64 | Tile Floor | 0 | 26.10 | Contract fallback |
| 66 | Tile Shower | 0 | 3,253.80 | Contract fallback |
| 84 | Drywall | 0 | 145 | Historical override by Index |

## Validation And Delivery

- Native Excel used in a separate hidden process, macros/events disabled during editing; no visible user apps opened.
- Initial array/numeric COM assignment errors occurred only in disposable work copies. No failed copy was saved back to Teams. Numeric strings in General cells were read back and verified as native doubles.
- Original VBA, Power Query source, defined names, controls, links and Tim formulas preserved. Existing row heights and print settings preserved; new AA:AD table occupies unused space.
- Full workbook formula/constant/style/error audit passed. Native Excel normalized nine existing HVAC invoice formulas from implicit to explicit current-row syntax; source and output opened with identical Formula2 and values. This is serialization normalization, not an HVAC logic change.
- Original query item set and non-Others Gnatt values unchanged. No new displayed formula errors.
- Saved file reopened in Automatic calculation. Override edit updated immediately without Calculate; clearing it restored Contract fallback. Sorting the override table retained all prices. Removing item 45 by changing Assigned and refreshing, then restoring and refreshing, retained every other item's price and restored item 45. All test changes discarded.
- Item 45: 77 x $26.10 = $2,009.70, formerly $357,280.
- Gnatt I5 (Others): $364,848.75 -> $16,016.45.
- Gnatt I6 (total): $646,084.853259645 -> $297,252.553259645.
- Gnatt I2/I3/I4 unchanged; Glasgow L3 remains $1,087.50. Current Profit inspected cells from earlier layouts are blank; no Profit formulas were manually edited.
- Original Teams item replaced November 3 at 6:51:47 PM Eastern. Exact downloaded SHA256: `5CF1948699150A8677540A7280AEB9B1849732EDB772E352AD8B84F8C889F20F`.
- Exact downloaded Teams workbook passed the same native automatic/edit/fallback/sort/remove/restore tests. Test changes were discarded. Wes was told he may reopen Pond.
- Validation evidence: `Property/Project Template/Validation Evidence/Pond Others indexed pricing validation 20261103.zip`, item `01ZGFUBDLNADBSNIV4JVG2THUXJHF45PJK`. Includes the complete 53-item mapping, native metadata preservation comparisons, whole-workbook audit, rendered preview PDF, and both saved-file/delivered-file test results. Archive downloaded for hash verification before scratch cleanup. One exact delivered workbook retained as the current review artifact; superseded source/build/test copies removed.

## Remaining Boundaries

Historical zero overrides remain zero, including existing active-quantity items; this repair does not infer that those zeros should be replaced with Contract prices. Latest item 144 zero was retained despite an older $2,000 historical override. These preserved business values are not newly approved costs. Other manual fields beside query results may have similar positional risk but were outside this price-only repair. The existing Full Recalc button/checkbox issue remains for its separate reminder.

No other project was migrated. No push authorized.
