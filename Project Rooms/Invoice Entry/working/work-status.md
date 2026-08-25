# Invoice Entry Current Work Status

Last updated: 2026-08-24

This is the authoritative current-state register for Invoice Entry. Read it before processing a handoff or opening a workbook. Packet files and processing logs remain the detailed evidence; when an older summary conflicts with this file, stop and reconcile the source before acting.

## Operating State

- Status: `Active - Josh August 1-15 Approved; Rosebrooks Posting And BackOffice Allocation Need Wes; Other Open Work Unchanged`
- Primary intake: direct Doc Scan or Email Monitor handoff; authorized versioned Manager Time Card packets are also supported for Time Card intake.
- Current task: `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`.
- Canonical skill: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`.
- Canonical skill and installed local `invoice-entry` skill were synchronized and recursive SHA-256 hash-verified across 10 files on 2026-08-14 after the opposite-signed Receipt posting rule, draft-first correction-review rule, and worker-versus-payee billing rule were added. Receipt documents retain positive collected amounts; workbook entries use the negative equivalent through normal invoice placement. Correctable invoice/time ambiguity is shown in a payee-and-Wes draft rather than held when one reasonable working interpretation exists. When one person's labor is billed through a contractor, the contractor remains issuer/payee and the worker is identified on the line item.
- Backup automation `invoice-entry-to-projects-backup-heartbeat` is a standalone local cron job at noon and 4:00 PM Eastern. It has no target task and must not add quiet-check turns to this operational task. Clean no-action runs archive their own execution task after recording memory; runs with a new packet, failure, blocker, or decision remain visible. The five completed no-action run tasks from 2026-08-01 through 2026-08-03 were archived on 2026-08-04.
- 2026-08-22 backup-monitor run: the central PR messaging share `\\WES-VIDEOEDITOR\BYH-PRMessaging$` denied access, so unresolved dispatches could not be authoritatively classified from the central record during this run.
- No external action from the prior unfinished turn requires retry.
- Doc Scan returned corrected item-level packets for eight visually verified PO-4121 Lowe's rows. After the initial lock cleared, a freshness-safe retry uploaded the validated workbook and the re-fetched authoritative copy passed hash and Excel read-back verification.
- Do not resend an email, repeat a workbook upload, or recreate a packet solely because an older task response was delayed or missing.
- `Reconcile` is a user-callable Invoice Entry mode as of 2026-08-04. A direct Wes request or implemented Dashboard handoff may invoke it for one exact project/property independently of the workbook checkbox. Dashboard implementation remains separately owned and is not part of this Invoice Entry change.
- Manager Time Card packet intake is enabled as of 2026-08-05. Invoice Entry accepts versioned, Wes-authorized structured packets, deduplicates by dispatch/version/canonical entry/period, and retains ownership of semimonthly invoice processing and every financial or external action. No Manager time-entry packet was supplied by the integration dispatch, so it created no invoice or time-line change.
- `Receipt` is a user-callable Invoice Entry mode as of 2026-08-14. For the current Rosebrooks Estate Sale, Wes's command `Receipt item #<item number>` confirms the exact item sold and cash collected, defaults to the item's current established Marketplace price and the request date, and assigns the receipt to `20-HM - 115 Rosebrooks Dr`. Invoice Entry then sends the exact item/listing to Marketplace for its separately owned Facebook `Sold` update. Receipt documents show the positive amount collected; project workbooks receive the negative equivalent through the normal invoice-placement workflow. Supported categories use the matching Vendor Tab, while unclear categories enter `Review` with a blank destination.

## Task Health Status

