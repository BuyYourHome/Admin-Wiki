---
name: invoice-entry
description: Use for Buy Your Home invoice-entry work after Doc Scan prepares a structured invoice, vendor receipt, or Statement packet; when Email Monitor or OfficeAssist routes a vendor invoice or Time Card; when Manager sends an authorized Time Card packet; when Wes invokes Reconcile; or when Wes invokes Receipt mode to document money collected and assign it to a property, including Marketplace estate-sale proceeds. Trigger for structured packets, collected-money receipts, semimonthly time, workbook routing, duplicate checks, approved insertion, Review reconciliation, validation, and uncertain routing.
---

# Invoice Entry

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry`
- Skill source: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`
- Authoritative current work: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\work-status.md`
- Teams working archive map: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\teams-working-archive-map.md`
- Scanned document action log: `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\scanned-document-action-log.md`
- Template-to-project migration room: `C:\Codex\Wiki Files\Project Rooms\Template to Project`

Use this skill for operational invoices, collected-money Receipts, Time Cards, and approved statement-line insertion into project-management spreadsheets. `Invoice` records money the business pays or owes; Receipt mode records money the business actually collects and posts that collection to the project workbook as the opposite-signed equivalent of an invoice expense. For scanned vendor receipts and Statement records, Doc Scan is the normal intake workflow and should trigger this workflow by direct follow-up message after creating the packet. For routed contractor/vendor invoice and Time Card emails, Email Monitor or OfficeAssist must hand off the preserved email source. Manager may separately hand off an authorized, versioned structured Time Card packet under the receiver rules below; this does not give Manager mailbox, invoice, rate, approval, filing, or workbook authority. A standalone backup cron monitor checks durable Project Room state for missed packet handoffs without waking the operational Invoice Entry task. Do not use this skill for scan inspection/OCR, document splitting, statement extraction, invoice-file routing, mailbox monitoring, Marketplace listing changes, or spreadsheet template redesign.

