# Doc Scan SOP

Project room: [[Project Rooms/Doc Scan/README|Doc Scan Project Room]]

## Purpose

This SOP explains how the `doc-scan` skill and `document-scanning` automation process scanned Office Admin documents, what a human needs to do to support the process, and what to do if the automation does not work.

## Scope

This process applies to scanned financial/admin PDFs and image scans (`.jpg` / `.jpeg`) placed in:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

Supported document types include:

- Mortgage statements
- Bank statements
- Credit card statements
- Loan and line-of-credit statements
- Property insurance documents from insurance companies or mortgage companies
- Property closing documents
- Signed operating agreements
- Invoices
- Receipts
- CPA and tax forms
- Donation records
- Medical statements

## Key Locations

Scan intake folder:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

Primary Teams/SharePoint discovery path:

- Use the SharePoint/Teams connector first to locate scans and destination folders when connector access is available.
- Use the local synced folders as the scanner drop-zone, PDF processing workspace, archive/log location, and fallback path when the connector is unavailable or incomplete.

Scan logs:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Logs`

Archived originals:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Archived`

Destination root:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`

Property/project destination root:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

Installed skill:

`C:\Users\wesbr\.codex\skills\doc-scan`

Skill spec:

`C:\Codex\Wiki Files\Document Scanning Skill Spec.md`

Folder map:

`C:\Codex\Wiki Files\Document Scanning Folder Map.md`

## Automation Schedule

The `Doc Scan` automation runs every 30 minutes from 10:00 AM through 4:30 PM Eastern:

- 10:00 AM
- 10:30 AM
- 11:00 AM
- 11:30 AM
- 12:00 PM
- 12:30 PM
- 1:00 PM
- 1:30 PM
- 2:00 PM
- 2:30 PM
- 3:00 PM
- 3:30 PM
- 4:00 PM
- 4:30 PM

It stays quiet when there are no new scans. It reports only when it processes files, finds a problem, needs review, or needs a human decision.

## What The Skill Does

1. Checks Teams/SharePoint with the connector for new PDF, JPG, and JPEG scan files in the Office Admin scanned-files location when connector access is available.
2. Checks the local synced scan intake folder as the scanner drop-zone, processing workspace, and fallback:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

3. Ignores files already inside `Logs` or `Archived`.
4. Opens each new scan and checks:
   - Page count
   - Whether text is embedded
   - Whether the scan is image-only
5. If the PDF has no embedded text, or if the source is a JPG/JPEG image, treats it as a scanned image document and uses visual/OCR-style parsing.
6. Reviews each page for:
   - Company, lender, bank, or vendor name
   - Account number or account suffix
   - Statement date, billing date, or invoice date
   - Page numbering
   - Document headers and payment coupons
7. Determines where each separate document starts and ends.
8. Splits one combined PDF scan into separate PDF files when the document boundaries are clear. For JPG/JPEG scans, convert or file the document as a single PDF output unless the file is routed to review.
9. Names each output file using:

   `YY-MM-DD - Company.pdf`

   Example:

   `26-05-05 - First Citizens Bank VISA.pdf`

10. Uses the SharePoint/Teams connector first to confirm destination folders and matching source documents when connector access is available.
11. Saves each split or converted output PDF into the correct mapped folder under the Office Admin 2026 folder or the matching property/project/entity folder, depending on the document type:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

12. Creates or updates a plain text log file in:

    `Scanned Files\Logs`

13. Archives the original source scan in:

    `Scanned Files\Archived`

14. If the scan cannot be confidently parsed or routed, it does not guess. It flags the document for review.

## Human Responsibilities Before Scanning

1. Sort pages in the order they should be processed.
2. Keep all pages for the same statement together.
3. Avoid mixing unrelated documents unless the scan is intended to be split.
4. Make sure pages are not upside down if practical.
5. Make sure account numbers, dates, and company names are visible.
6. Scan to PDF format when practical. JPG/JPEG image scans are also accepted when the scanner or phone workflow produces an image file.
7. Do not rename the scanned file unless there is a specific reason. The scanner's default file name is enough because the automation will read, split or convert, rename, and file the documents.
8. Place the PDF, JPG, or JPEG in:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

9. Do not place new scans directly into `Logs` or `Archived`.

## Human Responsibilities After Automation Runs

1. Review any notification from the automation.
2. If files were processed, spot-check the output files when needed.
3. Check the log file in `Scanned Files\Logs` for:
   - Source scan name
   - Page ranges
   - Destination folders
   - Output file names
   - Confidence notes
   - Review items
4. If the automation flags a file for review, inspect the scan manually and decide where it belongs.

## Filing Rules

The skill uses the mapped folder structure as the routing authority.

Common routing examples:

- First Citizens credit card statement -> `2026\Credit Cards\...`
- Mortgage statement -> matching property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, then `Owning`, then the folder named for the mortgage company
- Property insurance document -> matching property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, then that property's `Insurance` folder
- Property closing document -> matching property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, then the same subfolder that already contains the unsigned version
- Signed operating agreement -> the same entity folder that already contains the unsigned or approved-final operating agreement
- Project/property invoice or receipt with a specific property address -> matching property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, then `Owning`
- Bank statement -> `2026\Bank Statement\...`
- Lowe's Pro statement -> `2026\Credit Cards\Lowe's Pro-SYH-6140`
- Quest invoice -> `2026\Quest\Invoices\...`
- General receipt not tied to a specific property/project -> `2026\Receipts` or a specific receipt subfolder if mapped

