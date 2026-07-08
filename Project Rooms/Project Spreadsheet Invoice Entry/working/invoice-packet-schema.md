# Invoice Packet Schema

Use this schema when Document Scan hands a scanned invoice, receipt, or Statement Mode packet to Project Spreadsheet Invoice Entry. Other intake sources are out of scope unless Wes separately approves and documents them.

Document Scan owns Lowes Statement Mode extraction and will send extracted statement data for Project Spreadsheet Invoice Entry to consume. Statement Mode packets should not be inserted until Wes approves a tested process for allocating statement line items by project and by worksheet/table.

## Required Fields

| Field | Required | Notes |
| --- | --- | --- |
| `project_property` | yes | Property name or address. For Statement Mode, use `Needs Allocation` or `Multiple` when line items span projects. |
| `vendor_name` | yes | Vendor shown on invoice. |
| `invoice_date` | yes | Invoice date when available; otherwise mark missing. |
| `invoice_number` | no | Use when present. |
| `invoice_amount` | yes | Total amount to insert. |
| `work_category` | yes | Best known category, such as Plumbing Fixtures, HVAC, Paint, or Landscape. For Statement Mode, use `Needs Allocation` or `Multiple` when line items span categories. |
| `source_scan_path` | yes for Document Scan packets | Original scan or archived scan path used by Document Scan. |
| `saved_invoice_file_path` | yes | Teams/project-folder path where intake saved the invoice file. |
| `recommended_workbook` | yes | Active project-management workbook candidate. For Statement Mode, use `Needs Allocation` or list likely project workbooks only when supported by the extracted line data. |
| `recommended_worksheet` | yes | Candidate worksheet or `Needs Review`. For Statement Mode, use `Needs Allocation` unless every line item has approved worksheet allocation. |
| `confidence_status` | yes | Suggested values: `Ready`, `Needs Review`, `Duplicate Risk`, `Missing Data`, `Needs Review - Statement Mode`. |
| `notes` | no | Uncertainty, duplicate hints, or routing explanation. |

## Special Source Types

### Statement Mode Packets

If the packet is for extracted statement data:

- Set `confidence_status` to `Needs Review - Statement Mode`.
- Include the statement period and filed statement PDF path.
- Include extracted line items when available, with transaction date, description, amount, page/source reference, and extraction confidence.
- Do not recommend a single workbook or worksheet unless the approved Statement Mode process allows that for the specific line item.
- Do not insert line items into a workbook until the Statement Mode allocation process has been developed, tested, and approved by Wes.

## Handoff Boundary

The intake workflow should not edit the workbook. It should pass the packet to this project room for routing confirmation, duplicate check, insertion, and validation. For Statement Mode, Document Scan owns extraction and Project Spreadsheet Invoice Entry owns allocation and insertion decisions.
