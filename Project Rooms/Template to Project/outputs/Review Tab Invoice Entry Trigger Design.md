# Review Tab Invoice Entry Trigger Design

Date: 2026-07-13

## Purpose

Add a workbook-side mechanism on the `Review` tab that lets Wes request Invoice Entry review of eligible rows after `Destination Worksheet` and supporting review fields have been filled.

The workbook-side trigger must not move rows into vendor tables. Its only job is to identify eligible `Review` rows by table/header data and create a structured request packet for Invoice Entry.

## Ownership Boundary

`Template to Project` owns:

- `Review` tab structure.
- Workbook-side button/trigger design.
- Office Script or Power Automate trigger design.
- Required table columns and row identifiers.
- Rollout design across active project workbooks.
- Workbook preservation rules for formulas, formatting, tables, links, controls, and existing behavior.

`Invoice Entry` owns:

- Consuming the request packet.
- Duplicate checks.
- Final copy or movement into destination vendor tables.
- Validation of destination table totals and downstream links.
- Updating row status after completed insertion.
- Uploading the verified workbook when authorized.

## Recommended Implementation Path

Use an Office Script plus Power Automate design as the target implementation, with a manual packet-export preview as the first pilot.

Reason:

- Office Scripts are supported for Excel workbooks and can be run from a workbook button or from Power Automate.
- Power Automate can run an Office Script against a SharePoint/Teams workbook and then create or route the request packet.
- Keeping the Office Script as a pure workbook reader/packet builder avoids macro dependence and avoids making the script responsible for external workflow actions.
- Microsoft documents that scripts can be combined with Power Automate, but scripts run through Power Automate have platform/security limits. External calls should be handled by Power Automate actions, not by the script.

Recommended phases:

1. Pilot packet builder in one workbook.
   - Add a `Review` tab button labeled `Request Invoice Entry Review`.
   - The button runs an Office Script that reads `tblReview` by header name, builds a request packet, and writes a packet preview to a hidden or clearly marked `Invoice Entry Request` sheet.
   - The script does not move rows and does not write to vendor tabs.

2. Add Power Automate handoff.
   - A manually triggered or workbook-linked flow runs the same Office Script against the selected Teams/SharePoint workbook.
   - The flow receives the JSON packet returned by the script.
   - The flow saves the packet as a JSON or Markdown file in the Invoice Entry packet intake location, or sends a structured handoff message to the Invoice Entry chat if that connector path is approved.
   - The flow, not the Office Script, performs any external file creation, message sending, or webhook/API call.

3. Roll out after approval.
   - Add the same `Review` table columns, script, button, and flow mapping to active project workbooks.
   - Validate one project first, then continue by approved rollout batch.

## Why Not VBA First

VBA can create a familiar desktop button, but it is a weaker first choice for this workflow because the project workbooks live in Teams/SharePoint and may be used in Excel Online. VBA also increases macro/security handling and is less suitable for a repeatable cloud-side handoff.

Use VBA only as a fallback for a desktop-only pilot if Office Script or Power Automate cannot meet the workflow need.

## Review Tab Button

Button label:

```text
Request Invoice Entry Review
```

Button behavior:

- Reads `tblReview` by table and column header.
- Ignores filtered, hidden, or off-screen state.
- Selects eligible rows using data values only.
- Creates a request packet.
- Shows a simple result such as packet id, eligible row count, and rows excluded for missing required fields.
- Does not change destination vendor tables.
- Does not set any row to `Moved`.

Optional workbook-side output:

- Add a hidden or plain utility sheet named `Invoice Entry Request`.
- Add a table named `tblInvoiceEntryRequests`.
- Store one row per generated packet:
  - `Request ID`
  - `Requested At`
  - `Requested By`
  - `Project/Property`
  - `Workbook Path`
  - `Review Table`
  - `Eligible Row Count`
  - `Excluded Row Count`
  - `Packet JSON`
  - `Packet Status`
  - `Notes`

This table is a request log, not the insertion log. Invoice Entry still owns insertion results.

## Required Review Table

Recommended table name:

```text
tblReview
```

Required columns:

| Column | Purpose |
| --- | --- |
| `Review Row ID` | Stable row identifier. Do not depend on row number because sorting/filtering can change row position. |
| `Source Type` | Invoice, Receipt, Statement Line, Manual Review, or other approved source type. |
| `Source Packet ID` | Packet or intake identifier from Doc Scan or another approved source. |
| `Source Line ID` | Statement/invoice line identifier when a packet contains multiple rows. |
| `Project/Property` | Project or property name/address. |
| `Vendor` | Vendor name used for duplicate checks and destination row entry. |
| `Invoice Date` | Invoice, receipt, transaction, or statement-line date. |
| `Invoice #` | Invoice, receipt, reference, or transaction number when available. Format as text. |
| `Description` | Clean destination description. For Lowes statement items, this should be the clean item description. |
| `Amount` | Amount to insert or credit. |
| `Tax` | Tax amount when separately known. Blank is allowed when not known or not applicable. |
| `Qty` | Quantity when useful for destination vendor table mapping. |
| `Item #` | SKU/item number when useful for destination vendor table mapping. |
| `Destination Worksheet` | Target worksheet recommendation. Required for request eligibility. |
| `Destination Table` | Optional target table name if known, such as `tblFlooringInvoices`. |
| `Status` | Workflow status. `Moved` means ignore for future packets. |
| `Source File` | Filed invoice/statement path or filename for traceability. |
| `Source Email/Message ID` | Optional source email or message id when available. |
| `Notes` | Review notes, uncertainty, allocation notes, or duplicate-risk comments. |
| `Requested At` | Last packet request timestamp for this row. |
| `Request ID` | Last request id that included this row. |