- Operation in flight: no
- Operation started at UTC: none
- Current work durably recorded: yes
- External delivery evidence recorded: yes; Josh August 1-15 approved-status package verified `2026-08-21T13:57:12Z`; Tim August 17-20 Pond correction-review draft verified `2026-08-20T22:26:05Z`; Josh full-period correction-review draft and Wes approval request remain historical verified evidence
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
- Josh's August 1-15 packet has `100 hours 25 minutes` accepted through August 15: `70 hours 25 minutes` Tensity, `11 hours 30 minutes` BackOffice, `15 hours` Rosebrooks, and `3 hours 30 minutes` Pond. The fixed semimonthly amount remains `$2,708.33`; allocation is `$1,899.20` Tensity, `$310.17` BackOffice, `$404.56` Rosebrooks, and `$94.40` Pond. Josh confirmed the exact correction-review draft on 2026-08-18. This is worker accuracy confirmation only; the verified Wes approval request remains pending. The invoice is not finalized, filed, posted, or paid.
- Josh's August 16-31 packet is open as `INV-JKLLC-20260831-001`. Accepted time through August 19 is `26 hours 30 minutes`: Pond `20 hours 30 minutes` and Rosebrooks `6 hours`. The separate August 17 3:45 PM-5:10 PM interval (`1 hour 25 minutes`) remains held unallocated because no later source ties it to one project. No draft was generated or delivered.
- Tim Fleming and Jeff's August 3-14 source is represented by one durable packet. Wes clarified that Jeff's labor is billed through Tim, so Tim is issuer/payee for all three invoices: Pond `$812.50`, Tensity `$337.50`, and Rosebrooks `$75.00`, combined `$1,225.00`. Tim verified the displayed package and four-total-hours Tensity interpretation; Wes approved that exact package. A later 2026-08-17 `I approve` reply was reconciled as corroborating duplicate approval evidence and caused no repeated action. Final approved-not-paid PDFs passed QA. Pond and Tensity were filed once and read-back verified; Rosebrooks filing is held because no established invoice folder exists. The approved-status email to Tim with Wes and Jenny copied was sent exactly once and verified at `2026-08-17T02:08:42Z`. No workbook posting or payment occurred.
- Tim asked for the August 3-14 package status, and Wes replied that Pond will pay on August 20 and Tensity/Rosebrooks on Tuesday, August 25. These are expected payment dates only. No completed-payment evidence exists, so all three invoices remain `Not Paid`.
- Tim's August 17-20 Pond invoice `IE-TF-20260820-POND-001` is approved by Wes and not paid: `18.5` hours at `$62.50`, total `$1,156.25`. The final one-page PDF passed QA, was filed once to Pond `Owning/Invoices`, and passed SharePoint read-back. A separate Wes-only approved-invoice email was sent once from OfficeAssist and Sent Items-verified; the unsent approval draft was not sent and Tim was not contacted. A duplicate-safe Review row passed local Excel, formula, VBA, link, and visual QA, but SharePoint rejected the full-workbook replacement pending explicit Wes approval; the authoritative workbook is unchanged.
- Tim's August 24 Pond source is recorded once in new open draft accumulation `IE-TF-20260824-POND-001`: `3.0` hours at `$62.50`, total `$187.50`. It does not alter the approved August 17-20 invoice. The handoff withheld vendor contact and live workbook action, so no PDF, email, filing, posting, approval, payment, or paid status occurred.
- Josh's August 18 source separately reports a bed frame sold for `$50.00` at the Rosebrooks estate sale. No receipt exists because the source does not expressly confirm collection, payment method, buyer, collector, or exact Marketplace item/listing identity.
- Lowe's SYH 6140 invoice `74830` is represented by one Doc Scan packet and four held-detail rows totaling `$111.79` before `$8.10` tax. Handwritten `908 Pond` conflicts with printed P.O. `4121`; durable duplicate search found no prior Invoice Entry record, but no target workbook was opened because the project is unresolved. Lowe's page 3 of 3 is missing from the scan. No workbook, filing, approval, payment, email, or vendor-contact action occurred.
- The 2026-08-04 First Bank account-ending-3613 repeat notice is reconciled into the existing statement packet; it did not create another statement record or downloaded file.
- The 2026-08-06 Truist credit-card notice for account ending 4528 is represented by one held statement packet. It is distinct from the 1141/1254 checking notices and contains no attachment or transaction detail.
- The 2026-08-07 Shellpoint mortgage notice for account ending 7767 is represented by one held statement packet. It contains no attachment, amount, due date, or property address; borrower and account-suffix facts are not project evidence.
- The 2026-08-08 Rushmore printed-statement mail notice is represented by one held packet. It provides no account, borrower, property, balance, amount due, due date, or statement; it cannot be merged with another mortgage record by inference.
- Sullivan Surveying invoice `2475` for 908 Pond St is represented by one durable packet and one retained source PDF. Two same-time attachment copies and the later Square payment-link source were consolidated into the same obligation. The link was preserved without opening. The printed `$387.00` total is held because the first line is `$0.50` below the exact `1.25 x $150.00` extension, and surveying/property due diligence still has no approved worksheet destination.
- The American Express August 2026 notice for Wesley Browning's account ending `61000` is represented by one held statement packet. Two five-seconds-apart Outlook copies were consolidated. Payment is due 2026-09-04, but no statement attachment, balance, minimum payment, transaction detail, entity, or project evidence was supplied.
- The 2025 Lowe's source PDFs remain unchanged at their authoritative SharePoint links. Doc Scan packet files remain under the Doc Scan Project Room. The validated Tensity workbook and rollback copy remain classified in `Invoice Entry Working Archive\Generated\2026-08-04-2025-Lowes-Tensity-Upload-Hold` as upload/rollback evidence; the authoritative workbook was uploaded and verified at `2026-08-04T18:59:07Z`.
- The corrected 2025 Lowe's packet set now has 94 rows. Fourteen source-supported rows are present once in authoritative Review tables: eight Tensity rows (`$426.32`), one Britton row (`$122.55`), and five Pond rows (`$118.24`). Twelve more supported Willowdell/Old Buckhorn rows (`$988.99`) are retained in `lowes-statement-held-detail-register.md` because those workbooks do not yet have Review tables. The Britton and Pond uploads passed freshness, Excel reopen, visual QA, exact-target replacement, and byte-for-byte read-back verification on 2026-08-13.
- Barnes Restoration invoice `4121 Tensity` is represented by one source packet and one filed SharePoint PDF. One `$4,964.04` Review row exists in the authoritative Tensity workbook with blank destination; Roofing/Exterior is outside the approved Vendor Tabs set. It is not approved, paid, or marked paid.
- Tensity stove-sale receipt `RCPT-20260814-4121-001` is represented by one processing log and one verified property-folder PDF. It records `$250.00` cash received as `Stove Sale Proceeds / Project Credit`; one opposite-signed `-$250.00` row is now verified in authoritative `Appliances / tblAppliancesInvoices`. Deposit status, buyer name, and collector remain unrecorded. No Marketplace item number was supplied, so no sold-status handoff occurred.
- Rosebrooks cleanup-cash receipt `RCPT-20260814-115-001` is represented by one processing log and one verified PDF held in `Invoice Entry Working Archive\Generated\2026-08-14-Rosebrooks-Cleanup-Cash-Receipt-Hold`. It records `$300.00` cash found during cleanup as `Cleanup Cash / Project Credit`; one opposite-signed `-$300.00` row is now verified in authoritative `Review / tblInvoiceReview` with blank destination and `Needs Review` status. Payer, collector, and deposit remain unrecorded. Property filing is held because the current `20-HM` property has no established receipt folder and the stale `19-HM` centralized folder was not used.
- Rosebrooks Estate Sale receipt `RCPT-20260814-115-002` records `$50.00` received from Nivedita by Zelle for Marketplace item `ES-20260815-003`, Wood Rolling Kitchen Cart. The verified PDF is held in `Invoice Entry Working Archive\Generated\2026-08-14-Rosebrooks-ES-003-Receipt-Hold` because no established property receipt destination exists. One opposite-signed `-$50.00` row is verified in authoritative `Review / tblInvoiceReview` with blank destination and `Needs Review`; SharePoint exact-target replacement and byte-for-byte read-back passed. Deposit remains `Not Recorded`. Marketplace confirmed the exact Facebook listing is sold, Nivedita is selected as buyer, and the payment/pickup reply was sent and verified.
- No generated Invoice Entry working artifact from this run remains unclassified in the Git working tree.

