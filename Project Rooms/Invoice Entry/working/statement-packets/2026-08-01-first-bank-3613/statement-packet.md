# First Bank Statement Notice Packet - Account 3613

## Packet Status

- Status: `Held - Statement Not Retrieved`
- Workflow: `Statement Processing`
- Statement issuer: First Bank
- Account owner: not established by the notice
- Account identifier: ending `3613`
- Statement period: not stated
- Statement date: not stated
- Source type: authoritative OfficeAssist Outlook notice; no attachment supplied
- Project/property: not established
- Recommended workbook: `None`
- Recommended worksheet: `Needs Accounting Review`

## Notice Facts

- First Bank reported that the latest online statement for account ending `3613` is available through First Bank online banking.
- The notice contains no statement balance, transaction detail, amount due, due date, project clue, or account type.
- The notice says online statements remain available for up to 18 months.

## Source Traceability

- Mailbox: `OfficeAssist@BuyYourHomeLLC.com`
- Outlook message ID: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACgUD9nwAAAA==`
- Received: `2026-08-01T19:34:17Z`
- Subject: `FW: Your Online Statement account ending in ******3613 is now available!`
- Original sender shown in the forwarded message: `First Bank <enotifications@localfirstbank.com>`
- Outlook link: `https://outlook.office365.com/owa/?ItemID=AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACgUD9nwAAAA%3D%3D&exvsurl=1&viewmodel=ReadMessageItem`
- Attachments: none
- Statement access named by the notice: First Bank online banking at `https://LocalFirstBank.com`, then `eStatements`
- Reconciled repeat notice handoff on 2026-08-04:
  - Dispatch id: `email-monitor-route-vendor-invoice-20260804-firstbank-3613-001`
  - Outlook message id: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggACgUD9pwAAAA==`
  - Attachments: none
  - This is supporting notice evidence for the same account-ending-3613 held item, not a statement or separate payment obligation.

## Duplicate Check

- The 2026-08-04 handoff reconciles to this existing packet rather than creating another account-3613 record.
- The two notice message ids are supporting transport/source evidence for the same unresolved statement retrieval need and must not be treated as statement transactions or payment obligations.

## Retrieval Decision

- The exact Outlook message was retrieved and verified.
- A fresh read-only browser check on 2026-08-04 reached only First Bank's public login page with a User ID field; no authenticated First Bank online-banking session or bank connector is available to this task.
- Do not attempt credential entry, MFA, account selection, or an unauthenticated statement download.
- Obtain the statement through an authorized First Bank session, then route the downloaded statement through Doc Scan for extraction and a structured Invoice Entry handoff.
- Until the statement is supplied, do not infer an amount, due date, project, account classification, payment obligation, or accounting treatment.

## Processing Decision

- Do not create an invoice or replacement statement PDF from the notice.
- Do not create a project-workbook or accounting entry.
- Do not approve, schedule, or make a payment.
- Preserve the Outlook reference and hold the item until the actual statement is available through an authorized source.

## 2026-09-01 Repeat Notice

- Message/dispatch id: `prmsg-email-monitor-route-vendor-invoice-20260901-first-bank-3613-statement-001`; payload hash `e6d58e2025229a64de9beef046066722b520b3dbb632280dfb3c271e278b0f85`.
- Outlook message ending `AClUGMGQAAAA==`, received `2026-09-01T06:18:26Z`, has no attachment or statement facts.
- Reconciled as a third availability notice for the same account-ending-3613 retrieval hold. It is not a statement or separate obligation.
- Status remains `Held - Statement Not Retrieved`.

## 2026-09-01 Later Duplicate-Source Group

- Message/dispatch id: `prmsg-email-monitor-route-vendor-invoice-20260901-first-bank-3613-statement-duplicate-002`; payload hash `195211a2da394bd6c8e642e8395a66ad4e75ae0e3b26b185f746fd056f09f292`.
- Outlook messages ending `AClUGMIQAAAA==` and `AClUGMIAAAAA==`, received together at `2026-09-01T17:18:59Z`, are duplicate transport copies of one later availability notice.
- The two-copy group was reconciled once to this existing account-ending-3613 retrieval hold. It is supporting source evidence, not a statement or separate obligation.
- No PDF or statement facts were supplied. Status remains `Held - Statement Not Retrieved`.

## 2026-09-03 Repeat Notice

- Message/dispatch id: `prmsg-email-monitor-route-vendor-invoice-20260903-first-bank-3613-statement-001`; payload hash `be909c1b30df1bff3184f41371b3b9c803b4e0818f471e1c1959e5e63ba487f9`.
- Outlook message ending `AClUGMOAAAAA==`, received `2026-09-03T04:12:10Z`, says only that the latest statement is available online.
- Reconciled as a fifth availability-notice source group for the same account-ending-3613 retrieval hold. It is not the statement or a separate obligation.
- No PDF, balance, amount due, transaction detail, entity, project, or account classification was supplied. Status remains `Held - Statement Not Retrieved`.