Optional support columns:

- `Review Created At`
- `Review Created By`
- `Destination Confidence`
- `Duplicate Check Key`
- `Invoice Entry Result`
- `Moved At`
- `Moved By`

## Row Identifier Rule

Every `tblReview` row that may later be requested must have a stable `Review Row ID`.

Recommended format:

```text
REV-{project-number-or-short-code}-{yyyymmddhhmmss}-{sequence}
```

Example:

```text
REV-27-20260713143022-0004
```

If a row is missing `Review Row ID`, the packet-builder script may create one before building the packet. It should not use the visible Excel row number as the durable identifier.

## Eligibility Rules

Eligible rows must satisfy all of these:

- `Destination Worksheet` is filled.
- `Status` is not `Moved`.
- `Status` is not a hold/exclusion value such as `Hold`, `Do Not Move`, `Duplicate Risk`, `Missing Data`, or `Needs Review`.
- Required traceability fields are present enough for Invoice Entry to audit the source:
  - `Review Row ID`
  - `Project/Property`
  - `Vendor`
  - `Invoice Date` or transaction date
  - `Amount`
  - `Source File` or `Source Packet ID`
- At least one duplicate-check identifier is present:
  - `Invoice #`, or
  - `Source Line ID`, or
  - `Source Packet ID` plus row/source line detail.

Allowed ready statuses:

- blank
- `Ready`
- `Approved`
- `Ready for Invoice Entry`
- `Requested`, when a prior request needs to be resent

Ignored statuses:

- `Moved`
- `Hold`
- `Do Not Move`
- `Duplicate Risk`
- `Missing Data`
- `Needs Review`

If Wes wants every non-`Moved` row with a destination to be packeted, the script can support that as a mode option, but the default should avoid sending known hold/problem rows.

## Packet Schema

Packet format should be JSON first because it is easier for Power Automate, scripts, and Invoice Entry to consume reliably. A Markdown summary can be created from the same data for human review.

Example:

```json
{
  "packet_type": "review_move_request",
  "schema_version": "1.0",
  "requested_action": "duplicate-check and copy approved rows to destination tables",
  "requested_by": "Wes",
  "requested_at": "2026-07-13T14:30:22-04:00",
  "request_id": "RMR-27-20260713-143022",
  "project_property": "7001 Outrigger Dr",
  "workbook": {
    "name": "27_Project Management - 7001 Outrigger Dr.xlsm",
    "teams_path": "Property/27_Project Management - 7001 Outrigger Dr.xlsm",
    "sharepoint_item_id": "",
    "web_url": ""
  },
  "review_table": {
    "worksheet": "Review",
    "table_name": "tblReview"
  },
  "eligibility": {
    "included_statuses": ["", "Ready", "Approved", "Ready for Invoice Entry", "Requested"],
    "ignored_statuses": ["Moved", "Hold", "Do Not Move", "Duplicate Risk", "Missing Data", "Needs Review"]
  },
  "summary": {
    "eligible_row_count": 2,
    "excluded_row_count": 1
  },
  "rows": [
    {
      "review_row_id": "REV-27-20260713143022-0001",
      "source_type": "Statement Line",
      "source_packet_id": "LOWES-5997-2026-03-17",
      "source_line_id": "4",
      "project_property": "7001 Outrigger Dr",
      "vendor": "Lowes",
      "invoice_date": "2026-02-17",
      "invoice_number": "83160",
      "description": "INSTALL KIT-ELECTRIC WH",
      "amount": 31.93,
      "tax": null,
      "qty": 1,
      "item_number": "000000000758108",
      "destination_worksheet": "Plumbing Fixtures",
      "destination_table": "",
      "status": "Ready",
      "source_file": "Property/27-HM-7001 Outrigger Dr/Owning/2026-03-17 - Lowes PRO BYH 5997.pdf",
      "source_email_message_id": "",
      "notes": "Ready for Invoice Entry duplicate check; Review-first."
    }
  ],
  "excluded_rows": [
    {
      "review_row_id": "REV-27-20260713143022-0003",
      "reason": "Destination Worksheet is blank"
    }
  ]
}
```

## Office Script Design

The Office Script should:

1. Open the active workbook context.
2. Find worksheet `Review`.
3. Find table `tblReview`.
4. Read headers and rows using table APIs.
5. Normalize header names by trimming spaces and matching case-insensitively.
6. Validate required columns.
7. Assign missing `Review Row ID` values when enough row data exists.
8. Build eligible row objects by header name.
9. Write request metadata to `tblInvoiceEntryRequests` if that sheet/table exists or create it during the pilot.
10. Return the JSON packet to the caller.

The Office Script should not:

- Move rows to vendor tabs.
- Edit destination worksheets.
- Mark rows as `Moved`.
- Depend on row visibility, current filter, active selection, or screen state.
- Use external API calls.
- Refresh external data connections.

## Power Automate Design

The Power Automate flow should:

1. Be manually triggered for the pilot, or triggered from an approved workbook/process button later.
2. Receive or identify the target workbook path.
3. Run the Office Script against the workbook.
4. Receive the packet JSON as the script result.
5. Save the packet in an approved Invoice Entry intake location, with a filename like:

```text
review-move-request-{project}-{timestamp}.json
```

6. Optionally create a human-readable Markdown summary next to the JSON packet.
7. Optionally notify the dedicated Invoice Entry chat with the packet path and short summary, if that messaging path is approved.

The flow should not:

- Move rows into vendor tables.
- Mark rows as `Moved`.
- Approve or reject duplicates.
- Change accounting or payment status.

## Workbook Preservation Rules

During implementation and rollout:

- Preserve the existing `Review` table structure unless a column addition is approved.
- Add columns to the right side of `tblReview` where possible to reduce disruption.
- Preserve formulas, formatting, table names, named ranges, workbook links, selectors, macros, and existing workbook behavior.
- Do not rely on hidden or filtered screen state.
- Do not create external workbook links.
- Do not require `.xlsx`/`.xlsm` format changes unless a separate workbook-format decision is approved.
- Keep any button text clear and non-destructive.

## Rollout Risks

| Risk | Mitigation |
| --- | --- |
| Different active project workbooks have different `Review` table structures. | Inventory current Review columns before rollout and add only approved missing columns. |
| Row numbers change after sorting/filtering. | Use stable `Review Row ID`, never visible row number. |
| Office Script button behavior differs between Excel desktop and Excel Online. | Pilot with the exact Teams/SharePoint workbook path and test both common use contexts. |
| Office Script cannot safely start external workflow directly. | Keep script as packet builder; let Power Automate save/send the packet. |
| Packet includes rows that still need human review. | Default to explicit ready statuses and exclude hold/problem statuses. |
| Duplicate request packets are created. | Include `Request ID`, `Requested At`, and row-level `Request ID`; Invoice Entry should treat duplicate request IDs as idempotent. |
| Workbook links or formulas are disturbed by structural changes. | Validate workbook links, formula errors, table names, and downstream references after adding trigger components. |
| Macro-enabled workbook behavior is accidentally changed. | Avoid VBA first; if macros remain, preserve all existing VBA project parts and test clean open/save. |

## Validation Checklist

Before approving the trigger design for rollout:

- `Review` sheet contains `tblReview`.
- All required columns exist or are deliberately mapped.
- `Review Row ID` is stable and present for eligible rows.
- Button label is visible and clearly non-destructive.
- Running the button/script creates a packet but does not move rows to vendor tabs.
- Rows with `Status = Moved` are ignored.
- Rows with blank `Destination Worksheet` are excluded.
- Hidden or filtered rows are still evaluated from table data.
- Packet includes workbook path, timestamp, table name, row identifiers, row values, and requested action.
- Packet can be consumed by Invoice Entry without rereading screen state.
- Workbook opens cleanly after save.
- No unintended external workbook links are added.
- Existing formulas, formatting, selectors, table structure, and named ranges are preserved.
- Power Automate handoff saves or routes the packet without changing workbook contents beyond approved request-log fields.

## Open Decisions For Wes

- Should `Needs Review` rows with a filled `Destination Worksheet` be excluded by default, or should all non-`Moved` rows be sent?
- Should the request button write `Requested At` and `Request ID` back to each included Review row, or only log the request on the `Invoice Entry Request` sheet?
- Should the packet go to a file-drop folder first, or should it directly message the Invoice Entry chat once that connector path is proven?
- Should `Destination Table` be required when a worksheet has more than one possible vendor/actual table, or should Invoice Entry infer the table from the worksheet mode rules?

## Source References

- Template to Project rules: `C:\Codex\Wiki Files\Project Rooms\Template to Project\README.md`
- Vendor Tabs Mode rules: `C:\Codex\Wiki Files\Project Rooms\Template to Project\Worksheet Modes\Vendor Tabs Mode Rules.md`
- Invoice Entry packet/schema rules: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\invoice-packet-schema.md`
- Invoice Entry README boundary rules: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\README.md`
- Microsoft Office Scripts overview: `https://learn.microsoft.com/en-us/office/dev/scripts/overview/excel`
- Microsoft Office Scripts with Power Automate: `https://learn.microsoft.com/en-us/office/dev/scripts/develop/power-automate-integration`
- Microsoft Office Scripts platform limits: `https://learn.microsoft.com/en-us/office/dev/scripts/testing/platform-limits`