The skill prefers exact matches using:

- Last 4 account digits
- Institution/vendor name
- Business/entity label such as BYH, SYH, Heritage Mgmt, 401K, or personal/home

If the match is not clear, the skill should route to review instead of guessing.

## Project Invoice And Receipt Filing

Project/property invoices and receipts are property documents when the scan identifies a specific property address, project folder, or property number. Do not file those documents in the generic Office Admin invoice/receipt folders.

For every scanned project invoice or receipt:

1. Identify the related property using the property address, numeric street address, project name, entity label, or other reliable project details on the document.
2. Match the property to a project folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

3. Open the matched property folder and drill into:

   `Owning`

4. Save the filed PDF directly in the `Owning` folder unless a more specific approved subfolder already exists for that document type.
5. If the property folder cannot be identified confidently, route the item to review and note the uncertainty in the log.

### Invoice Entry Handoff

When Doc Scan processes a project-specific invoice or receipt, it should continue its existing scan workflow:

1. Inspect/OCR the scan.
2. Identify the document as an invoice or receipt.
3. Match it to the correct project/property when confidence is high.
4. Save or copy the invoice file into the correct Teams project folder.
5. Log the scan routing result.
6. Do not edit the project-management spreadsheet directly.
7. Create a structured invoice packet and hand it off to Invoice Entry.

Default handoff trigger: send a direct follow-up message to the dedicated Invoice Entry chat with the packet path and packet summary. The Invoice Entry heartbeat is a backup monitor that periodically checks the packet folder for handoffs that were not delivered by direct message.

Invoice Entry project room:

`C:\Codex\Wiki Files\Project Rooms\Invoice Entry`

Dedicated chat/thread:

`019f3d56-b310-75c0-b084-616bfc1e9f59`

Doc Scan owns scan inspection/OCR, document splitting, invoice/receipt identification, project/property folder routing, saving or copying the invoice file, scan log entries, and invoice packet creation.

Invoice Entry owns selecting the exact live project-management workbook, checking workbook records for duplicates, deciding final spreadsheet row placement, inserting the invoice record, preserving workbook formulas/formatting/selectors, validating totals and downstream links, and uploading the verified workbook back to Teams/SharePoint.

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

## Mortgage Statement Filing

Mortgage statements are routed by property, not to the generic Office Admin loan folders.

For every scanned mortgage statement:

1. Confirm the scanned document is a mortgage statement.
2. Split each individual mortgage statement into its own PDF.
3. Identify the related property using the property address, numeric street address, borrower/entity, loan number or suffix, mortgage company, servicer, or other reliable details on the statement.
4. Match the property to a project folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

5. Open the matched property folder and drill into:

   `Owning`

6. In `Owning`, find the folder named after the mortgage company.
7. Save the split mortgage statement PDF in that mortgage-company folder.

Use a credit-card-style naming pattern, with the file name starting with the full statement date in `YY-MM-DD` format:

`YY-MM-DD - Mortgage Company - AccountSuffix - Mortgage Statement.pdf`

Example:

`26-05-03 - Shellpoint - 1234 - Mortgage Statement.pdf`

If the property folder or mortgage-company folder cannot be identified confidently, do not guess and do not create a new folder automatically. Route the item to review and note the uncertainty in the log.

## Property Closing Document Filing

Property closing documents are property documents when the scan includes signed closing-package documents for a Buy Your Home property.

These documents may arrive as one combined scan. For every scanned property closing package:

