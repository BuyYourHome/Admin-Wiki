# Create Vendor Invoice Packet - Tim Fleming Pond Hours

## Packet Status

- Status: `Vendor confirmed - filed to project folder - spreadsheet placement held`
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
| `invoice_date` | `2026-07-17` from source email and vendor confirmation date; vendor invoice date not otherwise provided |
| `invoice_number` | Not provided by vendor |
| `invoice_amount` | `$1,375.00` confirmed by vendor reply: 22 hours at `$62.50/hour` |
| `work_category` | `Needs Review - Labor / project work category not confirmed` |
| `source_email_sender` | `Wes Will Buy Your Home <WesWill@BuyYourHomeLLC.com>` forwarding `Tim Fleming <tflem04@gmail.com>` |
| `source_email_subject` | `FW: Pond hours week of 7/6-7/17` |
| `source_email_received_at` | `2026-07-17T19:44:46Z` |
| `source_email_id_or_link` | `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACdOJ36gAAAA==` / https://outlook.office365.com/owa/?ItemID=AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACdOJ36gAAAA%3D%3D&exvsurl=1&viewmodel=ReadMessageItem |
| `saved_invoice_file_path` | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\26-BYH -908 Pond St\Owning\Tim Flemming\26-07-17 Tim Fleming Pond Hours.pdf` |
| `recommended_workbook` | `Property/26_Project Management - 908 Pond St 3.xlsm` |
| `recommended_worksheet` | `Needs Review` |
| `confidence_status` | `Needs Review - worksheet placement` |
| `notes` | Source supports vendor, project clue, date range, total hours, rate, and total amount. Tim Fleming confirmed the generated invoice by replying "Correct" on 2026-07-17 and again "This is correct and confirmed" on 2026-07-22. The packet still lacks invoice number and destination worksheet. |

## Source Details

- Routed source: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-17-194446-pond-hours-week-of-7-6-7-17.md`
- Vendor confirmation source: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-17-201803-tim-fleming-pond-hours-verification.md`
- Additional vendor confirmation source: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-22-121356-tim-fleming-pond-hours-confirmation.md`
- Has attachments: no
- Forwarded original sender: `Tim Fleming <tflem04@gmail.com>`
- Forwarded original sent time: 2026-07-17 3:12 PM
- Hours:
  - 2026-07-06 through 2026-07-10: 4 hours
  - 2026-07-13 through 2026-07-17: 18 hours
  - Total: 22 hours
- Rate supplied by Wes in the Invoice Entry chat: $62.50/hour.
- Confirmed total: $1,375.00.

## Duplicate Check

Preliminary project-room duplicate search found no prior Tim Fleming packet or log entry for this Pond hours item. The only hits for Tim Fleming / Pond hours / 22 hours were the routed source email, vendor confirmation source, and this packet set. After Wes supplied the $62.50/hour rate, a project-room search found no prior hits for `$1,375.00`, `1375`, `$62.50`, or `62.5` tied to this invoice item beyond this packet.

Read-only workbook duplicate check:

- The workbook contains an older `Tim` sheet with prior `Tim Flemming` contract/payment rows, but no row matching this 2026-07-06 through 2026-07-17 Pond hours invoice was found.
- `1375` text appeared in workbook internals, but not as a Tim Fleming Pond hours duplicate.
- The `Review` sheet did not contain this Tim Fleming invoice.
- Strongest duplicate key is unavailable because no invoice number was provided.
- Fallback key checked: project + vendor + invoice date + amount (`26-BYH -908 Pond St` + `Tim Fleming` + `2026-07-17` + `$1,375.00`).

## Processing Decision

Do not insert into the project spreadsheet yet.

Reasons:

- no invoice number,
- destination worksheet is not confirmed.

Next action: Wes should identify the destination worksheet or approved placement path. Do not insert into the workbook until placement is clear and duplicate checks are rerun immediately before insertion.
