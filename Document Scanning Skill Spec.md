# Doc Scan Skill Spec

Project room: [[Project Rooms/Doc Scan/README|Doc Scan Project Room]]

Working name: `doc-scan`

Purpose: process scanned financial/admin PDFs and image scans (`.jpg` / `.jpeg`), split combined scans into separate documents when applicable, name them consistently, and route them into the correct Office Admin or property/project folder.

Installed skill location:

`C:\Users\wesbr\.codex\skills\doc-scan`

Primary folder map:

- `Document Scanning Folder Map.md`
- Root document destination: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`
- Property/project destination root: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`
- Scan intake folder: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

Connector preference:

- Use the SharePoint/Teams connector as the default discovery path for locating scan files and matching destination folders when connector access is available.
- Use the local synced paths as the scanner drop-zone, working-copy, PDF processing, logging, archive, and fallback paths.

## Skill Trigger

Use this skill when asked to process scanned mortgage statements, credit card statements, bank statements, invoices, receipts, tax documents, CPA forms, medical bills, donation records, or similar Office Admin documents.

Example user requests:

- Process this scan.
- Split this mortgage statement scan by account.
- File the scanned statements in the 2026 Office Admin folders.
- Review the scan intake folder and route anything new.
- Parse this PDF or image scan into separate account files.

## Core Responsibilities

1. Locate one or more scanned PDFs, JPGs, or JPEGs through the SharePoint/Teams connector when available, then through the local synced intake folder or explicit file path as the processing/fallback path.
2. OCR pages when text is not already embedded, and visually/OCR-parse JPG/JPEG image scans.
3. Identify document type, institution/vendor, account number suffix, statement date, invoice date, and page boundaries.
4. Split multi-document PDF scans into one PDF per account/document when boundaries are clear.
5. Convert JPG/JPEG scans to a PDF output when filing, unless the item is routed to review.
6. Name each output PDF using a consistent naming convention.
7. Route each output PDF to the best matching folder under the 2026 Office Admin folder map or the matching property/project/entity folder, using the SharePoint/Teams connector first to discover and confirm folder matches when available.
8. Avoid destructive changes. Never delete the original scan automatically.
9. Flag uncertain classifications for human review instead of guessing.

## Document Types

Initial supported types:

- Mortgage statements
- Bank statements
- Credit card statements
- Line of credit statements
- Loan statements
- Property insurance documents from insurance companies or mortgage companies
- Property closing documents
- Signed operating agreements
- Invoices
- Receipts
- CPA/tax forms
- Donation records
- Medical bills/statements

## Routing Rules

Use the folder map as the routing authority.

Primary routing categories:

- Bank statements: `2026\Bank Statement\...`
- Credit cards: `2026\Credit Cards\...`
- Lines of credit: `2026\Line of Credit\...`
- Non-property-specific loans: `2026\Loans\...`
- Mortgage statements: match the statement to the related property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, drill into that property's `Owning` folder, then save the statement in the folder named for the mortgage company.
- Property insurance documents: match the document to the related property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, drill into that property's `Insurance` folder, then save there.
- Property closing documents: match the document to the related property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, find the existing unsigned version in that property's folder tree, then save the signed scan beside it using the unsigned name plus ` - Signed`.
- Signed operating agreements: match the document to the related entity, find the existing unsigned, approved-final, or controlling source version in the entity folder or Operating Agreements project-room outputs, then save the signed scan beside it using the matched name plus ` - Signed`.
- Project/property invoices and receipts: match the document to the related property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, drill into that property's `Owning` folder, then save the filed PDF there unless a more specific approved subfolder already exists.
- Quest invoices: `2026\Quest\Invoices\...`
- Quest receipts: `2026\Quest\Receipts\...`
- General receipts: `2026\Receipts`
- CPA forms: `2026\CPA\...`
- Tax/property tax documents: `2026\Taxes` or `2026\Tax-Properties`
- Donations: `2026\Donations`
- Medical: `2026\Medical`

