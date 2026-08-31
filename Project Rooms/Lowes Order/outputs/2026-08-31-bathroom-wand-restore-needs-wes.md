# Bathroom Fixtures Wand Restore Correction - Needs Wes - 2026-08-31

## Result

Status: Needs Wes.

Lowes Order processed durable message `bathroom-lowes-20260831-restore-deleted-wand-component-v1` under dispatch id `bathroom-dispatch-20260831-restore-deleted-wand-component-v1`.

The live Lowe's cart did not have a unique missing selected line. The payload authorized adding back only one uniquely identifiable deleted selected line. Because multiple baseline-selected lines were missing, Lowes Order made no cart additions.

Cart link:

`https://www.lowes.com/cart`

## Live Cart Status

| Field | Visible value |
| --- | --- |
| Visible session | `MyLowes Jenny` |
| Store | Morrisville Lowe's |
| ZIP | `27511` |
| Cart total units | `13` |
| Cart section | Scheduled Delivery `(5 Items)` |
| Header arrival | Arrives on Tue, Sep 15 |
| Item subtotal | `$1,809.41` |
| Delivery | `$49.00` |
| 5% Lowe's Cardholder Discount | `-$59.96` |
| Estimated tax | Calculated in checkout |
| Estimated total | `$1,798.45` |

The unrelated existing plywood line remained present:

| Item | Quantity | Line price |
| --- | ---: | ---: |
| Plytanium item #12244 / model #157946 plywood sheathing | 8 | `$273.68` |

## Baseline Selected Lines Present

| Model | Baseline quantity | Live quantity |
| --- | ---: | ---: |
| Endurance Peregrine LS4260VNWR | 1 | 1 |
| Delta Ashlyn T11864-SS | 1 | 1 |
| Delta U4993-SS | 2 | 2 |
| Delta RP61058SS | 1 | 1 |

## Baseline Selected Lines Missing

| Model | Baseline quantity | Role if provided |
| --- | ---: | --- |
| Delta R10000-MFWS | 2 | n/a |
| Delta R11000 | 2 | n/a |
| Delta Ashlyn T14064-SS | 2 | n/a |
| Delta Ashlyn T11964-SS | 1 | n/a |
| Delta RP62149SS | 1 | n/a |
| Delta 51584-PR | 1 | Selected slide-bar hand shower/wand assembly |
| Delta RP101842SS | 2 | n/a |
| Delta RP50841SS | 1 | n/a |
| Delta 50570-SS-PR | 1 | Selected hand-shower wall elbow |

## Decision Needed

Wes needs to identify which item should be restored, or authorize restoring the full missing baseline set. The wand-related candidates in the baseline are `Delta 51584-PR` and `Delta 50570-SS-PR`, but both are missing along with seven other selected lines, so Lowes Order could not uniquely identify a single deleted line.

## Boundary Check

No checkout, payment, substitutions, paid services, protection plans, financing, fulfillment scheduling, saved account/address/payment changes, or cart additions were made.
