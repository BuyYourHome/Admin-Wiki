# Josh Kennedy Biweekly Service Payment Packet

## Status

- Payment invoice: `Denied by Wes - Retired - Do Not Pay`
- Allocation reports: `Internal - Not Payable`
- Email Delivery: `Sent and Verified` to Wes only
- Teams filing, workbook changes, and payment: not performed

## Payment Invoice

| Field | Value |
| --- | --- |
| Invoice number | `SP-JK-20260731-001` |
| Issuer | Josh Kennedy |
| Customer | Buy Your Home |
| Invoice date | 2026-07-31 |
| Service period | 2026-07-20 through 2026-07-31 |
| Basis | Two weeks at `$1,250.00` per week |
| Invoice total | `$2,500.00` |
| Payment status | Not paid |

This draft was denied by Wes on 2026-08-01 and retired after the Time Card payment design changed. It is retained only as historical evidence. Do not approve, file, post, pay, or use invoice `SP-JK-20260731-001` as the basis for a future payment.

## Project Cost Allocation Reports

The prior week-ending 2026-07-24 project and BackOffice invoice documents were recast as non-payable internal allocation reports.

| Report number | Destination | Hours | Allocated cost |
| --- | --- | ---: | ---: |
| `PCA-JK-20260724-BACKOFFICE-001` | BackOffice | 7.75 | `$214.48` |
| `PCA-JK-20260724-TENSITY-001` | `24-HM - 4121 Tensity Dr` | 37.42 displayed / 37:25 source time | `$1,035.52` |
|  | **Total** | **45:10 source time** | **$1,250.00** |

Allocation method:

`destination allocation = $1,250.00 x destination hours / total accepted weekly hours`

The reports replace `TC-JK-20260724-BACKOFFICE-001` and `TC-JK-20260724-TENSITY-001` as the intended internal allocation records. They do not authorize or request payment.

## Duplicate Check

- No prior Invoice Entry packet or generated document used invoice number `SP-JK-20260731-001`.
- The two allocation report numbers are new.
- The allocation reports preserve the prior Time Card source lines; they do not create new time entries.
- The report totals reconcile exactly to the fixed `$1,250.00` weekly service cost.

## Delivery

- Request: `IE-EMAIL-20260730-JOSH-BIWEEKLY-AND-ALLOCATIONS-WES-001`
- Sent: `2026-07-30T14:30:38Z`
- From: `OfficeAssist@BuyYourHomeLLC.com`
- To: `WesWill@BuyYourHomeLLC.com` only
- CC/BCC: none
- Sent message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEJAAAAVSXargQY20aF7RLCkro4ggACgMgFNAAAAA==`
- Verification: exact sender, recipients, subject, body, and all three non-inline PDF attachments passed OfficeAssist Sent Items verification.

## Recurrence

The recurrence information below is historical. The separate biweekly-invoice design has been retired and does not authorize another payable invoice:

- Automation: `josh-biweekly-service-payment-invoice`
- Schedule: every other Friday at 4:00 PM Eastern
- First scheduled check: 2026-07-31
- Duplicate control: the first check must detect the already-created `SP-JK-20260731-001` and take no duplicate action. The next payable cycle is 2026-08-14.

## Outstanding Decisions

- No approval decision remains for `SP-JK-20260731-001`; Wes denied it on 2026-08-01.
- Do not file, post, pay, or revive this invoice.
- Existing Teams PDFs and the Tensity Review row still reflect the former invoice presentation and amount. Reconcile them only after Wes approves the allocation-report replacement and authorizes workbook processing.
