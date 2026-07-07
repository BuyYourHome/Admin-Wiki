# Project Spreadsheet Invoice Entry

## Purpose

This project room owns the operational workflow for inserting invoice records into Buy Your Home project-management spreadsheets.

The workflow starts after Document Scan has completed scanned invoice or receipt intake and prepared a structured invoice packet. This room receives that packet, decides where the record belongs in the project-management spreadsheet, checks for duplicates, inserts the record into the correct worksheet area, validates totals, and reports uncertainty for Wes review.

## Scope

Included:

- Receive structured invoice packets from Document Scan as the normal scanned-invoice intake source.
- Receive structured invoice packets from Email Summary, OfficeAssist, or another approved workflow only as a secondary or future handoff source when that workflow provides a complete structured packet.
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

- `Document Scan`: scan inspection/OCR, document splitting, invoice/receipt identification, project/property folder routing, saving/copying invoice files into Teams/project folders, scan log entries, and structured invoice packet creation.
- `Project Spreadsheet Invoice Entry`: structured packet receipt, exact live project-management workbook resolution, workbook duplicate checks, final row placement, invoice record insertion, workbook formula/format/selector/table/link preservation, totals and downstream-link validation, authorized upload back to Teams/SharePoint, and insertion logging.
- `Project Management Spreadsheet Redesign`: worksheet design, worksheet-mode rules, template changes, and rollout across project workbooks.
- `Email Summary / OfficeAssist`: secondary or future handoff source only when it has a complete structured invoice packet; it is not the default scanned-invoice intake path.

## Current Status

- Status: active heartbeat; invoice insertion procedure still has open design decisions.
- First supported worksheet group: Vendor Tabs Mode.
- First workbook for proving the workflow: Outrigger, after Wes approves the Vendor Tabs Mode design.
- Automation: active project-room heartbeat every 15 minutes. The heartbeat inspects this project room for new or changed structured invoice/receipt packets only; it does not scan inboxes, inspect raw scan folders, copy files into Teams, or edit a live workbook unless Wes has clearly authorized the insertion or an approved automation rule exists for that exact insertion type.
- Automation id: `project-spreadsheet-invoice-entry-heartbeat`.
- Dedicated chat/thread id: `019f3d56-b310-75c0-b084-616bfc1e9f59`.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\project-spreadsheet-invoice-entry\SKILL.md`

## Required Invoice Packet

Each handoff should include:

- Project/property
- Vendor name
- Invoice date
- Invoice number, if available
- Invoice amount
- Work category
- Source email sender
- Source email subject
- Source email received date/time
- Source email/message ID or Outlook link, if available
- Saved invoice file path in Teams/project folder
- Recommended project workbook
- Recommended worksheet
- Confidence/status
- Notes or uncertainty

## Folder Map

- `sources\` - copied invoice packets, intake examples, source notes, and supporting references.
- `working\` - routing decisions, duplicate checks, insertion logs, rollback references, and validation notes.
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

## Vendor Tabs Mode Startup

When inserting into Vendor Tabs Mode, read:

- `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Worksheet Modes\Vendor Tabs Mode Rules.md`
- `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign\Project Spreadsheet Expense Placement Rules.md`

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
- Also compare source filename and source email/message ID when available.

If a duplicate is likely, stop and route the packet for review instead of inserting another row.

## Open Decisions

- Exact row-insertion behavior for each Vendor Tab's yellow actual-invoice section.
- Whether successful low-risk insertions can later run automatically.
- Final STR worksheet design, because STR does not yet match the two-group vendor-tab layout.

## Next Actions

1. Finish and approve the Outrigger Vendor Tabs Mode design.
2. Create the first Outrigger invoice-entry test packet.
3. Prove duplicate detection, row placement, totals, and `Gnatt Chart` behavior on Outrigger.
4. After Wes approves, define the repeatable insertion procedure for other active project workbooks.
