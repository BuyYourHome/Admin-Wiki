# 2026-07-13 Outrigger Review Request Processing Log

## Workbook

- Teams workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- SharePoint item id: `01ZGFUBDLI2T63UQHIQVGZVZH4LRMVCLTC`
- Source timestamp before processing: `2026-07-13T20:47:50Z`
- Upload timestamp after processing: `2026-07-13T21:05:13Z`
- Review table: `tblInvoiceReview`
- Request marker: `invoiceEntryReviewRequest`
- Request marker reference verified in Excel: `=Review!$B$1`

## Action

Processed the checked Review request. Built the request packet from `tblInvoiceReview` by table headers, not visible rows or fixed cell positions.

## Duplicate Check

No duplicate-risk rows were found for the eligible Plumbing Fixtures rows in `tblPlumbingFixturesInvoices`.

## Rows Moved

Inserted six approved Lowe's statement rows into `Plumbing Fixtures` / `tblPlumbingFixturesInvoices`.

| Review Row ID | Destination | Sheet Row | Date | Vendor | Description | Item # | Qty | Cost/Unit | Amount |
| --- | --- | ---: | --- | --- | --- | --- | ---: | ---: | ---: |
| `OUTRIGGER-REV-004` | `Plumbing Fixtures` | 29 | 2026-02-17 | Lowes | EASTMAN Electric Water Heater Installation Kit | `758108` | 1 | 31.93 | 31.93 |
| `OUTRIGGER-REV-005` | `Plumbing Fixtures` | 30 | 2026-02-17 | Lowes | Delivery and Shipping | `2` | 1 | 20.00 | 20.00 |
| `OUTRIGGER-REV-006` | `Plumbing Fixtures` | 31 | 2026-02-17 | Lowes | EASTMAN 24-in ID Plastic Water Heater Drain Pan with PVC Fitting | `3488471` | 1 | 12.58 | 12.58 |
| `OUTRIGGER-REV-007` | `Plumbing Fixtures` | 32 | 2026-02-17 | Lowes | A.O. Smith Signature 100 50-Gallon Tall 6-Year 4500-Watt Double Element Electric Water Heater | `2483229` | 1 | 483.55 | 483.55 |
| `OUTRIGGER-REV-008` | `Plumbing Fixtures` | 33 | 2026-02-17 | Lowes | Delivery and Shipping | `2` | 1 | 0.00 | 0.00 |
| `OUTRIGGER-REV-009` | `Plumbing Fixtures` | 34 | 2026-03-03 | Lowes | EASTMAN 24-in ID Plastic Water Heater Drain Pan with PVC Fitting | `3488471` | 1 | -12.58 | -12.58 |

Each moved Review row was retained, set to `Moved`, and annotated with `Moved 2026-07-13 to Plumbing Fixtures / tblPlumbingFixturesInvoices.`

## Rows Excluded

| Review Row ID | Destination | Status | Reason |
| --- | --- | --- | --- |
| `OUTRIGGER-REV-001` | `Cabinets` | `Needs Review` | Status still excludes movement. Row note already indicates prior move/handling. |
| `OUTRIGGER-REV-002` | `Windows & Doors` | `Needs Review - Vendor Tab` | Status still excludes movement. |
| `OUTRIGGER-REV-003` | blank | `Needs Review - Vendor Tab` | Destination blank and status still excludes movement. |
| `OUTRIGGER-REV-010` | blank | `Needs Review - Project / Destination` | Destination blank and status still excludes movement. |
| `OUTRIGGER-REV-011` | blank | `Needs Review - Project / Destination` | Destination blank and status still excludes movement. |
| `OUTRIGGER-REV-012` | blank | `Needs Review - Project / Destination` | Destination blank and status still excludes movement. |
| `OUTRIGGER-REV-013` | blank | `Needs Review - Project / Destination` | Destination blank and status still excludes movement. |
| `OUTRIGGER-REV-014` | blank | `Needs Review - Allocation / Project` | Destination blank and status still excludes movement. |
| `OUTRIGGER-REV-015` | blank | `Needs Review - PO conflict` | Destination blank and status still excludes movement. |

## Validation

- Request checkbox cleared after validation: `invoiceEntryReviewRequest = FALSE`.
- Defined name still reopens as `=Review!$B$1`.
- `tblPlumbingFixturesInvoices` final range: `A14:J34`.
- `Plumbing Fixtures!L14` invoice total after insert: `1557.047275`.
- `Plumbing Fixtures!L16` grand total after insert: `1557.047275`.
- `Gnatt Chart!G10` still points to `='Plumbing Fixtures'!L16` and shows `1557.05`.
- Excel workbook links: `0`.
- External-link package parts: `0`.
- Post-upload readback from Teams reopened with `invoiceEntryReviewRequest = FALSE`, `tblPlumbingFixturesInvoices = A14:J34`, and `0` workbook links.

## Files

- Rollback copy retained in the project-room working area for this live workbook change.
- Final workbook was uploaded back to the same Teams/SharePoint item.
