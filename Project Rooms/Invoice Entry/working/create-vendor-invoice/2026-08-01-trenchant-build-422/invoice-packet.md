# Invoice Packet - Trenchant Build L.L.C. - Invoice 422

## Packet Status

- Status: `Paid - Needs Review Vendor Tab`
- Workflow: `Create Vendor Invoice`, attached vendor invoice and later paid-receipt evidence
- Project: `24-HM - 4121 Tensity Dr`
- Live workbook: `Property/24_Project Management - 4121 Tensity Dr 2.xlsm`
- Review Row ID: `IE-20260801-TRENCHANT-422`

## Invoice

- Vendor: `Trenchant Build L.L.C.`
- Invoice number: `422`
- Invoice date: `2026-07-31`
- Due date: `2026-07-31`
- Property stated on invoice: `4121 Tensity Dr, Raleigh, NC`
- Work subtotal: `$5,030.14`
- Card-processing fee: `$155.57`
- Invoice total: `$5,185.71`

The amount conflict is resolved by the invoice itself. Work Order 267-1 is `$3,950.00`; approved Change Order 267-2 is `$858.53`; approved Change Order 267-6 is `$221.61`. Those three documents total `$5,030.14`. Invoice 422 adds the separate `$155.57` card-processing line and states the final balance as `$5,185.71`.

## Payment Evidence

- Payment status: `Paid`
- Payment date: `2026-08-01`
- Amount paid: `$5,185.71`
- Payment method: Visa ending `7867`
- Authorization ID: `17ad52juu606`
- Additional transfer fees or taxes: none shown

Two Wes forwards preserve the same QuickBooks payment confirmation. Treat them as duplicate transport of one paid receipt, not two payments:

- OfficeAssist Outlook message ending `ACgUD9mgAAAA==`
- OfficeAssist Outlook message ending `ACgUD9mwAAAA==`, with Wes's 4121 Tensity project instruction

## Source Traceability

- Invoice email: OfficeAssist Outlook message ending `ACgUD9mQAAAA==`
- Attached invoice: `Invoice_422_from_Trenchant_Build_LLC.pdf`
- Supporting work order: `Work Order 267-1.pdf`
- Supporting change orders: `Change Order 267-2.pdf` and `Change Order 267-6.pdf`
- The Outlook message and its retrievable attachments remain the authoritative source set.

## Duplicate Check

- Strong key checked: project + vendor + invoice number.
- No Trenchant or invoice 422 record was found in the current Tensity workbook before insertion.
- No matching Trenchant file was found by the scoped SharePoint search.
- The `$5,030.14` and `$5,185.71` figures are two layers of the same invoice, not separate invoices.
- The two paid-receipt forwards are duplicate transport and updated the existing Review row instead of creating another row.

## Workbook Decision

- Added one row to `Review!tblInvoiceReview` for invoice 422 at `$5,185.71`.
- Status remains `Needs Review - Vendor Tab` because the invoice combines interior repairs, painting/touch-ups, and a card-processing fee.
- No destination worksheet was guessed and no vendor-table row was inserted.
- The Review note records the August 1 payment and the remaining destination/split decision.
- The updated workbook was saved through Excel, reopened cleanly, uploaded to the same SharePoint workbook, pulled back, and reopened again.
- Validation passed: Review row present, amount and paid evidence correct, `invoiceEntryReviewRequest` still refers to `=Review!$B$1`, zero workbook links, and zero changes to non-Review worksheet formulas or values.

## Open Decision

Wes must choose one approved destination worksheet or approve a supported split for the mixed scope and card-processing fee. Paid status does not resolve the spreadsheet category.