Doc Scan owns Lowes Statement extraction and will send extracted statement data for this skill to consume. This skill owns statement-line allocation, duplicate checks, final spreadsheet row placement, insertion, and validation after Wes approves the Statement allocation rules.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Admin Home.md`, `Project Room Workflow.md`, `Codex Skill Source Rule.md`, and `Git Work Scope Rule.md`.
3. Read the project-room `README.md`.
4. Read `working\work-status.md` before processing a handoff or opening a workbook. Treat it as the authority for active work, pending decisions, verified actions that must not be repeated, and current blockers.
5. Read `working\invoice-packet-schema.md` and the packet and processing log for the specific item.
6. If an older summary conflicts with `working\work-status.md` or the latest packet status, reconcile the authoritative source before repeating an email, workbook edit, upload, filing action, or generated-document action.
7. If older machine handoff packets, statement working files, review workbook evidence, or temporary workbook copies may matter, read `working\teams-working-archive-map.md` before assuming those files are unavailable locally.
8. For scanned-document-derived invoice work, read or update `working\scanned-document-action-log.md` to track what happened to the document and related spreadsheet action.
9. If the insertion is for Vendor Tabs, read:
   - `C:\Codex\Wiki Files\Project Rooms\Template to Project\Worksheet Modes\Vendor Tabs Mode Rules.md`
   - `C:\Codex\Wiki Files\Project Rooms\Template to Project\Project Spreadsheet Expense Placement Rules.md`
10. Use the SharePoint/Teams connector as the source-of-truth path for active project-management workbooks.

## Ownership Boundary

Doc Scan normally owns scanned invoice, receipt, and Statement intake, including:

- scan inspection/OCR,
- document splitting,
- invoice/receipt/statement identification,
- project/property folder routing,
- saving or copying the invoice file into Teams/project folders,
- scan log entries,
- Lowes Statement extraction,
- creating the structured packet.

Other packet handoff sources are out of scope unless Wes separately approves and documents them.

Email Monitor or OfficeAssist may route contractor/vendor invoice emails under Create Vendor Invoice. In that workflow, the routing workflow owns mailbox monitoring and source-email preservation, while Invoice Entry owns reading the routed source material, creating the structured invoice packet, and performing authorized invoice-entry work. Email Monitor's Email Delivery mode owns every outbound email send.

Invoice Entry may fetch one exact Outlook message for source reading only when the handoff supplies that message's exact ID and mailbox identity. It must not search, scan, triage, monitor, move, mark, draft, reply to, or send mailbox messages.

This skill owns:

- receiving the structured packet,
- creating a structured invoice packet from routed vendor invoice email source material when Create Vendor Invoice applies,
- processing Time Card handoffs from Email Monitor under Time Card,
- resolving the exact live project-management workbook,
- checking workbook records for duplicates,
- allocating extracted statement lines by project and worksheet/table when approved,
- deciding final spreadsheet row placement,
- inserting invoice, receipt, or approved statement-line records into approved project-spreadsheet expense areas,
- preparing complete outbound email packages for free-text invoice verification, Wes approval review, Time Card verification, and post-approval status notices,
- handing each authorized outbound email package to Email Monitor's Email Delivery mode,
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
- sending email directly, operating Outlook or another mailbox for delivery, invoice approval, payment, accounting entries, vendor communication outside the authorized Email Monitor delivery handoffs, or legal/financial decision-making.

## Outbound Email Boundary

Invoice Entry must not send email directly. Do not use an Outlook connector, local Outlook, or Outlook Web to draft, reply, forward, send, move, mark, or otherwise alter email from this Project Room. The exact-message source-reading exception in the ownership boundary does not authorize delivery or mailbox monitoring.

When an Invoice Entry rule authorizes an email:

1. Prepare the final delivery package inside Invoice Entry: sender, To, CC/BCC, subject, plain-text body, absolute attachment paths, authorization basis, and any stricter workflow restrictions.
2. Send a direct handoff message to the existing Email Monitor status task, `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`, explicitly requesting its Email Delivery mode.
3. Email Monitor's Email Delivery mode must use `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md` for OfficeAssist sender safety, connector/local-Outlook handling, attachment validation, Sent Items verification, delivery logging, and failure reporting.
4. Do not mark the email sent until Email Monitor returns a verified OfficeAssist Sent Items result with the sent message id and timestamp.
5. Record the handoff and returned delivery result in the Invoice Entry packet or processing log. If delivery fails or cannot be verified, keep the Invoice Entry item held and report the blocker.

## Concise Handoff Contract

Direct handoff messages are activation pointers, not durable processing histories. A normal Doc Scan or Email Monitor handoff should contain only:

- one packet path, exact Outlook message ID/link, or authoritative Teams/SharePoint source path;
- external attachment paths or a concise attachment-access blocker when applicable;
- a short vendor, project, statement, or Time Card summary;
- the requested Invoice Entry operation; and
- any source-specific warning that is not already governed by the Invoice Entry skill.

Do not repeat the full Invoice Entry standing rules, safety limits, mode instructions, full email body, complete prior-thread history, or completed-delivery narrative in a routine handoff. Invoice Entry must read its canonical skill, `working\work-status.md`, and the referenced packet or source record instead.

When the handoff supplies only an Outlook reference, fetch only that exact message when its full body is required. Do not broaden the operation into a mailbox search. Preserve the exact message ID/link and concise extracted facts in the packet or source inventory; do not copy the full body into repeated task messages.

If a concise handoff lacks enough information to identify or access the authoritative source, report the missing pointer or blocker. Do not ask the routing workflow to resend all standing instructions.

## Durable Dispatch Intake

For Email Monitor and Jean cross-Project-Room dispatches, the durable queue record is the authoritative handoff and a task message is only a wake-up signal.

- Queue location: `\\WES-VIDEOEDITOR\BYH-PRMessaging$\records`.
- Queue tool: `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1`.
- Protocol: `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\dispatch-queue-spec.md`.

At every Invoice Entry startup and backup-monitor run:

1. Inspect unresolved queue records whose destination task ID is `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`.
2. Deduplicate by dispatch ID and payload hash. Never process the same dispatch twice.
3. Confirm the request belongs to Invoice Entry and that its exact source pointer is accessible.
4. Before substantive work, run `Accept` with the registered Invoice Entry task ID. This writes the durable receipt. Return `accepted: <dispatch_id>` in the task when the channel is available.
5. Run `StartProcessing` before durable processing and use exactly one valid final action: `Complete`, `Block`, `NeedsWes`, or `Reject` for wrong-room work.
6. If the same accepted or completed dispatch is received again, return its existing status without repeating work or external actions.

Queue presence authorizes intake only. It does not authorize approval, payment, filing, workbook posting, vendor contact, email delivery, or another gated action. A malformed, conflicting, or inaccessible record must be blocked; wrong-room work must be rejected with the same dispatch ID and a concise reason.

## Task Health

Invoice Entry is enrolled in the shared Windows workflow-health supervisor owned by Email Monitor. Follow `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\README.md` for Invoice Entry context controls, `working\work-status.md` for current health fields, and `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\health-check-spec.md` for the shared supervisor contract. Do not copy the full supervisor implementation into this skill.

Activate Task Health when Wes requests it, when an authorized handoff reports an Invoice Entry context-health transition, or when observable performance degradation requires review. A Windows alert file alone does not invoke Codex; do not claim the mode ran unless the Invoice Entry task or an authorized coordinating task actually performed the review.

### Health Review Stage

- Keep detailed processing history in packet files, processing logs, or approved Teams locations instead of task messages.
- Keep exactly one active Invoice Entry operational task. Quiet health and backup checks must not add turns to it.
- Update `working\work-status.md` after meaningful state changes and before a substantial run ends. Maintain the operation state and start time, current-work durability, delivery evidence, open packets and blockers, Git/working-file classification, recent timeout/stall/duplicate-action counts, explicit health-follow-up status, and any observable task-turn or context-compaction measurements with source and observation time.
- Treat more than 150 observable task turns or five observable context compactions as review triggers only. If exact counts are unavailable, record them as unavailable; do not invent metrics.
- The supervisor may recommend controlled rollover only when multiple measured signals support review. It must not create or archive a task, repeat an external action, move Git state, or change the operational queue.
- Actual rollover requires Wes's separate approval. Before rollover, confirm no ambiguous external operation is in flight and that current work, delivery evidence, open packets, blockers, and Git classification are durable and current.

### Approved Rollover Stage

- After approval, keep this Project Room and skill, create one concise replacement-task handoff from durable state, and verify the replacement can read the canonical sources and authorization boundaries.
- Inventory every hardcoded Invoice Entry task ID, direct-routing destination, callback dependency, and automation target. State the exact cross-PR or shared-file edits required and obtain explicit authorization where Project Room ownership rules require it.
- Update the authorized routing references to the verified replacement. Do not create a duplicate backup automation; the existing detached noon/4:00 PM backup cron remains separate.
- Archive the predecessor only after replacement verification and authorized routing updates. Record predecessor and replacement task IDs and reset task-health review counters for the replacement.
- Do not create another Project Room, skill, or Git branch. Maintain exactly one active Invoice Entry operational task.

## Create Vendor Invoice

Use Create Vendor Invoice when Email Monitor or OfficeAssist routes a contractor/vendor invoice email to Invoice Entry.

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
- Every generated free-text invoice must have an invoice date and invoice number. If the source does not provide an invoice date, use the date Invoice Entry generates the draft and record that basis. If the source does not provide an invoice number, Invoice Entry must create one using the approved invoice-number pattern and record that it was generated by Invoice Entry.
- Use the polished Create Vendor Invoice PDF template for generated free-text invoices unless Wes requests a different invoice style. Template: `C:\Codex\Wiki Files\skills\invoice-entry\templates\create-vendor-invoice-polished-invoice-template.md`.
- For invoices Invoice Entry creates internally for an outside person or vendor, make that outside person or vendor the invoice issuer and visual identity. Show Buy Your Home as the customer. Never present Buy Your Home as the issuer of an invoice payable to the outside person.
- Generate this format with `C:\Codex\Wiki Files\skills\invoice-entry\scripts\create-outside-person-invoice.py` and structured JSON inputs so later verification and approval stages can be regenerated without changing invoice facts.
- Render and visually inspect the generated invoice PDF before attaching it to a review or vendor-verification email.
- Before handing off, filing, or replacing any generated free-text invoice PDF, run a Create Vendor Invoice preflight check: verify the PDF and packet show the current invoice date, invoice number, project/property, vendor, service period if applicable, amount, and status wording for the current stage. If the generator/template has hardcoded invoice number, date, or status text, update the generator/template first and regenerate the PDF before continuing.
- Prepare the generated formal invoice PDF and verification-request email package for the proper vendor when vendor identity, vendor email address, project/property, and source evidence are clear. This verification request has standing approval and does not require separate Wes review before the Email Monitor handoff. Set To to the vendor and CC `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`, then hand the package to Email Monitor's Email Delivery mode.
- Use the draft as the correction mechanism. A correctable ambiguity in dates, hours, quantity, or another invoice fact does not by itself justify holding the draft when the source supports one reasonable working interpretation. Show that interpretation and the exact ambiguity prominently in the draft and delivery body, send the draft to the payee with Wes and Jenny copied, and ask for corrections by exception. The ambiguity still blocks vendor-verified, approval, filing, posting, payment, and paid status until corrected or accepted through the applicable review rule.
- Missing payee identity or delivery contact remains a delivery blocker because Invoice Entry may not guess or misroute an invoice. Prepare the supported draft facts, record the missing contact, and obtain the payee's identity/email before the Email Delivery handoff.
- Distinguish the worker from the invoice issuer/payee. When the authoritative source or Wes states that one person's labor is billed through another vendor or contractor, keep that vendor/contractor as the invoice issuer and payee, identify the actual worker on the applicable line items, and send the correction-review draft to the issuer/payee. Do not create a separate invoice or require a separate delivery contact for the worker unless the source says the worker bills independently.
- Every project-related Create Vendor Invoice email subject must include the property address. Vendor-verification subjects should also identify the vendor and invoice purpose or service period, such as `908 Pond St - Tim Fleming Pond Hours Invoice - Verification Requested`.
- Do not include or forward the routed free-text source email in the vendor delivery package. Preserve it in the project room for traceability; the Email Monitor handoff may include only the polished generated invoice and the verification request.
- Sign Create Vendor Invoice vendor verification emails as `Jean Wright`.
- Treat vendor verification as confirmation that the generated invoice facts are accurate, not approval to pay, approval to file, or approval to insert into a project spreadsheet.
- After the vendor verifies a generated free-text invoice, prepare the verified invoice package for Wes's approval/payment review with Jenny copied and hand it to Email Monitor's Email Delivery mode. Include the property address, vendor, invoice date, invoice number, service period if applicable, amount, generated invoice PDF, vendor confirmation evidence, and any unresolved spreadsheet-placement issue.
- Use the exact subject pattern `Invoice Approval - <Vendor Name>` for every invoice package sent to Wes for approval. This approval-stage pattern is the exception to the property-address subject rule. Do not add property addresses, `Wes Approval Requested`, project names, amounts, service periods, or other variable suffixes. Example: `Invoice Approval - Tim Fleming`.
- Do not copy a verified free-text invoice to Teams/project folders, insert it into a project spreadsheet, mark it posted, or treat it as complete until Wes approves it by email.
- Until Wes approves by email, keep the generated and vendor-verified invoice in the Invoice Entry working files with status `Verified - Awaiting Wes Approval`.
- After Wes approves a verified free-text invoice by email, prepare an updated-status email package for the vendor, Wes, and Jenny unless Wes gives a different recipient list for that invoice, then hand it to Email Monitor's Email Delivery mode. The subject must include the property address and the body must identify the status as approved by Wes, the vendor, invoice date, invoice number, service period if applicable, amount, Teams/project-folder filing path once filed, spreadsheet insertion status, and any insertion blocker.
- Every invoice approved by Wes must result in one Sent Items-verified approved-invoice email to `WesWill@BuyYourHomeLLC.com` with the exact approved PDF attached. A verified vendor/status delivery that includes Wes and the exact approved PDF satisfies this rule; otherwise prepare a separate Wes-only package through Email Monitor's Email Delivery mode. A restriction against contacting the vendor does not suppress the required Wes copy. Filing, workbook posting, an unsent Outlook draft, or approval evidence alone is not delivery. Deduplicate by invoice number, approved PDF identity, recipient, and delivery request before sending so the rule never causes a second Wes copy.
- Record routing decisions, workbook edits, duplicate checks, validation results, and unresolved questions in the Invoice Entry project room.

Safety limits:

- Do not approve invoices.
- Do not pay invoices.
- Do not contact vendors or send email directly. Invoice Entry may prepare only the authorized Create Vendor Invoice and Time Card email packages described here and must route every send through Email Monitor's Email Delivery mode.
- Do not request delivery of a vendor verification email when the routed email already includes an attached invoice.
- Do not request delivery when the proper vendor email address is unclear, the free-text source evidence is insufficient, the invoice appears misrouted, or the message would imply approval, payment, or acceptance of the invoice.
- Do not guess the project, vendor, amount, invoice number, or destination worksheet when evidence is unclear.
- If the routed email lacks required fields or the attachment cannot be accessed, preserve the source link and report the blocker.
- If duplicate risk is found, stop before insertion and report the risk.
- If the invoice appears to be a statement with multiple project lines, handle it under Statement rules instead of treating it as one vendor invoice.

Completion:

- Preserve the routed email source and any invoice attachments as durable source material.
- For attached-invoice emails, keep enough traceability to link the workbook entry back to the email, attachment, and handoff.
- For free-text invoice emails, preserve the routed email, generated invoice, Email Monitor delivery handoff, verified sent-email evidence, copied recipients, and vendor response before final filing or spreadsheet insertion.
- For free-text invoice emails, preserve Wes's approval email before final Teams filing or spreadsheet insertion.
- For free-text invoice emails, record vendor verification, Wes approval, payment-review notice, Teams filing, spreadsheet insertion, and updated-status email as separate logged events.
- Record the vendor verification email result for free-text invoices, including whether it was sent, held, blocked, or needs Wes review.
- Report completed entries, held items, duplicate risks, filing results, and any open review questions.

## Time Card

Use Time Card when either:

- Email Monitor sends a direct handoff for an email with subject or body wording that resembles `Time Card`, `time sheet`, `timesheet`, or similar time-reporting language; or
- Manager sends a versioned structured Time Card packet after Wes requests draft/final processing or otherwise authorizes Invoice Entry processing.

Email Monitor remains the only supported email/mailbox intake and outbound-delivery path. Manager packets are structured ledger handoffs, not email handoffs and not authority for Invoice Entry to inspect a mailbox.

Trigger:

- Email Monitor detects and routes the Time Card or timesheet email.
- The routed source email is preserved under `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\`.
- The handoff includes the routed source path, sender, received time, subject, attachment paths or attachment blockers, and any project/vendor/person clues.
- Or Manager sends a direct handoff containing a packet that satisfies `working\invoice-packet-schema.md#manager-time-card-packets` and cites the authorizing Wes instruction.
- Invoice Entry must not scan inboxes, search for Time Card emails, or start this workflow from raw mailbox access on its own.

