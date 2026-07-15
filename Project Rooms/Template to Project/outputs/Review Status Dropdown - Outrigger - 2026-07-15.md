# Review Status Dropdown - Outrigger

Date: 2026-07-15

## Workbook

- Teams file: `Property/27_Project Management - 7001 Outrigger Dr.xlsm`
- SharePoint item ID: `01ZGFUBDLI2T63UQHIQVGZVZH4LRMVCLTC`
- Updated Teams timestamp: `2026-07-15T18:47:48Z`

## Changes

- Inserted `Import Date` immediately before the existing `Invoice date` column in `tblInvoiceReview`.
- Left historical Import Date cells blank because the workbook change date is not the invoice-processing date.
- Applied the approved eight-value dropdown to the entire `Status` data column.
- Converted 13 legacy `Moved` values to `Posted`.
- Normalized three legacy values beginning with `Needs Review` to `Needs Review`.
- Preserved the detailed review explanations in the existing Review/reason fields.

## Validation

- Review table range: `A4:P22`
- Status validation failures: `0`
- Invalid controlled statuses: `0`
- Remaining legacy `Moved` values: `0`
- Posted rows: `13`
- Request marker: `invoiceEntryReviewRequest = Review!$B$1`
- Request checkbox: visible, native, unchecked
- Formula count before/after: `31,795`
- External links: `0`
- Calculation: Automatic; iteration enabled
- Exact local/Teams roundtrip SHA-256: `A8217E759738416CE2E65381E9089E3CDF1A638AAF43320CF1649AFFF328CEC4`

The exact Teams-downloaded replacement reopened cleanly. The four formula errors at `Profit!L82`, `Profit!L84`, `MOG!E16`, and `MOG!E26` were present in the untouched baseline and were not introduced by this Review change.

## Rollout Lesson

Do not leave legacy explanatory text in a controlled Status column. Map legacy completion states to `Posted`, map legacy `Needs Review - ...` variants to `Needs Review`, and preserve the explanation in the Review/reason fields. Apply validation to the table data column by header name and verify every existing value against the approved list before upload.
