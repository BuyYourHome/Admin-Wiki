# Tensity Stove Sale Receipt Processing Log

- Receipt number: `RCPT-20260814-4121-001`
- Receipt date: `2026-08-14`
- Receiving entity: `Buy Your Home LLC`
- Project: `24-HM - 4121 Tensity Dr`
- Property: `4121 Tensity Dr`
- Item: Stove
- Quantity: `1`
- Amount collected: `$250.00`
- Payment method: Cash
- Collection status: `Cash Received`
- Deposit status: `Not Recorded`
- Application: `Stove Sale Proceeds / Project Credit`
- Received from: `Cash buyer - name not recorded`
- Collected by: `Not recorded`
- Source: Wes's direct instruction in the Invoice Entry task on 2026-08-14.

## Duplicate And Source Review

- The established property receipt destination, `Property/24-HM - 4121 Tensity Dr/Owning/Invoices`, was checked before filing.
- No matching stove-sale receipt or receipt number was present.
- No Marketplace item number or listing reference was supplied. No Marketplace sold-status handoff was created.

## Generated Receipt

- Filename: `26-08-14 - Stove Sale - Receipt RCPT-20260814-4121-001 - 4121 Tensity Dr.pdf`
- SharePoint item id: `01ZGFUBDLF3R6W6IWTV5EJZOHDHIOHN5QV`
- SharePoint path: `Property/24-HM - 4121 Tensity Dr/Owning/Invoices/26-08-14 - Stove Sale - Receipt RCPT-20260814-4121-001 - 4121 Tensity Dr.pdf`
- Local synchronized path: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\24-HM - 4121 Tensity Dr\Owning\Invoices\26-08-14 - Stove Sale - Receipt RCPT-20260814-4121-001 - 4121 Tensity Dr.pdf`
- SHA-256: `2E228EA83B06E7EE3D9614CDBD73A026BD7A2880AF3D6FE407A37761DA44096E`

## Verification And Holds

- The one-page Letter PDF passed text extraction, arithmetic reconciliation, and visual QA.
- The SharePoint upload used conflict-fail protection and was read back successfully.
- The synchronized property-folder copy matched the generated PDF byte-for-byte by SHA-256.
- On Wes's 2026-08-14 instruction to insert receipts into projects, a fresh authoritative `Property/24_Project Management - 4121 Tensity Dr 2.xlsm` was duplicate-checked and one opposite-signed row was inserted into `Appliances / tblAppliancesInvoices`.
- The row records receipt `RCPT-20260814-4121-001` as quantity `1`, cost per unit `-$250.00`, subtotal `-$250.00`, and tax `$0.00`. The Appliances invoice total and grand total both calculate to `-$250.00`.
- Fresh-instance Excel reopen validation found exactly one matching receipt row. Exact-target SharePoint replacement completed at `2026-08-14T18:18:12Z`; the downloaded authoritative read-back matched SHA-256 `F417613E9F53CC395D326B23199C73E2246C07BCD7691FAF4B454083C2B535BD` across `742,700` bytes.
- The pre-edit rollback workbook and validation manifest are retained in `Invoice Entry Working Archive/Generated/2026-08-14-Receipt-Opposite-Sign-Workbook-Posting`.
- No email, payment, deposit, Marketplace update, approval, or paid-status action occurred.
