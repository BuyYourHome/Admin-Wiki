---
name: document-scanning
description: Process scanned financial/admin PDFs from Office Admin scan folders. Use when Codex needs to inspect, OCR or visually parse, split, name, route, archive, or log scanned mortgage statements, bank statements, credit card statements, loan/line-of-credit statements, invoices, receipts, CPA/tax forms, donation records, or medical statements.
---

# Document Scanning

Development notes, source inventory, and open questions for this workflow live in `C:\Codex\Wiki Files\Project Rooms\Document Scan\`.

Process scanned Office Admin PDFs and JPG/JPEG image scans conservatively. Split combined scans into separate statement/account files when boundaries are clear, convert single-image scans to filed PDF outputs when appropriate, name them consistently, file them into the mapped Teams/SharePoint folders, and write a plain text log for every source scan.

## Paths

- Scan intake: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`
- Logs: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Logs`
- Archive: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Archived`
- Destination root: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`
- Property root for mortgage and property insurance documents: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`
- Current property/mortgage reference workbook: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Credit Cards Sheet.xlsx`, worksheet `Mortgages`

Read `references/folder-map.md` before routing files. Read `references/routing-rules.md` before deciding uncertain matches.

## Workflow

1. Find the requested scan or the newest PDF, JPG, or JPEG in the scan intake folder.
2. For PDFs, inspect page count and whether embedded text exists. Use `scripts/inspect_pdf.py` when useful.
3. If the PDF is image-only, or if the source is a JPG/JPEG image, visually/OCR-parse the scan. Do not guess from the source file name alone.
4. Identify document boundaries using institution/vendor, account number, statement date, page numbers, and header changes.
5. Decide one output group per account/document. If confidence is low, route the source or page range to review instead of filing approximately.
6. Name output PDFs with the approved naming convention.
7. Split PDF pages with `scripts/split_pdf.py` or equivalent PDF tooling. For JPG/JPEG scans, create a single filed PDF output unless routing confidence is low.
8. Save each output PDF into the matching folder from `references/folder-map.md`.
9. Write or append a `.log.txt` file in the Logs folder with the summary, destinations, confidence notes, and review items.
10. When processing is complete and intent is clear, move the original scan to Archived. Never delete it.

## Naming

Use this format unless Boss gives a different instruction:

`YY-MM-DD - Company.pdf`

Use the statement date or invoice date from the document, not the scan date. If only a due date is visible, use review unless the statement date can be inferred confidently.

Examples:

- `26-05-05 - First Citizens Bank VISA.pdf`
- `26-05-02 - Lowe's Pro.pdf`
- `26-04-30 - SECU Mortgage.pdf`

For mortgage statements, use a credit-card-style naming pattern, with the file name starting with the full statement date in `YY-MM-DD` format:

`YY-MM-DD - Mortgage Company - AccountSuffix - Mortgage Statement.pdf`

Example:

- `26-05-03 - Shellpoint - 1234 - Mortgage Statement.pdf`

If a file already exists, create a unique filename by appending ` (2)`, ` (3)`, etc. Do not overwrite silently.

## Mortgage Statement Routing

Mortgage statements are property documents. Do not file them in the generic Office Admin `2026\Loans` folder unless Boss explicitly instructs that for a specific document.

For each scanned PDF, JPG, or JPEG:

1. Determine whether the scan contains mortgage statements.
2. If it does, identify each individual mortgage statement and split each statement into its own PDF.
3. Match each statement to the correct project/property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

4. Use reliable document details such as property address, numeric street address, borrower/entity, loan number or suffix, mortgage company, servicer, or other statement details.
5. Open the matched property folder and drill down to its `Owning` folder.
6. Inside `Owning`, find the folder named for the mortgage company shown on the statement.
7. Save the split statement PDF in that mortgage-company folder.

If the property or mortgage-company folder cannot be identified confidently, do not guess and do not create a new folder automatically. Route the item to review and document what was unclear in the log.

## Property Insurance Documents

Property insurance documents are property documents when they come from an insurance company or from a mortgage company about property insurance coverage.

Use `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Credit Cards Sheet.xlsx`, worksheet `Mortgages`, as the current property and mortgage reference source when matching insurance documents.

For each scanned property insurance document:

1. Determine whether the document came from an insurance company or a mortgage company.
2. Match it to the correct property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

