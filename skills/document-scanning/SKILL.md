---
name: document-scanning
description: Process scanned financial/admin PDFs from Office Admin scan folders. Use when Codex needs to inspect, OCR or visually parse, split, name, route, archive, or log scanned mortgage statements, bank statements, credit card statements, loan/line-of-credit statements, property insurance documents, property closing documents, signed operating agreements, invoices, receipts, CPA/tax forms, donation records, or medical statements.
---

# Document Scanning

Development notes, source inventory, and open questions for this workflow live in `C:\Codex\Wiki Files\Project Rooms\Document Scan\`.

Process scanned Office Admin PDFs and JPG/JPEG image scans conservatively. Split combined scans into separate statement/account files when boundaries are clear, convert single-image scans to filed PDF outputs when appropriate, name them consistently, file them into the mapped Teams/SharePoint folders, and write a plain text log for every source scan.

## Paths

- Scan intake: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`
- Logs: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Logs`
- Archive: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Archived`
- Destination root: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`
- Property root for mortgage, property insurance, and property closing documents: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`
- Operating Agreements project room for signed operating-agreement source matching: `C:\Codex\Wiki Files\Project Rooms\Operating Agreements`
- Current property/mortgage reference workbook: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Credit Cards Sheet.xlsx`, worksheet `Mortgages`

Use the SharePoint/Teams connector as the default discovery path for locating scan files and matching destination folders when connector access is available. Use local synced folders as the scanner drop-zone, working-copy path, PDF processing path, archive/log path, and fallback path.

Read `references/folder-map.md` before routing files. Read `references/routing-rules.md` before deciding uncertain matches.

## Workflow

1. Use the SharePoint/Teams connector first to locate requested or newest PDF, JPG, or JPEG scans in the Office Admin scanned-files location when connector access is available.
2. Check the local synced scan intake folder as the scanner drop-zone, processing workspace, and fallback path.
3. For PDFs, inspect page count and whether embedded text exists. Use `scripts/inspect_pdf.py` when useful.
4. If the PDF is image-only, or if the source is a JPG/JPEG image, visually/OCR-parse the scan. Do not guess from the source file name alone.
5. Identify document boundaries using institution/vendor, account number, statement date, page numbers, and header changes.
6. Decide one output group per account/document. If confidence is low, route the source or page range to review instead of filing approximately.
7. Name output PDFs with the approved naming convention.
8. Split PDF pages with `scripts/split_pdf.py` or equivalent PDF tooling. For JPG/JPEG scans, create a single filed PDF output unless routing confidence is low.
9. Use the SharePoint/Teams connector first to confirm matching destination folders and source documents when available.
10. Save each output PDF into the matching folder from `references/folder-map.md`.
11. Write or append a `.log.txt` file in the Logs folder with the summary, destinations, confidence notes, and review items.
12. When processing is complete and intent is clear, move the original scan to Archived. Never delete it.

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

## Property Closing Documents

Property closing documents are property documents when a scan contains signed closing-package documents for a Buy Your Home property.

Property closing packages may arrive as one combined scan. For each scanned property closing package:

1. Determine whether the scan contains signed property closing documents.
2. Identify each individual closing document and split each document into its own PDF when boundaries are clear.
3. Match each document to the correct project/property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

4. Use reliable details such as property address, buyer/seller names, entity name, project folder name, closing date, document title, or other closing-package details.
5. Search the matched property's folder tree for the existing unsigned version of the same document.
6. Save the signed scan in the same folder as the unsigned version.
7. Name the signed PDF with the unsigned document's base name plus ` - Signed` before `.pdf`.

Examples:

- `320 Rose Pl - Contract for Deed Agreement - DRAFT.docx` -> `320 Rose Pl - Contract for Deed Agreement - DRAFT - Signed.pdf`
- `320 Rose Pl - Promissory Note for Contract for Deed - DRAFT.pdf` -> `320 Rose Pl - Promissory Note for Contract for Deed - DRAFT - Signed.pdf`

If the target signed filename already exists, do not overwrite it. Use the next available suffix such as ` (2)` and document the duplicate-looking condition in the log.

If the property, document boundary, document title, or matching unsigned version cannot be identified confidently, route the item to general review and document what was unclear in the log. Do not create a new property folder or file beside an approximate unsigned match.

## Signed Operating Agreements

Signed operating agreements are entity governance documents when a scan contains newly signed operating agreements, amendments, consents, membership schedules, or related signature pages for a Buy Your Home-related entity.

For each scanned signed operating-agreement package:

1. Determine whether the scan contains signed operating-agreement documents.
2. Identify each individual entity document and split each document into its own PDF when boundaries are clear.
3. Match each document to the correct entity using reliable details such as entity name, EIN when shown, agreement title, effective date, member/manager names, signature block, or other document details.
4. Search the relevant Teams-synced entity folder and the Operating Agreements project-room outputs for the existing unsigned, approved-final, or controlling source version of the same document.
5. Save the signed PDF in the same folder as the matched unsigned or approved-final version.
6. Name the signed PDF with the matched document's base name plus ` - Signed` before `.pdf`.

Example:

- `26-06-18 Sell Your Home LLC Operating Agreement - Approved Final.docx` -> `26-06-18 Sell Your Home LLC Operating Agreement - Approved Final - Signed.pdf`

If the target signed filename already exists, do not overwrite it. Use the next available suffix such as ` (2)` and document the duplicate-looking condition in the log and report.

If the entity, document boundary, document title, or matching unsigned/approved-final version cannot be identified confidently, route the item to general review and document what was unclear in the log. Do not create a new entity folder, move prior operating agreements into archive, or file beside an approximate unsigned match.

When a scan run files signed operating agreements, generate a friendly PDF status report with one row per detected entity document. Include entity, document title, page range, matched unsigned/approved-final source, filed signed PDF path, filing status, and review flags. Email the report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`. In the email body, note anything that needs attention, including unmatched entities, missing source versions, duplicate-looking signed files, unclear signature status, missing pages, or any item routed to review.

