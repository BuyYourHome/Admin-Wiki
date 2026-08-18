# Josh Kennedy LLC Semimonthly Time Card Invoice Packet - August 16-31, 2026

## Status

- State: `Period Open - Partial August 17 Intake - Allocation Clarification Required - No Draft Generated`
- Stable invoice number: `INV-JKLLC-20260831-001`
- Semimonthly period: `2026-08-16 through 2026-08-31`
- Issuer: `Josh Kennedy LLC`
- Invoice contact: `profcyber0077@gmail.com`
- Customer: `Buy Your Home`
- Fixed semimonthly amount when a complete allocatable draft can be produced: `$2,708.33`
- Draft PDF: not generated because one reported interval lacks a clear project allocation
- Filing, workbook posting, approval, payment, and paid status: not performed

## Routed Source

- Dispatch id: `email-monitor-route-vendor-invoice-20260818-josh-time-card-aug17-001`.
- Payload hash: `f79c80150516df5dc286ea9f67f60d230f9270148e93bb5bcc129fd1600e98a3`.
- Outlook message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACi7Vd2AAAAA==`.
- Sender: `IRAManager@SellYourHomeRaleigh.com`; received `2026-08-18T12:06:41Z`; subject `Time card`; attachments: none.
- Exact-source facts: Monday, August 17; `8:00 AM` to `3:45 PM` at source-stated `908 Pond Dr`; `3:45 PM` to `5:10 PM`; work with Tim Fleming framing; and work at `115 Rosebrooks Dr` taking down wallpaper and waiting for estate-sale customers.
- Source conflict: the email does not clearly tie the `3:45 PM` to `5:10 PM` interval to either Pond or Rosebrooks. No project was inferred for that interval.

## Accepted Line

| Work date | Destination | Start | End | Accepted time | Description | Source/status |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-08-17 | 908 Pond St | 8:00 AM | 3:45 PM | 7 hours 45 minutes | Work at source-stated 908 Pond Dr; framing with Tim Fleming is preserved as source context | Added once; source expressly places this interval at Pond. No break was stated or deducted. |

## Held Line

| Work date | Destination | Start | End | Held time | Description | Hold reason |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-08-17 | Unallocated - Pond or Rosebrooks | 3:45 PM | 5:10 PM | 1 hour 25 minutes | Tim Fleming framing; Rosebrooks wallpaper removal and waiting for estate-sale customers | The source mentions both project contexts without assigning this exact interval to one property. |

## Duplicate And Period Control

- No prior August 16-31 Josh packet, matching dispatch id, matching Outlook message id, or August 17 time line existed in Invoice Entry durable records.
- The 7-hour-45-minute Pond line is accepted once. The 1-hour-25-minute interval is retained once as held and must be updated in place after clarification.
- This packet is separate from closed-period invoice `INV-JKLLC-20260815-001`; it must not alter or duplicate the August 1-15 invoice.
- Do not generate or deliver the August 16-31 draft until the held interval has an authoritative project allocation. Do not infer a split.

## Decision Needed

Clarify whether the `3:45 PM` to `5:10 PM` interval belongs to `908 Pond St`, `115 Rosebrooks Dr`, or an explicitly supported split. The August 16-31 period remains open.