Manager packet receiver:

1. Return `accepted` with the same dispatch id before substantive processing when the request is within Invoice Entry scope. Finish with `done`, `blocked`, `needs Wes`, or `rejected as wrong room`, preserving that dispatch id.
2. Validate the dispatch id, positive packet version, worker, semimonthly period, requested operation, canonical Manager entry ids, active-line details, period total, source references, correction relationships, and missing/disputed fields against `working\invoice-packet-schema.md`.
3. Deduplicate on the combined identity of dispatch id, packet version, canonical Manager entry id, and semimonthly period. An unchanged packet is one intake, even if the handoff is repeated.
4. Treat a higher packet version as a correction candidate, preserve the prior version as history, apply explicit superseded/cancelled relationships, and recalculate the active-line total. Do not count `Superseded` or `Cancelled` lines.
5. Compare Manager's stated period total with the sum of active accepted lines. Hold the affected packet if the totals disagree, a canonical entry identity is missing, correction lineage is ambiguous, or the packet would overlap an existing Email Monitor-derived line without source-supported reconciliation.
6. Preserve Manager canonical entry ids in Invoice Entry's semimonthly source record so later corrections update the same line rather than create a new payable obligation.
7. Manager owns the source time ledger, source traceability, clarification, display, correction history, active-line totals, and packet production. Invoice Entry owns semimonthly accumulation, rates and amounts, invoice numbering, draft/final invoice generation, correction review, Wes approval, filing, allocation, and spreadsheet insertion.
8. A Manager packet never authorizes a rate, amount, invoice number, approval, filing destination, workbook entry, email, payment, or external action unless Invoice Entry previously returned that value or Wes separately authorized the action under Invoice Entry rules. No supplied packet means no invoice-generation action.

