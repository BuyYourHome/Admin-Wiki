# Pond Price Override At Left

## Authority And Source

Wes approved moving Unit Price Override to the first column of the adjacent Others override table and confirmed Pond saved and closed. This is a column-layout follow-up only, not a price change, macro redesign or other-project rollout.

- Live workbook: [908 Pond in Teams](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&action=default), item `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`.
- Fresh connector source: November 4, 2026, 11:00:11 AM Eastern; ETag suffix 251; SHA256 `316DBB280BFAC55D8037DEFA55F0193545D2F6782BF99516E9305D3D3A55C0ED`.
- Verified rollback: [26 Pond before price override column move 20261104-1103.xlsm](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BE2A78E76-6FA1-4D20-8382-972DEED06004%7D&action=default), item `01ZGFUBDLWR2T6FILPEBGYHAUXFXXNAYAE`, under `Property/Project Template/Rollback Copies`. Downloaded bytes match the source hash.

## Change And Validation

- Table remains `tblOthersPriceOverrides` at `Others!T4:X57`. New order is T Unit Price Override, U Index, V Item, W Mapping Note, hidden X _Display Order. Calculated H remains hidden.
- Moved the native table column, preserving its yellow currency formatting and carrying the existing column widths with their fields. Merged banners and the main table remain in place. Existing Approve = Yes filter and hidden-row state preserved.
- All 53 override values, including explicit zeros/blanks, and computed Unit Price 2 values remain unchanged by Index. No workbook VBA was edited. Queries, names, links and shapes/button bindings match the source exactly in native inspection.
- Reapplied the existing synchronization sort after moving the column; Excel's initial cut/insert left the saved sort-state range starting at U rather than T. The final range covers the complete table. Validation identifies columns by header rather than the former V address.
- Independent whole-workbook audit passed with zero issues: mapped cells/formulas/styles, widths, effective heights, merged cells, table schema and sort state, print settings, data validation, media, links and error state preserved outside the approved column permutation.
- Final candidate SHA256: `67BC49E1A087B514804C63A00806A5EB498181F83545C0B722C639405E69DE61`.

## Delivery

Saved to the original Teams item on November 4, 2026 at **11:15:50 AM Eastern**. The source ETag remained 251 immediately before replacement. Exact downloaded SHA256 matches the final candidate above.

Saved-file and exact downloaded-file native checks both passed: Automatic calculation on reopen, immediate price updates, whole-record sorts, query refresh with temporary reassignment/removal/return, new and duplicate Index handling, and restoration of Manual calculation/events settings. All 53 prices and computed values matched the source; all test changes were discarded. Wes may reopen Pond.

Validation archive: [Pond price override column validation 20261104.zip](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/Project%20Template/Validation%20Evidence/Pond%20price%20override%20column%20validation%2020261104.zip), item `01ZGFUBDKXOADP3ULSKBEZLTQ5VVRLNHVR`. Downloaded SHA256 matches `FAE192885FBAA616F8E50A2E225B0EE8FDC02953ACB822BCF7C3DF1B0F920176`. Source/result native metadata, preservation audit, preview PDF and both functional test results retained there. Superseded local working copies are removed; rollback remains in Teams and one exact delivered copy remains as the current review artifact.

The separate Full Recalc/checkbox reminder remains unresolved. No push authorized; unrelated Dashboard changes are untouched.
