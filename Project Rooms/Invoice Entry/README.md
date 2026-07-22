# Invoice Entry

## Purpose

This project room owns the operational workflow for inserting invoice and approved statement-line records into Buy Your Home project-management spreadsheets.

The workflow usually starts after Doc Scan has completed scanned invoice, receipt, or Statement intake and prepared a structured packet. It can also start when Email Monitor or OfficeAssist routes a contractor/vendor invoice email into Create Vendor Invoice. This room receives or creates the packet, decides where the record or statement line belongs in the project-management spreadsheet, checks for duplicates, inserts approved records into the correct worksheet area, validates totals, and reports uncertainty for Wes review.

## Scope

Included:

- Receive structured invoice, receipt, and Statement packets from Doc Scan as the scanned-document intake source.
- Receive routed contractor/vendor invoice emails from Email Monitor or OfficeAssist under Create Vendor Invoice.
- Other intake sources are out of scope unless Wes separately approves and documents them.
- Consume Lowes Statement packets extracted by Doc Scan; Doc Scan owns extraction, and Invoice Entry owns allocation and later spreadsheet insertion when approved.
- Resolve the correct active project-management workbook through Teams/SharePoint.
- Route invoice records to the correct worksheet and expense area.
- For Vendor Tabs, insert records only into the yellow actual-invoice section of the correct vendor tab.
- Preserve template-estimate rows, formulas, checkboxes/selectors, named ranges, tables, formatting, and workbook structure.
- Validate affected totals and downstream links such as `Gnatt Chart`.
- Keep rollback copies and record insertion decisions.

Excluded unless Wes explicitly expands scope:

- Scan inspection/OCR, document splitting, invoice/receipt identification, scan log entries, or saving/copying scanned invoice files into Teams/project folders.
- Designing or rolling out project-management spreadsheet templates.
- Replacing worksheet structures across all project workbooks.
- Paying invoices, approving invoices, contacting vendors, or changing accounting systems.

## Responsibility Boundary

- `Doc Scan`: scan inspection/OCR, document splitting, invoice/receipt/statement identification, project/property folder routing when applicable, saving/copying filed PDFs into Teams/project folders, scan log entries, Statement extraction, and structured packet creation.
- `Email Monitor` / `OfficeAssist`: mailbox monitoring, routed vendor-invoice email preservation, direct handoff messages, and source traceability for email-origin invoice intake.
- `Invoice Entry`: structured packet receipt, structured packet creation from routed free-text vendor-invoice emails, exact live project-management workbook resolution, workbook duplicate checks, statement-line allocation, final row placement, invoice or approved statement-line record insertion, Create Vendor Invoice verification requests for generated free-text invoices when vendor identity and email address are clear, workbook formula/format/selector/table/link preservation, totals and downstream-link validation, authorized upload back to Teams/SharePoint, and insertion logging.
- `Template to Project`: worksheet design, worksheet-mode rules, template changes, and rollout across project workbooks.

## Current Status

