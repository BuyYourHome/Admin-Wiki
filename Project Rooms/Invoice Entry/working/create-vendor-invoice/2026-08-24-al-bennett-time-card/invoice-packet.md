# Al Bennett Time Card Packet - August 24, 2026

## Status

- State: `Needs Wes - Worker/Payee Identity, Rate, And Contact`
- Reported worker/body signer: `Al Bennett, Manager`
- Source mailbox identity: `IRAManager@SellYourHomeRaleigh.com`, display name `Josh Kennedy`
- Work date: `2026-08-24`
- Reported time: `10.25 hours`
- Rate: not provided or established
- Amount: not calculated
- Invoice number: not assigned
- Approval, payment, and paid status: not established

## Exact Source

- PR message: `prmsg-email-monitor-route-vendor-invoice-20260825-al-bennett-time-card-001`.
- Dispatch: `email-monitor-route-vendor-invoice-20260825-al-bennett-time-card-001`.
- Payload hash: `8d33592a4a048ee0023519208515dd89d7b568257fa448accac365e7377dfc9f`.
- Outlook message ending: `ACkJJCUgAAAA==`.
- Received: `2026-08-25T16:35:50Z`.
- Subject: `Time card`.
- Attachment: none.

## Reported Lines

| Work date | Source project wording | Normalized project record | Description | Start | End | Hours |
| --- | --- | --- | --- | --- | --- | ---: |
| 2026-08-24 | 115 Rosebrooks Dr | 20-HM - 115 Rosebrooks Dr | Removed cabinet hardware and prepared for countertop removal | 6:00 AM | 9:00 AM | 3.00 |
| 2026-08-24 | 908 Pond Dr | 26-BYH - 908 Pond St | Worked on spiral staircase with Tim Fleming and trimmed bushes | 9:00 AM | 12:00 PM | 3.00 |
| 2026-08-24 | back office | BackOffice | Back-office work; no further description supplied | 12:00 PM | 4:15 PM | 4.25 |
| **Total** |  |  |  |  |  | **10.25** |

No break was stated or deducted. The normalized project names preserve the source wording while matching established Invoice Entry project identities.

## Duplicate Control

- No prior Invoice Entry record matched this PR message, dispatch, Outlook source, worker name, or August 24 line set.
- The Pond line overlaps Tim Fleming's work date and mentions working with Tim, but it is Al's separately reported labor and is not a duplicate of Tim's three-hour line.
- The source was not merged into Josh Kennedy's semimonthly invoice because the body identifies Al Bennett as the worker.
- Repeated routing must update this packet rather than create another time or invoice record.

## Decisions Required

Before Invoice Entry can calculate an amount, assign an invoice number, or create a correction-review draft, Wes must confirm:

1. Whether Al Bennett is the worker and invoice issuer/payee, or whether his labor is billed through Josh Kennedy or another contractor.
2. The authorized rate or other compensation basis.
3. The payee's delivery contact email.

BackOffice allocation is retained separately and does not establish a project-workbook destination. No PDF, email, filing, workbook action, approval, payment, or paid status was created.
