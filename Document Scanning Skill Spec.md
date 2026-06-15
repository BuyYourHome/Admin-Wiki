# Document Scanning Skill Spec

Project room: [[Project Rooms/Document Scan/README|Document Scan Project Room]]

Working name: `document-scanning`

Purpose: process scanned financial/admin PDFs and image scans (`.jpg` / `.jpeg`), split combined scans into separate documents when applicable, name them consistently, and route them into the correct Office Admin or property/project folder.

Installed skill location:

`C:\Users\wesbr\.codex\skills\document-scanning`

Primary folder map:

- `Document Scanning Folder Map.md`
- Root document destination: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`
- Property/project destination root: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`
- Scan intake folder: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

## Skill Trigger

Use this skill when asked to process scanned mortgage statements, credit card statements, bank statements, invoices, receipts, tax documents, CPA forms, medical bills, donation records, or similar Office Admin documents.

Example user requests:

- Process this scan.
- Split this mortgage statement scan by account.
- File the scanned statements in the 2026 Office Admin folders.
- Review the scan intake folder and route anything new.
- Parse this PDF or image scan into separate account files.

## Core Responsibilities

1. Read one or more scanned PDFs, JPGs, or JPEGs from an intake folder or explicit file path.
2. OCR pages when text is not already embedded, and visually/OCR-parse JPG/JPEG image scans.
3. Identify document type, institution/vendor, account number suffix, statement date, invoice date, and page boundaries.
4. Split multi-document PDF scans into one PDF per account/document when boundaries are clear.
5. Convert JPG/JPEG scans to a PDF output when filing, unless the item is routed to review.
6. Name each output PDF using a consistent naming convention.
7. Route each output PDF to the best matching folder under the 2026 Office Admin folder map or the matching property/project folder.
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
6. Each time the report is regenerated, email the friendly report PDF to both `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`. Summarize the critical matches and unresolved review items in the email body.

### SharePoint / Teams Fallback

If Boss identifies a scan that is present in Teams/SharePoint but it is not visible in the local synced folder, use the SharePoint connector to locate and download a working copy for processing. Preserve the original SharePoint source file, log the SharePoint URL, and do not move or delete the source scan.

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

- Watch `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files` on a schedule.
- Pass new PDFs, JPGs, and JPEGs to the `document-scanning` skill.
- Save output PDFs to destination folders.
- Post only meaningful summaries: files created, uncertain matches, errors, or decisions needed.
- Stay quiet when there are no new scans.

Suggested schedule:

- Every 15-30 minutes while active scanning is expected.
- Hourly or daily if the scan folder is used casually.

## Skill Resources To Build

Recommended skill structure:

```text
document-scanning
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
