# Rushmore Mortgage Statement Mail Notice Packet

## Packet Status

- Status: `Held - Statement Expected By Mail`
- Workflow: `Statement Processing`
- Statement servicer: Rushmore Servicing, NMLS #3030
- Account identifier: not stated
- Borrower: not stated
- Statement date: not stated
- Statement period: not stated
- Source type: authoritative OfficeAssist Outlook notice; no attachment supplied
- Project/property: not established
- Recommended workbook: `None`
- Recommended worksheet: `Needs Accounting Review`

## Notice Facts

- Rushmore says a printed mortgage statement is being delivered by mail and should arrive in five to seven days.
- The email offers account and application links but contains no statement data.
- The notice contains no account suffix, borrower, property address, statement PDF, balance, amount due, due date, transaction or loan detail, project allocation, payment authorization, or proof of payment.

## Source Traceability

- Dispatch id: `email-monitor-route-vendor-invoice-20260808-rushmore-statement-mail-001`
- Mailbox: `OfficeAssist@BuyYourHomeLLC.com`
- Outlook message ID: `AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggAChS2olwAAAA==`
- Received: `2026-08-08T19:10:23Z`
- Subject: `FW: Please open: Your new statement is being delivered to your mailbox`
- Forwarding sender: `WesWill@BuyYourHomeLLC.com`
- Recipients: `Jenny@BuyYourHomeLLC.com`; `OfficeAssist@BuyYourHomeLLC.com`
- Outlook link: `https://outlook.office365.com/owa/?ItemID=AQMkADZkMGMwNDI3LWU5ZjctNDgzMC1iMjdkLTY0NmRiN2IwNmIyZgBGAAADKGOvWJYjX0aEKaRpd0MYQQcAVSXargQY20aF7RLCkro4ggAAAgEMAAAAVSXargQY20aF7RLCkro4ggAChS2olwAAAA%3D%3D&exvsurl=1&viewmodel=ReadMessageItem`
- Attachments: none

## Duplicate Check

- No prior Invoice Entry record matched the exact Outlook message ID, exact dispatch id, Rushmore Servicing, NMLS #3030, or the printed-statement mail notice.
- The missing account, borrower, and property identifiers prevent reconciliation to a specific existing mortgage account or project. Do not merge it with another servicer packet by inference.
- If this notice is routed again, reconcile it to this packet instead of creating another statement record or payment obligation.

## Retrieval Decision

- The actual statement was not supplied. The notice says a printed copy should arrive by mail in five to seven days.
- Wait for the printed statement or for Wes to supply the actual statement through an authorized source. Route the document through Doc Scan before extraction, project identification, or allocation.
- Do not use the offered account or application links, access an account, enter credentials, complete MFA, or attempt a download under this dispatch.
- Until the statement is supplied, do not infer the account, borrower, property, balance, amount due, due date, loan details, transactions, project assignment, allocation, accounting treatment, or payment status.

## Processing Decision

- Do not create an invoice or substitute statement from the notice.
- Do not create a project-workbook or accounting entry.
- Do not file the notice as the statement.
- Do not approve, schedule, or make a payment.
- Preserve the Outlook reference and hold the item until the mailed or otherwise authorized actual statement is available.