## Immediate Action Queue

| Priority | Item | Current state | Next permitted action |
| --- | --- | --- | --- |
| 1 | 2025 Lowe's statements, BYH 5997 and SYH 6140 | 18 authoritative SharePoint PDFs; no duplicate periods; BYH gaps January-April and SYH gaps January-February. Fourteen supported rows are now in authoritative Review tables: Tensity 8 / `$426.32`, Britton 1 / `$122.55`, Pond 5 / `$118.24`. Willowdell 3 / `$152.55` and Old Buckhorn 9 / `$836.44` are held because those workbooks have no Review table. | Wes should review final Vendor Tabs for inserted rows. Template to Project must make Willowdell and Old Buckhorn Review-ready before the 12 held rows can be inserted; do not insert them directly into Vendor Tabs. Remaining packet rows lack supported project routing. |
| 1A | Lowe's SYH 6140 statement closing 2026-08-02, invoice `74830` | Four non-tax rows totaling `$111.79` are retained once. Handwritten `908 Pond` conflicts with printed P.O. `4121`; `$8.10` tax is notes-only. Durable duplicate search found no prior Invoice Entry row. No workbook was opened or changed. Lowe's page 3 of 3 is missing from the scan. | Wes must identify whether invoice `74830` belongs to 908 Pond St or 4121 Tensity Dr, or provide another authoritative allocation. Then run fresh-workbook duplicate checks and insert the four rows into the selected project's Review table. |
| 2 | Josh Kennedy LLC semimonthly Time Card invoice, 2026-07-16 through 2026-07-31 | Approved by Wes with format revisions permitted; `INV-JKLLC-20260731-001`, 97 hours 5 minutes, `$2,500.00`; allocation is `$199.57` BackOffice and `$2,300.43` Tensity; revised one-page PDF sent and verified | Make only Wes-directed format changes without changing the approved invoice facts. Filing and project posting remain held until the historical weekly PDFs and existing Tensity Review row are reconciled. Approval is not payment or paid status. |
| 3 | Josh Kennedy LLC Time Card, 2026-08-01 through 2026-08-15 | Period closed; worker confirmed. Accepted time is 100 hours 25 minutes and amount is `$2,708.33`. Josh replied `I approve` to the exact correction-review draft; the separate Wes approval request was already sent and verified. | Await Wes approval. Do not resend the package, treat Josh's response as Wes approval, finalize, file, post, pay, or mark paid. |
| 3B | Josh Kennedy LLC Time Card, 2026-08-16 through 2026-08-31 | Period open. Accepted through August 19: Pond `20h30m`, Rosebrooks `6h`, total `26h30m`. August 17 3:45-5:10 PM remains held once as unallocated. No draft exists. | Clarify whether August 17 3:45-5:10 PM belongs to Pond, Rosebrooks, or a supported split. Then update the same held line and generate the correction-review draft. Do not guess. |
| 3A | Tim Fleming and Jeff hours, 2026-08-03 through 2026-08-14 | Vendor verified and approved by Wes; not paid. Pond `$812.50` expected payment August 20; Tensity `$337.50` and Rosebrooks `$75.00` expected payment August 25. Timing is not payment evidence. | Do not repeat generation, filing, or email delivery. Await verified payment evidence before marking any invoice paid. Workbook posting remains separately unauthorized. |
| 3C | Tim Fleming Pond hours, 2026-08-17 through 2026-08-20 | Approved by Wes - Not Paid. Invoice `IE-TF-20260820-POND-001`; `18.5` hours / `$1,156.25`; final PDF filed/read back and Wes-only approved copy sent/verified. Review Row ID `IE-20260824-TIM-20260820-POND` passed local QA but is not in SharePoint. | Wes must explicitly approve replacing the shared Pond workbook to complete the staged Review posting. Do not resend, refile, contact Tim, pay, or mark paid. |
| 3F | Tim Fleming Pond hours, 2026-08-24 | Open Draft Facts Recorded. Draft invoice `IE-TF-20260824-POND-001`; `3.0` hours / `$187.50`. | Accumulate future supported Tim Pond time in this packet. Generate and route a correction-review draft only when vendor contact is authorized; do not file, post, approve, pay, or mark paid. |
| 3D | Rosebrooks bed-frame sale report, 2026-08-18 | Josh reported a bed frame sold for `$50.00`; no receipt number or action was created. | Wes should confirm that money was collected, payment method, buyer or buyer-not-recorded, collector, and exact Marketplace item/listing identity. |
| 4 | Construction Loan Services loan `77278`, July 2026, 908 Pond St V3 | `$1,658.75` due 2026-08-10; current balance `$181,141.75`; maturity 2026-09-24; no statement attachment or component breakdown | Obtain the detailed statement through Doc Scan if allocation is required and obtain accounting direction. Do not insert, approve, schedule, or pay from the email notice. |
| 5 | Trenchant Build invoice `422`, 4121 Tensity Dr | Paid once for `$5,185.71`; one Review row exists as `IE-20260801-TRENCHANT-422`; workbook upload and validation passed | Wait for Wes to choose one approved destination worksheet or approve a supported split for mixed work and the card-processing fee. Do not create another row. |
| 6 | QuickBooks Line of Credit statements `2a46fea` and `a46f130`, July 2026 | Two distinct statements, each held as `Needs Review - Statement - Accounting Allocation` | Wait for accounting direction outside property workbooks. Do not create invoices, approve payment, or insert either statement into a project workbook. |
| 7 | First Bank online statement notice, account ending `3613` | Original and repeat notices reconciled; neither has a statement or financial detail; 2026-08-04 browser check reached only the public login page | Wes must sign in through an authorized First Bank session or supply the downloaded statement, then route it through Doc Scan. Do not infer an amount, due date, project, account type, or payment obligation. |
| 8 | Truist credit-card statement notice, account ending `4528` | Statement date 2026-08-05; `$3,946.94` balance; `$76.00` minimum due 2026-09-02; no attachment or transaction detail | Wes must sign in through an authorized Truist session or supply the downloaded statement. Route it through Doc Scan before allocation. Do not approve, schedule, or pay from the notice. |
| 9 | Shellpoint mortgage billing statement notice, account ending `7767` | Current monthly statement reported available online; no attachment, amount, due date, property address, or statement detail | Wes must supply the statement or retrieve it through an authorized Shellpoint session, then route it through Doc Scan. Do not infer the property from Henry Bladimir Ramos's name or the account suffix. |
| 10 | Rushmore printed mortgage statement mail notice | Statement reported in the mail with a five-to-seven-day delivery estimate; no account, borrower, property, amount, due date, or statement data | Wait for the printed statement or a copy supplied by Wes, then route it through Doc Scan. Do not access account links or infer an account or property. |
| 11 | Truist digital statement notice, checking accounts ending `1141` and `1254` | Notice verified; no attachments or statement contents; available browser sessions reached the Truist login page | Wes must sign in through an authorized Truist session or supply the downloaded statements. Route each statement through Doc Scan before Invoice Entry processes it. Do not infer balances, transactions, payment obligations, projects, or accounting treatment. |
| 12 | NCAOC Remote Public Access invoice `41247668` | `$31.98`, dated 2026-08-02, due 2026-09-01; duplicate Outlook copies consolidated; one PDF filed to general-invoice `_Needs Review`; not approved, posted, or paid | Wes should classify it as a general BackOffice/legal-research expense or assign a named project and destination. Do not create another filing or entry, and do not pay or schedule payment. |
| 13 | Sullivan Surveying invoice `2475`, 908 Pond St | Two duplicate attachment copies and one later payment-link source consolidated; source PDF retained; Square link preserved but not opened; printed total `$387.00`; first line is `$0.50` below its exact quantity-times-rate extension; not filed, posted, approved, or paid | Wes should decide whether a corrected invoice is required or the printed total remains the review amount, then choose an approved surveying/property-due-diligence worksheet or Review placement. Any payment requires separate authorization after the discrepancy is resolved. |
| 14 | American Express August 2026 statement notice, account ending `61000` | Duplicate notices consolidated; payment due 2026-09-04; no statement attachment, balance, minimum payment, transactions, fees, entity, or project detail | Wes must retrieve the statement through an authorized American Express session or supply the PDF, then route it through Doc Scan. Do not approve, schedule, or pay from the notice. |
| 15 | Mathews Flooring LLC invoice `936569`, 4121 Tensity Dr | Approved by Wes; final `$200.00` house-cleaning invoice replaced the draft in the authoritative Tensity `Owning/Invoices` folder and was sent once to Wes from OfficeAssist; both actions verified; not posted or paid | Approval and delivery are complete. Do not repeat them. Workbook entry, payment, and paid status require separate authority. |
| 16 | Capital One Quicksilver statement notice, account ending `6426` | One notice held; Jeanette Hollinger named; balance `$376.48`; minimum `$25.00`; due `2026-09-05`; no statement PDF or transaction detail | Wes must retrieve the statement through an authorized Capital One session or supply it, then route it through Doc Scan. Do not infer entity/project allocation, approve, schedule, or pay from the notice. |
| 17 | Barnes Restoration invoice `4121 Tensity`, 4121 Tensity Dr | One `$4,964.04` invoice filed and one authoritative Tensity Review row exists; status `Needs Review`; no approval or payment | Wes should choose an approved Vendor Tab or authorize the required worksheet-mode change for Roofing/Exterior. Do not create another row, approve, pay, contact the vendor, or mark paid. |
| 18 | Receipt mode - 115 Rosebrooks Dr Estate Sale | First item completed: `ES-20260815-003`, Wood Rolling Kitchen Cart, `$50.00` received from Nivedita by Zelle. Receipt `RCPT-20260814-115-002` and one `-$50.00` Rosebrooks Review row are complete and duplicate-protected. Marketplace confirmed the exact listing sold and buyer reply sent. Property filing remains held. | Do not repeat the receipt, workbook row, Facebook sold action, or buyer reply. Continue using one receipt per future exact sold item command. Record a deposit only from separate evidence. |
| 19 | Tensity stove-sale receipt `RCPT-20260814-4121-001` | Complete. One `$250.00` cash receipt was generated, QA-verified, and filed once to Tensity `Owning/Invoices`. One `-$250.00` opposite-signed row is verified in authoritative `Appliances / tblAppliancesInvoices`; exact-target upload and byte-for-byte SharePoint read-back passed. Buyer name, collector, deposit, and Marketplace item number remain unrecorded. | Do not repeat the receipt, filing, or workbook row. If the stove corresponds to a Marketplace listing, Wes may supply its item number for a separate duplicate-safe sold-status handoff. Do not record a deposit without evidence. |
| 20 | Rosebrooks cleanup-cash receipt `RCPT-20260814-115-001` | Complete for workbook posting. One `$300.00` cash receipt was generated and QA-verified; the PDF remains in the Invoice Entry working archive because no current property receipt destination is established. One `-$300.00` opposite-signed row is verified in authoritative `Review / tblInvoiceReview` with blank destination and `Needs Review`; exact-target upload and byte-for-byte SharePoint read-back passed. | Do not recreate the receipt or workbook row, invent a property filing folder, or use the stale `19-HM` folder. Review may later supply a supported category/destination. Do not record a deposit without evidence. |

