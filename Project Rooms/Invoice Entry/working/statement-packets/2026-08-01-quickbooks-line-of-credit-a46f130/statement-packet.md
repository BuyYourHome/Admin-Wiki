# QuickBooks Line of Credit Statement Packet - Loan a46f130

## Packet Status

- Status: `Needs Review - Statement - Accounting Allocation`
- Workflow: `Statement Packet Handling`
- Statement issuer: Intuit / WebBank
- Account owner: Buy Your Home LLC
- Loan identifier: ending `a46f130`
- Activity period: 2026-07-01 through 2026-07-31
- Statement date: 2026-08-01
- Source type: authoritative OfficeAssist Outlook messages; no attachment supplied
- Project/property: `BackOffice / Office Admin`
- Recommended workbook: `None`
- Recommended worksheet: `Needs Accounting Review`

## Statement Facts

| Field | Amount / value |
| --- | ---: |
| Origination date | 2026-05-07 |
| Original loan amount | `$15,000.00` |
| Loan type | Cash |
| Interest rate | 32.99% |
| APR | 33.14% |
| July principal paid | `$1,108.74` |
| July interest paid | `$378.17` |
| July total payments made | `$1,486.91` |
| Principal balance | `$12,838.19` |
| Year-to-date principal paid | `$2,161.81` |
| Year-to-date interest paid | `$812.01` |
| Year-to-date total payments | `$2,973.82` |
| Next amount due | `$1,486.91` |
| Next due date | 2026-08-08 |

The July principal and interest components reconcile exactly to the stated July total payment: `$1,108.74 + $378.17 = $1,486.91`.

## Source Traceability

Two Wes forwards were received at the same timestamp and contain the same statement. Treat them as duplicate transport of one statement:

- Outlook message ID ending `ACgUD9nAAAAA==`
- Outlook message ID ending `ACgUD9nQAAAA==`
- Received: `2026-08-01T15:32:31Z`
- Subject: `FW: Monthly statement for your QuickBooks Line of Credit loan #a46f130`
- Original sender shown in both forwarded messages: `servicing@intuit.com`
- No attachment was present; the two Outlook messages remain the authoritative statement evidence.

## Duplicate Check

- No prior Invoice Entry record was found for loan suffix `a46f130`, the July 2026 activity period, principal balance `$12,838.19`, or payment amount `$1,486.91`.
- No matching SharePoint Office Admin document was found using the loan suffix, principal balance, or statement description.
- The two simultaneous forwards are duplicate transport and created one packet only.
- Loan suffix `a46f130` is distinct from the separately recorded QuickBooks Line of Credit statement for loan ending `2a46fea`.

## Processing Decision

- Do not treat this statement as one vendor invoice.
- Do not insert the principal balance, next payment, or statement totals into a project workbook.
- Hold the July principal and interest components for accounting review because allocating principal reduction and interest expense is an accounting decision outside Invoice Entry authority.
- Treat the August 8 amount due as informational only. Do not approve, schedule, or make the payment.
- Do not create a replacement statement PDF because the authoritative source is Outlook and no original attachment was supplied.

## Open Decision

Accounting must determine where the `$1,108.74` principal reduction and `$378.17` interest expense are recorded. Invoice Entry has no approved project-workbook or accounting-system destination for this statement.
