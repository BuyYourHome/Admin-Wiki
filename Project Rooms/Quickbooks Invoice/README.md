# Quickbooks Invoice Project Room

## Purpose

Create invoice records in QuickBooks from validated, authorized, structured handoffs received from Invoice Entry. This room owns connector-backed creation and read-back verification of the matching QuickBooks invoice only.

## Scope

In scope:

- Receive immutable durable handoffs only from the registered Invoice Entry task.
- Verify the handoff identity, authorization, target company, customer, invoice fields, line items, totals, and supporting references.
- Check for an existing QuickBooks invoice before creation.
- Create one invoice through an authenticated, approved QuickBooks connector or API integration after every readiness and per-invoice gate passes.
- Read the created record back, compare the controlling fields, log the durable outcome, and return the result to Invoice Entry.

Out of scope:

- Invoice intake, source validation, project/customer mapping, approval decisions, or handoff preparation; Invoice Entry owns those actions.
- Sending or scheduling an invoice to a customer.
- Applying or receiving a payment, marking an invoice paid, or changing payment status.
- Voiding, deleting, or altering an invoice after creation.
- Unrelated bookkeeping, reconciliation, journal entries, bills, expenses, estimates, credits, customer changes, or company settings.
- Browser automation as a substitute for a missing or unavailable connector.
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

## Connector Readiness

Status: **Pending connector setup - not dispatchable**.

All of these gates must pass before this room may become dispatchable:

1. An approved QuickBooks connector or API integration is callable from the dedicated task. Browser automation is not an alternative.
2. Authentication succeeds without storing credentials or tokens in Git, Project Room files, or durable messages.
3. The granted access is reviewed for the least privilege reasonably available for invoice creation and read-back verification.
4. Wes confirms the exact target QuickBooks company/file, and the connector reports the same immutable company identifier during validation.
5. Duplicate protection is validated against the target company using dispatch id, source invoice identity, customer, amount, invoice date, and QuickBooks transaction id when any.
6. A non-production QuickBooks sandbox, connector dry run, or another explicitly approved validation path proves invoice creation and read-back without sending, payment activity, paid status, void/delete, unrelated bookkeeping, or production-book impact.
7. The validation result, company selection evidence, connector identity, permission review, and timestamp are recorded without secrets.

Current blocker: no callable QuickBooks/Intuit connector is available in the current Codex environment, so authentication, target-company selection, least-privilege review, duplicate-protection testing, and safe invoice validation have not occurred.

## Messaging Readiness

- Dispatchable: No
- State: Messaging transport ready; connector readiness pending - not dispatchable
- Destination manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\quickbooks-invoice.json`
- Execution machine: `WESSTUDIO`
- Dedicated task id: `01a05809-d732-7b80-80b9-63602b8a6032`
- Machine registration: verified at `2026-08-31T13:39:19.8514402Z`
- Host access: verified at `2026-08-31T13:39:20.8539842Z`
- Synthetic lifecycle: corrected record `prmsg-quickbooks-invoice-readiness-validation-20260831-1342-correction-001` completed at `2026-08-31T13:48:19.9819523Z` after exactly one notification with Accepted, Processing, Completed, and explicit notification-count evidence under the exact destination identity

Passing Project Room messaging readiness does not override the separate Connector Readiness gates.

## Workflow

1. Reconcile the authoritative central message, verify the exact destination identity and payload hash, deduplicate by dispatch id, and write `Accepted` before substantive work.
2. Confirm the request came from the registered Invoice Entry task and contains the required validated handoff fields.
3. Confirm every Connector Readiness gate remains valid for the exact connector and target company.
4. Search the target company for likely duplicates using all supplied duplicate-check fields. If a match or ambiguity exists, stop without creating an invoice and return the existing transaction id or the review needed.
5. Resolve the exact customer and every line-item mapping through the connector. Do not create or edit customers, items, accounts, classes, locations, projects, jobs, tax settings, or terms unless a later workflow specifically authorizes that action.
6. Create exactly one invoice through the approved connector using a stable idempotency reference derived from the durable dispatch id when supported.
7. Read the created invoice back and compare company, customer, dates, number, currency, line items, mappings, and total to the authorized handoff.
8. Record the outcome in `working\quickbooks-invoice-action-log.md` and return the QuickBooks invoice id, company/file, customer, amount, creation timestamp, and verification result to Invoice Entry.
9. Do not send the invoice or take any payment, paid-status, void/delete, bookkeeping, browser, or customer-contact action.

## Folder Map

- `sources\` - approved source references or source notes; no credentials, tokens, or unnecessary financial documents.
- `working\source-inventory.md` - controlling source inventory.
- `working\duplicate-and-conflict-log.md` - duplicate risks, conflicts, and superseded information.
- `working\missing-context.md` - readiness and per-request decisions still needed.
- `working\quickbooks-invoice-action-log.md` - durable intake, duplicate-check, creation, verification, blocker, and return outcomes.
- `outputs\` - review-ready validation or outcome reports when needed.

## Current Status

Status: pending setup and not dispatchable.

The local Project Room package, dedicated task, and exact-identity Project Room messaging lifecycle are complete. Every QuickBooks connector readiness gate remains pending, so the room is not dispatchable.

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

1. Select and authenticate an approved QuickBooks connector or API integration with the least privilege reasonably available.
2. Have Wes confirm the exact target company/file.
3. Run and document duplicate protection and the safe non-production or otherwise explicitly approved connector validation.
