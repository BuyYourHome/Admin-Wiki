# Vendor Tabs Migration - 2325 Cool Springs Rd - 2026-07-14

## Workbooks

- Source template: Teams `Property/27_Project Management - 7001 Outrigger Dr.xlsm`, modified 2026-07-14 10:25:06 AM Eastern.
- Target: Teams `Property/22_Project Management - 2325 Cool Springs Rd 4.xlsm`.
- Target version before replacement: `58.0`, 1,097,004 bytes, modified 2026-07-07 11:25:53 AM Eastern.
- Target version after replacement: `59.0`, 1,164,492 bytes, modified 2026-07-14 3:03:27 PM Eastern.
- Rollback copy retained: `working/vendor-tabs-mode/cool-springs-20260714/rollback - 22_Project Management - 2325 Cool Springs Rd 4 before Vendor Tabs migration.xlsm`.

## Scope Completed

- Added an empty canonical `Review` worksheet with `tblInvoiceReview`, an unchecked native checkbox in `Review!B1`, and `invoiceEntryReviewRequest = Review!$B$1`.
- Replaced all 11 Vendor Tabs Mode worksheets side by side. Each legacy worksheet remains immediately before its replacement as `<Worksheet> - Old`.
- Kept `STR`, `Furnishing`, and all other worksheets outside this migration scope.
- Reconnected the 12 confirmed Cool Springs Gantt Chart vendor formulas to the canonical replacement totals.
- Protected the actively used Cool Springs `Amortization` worksheet with an exact before-and-after fingerprint; it did not change.

## Reconciled Values

| Worksheet | Before | After |
| --- | ---: | ---: |
| `Demo & Trash Haul` | $600.00 | $600.00 |
| `Appliances` | $0.00 | $0.00 |
| `Plumbing Fixtures` | $0.00 | $0.00 |
| `Windows & Doors` | $2,738.060325 | $2,738.060325 |
| `Cabinets` | $0.00 | $0.00 |
| `Paint` | $0.00 | $0.00 |
| `Flooring` | $0.00 | $0.00 |
| `HVAC` | $254.72 | $254.72 |
| `Electrical Fixtures` | $0.00 | $0.00 |
| `Landscape` | $0.00 | $0.00 |
| `Exterior` | $0.00 | $0.00 |

## Manual Mapping

- `Demo & Trash Haul`: migrated the $600.00 Gigi'sBuld Removal actual row and the three Cool Springs template options.
- `Windows & Doors`: migrated the $2,724.15 garage-door row and the $12.97 closet-door-knob row with $0.940325 tax. The selected total remains $2,738.060325.
- `Flooring`: migrated the two visible actual rows while retaining the saved `Yes` template selector and the selected total of $0.00. The second orange option quantity was set to zero because the approved replacement formula uses quantity directly.
- `HVAC`: migrated the $254.72 Trueheart service row with intentionally blank tax.
- Mapped orange template options independently on every vendor worksheet according to each Cool Springs legacy layout.
- `Exterior`: mapped Masking Tape item `1604326` and Drop Cloths item `228556` to `Item #` rather than treating them as costs.

## Validation

- Exact Teams-downloaded version `59.0` reopened successfully as `.xlsm`.
- Calculation mode is Automatic; iterative calculation remains enabled.
- All 11 native checkboxes are unlocked and update their Yes/No selector immediately in both states without a calculation command.
- All 11 selected totals and all 12 Gantt Chart values reconcile exactly.
- Review table is empty; the request checkbox and workbook name are correct.
- All old/new worksheet pairs are adjacent.
- External workbook links: `0`.
- Canonical worksheet formulas pointing to `- Old` tabs: `0`.
- Outrigger template formula references: `0`.
- Formula errors in Review and migrated Vendor Tabs: `0`.
- Amortization fingerprint before/after: `17295049ABF6AC752A9E5F67F66B450C0B65F3FF6D6BCA31CDD40716B8704965`.
- Visual review completed for Review, all 11 replacement Vendor Tabs, and Gantt Chart.

## Review Items

- Inspect each adjacent `<Worksheet> - Old` tab before approving its removal.
- Confirm the migrated Demo, Windows & Doors, Flooring, and HVAC actual rows.
- Review the project-specific orange template options, especially Landscape and Exterior.
- Confirm that the actively used Amortization schedule remains consistent with the buyer-approved numbers.
