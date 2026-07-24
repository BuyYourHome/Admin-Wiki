# Processing Log - Josh Kennedy Timesheet

## 2026-07-20

- Received Route Vendor Invoice handoff from Email Monitor for routed source `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-20-204307-josh-kennedy-timesheet.md`.
- Read the routed source. No attachments were supplied.
- Applied Wes's updated Time Card rules:
  - `Timesheet` is Time Card-relevant.
  - Used the email received date, `2026-07-20`, as the work date because the body did not state another date.
  - Created Time Card invoice numbers because the sender did not provide invoice numbers.
  - Applied Josh Kennedy's established `$31.25/hour` rate.
  - Split into one BackOffice draft invoice and one 4121 Tensity draft invoice.
- Parsed total source time as 6 hours 45 minutes.
- Created BackOffice draft invoice `TC-JK-20260724-BACKOFFICE-001` for 4.00 hours at `$31.25/hour`, totaling `$125.00`.
- Created Tensity draft invoice `TC-JK-20260724-TENSITY-001` for 2.75 hours at `$31.25/hour`, totaling `$85.94`.
- Preliminary Invoice Entry project-room duplicate search found no prior Josh Kennedy timesheet packet beyond this source and packet set.
- Generated polished PDF drafts through the Create Vendor Invoice document pattern.
- Updated Time Card rules after Wes clarified:
  - do not copy invoices to Teams until the final email for the end of the week,
  - every Time Card email should amend the invoices and email them to the sender with Wes and Jenny copied.
- Rendered the polished PDF drafts and found the first layout had overlapping text.
- Rebuilt the PDFs with a stacked line-item layout and rerendered them for visual inspection.
- Visual check passed for both corrected rendered invoice pages.
- Combined the two draft invoice PDFs into `26-07-24 - Josh Kennedy - Time Card Invoice Drafts - Week Ending 2026-07-24.pdf`.
- Sent the amended draft invoice packet to Josh Kennedy for accuracy verification from `OfficeAssist@BuyYourHomeLLC.com`, with Wes and Jenny copied.
- Verified the sent copy in OfficeAssist Sent Items. Sent item id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEJAAAAVSXargQY20aF7RLCkro4ggACecWKkQAAAA==`.
- No Teams filing was performed because this was not identified as the final end-of-week Time Card email.
- No workbook was edited.
- Tensity workbook insertion is held pending destination worksheet or approved placement path.
- BackOffice posting is held pending the approved BackOffice accounting or spreadsheet path.

## 2026-07-22

- Received Time Card handoff from Email Monitor for routed source `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-21-213901-josh-kennedy-timesheet-2026-07-21.md`.
- Read the routed source. No attachments were supplied.
- Treated the source as another Time Card email in Josh Kennedy's week ending 2026-07-24 packet.
- Parsed 2026-07-21 Tensity time as 7:50 A.M. to 1:00 P.M. = 5 hours 10 minutes, displayed as 5.17 hours, at `$31.25/hour`, totaling `$161.46`.
- Parsed 2026-07-21 BackOffice time as 1:00 P.M. to 4:45 P.M. = 3.75 hours at `$31.25/hour`, totaling `$117.19`.
- Duplicate check found no existing `2026-07-21` Josh Kennedy Time Card line in the packet before amendment.
- Amended the existing weekly invoice numbers rather than creating new invoice numbers:
  - `TC-JK-20260724-BACKOFFICE-001`: now 7.75 hours, `$242.19`.
  - `TC-JK-20260724-TENSITY-001`: now 7.92 displayed hours, `$247.40`.
- Regenerated the BackOffice and Tensity invoice draft PDFs and rebuilt the combined attachment `26-07-24 - Josh Kennedy - Time Card Invoice Drafts - Week Ending 2026-07-24.pdf`.
- PDF text/package validation passed: combined attachment has 2 pages, July 22 draft date, both existing invoice numbers, the 2026-07-21 line items, and the amended totals.
- Visual render validation could not be completed because `fitz` was not installed, `pdf2image` could not find Poppler, and `pypdfium2` crashed the Python process during rendering. The PDF package and extracted text validated.
- Sent the amended draft invoice packet to Josh Kennedy for accuracy verification from `OfficeAssist@BuyYourHomeLLC.com`, with Wes and Jenny copied.
- Verified the sent copy in OfficeAssist Sent Items. Sent item id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEJAAAAVSXargQY20aF7RLCkro4ggACe13aqAAAAA==`.
- No Teams filing was performed because this was not identified as the final end-of-week Time Card email.
- No workbook was edited.
- Tensity workbook insertion remains held pending destination worksheet or approved placement path.
- BackOffice posting remains held pending the approved BackOffice accounting or spreadsheet path.

