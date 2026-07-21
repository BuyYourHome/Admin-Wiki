# Time Card Packet - Josh Kennedy Timesheet

## Packet Status

- Status: `Draft invoices created - verification email sent - Teams filing and spreadsheet posting held`
- Workflow: `Time Card`, calling `Create Vendor Invoice` for invoice document creation
- Created: 2026-07-20
- Source type: Routed free-text timesheet email; no invoice attachment.
- Processing rule: Treat `Timesheet` as Time Card-relevant under Wes's 2026-07-20 rule update. Email amended invoice drafts to the sender after each Time Card email, with Wes and Jenny copied. Do not copy invoices to Teams until the final end-of-week email is received.

## Source Details

- Routed source: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-20-204307-josh-kennedy-timesheet.md`
- Sender: `Josh Kennedy <IRAManager@SellYourHomeRaleigh.com>`
- Subject: `Timesheet`
- Received: `2026-07-20T20:43:07Z` / `2026-07-20 4:43:07 PM Eastern`
- Attachments: none
- Outlook message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACecWiBgAAAA==`
- Outlook web link: https://outlook.office365.com/owa/?ItemID=AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACecWiBgAAAA%3D%3D&exvsurl=1&viewmodel=ReadMessageItem

## Time Card Assumptions Applied

- Work date: `2026-07-20`, inferred from the email received date because the body did not state a separate work date.
- Worker/vendor: `Josh Kennedy`.
- Hourly rate: `$31.25/hour`, from the established Invoice Entry Time Card rule for Josh.
- Invoice numbers: created by Invoice Entry because the sender did not provide invoice numbers.
- Week ending date: `2026-07-24`.
- Split rule: create one invoice per project and one separate invoice for BackOffice when BackOffice time is present.

## Parsed Lines

| Invoice # | Project / bucket | Work date | Description | Hours | Rate | Amount | Status |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| `TC-JK-20260724-BACKOFFICE-001` | `BackOffice` | `2026-07-20` | Back-office onboarding, account setup, and rules/procedures review. | 4.00 | `$31.25` | `$125.00` | Draft invoice created; spreadsheet posting not applicable until BackOffice accounting path is approved. |
| `TC-JK-20260724-TENSITY-001` | `24-HM - 4121 Tensity Dr` | `2026-07-20` | 4121 Tensity Dr property walkthrough and review of planned changes/responsibilities. | 2.75 | `$31.25` | `$85.94` | Draft invoice created; workbook insertion held for destination worksheet/expense placement. |

Total parsed time: 6.75 hours. Total draft amount: `$210.94`.

## Generated Drafts

| Draft | Path |
| --- | --- |
| BackOffice invoice PDF | `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\create-vendor-invoice\2026-07-20-josh-kennedy-timesheet\26-07-24 - Josh Kennedy - Time Card - BackOffice - Week Ending 2026-07-24.pdf` |
| Tensity invoice PDF | `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\create-vendor-invoice\2026-07-20-josh-kennedy-timesheet\26-07-24 - Josh Kennedy - Time Card - 4121 Tensity Dr - Week Ending 2026-07-24.pdf` |

## Duplicate Check

Preliminary project-room duplicate search found no prior Josh Kennedy packet or processing log for this routed timesheet beyond:

- `sources\email\2026-07-20-204307-josh-kennedy-timesheet.md`,
- `working\source-inventory.md`,
- this packet.

No workbook duplicate check was performed because destination worksheet/expense placement is not approved.

## Processing Decision

- Draft invoices were generated from the Time Card source by calling the Create Vendor Invoice document pattern.
- Draft invoices were emailed to Josh Kennedy for accuracy verification with Wes and Jenny copied.
- No invoice was filed into a Teams project folder because this was not identified as the final end-of-week Time Card email.
- No workbook was edited.
- Tensity workbook candidate: `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`.
- Tensity spreadsheet insertion remains held until Wes confirms the destination worksheet or approved placement path.
- BackOffice accounting/spreadsheet path remains held until Wes confirms where BackOffice Time Card invoices should be recorded.