## Property Insurance Documents

Property insurance documents are property documents when they come from an insurance company or from a mortgage company about property insurance coverage.

Use `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Credit Cards Sheet.xlsx`, worksheet `Mortgages`, as the current property and mortgage reference source when matching insurance documents.

For each scanned property insurance document:

1. Determine whether the document came from an insurance company or a mortgage company.
2. Match it to the correct property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

3. Use reliable details such as property address, borrower/entity, mortgage company, loan number or suffix, insurance company, policy number, or other document details.
4. Open the matched property folder and drill down to its `Insurance` folder.
5. Save the filed PDF in the property's `Insurance` folder.
6. If the matching property folder is clear but the `Insurance` folder does not exist, route the item to review and document that the destination folder is missing. Do not create the folder automatically unless Boss gives a later rule or specific approval.
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

Track insurance documents chronologically for each property and policy so the current status can be read from the newest reliable status document. Preserve each insurance document's date, source company, document type/status event, accepted/rejected coverage status when shown, status-change date when shown, escrow/direct-pay status when shown, payment frequency and amount when shown, filed document path, confidence, and uncertainty notes.

When a newer insurance document changes a property's or policy's status, keep the prior history and update the current status from the newest reliable document. Do not overwrite or collapse the historical trail into only the latest status.

### Insurance Cancellation Notices

When an insurance cancellation, non-renewal, lapse, lender-placed, second notice, or final notice is found:

1. Extract the policy number, insured/entity name, property address if visible, insurance company, mortgage company if visible, effective date, expiration date, processed/notice date, cancellation/rejection reason, annual premium, and whether the policy is bill-to-mortgagee.
2. Cross-check the policy number against existing filed insurance declarations, evidence-of-insurance files, the current property/mortgage reference workbook, and SharePoint/Teams search when the local synced folders do not show all files.
3. Treat an exact policy-number match to a filed declaration or EOI as the strongest property match. Record the matched declaration/EOI path in the log or report.
4. Do not match a cancellation notice to a property by company, entity, or policy dates alone. If the policy number does not match an existing filed policy and no property address is visible, route the notice to review.
5. For confirmed cancellation/lapse/final-notice documents, mark the property's current insurance status as review-needed until a newer reliable document shows reinstatement, replacement coverage, or lender acceptance.
6. Keep unmatched cancellation notices in the Office Admin review folder and record why the property could not be confirmed.