If no confident destination exists, route to a review folder, not to an approximate folder.

Recommended review folder:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026\_Needs Review`

## Project Invoice And Receipt Routing

Project/property invoices and receipts are property documents when the scan identifies a specific property address, project folder, or property number.

For each project invoice or receipt:

1. Match the document to the correct property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

2. Use reliable details such as property address, numeric street address, project number, entity label, vendor/payee, or other project details.
3. Open the matched property folder and drill down to its `Owning` folder.
4. Save the filed PDF directly in `Owning` unless a more specific approved subfolder already exists.
5. If the property folder cannot be identified confidently, route the item to review and document what was unclear in the log.

### Template to Project Handoff

When Doc Scan processes a project-specific invoice or receipt, finish the existing scan workflow first:

1. Inspect/OCR the scan.
2. Identify the document as an invoice or receipt.
3. Match it to the correct project/property when confidence is high.
4. Save or copy the invoice file into the correct Teams project folder.
5. Log the scan routing result.
6. Do not edit the project-management spreadsheet directly.
7. Create a structured invoice packet and hand it off to Template to Project.

Default handoff trigger: send a direct follow-up message to the dedicated Template to Project chat with the packet path and packet summary. The Template to Project heartbeat is a backup monitor that periodically checks the packet folder for handoffs that were not delivered by direct message.

Template to Project project room:

`C:\Codex\Wiki Files\Project Rooms\Template to Project`

Dedicated chat/thread:

`019f3d56-b310-75c0-b084-616bfc1e9f59`

Doc Scan owns scan inspection/OCR, document splitting, invoice/receipt identification, project/property folder routing, saving or copying the invoice file, scan log entries, and invoice packet creation.

Template to Project owns selecting the exact live project-management workbook, checking workbook records for duplicates, deciding final spreadsheet row placement, inserting the invoice record, preserving workbook formulas/formatting/selectors, validating totals and downstream links, and uploading the verified workbook back to Teams/SharePoint.

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

## Property Closing Document Routing

Property closing documents are property documents when the scan contains signed closing-package documents for a Buy Your Home property.

For each scanned property closing package:

1. Determine whether the scan contains signed property closing documents.
2. Identify each individual closing document and split each document into its own PDF when boundaries are clear.
3. Match each document to the correct project/property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

4. Use reliable document details such as property address, buyer/seller names, entity name, project folder name, closing date, document title, or other closing-package details.
5. Search the matched property's folder tree for the existing unsigned version of the same document.
6. Save the signed scan in the same folder as the unsigned version.
7. Name the signed PDF with the unsigned document's base name plus ` - Signed` before `.pdf`.

Examples:

- `320 Rose Pl - Contract for Deed Agreement - DRAFT.docx` -> `320 Rose Pl - Contract for Deed Agreement - DRAFT - Signed.pdf`
- `320 Rose Pl - Promissory Note for Contract for Deed - DRAFT.pdf` -> `320 Rose Pl - Promissory Note for Contract for Deed - DRAFT - Signed.pdf`

If the target signed filename already exists, do not overwrite it. Use the next available suffix such as ` (2)` and document the duplicate-looking condition in the log.

If the property, document boundary, document title, or matching unsigned version cannot be identified confidently, route the item to general review and document what was unclear in the log. Do not create a new property folder or file beside an approximate unsigned match.

## Signed Operating Agreement Routing

Signed operating agreements are entity governance documents when a scan contains newly signed operating agreements, amendments, consents, membership schedules, or related signature pages for a Buy Your Home-related entity.

For each scanned signed operating-agreement package:

1. Determine whether the scan contains signed operating-agreement documents.
2. Identify each individual entity document and split each document into its own PDF when boundaries are clear.
3. Match each document to the correct entity using reliable details such as entity name, EIN when shown, agreement title, effective date, member/manager names, signature block, or other document details.
4. Search the relevant Teams-synced entity folder and the Operating Agreements project-room outputs for the existing unsigned, approved-final, or controlling source version of the same document.
5. Save the signed PDF in the same folder as the matched unsigned or approved-final version.
6. Name the signed PDF with the matched document's base name plus ` - Signed` before `.pdf`.

Example:

- `26-06-18 Investment Services LLC Operating Agreement - Approved Final.docx` -> `26-06-18 Investment Services LLC Operating Agreement - Approved Final - Signed.pdf`

If the target signed filename already exists, do not overwrite it. Use the next available suffix such as ` (2)` and document the duplicate-looking condition in the log and report.

If the entity, document boundary, document title, or matching unsigned/approved-final version cannot be identified confidently, route the item to general review and document what was unclear in the log. Do not create a new entity folder, move prior operating agreements into archive, or file beside an approximate unsigned match.

### Signed Operating Agreement Reports

When a scan run files signed operating agreements:

1. Use one row per detected entity document.
2. Include columns for entity, document title, page range, matched unsigned/approved-final source, filed signed PDF path, filing status, and review flags.
3. Use color or status labels so filed, duplicate-looking, missing-source, unclear-entity, unclear-signature, missing-page, and review rows are easy to scan.
4. Email the friendly report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`.
5. In the email body, note anything that needs attention, including unmatched entities, missing source versions, duplicate-looking signed files, unclear signature status, missing pages, or any item routed to review.

