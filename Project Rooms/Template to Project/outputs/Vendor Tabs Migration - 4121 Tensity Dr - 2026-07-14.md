# Vendor Tabs Migration - 4121 Tensity Dr - 2026-07-14

## Workbooks

- Source template: Teams `Property/27_Project Management - 7001 Outrigger Dr.xlsm`, modified 2026-07-14 10:25:06 AM Eastern.
- Target: Teams `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`.
- Target version before replacement: `424.0`, 740,285 bytes, modified 2026-07-07 11:25:56 AM Eastern.
- Target version after replacement: `425.0`, 813,429 bytes, modified 2026-07-14 4:00:58 PM Eastern.
- Rollback copy retained: `working/vendor-tabs-mode/tensity-20260714/rollback - 24_Project Management - 4121 Tensity Dr 2 before Vendor Tabs migration.xlsm`.

## Scope Completed

- Added an empty canonical `Review` worksheet with `tblInvoiceReview`, an unchecked native checkbox in `Review!B1`, and `invoiceEntryReviewRequest = Review!$B$1`.
- Replaced all 11 Vendor Tabs Mode worksheets side by side. Each legacy worksheet remains immediately before its replacement as `<Worksheet> - Old`.
- Kept `STR`, `Furnishing`, and all other worksheets outside Vendor Tabs Mode.
- Reconnected 12 Tensity Gantt Chart reads to the canonical replacement totals. The former hardcoded Appliances zero is now connected to `Appliances!M15`.
- Protected every non-mode worksheet with before-and-after fingerprints. Only the 12 approved Gantt cells changed outside the migrated worksheets.

## Reconciled Values

| Worksheet | Before | After |
| --- | ---: | ---: |
| `Demo & Trash Haul` | $1,950.00 | $1,950.00 |
| `Appliances` | $0.00 | $0.00 |
| `Plumbing Fixtures` | $1,685.9448 | $1,685.9448 |
| `Windows & Doors` | $1,111.04565 | $1,111.04565 |
| `Cabinets` | $0.00 | $0.00 |
| `Paint` | $3,777.359125 | $3,777.359125 |
| `Flooring` | $7,817.600136 | $7,817.600136 |
| `HVAC` | $686.55 | $686.55 |
| `Electrical Fixtures` | $161.078775 | $161.078775 |
| `Landscape` | $3,305.96 | $3,305.96 |
| `Exterior` | $1,900.59 | $1,900.59 |

## Manual Mapping

- Mapped every Vendor Tab independently from Tensity's legacy layout; no prior project's positional map was reused.
- Kept undated zero-quantity product candidates in the orange option areas and contributing expenses in the yellow actual-invoice tables.
- `Paint`: retained four Sherwin-Williams material purchases and the `$3,400.00` painter expense; `Paint!E3` now reads Tensity's square-foot value from `Profit!M9`.
- `Flooring`: retained the `$7,590.64` installation subtotal and `$226.960136` card fee so the selected total remains `$7,817.600136`.
- `Exterior`: retained the legacy `$643.50` paver total with a description documenting the old quantity `2` at `$300.00`.
- Rebuilt every replacement selector as an unlocked native in-cell checkbox and saved all selectors unchecked. Tensity's approved `Profit!W6 = FALSE` gate remains unchanged.

## Validation

- Exact Teams-downloaded version `425.0` reopened successfully as `.xlsm` and was byte-for-byte identical to the validated upload source.
- Calculation mode is Automatic; iterative calculation remains enabled.
- All 11 native checkboxes are unlocked and update their selector immediately between `No` and `Yes` without `F9` when the existing `Profit!W6` gate is enabled temporarily in an unsaved test session.
- All 11 selected totals and all 12 Gantt Chart values reconcile exactly.
- Review table is empty; the request checkbox and workbook name are correct.
- External workbook links: `0`.
- Canonical worksheet formulas pointing to `- Old` tabs: `0`.
- Formula errors in Review and migrated Vendor Tabs: `0`.
- Visual review completed for Review, all 11 replacement Vendor Tabs, and Gantt Chart.
- Pre-existing formula errors outside the migrated sheets were not changed. This includes existing `#REF!` cells on Gantt Chart.

## Review Items

- Inspect each adjacent `<Worksheet> - Old` tab before approving its removal.
- Confirm the migrated Paint, Flooring, Landscape, and Exterior records and orange option rows.
- Confirm the Gantt totals, especially the newly connected Appliances zero and the duplicate HVAC reads at `G19` and `G24`.
- Leave `Profit!W6` unchanged unless the project model itself is intentionally changed.
