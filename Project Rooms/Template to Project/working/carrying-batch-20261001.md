# Carrying Batch - October 1, 2026

Wes confirmed remaining active workbooks saved and closed. Continue the approved batch using fresh Teams sources, independent maps, grid-authoritative corrections and Category defaults only for blank Vendors. No push requested.

## Rose - Delivered

- Same Teams item `01ZGFUBDNXYJNAKFRLTNDLLP2SWMYIHHCJ`, saved 2026-10-01T12:16:37Z. [Open Rose](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B055AC2B7-2B16-469B-B5BF-52B330839C49%7D&action=default).
- Source saved 2026-09-24T13:00:07Z; version checked immediately before replacement. Rollback: `Property/Project Template/Rollback Copies/28_Project Management - 320 Rose Pl.before-carrying-20261001.xlsm`.
- Independent map: `tools/carrying-entry/maps/20261001-28.json`. Grid A17/B17 held June 17, 2026 / $66.61; matched table row 16 held date serial 46190.42 and zero Amount. Preserved correction and original coordinates/values in Notes.
- Filled 152 blank Vendors before cleanup. Recovered the grid bill first, then removed 115 literal-zero Amount rows; 37 records remain, including ten blank Amount records. No blank records treated as zeros.
- Duke total $963.11 -> $1,029.72; Profit Carrying $13,340.98 -> $13,407.59. No template financial records copied.
- Installed form, same-size recurring button, Vendor selector, date inference, Labor, Review destination, Docs rent reference, and Profit Labor/date-reference changes. Automatic calculation verified.
- Full source/stage audit: no unintended cell/style/merge/table/name/control changes, no external links or new errors. Two existing Profit errors removed; 319 unrelated saved errors remain. This migration does not certify those unrelated formulas.
- Zero cleanup preserved every surviving record. Native comparison verified all 39 VBA component sources unchanged by cleanup. Visual Carrying/Profit previews passed.
- Delivered SHA256 `AE532E1395D037F4BF0C23D170108572B8FD5EC4044B4744171E6D1B00FE2ACF`. Connector download matched exactly and passed native unsaved insertion, duplicate, credit, Include, recurrence, date/amount pair, Review marker, Docs and mode-control tests. No synthetic test records saved.

## Cool Springs - Delivered

- Same Teams item `01ZGFUBDMNVSURGFMGXNBZUOMLQBCSV4MU`, saved 2026-10-01T12:23:23Z. Fresh rollback in the same rollback folder, filename `22_Project Management - 2325 Cool Springs Rd 4.before-carrying-20261001.xlsm`.
- Independent map `maps/20261001-22.json`. Filled 133 blank Vendors, removed 35 literal-zero rows; 98 records remain. Seven blank Amount records retained. Carrying total remains $25,807.15; existing tax escrow offsets preserved.
- Full-workbook audit passed: Amortization values/formulas/design were not replaced; source records/styles, names, controls and links preserved apart from the explicitly mapped Carrying/Profit/Docs/Review design changes and Excel's native reference updates. Source had 12,219 error cells (12,210 in Amortization); two Profit date-reference errors removed, no new errors. Existing Amortization errors are outside this change and remain unresolved.
- All 33 VBA sources unchanged through zero cleanup. Local and exact Teams-download insertion/recurrence/control/date-pair tests passed, 98 pairs; visual Carrying/Profit previews passed. No test rows saved.
- Delivered SHA256 `FD52D77BFB2CF6615DCC99A8E5397ABED4B406EBCDE1FC44736F7B54970A446C`.

## Britton - Delivered

- Same Teams item `01ZGFUBDO5QEQ7M544BRELUSIAOY3CVLKE`, saved 2026-10-01T12:28:04Z. Rollback `25_Project Management - 612 Britton Ct.before-carrying-20261001.xlsm` in the same Teams rollback folder.
- Independent map `maps/20261001-25.json`. Filled 133 blank Vendors, removed 99 literal-zero rows; 34 records remain, including 19 blank Amounts. Carrying total remains $18,176.28; tax escrow offsets preserved.
- Source/stage and cleanup audits passed, all 30 VBA sources preserved through cleanup, no new errors. All 66 preexisting errors remain; this includes unrelated Profit/Gnatt/Amortization/MOG defects, not repaired by this migration.
- Local and exact Teams-download tests passed (34 displayed pairs, recurrence, controls, insert, duplicate, credit and Include behavior). Visual previews passed; no test records saved.
- Delivered SHA256 `4465C34D637CE3335AB1B802DED28845DD567AFE50682FF3E3569A4300160D58`.

## Batch Exceptions