## Property Insurance Document Routing

Property insurance documents are property documents when they come from an insurance company or from a mortgage company about property insurance coverage.

Reference workbook for current property and mortgage matching:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Credit Cards Sheet.xlsx`

Reference worksheet:

`Mortgages`

For each scanned property insurance document:

1. Determine whether the sender/source is an insurance company or a mortgage company.
2. Match the document to the correct project/property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

3. Use reliable details such as property address, borrower/entity, mortgage company, loan number or suffix, insurance company, policy number, or other document details.
4. Open the matched property folder and drill down to its `Insurance` folder.
5. Save the filed PDF in the property's `Insurance` folder.
6. If the matching property folder is clear but the `Insurance` folder does not exist, route the item to review and document that the destination folder is missing. Do not create the folder automatically unless Boss gives a later rule or specific approval.
7. If the property, policy, coverage status, or payment responsibility cannot be identified confidently, route the item to review and document what was unclear in the log.

For insurance-company documents, extract and track:

- Insurance company name
- Policy number
- Property address
- Annual payment
- Whether the premium is escrowed in the mortgage payment
- Whether Buy Your Home pays the insurance company directly
- Whether payment is monthly or annual

For mortgage-company insurance documents, extract and track:

- Mortgage company name
- Property address
- Whether the mortgage company accepted or rejected the coverage
- Date of status change
- Policy number or insurance company name when shown

Do not infer escrow status, direct-pay status, payment frequency, acceptance, rejection, or status-change date from weak context. If the document does not say clearly, mark that field as unknown and route to review when the missing field affects filing or follow-up.

### Insurance Chronology And Current Status

Track insurance documents chronologically for each property and policy so the current status can be read from the newest reliable status document while preserving the document history.

For each insurance document, preserve these chronology fields in the log and any register/update handoff:

- Document Date
- Source Company
- Document Type / Status Event
- Coverage Accepted / Rejected, when shown
- Status Change Date, when shown
- Escrowed In Mortgage Payment, when shown
- Paid Directly To Insurance Company, when shown
- Payment Frequency, when shown
- Annual Payment, when shown
- Filed Document Path
- Confidence
- Notes / Missing Fields

When a newer insurance document changes the property's or policy's status, keep the prior chronology entries and update the current status fields from the newest reliable document. Do not collapse the history into a single latest-status-only row.

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

When Credit Card Statement Mode identifies and files a Lowe's statement, preserve all normal Lowe's statement handling first: inspect/OCR, split if needed, file the statement in the approved Lowe's credit-card statement folder, log the routing, include it in the credit-card statement report, and flag normal statement review items.

After normal statement filing, run Lowe's Statement Allocation Mode as an additive extraction workflow. Doc Scan extracts item-level source data for Template to Project. Doc Scan must not edit any project-management workbook and must not decide final spreadsheet insertion.

Do not treat the entire Lowe's statement as one invoice for one project. A single Lowe's statement may contain charges, returns, credits, fees, or interest for multiple projects and non-project/Home items.

Do not treat each statement transaction or reference number as one Template to Project row when the statement detail shows multiple purchased or returned items. A single Lowe's transaction/reference may produce multiple packet rows. Each packet row should represent one distinct purchasable item, returned item, delivery/shipping charge, fee, or credit component when the detail is visible.

Preserve the shared transaction header on every item row:

- Lowe's account label and account last 4.
- Statement date and statement period.
- Transaction date and posting date, when shown.
- Receipt number, invoice/order/reference number, or memo, when shown.
- Store number, if shown.
- PO value or other project/property clue shown on the statement.
- Source scan path.
- Filed statement PDF path.

For each item row, capture:

- Item description.
- Item amount, if shown or reasonably separable.
- Quantity, if shown.
- Item number/SKU, if shown.
- Charge/credit type.
- Likely project/property, if the PO or other evidence supports it.
- Recommended project-management workbook, if the project/property is high-confidence.
- Recommended worksheet/vendor tab, if the item category is high-confidence.
- Confidence/status.
- Notes explaining any split, uncertainty, duplicate risk, missing fields, or amount allocation issue.

If the transaction total is visible but item-level amounts are not separable, still split visible items into separate packet rows when useful, but mark amount fields as `Needs Review - Amount Split` and explain that the transaction total must be allocated before Template to Project can insert final rows.

Delivery/shipping should be its own row when it is separately shown or materially tied to a transaction. If delivery cannot be assigned to one item confidently, mark it `Needs Review - Allocation`.

Use the PO value as a strong project/property clue when present, but do not guess if the PO is missing, ambiguous, conflicts with other line details, or appears to belong to another project. Evaluate project/property routing independently for each line item.

For non-project/Home items, mark the line as non-project/Home and do not recommend a project-management workbook.

For unclear project items, mark the line `Needs Review - Project` and do not recommend a project-management workbook.

For clear project but unclear vendor-tab items, recommend the project workbook but set the worksheet/vendor tab to blank or `Needs Review`, with a short reason.

For mixed-tab credits or returns, mark the line `Needs Review - Mixed Tab` unless the statement detail clearly identifies the original item and category.

For fees, interest, finance charges, late fees, or payments, mark the line as accounting-review unless Wes has approved a specific project-spreadsheet handling rule. Do not recommend a vendor tab by default.

The packet handed to Template to Project should be item-row based. Each item row should carry the shared statement and transaction header data plus its own item data and routing confidence.

Template to Project owns:

- resolving the exact live project-management workbook,
- deciding whether a line belongs in that workbook,
- checking workbook records for duplicate statement lines,
- deciding final worksheet/vendor-tab placement,
- inserting approved line records,
- routing uncertain lines to the correct Review or exception process,
- validating totals and workbook links,
- uploading the verified workbook back to Teams/SharePoint when authorized.

Default handoff trigger: send a direct follow-up message to the dedicated Template to Project chat with the packet path and a short summary of line counts by status, including high-confidence project lines, unclear project lines, non-project/Home lines, mixed-tab lines, and accounting-review lines.

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

Use the local synced folders as the scanner drop-zone, processing workspace, archive/log path, and fallback path. If the connector finds a scan that is not visible locally, download a working copy for processing, preserve the original SharePoint source file, log the SharePoint URL, and do not move or delete the source scan.

Use local synced folders as fallback when the connector is unavailable, lacks the needed site/library/folder, is stale, or cannot perform the required read/write action safely.

## Boundary Detection Rules

Treat a new document as likely starting when a page contains one or more of:

- A statement or invoice title/header.
- Institution/vendor name differs from the prior page.
- Account number differs from the prior page.
- Statement period/date differs from the prior page.
- Page numbering restarts at 1.
- A remittance coupon or payment slip followed by a new header.

Treat pages as part of the same document when:

- Account number and institution match.
- Page numbering continues.
- Statement period/date matches.
- Headers/footers match the same account.

If boundary confidence is low, do not split silently. Put the scan or uncertain page range into review with a note.

## Account Matching

Prefer exact matches using:

- Last 4 account digits in the destination folder name.
- Institution/vendor name in the folder name.
- Business/entity name such as BYH, SYH, Heritage Mgmt, Hollinger Investments, or personal/home.

Use fuzzy matching only as a suggestion. Do not file automatically on weak fuzzy matches.

## Naming Convention

Preferred file name format:

`YYYY-MM - Institution or Vendor - AccountSuffix - Document Type.pdf`

Examples:

- `2026-05 - SECU - Mortgage 3953-91 - Statement.pdf`
- `2026-05 - Chase BYH - 5323 - Credit Card Statement.pdf`
- `2026-05 - Quest - Escalade - Invoice.pdf`

For mortgage statements, use the same style as credit card statements, but the file name must start with the full statement date in `YY-MM-DD` format:

`YY-MM-DD - Mortgage Company - AccountSuffix - Mortgage Statement.pdf`

Example:

- `26-05-03 - Shellpoint - 1234 - Mortgage Statement.pdf`

If only a due date is available, use the statement date if present; otherwise use the scan date and add a note in the review log.

## Outputs

For each processed scan, produce:

- Split/routed PDF files, including PDF outputs converted from JPG/JPEG scans.
- A processing summary.
- A review log entry for uncertain pages or unmatched folders.
- A plain text log file in `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Logs`.

Recommended summary fields:

- Source scan file
- Pages processed
- Files created
- Destination folders
- Confidence level
- Items needing review

Log file requirement:

- Write one `.txt` log per scanned source file.
- Put logs in `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Logs`.
- Include the planned or completed split ranges, document identities, output file names, destination folders, confidence notes, and review items.
- Use a log file name based on the source scan file name, for example `Receipt_2026-05-24_134923.log.txt`.

## Scanned Document Register Rules

Maintain the scanned document register as an account-level tracker, not as a statement-history ledger.

Register workbook:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Scanned Document Register.xlsx`

