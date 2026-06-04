# Invoice and Receipt Processing Notes

Invoice and receipt scanning instructions will extend the office document processing workflow.

## Destination Folder

Invoices and receipts should be saved here unless a later instruction gives a more specific destination:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Invoices & Receipts`

## General Invoice Routing

Invoices that are not project related should be filed under the matching Office Admin year, then `Invoices & Receipts`, then the vendor folder.

Use this rule when the invoice has nothing that can reasonably be interpreted as a project address or project designation.

Pattern:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\{Year}\Invoices & Receipts\{Vendor}`

For the current year:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Invoices & Receipts\{Vendor}`

If the vendor folder does not exist, do not guess between similar vendor names. Route to invoice review unless a later rule allows creating vendor folders.

## Status

Detailed parsing, naming, logging, and exception-handling rules are pending future instructions.

## Invoice Categories

Invoices fall broadly into two categories:

1. Project invoices
2. General invoices

Use this classification before routing or filing an invoice. If an invoice is clearly tied to a specific property/project, treat it as a project invoice. If it is not clearly tied to a specific property/project, treat it as a general invoice unless later rules give a more specific classification.

## Invoice Naming

Use the same naming convention for both project invoices and general invoices:

`YY-MM-DD - Vendor.pdf`

Use the invoice issue date as the file date. If the invoice issue date is not visible but the due date is visible, route the invoice for review unless a later rule allows a specific exception. If more than one invoice from the same vendor has the same invoice date, append the invoice number or another clear differentiator before adding a numeric duplicate suffix.

Examples:

- `26-05-26 - Greenview Works.pdf`
- `26-05-26 - Greenview Works - 000373.pdf`

## Property Designation Rule

Scanned invoices should include a property/project designation on the document.

- If the vendor already included the property designation, use that to route the invoice.
- If the vendor did not include a designation, a human will hand-write the numeric portion of the property address on the paper before scanning.
- The project designation may be handwritten on the invoice before scanning. If the handwritten designation can be read and confidently matched to a project, use it to route the invoice.
- Use the handwritten numeric address marker or handwritten project designation to match the invoice to the running project list and file it under the correct project folder.
- Project-related invoices should be filed under the matching project path:

  `All Properties\{Project}\Owning`

- If the designation cannot be confidently matched to a project, route the file for review rather than guessing.

## Invoice Review Folder

Invoice/receipt items that cannot be confidently matched or processed should use a separate review folder from the mortgage/credit-card statement review workflow:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Invoices & Receipts\_Needs Review`

Do not use the document-scanning statement review folder for invoice exceptions.

## Invoice Register Rules

Invoice register rows are historical entries. Keep every processed invoice as its own row instead of overwriting one current row per vendor/account.

The invoice worksheet/register view should include `Invoice #` immediately after the invoice date column.

Do not use `Last Min Payment` or `Current Min Payment` on the invoice worksheet/register view. Those comparison fields apply to mortgage and credit-card account statements, not individual invoices.
