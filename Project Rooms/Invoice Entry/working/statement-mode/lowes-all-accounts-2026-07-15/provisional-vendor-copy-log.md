# 2026-07-15 - Lowe's Provisional Vendor-Tab Copy Log

## Request

Wes asked Invoice Entry to make the new provisional-copy rule and rerun the last Lowe's all-account Statement Mode batch so high-confidence rows could be copied into vendor tabs for owner review.

## Rule Applied

Invoice Entry used the provisional vendor-tab copy exception added on 2026-07-15. This allows direct vendor-tab copy only when Wes explicitly authorizes post-copy review and the row has defensible project, amount, description, and destination evidence.

The copied rows are not final movement approvals. Their source `Review` rows were retained and marked `Copied - Needs Owner Verification`, not `Moved`.

## Workbook Updated

- Teams workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- Local working copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-all-accounts-2026-07-15\provisional-vendor-copy-20260715\sharepoint-downloads\27_Project Management - 7001 Outrigger Dr.xlsm`
- Rollback copy: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\statement-mode\lowes-all-accounts-2026-07-15\provisional-vendor-copy-20260715\rollback-copies\27_Project Management - 7001 Outrigger Dr.xlsm`

## Rows Copied

| Review Row ID | Destination worksheet | Destination table | Result |
| --- | --- | --- | --- |
| `OUTRIGGER-LOWES-6140-20260302-78928-DOCSCAN` | `Plumbing Fixtures` | `tblPlumbingFixturesInvoices` | Copied for owner verification. |
| `OUTRIGGER-LOWES-6140-20260602-89689-DOCSCAN` | `Electrical Fixtures` | `tblElectricalFixturesInvoices` | Copied for owner verification. |

## Rows Not Copied

- `OUTRIGGER-LOWES-6140-20260502-85288-DOCSCAN`: mixed transaction detail with no single defensible destination worksheet for direct vendor-tab copy.
- 908 Pond rows: no approved/defensible vendor-tab destination from this packet.
- 320 Rose rows: retained in Review because the Doc Scan packet was conservative OCR-derived review detail and did not provide clean item-level destinations suitable for provisional vendor-tab copy.
- Held-detail rows: left in the held-detail register when project, destination, accounting, tax, source completeness, or OCR confidence was insufficient.

## Validation

Before upload, Invoice Entry reopened the workbook through Excel and confirmed:

- `tblPlumbingFixturesInvoices` contains Lowe's ref `78928` with subtotal `$76.48` and tax `$5.54`.
- `tblElectricalFixturesInvoices` contains Lowe's ref `89689` with subtotal `$40.57` and tax `$2.94`.
- Both copied rows retained `Sub-Total` and `Tax` formulas.
- Both Review rows were retained and marked `Copied - Needs Owner Verification`.
- `invoiceEntryReviewRequest` reopened as `=Review!$B$1`.
- Excel reported zero external workbook links.
- `Gnatt Chart` references for `Plumbing Fixtures` and `Electrical Fixtures` had no error values.

The validated workbook was uploaded back to the same SharePoint target.