## 2026-07-22 - Later Time Card Update

- Received a new Time Card handoff for `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-22-214447-josh-kennedy-time-card-update.md`.
- Preserved `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-22-214452-wes-forward-josh-time-card-update.md` as duplicate transport evidence. It arrived five seconds after Josh's message and was not added as another time-card line.
- Parsed Josh's 2026-07-22 Tensity time as 9 hours 5 minutes: 6:45 A.M.-3:30 P.M. at 4121 Tensity Dr plus 3:30 P.M.-3:50 P.M. picking up project supplies at Lowe's in Cary.
- Applied the established `$31.25/hour` rate. The new rounded line amount is `$283.85`.
- Duplicate check found no existing 2026-07-22 source line in the weekly packet before amendment.
- Kept invoice `TC-JK-20260724-TENSITY-001` and amended it to 17.00 hours and `$531.25`. BackOffice invoice `TC-JK-20260724-BACKOFFICE-001` remains 7.75 hours and `$242.19`.
- Regenerated the two invoice PDFs and combined attachment `26-07-24 - Josh Kennedy - Time Card Invoice Drafts - Week Ending 2026-07-24.pdf`.
- Rendered and visually inspected both combined PDF pages. The existing invoice numbers, July 22 line, totals, layout, and source traceability are legible with no clipping or overlap.
- The Outlook connector is not available in this session. The local Outlook fallback has stores for Josh, Wes, and Jenny but not `OfficeAssist@BuyYourHomeLLC.com`, so Email Delivery sender verification cannot pass. The new amendment was not sent from another mailbox.
- No Teams filing was performed because this was not identified as the final end-of-week Time Card email.
- No workbook was edited. Tensity placement and BackOffice posting remain held under the existing rules.

## 2026-07-23

- Received a new Time Card handoff for `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-23-210720-josh-kennedy-time-card-update.md`.
- Preserved `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\2026-07-23-210725-wes-forward-josh-time-card-update.md` as duplicate transport evidence. It arrived five seconds after Josh's direct message and was not added as another time-card line.
- Parsed Josh's 2026-07-23 Tensity time as 10 hours 5 minutes from 6:50 A.M. to 4:55 P.M. at 4121 Tensity Dr.
- Applied the established `$31.25/hour` rate. The new rounded line amount is `$315.10`.
- Duplicate check found no existing 2026-07-23 source line in the weekly packet before amendment.
- Kept invoice `TC-JK-20260724-TENSITY-001` and amended it to 27.08 displayed hours and `$846.35`. BackOffice invoice `TC-JK-20260724-BACKOFFICE-001` remains 7.75 hours and `$242.19`.
- Regenerated the project and BackOffice PDFs from the accumulated weekly source data rather than editing the prior PDFs.
- Rebuilt the combined attachment `26-07-24 - Josh Kennedy - Time Card Invoice Drafts - Week Ending 2026-07-24.pdf`.
- Package validation passed: two pages, both existing invoice numbers, July 23 draft date, the 2026-07-23 line, and the amended totals are present.
- Rendered and visually inspected both pages. The invoice numbers, line items, totals, source traceability, and layout are legible with no clipping or overlap.
- Sent Email Monitor delivery request `IE-EMAIL-20260723-JOSH-TIMECARD-APPROVAL-001` for OfficeAssist delivery to Josh Kennedy, with Wes and Jenny copied. Sent Items verification is pending.
- Email Monitor returned `Sent and Verified`: OfficeAssist sent the message at `2026-07-24T01:22:41Z` to Josh Kennedy with Wes and Jenny copied. Sent message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEJAAAAVSXargQY20aF7RLCkro4ggACfHr4WAAAAA==`.
- OfficeAssist Sent Items verification confirmed the sender, To and CC recipients, subject, attachment flag, and attached PDF metadata.
- Email Delivery's first connector call failed because the attachment was passed as a string. Its single schema-correct retry used a one-item absolute-path list and succeeded.
- No Teams filing or workbook insertion was performed because this is an in-week draft and end-of-week approval has not occurred.
