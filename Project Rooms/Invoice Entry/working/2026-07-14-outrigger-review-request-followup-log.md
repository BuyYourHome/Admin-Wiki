# 2026-07-14 Outrigger Review Request Follow-up Log

## Workbook

- Teams workbook: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- SharePoint item id: `01ZGFUBDLI2T63UQHIQVGZVZH4LRMVCLTC`
- Source timestamp before processing: `2026-07-14T12:06:09Z`
- Upload timestamp after processing: `2026-07-14T12:16:06Z`
- Review table: `tblInvoiceReview`
- Request marker: `invoiceEntryReviewRequest`
- Request marker reference verified in Excel: `=Review!$B$1`

## Action

Processed destination-filled Review rows under the updated approval rule: a filled `Destination Worksheet` is approval to move unless status is an explicit stop such as `Hold`, `Do Not Move`, `Duplicate Risk`, or `Missing Data`.

## Duplicate Check

No duplicate-risk rows were found for the moved Windows & Doors or Plumbing Fixtures rows. The existing Cabinets row for GTI invoice `101492` was verified before correcting Review status.

## Status Corrected

| Review Row ID | Destination | Action |
| --- | --- | --- |
| `OUTRIGGER-REV-001` | `Cabinets` | Verified existing `tblCabinetsInvoices` row for GTI invoice `101492`; corrected Review status to `Moved`. |

## Rows Moved

| Review Row ID | Destination | Table | Sheet Row | Date | Vendor | Description | Item # | Qty | Cost/Unit | Amount |
| --- | --- | --- | ---: | --- | --- | --- | --- | ---: | ---: | ---: |
| `OUTRIGGER-REV-002` | `Windows & Doors` | `tblWindowsDoorsInvoices` | 39 | 2026-02-18 | Lowes | PFJCRWN L49 3-5/8-in x 9/16-in crown moulding | `171973` | 2 | 20.37 | 40.74 |
| `OUTRIGGER-REV-010` | `Windows & Doors` | `tblWindowsDoorsInvoices` | 40 | 2026-03-05 | Lowes | WRIGHT PRODUCTS Storm Door Satin Nickel Lockable Storm Door Replacement Handleset | `28827` | 1 | -75.03 | -75.03 |
| `OUTRIGGER-REV-011` | `Windows & Doors` | `tblWindowsDoorsInvoices` | 41 | 2026-03-05 | Lowes | LARSON Brushed Silver Lockable Storm Door Replacement Handleset | `3529255` | 1 | -59.48 | -59.48 |
| `OUTRIGGER-REV-012` | `Plumbing Fixtures` | `tblPlumbingFixturesInvoices` | 35 | 2026-03-05 | Lowes | EASTMAN Electric Water Heater Installation Kit | `758108` | 1 | -31.93 | -31.93 |
| `OUTRIGGER-REV-013` | `Windows & Doors` | `tblWindowsDoorsInvoices` | 42 | 2026-03-05 | Lowes | WRIGHT PRODUCTS 12.688-in EZ-Hold Adjustable White Aluminum Hold Open Screen/Storm Door Pneumatic Closer | `476952` | 1 | -28.48 | -28.48 |
| `OUTRIGGER-REV-015` | `Plumbing Fixtures` | `tblPlumbingFixturesInvoices` | 36 | 2026-03-06 | Lowes | RELIABILT Stainless Steel Toilet Tank-to-Bowl Bolts | `3625390` | 1 | 6.52 | 6.52 |

Each moved Review row was retained, set to `Moved`, and annotated with the destination worksheet/table and movement date.

## Rows Excluded

| Review Row ID | Destination | Status | Reason |
| --- | --- | --- | --- |
| `OUTRIGGER-REV-003` | `Exterior` | `Needs Review - Vendor Tab` | `Exterior` is outside approved Vendor Tabs Mode scope. Do not route to tabs right of `Landscape` without explicit scope expansion. |
| `OUTRIGGER-REV-014` | blank | `Needs Review - Allocation / Project` | Destination Worksheet is blank. |

## Validation

- Request checkbox cleared after processing: `invoiceEntryReviewRequest = FALSE`.
- Defined name still reopens as `=Review!$B$1`.
- `tblWindowsDoorsInvoices` final range after upload: `A11:J42`.
- `tblPlumbingFixturesInvoices` final range after upload: `A14:J36`.
- `Windows & Doors!M11` after insert: `897.3373`.
- `Plumbing Fixtures!L16` after insert: `1529.79505`.
- `Cabinets!L11` after status correction: `5563`.
- Excel workbook links: `0`.
- External-link package parts: `0`.
- Post-upload readback from Teams reopened with `invoiceEntryReviewRequest = FALSE`, expected table ranges, and `0` workbook links.

## Files

- Rollback copy retained in the project-room working area for this live workbook change.
- Final workbook was uploaded back to the same Teams/SharePoint item.
