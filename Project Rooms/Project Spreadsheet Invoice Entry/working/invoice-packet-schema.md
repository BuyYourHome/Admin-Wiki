# Invoice Packet Schema

Use this schema when Document Scan hands a scanned invoice or receipt packet to Project Spreadsheet Invoice Entry. Do not treat Email Summary or OfficeAssist as invoice-entry intake sources. Other intake sources are out of scope unless Wes separately approves and documents them.

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

## Handoff Boundary

The intake workflow should not edit the workbook. It should pass the packet to this project room for routing confirmation, duplicate check, insertion, and validation.
