# Insurance Document Rules

Created: 2026-06-15

## Scope

Insurance-related scanned documents include:

- Documents from insurance companies about property insurance.
- Documents from mortgage companies about property insurance coverage, escrow, acceptance, rejection, or status changes.

These are property documents, not general Office Admin invoices.

## Property Reference Source

Use this workbook for current property and mortgage context when matching insurance documents:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Credit Cards Sheet.xlsx`

Use worksheet:

`Mortgages`

## Insurance-Company Documents

When the document comes from an insurance company, capture:

- Insurance company name
- Policy number
- Property address
- Annual payment
- Whether the premium is escrowed in the mortgage-company payment
- Whether Buy Your Home pays the insurance company directly
- Whether payment is monthly or annual

## Mortgage-Company Insurance Documents

When the document comes from a mortgage company, capture:

- Mortgage company name
- Property address
- Whether the mortgage company accepted or rejected the coverage
- Date of status change
- Insurance company name or policy number when shown

## Filing Rule

Match the document to the correct property folder under:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

Then file under that property's `Insurance` folder.

If the matching property folder is clear but the `Insurance` folder does not exist, route the document to review and log that the destination folder is missing. Do not create the folder automatically unless Boss gives a later rule or specific approval.

If the property, policy, coverage status, escrow/direct-pay status, or payment frequency cannot be identified confidently, route the document to review and log the missing or unclear fields.

## Register Rule

Insurance tracking should use one row per property and policy when an insurance register worksheet exists.

Track scanned insurance documents chronologically for each property/policy so the current insurance status can be read from the newest reliable status document.

Chronological tracking should preserve:

- Document date
- Source company
- Document type or status event
- Coverage accepted/rejected status when shown
- Escrow/direct-pay status when shown
- Payment frequency and amount when shown
- Filed document path
- Notes about uncertainty or missing fields

When a newer document changes a property/policy status, keep the older history and update the current status fields from the newest reliable document. Do not overwrite history with only the latest status.

If the insurance register worksheet does not exist yet, do not write insurance data into an unrelated worksheet. Capture the fields in the scan log and final summary, and flag the register update as pending.