3. Use reliable details such as property address, borrower/entity, mortgage company, loan number or suffix, insurance company, policy number, or other document details.
4. Open the matched property folder and drill down to its `Owning` folder.
5. Save the filed PDF directly in `Owning` unless a clearly matching insurance-company or mortgage-company subfolder already exists.
6. Do not create new folders automatically.
7. If the property, policy, coverage status, or payment responsibility cannot be identified confidently, route the item to review and document the uncertainty in the log.

For insurance-company documents, capture:

- Insurance company name.
- Policy number.
- Property address.
- Annual payment.
- Whether the premium is escrowed in the mortgage payment.
- Whether Buy Your Home pays the insurance company directly.
- Whether payment is monthly or annual.

For mortgage-company insurance documents, capture:

- Mortgage company name.
- Property address.
- Whether the mortgage company accepted or rejected the coverage.
- Date of status change.
- Policy number or insurance company name when shown.

Do not infer escrow status, direct-pay status, payment frequency, coverage acceptance, coverage rejection, or status-change date from weak context. If the document does not say clearly, mark that field as unknown and route to review when the missing field affects filing or follow-up.

## Invoice And Receipt Routing

Keep invoice review separate from statement review.

Project/property invoices and receipts are property documents when the scan identifies a specific property address, project folder, property number, handwritten numeric address marker, or other reliable project designation.

For each scanned invoice or receipt:

1. Decide whether it is project-specific or general.
2. For project-specific items, match the document to the correct property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

3. Use reliable details such as property address, numeric street address, project number, handwritten property designation, entity label, vendor/payee, or other project details.
4. Open the matched property folder and drill down to its `Owning` folder.
5. Save the filed PDF directly in `Owning` unless a more specific approved subfolder already exists.
6. For general invoices that are not project-related, file under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Invoices & Receipts\{Vendor}`

7. If the project, vendor folder, invoice date, or destination cannot be identified confidently, route to invoice review instead of the statement review folder:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Invoices & Receipts\_Needs Review`

Do not create new vendor folders or choose between similar vendor names unless Boss gives a later rule or specific approval.

## Boundary Rules

Treat a new document as likely starting when a page contains:

- A new statement/invoice title or header.
- A different institution/vendor.
- A different account number or account suffix.
- A different statement period/date.
- Page numbering that restarts at 1.
- A new remittance/payment coupon after a previous document ends.

Treat pages as one document when account, institution, statement period, and continuing page numbers match.

## Logging

Write one text log per source scan in the Logs folder. Include:

- Source scan path.
- Page count and whether text was embedded or image-only.
- Planned and completed split ranges.
- Document identity for each output.
- Statement/invoice date used for naming.
- Destination folder and output file path.
- Confidence notes and any review items.
- Archive path for the original source scan, if archived.

## Scanned Document Register Alerts

When updating the scanned document register, use one row per account and compare new statement data to the existing row before overwriting it.

After a row is updated or reviewed, check the alert rules below. If a row meets an alert rule, email Jenny at `Jenny@BuyYourHomeLLC.com` and copy Wes. If the email is sent by OfficeAssist, send it from the OfficeAssist email account and state that it is sent on Wes's behalf.

Current alert rules:

1. `Current Min Payment` is greater than `Last Min Payment`.
2. `Current Min Payment` is more than `$10.00` less than `Last Min Payment`.

The alert email should identify the sheet, property/project, lender/vendor, statement date, last minimum payment, current minimum payment, and source statement file when available. Do not send duplicate alerts for the same row and same statement date unless a later update changes the alert details.

## Insurance Register Notes

Insurance tracking should use one row per property and policy when an insurance register worksheet exists.

Match insurance rows using:

`Property / Project + Property Address + Insurance Company + Policy #`

If an insurance worksheet does not exist yet, do not substitute another worksheet. Capture the insurance details in the scan log and final summary, and flag that register update is pending.

## Safety

- Never delete source scans.
- Never overwrite existing filed PDFs.
- Never pay invoices, submit forms, move money, contact vendors, or spend money.
- Do not file external lead/customer documents unless the destination is clear and approved.
- If a scan contains verification codes, passwords, security codes, or scam-looking messages, flag for review and do not share the code.

## Review Handling

Use or create:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\_Needs Review`

Move or copy uncertain statement/account output there only when needed, and explain what made it uncertain in the log and final summary.

Invoice and receipt exceptions use the separate invoice review folder:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\Invoices & Receipts\_Needs Review`
