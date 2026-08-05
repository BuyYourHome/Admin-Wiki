# Manager Time Card To Invoice Entry Handoff Contract

## Purpose

Manager preserves the source time ledger and sends structured, versioned time packets. Invoice Entry consumes accepted packets under its own Time Card rules to create or update draft and final invoice artifacts.

## Destination

- Project Room: Invoice Entry
- Registered task/thread id: `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`
- Dispatch id: `manager-dispatch-YYYYMMDD-time-card-vN`

## Activation

Send a packet only when Wes requests draft/final processing or otherwise authorizes Invoice Entry processing. Do not create an automation or schedule from this contract.

Invoice Entry accepts authorized, versioned Manager Time Card packets under its receiver rules committed as `0bf157b7`, in addition to Email Monitor-routed Time Card emails. Each operational packet must still receive its own `accepted` or other explicit return with the same dispatch id.

## Packet Fields

- Dispatch id.
- Packet version and created timestamp.
- Authorizing Wes instruction.
- Worker identity.
- Semimonthly period start and end.
- Requested operation: `create/update draft`, `process correction`, or `prepare closed-period final review`.
- Canonical Manager Time Card entry ids and display ids.
- Work date for each line.
- Exact hours and minutes for each line.
- Start/end/break evidence when supplied.
- Task description for each line.
- Project/property or `BackOffice` destination for each line.
- Source reference and received timestamp for each line.
- Superseded/cancelled relationships and correction history.
- Period total from active lines.
- Missing or disputed fields.
- Manager register path.

Do not include a rate, amount, invoice number, approval, filing direction, or spreadsheet insertion direction unless Invoice Entry has already returned that source-backed fact or Wes separately authorizes the action under Invoice Entry's rules.

## Deduplication And Versioning

- Deduplicate by dispatch id, packet version, canonical entry id, and semimonthly period.
- A correction creates a new packet version and preserves the prior version.
- Do not resend an unchanged packet after an ambiguous, missing, or possibly successful result.

## Required Return

Invoice Entry should return the same dispatch id and one of:

- `accepted` - packet accepted for Invoice Entry processing.
- `done` - requested stage completed; include artifact path, invoice number/status, period, and unresolved items.
- `blocked` - source, receiver rule, or processing blocker.
- `needs Wes` - a decision or approval is required.
- `rejected as wrong room` - the request is outside Invoice Entry's scope.

Manager applies `Accepted by Invoice Entry`, `Drafted`, `Finalized`, or `Held` only from the explicit returned evidence. A missing acknowledgment remains unresolved.

## Safety Boundary

- Manager does not create or finalize invoices, calculate pay, approve payment, file invoices, or edit project spreadsheets.
- Invoice Entry performs only actions authorized by its own current skill and Wes's approvals.
- Neither the packet nor a draft authorizes payment, invoice approval, filing, spreadsheet insertion, or external email.
