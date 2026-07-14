# Vendor Tabs Mode - 320 Rose Pl Migration Log

## Migration

- Completed: 2026-07-14 5:45 PM Eastern
- Source template workbook: `27_Project Management - 7001 Outrigger Dr.xlsm`, fetched fresh from Teams on 2026-07-14
- Target project workbook: `28_Project Management - 320 Rose Pl.xlsm`, fetched fresh from Teams before editing
- Teams version before migration: `384.0`
- Teams version after migration: `385.0`
- Teams workbook: [28_Project Management - 320 Rose Pl.xlsm](https://lifeisanadventure.sharepoint.com/sites/SellYourHome/_layouts/15/Doc.aspx?sourcedoc=%7BD39E03A5-035A-4BBF-9346-ADD40A7758EE%7D&file=28_Project%20Management%20-%20320%20Rose%20Pl.xlsm&action=default&mobileredirect=true)
- Rollback copy: `working/vendor-tabs-mode/rose-20260714/rollback - 28_Project Management - 320 Rose Pl before Vendor Tabs migration.xlsm`

## Workbook Changes

- Added the canonical `Review` worksheet with an empty `tblInvoiceReview`, an unchecked native checkbox at `B1`, and `invoiceEntryReviewRequest` referring to `=Review!$B$1`.
- Renamed all 11 legacy Vendor Tabs to `<Worksheet> - Old` and retained them beside their replacements for review.
- Added current Outrigger-format replacements for Demo & Trash Haul, Appliances, Plumbing Fixtures, Windows & Doors, Cabinets, Paint, Flooring, HVAC, Electrical Fixtures, Landscape, and Exterior.
- Mapped Rose-specific values independently from each legacy worksheet by field meaning.
- Rebuilt all 11 native checkboxes and restored Rose's selected state to `No` for each replacement.
- Reconnected the Rose Gantt Chart vendor rows to the replacement summary cells.
- Saved the workbook in Automatic calculation mode with iterative calculation enabled.

## Selected Totals Before And After

| Worksheet | Before | After |
|---|---:|---:|
| Demo & Trash Haul | $505.00 | $505.00 |
| Appliances | $150.00 | $150.00 |
| Plumbing Fixtures | $44.58 | $44.58 |
| Windows & Doors | $210.10 | $210.10 |
| Cabinets | $6,726.59 | $6,726.59 |
| Paint | $8,333.20 | $8,333.20 |
| Flooring | $5,905.82 | $5,905.82 |
| HVAC | $8,621.00 | $8,621.00 |
| Electrical Fixtures | $0.00 | $0.00 |
| Landscape | $270.00 | $270.00 |
| Exterior | $0.00 | $0.00 |

## Manual Mapping Notes

- Cabinets discounted rows were represented as quantity `1` at the approved discounted subtotal and labeled `legacy 10% discount` so the selected total remains unchanged.
- Windows & Doors legacy reference identifiers were moved into readable description text instead of being treated as dates.
- Long mapped descriptions were wrapped and widened where needed. Paint cents formatting and Flooring quantity formatting were corrected after rendered visual review.
- A pre-existing `Profit!O61` formula still refers to `Docs - Old 0704`; the stable-sheet fingerprint confirms this formula was unchanged by Vendor Tabs Mode.

## Validation

- All 11 selected totals reconcile to the fresh target baseline.
- All 11 Gantt Chart vendor totals point to and match the replacement worksheets.
- All 11 native checkboxes changed their selector from `No` to `Yes` without `F9` and were restored unchecked.
- No formula errors exist in the migrated Vendor Tabs or Review worksheet.
- No external workbook links or external-link package parts exist.
- The 20 worksheets outside Vendor Tabs, Review, and the mapped Gantt cells retained their formula and constant fingerprints.
- The exact Teams-downloaded replacement matched the local validated file byte for byte at SHA-256 `7898CAA52ACE733A13C425DE7027FA102F8E567889D1A899305B2E6D47F912B8`.

## Unresolved Issues

- None within Vendor Tabs Mode. The pre-existing `Docs - Old 0704` reference is outside this mode and remains unchanged.
