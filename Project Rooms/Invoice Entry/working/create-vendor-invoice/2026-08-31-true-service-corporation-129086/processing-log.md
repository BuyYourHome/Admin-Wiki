# True Service Corporation Invoice 129086 Processing Log

## 2026-08-31 - Routed Attached-Invoice Intake

- Validated the exact Invoice Entry destination and payload hash `16d75e51d8138f6a0f746f8b911c5688e10818b3fb4a93e1f91907986211f4f4` in authoritative message/dispatch `prmsg-email-monitor-route-vendor-invoice-20260831-true-service-129086-001`.
- Wrote the durable Accepted receipt before substantive work and then recorded Processing.
- Verified the retained attachment exists at the source archive path, is a two-page PDF, has `89,326` bytes, and matches SHA-256 `B2A336A95B27F5DFB549121BA89948C64EDEFE168DE475879A21D5A5B9380719`.
- Inspected both rendered pages and extracted text. The invoice identifies True Service Corporation, Buy Your Home LLC, `908 Pond Street`, invoice `129086`, issued and due `2026-08-31`, and amount due `$11,178.50`.
- Verified source arithmetic: four lines total `$22,357.00`; the printed 50% discount is `$11,178.50`; the resulting total is `$11,178.50`.
- Preserved the source-stated `2026-09-01` line date, equipment-delivery deposit wording, same-day due date, service-charge language, and mixed HVAC/ductwork/gas-line/bathroom-vent scope without inferring completion or payment.
- Durable duplicate search found no prior matching vendor, invoice number, Outlook source, payload hash, source PDF hash, or project/vendor/invoice identity. The project workbook was not opened.
- Recorded the exact project as `26-BYH - 908 Pond St` and retained the proposed workbook lookup `Property/26_Project Management - 908 Pond St 3.xlsm`, but held worksheet allocation as `Needs Review - Mixed Scope`.
- No approval, payment, vendor contact, property filing, workbook posting, paid status, or other external action occurred.

Outcome: `Needs Wes - approve separately and identify or approve the mixed-scope worksheet allocation before filing or posting`.

## 2026-08-31 - Payment Receipt Reconciliation

- Validated the exact Invoice Entry destination and payload hash `147034e9ec07ac7ea8fc3f17295d37bc62876b9095d673fe4edb30ab3b71bbc4` in authoritative message/dispatch `prmsg-email-monitor-route-vendor-invoice-20260831-true-service-129086-payment-receipt-001`.
- Wrote the durable Accepted receipt before substantive work and then recorded Processing.
- Verified the retained receipt exists at `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Source Documents\2026-08-31 True Service Corporation 129086\receipt\receipt.pdf`, is a one-page PDF, has `65,257` bytes, and matches SHA-256 `C2EEF4257AF137523D0C30A0847B0104A6FCF2D9C722A5BF0AED88D1291DCBD4`.
- Inspected the complete rendered page and extracted text. The receipt identifies True Service Corporation, Buy Your Home LLC, a `$11,000.00` credit-card payment dated `2026-08-31`, and application to invoice `129086`.
- Preserved transaction reference `ch_3UAbwNKXLQIAg16L0mZxSwJN` from the authoritative durable record; it is not printed on the retained PDF.
- Reconciled the receipt once against the existing `$11,178.50` obligation. Current arithmetic leaves `$178.50` unpaid.
- Durable duplicate search found no prior Invoice Entry record matching the payment message/dispatch id, payload hash, transaction reference, or receipt PDF hash. The receipt is supplemental evidence for the existing invoice, not a new obligation or a second payment.
- Updated the invoice to partial-payment evidence recorded while preserving the separate Wes approval hold and mixed-scope worksheet-allocation hold.
- No payment was initiated. No approval, full-paid status, vendor contact, property filing, workbook posting, or other external action occurred.

Outcome: `Needs Wes - $11,000.00 partial-payment evidence recorded; $178.50 remains; approval and mixed-scope allocation still required`.
