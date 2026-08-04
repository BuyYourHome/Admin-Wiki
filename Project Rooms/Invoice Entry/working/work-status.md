# Invoice Entry Current Work Status

Last updated: 2026-08-04

This is the authoritative current-state register for Invoice Entry. Read it before processing a handoff or opening a workbook. Packet files and processing logs remain the detailed evidence; when an older summary conflicts with this file, stop and reconcile the source before acting.

## Operating State

- Status: `Active - Needs Wes - 2025 Lowe's Structured Extraction Blocked`
- Primary intake: direct Doc Scan or Email Monitor handoff.
- Current task: `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`.
- Canonical skill: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`.
- Canonical skill and installed local `invoice-entry` skill were synchronized and SHA-256 hash-verified on 2026-08-04 after the user-callable Reconcile mode was added.
- Backup automation `invoice-entry-to-projects-backup-heartbeat` is a standalone local cron job at noon and 4:00 PM Eastern. It has no target task and must not add quiet-check turns to this operational task. Clean no-action runs archive their own execution task after recording memory; runs with a new packet, failure, blocker, or decision remain visible. The five completed no-action run tasks from 2026-08-01 through 2026-08-03 were archived on 2026-08-04.
- No external action from the prior unfinished turn requires retry.
- The 2025 Lowe's source inventory is complete, but line processing is blocked pending Doc Scan structured Statement packets. No workbook or external operation is in flight.
- Do not resend an email, repeat a workbook upload, or recreate a packet solely because an older task response was delayed or missing.
- `Reconcile` is a user-callable Invoice Entry mode as of 2026-08-04. A direct Wes request or implemented Dashboard handoff may invoke it for one exact project/property independently of the workbook checkbox. Dashboard implementation remains separately owned and is not part of this Invoice Entry change.

## Task Health Status

- Operation in flight: no
- Operation started at UTC: none
- Current work durably recorded: yes
- External delivery evidence recorded: yes
- Open packets and blockers current: yes
- Git and working-file state classified: yes
- Recent task timeouts: 0
- Recent stalled final responses: 1
- Recent duplicate external-action attempts: 0
- Health follow-up required: no
- Task turns observed: replacement baseline started; measure at the next Health Review
- Context compactions observed: 0 since replacement creation
- Metrics observed at UTC: 2026-08-01 rollover cutover
- Metric source: Approved Rollover completion record; the independent Windows supervisor cannot query Codex task history directly.
- Rollover status: complete; approved by Wes on 2026-08-01.
- Predecessor task: `019f3d56-b310-75c0-b084-616bfc1e9f59`.
- Replacement task: `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`; startup verification and active-routing verification passed.

The predecessor exceeded review thresholds and recently stalled after file changes. The controlled rollover completed after the replacement verified its startup state and authorized active routing references were updated. The predecessor may now be archived and must not resume operational work.

Classified working files:

- The July 16-31 semimonthly draft PDF, generation input, and visual-QA renders were archived to `Generated\2026-08-03-Josh-Semimonthly-Draft` after 4-file / 348,155-byte verification.
- The approved one-page July 16-31 invoice PDF and visual-QA render were archived to `Generated\2026-08-03-Josh-Semimonthly-Approved-Format` after 2-file / 250,796-byte and SHA-256 verification.
- The three superseded week-ending July 31 working records were archived to `Generated\2026-08-03-JK-Week31-Superseded-Working-Records` after 3-file / 5,768-byte verification.
- NCAOC Remote Public Access invoice `41247668` is represented by one durable packet and processing log. Its duplicate Outlook source copy is classified as transport evidence, and one hash-verified invoice copy is filed in the 2026 general-invoice `_Needs Review` folder.
- Josh's August 3 raw Time Card values are classified in the August 1-15 accumulated packet as a held source line with no accepted duration; no PDF or other generated artifact exists.
- The 2026-08-04 First Bank account-ending-3613 repeat notice is reconciled into the existing statement packet; it did not create another statement record or downloaded file.
- The 2025 Lowe's run created only durable Markdown inventory/log records. All 18 original statements remain at their authoritative SharePoint links; no downloaded statement, OCR artifact, packet substitute, or workbook copy was created.
- No generated Invoice Entry working artifact from this run remains unclassified in the Git working tree.

## Immediate Action Queue

| Priority | Item | Current state | Next permitted action |
| --- | --- | --- | --- |
| 1 | 2025 Lowe's statements, BYH 5997 and SYH 6140 | 18 authoritative SharePoint PDFs inventoried; no duplicate periods or existing 2025 packets found; BYH gaps January-April and SYH gaps January-February; priority project resolved to `24-HM - 4121 Tensity Dr` | Obtain item-level structured Statement packets through the registered Doc Scan workflow. Do not substitute raw-PDF extraction. Process Tensity first once entity, project, and allocation evidence supports individual lines. |
| 2 | Josh Kennedy LLC semimonthly Time Card invoice, 2026-07-16 through 2026-07-31 | Approved by Wes with format revisions permitted; `INV-JKLLC-20260731-001`, 97 hours 5 minutes, `$2,500.00`; allocation is `$199.57` BackOffice and `$2,300.43` Tensity; revised one-page PDF sent and verified | Make only Wes-directed format changes without changing the approved invoice facts. Filing and project posting remain held until the historical weekly PDFs and existing Tensity Review row are reconciled. Approval is not payment or paid status. |
| 3 | Josh Kennedy Time Card, 2026-08-03, 4121 Tensity Dr | Raw arrival `615` and departure `415`; AM/PM not stated; no duration accepted and no August 1-15 invoice generated | Obtain authorized AM/PM clarification. Amend the existing pending line; do not infer ten hours, allocate cost, generate a PDF, send a draft, file, post, or pay. |
| 4 | Construction Loan Services loan `77278`, July 2026, 908 Pond St V3 | `$1,658.75` due 2026-08-10; current balance `$181,141.75`; maturity 2026-09-24; no statement attachment or component breakdown | Obtain the detailed statement through Doc Scan if allocation is required and obtain accounting direction. Do not insert, approve, schedule, or pay from the email notice. |
| 5 | Trenchant Build invoice `422`, 4121 Tensity Dr | Paid once for `$5,185.71`; one Review row exists as `IE-20260801-TRENCHANT-422`; workbook upload and validation passed | Wait for Wes to choose one approved destination worksheet or approve a supported split for mixed work and the card-processing fee. Do not create another row. |
| 6 | QuickBooks Line of Credit statements `2a46fea` and `a46f130`, July 2026 | Two distinct statements, each held as `Needs Review - Statement - Accounting Allocation` | Wait for accounting direction outside property workbooks. Do not create invoices, approve payment, or insert either statement into a project workbook. |
| 7 | First Bank online statement notice, account ending `3613` | Original and repeat notices reconciled; neither has a statement or financial detail; 2026-08-04 browser check reached only the public login page | Wes must sign in through an authorized First Bank session or supply the downloaded statement, then route it through Doc Scan. Do not infer an amount, due date, project, account type, or payment obligation. |
| 8 | Truist digital statement notice, checking accounts ending `1141` and `1254` | Notice verified; no attachments or statement contents; available browser sessions reached the Truist login page | Wes must sign in through an authorized Truist session or supply the downloaded statements. Route each statement through Doc Scan before Invoice Entry processes it. Do not infer balances, transactions, payment obligations, projects, or accounting treatment. |
| 9 | NCAOC Remote Public Access invoice `41247668` | `$31.98`, dated 2026-08-02, due 2026-09-01; duplicate Outlook copies consolidated; one PDF filed to general-invoice `_Needs Review`; not approved, posted, or paid | Wes should classify it as a general BackOffice/legal-research expense or assign a named project and destination. Do not create another filing or entry, and do not pay or schedule payment. |

## Verified Delivery Evidence

### Josh Kennedy LLC July 16-31 Approved Revision

- Request: `IE-EMAIL-20260803-JOSH-SEMIMONTHLY-APPROVED-REVISION-001`
- Sent and verified: `2026-08-03T13:18:45Z`
- Message id ending: `ACgUDafAAAAA==`
- From OfficeAssist to Wes only; CC and BCC empty.
- Subject: `REVISED: Josh Kennedy LLC Time Card Invoice - July 16-31, 2026`
- Verified attachment: `26-07-31 - Josh Kennedy LLC - Time Card Invoice - 2026-07-16 to 2026-07-31.pdf`, non-inline `application/pdf`, 4,261 transmitted bytes; 3,805-byte source PDF.
- Approved by Wes; format-only revisions remain permitted. Not filed, posted, paid, or proof of payment.

### Josh Kennedy LLC July 16-31 Semimonthly Draft

- Request: `IE-EMAIL-20260803-JOSH-SEMIMONTHLY-DRAFT-001`
- Sent and verified: `2026-08-03T12:59:27Z`
- Message id ending: `ACgUDaewAAAA==`
- From OfficeAssist to Wes only; CC and BCC empty.
- Verified attachment: `26-07-31 - Josh Kennedy LLC - Time Card Invoice - 2026-07-16 to 2026-07-31.pdf`, non-inline `application/pdf`, 5,577 transmitted bytes.
- Draft only; not final, filed, posted, approved, paid, or proof of payment.

### Josh Kennedy Week Ending 2026-07-31

- Josh final accuracy confirmation:
  - Received: `2026-08-02T18:46:29Z`
  - Message id ending: `ACgUD9oQAAAA==`
  - Josh replied: `The above times are correct.`
  - Accuracy confirmation only; not Wes approval or payment authorization.

- Final correction-by-exception report sent to Josh with Wes and Jenny copied:
  - Request: `IE-EMAIL-20260801-JOSH-TIMECARD-FINAL-VERIFY-001`
  - Sent: `2026-08-01T14:06:42Z`
  - Message id ending: `ACgUDabgAAAA==`
- Payable report/invoice sent to Wes only:
  - Request: `IE-EMAIL-20260801-JOSH-TIMECARD-WES-APPROVAL-001`
  - Sent: `2026-08-01T17:56:29Z`
  - Message id ending: `ACgUDacAAAAA==`
  - Verified attachment: `26-07-31 - Josh Kennedy - Project Cost Allocation Report - 4121 Tensity Dr.pdf`, 4,190 bytes
  - Actual subject was `Invoice Approval - Josh Kennedy`. Future Time Card approval packages must use `Time Card Approval - <Worker Name>`. Do not resend this package only to correct the subject.

## Open Packets And Decisions

| Packet or record | Current state | Blocker or required decision |
| --- | --- | --- |
| Josh Kennedy separate biweekly invoice `SP-JK-20260731-001` | `Denied by Wes - Retired - Do Not Pay` | None. Retain as history only. Do not approve, file, post, pay, revive, or reuse it. The referenced recurrence automation is not installed at its recorded local path. |
| Josh Kennedy LLC semimonthly invoice `INV-JKLLC-20260731-001` | `Approved by Wes - Format Revisions Permitted`; revised PDF sent and verified | Filing and project posting remain held pending duplicate-safe reconciliation of the historical weekly PDFs and existing Tensity Review row. Approval is not payment or paid status. |
| Josh Kennedy LLC August 1-15 Time Card invoice | `Held - Ambiguous AM/PM - No Accepted Hours Yet`; proposed number `INV-JKLLC-20260815-001` not generated | Clarify whether raw `615` and `415` are AM or PM. Do not calculate duration or generate, send, file, post, approve, or pay an invoice from the unsupported line. |
| Josh Kennedy Time Card, week ending 2026-07-24 | Historical source records consolidated into the semimonthly invoice | Do not create a second payment obligation. Reconcile the filed PDFs and Tensity Review row under exact duplicate checks before semimonthly posting. |
| Tim Fleming Pond invoice `IE-TF-20260717-POND-001` | Vendor confirmed, Wes approved, PDF filed | Destination worksheet remains unresolved for `Property/26_Project Management - 908 Pond St 3.xlsm`. |
| Tim Fleming multi-project package, 2026-07-21 through 2026-07-28 | Vendor verified, Wes approved, three PDFs filed, not marked paid | Workbook posting remains held. Reconfirm the exact Outrigger, Pond, and Tensity workbook paths from SharePoint before processing. |
| Sullivan Surveying invoice `2395`, 908 Pond St | Duplicate check completed; not inserted | Surveying/property due diligence has no approved destination worksheet. |
| Amazon order `111-5051554-5651422`, 4121 Tensity Dr | One Review row exists with blank destination | Wes must choose an approved worksheet for the electronic surge protector. |
| Atlantic Discount Flooring invoice `001521` | Paid invoice consolidated once; Flooring category supported | Project/property is missing. Do not file or post until Wes identifies the project. |
| QPay transaction `12365790090`, order `10651` | Paid USA Flooring receipt filed for 2156 Haig Point Way | No active root-level project workbook is confirmed. Do not substitute another workbook. |
| GTI Stone Design Square receipt `1UXR`, 4121 Tensity Dr | Paid receipt filed once | Source gives no work category. Confirm destination worksheet or authorize Review placement without a destination. |
| Lowe's held statement detail | Retained in `lowes-statement-held-detail-register.md` | Continue holding unclear, mixed, tax-only, non-project, accounting, incomplete-source, and OCR-uncertain rows until source or allocation decisions resolve them. |
| NCAOC Remote Public Access invoice `41247668` | `Needs Review - General Invoice / Accounting Allocation`; one duplicate-safe filed copy | Determine general-accounting or named-project destination. Bill-to address `2156 Haig Point Way` is not sufficient project evidence. No payment authority was granted. |
| First Bank statement notice, account ending `3613` | `Held - Statement Not Retrieved`; repeat notice consolidated | Actual statement remains unavailable. The current browser reached only the public login screen; obtain an authenticated statement and route it through Doc Scan. |

## Record Reconciliation

- Josh's July 30 and July 31 Outlook sources are reconciled as separate shifts under the email-date rule.
- Wes's 2026-08-03 rule supersedes the weekly payable-report presentation and the Monday automatic-finalization rule.
- Invoice `INV-JKLLC-20260731-001` consolidates the accepted July 20-31 records into the July 16-31 semimonthly period without duplicating source lines or reviving denied invoice `SP-JK-20260731-001`.
- Wes approved `INV-JKLLC-20260731-001` on 2026-08-03. The approved one-page revision changed presentation only; the invoice number, period, accepted time, allocations, and amount remained unchanged.
- Earlier weekly PDFs, emails, and workbook rows remain historical evidence and require duplicate-safe reconciliation before any new posting.
- NCAOC Outlook messages ending `ACgUD9pgAAAA==` and `ACgUD9pQAAAA==` represent one invoice `41247668`, not two obligations. One hash-verified review-folder copy exists; do not repeat filing or create a second entry.
- Josh Outlook message ending `ACgUD9qAAAAA==` creates one pending August 3 source line with raw `615` to `415` values and no accepted duration. A later clarification must amend that line rather than add another.
- First Bank Outlook messages ending `ACgUD9nwAAAA==` and `ACgUD9pwAAAA==` reconcile to one account-ending-3613 retrieval hold; neither is the statement or a payment obligation.

## Safety Holds

- Invoice Entry does not approve or pay invoices.
- Invoice Entry does not send email directly; all delivery goes through Email Monitor's Email Delivery workflow.
- Do not retry a verified send or workbook upload without evidence that the prior action failed.
- Do not edit a live workbook without an authorized insertion or reconciliation action, a fresh SharePoint copy, a rollback copy, duplicate checks, Excel save/reopen validation, and verified upload.
- Do not guess a project, destination worksheet, split, accounting treatment, invoice identity, or missing source fact.