1. Identify each separate closing document and split the combined scan into one PDF per document when boundaries are clear.
2. Identify the related property using the property address, buyer/seller names, entity name, project folder name, closing date, document title, or other reliable closing-package details.
3. Match the property to a project folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

4. Search that property's Teams-synced folder tree for the existing unsigned version of each document.
5. File the signed document in the same folder as the matching unsigned version.
6. Use the unsigned document's file name as the base name and add ` - Signed` before `.pdf`.

Example:

- Unsigned source: `320 Rose Pl - Contract for Deed Agreement - DRAFT.pdf`
- Signed filing name: `320 Rose Pl - Contract for Deed Agreement - DRAFT - Signed.pdf`

If the unsigned version is a Word document, keep the same base name and file the signed scan as a PDF:

- Unsigned source: `320 Rose Pl - Promissory Note for Contract for Deed - DRAFT.docx`
- Signed filing name: `320 Rose Pl - Promissory Note for Contract for Deed - DRAFT - Signed.pdf`

If a signed file with the target name already exists, do not overwrite it. Add ` (2)`, ` (3)`, or the next available suffix and note the duplicate-looking condition in the log.

If the property, document boundary, document title, or matching unsigned version cannot be identified confidently, route the page range or source scan to the general review folder and explain what was unclear in the log. Do not create a new property folder or choose an approximate unsigned document by guesswork.

## Signed Operating Agreement Filing

Signed operating agreements are entity governance documents when a scan contains newly signed operating agreements, amendments, consents, membership schedules, or related signature pages for a Buy Your Home-related entity.

These documents may arrive as one combined scan. For every scanned signed operating-agreement package:

1. Identify each separate entity document and split the combined scan into one PDF per document when boundaries are clear.
2. Identify the related entity using the entity name, EIN when shown, agreement title, effective date, member/manager names, signature block, or other reliable document details.
3. Search the relevant Teams-synced entity folder and the Operating Agreements project-room outputs for the existing unsigned, approved-final, or controlling source version of the same document.
4. File the signed PDF in the same folder as the matched unsigned or approved-final version.
5. Use the matched document's file name as the base name and add ` - Signed` before `.pdf`.

Example:

- Unsigned source: `26-06-18 Sell Your Home LLC Operating Agreement - Approved Final.docx`
- Signed filing name: `26-06-18 Sell Your Home LLC Operating Agreement - Approved Final - Signed.pdf`

If a signed file with the target name already exists, do not overwrite it. Add ` (2)`, ` (3)`, or the next available suffix and note the duplicate-looking condition in the log and report.

If the entity, document boundary, document title, or matching unsigned/approved-final version cannot be identified confidently, route the page range or source scan to the general review folder and explain what was unclear in the log. Do not create a new entity folder, move prior operating agreements into archive, or choose an approximate unsigned document by guesswork.

When a scan run files signed operating agreements, generate a friendly PDF status report showing one row per detected entity document, including entity, document title, page range, matched unsigned/approved-final source, filed signed PDF path, filing status, and review flags. Email the report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`. In the email body, note anything that needs attention, including unmatched entities, missing source versions, duplicate-looking signed files, unclear signature status, missing pages, or any item routed to review.

## Property Insurance Document Filing

Property insurance documents are property documents when they come from an insurance company or from a mortgage company about property insurance coverage.

Use the current property/mortgage reference workbook when matching an insurance document to a property:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Credit Cards Sheet.xlsx`

The `Mortgages` worksheet lists the current properties and mortgage context.

For every scanned property insurance document:

1. Decide whether the document came from an insurance company or a mortgage company.
2. Identify the related property using the property address, borrower/entity, mortgage company, loan number or suffix, insurance company, policy number, or other reliable document details.
3. Match the property to a project folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

4. Open the matched property folder and drill into:

   `Insurance`

5. Save the filed PDF in the property's `Insurance` folder.
6. If the matching property folder is clear but the `Insurance` folder does not exist, route the document to review and note that the destination folder is missing. Do not create the folder automatically unless Boss gives a later rule or specific approval.
7. Do not choose between possible property matches by guesswork.
8. If the property, policy, coverage status, or payment responsibility cannot be identified confidently, route the document to review and note the uncertainty in the log.

For insurance-company documents, capture these fields in the log and any later register/update handoff:

- Insurance company name
- Policy number
- Property address
- Annual payment
- Whether the premium is escrowed in the mortgage payment
- Whether Buy Your Home pays the insurance company directly
- Whether payment is monthly or annual

