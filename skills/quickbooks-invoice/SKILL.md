---
name: quickbooks-invoice
description: Create and verify QuickBooks invoice records from validated, authorized Invoice Entry handoffs through an approved authenticated connector. Use for Quickbooks Invoice intake, duplicate protection, connector-backed invoice creation, read-back verification, outcome logging, and return to Invoice Entry. Do not use for invoice intake or approval, customer sending, payment activity, paid status, void/delete, unrelated bookkeeping, or browser substitution.
---

# Quickbooks Invoice

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\Quickbooks Invoice`
- Skill source: `C:\Codex\Wiki Files\skills\quickbooks-invoice\SKILL.md`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Routing map: `C:\Codex\Wiki Files\Project Rooms\Jean Wright\working\dispatcher-routing-map.md`
- Destination manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\quickbooks-invoice.json`

## Dedicated Task

- Task name: `Quickbooks Invoice`
- Thread id: `pending until the dedicated task is created`
- Execution machine: `WESSTUDIO`
- Accept work only through this exact registered task after all readiness gates pass.

## Messaging Readiness

- Dispatchable: No
- State: `Pending messaging registration - not dispatchable`
- Machine registration, host access, and exact-identity synthetic lifecycle: pending

Messaging readiness alone does not satisfy Connector Readiness.

## Connector Readiness

Status: pending and not dispatchable.

Require all of the following before any production invoice creation:

1. A callable approved QuickBooks connector or API integration; never substitute browser automation.
2. Successful secret-safe authentication.
3. Review of the least privilege reasonably available for invoice creation and read-back.
4. Wes-confirmed exact target company/file and connector-reported immutable company identity.
5. Proven duplicate search using dispatch id, source invoice identity, customer, amount, date, and QuickBooks transaction id when any.
6. A non-production sandbox, connector dry run, or another explicitly approved validation with no customer sending, payment activity, paid status, void/delete, unrelated bookkeeping, or production-book impact.
7. Durable, secret-free evidence of connector identity, target-company selection, permission review, validation result, and timestamp.

If any gate is missing or stale, return `blocked` or `needs Wes` and do not create an invoice.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Room Delegation Contract.md`, and `Project Room Messaging Rule.md`.
3. Read the Quickbooks Invoice README, source inventory, duplicate/conflict log, missing-context file, and action log.
4. Check `git status --short --branch` and work on `main` unless Wes explicitly asks for a branch.
5. Confirm Connector Readiness and Messaging Readiness before accepting production work.

## Required Handoff

Accept only an immutable durable message from the registered Invoice Entry task containing or referencing:

- dispatch id and payload hash;
- Invoice Entry validation and authorization evidence;
- exact target company/file;
- exact customer identity;
- source invoice identity, dates or terms, currency, invoice number when controlled, and total;
- complete line items and every required accounting/project mapping;
- source references and stable duplicate-check fields;
- any known prior QuickBooks transaction id.

Do not infer missing company, customer, dates, line items, totals, accounts, items, classes, locations, projects, jobs, tax, terms, or approval state.

## Workflow

1. Reconcile the authoritative central message with `Manage-ProjectRoomMessage.ps1`, verify the exact destination and payload hash, deduplicate by dispatch id, and write `Accepted` before substantive work.
2. Confirm the source is the registered Invoice Entry task and the handoff is complete, internally consistent, and authorized.
3. Confirm every connector and messaging readiness gate remains valid for the exact connector and company.
4. Search for likely duplicates using all supplied fields. Stop without creation when a match or ambiguity exists.
5. Resolve the exact customer and every line-item mapping without creating or changing unrelated QuickBooks entities or settings.
6. Create exactly one invoice through the approved connector, using the durable dispatch id as a stable external or idempotency reference when supported.
7. Read the invoice back and compare company, customer, number, dates, currency, line items, mappings, and total.
8. Log the outcome in `working\quickbooks-invoice-action-log.md` and return the QuickBooks invoice id, company/file, customer, amount, creation timestamp, and verification result to Invoice Entry under the same dispatch id.
9. Do not send the invoice or perform payment, paid-status, void/delete, unrelated bookkeeping, browser, or customer-contact actions.

## Duplicate Protection

- Treat dispatch id and payload hash as immutable request identity.
- Search QuickBooks before creation using source invoice identity, customer, amount, invoice date, and any external reference or transaction id.
- Record the created QuickBooks transaction id immediately after a successful response.
- On retry, reconcile the action log and QuickBooks search results before any create call.
- An ambiguous connector result is not permission to retry creation. Return a blocker for reconciliation.

## Outputs And Delivery

- Durable outcomes: `C:\Codex\Wiki Files\Project Rooms\Quickbooks Invoice\working\quickbooks-invoice-action-log.md`
- Review-ready reports when needed: `C:\Codex\Wiki Files\Project Rooms\Quickbooks Invoice\outputs\`
- Return to Invoice Entry: QuickBooks invoice id, company/file, customer, amount, creation timestamp, read-back verification, duplicate-check result, and any blocker.

## Boundaries

- Invoice Entry owns intake, source validation, mappings, approval gates, and structured handoff preparation.
- Do not send or schedule invoices to customers.
- Do not apply or receive payments, mark paid, void, delete, or alter an invoice after creation.
- Do not perform unrelated bookkeeping or change QuickBooks customers, items, accounts, classes, locations, projects, jobs, tax settings, terms, or company settings.
- Do not contact customers, vendors, or another external party.
- Do not use browser automation as a connector substitute.
- Do not store credentials, tokens, session data, or unnecessary financial documents in Git or Project Room messages.

## Git Rules

- Commit only Quickbooks Invoice files and specifically authorized registry, routing, manifest, and index updates.
- Leave unrelated dirty work untouched.
- Push only under the Admin wiki push rules.

## Start PR Pointer

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
