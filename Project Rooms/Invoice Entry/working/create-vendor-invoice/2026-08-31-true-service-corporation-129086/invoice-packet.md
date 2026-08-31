# True Service Corporation Invoice 129086 Packet

## Status

- State: `Held - Project Confirmed; Mixed-Scope Worksheet Allocation And Later Approval Required`
- Vendor: `True Service Corporation`
- Invoice number: `129086`
- Invoice date: `2026-08-31`
- Source-stated line date: `2026-09-01`
- Due date: `2026-08-31`; source also says payment is due at time of service
- Amount due: `$11,178.50`
- Project/property: `26-BYH - 908 Pond St` (`908 Pond Street` on the invoice)
- Work category: `Multiple - HVAC equipment, ductwork, gas line, and bathroom exhaust venting`
- Confidence/status: `Needs Review - Mixed Scope`
- Approval, property filing, workbook posting, payment, vendor contact, and paid status: not performed

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

- Durable Invoice Entry search found no prior `True Service Corporation`, invoice `129086`, matching Outlook message, payload hash, source PDF hash, or matching project/vendor/invoice identity.
- One obligation was recorded from this dispatch. Repeated routing must reconcile to this packet rather than create another invoice record.
- The project workbook was not opened, so no workbook-level duplicate assertion is made.

## Next Permitted Action

Wes must approve the invoice separately and identify or approve the worksheet allocation for its mixed scope before property filing or workbook posting. Payment and paid status require separate verified authority and evidence.