Semimonthly accumulation:

1. Each accepted Time Card email or validated Manager packet updates the accumulated, source-traceable semimonthly time record. The two periods are the 1st through the 15th and the 16th through the last calendar day of the month. The accumulated record is the source of truth; a generated PDF is a replaceable output, not the editable source.
2. Split actual time by project and BackOffice destination inside one invoice for the period.
3. Generate one payable `INVOICE` for the complete semimonthly period. The invoice both requests payment and shows the proportional project/BackOffice allocation; do not generate separate payable invoices per destination.
4. For Josh Kennedy, identify the issuer as `Josh Kennedy LLC`, show `profcyber0077@gmail.com` as the invoice contact, and show Buy Your Home as the customer even when Time Card source emails arrive from `IRAManager@SellYourHomeRaleigh.com`.
5. Calculate Josh's fixed semimonthly invoice amount by dividing his authorized annual compensation by `24`, then allocate that complete amount proportionally across all accepted time in the period. The current authorized annual basis is `$65,000.00`, so each semimonthly invoice is `$2,708.33`; this supersedes accumulating `$1,250.00` weekly amounts or carrying forward the prior `$2,500.00` invoice total. The line and destination allocations must reconcile exactly to the single invoice total.
6. After each meaningful time update, regenerate the draft invoice and route it through Email Monitor's Email Delivery workflow to the worker/payee, copying `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`. The draft is the correction mechanism: show any reasonable working interpretation of correctable source wording, identify the uncertainty in the PDF and email, and state that no reply is needed when the time, project allocation, and totals are correct; the sender should reply only when a correction is needed. Do not hold a draft merely because a correctable time detail may change. If the worker/payee identity or delivery address is missing, prepare and preserve the source-supported draft facts but do not guess a recipient; request the missing contact before delivery.
7. A semimonthly invoice cannot become final before its period closes on the 15th or the last calendar day of the month. After the close, send the draft to Wes for approval. Do not file, post, or treat it as eligible for payment until Wes approves it.

