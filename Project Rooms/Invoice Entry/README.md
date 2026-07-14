# Invoice Entry

## Purpose

This project room owns the operational workflow for inserting invoice and approved statement-line records into Buy Your Home project-management spreadsheets.

The workflow starts after Doc Scan has completed scanned invoice, receipt, or Statement Mode intake and prepared a structured packet. This room receives that packet, decides where the record or statement line belongs in the project-management spreadsheet, checks for duplicates, inserts approved records into the correct worksheet area, validates totals, and reports uncertainty for Wes review.

## Scope

Included:

- Receive structured invoice, receipt, and Statement Mode packets from Doc Scan as the scanned-document intake source.
- Other intake sources are out of scope unless Wes separately approves and documents them.
- Consume Lowes Statement Mode packets extracted by Doc Scan; Doc Scan owns extraction, and Invoice Entry owns allocation and later spreadsheet insertion when approved.
- Resolve the correct active project-management workbook through Teams/SharePoint.
- Route invoice records to the correct worksheet and expense area.
- For Vendor Tabs Mode, insert records only into the yellow actual-invoice section of the correct vendor tab.
- Preserve template-estimate rows, formulas, checkboxes/selectors, named ranges, tables, formatting, and workbook structure.
- Validate affected totals and downstream links such as `Gnatt Chart`.
- Keep rollback copies and record insertion decisions.

Excluded unless Wes explicitly expands scope:

- Scan inspection/OCR, document splitting, invoice/receipt identification, scan log entries, or saving/copying invoice files into Teams/project folders.
- Designing or rolling out project-management spreadsheet templates.
- Replacing worksheet structures across all project workbooks.
- Paying invoices, approving invoices, contacting vendors, or changing accounting systems.

## Responsibility Boundary

- `Doc Scan`: scan inspection/OCR, document splitting, invoice/receipt/statement identification, project/property folder routing when applicable, saving/copying filed PDFs into Teams/project folders, scan log entries, Statement Mode extraction, and structured packet creation.
- `Invoice Entry`: structured packet receipt, exact live project-management workbook resolution, workbook duplicate checks, statement-line allocation, final row placement, invoice or approved statement-line record insertion, workbook formula/format/selector/table/link preservation, totals and downstream-link validation, authorized upload back to Teams/SharePoint, and insertion logging.
- `Template to Project`: worksheet design, worksheet-mode rules, template changes, and rollout across project workbooks.

## Current Status

- Status: active direct-message handoff; backup heartbeat available. Invoice insertion procedure still has open design decisions.
- First supported worksheet group: Vendor Tabs Mode.
- Statement Mode status: Doc Scan owns Lowes Statement Mode extraction and will send extracted statement data for this room to consume. Invoice Entry holds statement lines until allocation and insertion rules are tested and approved.
- First workbook for proving the workflow: Outrigger, after Wes approves the Vendor Tabs Mode design.
- Primary trigger: direct follow-up message to the dedicated Invoice Entry chat with the packet path and summary.
- Backup automation: project-room heartbeat every 60 minutes. The heartbeat inspects this project room for new or changed structured invoice/receipt packets only; it does not scan inboxes, inspect raw scan folders, copy files into Teams, or edit a live workbook unless Wes has clearly authorized the insertion or an approved automation rule exists for that exact insertion type.
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

## Required Statement Mode Packet

Doc Scan sends extracted Statement Mode data for this room to consume. A Statement Mode handoff should include:

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
7. For Vendor Tabs Mode, use the yellow actual-invoice section; never write imports into the orange template-estimate rows.
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

## Statement Mode Hold

Statement Mode packets are extracted by Doc Scan and routed to this project room to be treated as statement-line source material, but they are not normal single-invoice packets. Lowes Statement Mode is the first active statement source.

If a Statement Mode packet is received:

1. Do not insert statement items into any workbook yet.
2. Do not treat the statement as a single invoice for one worksheet.
3. Mark the packet as `Needs Review - Statement Mode` unless the approved Statement Mode rules say otherwise.
4. Use the extracted data as the starting point for allocation review, not as automatic approval for insertion.
5. Hold insertion until Wes approves a tested process for allocating statement items by project and then by worksheet/table within each project.

Reason: a common invoice usually maps to one project and one tab, but a statement can contain charges for multiple projects and multiple tabs inside each project.

## Lowes Statement Operation Modes

Lowes statements have two supported operating modes:

1. **Requested statement processing** - Wes asks Invoice Entry to go get and process one Lowes statement or a set of Lowes statements.
2. **Doc Scan handoff processing** - Doc Scan receives a new Lowes statement, extracts the detail, and passes a structured Statement Mode packet to Invoice Entry.

For either mode:

- treat a statement as potentially multi-project,
- never treat the full statement as belonging to one workbook just because one line belongs there,
- route each retained line by project first, then worksheet/table,
- import a line into a project workbook only when that workbook is ready to receive that class of line,
- retain statement detail that applies to a project that is not yet ready for insertion,
- keep enough traceability to import retained lines later, including statement account, statement closing date, row/ref number, transaction date, description, amount, project clue, confidence/status, and source statement path,
- avoid duplicate Review or vendor-table rows when a held line is later imported.

Current rollout status: Outrigger is the first project workbook set up for Lowe's Review/vendor-table processing. After Template to Project migrates the same structure to more active project workbooks, Requested statement processing may iterate through active projects and import only the rows that apply to each ready project. Until then, non-ready project rows remain held.

Held statement detail lives in:

`C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\lowes-statement-held-detail-register.md`

## Lowes Statement Mode Review-First Rule

For Lowes Statement Mode packets:

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

## Vendor Tabs Mode Startup

When inserting into Vendor Tabs Mode, read:

- `C:\Codex\Wiki Files\Project Rooms\Template to Project\Worksheet Modes\Vendor Tabs Mode Rules.md`
- `C:\Codex\Wiki Files\Project Rooms\Template to Project\Project Spreadsheet Expense Placement Rules.md`

Current Vendor Tabs Mode worksheets:

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

Do not route invoices to tabs right of `Landscape`, such as `Exterior` or `Furnishing`, unless Wes explicitly expands Vendor Tabs Mode.

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
- Statement Mode allocation process for splitting extracted statement charges by project and by worksheet/table before insertion.
- Lowes Statement Mode follow-up process for moving approved Review rows into vendor tables after Wes supplies or accepts the destination worksheet.
- Safe workbook-structure rollout pattern for Vendor Tabs Mode, including how to standardize table columns and formatting without corrupting table headers.

## Next Actions

1. Finish and approve the Outrigger Vendor Tabs Mode design.
2. Create the first Outrigger invoice-entry test packet.
3. Prove duplicate detection, row placement, totals, and `Gnatt Chart` behavior on Outrigger.
4. After Wes approves, define the repeatable insertion procedure for other active project workbooks.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
