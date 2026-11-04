# Pond Others Synchronized Sort

## Authority And Source

Wes moved the override table beside the main Others table, saved and closed Pond, then authorized implementation of synchronized sorting with the calculated price column hidden. Scope is Pond Others only; no Tim changes or active-project rollout.

- Live workbook: [908 Pond](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&action=default).
- Teams item: `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`.
- Fresh connector source saved November 4, 2026 at 9:03:48 AM Eastern; ETag suffix 248.
- Source SHA256: `847F1D0CE518EEFB024EA451522C4A8FB789DA94250A9B777B1DE2BF13746D9F`.
- Verified rollback: [26 Pond before Others synchronized sort 20261104-0906.xlsm](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B1455885F-3E59-4738-956C-3593FC2F8857%7D&action=default), under `Property/Project Template/Rollback Copies`, item `01ZGFUBDK7RBKRIWJ6HBDZK3BVSP6C7CCX`. Downloaded hash matches source.

## Design

- Preserve the owner's main table at A4:P57 and override input columns T:W. Hide calculated Unit Price 2 at H. The editable yellow price column is V, found by header `Unit Price Override`, not a hard-coded position in the synchronization routine.
- Add hidden `_Display Order` to the override table at X. Align whole records with the current main-table Index order. Index-based pricing remains the authority; row position is presentation only.
- Preserve all 53 existing override records, including explicit zeros and blank Contract fallbacks. Existing owner value for Index 208 is $1,500 and remains unchanged. This task does not restore an older $2,000 value.
- New main-table indexes receive a blank override. Inactive override records remain below active items so returning items recover their original prices. Duplicate/invalid keys are rejected, not silently reassigned.
- Preserve the main table's existing Approve = Yes filter and hidden rows while aligning all data. Native sorting of a neighboring table otherwise skips hidden rows. Separate override-table filters and unsupported special filters stop alignment with a status warning.
- Initialize on workbook open and Others activation/selection. Sort/change/calculate/query-refresh events schedule an idle callback. Scheduled callbacks are cancelled on close. Macros must be enabled for automatic visual alignment; the price formulas remain Index-based without macros.
- Keep existing Full Recalc button bindings and procedure, adding only the scheduled alignment callback before its existing completion message. Alignment waits while the Others query is refreshing. Existing Full Recalc/checkbox behavior is not redesigned; its reminder remains separate. A broader trial was discarded after a long-running full-workbook calculation; it was not published. The final alignment itself batches changes under temporary Manual calculation and restores the caller's settings.
- No table records are deleted by the production synchronization code. Disposable tests do not use native ListRows.Delete beside the query table because that operation disturbed adjacent rows in this workbook.

## Validation And Delivery

Delivered to the original Teams item November 4, 2026 at **10:00:38 AM Eastern**. The source ETag was still 248 immediately before replacement. Exact downloaded SHA256 matches the validated candidate: `00A9819CAD459B3FDDC67BA2F35C02BFA6BCD968CF2CD9ADE68F6FC0A50F874A`.

- Native preservation checks compare all queries, defined names, shapes/button bindings, workbook links and original VBA modules. Only Others events and the explicitly integrated ThisWorkbook lifecycle/Full Recalc code may change.
- Independent read-only workbook audit compares formulas, constants, styles, effective row heights, column widths, tables, filters, print settings, merged cells, validation, media, external links and new errors. It passed on the final candidate with no issues.
- Failed candidate builds and test-only changes were never uploaded to the live Teams item. Early validation exposed VBA identifier case changes, filtered-row sorting and Excel busy timing; these were corrected before delivery.
- Saved candidate reopened in Automatic calculation. Native tests passed for reverse main sort, override-table sort, automatic price edits, event-driven title sort and query refresh, temporary removal/return of an assigned item, retaining inactive prices, adding a missing blank override, rejecting duplicate keys, and restoring Manual calculation/events settings. All 53 original prices and computed Unit Price 2 values were unchanged at the end. Test changes were discarded.
- Exact downloaded Teams workbook passed the same native test suite; all test changes were discarded. Wes may reopen Pond. All isolated Excel test processes closed.
- Validation archive: [Pond Others synchronized sort validation 20261104.zip](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/Project%20Template/Validation%20Evidence/Pond%20Others%20synchronized%20sort%20validation%2020261104.zip), item `01ZGFUBDLEIFRF5LJYFJB3MCJQS42YURH5`. Its downloaded SHA256 is `6A5E3A5424758D82E6D1608420F56E0BD95331A5C8CD4EDCC094AE9CD4F22B36`, matching the local archive. Includes source/result metadata, preservation audit, saved/delivered native results and the rendered preview. Rollback remains in Teams; superseded local source/build/test copies are removed after archive verification. The exact delivered workbook is retained as the current review artifact.

No push authorized. Unrelated Dashboard working changes remain untouched.
