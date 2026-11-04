# Pond Gnatt Synchronization

The later [[pond-active-item-alignment-20261104]] follow-up supersedes this repair's all-record sort and filter restrictions. It adds active-first alignment, preserved ordinary filters, one extending K rule, source-event detection and serialized query refreshes.

## Scope And Authority

- Mode: Gnatt Chart. Target: 26_Project Management - 908 Pond St 3.xlsm only.
- Wes reported a mismatch beginning at Index 74, then confirmed Pond closed and said to proceed.
- Repair began November 4, 2026 at 12:46 PM Eastern. No other active project or Invoice Entry file is in scope. No GitHub push authorized.
- Source: current Teams/SharePoint connector download, ETag 265, saved 12:44:51 PM Eastern. Earlier read-only inspection version 264 was not the repair source.
- Source SHA256: `19E9F0FFDAF2F9E37CC94ED07DEFC2E44CCF6BAB3DB9198CC95D80FF61686FB9`.
- [Live Pond workbook](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&action=default).

## Diagnosis And Mapping

- First saved mismatch: Gnatt Chart row 109, left Index 74/Foundation versus right Index 184/Power Connection. Right Order values were not sorted.
- Others column J formulas were already restored in the latest owner save. No earlier literal approval edits were transferred or overwritten.
- Left query: qryContractsToGnatt, A24:J226, 202 displayed records. Right editable table: Contract_Edits, L24:AN294, 270 records.
- Source helper formulas depend partly on row position. Immediate event-triggered sorting did not stabilize/recheck calculated Order. Query sorting omitted the Index tie breaker used by the right table. Sorting errors were silently ignored.
- Preserved all editable records as a complete formula/input multiset, including dates, payments, approvals, ranks and notes. Existing inactive duplicate indexes 237 and 913 were retained, not resolved by guessing.

## Changes

- Added BYHGnattSync and BYHGnattQueryWatcher. Coalesced deferred events wait for idle refreshes, calculate and sort with bounded stabilization, refresh the Gnatt query synchronously, and verify the full displayed Index sequence.
- Native whole-record sorting preserves inputs. Caller calculation mode, events and screen updating are restored on success and failure. Errors appear in the status bar with an instruction to check Index before editing.
- Both sides use Order ascending, then Index ascending. No new worksheet, table, helper column or layout was introduced.
- Replaced the immediate Module1/Sheet8 sorting path and integrated native query watchers and open/close lifecycle cleanup. FullRecalcRebuild received only a synchronization callback; its existing refresh/checkbox design remains deferred.
- Kept the existing Others price synchronization, all other VBA, names, links, shapes, table schemas, filters, print settings, dimensions and owner formatting.

## Validation

- Native build: 202 of 202 displayed rows aligned; 270 editable records preserved.
- Independent whole-workbook audit: no unintended formulas, constants, styles, sheet settings, schemas, media or links changed; no new formula errors. Query records were identical by Index. Four contractor Order caches recalculated; their formulas were unchanged.
- Grid borders verified unchanged at their original worksheet coordinates. Other record formatting followed each record, consistent with native Excel Sort.
- Unsaved native tests passed: open alignment, rank 74 change and restore, equal-rank tie with 184, unapprove/reapprove 14 (202 to 201 to 202), Manual-mode preservation, protected-sheet failure cleanup, query refresh, Refresh All and final idle state.
- Initial local-only validation exposed an absent AutoFilter object. The direct VBA call caused Debug dialogs, which Wes dismissed. No failed build was uploaded. Corrected the object guard and added a handled text-result automation entry point. Subsequent tests did not expose an unhandled error.
- Initial upload was refused because a safety check compared against earlier inspection version 264. Re-fetched the live file and proved its ETag 265 and SHA256 matched the actual repair source exactly. Retried the same connector action with that evidence; no alternate access path or safety bypass was used.

## Delivery And Retention

- Replaced the original Teams item `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB` at 1:06:30 PM Eastern, ETag 266.
- Delivered SHA256: `642C597E59E844710FB77A8D36F12FDD197F8D75C367DDB4BCB357D5D303DFEA`.
- Exact downloaded Teams bytes match the tested output. The full native test suite passed again on the downloaded copy with 202 aligned records and all editable records preserved. Tests were not saved. Wes was told Pond could reopen.
- [Rollback: 26 Pond before Gnatt synchronization repair 20261104-1246.xlsm](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B6991D915-6F8A-4BB9-B226-A0C49ED9384C%7D&action=default), under Property/Project Template/Rollback Copies, item `01ZGFUBDIV3GIWTCTPXFF3EJVAYSPNSOCM`.
- [Validation archive](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/Property/Project%20Template/Validation%20Evidence/Pond%20Gnatt%20synchronization%20validation%2020261104.zip), item `01ZGFUBDPJM64SHHTDAJCJIUD2FZDE3RTR`. Includes native build/test reports, the independent preservation audit, and before/after renders. SHA256 `7D00E892D5D0F2CB358F655E4576C0D8B825ABCBFADE66EB14A29E0D42609C62` verified after download.
- Rollback download SHA256 matches the source exactly. Keep the final delivered local artifact for review; superseded local workbooks and scratch evidence are removed after these remote verifications. No binary artifacts enter Git.

## Remaining Boundaries

- Existing inactive duplicate indexes and unrelated workbook errors were not repaired.
- Automatic synchronization requires enabled workbook macros. Active Gnatt filters, hidden record rows, protected sheets or failed refreshes stop synchronization with a warning rather than attempting a partial sort.
- Full Recalc button/checkbox redesign remains unresolved; keep the existing daily reminder active.
- No other workbook rollout, approvals, invoice movement or financial-input changes were performed.
