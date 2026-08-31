# Quickbooks Invoice Project Room

## Purpose

Create invoice records in QuickBooks from validated, authorized, structured handoffs received from Invoice Entry. This room owns controlled creation and read-back verification of the matching QuickBooks invoice through the currently approved execution method only.

## Scope

In scope:

- Receive immutable durable handoffs only from the registered Invoice Entry task.
- Verify the handoff identity, authorization, target company, customer, invoice fields, line items, totals, and supporting references.
- Check for an existing QuickBooks invoice before creation.
- Create one invoice through authenticated Chrome browser control after every readiness and per-invoice gate passes while Wes's interim authorization remains active.
- Read the created record back, compare the controlling fields, log the durable outcome, and return the result to Invoice Entry.

Out of scope:

- Invoice intake, source validation, project/customer mapping, approval decisions, or handoff preparation; Invoice Entry owns those actions.
- Sending or scheduling an invoice to a customer.
- Applying or receiving a payment, marking an invoice paid, or changing payment status.
- Voiding, deleting, or altering an invoice after creation.
- Unrelated bookkeeping, reconciliation, journal entries, bills, expenses, estimates, credits, customer changes, or company settings.
- Any browser action outside the controlled invoice workflow and the exact authorized handoff.
- Customer contact or any other external communication.

## Required Invoice Entry Handoff

Each request must provide or reference:

- Durable dispatch id and payload hash.
- Evidence that Invoice Entry validated the source and authorized the QuickBooks creation handoff.
- Exact target QuickBooks company/file selection.
- Exact customer identifier and customer name.
- Source invoice identity, proposed QuickBooks invoice number when controlled, invoice date, due date or terms, currency, and total.
- Complete line items, including description, quantity, rate, amount, and required item/account, class, location, project, job, tax, or other mappings.
- Supporting source references without copying credentials, tokens, or unnecessary financial documents into Git or Project Room messages.
- Stable duplicate-check fields and any known prior QuickBooks transaction id.

Missing, conflicting, or unsupported controlling data is a blocker. Do not guess.

## Interim Browser Readiness

Status: **Ready for validated Invoice Entry handoffs under Wes's interim Chrome authorization**.

Authorized method:

- Use Chrome browser control with the existing authenticated Intuit/QuickBooks Online session.
- Before every invoice, visibly select and verify the exact company named in the validated Invoice Entry handoff.
- Check the durable action log by dispatch id and search QuickBooks using the supplied invoice identity, customer, amount, date, invoice number, and any known transaction id before creation.
- Create exactly one invoice, save once, and read the saved record back before returning success.
- A login challenge, uncertain company, ambiguous duplicate, browser error after submission, or failed read-back is a blocker. Reconcile before any retry.

No-production-impact validation completed at `2026-08-31T16:51:43Z`:

- Chrome control reached the authenticated QuickBooks Online company chooser.
- The chooser visibly listed exactly five QuickBooks Online companies: `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC`.
- No company was selected because no Invoice Entry handoff identified a target.
- No invoice, customer, item, payment, setting, or bookkeeping record was created or changed.

The earlier Zapier MCP setup path is superseded by Wes's later interim browser-control decision. Credentials and session data remain outside Git and Project Room messages.

## Messaging Readiness

- Dispatchable: Yes, only for validated Invoice Entry handoffs under the interim Chrome policy
- State: Messaging transport and interim browser readiness complete; per-invoice gates required
- Destination manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\quickbooks-invoice.json`
- Execution machine: `WESSTUDIO`
- Dedicated task id: `01a05809-d732-7b80-80b9-63602b8a6032`
- Machine registration: verified at `2026-08-31T13:39:19.8514402Z`
- Host access: verified at `2026-08-31T13:39:20.8539842Z`
- Synthetic lifecycle: corrected record `prmsg-quickbooks-invoice-readiness-validation-20260831-1342-correction-001` completed at `2026-08-31T13:48:19.9819523Z` after exactly one notification with Accepted, Processing, Completed, and explicit notification-count evidence under the exact destination identity

Passing Project Room messaging readiness does not override the per-invoice browser safety gates.

## Workflow

1. Reconcile the authoritative central message, verify the exact destination identity and payload hash, deduplicate by dispatch id, and write `Accepted` before substantive work.
2. Confirm the request came from the registered Invoice Entry task and contains the required validated handoff fields.
3. Confirm the Chrome session is authenticated, then visibly select and verify the exact company from the handoff. Stop on any login challenge or company uncertainty.
4. Reconcile the action log by dispatch id and search the target company for likely duplicates using all supplied duplicate-check fields. If a match or ambiguity exists, stop without creating an invoice and return the existing transaction id or the review needed.
5. Resolve the exact customer and every line-item mapping in QuickBooks without creating or editing customers, items, accounts, classes, locations, projects, jobs, tax settings, or terms.
6. Review the staged invoice against the authorized handoff, then save exactly once. If the browser errors or becomes ambiguous after submission, do not retry creation; reconcile through the action log and QuickBooks search first.
7. Read the saved invoice back and compare company, customer, dates, number, currency, line items, mappings, total, and QuickBooks invoice identifier to the authorized handoff.
8. Record the outcome in `working\quickbooks-invoice-action-log.md` and return the QuickBooks invoice id, company/file, customer, amount, creation timestamp, and verification result to Invoice Entry.
9. Do not send the invoice or take any payment, paid-status, void/delete, unrelated-bookkeeping, unscoped-browser, or customer-contact action.

## Folder Map

- `sources\` - approved source references or source notes; no credentials, tokens, or unnecessary financial documents.
- `working\source-inventory.md` - controlling source inventory.
- `working\duplicate-and-conflict-log.md` - duplicate risks, conflicts, and superseded information.
- `working\missing-context.md` - readiness and per-request decisions still needed.
- `working\quickbooks-invoice-action-log.md` - durable intake, duplicate-check, creation, verification, blocker, and return outcomes.
- `outputs\` - review-ready validation or outcome reports when needed.

## Current Status

Status: dispatchable for validated Invoice Entry handoffs under the interim Chrome policy.

The local Project Room package, dedicated task, messaging lifecycle, and no-production-impact Chrome readiness validation are complete. Every invoice remains subject to exact target-company, duplicate-search, one-save, read-back, and reconciliation gates.

## Matching Skill

- `C:\Codex\Wiki Files\skills\quickbooks-invoice\SKILL.md`

## Dedicated Task

- Task name: `Quickbooks Invoice`
- Thread id: `01a05809-d732-7b80-80b9-63602b8a6032`
- Execution machine: `WESSTUDIO`

## Automation

- None. This is an on-demand workflow triggered by validated Invoice Entry handoffs.

## Main And Push

- Work on `main`.
- Follow `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`.
- Commit only Quickbooks Invoice files and specifically authorized registry, routing, manifest, and index updates.
- Push only under the Admin wiki push rules.

## Start PR Pointer

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

## Next Actions

1. Accept only validated and authorized Invoice Entry handoffs containing the exact target company and complete invoice fields.
2. Apply the target-company, action-log, duplicate-search, one-save, and read-back gates for every invoice.
3. Reconcile any ambiguous browser result before retrying; never blindly create a second invoice.
4. Revisit connector/API adoption separately if Wes replaces the interim Chrome authorization.
