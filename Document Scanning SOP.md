# Document Scanning SOP

Project room: [[Project Rooms/Document Scan/README|Document Scan Project Room]]

## Purpose

This SOP explains how the `document-scanning` skill and automation process scanned Office Admin documents, what a human needs to do to support the process, and what to do if the automation does not work.

## Scope

This process applies to scanned financial/admin PDFs and image scans (`.jpg` / `.jpeg`) placed in:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

Supported document types include:

- Mortgage statements
- Bank statements
- Credit card statements
- Loan and line-of-credit statements
- Property insurance documents from insurance companies or mortgage companies
- Invoices
- Receipts
- CPA and tax forms
- Donation records
- Medical statements

## Key Locations

Scan intake folder:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

Scan logs:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Logs`

Archived originals:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Archived`

Destination root:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`

Property/project destination root:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

Installed skill:

`C:\Users\wesbr\.codex\skills\document-scanning`

Skill spec:

`C:\Codex\Wiki Files\Document Scanning Skill Spec.md`

Folder map:

`C:\Codex\Wiki Files\Document Scanning Folder Map.md`

## Automation Schedule

The `Document scanning` automation runs every 2 hours between 10:00 AM and 5:00 PM:

- 10:00 AM
- 12:00 PM
- 2:00 PM
- 4:00 PM

It stays quiet when there are no new scans. It reports only when it processes files, finds a problem, needs review, or needs a human decision.

## What The Skill Does

1. Checks the scan intake folder for new PDF, JPG, and JPEG files.
2. Ignores files already inside `Logs` or `Archived`.
3. Opens each new scan and checks:
   - Page count
   - Whether text is embedded
   - Whether the scan is image-only
4. If the PDF has no embedded text, or if the source is a JPG/JPEG image, treats it as a scanned image document and uses visual/OCR-style parsing.
5. Reviews each page for:
   - Company, lender, bank, or vendor name
   - Account number or account suffix
   - Statement date, billing date, or invoice date
   - Page numbering
   - Document headers and payment coupons
6. Determines where each separate document starts and ends.
7. Splits one combined PDF scan into separate PDF files when the document boundaries are clear. For JPG/JPEG scans, convert or file the document as a single PDF output unless the file is routed to review.
8. Names each output file using:

   `YY-MM-DD - Company.pdf`

   Example:

   `26-05-05 - First Citizens Bank VISA.pdf`

9. Saves each split or converted output PDF into the correct mapped folder under the Office Admin 2026 folder or the matching property/project folder, depending on the document type:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\2026`

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`

10. Creates or updates a plain text log file in:

    `Scanned Files\Logs`

11. Archives the original source scan in:

    `Scanned Files\Archived`

12. If the scan cannot be confidently parsed or routed, it does not guess. It flags the document for review.

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
- Property insurance document -> matching property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, then `Owning`; use an existing insurance-company or mortgage-company subfolder only when the match is clear
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

   `Owning`

5. Save the filed PDF directly in `Owning` unless a clearly matching insurance-company or mortgage-company subfolder already exists.
6. Do not create a new folder automatically and do not choose between possible property matches by guesswork.
7. If the property, policy, coverage status, or payment responsibility cannot be identified confidently, route the document to review and note the uncertainty in the log.

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
2. Confirm the scan is in:

   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files`

3. Confirm it is not already in:

   `Scanned Files\Archived`

4. Check whether a log was created in:

   `Scanned Files\Logs`

5. Check whether output files were created in the expected 2026 destination folder.
6. If there is no log and no output, ask Codex:

   `Use the document-scanning skill to process the newest scan.`

7. If the file was partially processed, compare:
   - Source scan pages
   - Log file page ranges
   - Output PDF page counts
8. If a destination was wrong, move the output file manually to the correct folder and update the log.
9. If a file was not split correctly, ask Codex to reprocess the archived original scan and specify the correct page ranges.
10. If the automation itself is not running, ask Codex:

    `Show me the Document scanning automation.`

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