- When another Time Card email or validated Manager packet arrives for the same worker and semimonthly period, reconcile it against the existing period record, add only new active lines, update explicit corrections in place, and retain the same invoice number.
- Generate Time Card invoices with `C:\Codex\Wiki Files\skills\invoice-entry\scripts\create-project-cost-allocation-report.py`; despite the retained compatibility filename, its output is an invoice and must not use `Project Cost Allocation Report` as a document title or payable identity.
- For Josh's invoice layout, place `Josh Kennedy LLC` and `profcyber0077@gmail.com` above `INVOICE` on the upper left, keep the approval status aligned with the invoice heading, and omit explanatory allocation, method, and traceability panels from the bottom. Preserve the allocation summary, time-detail table, exact hours-and-minutes display, stable invoice number, period, customer, project totals, and amount due.
- After Wes approves an invoice, show `APPROVED BY WES`. Later format-only revisions keep that approval when the invoice number, service period, accepted time, allocations, and amount remain unchanged; regenerate and reverify the PDF without creating a new obligation.
- Preserve work dates, descriptions, hours, project allocation, period cost, allocation method, source traceability, duplicate decisions, delivery evidence, and approval responses.
- Draft Time Card invoices use correction-by-exception review. Silence from the sender means no correction was reported; it is not a separate affirmative verification requirement.
- Use the exact subject pattern `Time Card Approval - <Worker Name>` when sending a final Time Card report/invoice to Wes for approval. Do not use the Create Vendor Invoice subject `Invoice Approval - <Vendor Name>` for Time Card approval packages.
- If Wes approves the closed-period invoice, finalize it immediately. If Wes corrects or denies it, process the correction or hold the package as directed. Do not use the former Monday automatic-finalization rule.
- Preserve every routed Time Card email and accepted Manager packet version as source evidence and retain traceability from each invoice line back to its source email or canonical Manager entry id.
- If the source does not state the worked date, use the email received date as the worked date and record that assumption in the packet.
- Use the invoice number pattern `INV-JKLLC-<YYYYMMDD>-001`, where the date is the semimonthly period end. Use the period-end date as the invoice date.
- If no accepted hours exist for the period, the fixed service amount is unclear, or project allocation is unclear, hold the invoice rather than inventing an allocation.

Project handling:

- Split the semimonthly time by project and BackOffice inside the single payable invoice.
- Show a destination-allocation summary on the invoice so each project and BackOffice receives its supported share without creating multiple payment obligations.
- Maintain the current project-spreadsheet lookup list in `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\project-spreadsheet-register.md`.
- Use the register to identify the proposed workbook, then verify the exact current workbook at the SharePoint `Property` root before every edit. The register is a lookup aid, not authority to use a stale file.
- Invoice Entry owns this register until Wes explicitly transfers that duty to a Project PR or another named workflow.
- After the closed-period invoice is approved by Wes, insert each project's allocated cost into that project's correct project-management spreadsheet under existing Invoice Entry insertion rules.
- Do not put all time into one project unless the source clearly applies only to that project.
- If project, date, worker/vendor, hours, period cost, or destination worksheet is unclear, hold the affected line for review rather than guessing.
- Before inserting, check for existing entries for the same worker/vendor, semimonthly period, project, date, and source Time Card line so repeated updates do not duplicate prior additions.
- When a semimonthly invoice is updated after a prior insertion, reconcile against existing project spreadsheet rows and update or add only the delta allowed by the current workbook rules.

Teams filing:

- Do not copy a Time Card invoice to Teams/project folders until the semimonthly period has closed and Wes has approved it.
- After approval, save the single invoice in Teams `Office Admin/Invoices & Receipts` and preserve the project-allocation detail needed for supported project-workbook entries.
- If an invoice already exists for the same worker and semimonthly period after final processing, replace it with the updated invoice rather than creating a duplicate.
- Use a stable semimonthly filename so updates overwrite the same file.
- Standard filename: `YY-MM-DD - Josh Kennedy LLC - Time Card Invoice - <YYYY-MM-DD to YYYY-MM-DD>.pdf`.

Safety limits:

- Do not treat a draft invoice as final, paid, or proof of payment. The period must be closed and Wes must approve it before it is eligible for the normal payment process; Invoice Entry does not make payment.
- Do not request delivery if the sender identity is unclear, the invoice cannot be verified visually, or the destination allocations do not reconcile to the invoice total.
- Do not create workbook entries without enough project, date, hours, period-cost, allocation-method, and source traceability.
- Preserve unresolved lines in the project room and report what Wes must review.

## Receipt

Receipt is a user-callable mode for documenting money the business has actually collected. It produces a formal document titled `RECEIPT` and assigns the proceeds to one exact property. A vendor receipt showing money the business paid remains an Invoice/Doc Scan intake source; it is not this mode.

Authorized triggers:

- Wes directly requests `Receipt` or asks Invoice Entry to document collected money and identifies the property.
- An authorized Dashboard handoff names Invoice Entry mode `Receipt`, the exact property, the requester, and the collected-money facts.
- An authorized Marketplace handoff supplies item identity and completed-sale evidence. Marketplace source material can support the receipt but does not transfer Marketplace ownership to Invoice Entry.

Required receipt facts:

- exact property/project identity;
- receipt date and collision-checked receipt number;
- receiving entity;
- buyer or payer name, or an explicit statement that the cash buyer's name was not recorded;
- who collected the money;
- payment method;
- authoritative confirmation that the sale occurred and the money was collected;
- each item description, quantity, and actual amount collected;
- application of funds, such as `Estate Sale Proceeds / Project Credit`;
- separate collection and deposit statuses; and
- durable source references.

Marketplace reference rules:

- Receipt mode may read a Marketplace Estate Sale item ID, inventory row, listing title, listing URL, draft/listing ID, or Marketplace source path to identify the item.
- During the current Rosebrooks Estate Sale, Wes may invoke the complete shorthand `Receipt item #<item number>`. That direct command confirms that the exact item sold and cash was collected, defaults the receipt amount to the current established price in the sale-scoped Marketplace item record, and uses the request date as the receipt date. If Wes states another price or payment method, use the stated exception.
- `Established price` means the one current public sale price associated with that stable item number. Do not use an old price, private minimum, expected range, comparable value, or price belonging to another item. If the current record has no single price or conflicts with the listing, hold the request and ask Wes.
- Outside Wes's complete shorthand or another authoritative completed-sale source, an asking price, draft, active listing, buyer inquiry, offer, or appointment is not proof of a completed sale or the amount collected.
- Do not mark an item sold, edit a listing or Marketplace record, contact a buyer, negotiate, accept money, or perform another Marketplace action from Invoice Entry.
- Preserve the Marketplace identifier and source reference on the receipt packet so Marketplace and Invoice Entry records can later be reconciled without duplicating the sale. When the buyer and physical collector are not stated in the shorthand, record them explicitly as not recorded rather than inventing names.