Register sheets:

- `Mortgage`
- `Credit Cards`
- `Invoices`
- `Insurance` when the workbook has been updated to support insurance tracking

Use one row per account. Match an existing account row using:

`Document Category + Lender / Vendor + Account / Loan Last 4 + Property / Project`

When a new statement is found, compare its `Statement / Invoice Date` to the existing row's `Statement / Invoice Date`.

If the new statement date is newer:

1. Update the existing account row instead of adding a new row.
2. Before overwriting, move the old `Current Min Payment` value into `Last Min Payment`.
3. Update the current fields:
   - `Statement / Invoice Date`
   - `Due Date`
   - `Amount Due`
   - `Current Balance`
   - `Current Min Payment`
   - `Source Scan File`
   - `Source Scan Path`
   - `Status`
   - `Confidence`
   - `Last Updated`

If the new statement date is the same:

1. Do not overwrite the row unless the new scan fills missing details or improves confidence.
2. Add a note that a duplicate or same-period scan was found.

If the new statement date is older:

1. Do not update the account row.
2. Add a note only when it is useful for traceability, or ignore it if already represented.

If the statement date cannot be confidently read:

1. Do not update the account row.
2. Mark the item for review.

Never infer or update `Username` or `Password` from scanned statements. Leave those fields blank unless Boss explicitly provides them.

