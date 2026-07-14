# Vendor Tabs Migration - 908 Pond St

## Migration Record

- Date/time completed: 2026-07-14 17:09 EDT
- Template workbook: `27_Project Management - 7001 Outrigger Dr.xlsm`
- Target workbook: `26_Project Management - 908 Pond St 3.xlsm`
- Teams item ID: `01ZGFUBDJX4TR5QBFBDBG2RQTZNGHMZVZV`
- Teams version before: `1694.0`
- Teams version after: `1695.0`
- Rollback copy: `working/vendor-tabs-mode/pond-20260714/rollback - 26_Project Management - 908 Pond St 3 before Vendor Tabs migration.xlsm`
- Uploaded SHA-256: `512F466299885284F41841377E82AE4E3B17A6D43116BEAB5CD132F90F786979`

## Scope

- Added the canonical `Review` worksheet with `Needs Invoice Entry Review` checkbox in `B1` and an empty `tblInvoiceReview`.
- Migrated the 11 Vendor Tabs: Demo & Trash Haul, Appliances, Plumbing Fixtures, Windows & Doors, Cabinets, Paint, Flooring, HVAC, Electrical Fixtures, Landscape, and Exterior.
- Renamed each legacy Vendor Tab to `<Worksheet> - Old` and placed it beside the canonical replacement.
- Left `STR` and `Furnishing` outside this mode unchanged.
- Reconnected Pond's project-specific Gantt expense cells to the canonical replacement sheets.

## Selected Totals Before And After

| Worksheet | Selector | Before | After |
|---|---:|---:|---:|
| Demo & Trash Haul | Actual | $2,679.56 | $2,679.56 |
| Appliances | Actual | $0.00 | $0.00 |
| Plumbing Fixtures | Actual | $0.00 | $0.00 |
| Windows & Doors | Actual | $3,886.54825 | $3,886.54825 |
| Cabinets | Actual | $9,545.25 | $9,545.25 |
| Paint | Actual | $495.60225 | $495.60225 |
| Flooring | Template | $0.00 | $0.00 |
| HVAC | Template | $22,357.00 | $22,357.00 |
| Electrical Fixtures | Actual | $0.00 | $0.00 |
| Landscape | Actual | $1,470.00 | $1,470.00 |
| Exterior | Actual | $1,953.848475 | $1,953.848475 |

## Project-Specific Mapping

- Demo & Trash Haul: retained dated Meridian history, contributing undated legacy rows, and the exact selected actual total.
- Windows & Doors: retained the contributing project rows; represented two hardcoded legacy subtotal exceptions as quantity `1` with explanatory descriptions.
- Cabinets: retained the four contributing actual rows.
- Paint: retained three contributing Sherwin-Williams rows, including the negative discount.
- HVAC: retained the `$22,357.00` template selection and dated actual history; widened the summary result column so the selected value is readable.
- Landscape: retained five Greenview Works rows and the ArborEx tree-service row without adding tax.
- Exterior: retained five contributing actual rows, including the negative discount and untaxed electrical-service row.
- Flooring: retained the saved template selection and corrected the summary formula to sum calculated subtotal and tax rather than unit cost.

## Validation

- All 11 selected Vendor Tab totals match the fresh target baseline at full precision.
- All 11 project-specific Gantt results match their baseline values.
- All 11 native checkboxes passed unchecked, checked, and restored-state tests after save/reopen without `F9`.
- Workbook calculation mode is Automatic and iteration remains enabled.
- No formulas point to canonical `<Worksheet> - Old` sheets.
- No formula errors were found in the migrated worksheet ranges.
- No external workbook links, external-link package parts, or external workbook defined names remain.
- Non-mode worksheets match the rollback copy, and Gantt cells outside the approved reconnect set are unchanged.
- Review and all 11 Vendor Tabs passed full-width visual inspection.
- The exact Teams-downloaded replacement matched the validated local workbook byte-for-byte.

## Unresolved Issues

- None identified within Vendor Tabs Mode.
- Legacy worksheets remain beside the canonical replacements for Wes's inspection and approval before removal.