Generation and accounting rules:

1. Use `C:\Codex\Wiki Files\skills\invoice-entry\scripts\create-cash-receipt.py` with a validated JSON input packet. Use `templates\cash-receipt-template.md` as the field and layout reference.
2. Use receipt number pattern `RCPT-<YYYYMMDD>-<property-number>-<sequence>`, and check existing receipt evidence before choosing the sequence.
3. Prefer one receipt per sold estate-sale item. If multiple items were sold in one cash transaction, use one itemized receipt whose line total equals the actual total collected.
4. Run visual PDF QA before filing or delivery. Do not leave placeholders, clipped text, unsupported facts, or approval language.
5. `Cash Received` proves collection only. It does not prove that the money was deposited. Use deposit status `Not Recorded`, `Pending Deposit`, or `Deposited` only as separately supported.
6. Deduplicate first by project plus receipt number. Use Marketplace item ID plus sale date plus actual amount as the fallback transaction key.
7. Assign supported Estate Sale proceeds in the current workflow to `20-HM - 115 Rosebrooks Dr` with application `Estate Sale Proceeds / Project Credit`.
8. Preserve the historical invoice or purchase record. A collected-money Receipt does not delete, overwrite, mark refunded, or otherwise change the original expense evidence.
9. Post every supported Receipt to the project workbook as an opposite-signed invoice transaction: keep the formal Receipt and collection record positive, but use the negative of the collected amount in the workbook so the transaction offsets project expense.
10. Apply the normal invoice-placement rules to the negative workbook entry. When the receipt has a source-supported expense category, use the matching approved Vendor Tab and its actual-invoice section; for example, stove-sale proceeds belong in `Appliances`. Preserve the receipt number and source reference so the negative entry is not mistaken for a vendor refund or duplicate invoice.
11. When the project is certain but no existing expense category is defensible, insert the negative transaction into `Review`, leave `Destination Worksheet` blank, and explain the category decision needed. Do not guess a Vendor Tab merely because the cash was found or collected during a particular activity.
12. Use the same duplicate, rollback, Excel-save/reopen, formula, link, upload, and read-back safeguards required for invoices. Receipt amount in the workbook must equal `-1 x total collected`; never enter both a positive and negative copy.
13. File the finished receipt only in the freshly resolved authoritative property location under the established receipt destination. If no receipt destination exists or its ownership is unclear, report the filing blocker instead of inventing or using a similar folder. A filing hold does not prevent a separately authorized, source-supported workbook entry.
14. Invoice Entry never sends the receipt directly. If Wes requests delivery, prepare the exact package and hand it to Email Monitor's Email Delivery workflow; require verified OfficeAssist Sent Items evidence.
15. After the exact item, current established or overridden price, and confirmed cash collection are durably recorded, send one direct sold-status handoff to the registered Marketplace task `019fb5b0-6c29-7b32-822b-aa13b5920c29`. Use dispatch id `invoice-entry-marketplace-sold-<YYYYMMDD>-<item-number>-v1` and include the stable item number, exact listing URL or listing identifier, sale date, amount, payment method, receipt number, property, and the direct Wes command as authorization evidence.
16. Marketplace owns the Facebook action. Require it to return the same dispatch id with `accepted` before action and then `confirmed`, `blocked`, or `needs Wes`. Record the result with the receipt. Do not claim or infer that Facebook was updated before Marketplace returns verification.
17. If the item number is missing, duplicated, does not map to exactly one current item/listing, or conflicts with the supplied price or listing, hold both receipt generation and the sold-status handoff. Do not guess or mark a nearby item sold.
18. Do not repeat a Marketplace handoff after a verified `confirmed` result or an ambiguous result that might have changed Facebook. Reconcile the existing dispatch and listing status first.

For `20-HM - 115 Rosebrooks Dr`, the shorthand itself supplies completed-sale evidence, cash as payment method, current established price as the amount, request date as receipt date, and explicit not-recorded treatment for buyer and collector when omitted. Resolve the receiving entity and exact item/listing from the authoritative current sale record. Any unresolved required fact remains a blocker.

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

For Statement packets, set or treat `confidence/status` as `Needs Review - Statement` and stop before insertion unless Wes has approved the exact Statement allocation rule being applied. Do not treat the statement as a single invoice or route it to a single worksheet unless a later approved Statement process explicitly allows that for the specific line item.

## Workbook Rules

- Confirm the exact target workbook before editing.
- Active project-management spreadsheets live directly under the Teams/SharePoint `Property` drive root.
- Do not look for the project-management workbook inside individual property folders such as `Owning`, `Buying`, or `Renting`.
- Copy the connector-verified workbook into the project-room working area before editing.
- Create a rollback copy before every workbook edit.
- Edit through Excel-controlled saves for `.xlsm` project workbooks.
- Verify the workbook opens cleanly before upload.
- Upload back through the Teams/SharePoint connector only after validation passes.

## Reconcile

Use Reconcile as the user-callable mode for acting on existing workbook Review rows after their intended Vendor Tab has been specified.

Authorized triggers:

- Wes directly requests `Reconcile` and identifies the exact project/property.
- An implemented Dashboard action sends an authorized handoff naming Invoice Entry mode `Reconcile`, the exact project/property, and Wes as the requester. A mode selection, preview, log entry, or button that does not actually deliver the handoff is not a trigger.
- Invoice Entry opens an active project workbook for another authorized workbook action. In that case, run Reconcile before the other workbook work.