### Insurance Register Rules

Insurance register tracking should use one row per property and policy, not one row per scanned document.

Insurance chronology should use one history entry per scanned insurance document or status event. The current-status fields should be derived from the newest reliable chronology entry for that property/policy.

Match an existing insurance row using:

`Property / Project + Property Address + Insurance Company + Policy #`

For insurance-company documents, update or hand off these fields when confidently available:

- Insurance Company
- Policy #
- Property Address
- Annual Payment
- Escrowed In Mortgage Payment
- Paid Directly To Insurance Company
- Payment Frequency
- Source Scan File
- Source Scan Path
- Status
- Confidence
- Last Updated

For mortgage-company insurance documents, update or hand off these fields when confidently available:

- Mortgage Company
- Property Address
- Coverage Accepted / Rejected
- Status Change Date
- Insurance Company
- Policy #
- Source Scan File
- Source Scan Path
- Status
- Confidence
- Last Updated

If the insurance register worksheet does not exist yet, do not modify another worksheet as a substitute. Capture the insurance details in the scan log and final summary, and flag that register update is pending.

### Register Alert Rules

After updating or reviewing a register row, check whether it meets any alert rule. If a row meets an alert rule, email Jenny at `Jenny@BuyYourHomeLLC.com` and copy Wes. If the email is sent by OfficeAssist, send it from the OfficeAssist email account and state that it is sent on Wes's behalf.

