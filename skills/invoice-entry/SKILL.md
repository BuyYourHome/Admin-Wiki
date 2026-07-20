---
name: invoice-entry
description: Use for Buy Your Home project-management spreadsheet invoice-entry work after Doc Scan has prepared a structured invoice, receipt, or Statement Mode packet, when Email Monitor or OfficeAssist routes a contractor/vendor invoice email into Invoice Entry, or when Email Monitor routes a Time Card email. Trigger when Codex needs to receive or create a structured packet, choose the correct active project workbook and worksheet, check for duplicate invoice, time-card, or statement-line records, insert approved records into a Vendor Tab or other approved project-spreadsheet expense area, validate totals and workbook links, and report uncertain routing for Wes review.
---

# Invoice Entry

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry`
- Skill source: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`
- Template-to-project migration room: `C:\Codex\Wiki Files\Project Rooms\Template to Project`

Use this skill for operational invoice, Time Card, and approved statement-line insertion into project-management spreadsheets. For scanned invoice, receipt, and Statement Mode records, Doc Scan is the normal intake workflow and should trigger this workflow by direct follow-up message after creating the packet. For routed contractor/vendor invoice emails, Email Monitor or OfficeAssist may hand off a saved email source and attachments under Create Vendor Invoice Mode. For Time Card emails, Email Monitor is the only supported trigger and must hand off the preserved source email. The project-room heartbeat is a backup monitor for missed packet handoffs. Do not use this skill for scan inspection/OCR, document splitting, statement extraction, invoice-file routing, mailbox monitoring, or spreadsheet template redesign.