Reconcile requires an exact project/property identity. A supplied workbook name or path is only a lookup hint; resolve the fresh authoritative workbook from the SharePoint `Property` root. If the project is missing or ambiguous, stop and report the blocker. Reconcile processes rows already present in `Review`; it does not import new packet items unless a separately authorized intake mode is also part of the request.

For Reconcile:

- use worksheet `Review`,
- use Review table `tblInvoiceReview`,
- read the request checkbox through the defined name `invoiceEntryReviewRequest`,
- require `invoiceEntryReviewRequest` to reopen in Excel as `=Review!$B$1`,
- treat `TRUE` as a visible workbook request pending,
- treat `FALSE` or blank as no checkbox request pending, but do not let that block an explicit Reconcile invocation or the authorized workbook-open trigger,
- do not use the obsolete `Review!Q2` text selector,
- read Review rows by table name and column headers, not by visible row numbers, filters, hidden rows, or fixed cell ranges.

When Reconcile is triggered:

1. Confirm the exact Teams workbook before editing.
2. Retrieve a fresh copy using the SharePoint/Teams connector.
3. Confirm the workbook has worksheet `Review`, table `tblInvoiceReview`, and defined name `invoiceEntryReviewRequest` pointing to `=Review!$B$1`. If any are missing or invalid, report that the workbook is not Reconcile-ready and make no workbook change.
4. Read `invoiceEntryReviewRequest` by defined name.
5. Read `tblInvoiceReview` by column header name regardless of the checkbox value because the authorized Reconcile trigger is sufficient.
6. Build the request packet inside the Invoice Entry process. Do not add packet formulas, scripts, or duplicate-check logic to the workbook.
7. Include the workbook identity, request timestamp, Review Row IDs, current row values, destinations, statuses, and source traceability.
8. Treat rows as eligible when `Destination Worksheet` is filled, `Review Row ID` is present, required vendor, date, amount, and source information is present, and status is not an explicit stop. When Wes invokes Reconcile, a filled `Destination Worksheet` is approval to move the row even if an older status still says `Needs Review`.
9. Exclude rows when status is `Moved`, `Hold`, `Do Not Move`, `Duplicate Risk`, or `Missing Data`, `Destination Worksheet` is blank, or required traceability is insufficient. Treat `Hold` as a hard stop until Wes changes it.
10. Perform duplicate checks before inserting anything.
11. Insert approved records only into the yellow actual-invoice section of the correct destination worksheet; never write into orange template-estimate rows.
12. Preserve formulas, formatting, tables, controls, selectors, names, and workbook links.
13. After a successful insertion, retain the Review row, correct `Status` to `Moved`, and record the destination worksheet/table and movement date in the existing review or notes field. Correct an older `Needs Review` status during the move unless Wes set the status to `Hold`.
14. Preserve excluded or uncertain rows and explain what still needs review.
15. If `invoiceEntryReviewRequest` was `TRUE`, clear it to `FALSE` only after the request has been fully handled and validation passes. If it was already `FALSE` or blank, do not change it merely because Reconcile was invoked.
16. Do not clear a `TRUE` checkbox before the request has been processed and the workbook has passed validation.
17. Create a rollback copy before editing.
18. Save through Excel, reopen cleanly, validate destination totals and `Gnatt Chart` values, confirm zero unintended workbook links, and replace the same Teams workbook only after validation passes.
19. Report the project/workbook identity and counts for moved, held, duplicate-risk, missing-data, already-moved, and failed rows. Report whether the checkbox was cleared and whether the verified workbook replaced the authoritative SharePoint copy.

## Vendor Tabs Insertion

For Vendor Tabs:

- Route only to tabs included in the Vendor Tabs rules.
- Insert invoice records only into the yellow actual-invoice section.
- Never write invoice imports into the orange template-estimate area.
- Preserve the `M1` selector behavior.
- Preserve each tab's existing template-estimate formulas.
- Validate the affected tab total and the `Gnatt Chart` source cell after insertion.
- Treat `STR` as a special case until Wes approves its final design.

## Statement Packet Handling

If a Statement packet is received:

- hold processing before workbook insertion,
- consume the extracted statement data from Doc Scan,
- do not allocate charges across projects or tabs by guesswork,
- do not insert it as one invoice into one tab,
- report that the Statement allocation process still needs design and testing unless that exact allocation rule has been approved.

This hold exists because a common invoice usually maps to one project and one tab, while a statement can contain line items for multiple projects and multiple tabs inside each project.

## Lowes Statement Operations

Lowes statements have one supported intake path:

- Doc Scan handoff processing: Doc Scan receives or is asked to process one or more Lowes statements, extracts the detail, and passes a structured Statement packet to Invoice Entry.

Do not request statement processing directly in this Invoice Entry project room or skill. If Wes or another workflow wants one statement or a set of statements processed, route the request to Doc Scan first. Invoice Entry must wait for the Doc Scan Statement packet and must not substitute its own OCR, statement extraction, or raw-PDF parsing.

Do not commit machine handoff packets, OCR scratch files, generated statement working files, review workbook copies, or temporary workbook copies merely because they supported an invoice-entry action. Preserve the original scan and final filed document in Teams/SharePoint, archive working artifacts in the Teams working archive when useful, and record the durable outcome in `working\scanned-document-action-log.md`.

For Statement handoffs:

- treat each statement as potentially containing entries for multiple projects,
- never process the whole statement as belonging to one workbook merely because one line belongs to that project,
- route each retained line by project first, then worksheet/table,
- import a line into a project workbook only when that project workbook is ready to receive that class of line,
- when a line applies to a project that is not yet ready for insertion, retain the detail in the Invoice Entry held-detail register until that project is ready,
- keep enough source traceability to import later, including statement account, statement closing date, row/reference number, transaction date, description, amount, project clue, confidence/status, and source statement path,
- do not drop, ignore, or overwrite retained statement detail merely because the current project workbook is not ready,
- when the same statement is later processed across active projects, use the held-detail register and processing logs to avoid duplicate Review or vendor-table rows.

