# Document Scanning Skill Spec

Working name: `document-scanning`

Purpose: process scanned financial/admin PDFs, split combined scans into separate documents, name them consistently, and route them into the correct Office Admin folder.

Installed skill location:

`C:\Users\wesbr\.codex\skills\document-scanning`

Primary folder map:

- `Document Scanning Folder Map.md`
- Root document destination: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`
- Scan intake folder: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

## Skill Trigger

Use this skill when asked to process scanned mortgage statements, credit card statements, bank statements, invoices, receipts, tax documents, CPA forms, medical bills, donation records, or similar Office Admin documents.

Example user requests:

- Process this scan.
- Split this mortgage statement scan by account.
- File the scanned statements in the 2026 Office Admin folders.
- Review the scan intake folder and route anything new.
- Parse this PDF into separate account files.

## Core Responsibilities

1. Read one or more scanned PDFs from an intake folder or explicit file path.
2. OCR pages when text is not already embedded.
3. Identify document type, institution/vendor, account number suffix, statement date, invoice date, and page boundaries.
4. Split multi-document scans into one PDF per account/document.
5. Name each output PDF using a consistent naming convention.
6. Route each output PDF to the best matching folder under the 2026 Office Admin folder map.
7. Avoid destructive changes. Never delete the original scan automatically.
8. Flag uncertain classifications for human review instead of guessing.

## Document Types

Initial supported types:

- Mortgage statements
- Bank statements
- Credit card statements
- Line of credit statements
- Loan statements
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

## Mortgage Statement Routing

Mortgage statements are property documents. Do not file them in the generic Office Admin `2026\Loans` folder unless Boss explicitly instructs that for a specific document.

For each scanned PDF:

1. Determine whether the scan contains mortgage statements.
2. If it does, identify each individual mortgage statement and split each statement into its own PDF.
3. Match each statement to the correct project/property folder under:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

4. Use reliable document details such as property address, numeric street address, borrower/entity, loan number or suffix, mortgage company, servicer, or other statement details.
5. Open the matched property folder and drill down to its `Owning` folder.
6. Inside `Owning`, find the folder named for the mortgage company shown on the statement.
7. Save the split statement PDF in that mortgage-company folder.

If the property or mortgage-company folder cannot be identified confidently, do not guess and do not create a new folder automatically. Route the item to review and document what was unclear in the log.

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

- Split/routed PDF files.
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
- Pass new PDFs to the `document-scanning` skill.
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
