# Pond Carrying Manual Entry

## Scope And Source

September 30, 2026. Wes approved adding a desktop-only, fully migratable manual-entry interface above Pond's Carrying grid and confirmed the workbook closed. He enabled VBA project-object access himself after the live Excel route proved unable to install a persistent macro button. No visible Excel window, global macro-security setting, registry setting, other project or Invoice Entry process file was changed by this implementation.

- Source: `Property/26_Project Management - 908 Pond St 3.xlsm`, fetched through Teams/SharePoint, saved `2026-09-30T17:48:54Z`, ETag version 72. SHA-256 `7040D5FF6B44840E5DDA861E80AB605D633285225DAAA93F4D2ADE8B4793CC85`.
- Exact item: `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`; drive `b!4mDJWAoUZEiObH1uIc-tPNklzEL-JwdPrMve0F7Efu7K7Z-rHQDJTLJE2cO-WifT`.
- Rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-manual-entry-20260930-1805.xlsm`, item `01ZGFUBDKOEBBB4PZMPND2BUNC3VYN5CZH`.
- Source includes 75 Carrying records, including the existing Labor test amount $94.40. This task did not post that record.

## Changes And Mapping

- Added yellow entry fields in Carrying rows 1:4, category dropdown, linked Include checkbox, Insert Record button and orange feedback. Defaults are Source Manual Entry, Status Entered, Include checked. No date or monetary amount is assumed.
- Added standard VBA module `BYHCarryingEntry` and `ce` input/configuration names. Module appends one verified record to `tblCarryingExpenses` by header, checks possible duplicates across all records and clears successful input only. No Review movement, source-file copying, approval, payment or automated save occurs.
- Following Wes's whole-block move instruction, moved `A1:AJ29` to `A1000:AJ1028`, then to `A5:AJ33`. The visible grid is `A5:AJ29`; the blank tail is included because hidden legacy formulas reference rows through 27. Source table remains `AL2:AV77`; spacer AK remains intact. Native ranges were reacquired after the first move.
- Reconnected automatically through native Excel movement: Profit B31:B42 now read corresponding Carrying row-29 outputs instead of row 25; archived Docs - Old 0704 B62 follows E5 to E9. No permanent rewiring to another sheet or external workbook was introduced.
- All existing cell formulas/constants outside those reference updates remain unchanged; the moved grid's formulas follow the complete block, including hidden formulas under subtotal merges. Existing macro component source was compared during installation and retained, with only the new module added.
- Existing table records, resolved cell styles, column widths, merges, defined names, table definitions, control properties, external links, print settings and all category totals passed source/output comparison. Native Excel renumbered differential-format and other package identifiers; resolved definitions were compared instead of raw ID numbers.
- Grid row heights were moved with the grid; new input rows use 19/25/19/25 points. Row height is worksheet-wide, so source-table rows sharing those new form rows have the same changed heights; no source-table contents or position changed.

## Validation

- Native hidden Excel reopened the saved file normally. Calculation mode is Automatic; original iteration settings were left intact. Insertion updated Labor and Profit immediately, without a recalculation command in the tests.
- Passed empty required-input rejection, invalid pasted category rejection, literal text beginning with `=`, leading-zero invoice identity, ordinary positive entry, negative credit, Include No, linked checkbox toggling, immediate second click, possible duplicate, duplicate hidden by a table filter, and duplicate of an excluded record. Rejected input stayed in the form. Existing events remained disabled and their state was restored by the macro.
- Test rows were added only in unsaved copies; final delivered table remains 75 records. Macro does not auto-expand the 21-row category display; it warns on category overflow while the full-category subtotal still includes every included record.
- Source/output XML audit reported zero unexpected formula/constant/style differences, zero missing merges, unchanged resolved tables and existing controls, and no external-link changes. No new saved Excel errors; 110 pre-existing workbook error cells remain outside this design repair. This is not a whole-workbook financial or legacy-macro correctness certification.
- Visual PDF inspection confirmed the four-row form, visible Insert Record button and Include checkbox, original merged totals, original grid formatting and unchanged category layout. No visible application was launched.
- Preserved totals: Duke Electric $738.47; Mortgage Payment $14,421.92; Private Money $5,500.00; Casa Lending $5,921.56; Insurance $0; Water $490.08; Natural Gas $698.22; HOA $0; Property Taxes $0 net; Excavator Rental $6,000; Lawn $0; Labor $94.40. Profit B43 remains $33,864.65; B41 remains 7.288446700507615; D43 remains -$33,864.65.
- Owner's current Profit L83 formula is `=IF(H83=0,0,+H75/H83*$F$75/DAYS(J75,H75))`, with L83 approximately 0.08183555 and L85 approximately 0.01363926. Preserved without changing its numerator or business meaning. Capture it by label during later approved full Profit migration; this observation is not endorsement of the calculation's assumptions.

## Teams Delivery

Confirmed the source Teams item still had version 72 immediately before replacement. Replaced the same item through the connector, not a synced folder. Teams save: `2026-09-30T18:36:25Z`.

Fresh connector download matched the validated SHA-256 exactly: `B409A17D1FB9561809745C3A850B5F383044B8FBDC0EFD348A066914D8D89BD1`.

[Open Pond in Teams/SharePoint](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&file=26_Project%20Management%20-%20908%20Pond%20St%203.xlsm&action=default&mobileredirect=true)

Post-upload native tests passed on the exact downloaded Teams file, including Automatic mode, checkbox linking, insertion, immediate Labor/Profit recalculation, filtered/excluded duplicates, credits, required fields, literal text and repeat-click prevention. All edits were discarded. No rollout to other projects is authorized by this prototype installation. Wes should turn off Trust access to the VBA project object model after installation; ordinary button use does not require that setting. Normal workbook macro trust still applies.

## Lessons

Use Wes's non-overlapping two-step move for a merged block, and include its referenced blank tail. Audit hidden merged-cell formulas rather than only visible anchors. Native Excel COM can invalidate moved Range handles; reacquire them. Avoid new VBA identifiers that recase old code. Keep full record and total preservation checks, transient macro tests, and the exact Teams round-trip hash as delivery gates. Detailed reusable rules and source live in Carrying Mode Rules and `tools/carrying-entry`.
