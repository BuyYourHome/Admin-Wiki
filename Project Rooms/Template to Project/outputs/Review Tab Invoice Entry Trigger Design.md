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
- A request marker labeled `Request Invoice Entry Review`.
- Marker choices `Not Requested` and `Requested`.
- Workbook name `invoiceEntryReviewRequest` pointing to the marker cell.

The workbook does not contain:

- Packet-building formulas.
- A packet-preview worksheet.
- Eligibility formulas.
- Duplicate-check logic.
- Destination-row insertion logic.
- VBA, Office Script, or Power Automate code for the pilot.

## Request Workflow

1. Wes completes `Destination Worksheet` and/or `Status` for the rows he has reviewed.
2. Wes changes `invoiceEntryReviewRequest` from `Not Requested` to `Requested`.
3. Invoice Entry retrieves the current workbook from Teams and reads `tblInvoiceReview` by header name.
4. Invoice Entry builds its request packet outside the workbook and performs its governed duplicate-check and insertion process.
5. After successful processing, Invoice Entry records the row results and returns the request marker to `Not Requested` as part of its own approved workflow.

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

Rows with `Status = Moved` are ignored. Hidden columns, filters, and screen position do not control eligibility; Invoice Entry reads table values by header name.

## Outrigger Pilot Implementation

Workbook:

```text
Property/27_Project Management - 7001 Outrigger Dr.xlsm
```

Implemented on 2026-07-13:

- Resized `tblInvoiceReview` from `B1:N16` to `A1:O16` so `Project/property` is part of the table.
- Added `Review Row ID` in column O.
- Assigned IDs `OUTRIGGER-REV-001` through `OUTRIGGER-REV-015` to the existing populated rows.
- Added `Request Invoice Entry Review` at `Review!Q1`.
- Added the `Not Requested` / `Requested` selector at `Review!Q2`.
- Added workbook name `invoiceEntryReviewRequest` referring to `Review!Q2`.
- Added no formulas, macros, scripts, packet sheets, or external workbook links.

Validation completed:

- The uploaded Teams workbook matched the verified local workbook byte for byte.
- Excel reopened the uploaded workbook cleanly.
- The worksheet list and existing Review values were unchanged.
- All existing formulas were unchanged.
- Workbook link count remained zero.

## Rollout Rule

Do not copy a formula-heavy request system into other project workbooks. Roll out only the approved table structure, stable row identifier, and request marker after Wes approves the Outrigger pilot.

For each project:

- Fetch the current workbook from Teams.
- Inspect that project's Review table independently.
- Preserve its existing data and workbook behavior.
- Add only missing approved fields.
- Assign project-specific stable IDs without overwriting existing IDs.
- Verify clean Excel open, unchanged formulas, unchanged existing Review values, and zero unintended workbook links before replacing the Teams file.

## Reusable Lesson

Keep the workbook as the request surface and source data only. Packet creation and Invoice Entry decisions belong in the Invoice Entry process, where rules can be changed without adding fragile workbook formulas or scripts to every project spreadsheet.
