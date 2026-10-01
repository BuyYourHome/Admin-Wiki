# Carrying Migration Plan

## Approved Design

Prototype: Pond's current owner-formatted Carrying/manual-entry interface. Tensity received the first Carrying migration and Vendor prefill. On September 30, 2026, Wes requested next-logical-date suggestions in Pond first and inclusion in this migration plan.

Required package for later authorized targets:

1. Fetch the latest Teams target, confirm closure, preserve a rollback, and independently map all records, labels, formulas, controls, helpers and downstream dependencies.
2. Preserve project values and owner formatting. Reconcile grid overrides into `tblCarryingExpenses`; apply the approved typed-date pairing, Labor, supporting Profit/Review/Docs fixes and numeric-zero cleanup from [[Carrying Mode Rules]]. Never import the prototype's expenses.
3. Add or upgrade the named manual-entry form, Include control and Insert Record behavior. Confirm the target's table location, grid capacity, VBA and security prerequisites; do not launch visible Excel or change trust settings.
4. Add the Vendor dropdown and same-size Recurring Bill button beneath Insert Record. Preserve existing vendor identities and formulas; fill blank Vendors from their Category under Wes's September 30 batch authorization. Place the helper and feedback without overwriting cells.
5. Include next-logical-date suggestions: preserve entered dates/formulas; otherwise attempt weekly/monthly/quarterly/annual inference from the three latest distinct dates of the same Vendor + Category. Copy the latest record's Description without using it as a matching key. Only multiple categories require a choice; that choice identifies the category and still uses its latest record. Preserve month ends and February clamping; uncertain patterns remain blank. Suggestions are editable, and prefill never inserts an expense.
6. Verify original records, formulas, styles, macros, table definitions, controls, print settings, totals and existing-error baseline. Test dates, ambiguity, filtering, duplicate prevention, credits, manual date overrides, leap years and Automatic recalculation. Discard all test data.
7. Recheck Teams freshness, replace the same authorized item, download and match hash, repeat unsaved native tests, retain rollback, remove superseded temporary files and record lessons.

## Rollout Gates

- Pond: next-date enhancement and subsequent Vendor + Category matching correction completed and verified in Teams, latest save September 30, 2026 at 21:46:48Z; ready for Wes's inspection. See [[pond-recurring-date-20260930]] and [[pond-recurring-category-match-20260930]].
- Tensity: existing Vendor prefill works, but does not yet contain date inference. Follow Pond verification/review and obtain authorization for the upgrade; its closure notice alone does not change the requested Pond-first scope.
- Other active projects: pending later rollout authorization and independently confirmed active list. No workbook changed by creating this plan.
- Cool Springs: remains separately gated because of buyer-facing amortization history. Carrying scope does not authorize Amortization replacement.

## September 30 Batch Authorization

Wes authorized completing Outrigger and continuing through all active projects without a project-by-project design approval pause. The earlier rollout gates above are historical. Use manual grid amounts/dates over conflicting table values and fill blank Vendors from Category. Continue independent mapping and closure/freshness checks, rollback, validation and same-item Teams delivery for each project. Never copy prototype expense records.

Confirmed prior active rollout set: Outrigger, Rose, Pond, Banks, Pinetree, Pleasant Garden, Rosebrooks, Cool Springs, Tensity and Britton. Reconcile this set against current Teams files; retain earlier inactive exclusions (Old Buckhorn, Burgwyn, Pearces, Sandy Run, Larchmont, Willowdell and Mom). Pond is already enhanced; verify rather than reinstall. Tensity needs the current recurring module. Cool Springs Carrying may be updated but its Amortization must remain untouched.

Outrigger closure is confirmed. Other target closure confirmation was requested before replacement. Document any project-specific blocker without stopping safe work on other confirmed targets.
