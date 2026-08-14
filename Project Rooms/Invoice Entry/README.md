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
- `Email Monitor` owns mailbox monitoring, routed-email preservation, direct email handoff, and all outbound email delivery through Email Delivery.
- `Manager` owns its Time Card source ledger, source traceability, clarification, display, correction history, active-line totals, and versioned structured packet production.
- `Invoice Entry` owns packet consumption or authorized packet creation, duplicate checks, Receipt document generation from confirmed collection facts, property assignment, workbook resolution, approved insertion, validation, upload, and durable processing status.
- `Template to Project` owns worksheet design, worksheet-mode rules, template changes, and rollout across active workbooks.

Invoice Entry may read Template to Project rules while inserting into an established worksheet mode. It must not edit Template to Project files or redesign a workbook mode without Wes's exact authorization.

## Supported Modes

### Standard Packet Processing

Consume structured invoice or receipt packets from Doc Scan, resolve the active workbook and approved destination, check duplicates, insert only when authorized, validate, and log the result.

### Create Vendor Invoice

Consume vendor-invoice email handoffs from Email Monitor or OfficeAssist. Use an attached invoice as the source document. When the source is free text only, create the formal invoice, obtain vendor fact verification when required, obtain Wes approval before final filing or posting, and route every email package through Email Monitor.

### Time Card

Run from either an Email Monitor Time Card email handoff or an authorized, versioned structured Manager Time Card packet. Manager packets must cite Wes's processing instruction and are deduplicated by dispatch id, packet version, canonical Manager entry id, and semimonthly period; corrections preserve prior versions and update the same source lines. Accumulate accepted time by worker for semimonthly periods: the 1st-15th and the 16th-last calendar day. Generate one payable invoice for the complete period, with project and BackOffice allocation detail inside that invoice. For Josh, the issuer is `Josh Kennedy LLC`, the invoice contact is `profcyber0077@gmail.com`, and Buy Your Home is the customer even when time arrives from the IRA Manager mailbox. Invoice Entry retains ownership of rates, amounts, invoice generation, approval, filing, allocation, and spreadsheet insertion. A Manager packet does not authorize any of those actions by itself. The invoice cannot become final before the period closes and requires Wes approval before filing, posting, or payment eligibility.

### Receipt

Use Receipt as the user-callable mode for money the business has actually collected. It creates a formal `RECEIPT`, preserves the collection evidence, and assigns the proceeds to one exact property. During the current Rosebrooks Estate Sale, Wes may say `Receipt item #<item number>`. That direct command confirms the exact item sold and cash was collected, uses the item's current established Marketplace price unless Wes states a different amount, and uses the request date as the receipt date. Outside this exact command, an asking price or active listing is not proof of a sale or amount collected.

For the current Estate Sale workflow, assign supported receipts to `20-HM - 115 Rosebrooks Dr` and classify them as `Estate Sale Proceeds / Project Credit`. After resolving the exact item and recording the confirmed collection, Invoice Entry sends a duplicate-safe sold-status handoff to the registered Marketplace task. Marketplace owns the Facebook change and must verify that the exact item number maps to the exact listing before marking it sold. Invoice Entry does not operate Facebook or edit Marketplace records. Keep the Receipt document positive, preserve the historical purchase record, and post the collected amount to the project workbook as an opposite-signed invoice transaction. Use the matching approved Vendor Tab when the category is supported; otherwise place the negative transaction in `Review` with a blank destination and a concise category question.

### Statement Processing

Consume statement detail extracted and packaged by Doc Scan. Treat statements as potentially multi-project and multi-category. Allocate by project first, retain unsupported detail, and do not treat an entire statement as one invoice.

### Reconcile

