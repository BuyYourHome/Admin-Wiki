# Vendor Tabs Migration - 1426 Pleasant Garden Ln - 2026-07-14

## Workbooks

- Source template: Teams `Property/27_Project Management - 7001 Outrigger Dr.xlsm`, current source modified 2026-07-14 10:25:06 Eastern.
- Target: Teams `Property/18_Project Management - 1426 Pleasant Garden Ln.xlsm`.
- Target version before replacement: `21.0`, 730,835 bytes, modified 2026-07-07 11:25:45 Eastern.
- Target version after final replacement: `23.0`, 805,002 bytes, modified 2026-07-14 1:09:16 PM Eastern.
- Rollback copy retained: `working/vendor-tabs-mode/pleasant-garden-20260714/rollback - 18_Project Management - 1426 Pleasant Garden Ln before Vendor Tabs migration.xlsm`.

## Scope Completed

- Added an empty canonical `Review` worksheet with `tblInvoiceReview`, an unchecked native checkbox in `Review!B1`, and `invoiceEntryReviewRequest = Review!$B$1`.
- Replaced all 11 Vendor Tabs Mode worksheets side by side. Each legacy worksheet remains immediately before its replacement as `<Worksheet> - Old`.
- Kept `STR`, `Furnishing`, and all other worksheets outside this migration scope.
- Reconnected Gantt Chart vendor costs to the replacement worksheets by project row label, including Pleasant Garden's shifted HVAC contractor row.
- Confirmed that no worksheet formulas point to the adjacent `- Old` tabs.

## Reconciled Values

| Worksheet | Before | After |
| --- | ---: | ---: |
| `Demo & Trash Haul` | $0.00 | $0.00 |
| `Appliances` | $1,740.45 | $1,740.45 |
| `Plumbing Fixtures` | $1,279.55 | $1,279.55 |
| `Windows & Doors` | $2,024.31 | $2,024.31 |
| `Cabinets` | $4,165.00 | $4,165.00 |
| `Paint` | $5,750.00 | $5,750.00 |
| `Flooring` | $6,605.00 | $6,605.00 |
| `HVAC` | $9,504.50 | $9,504.50 |
| `Electrical Fixtures` | $581.91 | $581.91 |
| `Landscape` | $210.00 | $210.00 |
| `Exterior` | $71.04 | $71.04 |

## Manual Mapping

- `Demo & Trash Haul`: migrated five visible contributing rows totaling $1,773.75 and added a clearly labeled negative $1,773.75 reconciliation row because the legacy selected total was $0.00.
- `Cabinets`: retained the legacy AvilaCRI selected quote as one labeled $4,165.00 reconciliation row because the visible quantity-driven detail was $0.00.
- `Paint`: migrated four visible rows totaling $1,788.82 and added a labeled $3,961.18 adjustment to retain the legacy selected $5,750.00 quote.
- `Flooring`: retained the two legacy selected quote components, LVP $3,790.00 and carpet $2,815.00, as labeled reconciliation rows.
- Preserved explicit source tax values for Appliances, Plumbing Fixtures, and Paint. Cleared automatic tax formulas on rows whose legacy totals excluded tax so the new tables did not add 7.25% a second time.
- Replaced the Flooring subtotal formula with the standard blank-square-foot fallback so quantity and cost calculate when `Sq Ft` is blank.
- Repointed the remaining Gantt Chart legacy references for Landscape, Drainage/Exterior, and HVAC to the canonical replacement worksheets.

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

- Review the `Demo & Trash Haul` reconciliation. The old sheet contains $1,773.75 of visible detail while its selected total is $0.00.
- Review the Paint $3,961.18 reconciliation between visible detail and the saved $5,750.00 selected quote.
- Review whether the Cabinets and Flooring saved quotes should remain in the invoice tables or later move into the orange template-estimate sections after the old worksheets are removed.