### Insurance Status Reports

When Boss asks for a property insurance status report:

1. Use one row per property, with a separate review row for unmatched notices that cannot be tied to a property.
2. Include columns for property, lender/mortgage company, insurance company, policy number, annual payment, escrow/direct-pay status, payment frequency, latest filed document, new scan/status notices, current status, and review flags.
3. Organize each property's evidence chronologically so the current status is based on the newest reliable status document.
4. Use color or status labels so review-needed, critical cancellation/lapse, confirmed/strong-match, and closed mortgage rows are easy to scan.
5. State unknown fields as unknown. Do not invent escrow status, direct-pay status, mortgage acceptance, or payment frequency.
6. Each time the report is regenerated, email the friendly report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`. In the email body, note anything in the report that needs attention, including critical matches, coverage gaps, lender acceptance problems, cancellation/lapse notices, unresolved review items, missing policy numbers, missing Insurance folders, or unclear payment responsibility.

### Mortgage Statement Reports

When Boss asks for a mortgage statement report, or when a scan run files mortgage statements and a report is appropriate:

1. Use one row per property/loan.
2. Include columns for property, mortgage company/servicer, loan number or suffix, statement date, due date, payment due, past-due/delinquency/late-fee/foreclosure-warning flag, escrow/tax/insurance notice flag, latest filed statement path, and review flags.
3. Use color or status labels so late, delinquent, foreclosure-warning, escrow shortage, insurance-request, missing-match, and review rows are easy to scan.
4. Email the friendly report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`.
5. In the email body, note anything that needs attention, including late notices, payment changes, escrow shortages, insurance requests, lender-placed insurance warnings, foreclosure language, missing property matches, missing mortgage-company folders, or any statement routed to review.

### Credit Card Statement Reports

When Boss asks for a credit card statement report, or when a scan run files credit card statements and a report is appropriate:

1. Use one row per card/account.
2. Include columns for card issuer/account label, account last 4 or suffix, business/entity or property/project when shown, statement date, due date, statement balance, minimum payment, prior minimum payment comparison when available, latest filed statement path, and review flags.
3. Use color or status labels so minimum-payment increases, notable minimum-payment decreases, late fees, unusual balance changes, missing account matches, duplicate-looking statements, and review rows are easy to scan.
4. Email the friendly report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`.
5. In the email body, note anything that needs attention, including minimum-payment increases or notable decreases, late fees, unusual balance jumps, missing account matches, duplicate-looking statements, or any statement routed to review.

### Lowe's Statement Allocation Mode

When Credit Card Statement Mode identifies and files a Lowe's statement, preserve all normal Lowe's statement handling first: inspect/OCR, split if needed, file the statement in the approved Lowe's credit-card statement folder, log the routing, include it in the credit card statement report, and flag normal statement review items.

After normal statement filing, run Lowe's Statement Allocation Mode as an additive workflow. Extract each eligible purchase, charge, return, or credit line separately as invoice-entry-style source data. Do not treat the entire Lowe's statement as one invoice for one project, and do not force all statement lines into one vendor tab.

For each line item, capture when available:

- Lowe's account label and account last 4.
- Statement date and statement period.
- Transaction date and posting date.
- Transaction description, receipt number, invoice/order/reference number, or memo.
- PO value or other project/property clue shown on the statement.
- Amount, including whether it is a charge, return, credit, fee, or interest.
- Likely project/property.
- Recommended project-management workbook.
- Recommended worksheet/vendor tab.
- Source scan path and filed statement path.
- Confidence/status.
- Duplicate-risk notes and missing or uncertain fields.

Use the PO value as a strong project/property clue when present, but do not guess if the PO is missing, ambiguous, or conflicts with other line details. Evaluate project/property and vendor-tab routing independently for each line item.

For high-confidence line items, create a structured Lowe's statement allocation packet for Project Spreadsheet Invoice Entry with one line item per packet row or record. Mark unclear line items `Needs Review` and include the reason. Document Scan must not edit the project-management workbook directly.

### Invoice And Receipt Reports

When Boss asks for an invoice/receipt report, or when a scan run files invoices or receipts and a report is appropriate:

1. Use one row per invoice or receipt.
2. Include columns for vendor/payee, property/project or general category, invoice or receipt date, due date when shown, amount, invoice number or receipt reference when shown, filed location, review/payment status, and review flags.
3. Use color or status labels so due-soon, past-due, unknown-vendor, unclear-property-match, duplicate-looking, missing-amount/date, security-code/scam concern, and review rows are easy to scan.
4. Email the friendly report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`.
5. In the email body, note anything that needs attention, including invoices due soon, past-due notices, unknown vendors, unclear property matches, duplicate-looking invoices, missing amounts or dates, security-code/scam concerns, or any item routed to invoice review.
6. Do not pay invoices, submit forms, move money, or contact vendors.