- Cool Springs and Britton: delivered as recorded above. Cool Springs Amortization remains excluded.
- Tensity: completed as recorded below.
- Pleasant Garden: completed as recorded below.
- Banks and Rosebrooks: Wes explicitly deferred both on October 1 for separate review before migration. No live changes. Their legacy grids have no Carrying table and include formula-generated schedules, not only recorded bills. Profit links currently read incorrect positional grid cells (including dates as monetary values). Banks' current Profit Carrying total is $45,684.97; Rosebrooks' is $236,584.00; these are observed results, not validated costs. Rosebrooks payment formulas use blank Profit!J71 as a cutoff. Rosebrooks C9 is text `Net Income:` rather than rent; Docs linkage is deferred. Banks K34 has $182.76 insurance without a date; Wes deferred its disposition. Preserve the questions and independently review these two before any migration.
- Pinetree: no Carrying tab/history. Asked Wes whether to add an empty interface while retaining the existing $890.28 monthly mortgage estimate; no payment records will be invented.
- Pond: already enhanced and verified read-only. Current Teams save 2026-09-30T21:52:40Z remained current at final metadata check. Both Entry and Prefill sources exactly match canonical modules; unsaved entry, duplicate, credit, Include, recurrence, all 75 date/amount pairs, mode selectors, Review marker and Docs tests passed. All 75 records and $33,864.65 unchanged; existing $94.40 Labor record preserved. No upload or live edit.

## Pleasant Garden - Delivered

- Same Teams item `01ZGFUBDOJANAWG5C6NBFKWD57UBKLDLF4`, saved 2026-10-01T12:36:09Z. Rollback `18_Project Management - 1426 Pleasant Garden Ln.before-carrying-20261001.xlsm` in Teams rollback folder.
- Independent map `maps/20261001-18.json`: existing table already AL:AV; 130 records and 43 display rows. Preserved existing record values and filled 130 blank Vendors. Added only the actual July 1, 2026 HOA bill from V11/W11 ($253.65), retaining the January bill and recording provenance. Removed two literal-zero HOA rows; final 129 records at AL2:AV131.
- HOA $1,373.75 -> $1,627.40; total $73,402.88 -> $73,656.53. Grid retains 43-row capacity, footer row 51, all 129 pairs visible and matched. Empty Excavator/Lawn categories now connected to their local totals; Labor added. Existing correct Profit date-reference formula retained.
- Source/stage audit, zero-cleanup audit, all 29 VBA-source preservation checks, controls, formatting and visual previews passed. No preexisting or new saved formula errors. Local and Teams-download unsaved entry/recurrence/duplicate/credit/control tests passed.
- Delivered SHA256 `8DC9A6996EA234A82CE1A23168E2089BF35F9217DBED38BDBDDEB8BA7F8B82A5`.

## Tensity - Delivered

- Same Teams item `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`, saved 2026-10-01T12:41:39Z. Final source is Wes's 12:35:28Z closed save, after two freshness gates detected newer versions. Fresh final rollback `24_Project Management - 4121 Tensity Dr 2.before-recurring-date-20261001-123528.xlsm` in Teams rollback folder; earlier version-specific rollback snapshots retained there as well.
- Only `BYHCarryingPrefill` upgraded from verified baseline commit `fd6d6554` to canonical date inference and Vendor + Category matching. All 30 other VBA component sources unchanged. No layout change or table cleanup needed.
- Preserved all 45 expense records, pending form entries, $20,530.49 total, every worksheet formula/value/style, table, named range, control and validation. Source's 17 unrelated saved errors unchanged. Full module-only audit passed.
- Local and exact Teams-download native tests passed: all 45 date/amount pairs, mode selectors, Review marker, Docs rent, recurrence/date-formula preservation, insert/duplicate/credit/Include behavior. No synthetic records saved.
- Delivered SHA256 `5B929FBAEDD9D725DD76C3B7C7EE7EB486BFD68A4F190646382A88DCAA399A8B`. Wes was told Tensity is ready to reopen; no further Tensity writes in this batch.

## Completion Status

Seven of ten active workbooks are current for this approved Carrying package: Outrigger (prior completion), Rose, Cool Springs, Britton, Pleasant Garden, Tensity, and Pond (verified already current). Banks and Rosebrooks are explicitly deferred by Wes. Pinetree is unchanged pending the mortgage-estimate decision. Do not claim the full ten-workbook rollout complete.

No other room or shared Admin files edited. No push requested or performed by this chat. Current workbook bytes and rollback versions are in Teams; superseded local working files will be removed after verification.

## Lessons

- Source file freshness can change the record baseline between migrations; never reuse earlier log totals as the target's current truth.
- Formula comparison must normalize Excel serialization whitespace outside quoted strings without erasing intersection operators or meaningful string content. Resolve shared formulas before comparing.
- Cleanup can legitimately change the Vendor helper's cached spill. Verify it against surviving Vendor values rather than demanding stale cached strings remain.
- A VBA binary change is not a source-code proof. Compare every native component's source before accepting a cleanup save.
- Preserve each project's display capacity; do not truncate a larger grid to the prototype's 21 rows.
- Pleasant Garden's old grid started at row 3, unlike Rose's row 4. An ordinal-only match would have incorrectly replaced its January HOA bill. Check the actual first detail row and every neighboring bill before matching an override; the July bill was a separate missing table record.
- Tensity changed in Teams during preparation (12:19:33Z save). Replacement stopped at the version gate. Fresh source showed owner-entered Water form values; Wes reconfirmed closure. Rebuild from that fresh source and preserve the pending form; do not upload the already-tested older copy.
