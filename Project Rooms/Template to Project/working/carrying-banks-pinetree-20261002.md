# Banks and Pinetree Carrying Completion

## Authorization and Sources

October 2, 2026, evening Eastern. Wes answered `1. Yes 2. yes` to the remaining decisions: replace Banks from its current grid values, retain the old tab and undated insurance; add an empty Pinetree interface while preserving existing Profit estimates. All workbooks were confirmed saved and closed. This resolves the prior holds; it does not authorize a review of the financial accuracy of legacy schedules.

Fresh Teams/SharePoint sources from the live Property folder:

- Banks: `07_Project Management - 3325 Banks Rd.xlsm`, source modified September 29 at 13:09:09Z, SHA256 `53726CA627730E1C5D9EB97914D51C989A270E8A9FD930CF6008EBE17E43A985`.
- Pinetree: `17_Project Management - 3413 Pinetree Ln.xlsm`, source modified July 15 at 20:11:44Z. Its complete source hash is in the validation inventory.
- Current prototype: `24_Project Management - 4121 Tensity Dr 2.xlsm`, October 2 save at 19:51:15Z. Copy design and approved macros, never prototype financial records or escrow assumptions.

## Banks Independent Map

The original grid has no table. Map cached native values, not continuing schedule formulas; retain source coordinates and original formulas in each record's Notes. Retain the complete original worksheet as `Carrying - Old`.

| Source Date / Amount | Category | Records | Total |
| --- | --- | --- | --- |
| B5:B52 / C5:C52 | Duke Electric | 48 | $138.63 |
| F5:F86 / G5:G86 | Mortgage Payment | 82 | $69,755.50 |
| J5:J34 / K5:K34 | Insurance Payments | 30 | $5,170.81 |
| Total | | 160 | $75,064.94 |

Credits are preserved. Utility Vendor is Duke from the source label; mortgage/insurance use category defaults, not verified lender/provider identities. The Water block has no amount records. No nonzero amount was dropped, no zero record was added. The $182.76 K34 entry has no source date and is retained as Missing Data. Other records are Migrated Snapshot, not independently verified payments.

New table `tblCarryingExpenses` is AO4:AY164. Grid A10:AM91 provides 82 rows per category, with subtotals at row 92. Rent is separate income, excluded from expenses. Project-specific escrow assumptions were not imported.

Profit was independently mapped by labels. The old B31 formula read Carrying B25, a date; B34 read an insurance amount as refinanced debt; B36 contained `Immediate Profit:` text in the Water value cell. Insert the approved Labor row before Lawn using native Excel, then reconnect B31:B42 by category-specific SUMIFS divided by B28. Carrying Cost is now B43, `=B28*SUM(B31:B42)`. The private lender rate/checkbox move natively to row 44 and are preserved. Expense result changes from the incorrect $45,684.97 to the exact mapped grid total $75,064.94.

Other formulas are preserved with native row-reference shifts. Old Profit references remain on Carrying - Old; Docs E39 also retains its original source there. No rent/Docs financial correction was inferred.

## Pinetree Independent Map

No source Carrying sheet or bill history exists. Add the current interface after Review with zero records, retaining an empty native table and blank grid. No mortgage bill or zero-dollar placeholder is invented.

All existing Profit values, formulas, formatting and dimensions are preserved: B32 is $890.28/month, B28 is 6, and B42 remains $5,341.68. The new Carrying table intentionally does not drive these estimates. Changing Pinetree to actual-expense accounting requires a separate decision.

Both projects' existing Review destination dropdown B5:B217 gains Carrying. Other Review validations, controls and request-marker behavior are unchanged.

## Verification and Delivery

- Hidden native Excel authoring; no visible desktop application opened.
- Both independent raw-XML preservation audits report zero issues: original cells/formulas/styles, dimensions, names, tables, print settings and media preserved except the mapped changes.
- Banks retains its four pre-existing error cells; Pinetree retains its three. No new errors or external workbook links.
- Native tests verify every included date/amount pair, capacity, real-grid selection, undated record selection, next-month-end recurrence, insertion, editor Save/Cancel, active-edit guards, all button help, Rent exclusion and the appropriate Profit behavior. Test changes are discarded.
- Normal reopen of downloaded replacements verifies automatic calculation, saved VBA source and Include checkbox linkage. All 29 original Banks and 26 original Pinetree VBA components are preserved; each gains three reviewed modules and the empty new sheet component.
- Teams freshness checked immediately before replacement; original item identities and filenames preserved. Exact downloaded SHA256 matches the validated output.

| Project | Final Teams Save UTC | SHA256 | Live Workbook |
| --- | --- | --- | --- |
| Banks | 2026-10-03 01:37:07 | `0A83DF9FD38DF1295A7B38AA9FAB879FA697E55D2A3022302A7A41958E8F9BE3` | [Open Banks](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B1285A8AD-93C4-4909-91D7-A1496C5E5E6A%7D&action=default) |
| Pinetree | 2026-10-03 01:39:18 | `725AC2FD31724BDCDB2D5DBF6871EFFFF07C30743CF568CDE86FB255FF4AA364` | [Open Pinetree](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B82D7F937-5C3A-4823-B955-C8B6596AB856%7D&action=default) |

The UTC saves above occurred October 2 at 9:37 PM and 9:39 PM Eastern. Pinetree's first upload at 01:25:58Z was superseded by its final blank-date-hardened version; no intervening owner save was overwritten.

## Rollback, Evidence and Lessons

Both pre-edit rollbacks are in Teams `Property/Project Template/Rollback Copies`, with original basename plus `.before-carrying-completion-20261002-2105.xlsm`. Banks rollback item `01ZGFUBDK3GAXJLY6FBRB2UPLXGMIMXF5N`; Pinetree `01ZGFUBDORXEPJRN5TFNAYBAJWLWSGVGXY`.

Validation inventory, record map, native previews, VBA snapshots and audit/test results are retained in [Teams validation evidence](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/Project%20Template/Validation%20Evidence/Carrying%20Banks%20and%20Pinetree%20validation%202026-10-02.zip), item `01ZGFUBDKWOLRLL6PC35E2QQVNQTZ2BW5E`, archive SHA256 `3F9648AA537CCDDED007544E793C7AE99AC8F3ED406278E3835F03EC1F29361D`. Temporary workbook copies are removed after verified delivery; no binaries belong in Git. No push was authorized.

Lessons recorded in Carrying Mode Rules:

- Assert native copy actually inserted a sheet; ForceDisable can silently refuse copying a VBA worksheet. Keep events disabled and leave machine-wide trust settings unchanged.
- A copied current design must not import the prototype's records, pending input or escrow assumptions.
- Empty source tables require explicit empty-interface tests, and validation changes must use the target's actual existing extent.
- Preserve 2D COM arrays in PowerShell test code; pipeline enumeration can flatten them and invalidate record comparisons.
- Blank dates need explicit handling in both display and editor order. Local validation caught the 1900 display and insurance-grid selection failure before Banks delivery; final formulas and editor preserve the missing date. Apply this correction in future authorized migrations; do not silently edit unrelated live projects.

Residual review: Banks contains overlapping historical mortgage schedule dates and future generated amounts; these were retained exactly as requested, not deduplicated or certified paid. Existing unrelated formula errors and misplaced Review validation ranges remain outside this Carrying change. Rosebrooks rent/Docs is still deferred.
