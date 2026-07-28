# Invoice Packet - Atlantic Discount Flooring - 001521

## Packet Status

- Status: `Held - Missing Project`
- Workflow: `Create Vendor Invoice`
- Created: 2026-07-28
- Source type: Routed Square invoice notices and payment confirmation

## Invoice

| Field | Value |
| --- | --- |
| Vendor | Atlantic Discount Flooring LLC |
| Invoice date | 2026-07-28 |
| Invoice number | `001521` |
| Amount | `$363.04` |
| Payment status | Paid 2026-07-28 at 11:45 AM Eastern |
| Payment method | Visa ending `7366` |
| Work category | Flooring |
| Project/property | `Missing - Needs Wes Assignment` |
| Recommended workbook | `Missing - Needs Wes Assignment` |
| Recommended worksheet | `Flooring`, after project assignment and duplicate check |
| Confidence | `Missing Data - Project` |

## Line Items

| Description | Quantity | Rate | Amount |
| --- | ---: | ---: | ---: |
| 22 Mil - Kaneohe Bay | 118.200 sq ft | `$2.59/sq ft` | `$306.14` |
| Kaneohe Bay threshold/reducer | 1 stick | `$35.00` | `$35.00` |
| Credit-card processing fee | 1 |  | `$9.18` |
| Customer appreciation discount |  |  | `-$11.82` |
| Subtotal |  |  | `$338.50` |
| Sales tax |  |  | `$24.54` |
| Total paid |  |  | `$363.04` |

## Source Traceability

- Authoritative invoice PDF:
  `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Source Documents\2026-07-28 Atlantic Discount Flooring 001521\invoice\26-07-28 - Atlantic Discount Flooring - 001521.pdf`
- First invoice notice Outlook message id ending `CfptsdQAAAA==`.
- Duplicate invoice notice Outlook message id ending `CfptsdgAAAA==`.
- Paid confirmation Outlook message id ending `CfptsdwAAAA==`.
- Duplicate paid confirmations Outlook message ids ending `CfptseAAAAA==` and `CfptseQAAAA==`.
- Archived routed-email sources:
  `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Source Documents\2026-07-28 Atlantic Discount Flooring 001521\email`

## Duplicate Check

- The two `You received a new invoice (#001521)` messages are duplicate source evidence for the same invoice and must produce only one invoice record.
- The three paid-confirmation messages are duplicate payment-status evidence for that same invoice, not additional invoices or payments.
- Admin wiki records contain no prior packet or workbook insertion for Atlantic Discount Flooring invoice `001521`.
- SharePoint search did not find invoice `001521` or Kaneohe Bay in a project invoice file or project workbook.
- A project-workbook duplicate check cannot be completed until the owning project is identified.

## Processing Decision

- Downloaded the Square invoice PDF from the preserved link and confirmed its text against the routed email summaries.
- The invoice and PDF identify Buy Your Home as customer but contain no property address, PO, job name, or project identifier.
- Atlantic Discount Flooring's prior Outrigger invoice `001199` is not sufficient evidence that this later invoice belongs to Outrigger.
- Held all property-folder filing and workbook insertion to avoid assigning the invoice to the wrong project.
- After Wes identifies the project, retrieve the current project workbook, check project + vendor + invoice number, file the PDF to the project's approved invoice location, and insert one record into the approved `Flooring` actual-invoice area if no duplicate exists.
