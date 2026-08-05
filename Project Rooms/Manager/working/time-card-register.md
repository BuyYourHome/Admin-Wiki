# Manager Time Card Register

Use this register as the source-of-truth ledger for time worked by the Manager and the tasks performed.

## Ownership

- Manager owns time intake, source traceability, clarification, display, corrections, active totals, and structured Invoice Entry packets.
- Invoice Entry owns rates and amounts, semimonthly accumulation for invoice purposes, draft/final invoice generation, correction review, Wes approval, filing, allocation, and project-spreadsheet insertion.
- A Time Card line is not an invoice, approval, payment authorization, or proof of payment.

## Entry IDs

- Store the canonical id as `MTC-YYYYMMDD-NNN`, using the work date and the next unused suffix across the full register.
- Display the id as `TC-NNN`.
- Never reset or reuse the three-digit suffix.

## Required Fields

- Work date.
- Exact duration or supported start/end times.
- Task description.
- Project/property or `BackOffice` destination.
- Source and received timestamp when available.

Do not infer time or destination. Use `Needs Clarification` when a required field is unclear.

## Statuses

`Recorded`, `Needs Clarification`, `Ready for Invoice Entry`, `Handed Off`, `Accepted by Invoice Entry`, `Drafted`, `Finalized`, `Held`, `Superseded`, `Cancelled`

## Entries

| Entry ID | Display ID | Work Date | Start | End | Break | Duration | Task | Destination | Period | Status | Source / Received | Correction / Handoff Notes | Last Updated |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

## Totals Rule

- Periods are the 1st through the 15th and the 16th through the last calendar day.
- Total exact hours and minutes from active lines only.
- Exclude `Superseded` and `Cancelled` lines from active totals without deleting their history.
