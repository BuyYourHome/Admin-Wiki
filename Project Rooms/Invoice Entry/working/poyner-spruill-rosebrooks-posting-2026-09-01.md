# Poyner Spruill Rosebrooks Posting - 2026-09-01

## Authorization

Wes directed Invoice Entry to treat all Poyner Spruill bills as project expenses for 115 Rosebrooks, use category `Legal Expenses`, and route the current invoice as a vendor bill.

## Workbook Result

- Live workbook: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\20_Project Management - 115 Rosebrooks Dr.xlsm`
- Target: `Review!tblInvoiceReview`
- Rows inserted: 20 validated payable invoices
- Aggregate: `$202,038.81`
- Stable row IDs: `IE-POYNER-<invoice number>`
- Category and recommendation: `Legal Expenses`
- Destination worksheet: blank
- Status: `Needs Review`

The workbook has no approved `Legal Expenses` vendor worksheet. Invoice Entry therefore retained the rows in Review and did not invent or create a destination tab owned by Template to Project.

## Duplicate And Integrity Controls

- Source workbook SHA-256: `D2090DBCB53976461D306A2988383FE09C133B968308EB3E3AF0FEB30BB93EA0`
- Updated/live workbook SHA-256: `100110FC452BE830C5B2F74C1B1235E4DAECADFE70DA3C78001320E14C3F1FC1`
- Workbook duplicate search found no prior Poyner invoice numbers or stable row IDs.
- Excel saved and reopened the working copy before replacement.
- Live read-back found 20 Poyner rows totaling `$202,038.81`, zero external workbook links, Automatic calculation, 25 worksheets, 22 tables, and zero formula errors.
- A rendered Review preview was visually checked after save.
- Before and after workbook copies were retained outside Git at `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Workbook Copies\2026-09-01 Poyner Spruill Rosebrooks Posting`; their hashes match the source and verified live versions above. Temporary project-room workbook copies and inspection artifacts were then removed.

## Filing And QuickBooks

- Invoice `1277608` was filed as `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\20-HM-115 Rosebrooks Dr\Lawsuit\Billing\26-08-11 Poyner Spruill - invoice 1277608 3671.80.pdf`.
- Filed PDF SHA-256: `2E61120798D9E667F6A60A6D3730068CACC473DC12B4C87E67C1C82F0A0C28E3`.
- QuickBooks child: `prmsg-invoice-entry-quickbooks-poyner-1277608-20260901-001`.
- Corrected QuickBooks child: `prmsg-invoice-entry-quickbooks-poyner-1277608-resume-corrected-20260902-001`; the earlier authentication blocker is superseded by authoritative return `prmsg-quickbooks-invoice-entry-poyner-1277608-completed-return-20260902-001`.
- QuickBooks result: live duplicate search Not Found; exactly one bill saved in Buy Your Home LLC as transaction `13399`, total/balance `$3,671.80`, status `Unpaid`. Returned lines are `$3,584.00` attorney fees and `$87.80` expenses under `SchC-Professional Fees:Legal fees`, class `BYH:115:Atorneys fees`, customer blank.
- Do not recreate the bill, initiate payment, mark paid, or infer invoice approval from QuickBooks entry.
- Child payload hash: `af45347f5a35f85fdfbb8739e977a8c19346ea25747e60ba53e325f030b34b60`.
- Destination task is now registered to the `Quickbooks` Project Room as `01a05967-9a05-7081-a62e-616b2d8e61fd` on `WES-VIDEOEDITOR`.
- The child requires a live duplicate search, one save only if absent, full read-back, and a block if the exact project or any additional required mapping cannot be verified.
- The 19 historical invoices were not sent for creation. Their completed audit remains authoritative: 13 exact matches and six ambiguous candidates.

No approval, payment, vendor contact, paid status, or historical QuickBooks correction occurred.
