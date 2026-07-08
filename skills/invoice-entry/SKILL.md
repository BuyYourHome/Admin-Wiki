---
name: invoice-entry
description: Use for Buy Your Home project-management spreadsheet invoice-entry work after Doc Scan has prepared a structured invoice, receipt, or Statement Mode packet. Trigger when Codex needs to receive a structured packet, choose the correct active project workbook and worksheet, check for duplicate invoice or statement-line records, insert approved records into a Vendor Tab or other approved project-spreadsheet expense area, validate totals and workbook links, and report uncertain routing for Wes review.
---

# Invoice Entry

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry`
- Skill source: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`
- Spreadsheet redesign room: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign`

Use this skill for operational invoice and approved statement-line insertion into project-management spreadsheets. For scanned invoice, receipt, and Statement Mode records, Doc Scan is the normal intake workflow and should trigger this workflow by direct follow-up message after creating the packet. The project-room heartbeat is a backup monitor for missed packet handoffs. Do not use this skill for scan inspection/OCR, document splitting, statement extraction, invoice-file routing, or spreadsheet template redesign.

Doc Scan owns Lowes Statement Mode extraction and will send extracted statement data for this skill to consume. This skill owns statement-line allocation, duplicate checks, final spreadsheet row placement, insertion, and validation after Wes approves the Statement Mode allocation rules.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Admin Home.md`, `Project Room Workflow.md`, `Codex Skill Source Rule.md`, and `Git Work Scope Rule.md`.
3. Read the project-room `README.md`.
4. Read `working\invoice-packet-schema.md`.
5. If the insertion is for Vendor Tabs Mode, read:
   - `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Worksheet Modes\Vendor Tabs Mode Rules.md`
   - `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Project Spreadsheet Expense Placement Rules.md`
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

This skill owns:

- receiving the structured packet,
- resolving the exact live project-management workbook,
- checking workbook records for duplicates,
- allocating extracted statement lines by project and worksheet/table when approved,
- deciding final spreadsheet row placement,
- inserting invoice, receipt, or approved statement-line records into approved project-spreadsheet expense areas,
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
- template redesign or worksheet-mode rollout,
- invoice approval, payment, accounting entries, vendor communication, or legal/financial decision-making.

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