Current alert rules:

1. `Current Min Payment` is greater than `Last Min Payment`.
2. `Current Min Payment` is more than `$10.00` less than `Last Min Payment`.

The alert email should identify the sheet, property/project, lender/vendor, statement date, last minimum payment, current minimum payment, and source statement file when available. Do not send duplicate alerts for the same row and same statement date unless a later update changes the alert details.

Priority register columns should stay at the left in this order:

1. `Property / Project`
2. `Lender / Vendor`
3. `Statement / Invoice Date`
4. `Due Date`
5. `Amount Due`
6. `Current Balance`
7. `Last Min Payment`
8. `Current Min Payment`
9. `Download Flag`

## Safety Rules

- Never delete or overwrite the original scan.
- Never overwrite an existing routed file without creating a unique name or asking for confirmation.
- Do not move money, pay invoices, submit forms, or contact vendors.
- Do not file external/customer/lead documents unless the destination is clear and approved.
- If a document includes security codes, passwords, or verification codes, flag it for review and do not share the code.

## Automation Design

The automation should call this skill rather than contain document-processing logic itself.

Automation responsibilities:

- Check the Office Admin scanned-files location through the SharePoint/Teams connector when available, and check `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files` as the local scanner drop-zone and fallback path on a schedule.
- Pass new PDFs, JPGs, and JPEGs to the `doc-scan` skill.
- Save output PDFs to destination folders.
- Post only meaningful summaries: files created, uncertain matches, errors, or decisions needed.
- Stay quiet when there are no new scans.

Suggested schedule:

- Every 15-30 minutes while active scanning is expected.
- Hourly or daily if the scan folder is used casually.

## Skill Resources To Build

Recommended skill structure:

```text
doc-scan
├─ SKILL.md
├─ references
│  ├─ folder-map.md
│  ├─ routing-rules.md
│  └─ naming-rules.md
└─ scripts
   ├─ inspect_pdf.py
   ├─ ocr_pdf.py
   ├─ split_pdf.py
   └─ route_document.py
```

Scripts should be deterministic and conservative. The model can interpret results and make filing decisions, but scripts should handle PDF/OCR/splitting mechanics.

## Open Questions

- Should the automation move completed original scans to an archive folder after successful processing, or leave them in place?
- What should the review folder be named?
- Should output files be grouped by month inside each account folder, or placed directly in the account folder?
- Should routing include 2025/2027 folders later, or only 2026 for now?