For mortgage-company insurance documents, capture these fields in the log and any later register/update handoff:

- Mortgage company name
- Property address
- Whether the mortgage company accepted or rejected the coverage
- Date of status change
- Policy number or insurance company name when shown

Track insurance documents chronologically for each property and policy so the current status is clear. The log or register handoff should preserve each insurance document's date, source company, document type or status event, accepted/rejected coverage status when shown, escrow/direct-pay status when shown, payment frequency and amount when shown, filed document path, and uncertainty notes.

When a newer insurance document changes the status for a property or policy, keep the older document history and update the current status from the newest reliable document. Do not overwrite the historical trail with only the latest status.

### Insurance Cancellation Notices

When the scan includes an insurance cancellation, non-renewal, lapse, lender-placed, second notice, or final notice:

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

When Boss asks for a mortgage statement report, or when a scan run files mortgage statements and a report is appropriate, use one row per property/loan and attach a friendly PDF report.

Include columns for property, mortgage company or servicer, loan number or suffix, statement date, due date, payment due, past-due/delinquency/late-fee/foreclosure-warning flag, escrow/tax/insurance notice flag, latest filed statement path, and review flags.

Email the report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`. In the email body, note mortgage items that need attention, including late notices, payment changes, escrow shortages, insurance requests, lender-placed insurance warnings, foreclosure language, missing property matches, missing mortgage-company folders, or any statement routed to review.

### Credit Card Statement Reports

When Boss asks for a credit card statement report, or when a scan run files credit card statements and a report is appropriate, use one row per card/account and attach a friendly PDF report.

Include columns for card issuer/account label, account last 4 or suffix, business/entity or property/project when shown, statement date, due date, statement balance, minimum payment, prior minimum payment comparison when available, latest filed statement path, and review flags.

Email the report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`. In the email body, note credit card items that need attention, including minimum-payment increases or notable decreases, late fees, unusual balance jumps, missing account matches, duplicate-looking statements, or any statement routed to review.

### Lowe's Statement Allocation Mode

When Credit Card Statement Mode identifies and files a Lowe's statement, preserve all normal Lowe's statement handling first: inspect/OCR, split if needed, file the statement in the approved Lowe's credit-card statement folder, log the routing, include it in the credit-card statement report, and flag normal statement review items.

After normal statement filing, run Lowe's Statement Allocation Mode as an additive extraction workflow. Doc Scan extracts item-level source data for Invoice Entry. Doc Scan must not edit any project-management workbook and must not decide final spreadsheet insertion.

Do not treat the entire Lowe's statement as one invoice for one project. A single Lowe's statement may contain charges, returns, credits, fees, or interest for multiple projects and non-project/Home items.

Do not treat each statement transaction or reference number as one Invoice Entry row when the statement detail shows multiple purchased or returned items. A single Lowe's transaction/reference may produce multiple packet rows. Each packet row should represent one distinct purchasable item, returned item, delivery/shipping charge, fee, or credit component when the detail is visible.

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

If the transaction total is visible but item-level amounts are not separable, still split visible items into separate packet rows when useful, but mark amount fields as `Needs Review - Amount Split` and explain that the transaction total must be allocated before Invoice Entry can insert final rows.

Delivery/shipping should be its own row when it is separately shown or materially tied to a transaction. If delivery cannot be assigned to one item confidently, mark it `Needs Review - Allocation`.

Use the PO value as a strong project/property clue when present, but do not guess if the PO is missing, ambiguous, conflicts with other line details, or appears to belong to another project. Evaluate project/property routing independently for each line item.

For non-project/Home items, mark the line as non-project/Home and do not recommend a project-management workbook.

For unclear project items, mark the line `Needs Review - Project` and do not recommend a project-management workbook.

For clear project but unclear vendor-tab items, recommend the project workbook but set the worksheet/vendor tab to blank or `Needs Review`, with a short reason.

For mixed-tab credits or returns, mark the line `Needs Review - Mixed Tab` unless the statement detail clearly identifies the original item and category.

For fees, interest, finance charges, late fees, or payments, mark the line as accounting-review unless Wes has approved a specific project-spreadsheet handling rule. Do not recommend a vendor tab by default.

The packet handed to Invoice Entry should be item-row based. Each item row should carry the shared statement and transaction header data plus its own item data and routing confidence.

Invoice Entry owns:

