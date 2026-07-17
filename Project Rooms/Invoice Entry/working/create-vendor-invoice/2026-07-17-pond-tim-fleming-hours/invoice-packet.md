# Create Vendor Invoice Packet - Tim Fleming Pond Hours

## Packet Status

- Status: `Held - Vendor verification draft pending Wes approval`
- Mode: `Create Vendor Invoice`
- Created: 2026-07-17
- Source type: Routed free-text vendor invoice email; no invoice attachment.
- Processing rule: Do not file as a final invoice, insert into a workbook, or mark ready for posting until the vendor confirms the generated invoice as accurate.

## Required Fields

| Field | Value |
| --- | --- |
| `project_property` | `26-BYH -908 Pond St` |
| `vendor_name` | `Tim Fleming` |
| `vendor_email` | `tflem04@gmail.com` |
| `invoice_date` | `2026-07-17` from source email date; vendor invoice date not provided |
| `invoice_number` | Not provided |
| `invoice_amount` | `$1,375.00` draft amount from 22 hours at `$62.50/hour`; pending vendor verification |
| `work_category` | `Needs Review - Labor / project work category not confirmed` |
| `source_email_sender` | `Wes Will Buy Your Home <WesWill@BuyYourHomeLLC.com>` forwarding `Tim Fleming <tflem04@gmail.com>` |
| `source_email_subject` | `FW: Pond hours week of 7/6-7/17` |
| `source_email_received_at` | `2026-07-17T19:44:46Z` |
| `source_email_id_or_link` | `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACdOJ36gAAAA==` / https://outlook.office365.com/owa/?ItemID=AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACdOJ36gAAAA%3D%3D&exvsurl=1&viewmodel=ReadMessageItem |
| `saved_invoice_file_path` | `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\create-vendor-invoice\2026-07-17-pond-tim-fleming-hours\tim-fleming-pond-hours-invoice-draft.pdf` pending vendor verification |
| `recommended_workbook` | `Property/26_Project Management - 908 Pond St 3.xlsm` |
| `recommended_worksheet` | `Needs Review` |
| `confidence_status` | `Needs Review - vendor verification required` |
| `notes` | Source supports vendor, project clue, date range, and total hours. Wes supplied the rate as `$62.50/hour`, producing a draft amount of `$1,375.00`. The packet still lacks invoice number, destination worksheet, and vendor confirmation of a generated invoice. |

## Source Details

- Routed source: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-17-194446-pond-hours-week-of-7-6-7-17.md`
- Has attachments: no
- Forwarded original sender: `Tim Fleming <tflem04@gmail.com>`
- Forwarded original sent time: 2026-07-17 3:12 PM
- Hours:
  - 2026-07-06 through 2026-07-10: 4 hours
  - 2026-07-13 through 2026-07-17: 18 hours
  - Total: 22 hours
- Rate supplied by Wes in the Invoice Entry chat: $62.50/hour.
- Draft total: $1,375.00.

## Duplicate Check

Preliminary project-room duplicate search found no prior Tim Fleming packet or log entry for this Pond hours item. The only hits for Tim Fleming / Pond hours / 22 hours were the routed source email and this new packet set. After Wes supplied the $62.50/hour rate, a project-room search found no prior hits for `$1,375.00`, `1375`, `$62.50`, or `62.5` tied to this invoice item.

Full workbook duplicate checking is deferred because the generated invoice is not final and required amount/rate data is missing. Before any later workbook insertion, run duplicate checks using:

- project + vendor + invoice number, if Tim provides an invoice number,
- project + vendor + invoice date + amount (`26-BYH -908 Pond St` + `Tim Fleming` + `2026-07-17` + `$1,375.00`),
- source email id/link,
- generated or vendor-confirmed invoice filename.

## Processing Decision

Do not insert into the project spreadsheet yet.

Reasons:

- no attached invoice,
- no invoice number,
- destination worksheet is not confirmed,
- generated invoice has not been reviewed by Wes or verified by Tim Fleming.

Next action: show Wes the verification email draft. If Wes approves the exact recipient list and text, send the polished generated invoice PDF to Tim Fleming for accuracy verification with Wes and Jenny copied.
