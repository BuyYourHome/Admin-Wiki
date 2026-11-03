# Pond Paid Column Header Repair

## Scope and Source

Wes requested renaming the mistaken `Contract_Edits[0]` column to `Paid` everywhere referenced and confirmed Pond saved to Teams and closed. Scope is Pond only. No other workbook, query logic, financial assumption, record or macro change was authorized.

- Workbook: [908 Pond St](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&action=default).
- Item: `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`, directly under `Property`.
- Fresh source: version 158, modified `2026-11-03T14:33:59Z`, SHA256 `2AFD1F1E14C003E81944CB9DF4946EFF80A6EF30A542A3A1B4B7D27FF28DA7D3`.
- Table: `Contract_Edits`, range `Gnatt Chart!L24:AN303`; sixth column header `Q24`, 279 data rows.
- Source rechecked unchanged immediately before upload.

## Change and Validation

Native hidden Excel, with macros and events disabled, renamed the table column `0` to `Paid`. All 222 dependent formulas updated automatically: Depends 31, Glasgow 74, Tim 48, Others 57, Gnatt Chart 12. Formula logic, including existing differing error fallbacks, was preserved. No stale `Contract_Edits[0]` references remained in the saved XML; none were present in VBA or Power Query.

The independent whole-workbook audit passed with zero issues. All constants except Q24, other formulas, formatting, dimensions, tables, validations, print settings, names, controls and VBA source preserved. Power Query sources unchanged and not refreshed. Native recalculated values before/after rename and after reopening matched across every worksheet, with the header masked. All 279 Paid-column values preserved; 110 pre-existing native error cells unchanged. This repair does not certify or fix those unrelated errors.

The Gnatt Chart native summary baseline and result matched:

| Cell | Meaning | Before and After |
| --- | --- | ---: |
| I2 | Materials/vendor expense | 32616.749812425274 |
| I3 | Glasgow expense | 189900.95 |
| I4 | Tim expense | 16184.375 |
| I5 | Buy Your Home expense | 28030.22 |
| I6 | Grand expense total | 266732.2948124253 |
| L2 | Vendor Due summary | -870 |
| L3 | Glasgow Due less Paid | 26808.75 |
| L4 | Tim Due less Paid | -4468.75 |
| L5 | Buy Your Home Due less Paid | 7155 |
| L6 | Existing grand Due formula | 0 |

Before/after header previews were inspected; existing yellow/orange formatting retained. Calculation mode saved as Automatic. Test/print configuration changes were discarded without saving.

## Delivery and Recovery

Delivered to the same Teams item at `2026-11-03T14:43:45Z` (9:43:45 AM Eastern), version 159. Downloaded bytes exactly matched validated output SHA256 `3C712D97272E131AD9B154470A0D08B696B213F8F30022B629D6B17EA2B523FD`.

Rollback: [26 Pond before Paid column rename 20261103-0935.xlsm](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BD72D41FB-3229-427B-8516-5F913C81067F%7D&action=default), under `Property/Project Template/Rollback Copies`, item `01ZGFUBDP3IEW5OKJSPNBIKFS7SE6ICBT7`. Downloaded rollback SHA256 matched the untouched source before editing.

Final downloaded native verification and independent audit passed with zero issues, all 222 references updated and all 279 Paid values unchanged. The downloaded file's SHA256 was unchanged after the no-save native test. Wes was told Pond could reopen.

Evidence: [Pond Paid header validation 20261103-0935.zip](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/Project%20Template/Validation%20Evidence/Pond%20Paid%20header%20validation%2020261103-0935.zip), item `01ZGFUBDPGZXYQXB7A2BCKPBZDJIAAVLBO`. Uploaded/downloaded SHA256 verified as `6BE997A7F0C78A4ECD897D45D59D5CF08AAFEF741BD73257FF74F7742D5BE75E`. Includes native snapshots, both audits and header previews. Exact repair TEMP root and superseded earlier Due-review download removed after verification. Rollback remains in Teams.

No push authorized. Unrelated Dashboard changes remain untouched.

## Reusable Support

- `tools/Rename-PondPaidColumn.ps1`: scoped native inspect/rename/reopen checks and preview, with all workbook edits limited to the native column rename.
- `tools/audit_paid_column_rename.py`: independent semantic comparison using existing read-only audit helpers; never saves a workbook.
- Lessons recorded in [[../Worksheet Modes/Gnatt Chart Mode Rules]].