- Status: active direct-message handoff; backup heartbeat available. Invoice insertion procedure still has open design decisions.
- First supported worksheet group: Vendor Tabs.
- Statement status: Doc Scan owns Lowes Statement extraction and will send extracted statement data for this room to consume. Invoice Entry holds statement lines until allocation and insertion rules are tested and approved.
- First workbook for proving the workflow: Outrigger, after Wes approves the Vendor Tabs design.
- Primary trigger: direct follow-up message to the dedicated Invoice Entry chat with the packet path and summary.
- Backup automation: project-room heartbeat at noon and 4:00 PM Eastern. The heartbeat inspects this project room for new or changed structured invoice/receipt packets only; it does not scan inboxes, inspect raw scan folders, copy files into Teams, or edit a live workbook unless Wes has clearly authorized the insertion or an approved automation rule exists for that exact insertion type.
- Automation id: `invoice-entry-to-projects-backup-heartbeat`.
- Dedicated chat/thread id: `019f3d56-b310-75c0-b084-616bfc1e9f59`.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`

## Required Invoice Packet

Each handoff should include:

- Project/property
- Vendor name
- Invoice date
- Invoice number, if available
- Invoice amount
- Work category
- Saved invoice file path in Teams/project folder
- Recommended project workbook
- Recommended worksheet
- Confidence/status
- Notes or uncertainty

## Create Vendor Invoice

Use Create Vendor Invoice when Email Monitor or OfficeAssist routes a contractor/vendor invoice email to Invoice Entry.

Trigger:

- A direct handoff message from Email Monitor or OfficeAssist says to process a routed vendor invoice.
- The routed source is an email saved under `Project Rooms\Invoice Entry\sources\email\`.
- The handoff may include invoice attachment paths, an Outlook message link, attachment-access blockers, vendor clues, project clues, and a short summary.

Invoice Entry responsibilities:

- Read the routed email source and any saved invoice attachments.
- If the routed email has an attached invoice, treat the attachment as the source invoice. Do not create a new invoice and do not send it back to the vendor for verification merely because it arrived by email.
- For attached-invoice emails, identify the vendor, project/property, invoice date, invoice number if available, amount, work category, and source traceability, then continue under the normal Invoice Entry rules.
- For attached-invoice emails, choose the correct active project-management workbook and worksheet, check duplicate risk, move or copy the invoice file to the correct Teams/SharePoint project folder when authorized, insert only when confidence and rules allow, validate the workbook, and record the result.
- If the routed email has no attached invoice and the invoice information exists only as free text, treat the email body as invoice source material, not as a finished invoice.
- For free-text invoice emails, create a formal invoice document from the email body and preserved source details.
- Every generated free-text invoice must have an invoice date and invoice number. If the source does not provide an invoice date, use the date Invoice Entry generates the draft and record that basis. If the source does not provide an invoice number, Invoice Entry must create one using the approved invoice-number pattern and record that it was generated by Invoice Entry.
- Use the polished Create Vendor Invoice PDF template for generated free-text invoices unless Wes requests a different invoice style. Template: `C:\Codex\Wiki Files\skills\invoice-entry\templates\create-vendor-invoice-polished-invoice-template.md`.
- Render and visually inspect the generated invoice PDF before attaching it to a review or vendor-verification email.
- Email the generated formal invoice PDF back to the proper vendor with a request to verify the invoice's accuracy when vendor identity, vendor email address, project/property, and source evidence are clear. This Create Vendor Invoice verification email has standing approval and does not require a separate Wes review step before sending. Copy `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com` on that verification email. Use the Admin wiki email-delivery rules for sender safety and sent-item verification.
- Every project-related Create Vendor Invoice email subject must include the property address. Vendor-verification subjects should also identify the vendor and invoice purpose or service period, such as `908 Pond St - Tim Fleming Pond Hours Invoice - Verification Requested`.
- Do not forward or attach the routed free-text source email to the vendor. Preserve the source email in the project room for traceability, but send the vendor only the polished generated invoice and the verification request.
- Sign Create Vendor Invoice vendor verification emails as `Jean Wright`.
- Treat vendor verification as confirmation that the generated invoice facts are accurate, not approval to pay, approval to file, or approval to insert into a project spreadsheet.
- After the vendor verifies a generated free-text invoice, send the verified invoice package to Wes for approval/payment review with Jenny copied. Include the property address, vendor, invoice date, invoice number, service period if applicable, amount, generated invoice PDF, vendor confirmation evidence, and any unresolved spreadsheet-placement issue.
- Do not copy a verified free-text invoice to Teams/project folders, insert it into a project spreadsheet, mark it posted, or treat it as complete until Wes approves it by email.
- Until Wes approves by email, keep the generated and vendor-verified invoice in the Invoice Entry working files with status `Verified - Awaiting Wes Approval`.
- After Wes approves a verified free-text invoice by email, send an updated-status email to the vendor, Wes, and Jenny unless Wes gives a different recipient list for that invoice. The subject must include the property address and the body must identify the status as approved by Wes, the vendor, invoice date, invoice number, service period if applicable, amount, Teams/project-folder filing path once filed, spreadsheet insertion status, and any insertion blocker.
- Record routing decisions, workbook edits, duplicate checks, validation results, and unresolved questions in this project room.

Safety limits:

- Do not approve invoices.
- Do not pay invoices.
- Do not contact vendors except for the Create Vendor Invoice free-text invoice-accuracy verification request and the post-Wes-approval updated-status email described above.
- Do not send a vendor verification request for an email that already includes an attached invoice.
- Do not send a vendor verification request if the proper vendor email address is unclear, the free-text source evidence is insufficient, the invoice appears misrouted, or the message would imply approval, payment, or acceptance of the invoice.
- Do not guess the project, vendor, amount, invoice number, or destination worksheet when evidence is unclear.
- If the routed email lacks required fields or the attachment cannot be accessed, preserve the source link and report the blocker.
- If duplicate risk is found, stop before insertion and report the risk.
- If the invoice appears to be a statement with multiple project lines, handle it under Statement rules instead of treating it as one vendor invoice.

Completion:

- Preserve the routed email source and any invoice attachments as durable source material.
- For attached-invoice emails, keep enough traceability to link the workbook entry back to the email, attachment, and handoff.
- For free-text invoice emails, preserve the routed email, generated invoice, verification email, copied recipients, and vendor response before final filing or spreadsheet insertion.
- For free-text invoice emails, preserve Wes's approval email before final Teams filing or spreadsheet insertion.
- For free-text invoice emails, record vendor verification, Wes approval, payment-review notice, Teams filing, spreadsheet insertion, and updated-status email as separate logged events.
- Record the vendor verification email result for free-text invoices, including whether it was sent, held, blocked, or needs Wes review.
- Report completed entries, held items, duplicate risks, filing results, and any open review questions.

## Time Card

Use Time Card only when Email Monitor sends a direct handoff message to Invoice Entry for an email with subject or body wording that resembles `Time Card`, `time sheet`, `timesheet`, or similar time-reporting language.

Trigger:

- Email Monitor detects and routes the Time Card or timesheet email.
- The routed source email is preserved under `Project Rooms\Invoice Entry\sources\email\`.
- The handoff includes the routed source path, sender, received time, subject, attachment paths or attachment blockers, and any project/vendor/person clues.
- Invoice Entry must not scan inboxes, search for Time Card emails, or start this workflow from raw mailbox access on its own.

Weekly accumulation:

- Accumulate Time Card emails by worker/vendor and work week.
- Maintain one weekly invoice per worker/vendor for that week.
- When another Time Card email arrives for the same worker/vendor/week, add its new time lines to the existing weekly invoice source record rather than creating a separate invoice.
- Call Create Vendor Invoice to create or regenerate the weekly invoice document from the accumulated Time Card source lines after each new Time Card handoff.
- Time Card owns accumulation, project/time splitting, known-rate application, and spreadsheet/Teams placement; Create Vendor Invoice owns the formal invoice document generation using the established polished invoice template.
- Every time a Time Card email is processed, amend the current weekly project/BackOffice invoice drafts and email the amended invoice PDFs back to the sender for accuracy verification using the Create Vendor Invoice verification email rules. Copy `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`, sign as `Jean Wright`, and preserve the sent email and verification response as source evidence.
- Treat the Friday or otherwise final end-of-week Time Card email as the point when the verified weekly invoices may be copied to Teams/project folders, subject to the rest of the filing and validation rules.
- Preserve every routed Time Card email as source evidence and retain traceability from each invoice line back to the source email.
- If the source does not state the worked date, use the email received date as the worked date and record that assumption in the packet.
- The worker/vendor does not need to supply an invoice number for Time Card. Invoice Entry creates the invoice number using the standard Time Card invoice numbering and file naming pattern.

Known Time Card rates:

- Josh: calculate Time Card labor at `$31.25` per hour.
- If a routed Time Card source conflicts with a known rate, hold the affected line for Wes review instead of silently using the conflicting rate.

Project handling:

- Split the weekly time by project when the Time Card source identifies multiple projects.
- Create one invoice per project and one separate invoice for BackOffice time when BackOffice time is present.
- Insert each project's time into that project's correct project-management spreadsheet under existing Invoice Entry insertion rules.
- Do not put all time into one project unless the source clearly applies only to that project.
- If project, date, worker/vendor, hours, rate, or destination worksheet is unclear, hold the affected line for review rather than guessing.
- Before inserting, check for existing entries for the same worker/vendor, week, project, date, and source Time Card line so repeated weekly updates do not duplicate prior additions.
- When a weekly Time Card invoice is updated after a prior insertion, reconcile against existing project spreadsheet rows and update or add only the delta allowed by the current workbook rules.

Teams filing:

- Do not copy Time Card invoice PDFs to Teams/project folders until the final email for the end of the week has been received and processed.
- After the final end-of-week Time Card email is processed, save a copy of the current weekly invoice PDF in each affected Teams project `Invoices` folder.
- If a weekly invoice file already exists for the same worker/vendor/week/project after final processing, replace that Teams file with the updated invoice copy.
- Use a stable weekly filename so updates overwrite the same file instead of creating duplicates.
- Standard file naming pattern: `YY-MM-DD - <Worker or Vendor> - Time Card - Week Ending YYYY-MM-DD.pdf`, where the leading `YY-MM-DD` is the week-ending date.

Safety limits:

- Do not approve or pay the invoice.
- Do not send a Time Card verification email if the sender identity is unclear, the generated invoice cannot be verified visually, or the message would imply approval, payment, or acceptance of the invoice.
- Do not create workbook entries without enough project, date, hours, rate, and source traceability.
- Preserve unresolved lines in the project room and report what Wes must review.

## Required Statement Packet

Statement processing must be routed through Doc Scan. Do not ask Invoice Entry directly to fetch, OCR, parse, or process raw statement PDFs. Doc Scan sends extracted Statement data for this room to consume. A Statement handoff should include:

- Statement vendor
- Statement account or account suffix, if available
- Statement date or period
- Due date, if available
- Statement total or balance, if available
- Filed statement PDF path in Teams
- Source scan path or source document reference
- Extracted line items, with transaction date, description, amount, page/source reference, and extraction confidence when available
- Statement-level confidence/status
- Notes about missing pages, weak OCR, credits/payments, non-purchase rows, or unclear line items

## Folder Map

- `sources\` - copied invoice packets, intake examples, source notes, and supporting references.
- `working\` - routing decisions, duplicate checks, insertion logs, rollback references, validation notes, and iteration lessons.
- `outputs\` - review-ready reports or handoff summaries for Wes.

## Operating Rules

1. Do not edit a live project workbook until Wes has clearly authorized the insertion or the workflow has an approved automation rule for that exact kind of insertion.
2. Use Teams/SharePoint as the source of truth for active project-management workbooks.
3. Project-management spreadsheets live directly under the Teams/SharePoint `Property` drive root, such as `Property/27_Project Management - 7001 Outrigger Dr.xlsm`.
4. Do not use individual property subfolders as the source for the project-management spreadsheet.
5. Make a rollback copy before editing a workbook.
6. Insert invoice rows only into the destination area approved for that worksheet mode.
7. For Vendor Tabs, use the yellow actual-invoice section; never write imports into the orange template-estimate rows.
8. Check for duplicates before insertion.
9. Validate affected totals after insertion.
10. Upload the verified workbook back through the Teams/SharePoint connector only after it opens cleanly and has no unintended workbook links.
11. After each workbook or workflow iteration, record, refine, or expand lessons learned in `working\iteration-lessons.md` before treating the iteration as complete.

## Review Request Processing

For project workbooks that use the Review request design:

- Worksheet: `Review`.
- Review table: `tblInvoiceReview`.
- Request checkbox: `Review!B1`.
- Checkbox label: `Needs Invoice Entry Review`.
- Defined name: `invoiceEntryReviewRequest`.
- Required defined-name reference: `=Review!$B$1`.
- `TRUE` means Invoice Entry review is requested.
- `FALSE` or blank means no request is pending.
- The prior `Review!Q2` text selector is obsolete and must not be used.

Review reconciliation trigger: any time Invoice Entry opens an active project workbook for an authorized workbook action, first check whether the workbook has worksheet `Review` and table `tblInvoiceReview`. If it does, run the existing Review Request Processing rules against that table before other workbook work. The checkbox remains a user-visible request marker, but it is not the only trigger for reconciliation; an authorized workbook-open action is also enough to invoke the existing Review processing rules.

When processing a workbook Review request:

1. Confirm the exact Teams workbook before editing.
2. Retrieve a fresh copy using the SharePoint/Teams connector.
3. Read `invoiceEntryReviewRequest` by defined name, not by guessing its cell location.
4. Verify through Excel that `invoiceEntryReviewRequest` reopens as `=Review!$B$1`; do not create or rely on a relative reference such as `=Review!B1`.
5. If the request value is `FALSE` or blank, report that no Invoice Entry request is pending and do not process Review rows.
6. If the request value is `TRUE`, read `tblInvoiceReview` by table name and column headers.
7. Do not depend on visible row numbers, filtering, hidden rows, or the table's current cell range.
8. Build the structured request packet inside the Invoice Entry process. Do not add packet formulas, scripts, or duplicate-check logic to the workbook.
9. Include the workbook identity, request timestamp, Review Row IDs, current row values, destinations, statuses, and source traceability.
10. Treat rows as eligible when `Destination Worksheet` is filled, `Review Row ID` is present, required vendor, date, amount, and source information is present, and status is not an explicit stop. A filled `Destination Worksheet` supplied by Wes is approval to move the row even if an older status still says `Needs Review`.
11. Exclude rows when status is `Moved`, `Hold`, `Do Not Move`, `Duplicate Risk`, or `Missing Data`, `Destination Worksheet` is blank, or required traceability is insufficient. Treat `Hold` as a hard stop until Wes changes it.
12. Perform duplicate checks before inserting anything.
13. Insert approved records only into the yellow actual-invoice section of the correct destination worksheet; never write into orange template-estimate rows.
14. Preserve formulas, formatting, tables, controls, selectors, names, and workbook links.
15. After a successful insertion, retain the Review row, correct `Status` to `Moved`, and record the destination worksheet/table and movement date in the existing review or notes field. Correct an older `Needs Review` status during the move unless Wes set the status to `Hold`.
16. Preserve excluded or uncertain rows and explain what still needs review.
17. After the pending request has been fully handled and validation passes, clear the checkbox by setting `invoiceEntryReviewRequest` to `FALSE`.
18. Do not clear the checkbox before the request has been processed and the workbook has passed validation.
19. Create a rollback copy before editing.
20. Save through Excel, reopen cleanly, validate destination totals and `Gnatt Chart` values, confirm zero unintended workbook links, and replace the same Teams workbook only after validation passes.

## Statement Hold

Statement packets are extracted by Doc Scan and routed to this project room to be treated as statement-line source material, but they are not normal single-invoice packets. Lowes Statement is the first active statement source.

If a Statement packet is received:

1. Do not insert statement items into any workbook yet.
2. Do not treat the statement as a single invoice for one worksheet.
3. Mark the packet as `Needs Review - Statement` unless the approved Statement rules say otherwise.
4. Use the extracted data as the starting point for allocation review, not as automatic approval for insertion.
5. Hold insertion until Wes approves a tested process for allocating statement items by project and then by worksheet/table within each project.

Reason: a common invoice usually maps to one project and one tab, but a statement can contain charges for multiple projects and multiple tabs inside each project.

## Lowes Statement Operations

Lowes statements have one supported intake path:

- **Doc Scan handoff processing** - Doc Scan receives or is asked to process one or more Lowes statements, extracts the detail, and passes a structured Statement packet to Invoice Entry.

Do not request statement processing directly in this Invoice Entry project room. If Wes or another workflow wants one statement or a set of statements processed, route the request to Doc Scan first. Invoice Entry must wait for the Doc Scan Statement packet and must not substitute its own OCR, statement extraction, or raw-PDF parsing.

For Statement handoffs:

- treat a statement as potentially multi-project,
- never treat the full statement as belonging to one workbook just because one line belongs there,
- route each retained line by project first, then worksheet/table,
- import a line into a project workbook only when that workbook is ready to receive that class of line,
- retain statement detail that applies to a project that is not yet ready for insertion,
- keep enough traceability to import retained lines later, including statement account, statement closing date, row/ref number, transaction date, description, amount, project clue, confidence/status, and source statement path,
- avoid duplicate Review or vendor-table rows when a held line is later imported.

Current rollout status: active project workbooks are being prepared for Lowe's Review/vendor-table processing. When Doc Scan supplies a structured Statement packet, Invoice Entry may iterate through ready active projects and import only the rows that apply to each ready project. Non-ready or unclear rows remain held.

Held statement detail lives in:

`C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\lowes-statement-held-detail-register.md`

## Lowes Statement Review-First Rule

For Lowes Statement packets:

1. Exclude rows that clearly do not belong to the target project.
2. Exclude sales-tax-only and tax-credit-only rows; tax will be calculated or allocated later by an approved spreadsheet tax method.
3. Insert rows that certainly belong to the target project into that project's workbook `Review` table first.
4. Also insert rows that may belong to the target project but have project, PO, destination, mixed-tab, or allocation uncertainty into that project's workbook `Review` table first.
5. Populate `Review[Description]` with the clean item description that will later map into the vendor-table description field.
6. When Lowe's item numbers are available, use reliable Lowe's product-page matches to improve `Review[Description]`; keep statement-derived text when no reliable product match is found.
7. Do not insert Lowes statement items directly into vendor tabs during the initial packet-consumption pass.
8. If the destination tab is clear, fill `Review[Destination Worksheet]` with that worksheet name.
9. If the destination is not clear, leave `Review[Destination Worksheet]` blank and explain the issue in the review/status fields.
10. A filled `Destination Worksheet` means Invoice Entry has a confident routing recommendation; it does not by itself mean the row has already been copied into the destination vendor table.
11. Moving or copying a reviewed Lowes statement row from `Review` into a vendor table happens only after the review/approval rule for that row is satisfied.
12. Rows not inserted into a particular project workbook must still be retained in the held-detail register when they are Home/non-project, accounting-review, unclear-project, belong to a project whose workbook is not ready, or otherwise cannot yet be inserted into the appropriate project workbook.

### Provisional Vendor-Tab Copy Exception

If Wes explicitly authorizes post-copy review for a Statement batch, Invoice Entry may copy high-confidence Lowe's statement rows directly from `Review` into a vendor tab when project, amount, description, and destination worksheet are defensible from the packet and approved worksheet-mode rules.

This is a copy-for-review, not final approval:

- keep the source `Review` row,
- set or leave its status as `Copied - Needs Owner Verification` or another clear review status rather than `Moved`,
- record the destination worksheet/table and copy date in the review or notes field,
- do not use this exception for unclear project, blank or guessed destination, tax-only amounts, missing/fragmented amount evidence, mixed destination items, incomplete-source-only summary rows, or explicit stop statuses such as `Hold`.

## Vendor Tabs Startup

When inserting into Vendor Tabs, read:

- `C:\Codex\Wiki Files\Project Rooms\Template to Project\Worksheet Modes\Vendor Tabs Mode Rules.md`
- `C:\Codex\Wiki Files\Project Rooms\Template to Project\Project Spreadsheet Expense Placement Rules.md`

Current Vendor Tabs worksheets:

1. `Demo & Trash Haul`
2. `Appliances`
3. `Plumbing Fixtures`
4. `Windows & Doors`
5. `Cabinets`
6. `Paint`
7. `Flooring`
8. `HVAC`
9. `Electrical Fixtures`
10. `STR`
11. `Landscape`

Do not route invoices to tabs right of `Landscape`, such as `Exterior` or `Furnishing`, unless Wes explicitly expands Vendor Tabs.

## Duplicate Check

Use these duplicate indicators before inserting:

- Strongest key: project + vendor + invoice number.
- If no invoice number: project + vendor + invoice date + amount.
- Also compare source filename and Doc Scan packet/source identifier when available.

If a duplicate is likely, stop and route the packet for review instead of inserting another row.

## Open Decisions

- Exact row-insertion behavior for each Vendor Tab's yellow actual-invoice section.
- Whether successful low-risk insertions can later run automatically.
- Final STR worksheet design, because STR does not yet match the two-group vendor-tab layout.
- Statement allocation process for splitting extracted statement charges by project and by worksheet/table before insertion.
- Lowes Statement follow-up process for moving approved Review rows into vendor tables after Wes supplies or accepts the destination worksheet.
- Safe workbook-structure rollout pattern for Vendor Tabs, including how to standardize table columns and formatting without corrupting table headers.

## Next Actions

1. Finish and approve the Outrigger Vendor Tabs design.
2. Create the first Outrigger invoice-entry test packet.
3. Prove duplicate detection, row placement, totals, and `Gnatt Chart` behavior on Outrigger.
4. After Wes approves, define the repeatable insertion procedure for other active project workbooks.
## Start PR Pointer

Before durable work, follow the Start PR workflow in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