### SharePoint / Teams Connector Default

Use the SharePoint/Teams connector as the default discovery path for scanned files, property folders, entity folders, insurance folders, and matching source documents when connector access is available.

Use local synced folders as the scanner drop-zone, processing workspace, archive/log path, and fallback path. If the connector finds a scan that is not visible locally, download a working copy for processing, preserve the original SharePoint source file, log the SharePoint URL, and do not move or delete the source scan.

Use local synced folders as fallback when the connector is unavailable, lacks the needed site/library/folder, is stale, or cannot perform the required read/write action safely.

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

### Project Spreadsheet Invoice Entry Handoff

When Document Scan processes a project-specific invoice or receipt, finish the scan workflow first: inspect/OCR the scan, identify the document as an invoice or receipt, match it to the correct project/property when confidence is high, save or copy the invoice file into the correct Teams project folder, and write the scan routing log.

Do not edit the project-management spreadsheet directly. After filing a high-confidence project invoice or receipt, create a structured invoice packet and hand it off to Project Spreadsheet Invoice Entry.

Default handoff trigger: send a direct follow-up message to the dedicated Project Spreadsheet Invoice Entry chat with the packet path and packet summary. The Project Spreadsheet Invoice Entry heartbeat is a backup monitor that periodically checks the packet folder for handoffs that were not delivered by direct message.

Project Spreadsheet Invoice Entry project room:

`C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry`

Dedicated chat/thread:

`019f3d56-b310-75c0-b084-616bfc1e9f59`

Document Scan owns scan inspection/OCR, document splitting, invoice/receipt identification, project/property folder routing, saving or copying the invoice file, scan log entries, and invoice packet creation.

Project Spreadsheet Invoice Entry owns selecting the exact live project-management workbook, checking workbook records for duplicates, deciding final spreadsheet row placement, inserting the invoice record, preserving workbook formulas/formatting/selectors, validating totals and downstream links, and uploading the verified workbook back to Teams/SharePoint.

Include these fields in each scanned-invoice handoff packet:

- Project/property
- Vendor name
- Invoice date
- Invoice number, if available
- Invoice amount
- Work category
- Source scan path
- Filed invoice path in Teams/project folder
- Recommended project-management workbook
- Recommended worksheet/vendor tab
- Confidence/status
- Duplicate-risk notes, if any
- Any missing or uncertain fields

If the invoice appears to belong in Vendor Tabs Mode, recommend one of these vendor tabs when confidence is high:

1. Demo & Trash Haul
2. Appliances
3. Plumbing Fixtures
4. Windows & Doors
5. Cabinets
6. Paint
7. Flooring
8. HVAC
9. Electrical Fixtures
10. STR
11. Landscape

Do not recommend tabs right of Landscape, such as Exterior or Furnishing, unless Boss expands Vendor Tabs Mode.

If the category, project, workbook, amount, date, or duplicate status is unclear, set `Confidence/status` to `Needs Review` instead of guessing.

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

Insurance chronology should use one history entry per scanned insurance document or status event. Current-status fields should be based on the newest reliable chronology entry for that property/policy.

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
