# Invoice Entry Current Work Status

Last updated: 2026-08-01

This is the authoritative current-state register for Invoice Entry. Read it before processing a handoff or opening a workbook. Packet files and processing logs remain the detailed evidence; when an older summary conflicts with this file, stop and reconcile the source before acting.

## Operating State

- Status: `Active - No Operation In Flight`
- Primary intake: direct Doc Scan or Email Monitor handoff.
- Current task: `019f3d56-b310-75c0-b084-616bfc1e9f59`.
- Canonical skill: `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`.
- Canonical skill and installed local `invoice-entry` skill were synchronized and hash-verified after standalone-monitor commit `3ddf901` on 2026-08-01.
- Backup automation `invoice-entry-to-projects-backup-heartbeat` is a standalone local cron job at noon and 4:00 PM Eastern. It has no target task and must not add quiet-check turns to this operational task.
- No external action from the prior unfinished turn requires retry.
- Do not resend an email, repeat a workbook upload, or recreate a packet solely because an older task response was delayed or missing.

## Immediate Action Queue

| Priority | Item | Current state | Next permitted action |
| --- | --- | --- | --- |
| 1 | Josh Kennedy Time Card, week ending 2026-07-31 | Payable report/invoice `PCA-JK-20260731-TENSITY-001`, 51 hours 55 minutes, `$1,250.00`; sent and verified to Wes; approval pending | Wait through Sunday for Wes to approve, correct, or deny. If no Wes decision and no sender correction exists at the first Invoice Entry check on Monday, apply `Final - No Corrections Received`, then follow normal filing and spreadsheet rules. |
| 2 | Construction Loan Services loan `77278`, July 2026, 908 Pond St V3 | `$1,658.75` due 2026-08-10; current balance `$181,141.75`; maturity 2026-09-24; no statement attachment or component breakdown | Obtain the detailed statement through Doc Scan if allocation is required and obtain accounting direction. Do not insert, approve, schedule, or pay from the email notice. |
| 3 | Trenchant Build invoice `422`, 4121 Tensity Dr | Paid once for `$5,185.71`; one Review row exists as `IE-20260801-TRENCHANT-422`; workbook upload and validation passed | Wait for Wes to choose one approved destination worksheet or approve a supported split for mixed work and the card-processing fee. Do not create another row. |
| 4 | QuickBooks Line of Credit statements `2a46fea` and `a46f130`, July 2026 | Two distinct statements, each held as `Needs Review - Statement - Accounting Allocation` | Wait for accounting direction outside property workbooks. Do not create invoices, approve payment, or insert either statement into a project workbook. |
| 5 | First Bank online statement notice, account ending `3613` | Notice verified; no statement attachment or financial details; actual statement not retrieved | Retrieve through an authorized First Bank session and route the downloaded statement through Doc Scan. Do not infer an amount, due date, project, account type, or payment obligation. |

## Verified Delivery Evidence

### Josh Kennedy Week Ending 2026-07-31

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
| Josh Kennedy Time Card, week ending 2026-07-24 | Historical documents and workbook records need reconciliation with the current payable-allocation-report design | Do not create a second payment obligation. Reconcile only under the current Time Card rule and with exact workbook duplicate checking. |
| Tim Fleming Pond invoice `IE-TF-20260717-POND-001` | Vendor confirmed, Wes approved, PDF filed | Destination worksheet remains unresolved for `Property/26_Project Management - 908 Pond St 3.xlsm`. |
| Tim Fleming multi-project package, 2026-07-21 through 2026-07-28 | Vendor verified, Wes approved, three PDFs filed, not marked paid | Workbook posting remains held. Reconfirm the exact Outrigger, Pond, and Tensity workbook paths from SharePoint before processing. |
| Sullivan Surveying invoice `2395`, 908 Pond St | Duplicate check completed; not inserted | Surveying/property due diligence has no approved destination worksheet. |
| Amazon order `111-5051554-5651422`, 4121 Tensity Dr | One Review row exists with blank destination | Wes must choose an approved worksheet for the electronic surge protector. |
| Atlantic Discount Flooring invoice `001521` | Paid invoice consolidated once; Flooring category supported | Project/property is missing. Do not file or post until Wes identifies the project. |
| QPay transaction `12365790090`, order `10651` | Paid USA Flooring receipt filed for 2156 Haig Point Way | No active root-level project workbook is confirmed. Do not substitute another workbook. |
| GTI Stone Design Square receipt `1UXR`, 4121 Tensity Dr | Paid receipt filed once | Source gives no work category. Confirm destination worksheet or authorize Review placement without a destination. |
| Lowe's held statement detail | Retained in `lowes-statement-held-detail-register.md` | Continue holding unclear, mixed, tax-only, non-project, accounting, incomplete-source, and OCR-uncertain rows until source or allocation decisions resolve them. |

## Record Reconciliation

- Josh's July 30 and July 31 Outlook sources are reconciled as separate shifts under the email-date rule.
- The week-ending 2026-07-31 queue and packet now reflect 51 hours 55 minutes and the `$1,250.00` payable Project Cost Allocation Report/invoice.
- Older non-payable language remains only as labeled historical chronology and is superseded by the 2026-08-01 Time Card rule.
- Active JSON and email-delivery evidence remains intentionally untracked until finalization; the packet records its retention and disposition rule.

## Safety Holds

- Invoice Entry does not approve or pay invoices.
- Invoice Entry does not send email directly; all delivery goes through Email Monitor's Email Delivery workflow.
- Do not retry a verified send or workbook upload without evidence that the prior action failed.
- Do not edit a live workbook without an authorized insertion or reconciliation action, a fresh SharePoint copy, a rollback copy, duplicate checks, Excel save/reopen validation, and verified upload.
- Do not guess a project, destination worksheet, split, accounting treatment, invoice identity, or missing source fact.
