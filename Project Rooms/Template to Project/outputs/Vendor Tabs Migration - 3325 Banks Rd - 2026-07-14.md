# Vendor Tabs Migration - 3325 Banks Rd

## Migration Record

- Date/time: 2026-07-14 11:24 AM Eastern
- Source template workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- Target project workbook: `Property/07_Project Management - 3325 Banks Rd.xlsm`
- Teams version after replacement: `20.0`
- Rollback copy: `working/vendor-tabs-mode/banks-pilot-20260714/rollback - 07_Project Management - 3325 Banks Rd before Vendor Tabs migration.xlsm`

## Structure Applied

- Added canonical `Review` with `tblInvoiceReview`, unchecked `Review!B1`, and `invoiceEntryReviewRequest = Review!$B$1`.
- Renamed each existing vendor worksheet to `<Worksheet> - Old`.
- Added the current Outrigger vendor design beside each old worksheet under the original worksheet name.
- Reconnected Gantt Chart to the selected total on each replacement worksheet.
- Excluded `STR` and `Furnishing`.

## Reconciled Values

| Worksheet | Before | After |
| --- | ---: | ---: |
| Demo & Trash Haul | $5,322.49 | $5,322.49 |
| Appliances | $1,269.16 | $1,269.16 |
| Plumbing Fixtures | $433.46 | $433.46 |
| Windows & Doors | $749.65 | $749.65 |
| Cabinets | $4,165.40 | $4,165.40 |
| Paint | $1,332.94 | $1,332.94 |
| Flooring | $5,098.80 | $5,098.80 |
| HVAC | $13,062.00 | $13,062.00 |
| Electrical Fixtures | $1,357.20 | $1,357.20 |
| Landscape | $3,305.00 | $3,305.00 |
| Exterior | $19,189.95 | $19,189.95 |

## Manual Mapping

- Converted each vendor tab from its own legacy columns rather than using one cross-project map.
- Preserved accumulated-tax lines as separate actual expenses where needed to prevent double taxation.
- Preserved both Banks Paint tax-related lines and labeled the second as `Legacy duplicate tax preserved for reconciliation`.
- Converted Landscape's legacy cost/square-foot details into description traceability while keeping the reconciled row amount in `Cost/Unit` with quantity 1.
- Removed stale Outrigger option rows from replacement orange areas and corrected the Windows & Doors template label.
- Widened HVAC total columns so `$13,062.00` displays without clipping.

## Validation

- All eleven selected vendor totals match the pre-migration values.
- Gantt Chart references the replacement worksheets.
- External workbook links: 0.
- New formula errors: 0.
- Native selector and Review checkboxes remained present and unchecked.
- Visual review completed for Review, all eleven replacement vendor worksheets, and Gantt Chart.

## Unresolved Items

- Banks Paint contains two legacy `$97.13` tax-related lines. They were intentionally preserved for exact reconciliation and should be reviewed by Wes before either line is removed.
- These pre-existing errors remain outside the migrated worksheets: `Profit!L82 = #VALUE!`, `Profit!L84 = #VALUE!`, `Todo!C48 = #DIV/0!`, and `Todo!E48 = #DIV/0!`.
