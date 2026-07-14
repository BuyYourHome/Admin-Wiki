# Vendor Tabs Migration - 3413 Pinetree Ln - 2026-07-14

## Workbooks

- Source template: Teams `Property/27_Project Management - 7001 Outrigger Dr.xlsm`, current source copy modified 2026-07-14 10:25:06 Eastern.
- Target: Teams `Property/17_Project Management - 3413 Pinetree Ln.xlsm`.
- Target version before replacement: `22.0`, 607,476 bytes, modified 2026-07-07 11:25:41 Eastern.
- Target version after replacement: `23.0`, 682,701 bytes, modified 2026-07-14 12:29:19 Eastern.
- Rollback copy retained: `working/vendor-tabs-mode/pinetree-20260714/rollback - 17_Project Management - 3413 Pinetree Ln before Vendor Tabs migration.xlsm`.

## Scope Completed

- Added an empty canonical `Review` sheet with `tblInvoiceReview`, an unchecked native checkbox in `Review!B1`, and `invoiceEntryReviewRequest = Review!$B$1`.
- Replaced all 11 Vendor Tabs Mode worksheets side by side. Each legacy worksheet remains immediately before its replacement as `<Worksheet> - Old`.
- Kept `STR`, `Furnishing`, `Sheet1`, `Sheet2`, and `Sheet5` outside the migration scope.
- Reconnected Gnatt Chart vendor costs to the replacement selected totals while preserving Pinetree's existing quantities.
- Confirmed zero external workbook links after save and reopen.

## Key Totals

| Worksheet | Before | After |
| --- | ---: | ---: |
| Demo & Trash Haul | $0.00 | $0.00 |
| Appliances | $0.00 | $0.00 |
| Plumbing Fixtures | $0.00 | $0.00 |
| Windows & Doors | $235.81 | $235.81 |
| Cabinets | $0.00 | $0.00 |
| Paint | $0.00 | $0.00 |
| Flooring | $5,098.80 | $5,098.80 |
| HVAC | $0.00 | $0.00 |
| Electrical Fixtures | $0.00 | $0.00 |
| Landscape | $0.00 | $0.00 |
| Exterior | $61.44 | $61.44 |

Gnatt Chart retained the same selected vendor values and quantities, including Windows & Doors `$235.81`, Flooring `$5,098.80`, and Exterior `$61.44`.

## Manual Mapping

- Windows & Doors: mapped the two visible contributing rows totaling `$220.38` and added a labeled `$15.43` legacy tax/total adjustment because the saved legacy total was static and did not reconcile to the displayed detail.
- Flooring: mapped RediCarpet rows of `$571.80` and `$4,527.00`, preserving blank tax cells and the `$5,098.80` total.
- Exterior: mapped Lowes mailbox `$28.46` and Home Depot mailbox post `$32.98`; corrected the legacy mailbox-post column misalignment by placing `HD106052` in `Item #`.
- All other vendor tabs had zero selected totals. Their actual tables were cleared and Pinetree-specific undated candidates were placed only in the orange option area where space permitted.

## Validation

- Workbook reopened successfully as `.xlsm`.
- Review table empty; request checkbox is native, unchecked, and not formula-driven.
- All expected tables, side-by-side old/new sheets, selector totals, and Gnatt Chart formulas validated.
- External links: `0`.
- Visual review completed for Review, all 11 replacement vendor tabs, and Gnatt Chart.
- Pre-existing errors remained unchanged: `Docs!E39 = #REF!` and `Profit!L82 = #VALUE!`.

## Unresolved Issues

- The source of the legacy Windows & Doors `$15.43` difference is not identifiable from the visible legacy rows. It is preserved transparently for Wes's review rather than normalized.
- The two pre-existing workbook errors are outside this Vendor Tabs migration and remain unresolved.
