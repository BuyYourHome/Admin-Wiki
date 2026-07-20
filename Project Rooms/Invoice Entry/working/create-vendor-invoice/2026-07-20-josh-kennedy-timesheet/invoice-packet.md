# Create Vendor Invoice Packet - Josh Kennedy Timesheet

## Packet Status

- Status: `Held - missing invoice fields and placement`
- Workflow: `Create Vendor Invoice`
- Created: 2026-07-20
- Source type: Routed free-text contractor/project-cost email; no invoice attachment.
- Processing rule: Do not create a final invoice, send a verification email, file to Teams, or insert into a workbook until the held fields below are resolved.

## Required Fields

| Field | Value |
| --- | --- |
| `project_property` | `24-HM - 4121 Tensity Dr` is a likely project clue from the source text, but allocation is not final. |
| `vendor_name` | `Josh Kennedy` |
| `vendor_email` | `IRAManager@SellYourHomeRaleigh.com` |
| `invoice_date` | Missing; source email received `2026-07-20T20:43:07Z`, but the worked date is not stated in the body. |
| `invoice_number` | Not provided |
| `invoice_amount` | Missing; the source reports time but does not state rate or total amount. |
| `work_category` | `Needs Review - labor / onboarding / project management` |
| `source_email_sender` | `Josh Kennedy <IRAManager@SellYourHomeRaleigh.com>` |
| `source_email_subject` | `Timesheet` |
| `source_email_received_at` | `2026-07-20T20:43:07Z` |
| `source_email_id_or_link` | `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACecWiBgAAAA==` / https://outlook.office365.com/owa/?ItemID=AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACecWiBgAAAA%3D%3D&exvsurl=1&viewmodel=ReadMessageItem |
| `saved_invoice_file_path` | Not created or filed |
| `recommended_workbook` | `Property/24_Project Management - 4121 Tensity Dr 2.xlsm` is the likely workbook if Wes confirms the project allocation. |
| `recommended_worksheet` | `Needs Review` |
| `confidence_status` | `Missing Data - held before invoice creation and insertion` |
| `notes` | Source supports sender, total elapsed time of 6 hours 45 minutes, and a 4121 Tensity Dr project clue. Source does not state work date, invoice number, rate, amount, final project allocation, or destination worksheet. The direct handoff also instructed Invoice Entry not to infer hourly rate, amount, project allocation, or approval beyond the source. |

## Source Details

- Routed source: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-20-204307-josh-kennedy-timesheet.md`
- Has attachments: no
- Body reports:
  - `10A.M to 4:45P.M.`
  - back-office onboarding, account setup, rules and procedures,
  - `10A.M. to 2P.M. 4121 Tensity Dr`,
  - `2P.M. to 4:45 P.M.` property walkthrough and review of planned changes/responsibilities.
- Calculated elapsed time from the stated span: 6 hours 45 minutes.

## Duplicate Check

Preliminary project-room duplicate search found no prior Josh Kennedy packet or processing log for this routed timesheet beyond:

- `sources\email\2026-07-20-204307-josh-kennedy-timesheet.md`,
- `working\source-inventory.md`,
- this packet.

No workbook duplicate check was performed because the packet is held before workbook insertion.

## Processing Decision

Do not create a final invoice, send it to Josh for verification, file it to Teams, or insert it into the Tensity workbook yet.

Reasons:

- source subject is `Timesheet`, not the currently supported `Time Card` trigger,
- worked date is not stated,
- rate and total amount are not in the source and the handoff explicitly says not to infer them,
- the Tensity project clue is present but the final allocation is not confirmed,
- destination worksheet/expense area is not confirmed,
- no invoice number was provided.

Next action: Wes should confirm whether this source should be handled as Time Card despite the `Timesheet` subject, confirm the worked date, confirm whether the known Josh rate may be applied to this item, confirm project allocation to Tensity, and identify the destination worksheet or approved placement path.
