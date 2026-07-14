# Vendor Tabs Migration - 115 Rosebrooks Dr - 2026-07-14

## Workbooks

- Source template: Teams `Property/27_Project Management - 7001 Outrigger Dr.xlsm`, current source modified 2026-07-14 10:25:06 Eastern.
- Target: Teams `Property/20_Project Management - 115 Rosebrooks Dr.xlsm`.
- Target version before replacement: `50.0`, 692,254 bytes, modified 2026-07-07 11:25:50 Eastern.
- Target version after replacement: `51.0`, 766,207 bytes, modified 2026-07-14 1:28:32 PM Eastern.
- Rollback copy retained: `working/vendor-tabs-mode/rosebrooks-20260714/rollback - 20_Project Management - 115 Rosebrooks Dr before Vendor Tabs migration.xlsm`.

## Scope Completed

- Added an empty canonical `Review` worksheet with `tblInvoiceReview`, an unchecked native checkbox in `Review!B1`, and `invoiceEntryReviewRequest = Review!$B$1`.
- Replaced all 11 Vendor Tabs Mode worksheets side by side. Each legacy worksheet remains immediately before its replacement as `<Worksheet> - Old`.
- Kept `STR`, `Furnishing`, and all other worksheets outside this migration scope.
- Reconnected all Rosebrooks Gantt Chart vendor rows by label and business meaning, including the shifted HVAC and zero-quantity project-specific rows.
- Confirmed that no worksheet formulas point to the adjacent `- Old` tabs.

## Reconciled Values

| Worksheet | Before | After |
| --- | ---: | ---: |
| `Demo & Trash Haul` | $0.00 | $0.00 |
| `Appliances` | $1,646.56 | $1,646.56 |
| `Plumbing Fixtures` | $0.00 | $0.00 |
| `Windows & Doors` | $0.00 | $0.00 |
| `Cabinets` | $0.00 | $0.00 |
| `Paint` | $0.00 | $0.00 |
| `Flooring` | $0.00 | $0.00 |
| `HVAC` | $0.00 | $0.00 |
| `Electrical Fixtures` | $0.00 | $0.00 |
| `Landscape` | $0.00 | $0.00 |
| `Exterior` | $0.00 | $0.00 |

## Manual Mapping

- `Demo & Trash Haul`: migrated the visible $1,200.00 Gigi's Building Removal row and added a clearly labeled negative $1,200.00 reconciliation row because the legacy selected total was $0.00.
- `Appliances`: migrated seven contributing rows with their original item numbers, quantities, costs, and tax values. The table total remains $1,646.555625.
- The other nine actual-invoice tables are blank because their selected legacy totals and contributing rows were zero.
- Moved representative zero-quantity legacy choices into each replacement's orange template-option area. The adjacent old worksheets retain every legacy candidate for review.
- Wrote numeric zero inputs explicitly into Paint option rows. This prevents the Outrigger quantity formulas from dividing a blank-text square-foot input and returning `#VALUE!` in a Rosebrooks Flip model.
- Repointed Cleanup, vendor-material rows, Landscape, Exterior/Drainage, and all HVAC Gantt rows to the canonical replacement totals.

## Validation

- Workbook reopened successfully as `.xlsm`.
- All 11 selected totals reconcile exactly.
- Review table is empty; request checkbox is native and unchecked.
- All old/new worksheet pairs are adjacent.
- External workbook links: `0`.
- Worksheet formulas pointing to `- Old` tabs: `0`.
- Formula errors in migrated ranges: `0`.
- Visual review completed for Review, all 11 replacement vendor worksheets, and Gantt Chart.

## Review Items

- Review the Cleanup reconciliation. The old sheet contains a visible $1,200.00 removal charge while its selected total is $0.00.
- Confirm the seven migrated Appliances rows and the $1,646.56 selected total.
- Review the representative orange option choices before removing any adjacent old worksheet.

## Vendor Checkbox Repair

Wes reported that the replacement Vendor Tab checkboxes were not working after the initial migration. A fresh Teams version 52 was retrieved and repaired on 2026-07-14.

- Rebuilt all 11 Vendor Tab selectors as native in-cell checkboxes in their existing cells.
- Explicitly unlocked each checkbox's full merged area while preserving the saved state. Demo & Trash Haul and Appliances remained checked; the other nine selectors remained unchecked.
- Preserved the existing selector formulas and `Profit!W6` gating logic.
- Verified both states after save/reopen. Every selector changes from `No` when unchecked to `Yes` when checked.
- Verified Appliances changes its selected/Gantt result from `$0.00` to `$962.0325`. The other Rosebrooks template totals are currently zero, so their dollar results remain zero in both states even though the selector text changes correctly.
- Replaced the Teams workbook as version `53.0`, then downloaded and reopened that exact Teams copy for verification.
- Server-copy validation: 11 native checkboxes, 11 unlocked checkbox areas, 0 external links, and all two-state selector tests passed.

## Calculation Mode Repair

The first checkbox validation forced a full recalculation after each state change. That masked the actual interactive defect: Rosebrooks was saved with `calcMode="manual"`, so the checkbox Boolean changed but dependent selector cells such as `Appliances!M4` did not update until `F9`.

- Retrieved the fresh Teams version `54.0`, which included Wes's latest checkbox test state.
- Changed the workbook calculation mode from Manual to Automatic while retaining iterative calculation.
- Preserved all current checkbox states, formulas, worksheet structure, and Gantt connections.
- Reopened the workbook in a fresh Excel instance and tested all 11 selectors without any calculation command. Every selector changed immediately from `No` to `Yes` and restored to its saved state.
- Replaced the Teams workbook as version `55.0` and downloaded that exact copy for the same no-forced-calculation test.
- Server-copy validation: Automatic calculation, iterative calculation retained, 11 immediate selector updates passed, and 0 external links.
