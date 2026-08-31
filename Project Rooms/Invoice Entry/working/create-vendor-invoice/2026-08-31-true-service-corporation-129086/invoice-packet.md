# True Service Corporation Invoice 129086 Packet

## Status

- State: `Partial Payment Evidence Recorded - $178.50 Remaining; Approval And Mixed-Scope Worksheet Allocation Still Held`
- Vendor: `True Service Corporation`
- Invoice number: `129086`
- Invoice date: `2026-08-31`
- Source-stated line date: `2026-09-01`
- Due date: `2026-08-31`; source also says payment is due at time of service
- Amount due: `$11,178.50`
- Project/property: `26-BYH - 908 Pond St` (`908 Pond Street` on the invoice)
- Work category: `Multiple - HVAC equipment, ductwork, gas line, and bathroom exhaust venting`
- Confidence/status: `Needs Review - Mixed Scope`
- Payment evidence: `$11,000.00` credit-card payment dated `2026-08-31` applied to invoice `129086`; the current invoice arithmetic leaves `$178.50` unpaid
- Approval, property filing, workbook posting, vendor contact, and full-paid status: not performed

## Source Traceability

- Message/dispatch id: `prmsg-email-monitor-route-vendor-invoice-20260831-true-service-129086-001`
- Payload hash: `16d75e51d8138f6a0f746f8b911c5688e10818b3fb4a93e1f91907986211f4f4`
- Outlook message id ending: `AClUGMFwAAAA==`
- Mailbox: `OfficeAssist@BuyYourHomeLLC.com`; folder: `Inbox`
- Sender: `WesWill@BuyYourHomeLLC.com`; received `2026-08-31T19:48:15Z`
- Subject: `FW: Invoice from True Service Corporation - For Services Rendered`
- Retained source PDF: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Source Documents\2026-08-31 True Service Corporation 129086\invoice\invoice_129086.pdf`
- Retained source size: `89,326` bytes
- Retained source SHA-256: `B2A336A95B27F5DFB549121BA89948C64EDEFE168DE475879A21D5A5B9380719`
- Vendor contact shown on invoice: `Info@trueserviceinc.com`; phone `9197941804`

## Payment Receipt Reconciliation

- Payment message/dispatch id: `prmsg-email-monitor-route-vendor-invoice-20260831-true-service-129086-payment-receipt-001`
- Payment payload hash: `147034e9ec07ac7ea8fc3f17295d37bc62876b9095d673fe4edb30ab3b71bbc4`
- Payment Outlook message id ending: `AClUGMGAAAAA==`
- Payment source: Wes forward received `2026-08-31T20:38:22Z`, subject `FW: Receipt for payment from True Service Corporation - Aug 31, 2026`
- Retained receipt PDF: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Source Documents\2026-08-31 True Service Corporation 129086\receipt\receipt.pdf`
- Retained receipt size: `65,257` bytes
- Retained receipt SHA-256: `C2EEF4257AF137523D0C30A0847B0104A6FCF2D9C722A5BF0AED88D1291DCBD4`
- Receipt-supported facts: True Service Corporation received `$11,000.00` by credit card on `2026-08-31`, applied to invoice `129086` for Buy Your Home LLC.
- Provider transaction reference preserved from the authoritative durable record: `ch_3UAbwNKXLQIAg16L0mZxSwJN`.
- Reconciliation: `$11,178.50` invoice amount due less `$11,000.00` verified payment equals `$178.50` remaining.
- This is partial-payment evidence only. It does not approve the invoice, establish full payment, resolve the mixed-scope worksheet allocation, authorize filing or posting, or support a `Paid` status.

## Source-Supported Scope And Math

| Product/service | Source description summary | Quantity | Unit price | Line total |
| --- | --- | ---: | ---: | ---: |
| Tempstar 3 ton split AC with gas furnace | New 3-ton, 15-SEER split AC with 92% gas furnace; equipment, accessories, models, warranties, and permitting described | 1 | `$12,540.00` | `$12,540.00` |
| Duct Work | New ductwork throughout according to load calculation; ceiling ducts and wall returns | 1 | `$8,250.00` | `$8,250.00` |
| Gas Line | Gas line for stove with shutoff | 1 | `$822.00` | `$822.00` |
| Bathroom exhaust fan | Owner/electrician supplies and mounts fans; True Service supplies and installs venting | 1 | `$745.00` | `$745.00` |

- Line subtotal: `$22,357.00`.
- Source discount: `50.0%`, shown as `-$11,178.50`.
- Source total and amount due: `$11,178.50`.
- Arithmetic check passed: the four line totals equal `$22,357.00`, and the 50% discount leaves `$11,178.50`.
- The first line says `50% required upon delivery of equipment`; preserve the document as one invoice obligation and do not infer payment, delivery, completion, or paid status.

## Routing Recommendation

- Proposed workbook lookup: `Property/26_Project Management - 908 Pond St 3.xlsm` from the current project-spreadsheet register.
- Fresh SharePoint workbook verification: not performed because this intake did not authorize workbook action.
- Recommended worksheet: `Needs Review - Mixed Scope`.
- Reason: the invoice is clearly for 908 Pond, but its four source lines span HVAC equipment, ductwork, gas-line work, and bathroom exhaust venting. No split among approved workbook destinations is authorized by this handoff.
- Saved invoice file path: the retained source archive path above. It is not property-filed evidence.

## Duplicate Control

- Durable Invoice Entry search found no prior `True Service Corporation`, invoice `129086`, matching invoice Outlook message, invoice payload hash, source invoice PDF hash, or matching project/vendor/invoice identity.
- One obligation was recorded from this dispatch. Repeated routing must reconcile to this packet rather than create another invoice record.
- The payment-receipt search found no prior Invoice Entry record matching its message/dispatch id, payload hash, transaction reference, or retained receipt PDF hash. It was reconciled once as supplemental payment evidence against the existing obligation, not as a new invoice or a second payment.
- The project workbook was not opened, so no workbook-level duplicate assertion is made.

## Next Permitted Action

Wes must approve the invoice separately and identify or approve the worksheet allocation for its mixed scope before property filing or workbook posting. The verified receipt supports a partial-payment status only; `$178.50` remains under the current invoice arithmetic, so do not mark the invoice fully paid without additional verified evidence.
