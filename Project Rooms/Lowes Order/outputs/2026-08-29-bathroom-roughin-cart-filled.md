# Bathroom Rough-In Lowe's Cart Filled

Source: `sources\2026-08-29-bathroom-roughin-cart-handoff-summary.md`

Status: Completed under dispatch `bathroom-dispatch-20260829-lowes-roughin-cart-v1`.

## Validation

- Durable queue record was read from `\\WES-VIDEOEDITOR\BYH-PRMessaging$\records\bathroom-lowes-20260829-roughin-cart-v1.json`.
- Destination validated as Lowes Order task `019f5845-fb96-7370-baf2-b8f00fddffae`.
- Record payload hash matched the handoff value: `faaeb0bb1a4b737175222d2157c64a847fe20f9ab21a5e20bcf9326992addb15`.
- Durable `Accepted` receipt was written before substantive work.
- Durable state was advanced to `Processing` before cart work.

## Cart Status

- Lowe's session shown in Chrome: MyLowes Jenny
- Store shown: N. Raleigh Lowe's, ZIP 27529
- Cart link: `https://www.lowes.com/cart`
- Existing cart before additions: one Moen `S3102` at quantity `1`.
- Unrelated preexisting cart contents observed: none. The preexisting Moen `S3102` matched the requested package and quantity.
- Final cart status observed: 6 item units.
- Final requested model quantities observed: `S3102` quantity `1`, `R10000-MFWS` quantity `2`, `R11000` quantity `2`, `LS4260VNWR` quantity `1`.
- Fulfillment shown: pickup at N. Raleigh Lowe's; readiness ranged between September 3 and September 15 by item.
- Checkout/payment/account/fulfillment changes: none.

## Items In Cart

| Model | Lowe's item | Quantity | Current price observed | Availability observed |
| --- | --- | ---: | ---: | --- |
| `S3102` | Moen Smart Shower Valve 1/2-in ID Compression x 1/2-in OD Compression Polymer Thermostatic Mixing Valve for Shower, item `855462` | 1 | `$486.79` | Ready by Thu, Sep 3 |
| `R10000-MFWS` | Delta 1/2-in ID OD compression x 1/2-in OD Compression Brass Shower Valve for Tub and Shower, item `714530` | 2 | `$67.07` each; `$134.14` line | Ready by Tue, Sep 8 |
| `R11000` | Delta 1/2-in ID Copper sweat x 1/2-in OD Copper sweat Brass Diverter Valve for Tub and Shower, item `786632` | 2 | `$101.11` each; `$202.22` line | Ready by Tue, Sep 8 |
| `LS4260VNWR` | Endurance Peregrine 41.5-in x 59.75-in White Acrylic Rectangle Drop-in Whirlpool Tub, right drain, item `570864` | 1 | `$1,199.20` | Ready by Tue, Sep 15 |

## Email Delivery

- Sender: `OfficeAssist@BuyYourHomeLLC.com`
- To: Wes `<WesWill@BuyYourHomeLLC.com>`
- CC: Jenny `<Jenny@BuyYourHomeLLC.com>`
- Subject: `[Lowes Order] Bathroom rough-in Lowe's cart ready for review`
- Sent/verified timestamp: 2026-08-29T17:29:16Z
- Verified sent message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEJAAAAVSXargQY20aF7RLCkro4ggAClIAFPQAAAA==`
- Attachments: none
- The message included the Lowe's cart link `https://www.lowes.com/cart`.

## Remaining Decisions

- Wes must review and approve checkout, payment, pickup/delivery changes, quantity changes, substitutions, financing, protection plans, paid services, or final order action.
- The Bathroom Fixtures source task was the originating sender channel; the final return includes the Lowe's cart link for that source task.
