# Full Carrying Rollout - October 2, 2026

## Authorization

Wes requested Casa Lending renamed to Refinance and migration to other active projects. He explicitly confirmed **Complete updated Carrying design** and **all saved and closed**. Prototype is the current Tensity Teams save at 2026-10-02T19:19:36Z, SHA256 `802B75063F71ACB68E9613673D2A5546E5D4CFC040DF06D9B1E06127E4A3FDA3`.

Scope includes current row editor, selected-grid recurring bills, next-date suggestions, five-button toolbar and context instructions, owner green instruction/result formatting, yellow inputs, orange category grid, consistent widths and separate Rent income. No Rent expense or new Profit income connection. Preserve Cool Springs Amortization.

## Independent Maps

Fresh connector downloads from the live Property folder were inventoried separately. No manual grid overrides were present in the eight existing table-based Carrying sheets. Blank Vendors were already filled; nonblank vendors remain unchanged. Only Pond has existing Casa Lending category records (seven); those categories become Refinance, with Vendor fields retained.

| Project | Records Before / After | Grid Capacity | Expense Total Before / After | Status |
| --- | --- | --- | --- | --- |
| Tensity | 56 / 56 | 21 | $28,224.97 | Delivered; exact Teams hash verified |
| Pond | 90 / 90 | 21 | $44,776.50 | Delivered; exact Teams hash verified |
| Rose | 37 / 37 | 21 | $13,407.59 | Delivered; exact Teams hash verified |
| Pleasant Garden | 129 / 129 | 43 | $73,656.53 | Delivered; exact Teams hash verified |
| Rosebrooks | 24 / 24 | 21 | $10,848.20 | Delivered; exact Teams hash verified |
| Cool Springs | 98 / 98 | 21 | $25,807.15 | Delivered; exact Teams hash verified |
| Britton | 34 / 34 | 21 | $18,176.28 | Delivered; exact Teams hash verified |
| Outrigger | 127 / 126 | 21 | $19,473.95 | Delivered; exact Teams hash verified; one literal zero removed |
| Banks | Legacy grid | Pending | Not certified | Earlier legacy-schedule review gate; specific approval requested |
| Pinetree | No Carrying | Pending | Existing $890.28/month estimate retained | Earlier empty-interface/estimate gate; specific approval requested |

Inactive exclusions remain Old Buckhorn, Burgwyn, Pearces, Sandy Run, Larchmont, Willowdell and Mom. Rosebrooks' earlier rent/Docs question is outside this change. Its current source no longer contains Carrying - Old; this rollout did not delete it.

## Preservation and Tests

- Original source table records are checked field-by-field, including excluded rows, blanks, formulas, dates and source references.
- Existing enhanced projects move from header row 5 to row 7 by native whole-row insertion. Rent uses AK:AM; source table moves from AL:AV to AO:AY and Vendor helper AX to BA. Pleasant Garden retains its 43-row grid and subtotal row 53; other subtotals are row 31.
- Preserve target pending manual-form fields and project-specific property-tax/escrow formulas. No prototype bill values or escrow assumptions are imported.
- Preserve every existing VBA module; add the current BYHCarryingEdit module where absent and redirect only the Carrying buttons. Entry and Prefill sources must match the approved source before proceeding.
- Native unsaved tests verify every displayed date/amount pair, no overflow, edit/save/cancel, selected-grid Vendor/Category, suggested next month-end date, instruction messages, insertion guards, Rent excluded from expenses, and Labor/Refinance included in Profit.
- Audit all other sheets' values/formulas/resolved styles, names, table schemas/styles and print settings. Distinguish existing errors from new errors; no unrelated repairs.
- Recheck live Teams modification metadata immediately before same-item replacement; download replacement, compare SHA256, and run native tests again without saving.

## Teams Deliveries

All replacements retained their original item identity and filename. All eight preservation audits reported zero issues; native functional tests passed. Every downloaded replacement then passed normal native reopen, saved VBA source verification, real-grid record editing/recurring selection, and checkbox-link tests without saving. Existing unrelated error counts stayed unchanged: Tensity 17, Pond 110, Rose 319, Pleasant Garden 0, Rosebrooks 1, Cool Springs 12,217, Britton 66, Outrigger 2. These existing errors are not certified correct or repaired by this design migration.

| Project | Verified Teams Save (UTC) | Live Workbook |
| --- | --- | --- |
| Tensity | 2026-10-02 19:51:15 | [Open Tensity](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BFB8825B0-06EF-4B3E-8015-A106EEEA5C7C%7D&action=default) |
| Pond | 2026-10-02 20:01:52 | [Open Pond](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&action=default) |
| Rose | 2026-10-02 20:02:13 | [Open Rose](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B055AC2B7-2B16-469B-B5BF-52B330839C49%7D&action=default) |
| Pleasant Garden | 2026-10-02 20:02:29 | [Open Pleasant Garden](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B634103C9-5E74-4A68-AB0F-BFA054B1ACBC%7D&action=default) |
| Rosebrooks | 2026-10-02 20:03:53 | [Open Rosebrooks](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B5EC3294D-9743-47F7-8692-B607638A1E26%7D&action=default) |
| Cool Springs | 2026-10-02 20:04:08 | [Open Cool Springs](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B13A9AC8D-8615-43BB-9A39-8B80452AF194%7D&action=default) |
| Britton | 2026-10-02 20:06:03 | [Open Britton](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BF62181DD-9C77-480C-BA49-0076362AAD44%7D&action=default) |
| Outrigger | 2026-10-02 20:06:16 | [Open Outrigger](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BBAFDD468-E840-4D85-9AE4-FC5C59512E62%7D&action=default) |

## Rollback and Evidence

Rollback copies for the eight existing Carrying projects are in Teams `Property/Project Template/Rollback Copies`. Each keeps its live basename with suffix `.before-full-carrying-20261002-1522.xlsm`. All eight rollback uploads succeeded before their local edits.

Native previews, mapping inventory, VBA snapshots, test/audit results, final hashes and delivery metadata are archived in [Teams validation evidence](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/Project%20Template/Validation%20Evidence/Carrying%20full%20rollout%20validation%202026-10-02.zip), item `01ZGFUBDPMVIBRIFNDMNE3WZ56C2NSZ23A`. No test records were saved. Working binaries remain outside Git and superseded temporary workbook copies are removed after verified delivery. No Git push authorized.

## Lessons

- Hidden Excel preparation caught merged-cell clearing and nullable control-font handling before delivery; clear complete MergeArea ranges and preserve typed values when restoring linked controls.
- Recreating the Include checkbox reset its linked Boolean in a local candidate. The source value was restored and checked before delivery.
- Pleasant Garden's longer grid caught a relative-footer-header reference error in a local candidate. Use explicit anchored category headings and validate every subtotal independently.
- Native save renumbered Tensity differential-format IDs. Resolved definitions matched; audits must compare meanings, not IDs.
- Preserve printable-button settings explicitly when creating native controls; screen visibility alone does not establish PDF/print behavior.
