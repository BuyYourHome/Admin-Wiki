# QuickBooks Line of Credit Statement Packet - Loan 2a46fea

## Packet Status

- Status: `Needs Review - Statement - Accounting Allocation`
- Workflow: `Statement Packet Handling`
- Statement issuer: Intuit / WebBank
- Account owner: Buy Your Home LLC
- Loan identifier: ending `2a46fea`
- Activity period: 2026-07-01 through 2026-07-31
- Statement date: 2026-08-01
- Source type: authoritative OfficeAssist Outlook message; no attachment supplied.
- Project/property: `BackOffice / Office Admin`
- Recommended workbook: `None`
- Recommended worksheet: `Needs Accounting Review`

## Statement Facts

| Field | Amount / value |
| --- | ---: |
| Origination date | 2025-08-25 |
| Original loan amount | `$25,000.00` |
| Loan type | Cash |
| Interest rate | 32.99% |
| APR | 33.01% |
| July principal paid | `$2,363.82` |
| July interest paid | `$112.80` |
| July total payments made | `$2,476.62` |
| Principal balance | `$2,436.20` |
| Year-to-date principal paid | `$15,154.88` |
| Year-to-date interest paid | `$2,181.46` |
| Year-to-date total payments | `$17,336.34` |
| Next amount due | `$2,476.62` |
| Next due date | 2026-08-26 |

The July principal and interest components reconcile to the stated July total payment: `$2,363.82 + $112.80 = $2,476.62`.

## Source Traceability

- Outlook message ID: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACgUD9mAAAAA==`
- Received: `2026-08-01T13:15:06Z`
- Subject: `FW: Monthly statement for your QuickBooks Line of Credit loan #2a46fea`
- Outlook link: `https://outlook.office365.com/owa/?ItemID=AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACgUD9mAAAAA%3D%3D&exvsurl=1&viewmodel=ReadMessageItem`
- Original sender shown in the forwarded message: `servicing@intuit.com`.
- No attachment was present; the Outlook message remains the authoritative statement source.

## Duplicate Check

- No prior Invoice Entry record was found for loan suffix `2a46fea`, the July 2026 activity period, or the exact `$2,476.62` payment total.
- No matching document was found under the SharePoint `Office Admin` folder using the loan suffix, statement name, or exact payment amount.

## Processing Decision

- Do not treat the statement as one vendor invoice.
- Do not insert the principal balance, next payment, or total statement amount into a project workbook.
- Hold the July principal and interest components for accounting review because allocating principal reduction and interest expense is an accounting decision outside Invoice Entry authority.
- Do not approve, schedule, or make the August 26 payment.
- Do not create a replacement statement PDF because the authoritative source is the Outlook message and no original attachment was supplied.

## 2026-09-01 August Notice

- Message/dispatch `prmsg-email-monitor-route-vendor-invoice-20260901-quickbooks-loc-2a46fea-statement-001`; payload hash `f82972a13887ffee2c231ff9ba6dc04a61e25cd236049988c81710e83143539c`.
- Outlook messages ending `AClUGMHQAAAA==` and `AClUGMHAAAAA==` are duplicate copies of one August 1-31 source group.
- No statement PDF is attached. The exact period, 32.99% interest rate, 33.01% APR, and 2026-09-26 due date are preserved. Monetary fields in the routed summary are incomplete because leading dollar digits are absent, so no amount was inferred.
- Status: `Held - Statement Not Retrieved / Exact Amounts Unavailable`.
