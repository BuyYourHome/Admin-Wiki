# Vendor Tabs Migration - 612 Britton Ct

## Migration Record

- Date/time: 2026-07-14 16:33:49 -04:00
- Mode: Vendor Tabs Mode
- Source template workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- Target project workbook: `Property/25_Project Management - 612 Britton Ct.xlsm`
- Teams target item: `01ZGFUBDO5QEQ7M544BRELUSIAOY3CVLKE`
- SharePoint version before migration: `168.0`
- SharePoint version after migration: `169.0`
- Rollback file retained locally: `working/vendor-tabs-mode/britton-20260714/rollback - 25_Project Management - 612 Britton Ct before Vendor Tabs migration.xlsm`

## Work Completed

- Added a clean `Review` worksheet with `tblInvoiceReview`, native checkbox at `Review!B1`, and workbook name `invoiceEntryReviewRequest = Review!$B$1`.
- Renamed each legacy vendor worksheet to `<Worksheet> - Old` and placed the approved Outrigger replacement immediately beside it under the canonical worksheet name.
- Migrated project values independently by worksheet meaning.
- Reconnected Britton's twelve Gantt reads to the canonical replacement totals.
- Rebuilt and tested all eleven native Vendor Tab checkboxes.
- Saved the workbook in Automatic calculation mode with iterative calculation retained.

## Selected Totals Before And After

| Worksheet | Before | After |
| --- | ---: | ---: |
| Demo & Trash Haul | $0.00 | $0.00 |
| Appliances | $0.00 | $0.00 |
| Plumbing Fixtures | $862.31145 | $862.31145 |
| Windows & Doors | $0.00 | $0.00 |
| Cabinets | $0.00 | $0.00 |
| Paint | $0.00 | $0.00 |
| Flooring | $0.00 | $0.00 |
| HVAC | $0.00 | $0.00 |
| Electrical Fixtures | $0.00 | $0.00 |
| Landscape | $0.00 | $0.00 |
| Exterior | $8,080.00 | $8,080.00 |

## Manual Mapping Decisions

- Mapped all fourteen rows from Demo & Trash Haul's legacy actual section because that section explicitly represented actual activity, including dated and zero-dollar history.
- Mapped four dated Plumbing Fixtures rows. Restored the standard Tax calculated-column formula on each mapped row so the exact `$862.31145` total reconciled.
- Mapped the dated garage-door row on Windows & Doors and the dated HVAC service row; undated zero-quantity product candidates remain on the adjacent old sheets.
- Mapped all five dated Exterior transactions and kept their Tax cells blank because the legacy `$8,080.00` total excluded tax.
- Mapped representative project estimates into limited orange option areas for tabs with more dormant candidates than the approved design can display. The adjacent old sheets retain the complete candidate lists.

## Validation

- Non-mode worksheets matched the rollback copy; only the twelve approved Gantt cells changed outside Vendor Tabs Mode.
- All eleven selected totals matched their pre-migration values.
- All twelve Gantt totals matched the new canonical sheet totals.
- No formulas referred to Vendor Tabs named `- Old`.
- No formula errors were present in `Review` or the canonical migrated Vendor Tabs.
- No external workbook links or external defined names remained.
- `Review` was blank and its request checkbox/name were correct.
- All eleven native Vendor Tab checkboxes changed `No -> Yes -> No` without `F9` or an explicit calculation command.
- Workbook calculation mode was Automatic and iterative calculation remained enabled.
- Visual PDF review covered all twelve mode worksheets and prompted correction of one stale prototype label, Paint field placement, and Flooring quantity formatting.
- The Teams-downloaded replacement was byte-for-byte identical to the validated local output. SHA-256: `34972F314D4AC94599479893DBA66FFDA6C6850566EDFBE23765D7D83B80C9B4`.

## Unresolved Issues

- None identified within Vendor Tabs Mode.
- Legacy worksheets remain beside their replacements for Wes's inspection and approval.
