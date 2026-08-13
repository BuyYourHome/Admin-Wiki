# Invoice Entry Current Work Status

Last updated: 2026-08-12

This is the authoritative current-state register for Invoice Entry. Read it before processing a handoff or opening a workbook. Packet files and processing logs remain the detailed evidence; when an older summary conflicts with this file, stop and reconcile the source before acting.

## Operating State

- Status: `Active - Josh August 1-15 Time Card Accumulating`
- Primary intake: direct Doc Scan or Email Monitor handoff; authorized versioned Manager Time Card packets are also supported for Time Card intake.
- Current task: `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`.
- Canonical skill: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`.
- Canonical skill and installed local `invoice-entry` skill were synchronized and SHA-256 hash-verified on 2026-08-12 after the semimonthly compensation calculation and invoice-column layout were corrected.
- Backup automation `invoice-entry-to-projects-backup-heartbeat` is a standalone local cron job at noon and 4:00 PM Eastern. It has no target task and must not add quiet-check turns to this operational task. Clean no-action runs archive their own execution task after recording memory; runs with a new packet, failure, blocker, or decision remain visible. The five completed no-action run tasks from 2026-08-01 through 2026-08-03 were archived on 2026-08-04.
- No external action from the prior unfinished turn requires retry.
- Doc Scan returned corrected item-level packets for eight visually verified PO-4121 Lowe's rows. After the initial lock cleared, a freshness-safe retry uploaded the validated workbook and the re-fetched authoritative copy passed hash and Excel read-back verification.
- Do not resend an email, repeat a workbook upload, or recreate a packet solely because an older task response was delayed or missing.
- `Reconcile` is a user-callable Invoice Entry mode as of 2026-08-04. A direct Wes request or implemented Dashboard handoff may invoke it for one exact project/property independently of the workbook checkbox. Dashboard implementation remains separately owned and is not part of this Invoice Entry change.
- Manager Time Card packet intake is enabled as of 2026-08-05. Invoice Entry accepts versioned, Wes-authorized structured packets, deduplicates by dispatch/version/canonical entry/period, and retains ownership of semimonthly invoice processing and every financial or external action. No Manager time-entry packet was supplied by the integration dispatch, so it created no invoice or time-line change.

## Task Health Status

- Operation in flight: no
- Operation started at UTC: none
- Current work durably recorded: yes
- External delivery evidence recorded: yes; latest Josh daily draft verified `2026-08-13T13:12:46Z`
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
- Josh's August 1-15 packet has `77 hours 55 minutes` accepted through August 11: `70 hours 25 minutes` Tensity, `4 hours` BackOffice, and `3 hours 30 minutes` Rosebrooks. Wes corrected the compensation basis to `$65,000.00 / 24`, making the open-period invoice amount `$2,708.33` instead of `$2,500.00`; the current allocation is `$2,447.64` Tensity, `$139.04` BackOffice, and `$121.65` Rosebrooks. The final-style presentation package was archived after 3-file / 191,160-byte verification.
- The 2026-08-04 First Bank account-ending-3613 repeat notice is reconciled into the existing statement packet; it did not create another statement record or downloaded file.
- The 2026-08-06 Truist credit-card notice for account ending 4528 is represented by one held statement packet. It is distinct from the 1141/1254 checking notices and contains no attachment or transaction detail.
- The 2026-08-07 Shellpoint mortgage notice for account ending 7767 is represented by one held statement packet. It contains no attachment, amount, due date, or property address; borrower and account-suffix facts are not project evidence.
- The 2026-08-08 Rushmore printed-statement mail notice is represented by one held packet. It provides no account, borrower, property, balance, amount due, due date, or statement; it cannot be merged with another mortgage record by inference.
- Sullivan Surveying invoice `2475` for 908 Pond St is represented by one durable packet and one retained source PDF. Two same-time Outlook copies were consolidated. The printed `$387.00` total is held because the first line is `$0.50` below the exact `1.25 x $150.00` extension, and surveying/property due diligence still has no approved worksheet destination.
- The American Express August 2026 notice for Wesley Browning's account ending `61000` is represented by one held statement packet. Two five-seconds-apart Outlook copies were consolidated. Payment is due 2026-09-04, but no statement attachment, balance, minimum payment, transaction detail, entity, or project evidence was supplied.
- The 2025 Lowe's source PDFs remain unchanged at their authoritative SharePoint links. Doc Scan packet files remain under the Doc Scan Project Room. The validated Tensity workbook and rollback copy remain classified in `Invoice Entry Working Archive\Generated\2026-08-04-2025-Lowes-Tensity-Upload-Hold` as upload/rollback evidence; the authoritative workbook was uploaded and verified at `2026-08-04T18:59:07Z`.
- No generated Invoice Entry working artifact from this run remains unclassified in the Git working tree.

## Immediate Action Queue

| Priority | Item | Current state | Next permitted action |
| --- | --- | --- | --- |
| 1 | 2025 Lowe's statements, BYH 5997 and SYH 6140 | 18 authoritative SharePoint PDFs inventoried; no duplicate periods; BYH gaps January-April and SYH gaps January-February. Eight PO-4121 items totaling `$426.32` from two BYH statements are now in the authoritative Tensity Review table with blank destinations and `Needs Review` status. | Wes should review and specify or approve final Vendor Tabs for the eight Tensity rows. Continue other project routing only from supported packet evidence. |
| 2 | Josh Kennedy LLC semimonthly Time Card invoice, 2026-07-16 through 2026-07-31 | Approved by Wes with format revisions permitted; `INV-JKLLC-20260731-001`, 97 hours 5 minutes, `$2,500.00`; allocation is `$199.57` BackOffice and `$2,300.43` Tensity; revised one-page PDF sent and verified | Make only Wes-directed format changes without changing the approved invoice facts. Filing and project posting remain held until the historical weekly PDFs and existing Tensity Review row are reconciled. Approval is not payment or paid status. |
| 3 | Josh Kennedy LLC Time Card, 2026-08-01 through 2026-08-15 | Accepted time through August 12 is 86 hours 25 minutes: 70 hours 25 minutes Tensity, 4 hours BackOffice, and 12 hours Rosebrooks. Amount remains `$2,708.33`; allocation is `$2,206.89` Tensity, `$125.36` BackOffice, and `$376.08` Rosebrooks. Updated draft sent once and verified. | Continue accumulating through August 15. Do not finalize, file, post, approve, or treat the invoice as payable before the period closes and Wes approves it. |
| 4 | Construction Loan Services loan `77278`, July 2026, 908 Pond St V3 | `$1,658.75` due 2026-08-10; current balance `$181,141.75`; maturity 2026-09-24; no statement attachment or component breakdown | Obtain the detailed statement through Doc Scan if allocation is required and obtain accounting direction. Do not insert, approve, schedule, or pay from the email notice. |
| 5 | Trenchant Build invoice `422`, 4121 Tensity Dr | Paid once for `$5,185.71`; one Review row exists as `IE-20260801-TRENCHANT-422`; workbook upload and validation passed | Wait for Wes to choose one approved destination worksheet or approve a supported split for mixed work and the card-processing fee. Do not create another row. |
| 6 | QuickBooks Line of Credit statements `2a46fea` and `a46f130`, July 2026 | Two distinct statements, each held as `Needs Review - Statement - Accounting Allocation` | Wait for accounting direction outside property workbooks. Do not create invoices, approve payment, or insert either statement into a project workbook. |
| 7 | First Bank online statement notice, account ending `3613` | Original and repeat notices reconciled; neither has a statement or financial detail; 2026-08-04 browser check reached only the public login page | Wes must sign in through an authorized First Bank session or supply the downloaded statement, then route it through Doc Scan. Do not infer an amount, due date, project, account type, or payment obligation. |
| 8 | Truist credit-card statement notice, account ending `4528` | Statement date 2026-08-05; `$3,946.94` balance; `$76.00` minimum due 2026-09-02; no attachment or transaction detail | Wes must sign in through an authorized Truist session or supply the downloaded statement. Route it through Doc Scan before allocation. Do not approve, schedule, or pay from the notice. |
| 9 | Shellpoint mortgage billing statement notice, account ending `7767` | Current monthly statement reported available online; no attachment, amount, due date, property address, or statement detail | Wes must supply the statement or retrieve it through an authorized Shellpoint session, then route it through Doc Scan. Do not infer the property from Henry Bladimir Ramos's name or the account suffix. |
| 10 | Rushmore printed mortgage statement mail notice | Statement reported in the mail with a five-to-seven-day delivery estimate; no account, borrower, property, amount, due date, or statement data | Wait for the printed statement or a copy supplied by Wes, then route it through Doc Scan. Do not access account links or infer an account or property. |
| 11 | Truist digital statement notice, checking accounts ending `1141` and `1254` | Notice verified; no attachments or statement contents; available browser sessions reached the Truist login page | Wes must sign in through an authorized Truist session or supply the downloaded statements. Route each statement through Doc Scan before Invoice Entry processes it. Do not infer balances, transactions, payment obligations, projects, or accounting treatment. |
| 12 | NCAOC Remote Public Access invoice `41247668` | `$31.98`, dated 2026-08-02, due 2026-09-01; duplicate Outlook copies consolidated; one PDF filed to general-invoice `_Needs Review`; not approved, posted, or paid | Wes should classify it as a general BackOffice/legal-research expense or assign a named project and destination. Do not create another filing or entry, and do not pay or schedule payment. |
| 13 | Sullivan Surveying invoice `2475`, 908 Pond St | Two duplicate Outlook copies consolidated; source PDF retained; printed total `$387.00`; first line is `$0.50` below its exact quantity-times-rate extension; not filed, posted, approved, or paid | Wes should decide whether a corrected invoice is required or the printed total remains the review amount, then choose an approved surveying/property-due-diligence worksheet or Review placement. |
| 14 | American Express August 2026 statement notice, account ending `61000` | Duplicate notices consolidated; payment due 2026-09-04; no statement attachment, balance, minimum payment, transactions, fees, entity, or project detail | Wes must retrieve the statement through an authorized American Express session or supply the PDF, then route it through Doc Scan. Do not approve, schedule, or pay from the notice. |
| 15 | Mathews Flooring LLC invoice `936569`, 4121 Tensity Dr | Approved by Wes; final `$200.00` house-cleaning invoice replaced the draft in the authoritative Tensity `Owning/Invoices` folder and was sent once to Wes from OfficeAssist; both actions verified; not posted or paid | Approval and delivery are complete. Do not repeat them. Workbook entry, payment, and paid status require separate authority. |
| 16 | Capital One Quicksilver statement notice, account ending `6426` | One notice held; Jeanette Hollinger named; balance `$376.48`; minimum `$25.00`; due `2026-09-05`; no statement PDF or transaction detail | Wes must retrieve the statement through an authorized Capital One session or supply it, then route it through Doc Scan. Do not infer entity/project allocation, approve, schedule, or pay from the notice. |

## Verified Delivery Evidence

### Mathews Flooring LLC Invoice 936569 Draft

- Request: `IE-EMAIL-20260812-MATHEWS-936569-WES-REVIEW-001`
- Sent and verified: `2026-08-12T09:12:21Z`
- Message id ending: `ACiSJqAQAAAA==`
- From OfficeAssist to Wes only; CC and BCC empty.
- Subject: `DRAFT: Mathews Flooring LLC Invoice 936569 - 4121 Tensity Dr`
- Verified attachment: `26-08-07 - Mathews Flooring LLC - Invoice 936569 - 4121 Tensity Dr.pdf`, non-inline `application/pdf`, 3,671 transmitted bytes.
- Filed and read-back verified at `Property/24-HM - 4121 Tensity Dr/Owning/Invoices` before delivery completion. Draft only; not posted, approved, paid, or proof of payment.

### Mathews Flooring LLC Invoice 936569 Final

- Request: `IE-EMAIL-20260812-MATHEWS-936569-FINAL-001`
- Sent and verified: `2026-08-12T09:19:30Z`
- Message id ending: `ACiSJqAgAAAA==`
- From OfficeAssist to Wes only; CC and BCC empty.
- Subject: `FINAL: Mathews Flooring LLC Invoice 936569 - 4121 Tensity Dr`
- Verified attachment: `26-08-07 - Mathews Flooring LLC - Invoice 936569 - 4121 Tensity Dr.pdf`, non-inline `application/pdf`, 3,594 transmitted bytes.
- The final approved PDF replaced the property-folder draft at the same SharePoint item and passed read-back verification. Approved and filed; not posted, paid, or proof of payment.

### Josh Kennedy LLC July 16-31 Approved Revision

- Request: `IE-EMAIL-20260803-JOSH-SEMIMONTHLY-APPROVED-REVISION-001`
- Sent and verified: `2026-08-03T13:18:45Z`
- Message id ending: `ACgUDafAAAAA==`
- From OfficeAssist to Wes only; CC and BCC empty.
- Subject: `REVISED: Josh Kennedy LLC Time Card Invoice - July 16-31, 2026`
- Verified attachment: `26-07-31 - Josh Kennedy LLC - Time Card Invoice - 2026-07-16 to 2026-07-31.pdf`, non-inline `application/pdf`, 4,261 transmitted bytes; 3,805-byte source PDF.
- Approved by Wes; format-only revisions remain permitted. Not filed, posted, paid, or proof of payment.

### Josh Kennedy LLC August 1-15 Daily Draft Through August 10

- Request: `IE-EMAIL-20260811-JOSH-SEMIMONTHLY-DAILY-DRAFT-001`
- Sent and verified: `2026-08-11T21:51:43Z`
- Message id ending: `ACiLFEUQAAAA==`
- From OfficeAssist to `IRAManager@SellYourHomeRaleigh.com`; Wes and Jenny copied; BCC empty.
- Subject: `DRAFT: Josh Kennedy LLC Time Card Invoice - August 1-15, 2026 (Through August 10)`
- Verified attachment: `26-08-15 - Josh Kennedy LLC - Time Card Invoice - 2026-08-01 to 2026-08-15.pdf`, non-inline `application/pdf`, 3,761 transmitted bytes; 3,305-byte source PDF.
- Draft only; period remains open. Not final, filed, posted, approved, paid, or proof of payment.

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
| Josh Kennedy LLC August 1-15 Time Card invoice | `Accumulating - Period Open - August 12 Draft Sent`; stable number `INV-JKLLC-20260815-001`; 86 hours 25 minutes accepted through August 12; amount `$2,708.33`; delivery verified | Continue source-supported accumulation and reconcile corrections in place. Period closes August 15; no finalization, filing, posting, approval, payment, or paid status before close and Wes approval. |
| Josh Kennedy Time Card, week ending 2026-07-24 | Historical source records consolidated into the semimonthly invoice | Do not create a second payment obligation. Reconcile the filed PDFs and Tensity Review row under exact duplicate checks before semimonthly posting. |
| Tim Fleming Pond invoice `IE-TF-20260717-POND-001` | Vendor confirmed, Wes approved, PDF filed | Destination worksheet remains unresolved for `Property/26_Project Management - 908 Pond St 3.xlsm`. |
| Tim Fleming multi-project package, 2026-07-21 through 2026-07-28 | Vendor verified, Wes approved, three PDFs filed, not marked paid | Workbook posting remains held. Reconfirm the exact Outrigger, Pond, and Tensity workbook paths from SharePoint before processing. |
| Sullivan Surveying invoice `2395`, 908 Pond St | Duplicate check completed; not inserted | Surveying/property due diligence has no approved destination worksheet. |
| Amazon order `111-5051554-5651422`, 4121 Tensity Dr | Reconcile posted the existing Review row once to `Electrical Fixtures`; the authoritative workbook upload and read-back passed. | Complete. Do not create another Review or vendor-tab row. |
| Atlantic Discount Flooring invoice `001521` | Paid invoice consolidated once; Flooring category supported | Project/property is missing. Do not file or post until Wes identifies the project. |
| QPay transaction `12365790090`, order `10651` | Paid USA Flooring receipt filed for 2156 Haig Point Way | No active root-level project workbook is confirmed. Do not substitute another workbook. |
| GTI Stone Design Square receipt `1UXR`, 4121 Tensity Dr | Paid receipt filed once | Source gives no work category. Confirm destination worksheet or authorize Review placement without a destination. |
| Lowe's held statement detail | Retained in `lowes-statement-held-detail-register.md` | Continue holding unclear, mixed, tax-only, non-project, accounting, incomplete-source, and OCR-uncertain rows until source or allocation decisions resolve them. |
| 2025 Lowe's Tensity upload | Eight rows / `$426.32` inserted in authoritative Review; eligible Amazon row posted once to Electrical Fixtures | Upload and post-upload verification complete. Await Wes's final Vendor Tab decisions for the eight Lowe's rows; do not repeat the upload. |
| NCAOC Remote Public Access invoice `41247668` | `Needs Review - General Invoice / Accounting Allocation`; one duplicate-safe filed copy | Determine general-accounting or named-project destination. Bill-to address `2156 Haig Point Way` is not sufficient project evidence. No payment authority was granted. |
| First Bank statement notice, account ending `3613` | `Held - Statement Not Retrieved`; repeat notice consolidated | Actual statement remains unavailable. The current browser reached only the public login screen; obtain an authenticated statement and route it through Doc Scan. |
| Truist credit-card statement, account ending `4528`, statement date `2026-08-05` | `Held - Statement Not Retrieved`; notice facts preserved; no duplicate found | Actual statement remains unavailable. Obtain it through an authorized Truist session and route it through Doc Scan. Notice facts do not authorize payment, filing, or workbook/accounting entry. |
| Shellpoint mortgage billing statement, account ending `7767` | `Held - Statement Not Retrieved`; notice facts preserved; no duplicate found | Actual statement remains unavailable. Wes must supply it or retrieve it through an authorized Shellpoint session and route it through Doc Scan. Borrower and account-suffix facts do not establish a property. |
| Rushmore mortgage printed-statement mail notice | `Held - Statement Expected By Mail`; notice facts preserved; no duplicate found | Wait for the printed statement or a copy supplied by Wes, then route it through Doc Scan. Missing identifiers prevent account or property assignment. |
| Sullivan Surveying invoice `2475`, 908 Pond St | `Needs Wes - Vendor Math And Worksheet Placement`; one retained PDF; duplicate transport consolidated | Decide whether Sullivan should correct the `$0.50` line-extension mismatch or the printed `$387.00` remains the review amount, and choose the approved destination in `Property/26_Project Management - 908 Pond St 3.xlsm`. |
| American Express August 2026 statement, account ending `61000` | `Held - Statement Not Retrieved`; duplicate transport consolidated; due date preserved | Wes must retrieve the PDF through an authorized American Express session or supply it, then route the actual statement through Doc Scan. The notice is not the statement or payment authority. |
| Mathews Flooring LLC invoice `936569`, 4121 Tensity Dr | `Approved By Wes - Final Filed And Sent`; `$200.00` house cleaning dated 2026-08-07 | Approval, final property replacement, and final Wes delivery are complete and must not be repeated. Workbook entry, payment, and paid status remain unperformed. |
| Capital One Quicksilver statement, account ending `6426` | `Held - Statement Not Retrieved`; notice facts preserved; no duplicate found | Actual statement remains unavailable. Wes must retrieve it through an authorized Capital One session or supply it and route it through Doc Scan. Matching `$376.48`/`6426` facts in a historical receipt are only a reconciliation clue, not sufficient entity or project evidence. |

## Record Reconciliation

- Josh's July 30 and July 31 Outlook sources are reconciled as separate shifts under the email-date rule.
- Wes's 2026-08-03 rule supersedes the weekly payable-report presentation and the Monday automatic-finalization rule.
- Invoice `INV-JKLLC-20260731-001` consolidates the accepted July 20-31 records into the July 16-31 semimonthly period without duplicating source lines or reviving denied invoice `SP-JK-20260731-001`.
- Wes approved `INV-JKLLC-20260731-001` on 2026-08-03. The approved one-page revision changed presentation only; the invoice number, period, accepted time, allocations, and amount remained unchanged.
- Earlier weekly PDFs, emails, and workbook rows remain historical evidence and require duplicate-safe reconciliation before any new posting.
- NCAOC Outlook messages ending `ACgUD9pgAAAA==` and `ACgUD9pQAAAA==` represent one invoice `41247668`, not two obligations. One hash-verified review-folder copy exists; do not repeat filing or create a second entry.
- Josh Outlook message ending `ACgUD9qAAAAA==` created one August 3 source line. Messages ending `ACgUD9qgAAAA==` and `ACgUD9qwAAAA==` clarify that same line to 6:15 AM-4:15 PM and add August 4 once; they do not create duplicate time sets.
- Josh Outlook message ending `AChS2okAAAAA==` adds one August 5 Tensity line from 6:00 AM to 2:40 PM. Dispatch `email-monitor-route-vendor-invoice-20260806-josh-timecard-aug5-001` is consumed; do not add it again if rerouted.
- Josh Outlook message ending `AChS2okgAAAA==` adds one August 6 Tensity line from 6:00 AM to 3:30 PM. The original task-message attempt did not appear, so the same-id retry was processed once. Dispatch `email-monitor-route-vendor-invoice-20260807-josh-timecard-aug6-001` is now consumed; do not add it again.
- Josh Outlook message ending `AChS2okwAAAA==` and dispatch `email-monitor-route-vendor-invoice-20260807-josh-timecard-aug6-duplicate-002` repeat the accepted August 6 facts exactly. They are supporting duplicate evidence only and do not change the line or period totals.
- Josh Outlook message ending `AChS2olgAAAA==` adds one August 2 Tensity line from 6:00 AM to 4:15 PM. Dispatch `email-monitor-route-vendor-invoice-20260808-josh-timecard-aug2-001` is consumed; do not add it again if rerouted.
- Josh Outlook message ending `AChS2onAAAAA==` adds one August 7 Tensity line from 6:00 AM to 4:15 PM. The prior task-message attempt was absent, so dispatch `email-monitor-route-vendor-invoice-20260808-josh-timecard-aug7-001` was processed once and is consumed; do not add it again if rerouted.
- Josh Outlook message ending `ACh9Ye9QAAAA==` adds one August 10 Tensity line from 6:00 AM to 6:15 PM. Dispatch `email-monitor-route-vendor-invoice-20260811-josh-timecard-aug10-001` is consumed; do not add it again if rerouted.
- Josh Outlook message ending `ACiLEHrgAAAA==` adds two August 11 lines totaling 9 hours 15 minutes: 3 hours 30 minutes at 115 Rosebrooks Dr and 5 hours 45 minutes at 4121 Tensity Dr. The source omitted the work date, so the Eastern received date is used under the canonical rule and identified in the review email. Dispatch `email-monitor-route-vendor-invoice-20260811-josh-timecard-aug11-001` is consumed; reconcile any later date correction in place and do not duplicate the intervals.
- First Bank Outlook messages ending `ACgUD9nwAAAA==` and `ACgUD9pwAAAA==` reconcile to one account-ending-3613 retrieval hold; neither is the statement or a payment obligation.
- Truist Outlook message ending `AChS2okQAAAA==` creates one distinct credit-card statement retrieval hold for account ending `4528`, statement date `2026-08-05`. It does not overlap the checking-account packet for `1141` and `1254` and is not payment authority.
- Shellpoint Outlook message ending `AChS2olAAAAA==` creates one distinct mortgage billing-statement retrieval hold for account ending `7767`. It supplies no statement, property address, amount, or due date and is not payment authority.
- Rushmore Outlook message ending `AChS2olwAAAA==` creates one distinct printed-statement mail hold. It supplies no account, borrower, property, balance, amount due, due date, or statement and is not payment authority.
- Sullivan Outlook messages ending `AChS2omgAAAA==` and `AChS2omwAAAA==` are duplicate transport copies of one invoice `2475`, not two obligations. The invoice is distinct from Sullivan invoice `2395`; the retained source and packet must be reconciled rather than recreated if rerouted.
- American Express Outlook messages ending `ACiLEHqgAAAA==` and `ACiLEHqwAAAA==` are duplicate transport copies of one August 2026 statement-availability event for account ending `61000`, not two obligations. Repeated routing must reconcile to the existing held packet; the notices do not supply the statement or payment authority.
- Wes's Outlook message ending `ACiLEHrwAAAA==`, inline image reference `936569`, and the generated Mathews Flooring LLC draft represent one `$200.00` 4121 Tensity Dr house-cleaning invoice intake. Dispatch `email-monitor-route-vendor-invoice-20260811-mathews-flooring-maria-001` is consumed; do not recreate the draft or treat the image and generated PDF as separate obligations.
- Wes approved invoice `936569` on 2026-08-12. The final replaced the draft at the same property-folder path and was sent once under request `IE-EMAIL-20260812-MATHEWS-936569-FINAL-001`. Do not repeat the replacement or delivery. Approval is not payment or paid status.
- Capital One Outlook message ending `ACiSKPKwAAAA==` creates one statement-retrieval hold for Jeanette Hollinger's Quicksilver account ending `6426`. The notice balance matches a historical QPay/USA Flooring receipt amount and the suffix matches its recorded card ending, but the statement itself is absent; do not infer transaction inclusion, entity, or full-project allocation from that coincidence.
- Josh Outlook message ending `ACifK_bAAAAA==` adds one August 12 Rosebrooks cleaning line from 7:30 AM to 4:00 PM. Dispatch `email-monitor-route-vendor-invoice-20260813-josh-time-card-001` is consumed; do not add it again if rerouted, and do not deduct a break unless a source correction states one.

## Safety Holds

- Invoice Entry does not approve or pay invoices.
- Invoice Entry does not send email directly; all delivery goes through Email Monitor's Email Delivery workflow.
- Do not retry a verified send or workbook upload without evidence that the prior action failed.
- Do not edit a live workbook without an authorized insertion or reconciliation action, a fresh SharePoint copy, a rollback copy, duplicate checks, Excel save/reopen validation, and verified upload.
- Do not guess a project, destination worksheet, split, accounting treatment, invoice identity, or missing source fact.
