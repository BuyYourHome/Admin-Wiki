---
name: project-spreadsheet-invoice-entry
description: Use for Buy Your Home project-management spreadsheet invoice-entry work after Document Scan or another approved intake workflow has prepared a structured invoice or receipt packet. Trigger when Codex needs to receive a structured packet, choose the correct active project workbook and worksheet, check for duplicate invoice records, insert a record into a Vendor Tab or other approved project-spreadsheet expense area, validate totals and workbook links, and report uncertain routing for Wes review.
---

# Project Spreadsheet Invoice Entry

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry`
- Skill source: `C:\Codex\Wiki Files\skills\project-spreadsheet-invoice-entry\SKILL.md`
- Spreadsheet redesign room: `C:\Codex\Wiki Files\Project Rooms\Project Management Spreadsheet Redesign`

Use this skill for operational invoice insertion into project-management spreadsheets. For scanned invoice and receipt records, Document Scan is the normal intake workflow. Do not use this skill for scan inspection/OCR, document splitting, invoice-file routing, or spreadsheet template redesign.

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

Document Scan normally owns scanned invoice and receipt intake, including:

- scan inspection/OCR,
- document splitting,
- invoice/receipt identification,
- project/property folder routing,
- saving or copying the invoice file into Teams/project folders,
- scan log entries,
- creating the structured invoice packet.

Email Summary / OfficeAssist may hand off an invoice only as a secondary or future source when it has a complete structured invoice packet. It is not the default scanned-invoice intake path.

This skill owns:

- receiving the structured invoice packet,
- resolving the exact live project-management workbook,
- checking workbook records for duplicates,
- deciding final spreadsheet row placement,
- inserting the invoice record into approved project-spreadsheet expense areas,
- preserving workbook formulas, formatting, selectors, tables, and links,
- validating totals and downstream links,
- uploading the verified workbook back to Teams/SharePoint when authorized,
- insertion notes and review questions.

This skill does not own:

- scan inspection/OCR,
- document splitting,
- invoice/receipt identification,
- project/property folder routing,
- saving or copying invoice files into Teams/project folders,
- scan log entries,
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
- source email sender, subject, and received time,
- source email/message ID or link when available,
- saved invoice file path,
- recommended workbook,
- recommended worksheet,
- confidence/status,
- notes or uncertainty.

If required fields are missing, ask Wes or route the packet for review unless the missing value can be safely derived from the filed invoice and source email.

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

## Duplicate Checks

Check likely duplicates before insertion:

- strongest key: project + vendor + invoice number,
- fallback key: project + vendor + invoice date + amount,
- supporting evidence: saved source filename and source email/message ID.

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

## Completion

- Record insertion decisions, duplicate findings, and unresolved questions in the project room.
- Capture new reusable lessons in the project-room rules or a relevant mode rule before completion.
- Commit durable wiki/skill changes when made.
- Do not push Git changes unless Wes says the work is finished, explicitly asks for a push, or the task defines the deliverable as final.
