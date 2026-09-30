# Pond Recurring Category Match - September 30, 2026

Wes reported the Choose recurring bill prompt and approved correcting the matching key to Vendor + Category, reusing the latest description. Pond was confirmed saved and closed. Scope: Pond only, the prefill module, migration rules, regression tests and this log. No operational invoice insertion or other-project rollout.

## Source And Rollback

- Teams source: `Property/26_Project Management - 908 Pond St 3.xlsm`, saved `2026-09-30T21:36:54Z`.
- Item: `01ZGFUBDLVK7BSTEO4Z5D2YYXQAVBZT7UB`.
- Rollback: `Property/Project Template/Rollback Copies/26_Project Management - 908 Pond St 3.before-category-match-20260930-2140.xlsm`, item `01ZGFUBDN7NARFIHUE5VC2O2LLFPKJ5DA6`.
- [Open Pond](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7B29C35775-DC91-47CF-AC62-F0054399FE81%7D&file=26_Project%20Management%20-%20908%20Pond%20St%203.xlsm&action=default).

The current form had Vendor Water and the reported feedback. Its input values and saved feedback are preserved by this code-only correction; the next click updates the feedback. Table remains AL2:AV77 with 75 records.

## Correction

Description is no longer an identity key for record selection or date history. Match trimmed, case-insensitive Vendor + Category, choose the latest dated record and copy its description. Only multiple categories cause a prompt. The selected table cell identifies a category; even if the chosen row is old, the latest record in that category supplies the form. Wrong-vendor and invalid row choices are rejected. Existing date/formula preservation, recurrence rules, provenance clearing and insertion safety are unchanged.

Only `BYHCarryingPrefill` was replaced. Compared its saved source against commit `6e0546a2`, allowing only the observed VBE normalization `Err.description` versus `Err.Description`; other differences stop the updater. All 37 other VBA components remained unchanged.

## Validation

- Water fills $65.77, latest recovered-grid description and suggested August 14, 2026 without a prompt. Duke Electric fills $109.49 and August 10, 2026 without a prompt.
- Synthetic same-vendor/different-category record still requires a choice without overwriting form input. Selecting an older Water row still uses the latest Water record and full date history. Wrong-vendor/out-of-range choices rejected; test record discarded.
- Natural Gas, Property Taxes and one-off Labor examples still pass.
- Full raw-cell/style/table/name/validation audit passed with zero changes permitted. No new error cells or external links. The 110 pre-existing error cells remain outside scope.
- Original 75 records and Profit B43 $33,864.65 unchanged. The change adds no expense and alters no stored source dates/amounts. No layout change required another rendering; existing geometry checks passed.
- Insertion regression passed: required input, literal text, credits, excluded/filtered duplicates, checkbox and immediate Labor/Profit recalculation. All test edits discarded.

## Delivery

Rechecked unchanged source version 81 and replaced the same Teams item at `2026-09-30T21:46:48Z` (5:46:48 PM Eastern). Fresh download matched SHA-256 `E78E59A88D993A13360B84715B3AB930F70600B9D2174869B14B9E49E9A82511`; source SHA-256 was `DB13A320CB358AA3AB6F55553931E400AB4A78AE3C7E67C51932A96E5B95CCED`. Corrected-match, latest-description, category separation and real-history tests passed again on the exact download, without saving. Ready for Pond review. Scoped code/rules/tests/log committed locally, not pushed. Rollback retained in Teams and superseded temporary workbook copies removed.

## Lesson

Migration/provenance wording and ordinary invoice descriptions are not stable bill identities. Regression tests must include one vendor/category whose descriptions change, and a separate test proving that genuinely different categories remain separated. This supersedes the description-based rule recorded in the earlier Pond/Tensity pilot logs. See [[Carrying Mode Rules]] and [[carrying-migration-plan]].
