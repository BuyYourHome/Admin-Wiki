# Invoice Entry

## Purpose

Invoice Entry owns operational processing after a structured invoice, receipt, statement-line, routed vendor-invoice, or routed Time Card source reaches this Project Room. It resolves the correct active project-management workbook, checks duplicates, determines approved row placement, performs authorized insertion, validates the workbook, and records the outcome.

Invoice Entry does not redesign workbook templates, approve or pay invoices, monitor mailboxes, perform scan OCR, or make unsupported accounting decisions.

## Canonical Operating Sources

- Detailed workflow rules: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`
- Authoritative current work: `working\work-status.md`
- Packet structure: `working\invoice-packet-schema.md`
- Active workbook lookup: `working\project-spreadsheet-register.md`
- Current blockers and decisions: `working\missing-context.md`
- Source references and retention outcomes: `working\source-inventory.md`
- Duplicate decisions: `working\duplicate-and-conflict-log.md`
- Lowe's retained detail: `working\lowes-statement-held-detail-register.md`
- Scanned-document outcomes: `working\scanned-document-action-log.md`
- Working archive locations: `working\teams-working-archive-map.md`
- Reusable lessons: `working\iteration-lessons.md`

Do not duplicate the full skill rules in this README. The skill controls workflow behavior; `work-status.md` controls what is currently open. Historical packet and processing logs preserve evidence but do not override a later governing rule or current status.

## Required Startup

1. Confirm the working folder is exactly `C:\Codex\Wiki Files`.
2. Read the installed Invoice Entry skill and this README.
3. Read `working\work-status.md` before processing a handoff or opening a workbook.
4. Read the packet, source references, and detailed processing log for the specific item.
5. If records conflict, stop and reconcile the authoritative source before repeating an external action.
6. Use SharePoint/Teams as the source of truth for active project-management workbooks.

## Ownership Boundary

- `Doc Scan` owns scan inspection, OCR, splitting, document identification, scanned-file routing, scan logs, statement extraction, and creation of structured scanned-document packets.
- `Email Monitor` owns mailbox monitoring, routed-email preservation, direct handoff, and all outbound email delivery through Email Delivery.
- `Invoice Entry` owns packet consumption or authorized packet creation, duplicate checks, workbook resolution, approved insertion, validation, upload, and durable processing status.
- `Template to Project` owns worksheet design, worksheet-mode rules, template changes, and rollout across active workbooks.

Invoice Entry may read Template to Project rules while inserting into an established worksheet mode. It must not edit Template to Project files or redesign a workbook mode without Wes's exact authorization.

## Supported Modes

### Standard Packet Processing

Consume structured invoice or receipt packets from Doc Scan, resolve the active workbook and approved destination, check duplicates, insert only when authorized, validate, and log the result.

### Create Vendor Invoice

Consume vendor-invoice email handoffs from Email Monitor or OfficeAssist. Use an attached invoice as the source document. When the source is free text only, create the formal invoice, obtain vendor fact verification when required, obtain Wes approval before final filing or posting, and route every email package through Email Monitor.

### Time Card

Run only from an Email Monitor handoff. Accumulate accepted time by worker and week, split time by project or BackOffice destination, and regenerate one Project Cost Allocation Report per destination. Under the current rule, each destination report is also the payable invoice; together the reports must reconcile to Josh Kennedy's fixed `$1,250.00` weekly amount. Do not create a separate biweekly service-payment invoice.

### Statement Processing

Consume statement detail extracted and packaged by Doc Scan. Treat statements as potentially multi-project and multi-category. Allocate by project first, retain unsupported detail, and do not treat an entire statement as one invoice.

### Review Request Processing

For authorized workbook work, reconcile `Review!tblInvoiceReview` by table and column names, independent of filters or hidden rows. Use the defined name `invoiceEntryReviewRequest`, preserve held rows, run duplicate checks, and post only rows that meet the current Review and worksheet-mode rules.

### Vendor Tabs

Insert only into the yellow actual-invoice area of an approved Vendor Tab. Never write imported records into orange template-estimate rows. Read the current Template to Project Vendor Tabs rules before insertion.

## Email Boundary

Invoice Entry never sends email directly. It prepares the exact package and hands it to Email Monitor's Email Delivery workflow. A send is complete only after Email Monitor returns verified OfficeAssist Sent Items evidence. Do not retry a verified or ambiguous delivery without reconciliation.

## Concise Handoffs

A routine direct handoff should provide one authoritative source pointer, external attachment paths or blocker when applicable, a short summary, the requested operation, and only source-specific warnings. Do not repeat the full skill, standing safety rules, full email body, or completed history in task messages. Detailed evidence belongs in the referenced packet and Invoice Entry records.

Invoice Entry may read one exact Outlook message when the handoff supplies its exact message ID and mailbox identity. It must not search or monitor a mailbox, alter messages, or send email.

## Workbook Safety

- Confirm the exact live workbook at the SharePoint `Property` root before every edit.
- Use `working\project-spreadsheet-register.md` as a lookup aid, not as proof that a cached filename is still current.
- Create a rollback copy before editing.
- Check duplicates before insertion.
- Preserve formulas, formatting, tables, controls, selectors, names, macros, and links.
- Save through Excel when required, reopen cleanly, validate affected totals and `Gnatt Chart`, and confirm zero unintended links.
- Replace the same SharePoint workbook only after validation passes.
- Do not retry an upload already recorded as verified unless evidence shows that it failed.

## Current State

The current operational queue, verified deliveries, holds, and known stale records live only in `working\work-status.md`. Update that file after every substantive run. Do not place an active queue in this README.

Dedicated task: `019f3d56-b310-75c0-b084-616bfc1e9f59`.

Backup automation: standalone local cron job `invoice-entry-to-projects-backup-heartbeat`, displayed as `Invoice Entry Backup Monitor`, scheduled for noon and 4:00 PM Eastern. It reads durable Project Room state and does not target or wake the operational task. Direct handoffs remain the primary trigger.

## Source And Working-File Retention

The Git repository retains rules, status, schemas, compact packet summaries, references, decisions, and logs. Operational source emails, attachments, generated PDFs, workbook copies, render previews, OCR files, and machine handoff artifacts belong in their authoritative mailbox, SharePoint/Teams location, project folder, or mapped Invoice Entry Working Archive.

At the end of a run, preserve durable evidence, archive or remove generated working artifacts under the detailed skill rules, and update the archive map. Do not delete uncertain evidence.

## Git And Skill Sync

- Invoice Entry owns this Project Room and `skills\invoice-entry`.
- Do not edit another Project Room or skill without Wes's exact authorization.
- Commit only the scoped Invoice Entry body of work.
- Push only when Wes explicitly asks or the deliverable is already defined as final.
- The wiki-managed skill is the source of truth. Sync it to `%USERPROFILE%\.codex\skills\invoice-entry` only after the source is correct and ready for use.

## Start PR Pointer

Before durable work, follow `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Work on `main` unless Wes explicitly asks for another branch.