## Verified Delivery Evidence

### Tim Fleming Three-Project Approved Status

- Request: `IE-EMAIL-20260816-TIM-MULTIPROJECT-APPROVED-STATUS-001`
- Sent and verified: `2026-08-17T02:08:42Z`
- Message id ending: `ACi7Uw1wAAAA==`
- From OfficeAssist to Tim; Wes and Jenny copied; BCC empty.
- Subject: `908 Pond St, 4121 Tensity Dr, and 115 Rosebrooks Dr - Tim Fleming Invoices - Approved by Wes`
- Verified approved-not-paid attachments: Pond 3,386 bytes; Tensity 3,492 bytes; Rosebrooks 3,429 bytes; all non-inline `application/pdf`.
- Pond and Tensity filed; Rosebrooks filing held; no workbook posting, payment, or paid status.

### Tim Fleming Three-Project Wes Approval Review

- Request: `IE-EMAIL-20260816-TIM-MULTIPROJECT-WES-APPROVAL-001`
- Sent and verified: `2026-08-17T01:51:33Z`
- Message id ending: `ACi7Uw1gAAAA==`
- From OfficeAssist to Wes; Jenny copied; BCC empty.
- Subject: `Invoice Approval - Tim Fleming`
- Verified attachments: Pond 3,470 bytes; Tensity 3,618 bytes; Rosebrooks 3,496 bytes; all non-inline `application/pdf`.
- Vendor verified only; awaiting Wes approval. Not finalized, filed, posted, paid, or marked paid.

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

