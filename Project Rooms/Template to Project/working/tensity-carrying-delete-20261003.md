# Tensity Carrying Delete Record

## Scope and Status

Wes requested a final inline toolbar button deleting the source table record identified by the focused grid cell. Tensity only. The local candidate is implemented; replacement of the live Teams workbook is pending saved-and-closed confirmation. An async question was presented before replacement. No live records were deleted, and no other projects were changed.

## Source and Recovery

- Current connector source: `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`, saved October 3, 2026 at 18:30:41Z, ETag version 1250. This includes owner changes after the earlier version 1247 rent delivery; these newer changes are preserved.
- Drive: `b!4mDJWAoUZEiObH1uIc-tPNklzEL-JwdPrMve0F7Efu7K7Z-rHQDJTLJE2cO-WifT`; live item: `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`.
- [Teams live workbook](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BFB8825B0-06EF-4B3E-8015-A106EEEA5C7C%7D&file=24_Project%20Management%20-%204121%20Tensity%20Dr%202.xlsm&action=default&mobileredirect=true).
- Rollback uploaded through the connector to `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-delete-button-20261003-1433.xlsm`, item `01ZGFUBDJEET3UBKJC6ZH3J5DFNPXYCGIC`. Download/hash verification remains part of final delivery.
- Temporary candidate: `C:\Users\wesbr\AppData\Local\Temp\tensity-delete-20261003-1433\final\24_Project Management - 4121 Tensity Dr 2.xlsm`.
- Temporary evidence directory: `C:\Users\wesbr\AppData\Local\Temp\tensity-delete-20261003-1433`. Retain final/source and validation evidence until delivery; earlier output/candidate/ready folders are superseded test builds, not deliverables.

## Implemented Behavior

- Added `ceDeleteButton` last after Cancel Edit, same size as Cancel, same height/top as existing buttons. Six buttons have 72.35-point equal gaps and do not overlap the unchanged merged instruction box.
- Appended the Delete procedure suffix to the target's existing `BYHCarryingEdit`. Original procedures and other modules are unchanged. The button calls `CarryingEdit_DeleteRecord`.
- Requires one valid date or amount in the named grid. Uses the existing mapping and a unique full-record snapshot; confirmation lists category, vendor, date/rental month, amount, description, invoice/reference and status.
- Defaults to No. Confirms that only the table record is removed, not the worksheet row or Review audit record. Warns that Excel Undo cannot restore it.
- Rejects active edits, protected/read-only state, filtered table, invalid/stale/overwritten selection and indistinguishable duplicate records. Revalidates after confirmation, safely tolerating table re-sorting but refusing a changed record.
- Deletes one ListRow and recalculates. Leaves form contents intact, restores event state, and reports partial/uncertain outcomes without automatic retry.

## Validation

- Native Excel authored/saved/reopened the candidate with Automatic calculation; no workbook repair occurred.
- Saved-copy audit `audit.json`: zero unexpected differences across cells, formulas, styles, dimensions, print settings, names, tables, validations, existing controls and original VBA. Only authorized toolbar position changes, new button and appended code are present.
- All 68 source records retained, including 12 Rent rows. Expenses remain $28,224.97; rent collected remains $22,200 over 12 months. Flip, Hold and Slow Flip outputs exactly match fresh version 1250. Seventeen pre-existing Contract/Gnatt Chart error displays remain unchanged.
- Native toolbar PDF visually inspected: last button aligned, label legible, owner formatting and context box preserved.
- Functional testing passed all five groups in `tests-final.json`: confirmation/cancel, invalid-state guards, exact one-row deletion and unchanged survivors/form/grid, sort-safe revalidation and financial effects, last/empty-table behavior and reinsertion. Tests use an in-memory confirmation harness only, close without saving, and do not alter production confirmation or any live record.
- Lessons: PowerShell COM Shape geometry setters need Single values; range Formula2 arrays require explicit dispatch assignment. Native table deletion under an active filter fails, so block it before attempting deletion. Reinsertion into a fully emptied table can create a blank structural row alongside the one populated record; it is not a duplicate payment and the existing insert module is preserved.

## Remaining Delivery

1. Receive saved-and-closed confirmation; recheck live version 1250. If newer, fetch and rebase/revalidate, never overwrite owner edits.
2. Verify rollback bytes, upload validated candidate to the same Teams item, download and hash-match exact saved bytes.
3. Re-run native safety tests on the downloaded replacement, preserve validation evidence externally, update this status and commit the owned completion notes. No push is authorized.
4. Remove superseded TEMP copies only after verified delivery/evidence preservation. Report the live review link and that installation did not delete records.
