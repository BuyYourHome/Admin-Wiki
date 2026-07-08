# Invoice Packet Schema

Use this schema when Document Scan hands a scanned invoice or receipt packet to Project Spreadsheet Invoice Entry. Other intake sources are out of scope unless Wes separately approves and documents them.

Lowes credit card statements are a special held source type. They may be routed here as invoice-like source material, but they should not be inserted until Wes approves a tested process for splitting statement line items by project and by worksheet/tab.

## Required Fields

| Field | Required | Notes |
| --- | --- | --- |
| `project_property` | yes | Property name or address. |
| `vendor_name` | yes | Vendor shown on invoice. |
| `invoice_date` | yes | Invoice date when available; otherwise mark missing. |
| `invoice_number` | no | Use when present. |
| `invoice_amount` | yes | Total amount to insert. |
| `work_category` | yes | Best known category, such as Plumbing Fixtures, HVAC, Paint, or Landscape. |
| `source_scan_path` | yes for Document Scan packets | Original scan or archived scan path used by Document Scan. |
| `saved_invoice_file_path` | yes | Teams/project-folder path where intake saved the invoice file. |
| `recommended_workbook` | yes | Active project-management workbook candidate. |
| `recommended_worksheet` | yes | Candidate worksheet or `Needs Review`. |
| `confidence_status` | yes | Suggested values: `Ready`, `Needs Review`, `Duplicate Risk`, `Missing Data`. |
| `notes` | no | Uncertainty, duplicate hints, or routing explanation. |

## Special Source Types

### Lowes Credit Card Statements

If the packet is for a Lowes credit card statement:

- Set `confidence_status` to `Needs Review - Lowes Statement`.
- Include the statement period and source file path in `notes` when available.
- Do not recommend a single worksheet unless the approved Lowes statement process later allows that.
- Do not insert line items into a workbook until the Lowes statement splitting process has been developed, tested, and approved by Wes.

## Handoff Boundary

The intake workflow should not edit the workbook. It should pass the packet to this project room for routing confirmation, duplicate check, insertion, and validation.
