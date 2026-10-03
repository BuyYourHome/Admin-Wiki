# Tensity Carrying Delete Record

## Scope and Status

Wes requested a final inline toolbar button deleting the source table record identified by the focused grid cell. Tensity only. Wes confirmed closure, and the update was delivered to the original Teams item on October 3, 2026 at 23:13:54Z (7:13:54 PM Eastern), version 1254. No live records were deleted, and no other projects were changed.

## Source and Recovery

- Final connector source: `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`, closing save October 3, 2026 at 23:09:04Z, ETag version 1253. The earlier version 1250 candidate was superseded; the approved additive change was rebuilt and revalidated against this fresh source, preserving all owner changes.
- Drive: `b!4mDJWAoUZEiObH1uIc-tPNklzEL-JwdPrMve0F7Efu7K7Z-rHQDJTLJE2cO-WifT`; live item: `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`.
- [Teams live workbook](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BFB8825B0-06EF-4B3E-8015-A106EEEA5C7C%7D&file=24_Project%20Management%20-%204121%20Tensity%20Dr%202.xlsm&action=default&mobileredirect=true).
- Fresh rollback uploaded and downloaded/hash-verified: `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-delete-button-20261003-1909.xlsm`, item `01ZGFUBDJTWXBMZM5UKJEYSLE4YHY6DKS2`. SHA256 `190DD3DA967CE787E162E66E754454B40BDC86EA312DF2647E441BA5D4CAE750`. The earlier 1433 rollback is retained as history, not the final pre-update version.
- Delivered workbook downloaded/hash-matched: SHA256 `384A94AA2915D2975B7D91DCF10E5293B38A31690ABEC026F01CC0162BCBA9EE`.

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
- All 68 source records retained, including 12 Rent rows. Expenses remain $28,224.97; rent collected remains $22,200 over 12 months. Flip, Hold and Slow Flip outputs exactly match fresh version 1253. Seventeen pre-existing Contract/Gnatt Chart error displays remain unchanged.
- Native toolbar PDF visually inspected: last button aligned, label legible, owner formatting and context box preserved.
- Functional testing passed all five groups in `tests-final.json`: confirmation/cancel, invalid-state guards, exact one-row deletion and unchanged survivors/form/grid, sort-safe revalidation and financial effects, last/empty-table behavior and reinsertion. Tests use an in-memory confirmation harness only, close without saving, and do not alter production confirmation or any live record.
- Lessons: PowerShell COM Shape geometry setters need Single values; range Formula2 arrays require explicit dispatch assignment. Native table deletion under an active filter fails, so block it before attempting deletion. Reinsertion into a fully emptied table can create a blank structural row alongside the one populated record; it is not a duplicate payment and the existing insert module is preserved.

## Delivery Verification

- Closure confirmation received; version 1253 rechecked immediately before replacement. Saved copy audit and all native tests passed before upload.
- Rollback and delivered bytes verified through connector downloads. All five native test groups passed again on the downloaded replacement, with test changes discarded. Wes was notified Tensity could reopen.
- Validation archive uploaded and downloaded/hash-verified: `Property/Project Template/Validation Evidence/tensity-delete-validation-20261003-1909.zip`, item `01ZGFUBDLKZPRO4JFYSFD25CKLCFXGXG5Y`, SHA256 `46A44B5F6235AB21607EAEA92C7E6C8C99DA61A5F1D3F107462AED2778E54E69`. Includes before/after native snapshots, preservation audit, pre/post-delivery functional tests and PDF/image checks. Superseded local working copies are removed after this verification; rollback and evidence remain in Teams.
- Lesson reinforced: an owner's closing save can change the version after a prepared candidate is validated. Rebuild against the new current source, rather than treating closure as permission to overwrite the newer save.
- Implementation/rules commit `1e0c1e5b` was local only; no Git push is authorized.