Run Reconcile as a user-callable mode when Wes directly requests it or an authorized Dashboard handoff identifies Invoice Entry mode `Reconcile` and the exact project/property. The Dashboard invocation is authorization to evaluate existing `Review!tblInvoiceReview` rows even when `invoiceEntryReviewRequest` is `FALSE` or blank; the checkbox remains a separate visible request marker. Invoice Entry resolves the fresh authoritative workbook, preserves held or incomplete rows, checks duplicates, moves only eligible rows with an approved `Destination Worksheet`, validates the workbook, and reports moved, held, duplicate-risk, and failed rows. Reconcile processes existing Review rows only; adding new packet items requires the applicable intake mode.

### Vendor Tabs

Insert only into the yellow actual-invoice area of an approved Vendor Tab. Never write imported records into orange template-estimate rows. Read the current Template to Project Vendor Tabs rules before insertion.

## Email Boundary

Invoice Entry never sends email directly. It prepares the exact package and hands it to Email Monitor's Email Delivery workflow. A send is complete only after Email Monitor returns verified OfficeAssist Sent Items evidence. Do not retry a verified or ambiguous delivery without reconciliation.

## Concise Handoffs

A routine direct handoff should provide one authoritative source pointer, external attachment paths or blocker when applicable, a short summary, the requested operation, and only source-specific warnings. Do not repeat the full skill, standing safety rules, full email body, or completed history in task messages. Detailed evidence belongs in the referenced packet and Invoice Entry records.

Invoice Entry may read one exact Outlook message when the handoff supplies its exact message ID and mailbox identity. It must not search or monitor a mailbox, alter messages, or send email.

## Durable Dispatch Intake

Email Monitor and Jean dispatches are authoritative in `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\dispatch-queue\records`; task messages are wake-up signals. On every startup and backup-monitor run, inspect unresolved records addressed to the registered Invoice Entry task, deduplicate by dispatch ID and payload hash, write the durable `accepted` receipt before substantive work, then record `Processing`, `Completed`, or `Failed` through `Project Rooms\Email Monitor\tools\Manage-EmailMonitorDispatch.ps1`. Queue presence grants intake authority only and does not bypass Invoice Entry's approval, payment, filing, workbook, vendor-contact, or email-delivery gates.

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

Dedicated task: `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`.

Backup automation: standalone local cron job `invoice-entry-to-projects-backup-heartbeat`, displayed as `Invoice Entry Backup Monitor`, scheduled for noon and 4:00 PM Eastern. It reads durable Project Room state and does not target or wake the operational task. Direct handoffs remain the primary trigger. After recording its outcome, a clean run with no new packet, failure, blocker, or decision archives only its own cron execution task. A run that finds a packet or needs attention remains visible.

## Task Health

- Keep detailed processing history in packet files, logs, or approved Teams locations instead of repeating it in task messages.
- Keep `working\work-status.md` current after meaningful state changes and before a substantial run ends. It must identify the operation state, queue, blockers, delivery evidence, classified working files, and observable task-health metrics.
- Quiet backup and health checks must not add turns to the operational Invoice Entry task. Notify it only for actionable work, a health transition, a failure, or a decision.
- More than 150 observable turns or five observable context compactions triggers review; neither threshold causes automatic rollover.
- The shared Windows supervisor may recommend controlled rollover only when multiple measured signals support it. It may not create or archive a task.
- Actual rollover requires Wes's separate approval. Preserve durable state, confirm no ambiguous external action remains in flight, create one replacement task for this same Project Room, verify its startup state, and only then archive the predecessor.
- Maintain exactly one active Invoice Entry operational task. Do not create another Project Room, skill, or Git branch for rollover.
- Before an approved rollover, inventory direct-routing task IDs, callback dependencies, and automation targets. Update only specifically authorized cross-PR or shared references, then archive the predecessor after replacement verification.

Shared supervisor configuration is owned by Email Monitor at `Project Rooms\Email Monitor\config\workflow-health-registry.json`. Invoice Entry keeps only its current status and concise enrollment documentation here.

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
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; the PR must accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