### Josh Kennedy LLC August 1-15 Full-Period Draft And Approval Request

- Correction-review request: `IE-EMAIL-20260817-JOSH-SEMIMONTHLY-CLOSED-DRAFT-006`; sent and verified `2026-08-17T12:00:22Z`; message id ending `ACi7Uw2QAAAA==`; OfficeAssist to Josh with Wes and Jenny copied.
- Wes approval request: `IE-EMAIL-20260817-JOSH-SEMIMONTHLY-WES-APPROVAL-001`; sent and verified `2026-08-17T12:02:37Z`; message id ending `ACi7Uw2gAAAA==`; OfficeAssist to Wes with Jenny copied.
- Both deliveries carried the same non-inline PDF at 4,450 transmitted bytes. The invoice remains a draft awaiting Wes approval; no filing, posting, payment, or paid status occurred.

## Open Packets And Decisions

| Packet or record | Current state | Blocker or required decision |
| --- | --- | --- |
| Josh Kennedy separate biweekly invoice `SP-JK-20260731-001` | `Denied by Wes - Retired - Do Not Pay` | None. Retain as history only. Do not approve, file, post, pay, revive, or reuse it. The referenced recurrence automation is not installed at its recorded local path. |
| Josh Kennedy LLC semimonthly invoice `INV-JKLLC-20260731-001` | `Approved by Wes - Format Revisions Permitted`; revised PDF sent and verified | Filing and project posting remain held pending duplicate-safe reconciliation of the historical weekly PDFs and existing Tensity Review row. Approval is not payment or paid status. |
| Josh Kennedy LLC August 1-15 Time Card invoice | `Approved by Wes - Not Paid`; stable number `INV-JKLLC-20260815-001`; `$2,708.33`; final Office Admin filing and approved-status delivery verified; Tensity `$1,899.20` and Pond `$94.40` posted once to Review | Rosebrooks `$404.56` local staging passed QA, but SharePoint rejected the exact workbook overwrite; explicit Wes approval is required before retry. BackOffice `$310.17` remains held without an approved accounting destination. Do not repeat filing, Tensity/Pond posting, or email delivery. |
| Josh Kennedy LLC August 16-31 Time Card invoice | `Period Open - Accepted Through August 21 - Allocation Clarification Required`; stable number `INV-JKLLC-20260831-001`; accepted `41h00m`; held `1h25m` unallocated | August 21 Rosebrooks `6h00m` is recorded once with no inferred break. Clarify the August 17 3:45 PM-5:10 PM project allocation between Pond and Rosebrooks or provide a supported split. No draft should be generated until resolved. |
| Tim Fleming Pond invoice `IE-TF-20260820-POND-001` | `Approved by Wes - Not Paid`; `18.5` hours / `$1,156.25`; final PDF filed once and SharePoint read-back passed; Wes-only approved copy sent once and Sent Items-verified. Unsent approval draft was not sent. Review row staged locally and fully validated. | Explicit Wes approval is required before replacing the shared Pond workbook with the validated staged copy. Do not repeat PDF generation/filing or Wes delivery, send the draft, contact Tim, pay, or mark paid. |
| Tim Fleming Pond draft `IE-TF-20260824-POND-001` | `Open Draft Facts Recorded`; August 24 `3.0` hours / `$187.50`; no PDF or external action | Continue duplicate-safe accumulation. Vendor contact was expressly withheld for this intake; generate and route the correction-review draft only after authorized delivery or the applicable workflow trigger. |
| Rosebrooks bed-frame sale report | Receipt-mode hold; `$50.00` sale reported but collection facts incomplete | Confirm collection, payment method, buyer, collector, and exact item/listing before assigning a receipt number or taking workbook/Marketplace action. |
| Josh Kennedy Time Card, week ending 2026-07-24 | Historical source records consolidated into the semimonthly invoice | Do not create a second payment obligation. Reconcile the filed PDFs and Tensity Review row under exact duplicate checks before semimonthly posting. |
| Tim Fleming Pond invoice `IE-TF-20260717-POND-001` | Vendor confirmed, Wes approved, PDF filed | Destination worksheet remains unresolved for `Property/26_Project Management - 908 Pond St 3.xlsm`. |
| Tim Fleming multi-project package, 2026-07-21 through 2026-07-28 | Vendor verified, Wes approved, three PDFs filed, not marked paid | Workbook posting remains held. Reconfirm the exact Outrigger, Pond, and Tensity workbook paths from SharePoint before processing. |
| Sullivan Surveying invoice `2395`, 908 Pond St | Duplicate check completed; not inserted | Surveying/property due diligence has no approved destination worksheet. |
| Amazon order `111-5051554-5651422`, 4121 Tensity Dr | Reconcile posted the existing Review row once to `Electrical Fixtures`; the authoritative workbook upload and read-back passed. | Complete. Do not create another Review or vendor-tab row. |
| Atlantic Discount Flooring invoice `001521` | Paid invoice consolidated once; Flooring category supported | Project/property is missing. Do not file or post until Wes identifies the project. |
| QPay transaction `12365790090`, order `10651` | Paid USA Flooring receipt filed for 2156 Haig Point Way | No active root-level project workbook is confirmed. Do not substitute another workbook. |
| GTI Stone Design Square receipt `1UXR`, 4121 Tensity Dr | Paid receipt filed once | Source gives no work category. Confirm destination worksheet or authorize Review placement without a destination. |
| Lowe's held statement detail | Retained in `lowes-statement-held-detail-register.md`; includes 12 source-supported 2025 Willowdell/Old Buckhorn rows totaling `$988.99` because those workbooks lack Review tables | Continue holding unclear, mixed, tax-only, non-project, accounting, incomplete-source, OCR-uncertain, and non-ready-workbook rows. Insert the 12 ready-project rows only after Template to Project makes the exact workbooks Review-ready. |
| 2025 Lowe's project workbook processing | Tensity 8 / `$426.32`, Britton 1 / `$122.55`, and Pond 5 / `$118.24` inserted once in authoritative Review tables; all final Vendor Tabs blank | Upload and post-upload verification complete. Await Wes's final Vendor Tab decisions; do not repeat any upload or row. Willowdell and Old Buckhorn remain held rather than directly inserted. |
| Barnes Restoration invoice `4121 Tensity` | `$4,964.04`; filed once; one Tensity Review row with blank destination | Choose an approved Vendor Tab or authorize worksheet-mode handling for Roofing/Exterior. No approval, payment, vendor contact, or paid status occurred. |
| NCAOC Remote Public Access invoice `41247668` | `Needs Review - General Invoice / Accounting Allocation`; one duplicate-safe filed copy | Determine general-accounting or named-project destination. Bill-to address `2156 Haig Point Way` is not sufficient project evidence. No payment authority was granted. |
| First Bank statement notice, account ending `3613` | `Held - Statement Not Retrieved`; repeat notice consolidated | Actual statement remains unavailable. The current browser reached only the public login screen; obtain an authenticated statement and route it through Doc Scan. |
| Truist credit-card statement, account ending `4528`, statement date `2026-08-05` | `Held - Statement Not Retrieved`; notice facts preserved; no duplicate found | Actual statement remains unavailable. Obtain it through an authorized Truist session and route it through Doc Scan. Notice facts do not authorize payment, filing, or workbook/accounting entry. |
| Shellpoint mortgage billing statement, account ending `7767` | `Held - Statement Not Retrieved`; notice facts preserved; no duplicate found | Actual statement remains unavailable. Wes must supply it or retrieve it through an authorized Shellpoint session and route it through Doc Scan. Borrower and account-suffix facts do not establish a property. |
| Rushmore mortgage printed-statement mail notice | `Held - Statement Expected By Mail`; notice facts preserved; no duplicate found | Wait for the printed statement or a copy supplied by Wes, then route it through Doc Scan. Missing identifiers prevent account or property assignment. |
| Sullivan Surveying invoice `2475`, 908 Pond St | `Needs Wes - Vendor Math And Worksheet Placement`; one retained PDF; duplicate transport and later payment-link source consolidated | Decide whether Sullivan should correct the `$0.50` line-extension mismatch or the printed `$387.00` remains the review amount, and choose the approved destination in `Property/26_Project Management - 908 Pond St 3.xlsm`. The Square link is reference only; payment requires separate authorization. |
| American Express August 2026 statement, account ending `61000` | `Held - Statement Not Retrieved`; duplicate transport consolidated; due date preserved | Wes must retrieve the PDF through an authorized American Express session or supply it, then route the actual statement through Doc Scan. The notice is not the statement or payment authority. |
| Mathews Flooring LLC invoice `936569`, 4121 Tensity Dr | `Approved By Wes - Final Filed And Sent`; `$200.00` house cleaning dated 2026-08-07 | Approval, final property replacement, and final Wes delivery are complete and must not be repeated. Workbook entry, payment, and paid status remain unperformed. |
| Capital One Quicksilver statement, account ending `6426` | `Held - Statement Not Retrieved`; notice facts preserved; no duplicate found | Actual statement remains unavailable. Wes must retrieve it through an authorized Capital One session or supply it and route it through Doc Scan. Matching `$376.48`/`6426` facts in a historical receipt are only a reconciliation clue, not sufficient entity or project evidence. |
| Lowe's SYH 6140 invoice `74830`, statement closing 2026-08-02 | `Needs Wes - Project Conflict`; four item rows / `$111.79` retained once; no workbook action | Decide between handwritten `908 Pond` and printed P.O. `4121`, or provide another authoritative allocation. The scan is also missing Lowe's page 3 of 3. Do not place the rows in either workbook until the project conflict is resolved. |

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
- Sullivan Outlook messages ending `AChS2omgAAAA==` and `AChS2omwAAAA==` are duplicate transport copies of one invoice `2475`, not two obligations. Later Outlook message ending `ACizIZoQAAAA==` and dispatch `email-monitor-route-vendor-invoice-20260815-sullivan-payment-link-001` add the Square payment-link reference to that same obligation; they do not establish approval, payment, or paid status. The invoice is distinct from Sullivan invoice `2395`; the retained source and packet must be reconciled rather than recreated if rerouted.
- American Express Outlook messages ending `ACiLEHqgAAAA==` and `ACiLEHqwAAAA==` are duplicate transport copies of one August 2026 statement-availability event for account ending `61000`, not two obligations. Repeated routing must reconcile to the existing held packet; the notices do not supply the statement or payment authority.
- Wes's Outlook message ending `ACiLEHrwAAAA==`, inline image reference `936569`, and the generated Mathews Flooring LLC draft represent one `$200.00` 4121 Tensity Dr house-cleaning invoice intake. Dispatch `email-monitor-route-vendor-invoice-20260811-mathews-flooring-maria-001` is consumed; do not recreate the draft or treat the image and generated PDF as separate obligations.
- Wes approved invoice `936569` on 2026-08-12. The final replaced the draft at the same property-folder path and was sent once under request `IE-EMAIL-20260812-MATHEWS-936569-FINAL-001`. Do not repeat the replacement or delivery. Approval is not payment or paid status.
- Capital One Outlook message ending `ACiSKPKwAAAA==` creates one statement-retrieval hold for Jeanette Hollinger's Quicksilver account ending `6426`. The notice balance matches a historical QPay/USA Flooring receipt amount and the suffix matches its recorded card ending, but the statement itself is absent; do not infer transaction inclusion, entity, or full-project allocation from that coincidence.
- Josh Outlook message ending `ACifK_bAAAAA==` adds one August 12 Rosebrooks cleaning line from 7:30 AM to 4:00 PM. Dispatch `email-monitor-route-vendor-invoice-20260813-josh-time-card-001` is consumed; do not add it again if rerouted, and do not deduct a break unless a source correction states one.
- Josh Outlook message ending `ACi7Vd0AAAAA==` adds one August 15 Rosebrooks line from 8:00 AM to 11:00 AM. Dispatch `email-monitor-route-vendor-invoice-20260817-josh-time-card-aug15-001` is consumed; do not add it again if rerouted. No task description or break was inferred.
- Josh Outlook message ending `ACi7Vd1wAAAA==` confirms the exact August 1-15 correction-review draft from the worker's perspective. It is not Wes approval and does not authorize another email, finalization, filing, posting, payment, or paid status.
- Josh Outlook message ending `ACi7Vd2AAAAA==` adds August 17 Pond 8:00 AM-3:45 PM once and retains 3:45 PM-5:10 PM once as an unallocated held interval. Dispatch `email-monitor-route-vendor-invoice-20260818-josh-time-card-aug17-001` is consumed; reconcile a later clarification in place rather than adding another interval.
- Josh Outlook message ending `ACjvzcuAAAAA==` adds August 20 BackOffice 8:00 AM-3:45 PM and Tensity 3:45 PM-4:30 PM once. Dispatch `email-monitor-route-vendor-invoice-20260821-josh-time-card-aug20-001` is consumed; do not add either interval again if rerouted.
- Tim Outlook message ending `ACjvzcuQAAAA==` reports no hours but conflicts between subject date `Friday 8/21` and body date `Friday 8/12`. Dispatch `email-monitor-route-vendor-invoice-20260821-tim-hours-aug21-001` is consumed as zero-hours source evidence; it creates no payable line and does not change the existing Tim draft.
- Tim Outlook message ending `ACkJJCUAAAAA==` adds August 24 Pond `3.0` hours once for stairs secured to concrete, lock installation, and a materials list. PR message `prmsg-email-monitor-route-vendor-invoice-20260824-tim-pond-001` and dispatch `email-monitor-route-vendor-invoice-20260824-tim-pond-001` are consumed; reconcile any repeated routing into open draft `IE-TF-20260824-POND-001` rather than adding another line or modifying the approved August 17-20 invoice.
- Josh Outlook message ending `ACkJJCTgAAAA==` adds August 21 Rosebrooks 6:00 AM-12:00 PM once as six hours with no inferred break. Message `prmsg-email-monitor-route-vendor-invoice-20260824-josh-time-card-aug21-001` and dispatch `email-monitor-route-vendor-invoice-20260824-josh-time-card-aug21-001` are consumed; do not add the interval again if rerouted.

## Safety Holds

- Invoice Entry does not approve or pay invoices.
- Invoice Entry does not send email directly; all delivery goes through Email Monitor's Email Delivery workflow.
- Do not retry a verified send or workbook upload without evidence that the prior action failed.
- Do not edit a live workbook without an authorized insertion or reconciliation action, a fresh SharePoint copy, a rollback copy, duplicate checks, Excel save/reopen validation, and verified upload.
- Do not guess a project, destination worksheet, split, accounting treatment, invoice identity, or missing source fact.
