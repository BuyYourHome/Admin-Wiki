# Tensity Carrying Row Editor

## Authorization And Delivery Gate

Wes requested an implemented quick row editor in Tensity, not a design discussion. Scope is Tensity Carrying only; no rollout to other projects was requested.

Status: implemented and validated in a local copy; live Teams workbook has not been replaced. Saved/closed confirmation was requested and remains unanswered. Once confirmed, refetch current Teams bytes and reconcile any changes before replacing the same item, then verify the exact downloaded hash and rerun unsaved native tests. Do not ask for another design approval or repeat go.

## Source And Rollback

- Target: `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`, item `01ZGFUBDNQEWEPX3YGHZFYAFNBA3XOUXD4`.
- Source version 1226, saved 2026-10-01T17:59:35Z; fresh Teams connector download. SHA256 `EE5A2BA71E6F828B72387C9920B6EA378646F52D9F0B34CE9FF03C20FBFC324A`.
- Source table: `tblCarryingExpenses`, AL2:AV58, 56 records and eleven columns. Included Carrying total/Profit B43 $28,224.97, including Labor $6,207.47. Do not use the earlier 45-record migration snapshot.
- Teams rollback: `Property/Project Template/Rollback Copies/24_Project Management - 4121 Tensity Dr 2.before-carrying-editor-20261001-2115.xlsm`, item `01ZGFUBDMY4FBFUAIFDBHJGF5V4X26JPAB`.
- Validated pending file: `%TEMP%\tensity-carrying-editor-final\24_Project Management - 4121 Tensity Dr 2.xlsm`; SHA256 `92137820384AD130E68BDF699AE7BFB220A63539103F0FE22468AE1D6C8448F6`.
- Fresh source remains `%TEMP%\tensity-carrying-edit-source-20261001.xlsm` for final delivery reconciliation; current result is not superseded while awaiting closure.

## Implemented Behavior

- Three native buttons alongside the existing buttons: Edit Record, Save Changes, Cancel Edit. Reuses the existing yellow input fields. No worksheet, table column, source record, grid formula or financial assumption was added or replaced.
- Select one date/amount cell in the friendly grid or one cell in the source table, then Edit Record. Grid mapping uses the current category, Include state, chronological date order and physical-order tie break, with date/amount checks against the displayed pair. A manually overwritten grid cell is not silently treated as its source record.
- Save updates only changed fields in one uniquely identifiable unchanged source row. Row identity uses the full original row/formula snapshot, not the remembered row number; sorting is supported. Missing, modified or indistinguishable duplicate source rows are rejected. Unchanged formulas, blank/space amounts, date fractions and provenance remain intact.
- Duplicate checks examine all table rows, including hidden/excluded records, using vendor/invoice or vendor/category/date/amount. Invalid changed fields are rejected without losing input. Credits, literal formula-looking text and leading-zero invoice identifiers are supported. This is not Invoice Entry's cross-destination reconciliation or approval workflow.
- Save or Cancel restores any form entry that existed before loading the record. Existing Insert Record and Recurring Bill buttons are guarded during editing; their original VBA modules are unchanged.
- Hidden workbook constant `ceEditActive` persists an unfinished edit. A close/reopen loses the in-memory row snapshot, so Save and Insert are blocked until Cancel clears the stale form and the record is loaded again. It never guesses a target from saved input values. Cancel's button asks before discarding unsaved changes.
- Source records are never deleted or appended by the editor. Macros do not save the workbook, send anything, refresh queries or post Review rows. Wes's normal Excel save/AutoSave applies.

## Validation

- Native hidden Excel installer preserved all 31 original VBA component sources and imported only `BYHCarryingEdit`. Current workbook filename is used in button bindings. Automatic calculation retained; no persistent security/trust settings changed and no visible app launched.
- Independent raw-XML/shared-formula and resolved-style audit passed with zero issues: all original cells, formulas, styles, records, table schemas, names, validation, merges, widths, heights, print settings and original controls preserved except the two intended button macro redirects. Four editor names and three controls added. No external links introduced.
- All 17 pre-existing formula errors remain; no new error or unrelated repair. Total stays $28,224.97.
- Unsaved native editor tests passed: grid load, single-field save, automatic Profit delta, pending-form restoration, insert/recurring guards, cancellation, no-op save, invalid category/date/amount rejection, blank/fractional-date preservation, filtered duplicate rejection, leading-zero identifiers, literal text, credits, Include edits, source formula preservation, concurrent-source-change rejection, sorting and protected-sheet handling.
- Separate disposable saved/reopened-session test passed: stale Save rejected, Insert blocked, Cancel cleared stale inputs, all 56 original records unchanged. Disposable test workbook removed.
- Existing manual-insertion tests also passed with the editor installed: checkbox, required fields, insertion, duplicates, credits, excluded records and automatic recalculation. All behavioral tests discarded test edits.
- Before/after PDF renders inspected. Buttons fit above the grid and do not cover feedback or existing controls. Preview: `%TEMP%\tensity-carrying-editor-after.pdf`.

## Lessons And Limits

- A no-argument VBA procedure name followed immediately by a colon can parse as a label. Use explicit `Call` or a separate line; test restoration behavior rather than merely a successful Save message.
- A protected-sheet rejection must not itself fail while writing feedback into the protected sheet. Feedback is best-effort; preserve the returned error and do not attempt a data write.
- Test closing/reopening an edit, filtered records, sort-induced row movement, unchanged source formulas and pending form entries. A remembered row index alone is not a safe edit identity.
- During a stalled protected-sheet test, only the identified isolated automation Excel process was stopped. The unrelated Teams Credit Cards Excel session was left untouched.
- No new instruction to roll this editor out to other projects, edit Invoice Entry rules, or push to GitHub was given. Delivery remains gated on Tensity closure and final freshness.
