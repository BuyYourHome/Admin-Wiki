# Josh Kennedy Lowe's Order Cart Filled

Source: `sources\2026-07-27-josh-kennedy-lowes-order-summary.md`

Status: Reprocessed after Wes updated the Lowes Order rule to assume quantity `1` when a confirmed item has no stated quantity.

## Cart Status

- Lowe's session shown in Chrome: Jenny
- Store shown: Cary Lowe's, ZIP 27529
- Cart status after reprocessing: 4 items
- Quantity assumption: quantity `1` was used for each item because the source email did not state quantities.
- Checkout/payment/account changes: none
- Pickup/delivery changes: none

## Items Added

| Item number | Lowe's matched item | Model | Quantity | Cart availability observed |
| --- | --- | --- | --- | --- |
| `4847122` | Broan QuicKit 60 CFM Replacement Bath Fan Motor | `BKR60` | `1` | Ready today for pickup at Cary Lowe's |
| `7480956` | Utilitech 60-Watt EQ A15 Daylight E26 Dimmable LED General Purpose Light Bulb 6-Pack | `L10A15DU6W50K6PK` | `1` | Ready today for pickup at Cary Lowe's |
| `259930` | Filtrete 20 x 20 x 1 MERV 1 Basic Flat Air Filter 2-Pack | `FPL02-2PK-24` | `1` | Ready today for pickup at Cary Lowe's |
| `102634` | Kwikset Tylo Satin Chrome Exterior Double-Cylinder Deadbolt and Keyed Entry Door Knob Combo Pack | `695T 26D CP CODE K6` | `1` | Ready today for pickup at Cary Lowe's |

## Email Delivery

Confirmation to Josh:

- Sender: `OfficeAssist@BuyYourHomeLLC.com`
- To: Josh Kennedy `<IRAManager@SellYourHomeRaleigh.com>`
- Subject: `[Lowes Order] Lowe's cart filled for review`
- Sent/verified timestamp: 2026-07-30T19:44:02Z
- Verified sent message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEJAAAAVSXargQY20aF7RLCkro4ggACgMgFOQAAAA==`
- Attachments: none

Approval notification to Wes:

- Sender: `OfficeAssist@BuyYourHomeLLC.com`
- To: Wes `<WesWill@BuyYourHomeLLC.com>`
- Subject: `[Lowes Order] Lowe's cart ready for review and approval`
- Sent/verified timestamp: 2026-07-30T19:44:12Z
- Verified sent message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEJAAAAVSXargQY20aF7RLCkro4ggACgMgFOgAAAA==`
- Attachments: none

## Remaining Decisions

- Wes must review and approve any checkout, payment, pickup/delivery change, quantity change, substitution, or final order action.
- The source email subject was `Lowe's order`, not `Lowes Order`, so the confirmation told Josh to identify Lowes Order mode in future source-email subjects.
