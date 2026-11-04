# Pond Active-Item Alignment And Column K

## Scope And Source

- November 4, 2026 follow-up began at 1:50 PM Eastern. Wes reported new Index 214 out of alignment and requested one extending column K rule, then authorized the closed-workbook repair with `go`.
- Target: 26_Project Management - 908 Pond St 3.xlsm only. No other project or Full Recalc redesign is included; no push authorized.
- Fresh Teams source: ETag 280, saved 1:44:51 PM Eastern. SHA256 `7705EAC59FF8F322F6B081D6F9ED6FA61A048F8E60F0C1D473718B9DC7504975`.
- [Live Pond workbook](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&action=default).
- [Verified rollback](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BE1DACC1F-8E2D-4976-979C-B0A83F0D7C8C%7D&action=default): Property/Project Template/Rollback Copies/26 Pond before active-row and K-rule repair 20261104-1350.xlsm. Downloaded hash matches source.

## Diagnosis And Mapping

- The current left query has 183 records, while Contract_Edits has 270, including unused records. Index 214 appeared at left row 207 and right row 209 because unused 212/213 had the same calculated Order and preceded it in a global sort.
- Whole editable records must follow the active query's exact Index sequence, with inactive records retained below it. Index, not physical row or Order alone, determines the match.
- Preserve the current Glasgow DB filter and include filtered-out rows in alignment. Preserve all 270 complete records, including legacy inactive duplicates 237/913.
- Six fragmented K rules included broken references; the valid rule stopped at K205. Replace only the data-region mismatch rules with one `=AND($J25<>"",$J25<>$L25)` rule applying to K25:K1048576. Preserve unrelated summary formatting above the data region.
- Preserve the owner's query change removing Glasgow's Unit Price 2 from the Gnatt input. Index 214 retains $807.41 and its existing editable dependency 196; do not change approval or dependency based on the different Contract dependency.
- The existing inactive Index 257 uses `=+L251+1` at L291 in the repaired layout. Adding an active row legitimately moves both that formula and its referenced record by one row. Its relative reference and evaluated Index must remain unchanged; exact A1 text alone would falsely reject this native adjustment. Other fields still receive exact formula/input comparison. No Index formula is replaced with a guessed constant.

## Implementation And Validation Status

- Local alignment uses the existing calculated RowPos column as a temporary native-sort key with events and calculation suspended. Its exact formula is restored before calculation, refresh, return or save. No permanent helper, sheet or table is added.
- Source-table fingerprints and workbook source change/calculation notifications supplement native query watchers; testing must prove activation, not merely an already-aligned unchanged row count.
- Pond's worksheet QueryTables collections enumerated zero entries despite its Power Query ListObjects exposing QueryTable individually. The new source-change/calculation notifications provide the tested activation path; OLEDB connection state provides refresh coverage rather than relying on that empty collection. Native refresh metadata records 15 connections, all saved with background refresh disabled.
- Full-refresh testing exposed a Power Query `Unit Price` missing-column dialog, despite the saved source tables containing that header. All 15 connections then refreshed successfully one at a time on the untouched source with macros disabled. The candidate serializes background query refreshes, preserves query text/commands and RefreshWithRefreshAll flags, and waits for both connection/table activity plus a quiet interval before deferred alignment. Full Recalc's separate checkbox/error-cleanup redesign remains deferred.
- Required unsaved tests: activate/deactivate unused 213; append/remove an independent test Index with its editable record; fragment/repair K formatting; verify matching/mismatching/unused-row colors; repeat rank, equal-rank, approval, refresh, cleanup and caller-state checks.
- Initial local testing found a newly introduced `Sub` ending with `End Function`. Wes saw the resulting compile dialog. No failed copy was uploaded. Corrected the terminator and added procedure-ending preflight checks before opening Excel; the isolated failed validation process was closed without saving.
- Pre-upload native tests passed: 183 original records; activation and true append increased to 184, removal restored 183; unapproval reduced to 182 and reapproval restored 183. Rank/tie, red-warning behavior, one-rule maintenance, caller-state restoration, protected-sheet failure cleanup, query refresh, Refresh All, idle stability, record preservation and final filter/rule checks passed. Test changes were discarded.
- The independent whole-workbook audit passed with no issues, changed query records or changed cached values. Original formulas, inputs, styling, dimensions, sheet settings, tables, names, shapes, links and other VBA were preserved. Workbook events changed only at the exact source-notification integration. Native refresh metadata confirms only background settings changed.

## Delivery

- Original Teams item `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB` replaced at 2:48:09 PM Eastern, ETag 281. Source ETag 280 was rechecked immediately before replacement; a fresh pre-upload download also matched the repair source hash.
- Delivered SHA256: `31828E261A9ED356F5256AF65BDE6C9A76520C3AC0738FC6B38B93E0F52B33B9`. Exact Teams download matches the tested output.
- The full native suite passed again on the exact downloaded Teams file, including activation, append, removal, approvals, formatting, filter preservation and Refresh All. Test edits were discarded. Wes was told he may reopen Pond.
- [Validation archive](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/Project%20Template/Validation%20Evidence/Pond%20active-item%20and%20K-rule%20validation%2020261104.zip), item `01ZGFUBDNZTADFOH7NWVGZ7YTULCO7RR47`, contains native build/test reports, independent audit, source connection probe and before/after previews. Downloaded SHA256 verified: `402AB3FCB9747D5E58ACFCF6A933ACA3BD4AC0C30736F4C0DE9D230C79F61751`.
- Verified rollback and validation evidence remain in Teams. Keep only the latest delivered local workbook for review; superseded working copies and scratch evidence are removed. No binary artifacts enter Git. Repair and lessons are committed locally; no GitHub push authorized.

## Remaining Boundaries

- Automatic synchronization requires enabled macros. Unsupported special filters, protection, missing/ambiguous active indexes or refresh failures are reported instead of guessed away.
- Existing inactive duplicate indexes and the separately deferred Full Recalc button redesign remain outside this repair. No financial inputs or other project workbooks changed.