Doc Scan owns Lowes Statement Mode extraction and will send extracted statement data for this skill to consume. This skill owns statement-line allocation, duplicate checks, final spreadsheet row placement, insertion, and validation after Wes approves the Statement Mode allocation rules.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Admin Home.md`, `Project Room Workflow.md`, `Codex Skill Source Rule.md`, and `Git Work Scope Rule.md`.
3. Read the project-room `README.md`.
4. Read `working\invoice-packet-schema.md`.
5. If the insertion is for Vendor Tabs Mode, read:
   - `C:\Codex\Wiki Files\Project Rooms\Template to Project\Worksheet Modes\Vendor Tabs Mode Rules.md`
   - `C:\Codex\Wiki Files\Project Rooms\Template to Project\Project Spreadsheet Expense Placement Rules.md`
6. Use the SharePoint/Teams connector as the source-of-truth path for active project-management workbooks.

## Ownership Boundary

Doc Scan normally owns scanned invoice, receipt, and Statement Mode intake, including:

- scan inspection/OCR,
- document splitting,
- invoice/receipt/statement identification,
- project/property folder routing,
- saving or copying the invoice file into Teams/project folders,
- scan log entries,
- Lowes Statement Mode extraction,
- creating the structured packet.

Other packet handoff sources are out of scope unless Wes separately approves and documents them.

Email Monitor or OfficeAssist may route contractor/vendor invoice emails under Create Vendor Invoice Mode. In that mode, the routing workflow owns mailbox monitoring and source-email preservation, while Invoice Entry owns reading the routed source material, creating the structured invoice packet, and performing authorized invoice-entry work.

This skill owns:

- receiving the structured packet,
- creating a structured invoice packet from routed vendor invoice email source material when Create Vendor Invoice Mode applies,
- processing Time Card handoffs from Email Monitor under Time Card Mode,
- resolving the exact live project-management workbook,
- checking workbook records for duplicates,
- allocating extracted statement lines by project and worksheet/table when approved,
- deciding final spreadsheet row placement,
- inserting invoice, receipt, or approved statement-line records into approved project-spreadsheet expense areas,
- creating and sending a free-text invoice verification request back to the proper vendor under Create Vendor Invoice Mode when vendor identity and email address are clear,
- preserving workbook formulas, formatting, selectors, tables, and links,
- validating totals and downstream links,
- uploading the verified workbook back to Teams/SharePoint when authorized,
- insertion notes and review questions.

This skill does not own:

- scan inspection/OCR,
- document splitting,
- invoice/receipt/statement identification,
- project/property folder routing,
- saving or copying invoice files into Teams/project folders,
- scan log entries,
- statement-line extraction from PDFs,
- mailbox scanning or Time Card email detection,
- template redesign or worksheet-mode rollout,
- invoice approval, payment, accounting entries, vendor communication outside the Create Vendor Invoice Mode free-text invoice verification request, or legal/financial decision-making.

## Create Vendor Invoice Mode

Use Create Vendor Invoice Mode when Email Monitor or OfficeAssist routes a contractor/vendor invoice email to Invoice Entry.

Trigger:

- A direct handoff message from Email Monitor or OfficeAssist says to process a routed vendor invoice.
- The routed source is an email saved under `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\`.
- The handoff may include invoice attachment paths, an Outlook message link, attachment-access blockers, vendor clues, project clues, and a short summary.

Invoice Entry responsibilities:

- Read the routed email source and any saved invoice attachments.
- If the routed email has an attached invoice, treat the attachment as the source invoice. Do not create a new invoice and do not send it back to the vendor for verification merely because it arrived by email.
- For attached-invoice emails, identify the vendor, project/property, invoice date, invoice number if available, amount, work category, and source traceability, then continue under the normal Invoice Entry rules.
- For attached-invoice emails, choose the correct active project-management workbook and worksheet, check duplicate risk, move or copy the invoice file to the correct Teams/SharePoint project folder when authorized, insert only when confidence and rules allow, validate the workbook, and record the result.
- If the routed email has no attached invoice and the invoice information exists only as free text, treat the email body as invoice source material, not as a finished invoice.
- For free-text invoice emails, create a formal invoice document from the email body and preserved source details.
- Use the polished Create Vendor Invoice PDF template for generated free-text invoices unless Wes requests a different invoice style. Template: `C:\Codex\Wiki Files\skills\invoice-entry\templates\create-vendor-invoice-polished-invoice-template.md`.
- Render and visually inspect the generated invoice PDF before attaching it to a review or vendor-verification email.
- Email the generated formal invoice PDF back to the proper vendor with a request to verify the invoice's accuracy when vendor identity, vendor email address, and source evidence are clear. This Create Vendor Invoice Mode verification email has standing approval and does not require a separate Wes review step before sending. Copy `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com` on that verification email. Use the Admin wiki email-delivery rules for sender safety and sent-item verification.
- Do not forward or attach the routed free-text source email to the vendor. Preserve the source email in the project room for traceability, but send the vendor only the polished generated invoice and the verification request.
- Sign Create Vendor Invoice Mode vendor verification emails as `Jean Wright`.
- Do not file a free-text generated invoice as a final invoice, insert it into a project spreadsheet, or mark it ready for posting until the vendor has returned or confirmed it as accurate.
- Record routing decisions, workbook edits, duplicate checks, validation results, and unresolved questions in the Invoice Entry project room.

Safety limits:

- Do not approve invoices.
- Do not pay invoices.
- Do not contact vendors except for the Create Vendor Invoice Mode free-text invoice-accuracy verification request described above.
- Do not send a vendor verification request for an email that already includes an attached invoice.
- Do not send a vendor verification request if the proper vendor email address is unclear, the free-text source evidence is insufficient, the invoice appears misrouted, or the message would imply approval, payment, or acceptance of the invoice.
- Do not guess the project, vendor, amount, invoice number, or destination worksheet when evidence is unclear.
- If the routed email lacks required fields or the attachment cannot be accessed, preserve the source link and report the blocker.
- If duplicate risk is found, stop before insertion and report the risk.
- If the invoice appears to be a statement with multiple project lines, handle it under Statement Mode rules instead of treating it as one vendor invoice.

Completion:

- Preserve the routed email source and any invoice attachments as durable source material.
- For attached-invoice emails, keep enough traceability to link the workbook entry back to the email, attachment, and handoff.
- For free-text invoice emails, preserve the routed email, generated invoice, verification email, copied recipients, and vendor response before final filing or spreadsheet insertion.
- Record the vendor verification email result for free-text invoices, including whether it was sent, held, blocked, or needs Wes review.
- Report completed entries, held items, duplicate risks, filing results, and any open review questions.

## Time Card Mode

Use Time Card Mode only when Email Monitor sends a direct handoff message to Invoice Entry for an email with subject containing `Time Card`.

Trigger:

- Email Monitor detects and routes the Time Card email.
- The routed source email is preserved under `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\`.
- The handoff includes the routed source path, sender, received time, subject, attachment paths or attachment blockers, and any project/vendor/person clues.
- Invoice Entry must not scan inboxes, search for Time Card emails, or start this mode from raw mailbox access on its own.

Weekly accumulation:

- Accumulate Time Card emails by worker/vendor and work week.
- Maintain one weekly invoice per worker/vendor for that week.
- When another Time Card email arrives for the same worker/vendor/week, add its new time lines to the existing weekly invoice source record rather than creating a separate invoice.
- Regenerate the weekly invoice using the established polished invoice template after each new Time Card handoff.
- Preserve every routed Time Card email as source evidence and retain traceability from each invoice line back to the source email.

Project handling:

- Split the weekly time by project when the Time Card source identifies multiple projects.
- Insert each project's time into that project's correct project-management spreadsheet under existing Invoice Entry insertion rules.
- Do not put all time into one project unless the source clearly applies only to that project.
- If project, date, worker/vendor, hours, rate, or destination worksheet is unclear, hold the affected line for review rather than guessing.
- Before inserting, check for existing entries for the same worker/vendor, week, project, date, and source Time Card line so repeated weekly updates do not duplicate prior additions.
- When a weekly Time Card invoice is updated after a prior insertion, reconcile against existing project spreadsheet rows and update or add only the delta allowed by the current workbook rules.

Teams filing:

- Save a copy of the current weekly invoice PDF in each affected Teams project `Invoices` folder.
- If a weekly invoice file already exists for the same worker/vendor/week/project, replace that Teams file with the updated invoice copy.
- Use a stable weekly filename so updates overwrite the same file instead of creating duplicates.
- Standard file naming pattern: `YY-MM-DD - <Worker or Vendor> - Time Card - Week Ending YYYY-MM-DD.pdf`, where the leading `YY-MM-DD` is the week-ending date.

Safety limits:

- Do not approve or pay the invoice.
- Do not contact the worker/vendor merely because a Time Card email arrived unless another approved Invoice Entry mode separately authorizes that contact.
- Do not create workbook entries without enough project, date, hours, rate, and source traceability.
- Preserve unresolved lines in the project room and report what Wes must review.

## Required Inputs

Before editing a workbook, obtain or build an invoice packet with:

- project/property,
- vendor,
- invoice date,
- invoice number if available,
- invoice amount,
- work category,
- source scan path for Doc Scan packets,
- saved invoice file path,
- recommended workbook,
- recommended worksheet,
- confidence/status,
- notes or uncertainty.

If required fields are missing, ask Wes or route the packet for review unless the missing value can be safely derived from the filed invoice and approved packet.

For Statement Mode packets, set or treat `confidence/status` as `Needs Review - Statement Mode` and stop before insertion unless Wes has approved the exact Statement Mode allocation rule being applied. Do not treat the statement as a single invoice or route it to a single worksheet unless a later approved Statement Mode process explicitly allows that for the specific line item.

## Workbook Rules

- Confirm the exact target workbook before editing.
- Active project-management spreadsheets live directly under the Teams/SharePoint `Property` drive root.
- Do not look for the project-management workbook inside individual property folders such as `Owning`, `Buying`, or `Renting`.
- Copy the connector-verified workbook into the project-room working area before editing.
- Create a rollback copy before every workbook edit.
- Edit through Excel-controlled saves for `.xlsm` project workbooks.
- Verify the workbook opens cleanly before upload.
- Upload back through the Teams/SharePoint connector only after validation passes.

## Review Request Processing

For workbook Review requests:

- use worksheet `Review`,
- use Review table `tblInvoiceReview`,
- read the request checkbox through the defined name `invoiceEntryReviewRequest`,
- require `invoiceEntryReviewRequest` to reopen in Excel as `=Review!$B$1`,
- treat `TRUE` as request pending,
- treat `FALSE` or blank as no request pending,
- do not use the obsolete `Review!Q2` text selector,
- read Review rows by table name and column headers, not by visible row numbers, filters, hidden rows, or fixed cell ranges.

Review reconciliation trigger: any time Invoice Entry opens an active project workbook for an authorized workbook action, first check whether the workbook has worksheet `Review` and table `tblInvoiceReview`. If it does, run the existing Review Request Processing rules against that table before other workbook work. The checkbox remains a user-visible request marker, but it is not the only trigger for reconciliation; an authorized workbook-open action is also enough to invoke the existing Review processing rules.

When instructed to process a workbook request:

1. Confirm the exact Teams workbook before editing.
2. Retrieve a fresh copy using the SharePoint/Teams connector.
3. Read `invoiceEntryReviewRequest` by defined name.
4. If it is `FALSE` or blank, report that no Invoice Entry request is pending and do not process Review rows.
5. If it is `TRUE`, read `tblInvoiceReview` by column header name.
6. Build the request packet inside the Invoice Entry process. Do not add packet formulas, scripts, or duplicate-check logic to the workbook.
7. Include the workbook identity, request timestamp, Review Row IDs, current row values, destinations, statuses, and source traceability.
8. Treat rows as eligible when `Destination Worksheet` is filled, `Review Row ID` is present, required vendor, date, amount, and source information is present, and status is not an explicit stop. A filled `Destination Worksheet` supplied by Wes is approval to move the row even if an older status still says `Needs Review`.
9. Exclude rows when status is `Moved`, `Hold`, `Do Not Move`, `Duplicate Risk`, or `Missing Data`, `Destination Worksheet` is blank, or required traceability is insufficient. Treat `Hold` as a hard stop until Wes changes it.
10. Perform duplicate checks before inserting anything.
11. Insert approved records only into the yellow actual-invoice section of the correct destination worksheet; never write into orange template-estimate rows.
12. Preserve formulas, formatting, tables, controls, selectors, names, and workbook links.
13. After a successful insertion, retain the Review row, correct `Status` to `Moved`, and record the destination worksheet/table and movement date in the existing review or notes field. Correct an older `Needs Review` status during the move unless Wes set the status to `Hold`.
14. Preserve excluded or uncertain rows and explain what still needs review.
15. After the pending request has been fully handled and validation passes, clear the checkbox by setting `invoiceEntryReviewRequest` to `FALSE`.
16. Do not clear the checkbox before the request has been processed and the workbook has passed validation.
17. Create a rollback copy before editing.
18. Save through Excel, reopen cleanly, validate destination totals and `Gnatt Chart` values, confirm zero unintended workbook links, and replace the same Teams workbook only after validation passes.

## Vendor Tabs Mode Insertion

For Vendor Tabs Mode:

- Route only to tabs included in `Vendor Tabs Mode Rules.md`.
- Insert invoice records only into the yellow actual-invoice section.
- Never write invoice imports into the orange template-estimate area.
- Preserve the `M1` selector behavior.
- Preserve each tab's existing template-estimate formulas.
- Validate the affected tab total and the `Gnatt Chart` source cell after insertion.
- Treat `STR` as a special case until Wes approves its final design.

## Statement Mode Packet Handling

If a Statement Mode packet is received:

- hold processing before workbook insertion,
- consume the extracted statement data from Doc Scan,
- do not allocate charges across projects or tabs by guesswork,
- do not insert it as one invoice into one tab,
- report that the Statement Mode allocation process still needs design and testing unless that exact allocation rule has been approved.

This hold exists because a common invoice usually maps to one project and one tab, while a statement can contain line items for multiple projects and multiple tabs inside each project.

## Lowes Statement Operation Modes

Lowes statements have one supported intake path:

- Doc Scan handoff processing: Doc Scan receives or is asked to process one or more Lowes statements, extracts the detail, and passes a structured Statement Mode packet to Invoice Entry.

Do not request statement processing directly in this Invoice Entry project room or skill. If Wes or another workflow wants one statement or a set of statements processed, route the request to Doc Scan first. Invoice Entry must wait for the Doc Scan Statement Mode packet and must not substitute its own OCR, statement extraction, or raw-PDF parsing.

For Statement Mode handoffs:

- treat each statement as potentially containing entries for multiple projects,
- never process the whole statement as belonging to one workbook merely because one line belongs to that project,
- route each retained line by project first, then worksheet/table,
- import a line into a project workbook only when that project workbook is ready to receive that class of line,
- when a line applies to a project that is not yet ready for insertion, retain the detail in the Invoice Entry held-detail register until that project is ready,
- keep enough source traceability to import later, including statement account, statement closing date, row/reference number, transaction date, description, amount, project clue, confidence/status, and source statement path,
- do not drop, ignore, or overwrite retained statement detail merely because the current project workbook is not ready,
- when the same statement is later processed across active projects, use the held-detail register and processing logs to avoid duplicate Review or vendor-table rows.

Current rollout status: active project workbooks are being prepared for Lowe's Review/vendor-table processing. When Doc Scan supplies a structured Statement Mode packet, Invoice Entry may iterate through ready active projects and import only the rows that apply to each ready project. Non-ready or unclear rows remain held.

## Lowes Statement Mode Project-First Review Rule

For Lowes Statement Mode packets:

- expect item-level rows, not transaction-summary rows, when the Lowe's statement detail shows multiple purchased or returned items under one transaction/reference number,
- preserve the shared transaction header on each item row, including statement date, transaction/posting dates, receipt/reference number, store number, PO/project clue, and source/filing paths,
- treat rows marked `Needs Review - Amount Split` or `Needs Review - Allocation` as not ready for final vendor-tab copy until amount allocation is resolved,
- route each extracted statement item by project/workbook first,
- exclude rows that clearly do not belong to the target project,
- insert statement items that certainly belong to the target project into that project's workbook `Review` table,
- also insert statement items that may belong to the target project but have project, PO, destination, mixed-tab, or allocation uncertainty into that project's workbook `Review` table,
- keep Home/non-project, clearly non-matched-project, accounting-review, and other clearly non-project lines outside project workbooks until the project/accounting status is resolved,
- exclude sales-tax-only and tax-credit-only rows from Statement Mode insertion because tax will be calculated or allocated later by an approved spreadsheet tax method,
- do not insert Lowes statement items directly into vendor tabs during the initial packet-consumption pass,
- populate `Review[Description]` with the clean item description that will later map into the vendor-table description field,
- when Lowe's item numbers are available, use reliable Lowe's product-page matches to improve `Review[Description]`; keep statement-derived text when no reliable product match is found,
- fill `Review[Destination Worksheet]` only when the destination tab is clear for a line already matched to that project,
- leave `Review[Destination Worksheet]` blank when the line belongs or may belong to the project but the vendor tab or project proof is unclear,
- use the review/status fields to explain what is needed before the line can be copied,
- treat a filled `Destination Worksheet` as a routing recommendation, not proof that the row has already been inserted into the destination vendor table.

Moving or copying a reviewed Lowes statement row from `Review` into a vendor table happens only after the review/approval rule for that row is satisfied.

Provisional vendor-tab copy exception: if Wes explicitly authorizes post-copy review for a Statement Mode batch, Invoice Entry may copy high-confidence Lowe's statement rows directly from `Review` into a vendor tab when project, amount, description, and destination worksheet are defensible from the packet and approved worksheet-mode rules. This is a copy-for-review, not final approval. Keep the source `Review` row, set or leave its status as `Copied - Needs Owner Verification` or another clear review status rather than `Moved`, and record the destination worksheet/table and copy date in the review or notes field. Do not use this exception for rows with unclear project, blank or guessed destination, tax-only amounts, missing/fragmented amount evidence, mixed destination items, incomplete-source-only summary rows, or an explicit stop status such as `Hold`.

Rows not inserted into a particular project workbook must still be retained. Use `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\lowes-statement-held-detail-register.md` for statement detail that is Home/non-project, accounting-review, unclear-project, belongs to a project whose workbook is not ready, or otherwise cannot yet be inserted into the appropriate project workbook.

## Duplicate Checks

Check likely duplicates before insertion:

- strongest key: project + vendor + invoice number,
- fallback key: project + vendor + invoice date + amount,
- supporting evidence: saved source filename and Doc Scan packet/source identifier.

If a duplicate is likely, stop and report the duplicate risk instead of inserting.

## Validation

Before marking an insertion complete:

- verify inserted values match the invoice packet,
- verify source traceability was recorded,
- verify affected worksheet totals,
- verify downstream `Gnatt Chart` value when applicable,
- verify workbook-link count is zero,
- verify there are no unintended external-link package parts,
- reopen the saved workbook cleanly in Excel before upload.

## Iteration Lessons

After each workbook or workflow iteration, record, refine, or expand reusable lessons in the project room before marking the work complete. Use:

- `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\iteration-lessons.md`

Lessons should include failed attempts, workbook-specific hazards, safer next-step constraints, and validation checks that should be repeated in future iterations.

## Completion

- Record insertion decisions, duplicate findings, and unresolved questions in the project room.
- Capture new reusable lessons in the project-room rules or a relevant mode rule before completion.
- Commit durable wiki/skill changes when made.
- Do not push Git changes unless Wes says the work is finished, explicitly asks for a push, or the task defines the deliverable as final.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
