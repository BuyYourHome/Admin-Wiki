# Tensity Grid-Selected Recurring Bill

## Request and Source

October 2: Wes requested Recurring Bill choose the vendor selected in the grid and confirmed Tensity saved/closed. Scope is this button in Tensity, not another-project rollout.

- Fresh Teams source: `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`, same item `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`. Initial save 18:21:20Z/version 1238 was superseded by the owner's 18:27:37Z/version 1240 save before his closure confirmation. Refetched and rebuilt on version 1240; no old snapshot overwrote his changes.
- Final source SHA256 `F92DADE531BDCEA21B6ED5DB924AF2A0DFAC9B16628CC8D46D736F6B8397B020`.
- Current rollback: `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-grid-recurring-20261002-1427.xlsm`, item `01ZGFUBDJGXJHBBAORBJA2L6ZYPT5ALALO`. Earlier 1421 rollback also retained in Teams, item `01ZGFUBDKEVECNLCAFIVAJM6DB33B4FQOD`.
- Baseline: 56 source records, $28,224.97 Profit carrying total, 17 existing errors. Fresh owner formatting preserved.

## Change

Only BYHCarryingEdit changes. The Recurring button resolves the single selected date/amount cell through ceEditGrid/ceEditHeaders and the source table, or accepts one source-table cell. It takes the selected record's Vendor and calls the existing prefill engine with the explicit row identifying its Category. This excludes unrelated vendors in the same category and other categories of the same vendor. Latest matching bill, recurring-date inference, explicit-date preservation and final Insert Record remain unchanged.

No selected bill, multiple cells, another worksheet, a blank vendor, protected/read-only state or active edit is rejected without replacing the entry form. Failed prefill restores the temporary vendor assignment, preserving its formula/format. Context guidance now describes grid selection. No new source rows, names, layouts or financial assumptions.

## Validation

Whole-workbook content/style/name/table/validation/layout audit passed with zero issues; all 17 existing errors remain. All 31 other VBA modules preserved exactly. The updater gates the starting editor against approved commit a9b1ae86 with only documented VBE capitalization normalization.

Native tests passed on both the first candidate and rebuilt owner save: grid date/amount and table selection, rejection of header/multicell/other-sheet/empty selection, wrong form vendor ignored, selected category isolated from another category sharing the vendor, blank vendor rejection, entered-date formula preservation, month-end inference, irregular-history blanks, active-edit/protection guards and no insertion. All 56 records and total preserved; test edits discarded.

Live Teams replacement saved October 2 at 18:36:26Z (2:36:26 PM Eastern), after unchanged version 1240 was reconfirmed. Downloaded bytes match SHA256 `CAD8DBD622B0CFF6C2AEB4E628186BE892160AAA5D63126FBD202DA95C8B3AC1`. Final downloaded native tests passed; test changes were not saved. Rollback retained; no other project changed. Wes can reopen it.

## Lessons

- Tensity's Private Money history contains both the category-default Vendor and Neal Isaacs. Use the selected record's actual vendor, not its category label or a form value left from another action.
- Irregular/fractional historical dates may produce no date suggestion; a vendor with only one record also lacks enough history. Preserve the existing safe inference rather than forcing a guessed date. Test reliable month-end inference separately with discarded synthetic data.
- PowerShell functions can enumerate a multi-cell COM range on return. Read the named merged context range directly rather than treating an enumerated array as a native Range.
- Other-project migration remains subject to the existing approval and independent mapping gates. No push authorized.
