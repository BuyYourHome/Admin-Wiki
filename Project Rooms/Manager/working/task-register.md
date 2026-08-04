# Manager Task Register

Use this register as the durable status record for Manager Tasks.

## Task ID Display

- Store the full canonical id as `MGR-YYYYMMDD-NNN` in this register and internal records.
- Show only the final three digits (`NNN`) in user-facing task lists, summaries, status reports, and task emails.
- Keep each three-digit display number unique across the entire register. Do not reset the suffix on a new date or reuse a historical number.

## Allowed Values

- Priority: `Critical`, `High`, `Normal`, `Low`
- Status: `New`, `Delivered`, `Acknowledged`, `In Progress`, `Waiting`, `Completed`, `Cancelled`

## Tasks

| Task ID | Received | Requester | Task | Priority | Status | Due | Delivered | Last Updated | Source / Delivery / Update Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MGR-20260724-001 | 2026-07-24T13:49:47Z | Wes Will Buy Your Home <WesWill@BuyYourHomeLLC.com> | Review the active project spreadsheets for proper automated entries of invoices and Lowes statement items. | Normal | New |  |  | 2026-07-24T14:02:19Z | Source: `sources\email\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested. |
| MGR-20260724-002 | 2026-07-24T13:49:47Z | Wes Will Buy Your Home <WesWill@BuyYourHomeLLC.com> | Prepare the next computer for Codex installation. | Normal | New |  |  | 2026-07-24T14:02:19Z | Source: `sources\email\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested. |
| MGR-20260724-003 | 2026-07-24T13:49:47Z | Wes Will Buy Your Home <WesWill@BuyYourHomeLLC.com> | Finish the Tensity project. | Normal | New |  |  | 2026-07-24T14:02:19Z | Source: `sources\email\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested. |
| MGR-20260724-004 | 2026-07-24T13:49:47Z | Wes Will Buy Your Home <WesWill@BuyYourHomeLLC.com> | Spend time working closely with Tim Flemming on the Pond project. | Normal | New |  |  | 2026-07-24T14:02:19Z | Source: `sources\email\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested. |
| MGR-20260724-005 | 2026-07-24T13:49:47Z | Wes Will Buy Your Home <WesWill@BuyYourHomeLLC.com> | See Jenny about anything that needs scanning. | Normal | New |  |  | 2026-07-24T14:02:19Z | Source: `sources\email\2026-07-24-094947-manager-task.md`; Outlook message ID recorded in `manager-routing-ledger.md`; no delivery requested. |
