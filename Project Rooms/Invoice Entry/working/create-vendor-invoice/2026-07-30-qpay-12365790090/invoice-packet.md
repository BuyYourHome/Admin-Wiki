# Create Vendor Invoice Packet - QPay Transaction 12365790090

## Packet Status

- Status: `Held - Missing Vendor And Project Mapping`
- Workflow: `Create Vendor Invoice`
- Created: 2026-07-30
- Source type: Routed free-text payment receipt; no invoice attachment.
- Payment evidence: QPay reports a completed card transaction.
- Filing and spreadsheet insertion: not performed.

## Source

- Routed source archive: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive\Source Documents\2026-07-30 QPay Transaction 12365790090\email\2026-07-30-151808-wes-forward-qpay-transaction-12365790090-project-4120.md`
- Outlook message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACgMftuQAAAA==`
- Forwarded sender: `QPay <no-reply@qprosoftware.com>`
- Subject: `FW: QPay transaction successful`
- Wes instruction: `Create this as an invoice for project 4120. Process it normally.`
- Attachments: none.

## Receipt Facts

| Field | Value |
| --- | --- |
| Transaction date/time | 2026-07-30 11:14 AM EDT |
| Transaction number | `12365790090` |
| Order number | `10651` |
| Card | MasterCard ending `6426` |
| Payment amount | `$365.51` |
| Surcharge | `$10.97` |
| Total paid | `$376.48` |
| Project clue | `4120` |

The arithmetic reconciles: `$365.51 + $10.97 = $376.48`.

## Duplicate Check

- No prior Invoice Entry packet or logged transaction was found for transaction `12365790090`.
- No prior Invoice Entry packet or logged transaction was found for order `10651`.
- Because project `4120` is unresolved, no project-folder or workbook duplicate check was attempted.

## Holds

1. The receipt identifies QPay as the payment processor but does not identify the underlying vendor, purchased item or service, or work category.
2. Project `4120` does not appear in the active Invoice Project List or the current project-spreadsheet register.
3. No SharePoint property or root project-management workbook matching `4120` was found.
4. Invoice Entry must not infer that `4120` means `4121 Tensity Dr`.

## Required Decision

Wes must provide:

- the underlying vendor or payee for order `10651`; and
- the full project/property identity intended by `4120`.

After both are confirmed, Invoice Entry can generate the formal paid invoice/receipt record, resolve the exact workbook and destination, rerun duplicate checks, and continue normal filing and posting.