Current rollout status: active project workbooks are being prepared for Lowe's Review/vendor-table processing. When Doc Scan supplies a structured Statement packet, Invoice Entry may iterate through ready active projects and import only the rows that apply to each ready project. Non-ready or unclear rows remain held.

## Lowes Statement Project-First Review Rule

For Lowes Statement packets:

- expect item-level rows, not transaction-summary rows, when the Lowe's statement detail shows multiple purchased or returned items under one transaction/reference number,
- preserve the shared transaction header on each item row, including statement date, transaction/posting dates, receipt/reference number, store number, PO/project clue, and source/filing paths,
- treat rows marked `Needs Review - Amount Split` or `Needs Review - Allocation` as not ready for final vendor-tab copy until amount allocation is resolved,
- route each extracted statement item by project/workbook first,
- exclude rows that clearly do not belong to the target project,
- insert statement items that certainly belong to the target project into that project's workbook `Review` table,
- also insert statement items that may belong to the target project but have project, PO, destination, mixed-tab, or allocation uncertainty into that project's workbook `Review` table,
- keep Home/non-project, clearly non-matched-project, accounting-review, and other clearly non-project lines outside project workbooks until the project/accounting status is resolved,
- exclude sales-tax-only and tax-credit-only rows from Statement insertion because tax will be calculated or allocated later by an approved spreadsheet tax method,
- do not insert Lowes statement items directly into vendor tabs during the initial packet-consumption pass,
- populate `Review[Description]` with the clean item description that will later map into the vendor-table description field,
- when Lowe's item numbers are available, use reliable Lowe's product-page matches to improve `Review[Description]`; keep statement-derived text when no reliable product match is found,
- fill `Review[Destination Worksheet]` only when the destination tab is clear for a line already matched to that project,
- leave `Review[Destination Worksheet]` blank when the line belongs or may belong to the project but the vendor tab or project proof is unclear,
- use the review/status fields to explain what is needed before the line can be copied,
- treat a filled `Destination Worksheet` as a routing recommendation, not proof that the row has already been inserted into the destination vendor table.

Moving or copying a reviewed Lowes statement row from `Review` into a vendor table happens only after the review/approval rule for that row is satisfied.

Provisional vendor-tab copy exception: if Wes explicitly authorizes post-copy review for a Statement batch, Invoice Entry may copy high-confidence Lowe's statement rows directly from `Review` into a vendor tab when project, amount, description, and destination worksheet are defensible from the packet and approved worksheet-mode rules. This is a copy-for-review, not final approval. Keep the source `Review` row, set or leave its status as `Copied - Needs Owner Verification` or another clear review status rather than `Moved`, and record the destination worksheet/table and copy date in the review or notes field. Do not use this exception for rows with unclear project, blank or guessed destination, tax-only amounts, missing/fragmented amount evidence, mixed destination items, incomplete-source-only summary rows, or an explicit stop status such as `Hold`.

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

## End-Of-Run Working File Cleanup Rule

Treat `Project Rooms\Invoice Entry\working\` as temporary workspace, not durable storage.

At the end of every Invoice Entry run, clean up the generated working files created by that run before considering the job complete.

Required end-of-run steps:

1. Preserve the authoritative source material in Teams, SharePoint, the routed email source, the filed project document, or the active project workbook as applicable.
2. Preserve durable process records in Markdown logs, packet summaries, source inventories, held-detail registers, and action logs.
3. Do not keep generated workbook backups, temporary workbook downloads, rendered page previews, generated invoice PDFs, PDF render images, machine handoff packets, packet experiments, or statement working folders in the Admin wiki Git repo merely to show how work was performed.
4. If generated working artifacts need temporary retention, move them to:
   `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Invoice Entry Working Archive`
5. Preserve the same relative folder structure when moving generated working artifacts to the Teams archive.
6. Verify the Teams copy by file count and byte total before removing the local working copy.
7. Record the Teams archive location in:
   `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\teams-working-archive-map.md`
8. After successful verification and mapping, remove the local generated working files from `Project Rooms\Invoice Entry\working\`.
9. If the run cannot safely determine whether a file is durable source material, generated output, or needed evidence, leave it in place and record the decision needed instead of deleting it.

An Invoice Entry job is not complete until its generated working files have either been removed, moved to the Teams Working Archive and mapped, or explicitly recorded as needing human review.

## Source Packet And Email Retention Rule

Invoice Entry source material is not durable Admin wiki repo content.

The Admin wiki repo should keep rules, SOP pointers, packet schemas, source inventories, action logs, archive maps, held-detail registers, review notes, and handoff records. It should not keep routed email source files, operational packet JSON/Markdown files, source attachments, generated invoice drafts, machine handoff files, or final filed project documents.

Source material should live in Teams, SharePoint, routed mailbox evidence, property folders, Office Admin folders, or the Invoice Entry Teams Working Archive.

Invoice Entry may temporarily use local copies only when needed for processing, duplicate review, workbook insertion, or traceability. After the durable outcome is logged, the source material must either remain preserved at its authoritative Teams/SharePoint/mailbox location, be filed into the correct Teams/property/Admin destination, be moved to the Invoice Entry Teams Working Archive with count/byte verification and map logging, or be recorded as needing human review.

Do not leave source packets, routed emails, attachments, generated PDFs, workbook copies, or other operational source artifacts under `Project Rooms\Invoice Entry\sources` unless Wes explicitly approves a specific file as durable repo source material.

## Completion

- Record insertion decisions, duplicate findings, and unresolved questions in the project room.
- Update `working\work-status.md` after every substantive run. Keep only current work, pending decisions, verified non-repeatable actions, blockers, and next permitted actions there; leave detailed chronology in packet and processing logs.
- Capture new reusable lessons in the project-room rules or a relevant workflow rule before completion.
- Commit durable wiki/skill changes when made.
- Do not push Git changes unless Wes says the work is finished, explicitly asks for a push, or the task defines the deliverable as final.
## Start PR Pointer

Before durable work, follow the Start PR workflow in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
