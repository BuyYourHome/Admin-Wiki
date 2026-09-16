# Invoice Entry Reusable Lessons

This file contains transaction-neutral lessons for future Invoice Entry work. Transaction histories, vendor identities, document numbers, amounts, project-specific outcomes, approvals, dispatch records, and machine-local paths belong in SharePoint operational records or historical archives.

## Retention And Source Identity

- Keep operational packets, source inventories, logs, registers, decisions, drafts, outputs, and validation evidence in the canonical SharePoint archive, not Git.
- Identify SharePoint material by site URL plus drive-relative path, item ID, or web URL. A synced Windows path is only a temporary tool input and must not become the durable identity.
- Preserve the authoritative source before removing temporary files. Verify archived copies by hash, file count, byte total, or read-back as appropriate.
- Treat migrated Git history as read-only evidence. Do not recreate an active operational ledger in the repository.

## Handoffs And Durable Messaging

- Keep handoff messages concise: one authoritative source pointer, a short summary, the requested operation, and any source-specific warning.
- Treat the durable central message as authoritative and task notification as a wake-up signal only.
- Validate source, destination, authorization, payload identity, and duplicate status before substantive work.
- Record acceptance before processing and exactly one terminal result afterward.
- Reconcile ambiguous or repeated delivery before retrying. Never repeat a possibly successful external action merely because a notification timed out.

## Duplicate And Correction Control

- Prefer project + issuer + document number as the strongest invoice key; use project + issuer + date + amount only as a fallback.
- Repeated email copies, forwards, or notices can be transport duplicates rather than new obligations. Preserve their identities but record one business transaction.
- Compare retained-file hashes and extracted document facts; different scan hashes can still represent the same invoice.
- Apply an explicit correction to the existing line or packet version. Preserve lineage and do not create a second obligation.
- When identity remains ambiguous, stop at `Duplicate Risk` instead of guessing.

## Email Ownership And Delivery Verification

- Invoice Entry prepares permitted email content, recipients, attachments, and authorization evidence; the Email Delivery workflow performs the send.
- Do not mark a message sent without verified sender, recipient, subject, attachment, timestamp, and Sent Items evidence.
- Treat source reading and outbound delivery as separate authorities. Permission to read one exact message does not authorize mailbox search or sending.
- Vendor fact verification, owner approval, filing, workbook posting, payment, and paid status are separate gates.

## Generated Invoice Integrity

- Generate invoices from structured data so corrections and status changes can be reproduced without editing an old PDF.
- Before delivery, filing, or replacement, verify issuer/payee, customer, document number, date, service period, project, amount, and current status wording.
- The outside party billing the company is the invoice issuer; the company is the customer.
- Preserve approval only for format-only revisions that do not change transaction identity, period, accepted lines, allocations, or total.
- Re-render every revised PDF and inspect the full document. A nearly blank continuation page caused only by the amount-due block is a layout defect.

## Time-Card Accumulation

- Use the worker's authorized billing cycle; do not assume every worker shares the same period.
- Reconcile every source into one accumulated record for that worker and period. The structured record is authoritative; the PDF is replaceable output.
- Preserve exact hours and minutes. Do not invent breaks, AM/PM, dates, project allocations, or unstated activity.
- Keep the invoice issuer/payee distinct from the individual worker when labor is billed through another party.
- A reasonable working interpretation may support correction review when the workflow permits it, but it does not establish final allocation, approval, filing, posting, or payment.
- Apply later corrections to the same source line and stable invoice identity.
- Worker accuracy confirmation does not authorize payment. Closed-period owner approval remains a separate gate.

## Statement Processing

- Keep statement extraction with the scanning workflow and allocation/insertion with Invoice Entry.
- Treat a statement as potentially multi-project and multi-category; never assign the entire statement from one matching line.
- Preserve item-level detail when a transaction contains separable purchases, returns, delivery, or credits.
- Route by project first, then by worksheet. Initial statement consumption is review-first unless an approved exception explicitly allows otherwise.
- Retain every uninserted line with sufficient source traceability and a clear hold reason.
- Keep payment, interest, tax-only, accounting-review, unclear-project, and not-ready-project lines outside project workbooks until supported routing exists.
- Use reliable product-page descriptions only when the source item identity matches; otherwise retain source-derived wording.

## Workbook Editing Safety

- Resolve a fresh authoritative workbook from SharePoint before every edit; registry entries and prior filenames are lookup aids only.
- Create a rollback copy before editing.
- Make one narrow structural or formula change at a time. Broad paste, resize, style, and formula operations can corrupt table metadata.
- Treat table headers, table ranges, defined names, formulas, controls, macros, and external links as first-class validation targets.
- Prefer structured table formulas over fixed ranges when the workbook design supports them.
- Preserve existing tax behavior unless a separate authorized rule changes it.
- Save through the required application, reopen cleanly, verify totals and downstream links, and upload only after validation passes.
- If the application disconnects or cleanup times out, assume nothing. Reopen and verify the saved file independently before upload.
- A definitive SharePoint lock or replacement error means the authoritative workbook is unchanged. Re-fetch if the live version changes before retry.

## Review And Reconcile

- Read review work by table name and column headers, not visible row numbers, filters, or fixed cell ranges.
- Verify the review-request defined name points to its documented absolute cell before relying on it.
- An explicit authorized reconcile request can be sufficient to evaluate existing review rows even when the visible checkbox is not selected.
- Move only rows with complete source traceability and an approved destination. Preserve hard-stop, missing-data, and duplicate-risk rows.
- Keep the review row after movement and record destination and movement status so later runs can deduplicate.
- Clear a pending request marker only after the complete request passes save, reopen, formula, link, and upload validation.

## Receipts For Collected Money

- A collected-money receipt is not a vendor purchase receipt. Preserve the original expense and classify collected proceeds separately.
- An asking price or listing identifies an item but does not prove a completed sale or collected amount.
- Collection and deposit are separate states; never infer deposit from possession of cash.
- Require exact property, payer or explicit unknown status, collector or explicit unknown status, payment method, line items, total collected, application, and durable source evidence.
- Keep listing or marketplace actions with their owning workflow and deduplicate any sold-status handoff before retry.

## Validation And Completion

- Validate packet values against source evidence before insertion or routing.
- Keep approval, delivery, filing, workbook posting, accounting entry, payment, and paid status as independent fields.
- Record the operational result and next permitted action in SharePoint before marking work complete.
- Do not use a Git commit as an operational retention fallback.
- Remove temporary local artifacts only after the authoritative archive and required operational records are verified.
