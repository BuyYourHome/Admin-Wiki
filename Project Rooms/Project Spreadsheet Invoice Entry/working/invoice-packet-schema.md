# Invoice Packet Schema

Use this schema when Document Scan hands a scanned invoice or receipt packet to Project Spreadsheet Invoice Entry. Email Summary, OfficeAssist, or another approved workflow may also use this schema only as a secondary or future handoff source when it has a complete structured invoice packet.

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
| `source_email_sender` | yes for email-based packets | Sender of invoice email. Not required for Document Scan packets unless the scan came from a known email source. |
| `source_email_subject` | yes for email-based packets | Subject of invoice email. Not required for Document Scan packets unless the scan came from a known email source. |
| `source_email_received_at` | yes for email-based packets | Received date/time. Not required for Document Scan packets unless the scan came from a known email source. |
| `source_email_id_or_link` | no | Message ID or Outlook link when available. |
| `saved_invoice_file_path` | yes | Teams/project-folder path where intake saved the invoice file. |
| `recommended_workbook` | yes | Active project-management workbook candidate. |
| `recommended_worksheet` | yes | Candidate worksheet or `Needs Review`. |
| `confidence_status` | yes | Suggested values: `Ready`, `Needs Review`, `Duplicate Risk`, `Missing Data`. |
| `notes` | no | Uncertainty, duplicate hints, or routing explanation. |

## Handoff Boundary

The intake workflow should not edit the workbook. It should pass the packet to this project room for routing confirmation, duplicate check, insertion, and validation.
