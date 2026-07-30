# Create Vendor Invoice Polished Invoice Template

Canonical skill template:

`C:\Codex\Wiki Files\skills\invoice-entry\templates\create-vendor-invoice-polished-invoice-template.md`

Use this template for Create Vendor Invoice free-text vendor invoices. The approved format makes the outside person or vendor the invoice issuer and Buy Your Home the customer.

Required behavior:

- create a polished PDF invoice draft, not a plain Markdown-only table,
- show the outside person or vendor name and email as the top-left issuer identity,
- show `Buy Your Home` as the customer,
- label the document clearly as `INVOICE DRAFT`,
- state `For vendor verification` and `Not approved for payment`,
- show vendor, project, bill-to, line items, subtotal, tax, and draft total,
- include a verification note that the draft is not final until vendor confirmed,
- preserve source email traceability,
- render the PDF to PNG and visually inspect before use,
- send the vendor email when vendor identity, vendor email address, and source evidence are clear; copy Wes and Jenny and sign as `Jean Wright`.
- do not forward or attach the routed free-text source email to the vendor.

Canonical generator:

`C:\Codex\Wiki Files\skills\invoice-entry\scripts\create-outside-person-invoice.py`
