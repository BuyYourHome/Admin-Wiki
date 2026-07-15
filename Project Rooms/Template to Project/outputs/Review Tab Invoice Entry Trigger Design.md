# Review Tab Invoice Entry Request Design

Date: 2026-07-13

## Purpose

Give Wes a simple workbook-side way to mark that the `Review` tab is ready for Invoice Entry without putting packet-building, duplicate-check, routing, or row-movement logic into the workbook.

## Ownership Boundary

`Template to Project` owns:

- The `Review` worksheet structure.
- The Review table, stable row identifiers, and request marker.
- Preservation and rollout of the approved workbook design.

`Invoice Entry` owns:

- Retrieving the current Teams workbook after a request.
- Reading Review data by table header name.
- Determining eligible rows.
- Building the structured request packet.
- Duplicate checks and destination-table insertion.
- Updating completed rows and validating the workbook.

The workbook must not perform duplicate checks or move rows into destination tables.

## Approved Lean Design

Use the existing Review table and one request marker.

The workbook contains:

- Review data in `tblInvoiceReview`.
- `Project/property` as a column inside the table.
- A stable `Review Row ID` for each populated row.
- `Import Date` immediately before the invoice-date column. It is a fixed processing date written by Invoice Entry, not a volatile formula.
- A controlled dropdown in the `Status` table column.
- A native in-cell checkbox at `Review!B1` labeled `Needs Invoice Entry Review` in `Review!A1`.
- An unchecked/`FALSE` value for no request and a checked/`TRUE` value when Invoice Entry review is needed.
- Workbook name `invoiceEntryReviewRequest` pointing absolutely to `Review!B1`.

The workbook does not contain:

- Packet-building formulas.
- A packet-preview worksheet.
- Eligibility formulas.
- Duplicate-check logic.
- Destination-row insertion logic.
- VBA, Office Script, or Power Automate code for the pilot.

## Request Workflow

1. Wes completes `Destination Worksheet` and/or `Status` for the rows he has reviewed.
2. Wes checks the `Needs Invoice Entry Review` checkbox in `Review!B1`.
3. Invoice Entry retrieves the current workbook from Teams and reads `tblInvoiceReview` by header name.
4. Invoice Entry builds its request packet outside the workbook and performs its governed duplicate-check and insertion process.
5. After successful processing, Invoice Entry records the row results and clears the checkbox as part of its own approved workflow.

Changing the marker alone does not currently send an automatic message or start a background process. Automatic notification would require a separately approved monitor or Power Automate handoff. That external handoff must remain lightweight and must not move Invoice Entry logic into the workbook.

## Row Identification

Every populated Review row must have a stable `Review Row ID` that survives sorting and filtering. Do not use the visible Excel row number as the identifier.

Outrigger pilot format:

```text
OUTRIGGER-REV-001
```

Future projects should use a project-specific prefix and a stable sequence or source identifier. Existing IDs must not be regenerated merely because a row moves.

## Packet Contents

Invoice Entry builds the packet from the current Teams workbook. The packet should include:

- Project/property.
- Teams workbook path and workbook identity.
- Request timestamp and request ID.
- Review worksheet and table name.
- Stable Review Row IDs.
- Current row values needed for traceability, duplicate checks, and insertion.
- Requested action: duplicate-check and copy approved rows to destination tables.

`Status` uses only:

- `Needs Review`
- `Ready`
- `Posted`
- `Copied - Needs Owner Verification`
- `Hold`
- `Duplicate Risk`
- `Missing Data`
- `Do Not Move`

`Posted` is final and the Review row remains as the audit record. Legacy `Moved` values are treated as `Posted`. `Ready` alone is not enough to post; Destination Worksheet and required traceability fields must also be present. `Hold`, `Duplicate Risk`, `Missing Data`, and `Do Not Move` prevent posting. Hidden columns, filters, and screen position do not control eligibility; Invoice Entry reads table values by header name.

## Outrigger Pilot Implementation

Workbook:

```text
Property/27_Project Management - 7001 Outrigger Dr.xlsm
```

Implemented on 2026-07-13:

- Resized `tblInvoiceReview` from `B1:N16` to `A1:O16` so `Project/property` is part of the table.
- Added `Review Row ID` in column O.
- Assigned IDs `OUTRIGGER-REV-001` through `OUTRIGGER-REV-015` to the existing populated rows.
- Moved `tblInvoiceReview` down three rows to `A4:O19`.
- Added `Needs Invoice Entry Review` at `Review!A1` and a native in-cell checkbox at `Review!B1`.
- Preserved the prior `Requested` state by initially setting the checkbox to checked/`TRUE`.
- Added workbook name `invoiceEntryReviewRequest` referring absolutely to `Review!B1`.
- Added no formulas, macros, scripts, packet sheets, or external workbook links.

Validation completed:

- The uploaded Teams workbook matched the verified local workbook byte for byte.
- Excel reopened the uploaded workbook cleanly.
- The worksheet list and existing Review values were unchanged.
- All existing formulas were unchanged.
- Workbook link count remained zero.

Updated on 2026-07-15:

- Inserted `Import Date` immediately before the existing `Invoice date` column without populating unsupported historical dates.
- Applied the eight-value controlled Status dropdown to every `tblInvoiceReview` data row.
- Converted 13 legacy `Moved` values to `Posted`.
- Normalized three legacy `Needs Review - ...` values to `Needs Review`.
- Preserved `invoiceEntryReviewRequest = Review!$B$1`, the visible native request checkbox, all 31,795 formulas, Automatic calculation with iteration enabled, and zero external links.
- Replaced the exact Teams item and validated the downloaded replacement byte for byte at SHA-256 `A8217E759738416CE2E65381E9089E3CDF1A638AAF43320CF1649AFFF328CEC4`.
- The same four pre-existing formula errors remained outside Review: `Profit!L82`, `Profit!L84`, `MOG!E16`, and `MOG!E26`.

## Rollout Rule

Do not copy a formula-heavy request system into other project workbooks. Roll out only the approved table structure, stable row identifier, and request marker after Wes approves the Outrigger pilot.

The controlled Status dropdown and Import Date design was rolled out to all approved active project workbooks on 2026-07-15. See [[Review Status Dropdown - Active Projects Rollout - 2026-07-15]] for workbook hashes, validation results, and Teams links.

For each project:

- Fetch the current workbook from Teams.
- Inspect that project's Review table independently.
- Preserve its existing data and workbook behavior.
- Add only missing approved fields.
- Assign project-specific stable IDs without overwriting existing IDs.
- Verify clean Excel open, unchanged formulas, unchanged existing Review values, and zero unintended workbook links before replacing the Teams file.

## Reusable Lesson

Keep the workbook as the request surface and source data only. Packet creation and Invoice Entry decisions belong in the Invoice Entry process, where rules can be changed without adding fragile workbook formulas or scripts to every project spreadsheet.

When creating or repointing workbook names, use absolute references such as `=Review!$B$1`. A relative name such as `=Review!B1` can reopen at a different cell depending on Excel's active-cell context. Validate the name's `RefersTo` value after reopening the saved workbook through Excel; package-level inspection alone may show the intended text without detecting Excel's relative-reference interpretation.
