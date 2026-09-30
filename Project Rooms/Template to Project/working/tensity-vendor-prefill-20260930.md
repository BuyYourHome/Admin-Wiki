# Tensity Vendor Prefill - September 30, 2026

## Scope And Source

Wes approved Tensity-only Carrying Vendor selection, a same-size Recurring Bill button beneath Insert Record, and filling existing blank Vendor fields from Category. Tensity was confirmed closed. No operational invoice posting, Pond edit, or other-project rollout was authorized.

- Live workbook: `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`.
- Teams item: `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`.
- Fresh source save: `2026-09-30T20:41:50Z`; checked unchanged before replacement.
- Source SHA-256: `4574849559988C18F92A6E7BAD70A260847F43EA7B81354F14B9DE717200D6BC`.
- Rollback: `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-vendor-prefill-20260930-2045.xlsm`, item `01ZGFUBDKAPUMCDBQNJRGKNUIKS7CE7JN6`.
- Replacement save: `2026-09-30T20:57:34Z`, same live item/name.
- Delivered and downloaded SHA-256: `E438D4C2A5FE0744F27BF7133F3C34DCC634CAEA50A2F953E899C1250B4C5BF9`.
- [Open Tensity](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BFB8825B0-06EF-4B3E-8015-A106EEEA5C7C%7D&file=24_Project%20Management%20-%204121%20Tensity%20Dr%202.xlsm&action=default).

## Mapping And Behavior

All 41 blank Vendor fields in `tblCarryingExpenses` were filled from their row's Category; no other source field changed. Dropdown choices: Duke Electric, HOA, Mortgage Payment, Private Money, Property Taxes, Water. The list is dynamic and permits new manually typed vendors. These labels are not independently verified supplier identities.

`ceVendorList` reads the AX2 spill; AX is hidden. Vendor input remains G2:K2. Added `ceRecurringButton`, with matching Insert Record dimensions, directly below it; feedback name moves W3 to Z3 to avoid overlap. Existing form style, merges, grid, tables, print settings, formulas and previous VBA source preserved. The separate VBA module fills form fields only, never inserts or saves.

Latest matching record seeds Category, Vendor, Description, Amount and Include. Date is retained; prior invoice/source-file/notes are cleared; Source/Status reset to Manual Entry/Entered. Different bill types require explicit source-row selection. Blank latest amounts remain blank; dates are not advanced and recurrence is not inferred. Future-dated existing rows remain eligible.

## Verification

- Hidden native Excel normal open and Automatic calculation; no visible apps launched or security settings changed.
- Functional tests passed: dropdown, button geometry, blank/unknown vendor, latest record, preserved input date, cleared provenance, filtered rows, blank amount, ambiguous bill types, explicit row, credits, Include No and dynamic dropdown expansion/contraction.
- Existing Insert Record tests passed: required fields, literal text, leading zeros, immediate Labor/Profit calculation, repeated clicks, filtered duplicates, negative credit and exclusions. Test rows discarded without save.
- All 41 grid date/amount pairs, Flip/Hold/Slow Flip selectors, Review marker and Docs rent link passed. Docs rent remains $1,850.
- Full raw-cell/style/table/name preservation audit passed after resolving Excel differential-format renumbering. Original macro sources verified unchanged during installation.
- Source records: 41 before/after. Profit B43: $17,416.09 before/after. No new external links or error cells. Seventeen pre-existing unrelated error cells remain; no whole-workbook financial certification implied.
- PDF preview reviewed: matching stacked buttons fit above the grid; form formatting preserved.
- Teams replacement downloaded and SHA-256 matched the tested local output. Both prefill and existing insertion test suites passed again on the exact downloaded file; no test edits saved.

## Lessons And Limits

Latest records may have blank amounts (Duke Electric/HOA); preserving the blank avoids silently reusing a stale bill amount. Category-as-Vendor requires owner approval per project. Reusable VBA uses names/headers, but installer and pilot tests require independent project mapping before rollout. The dynamic LET list adds Excel's hidden `_xlpm.v` compatibility name; this is not a new error cell.

Wes authorized the specific remote merge before implementation; unrelated dirty Admin/Dashboard files were preserved. Scope source/rules/tests/logs are committed locally, not pushed. Rollback remains in Teams; temporary workbooks are removed after verification.