- resolving the exact live project-management workbook,
- deciding whether a line belongs in that workbook,
- checking workbook records for duplicate statement lines,
- deciding final worksheet/vendor-tab placement,
- inserting approved line records,
- routing uncertain lines to the correct Review or exception process,
- validating totals and workbook links,
- uploading the verified workbook back to Teams/SharePoint when authorized.

Default handoff trigger: send a direct follow-up message to the dedicated Invoice Entry chat with the packet path and a short summary of line counts by status, including high-confidence project lines, unclear project lines, non-project/Home lines, mixed-tab lines, and accounting-review lines.

### Invoice And Receipt Reports

When Boss asks for an invoice/receipt report, or when a scan run files invoices or receipts and a report is appropriate, use one row per invoice or receipt and attach a friendly PDF report.

Include columns for vendor/payee, property/project or general category, invoice or receipt date, due date when shown, amount, invoice number or receipt reference when shown, filed location, review/payment status, and review flags.

Email the report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`. In the email body, note invoice or receipt items that need attention, including invoices due soon, past-due notices, unknown vendors, unclear property matches, duplicate-looking invoices, missing amounts or dates, security-code/scam concerns, or any item routed to invoice review. Do not pay invoices, submit forms, move money, or contact vendors.

### SharePoint / Teams Connector Default

Use the SharePoint/Teams connector as the default discovery path for scanned files and destination-folder matching when connector access is available.

The local synced folders remain the processing path for files dropped by the scanner and for PDF splitting, visual parsing, report generation, logging, and archiving. If the connector finds a scan that is not visible locally, download a working copy for processing, preserve the original SharePoint source file, log the SharePoint URL, and do not move or delete the source scan.

Use local synced folders as fallback when the connector is unavailable, lacks the needed site/library/folder, is stale, or cannot perform the required read/write action safely.

## Logging Requirements

Every processed source scan should have one `.log.txt` file in:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Logs`

The log should include:

- Source scan path
- Page count
- Whether the source was a PDF or JPG/JPEG image, and whether a PDF was image-only
- Planned and completed split ranges
- Document identity for each output file
- Date used for naming
- Destination folder
- Output file path
- Confidence notes
- Review items
- Archive path for the original scan

## If The Automation Fails

Use this checklist.

1. Confirm the scan is a PDF, JPG, or JPEG.
2. Use the SharePoint/Teams connector to confirm whether the scan exists in the Office Admin scanned-files location.
3. Confirm whether the scan is visible in the local synced folder:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

4. Confirm it is not already in:

   `Scanned Files\Archived`

5. Check whether a log was created in:

   `Scanned Files\Logs`

6. Check whether output files were created in the expected 2026 destination folder.
7. If there is no log and no output, ask Codex:

   `Use the doc-scan skill to process the newest scan.`

8. If the file was partially processed, compare:
   - Source scan pages
   - Log file page ranges
   - Output PDF page counts
9. If a destination was wrong, move the output file manually to the correct folder and update the log.
10. If a file was not split correctly, ask Codex to reprocess the archived original scan and specify the correct page ranges.
11. If the automation itself is not running, ask Codex:

    `Show me the Doc Scan automation.`

## Manual Processing If Automation Is Down

1. Open the scan file from `Scanned Files`.
2. Identify each separate document by company, account number, statement date, and page number.
3. Write down the page ranges.
4. Use the naming convention:

   `YY-MM-DD - Company.pdf`

5. Save each split file into the correct mapped folder.
6. Create a log file in `Scanned Files\Logs`.
7. Move the original scan to `Scanned Files\Archived`.
8. If any match is uncertain, move or copy the uncertain document to a review location and note the reason in the log.

## Safety Rules

- Do not delete source scans.
- Do not overwrite existing filed PDFs.
- Do not pay invoices.
- Do not submit forms.
- Do not contact vendors.
- Do not move money.
- Do not share verification codes, passwords, or security codes found in scans.
- If a scan contains a security code or suspicious verification message, flag it for review.

## Example Successful Processing

Source scan:

`Receipt_2026-05-24_134923.pdf`

Detected documents:

1. First Citizens Bank VISA, account ending 4696, statement date 2026-05-05, pages 1-1
2. First Citizens Bank VISA, SYH account ending 4882, statement date 2026-05-05, pages 2-3
3. Lowe's Pro, account ending 6140, statement date 2026-05-02, pages 4-5

Created files:

- `26-05-05 - First Citizens Bank VISA.pdf`
- `26-05-05 - First Citizens Bank VISA.pdf`
- `26-05-02 - Lowe's Pro.pdf`

Original source scan was archived after successful processing.
