---
name: quickbooks-invoice
description: Create and verify QuickBooks invoice records from validated, authorized Invoice Entry handoffs through Wes-authorized authenticated Chrome browser control or a later approved method. Use for Quickbooks Invoice intake, duplicate protection, controlled one-invoice creation, read-back verification, outcome logging, and return to Invoice Entry. Do not use for invoice intake or approval, customer sending, payment activity, paid status, void/delete, unrelated bookkeeping, or unscoped browser action.
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
- Thread id: `01a05809-d732-7b80-80b9-63602b8a6032`
- Execution machine: `WESSTUDIO`
- Accept work only through this exact registered task after all readiness gates pass.

## Messaging Readiness

- Dispatchable: Yes, only for validated Invoice Entry handoffs under the interim Chrome policy
- State: Messaging transport and interim browser readiness complete; per-invoice gates required
- Exact task id: `01a05809-d732-7b80-80b9-63602b8a6032`
- Machine registration and host access: verified on `WESSTUDIO`
- Synthetic lifecycle: corrected record `prmsg-quickbooks-invoice-readiness-validation-20260831-1342-correction-001` completed after exactly one notification with explicit notification-count evidence under the exact destination identity

Messaging readiness alone does not override the interim browser and per-invoice safety gates.

## Interim Browser Readiness

Status: ready for validated Invoice Entry handoffs under Wes's interim Chrome authorization.

- Use the existing authenticated Intuit/QuickBooks Online session through Chrome browser control.
- A no-production-impact validation on `2026-08-31T16:51:43Z` reached the company chooser and verified five visible QuickBooks Online companies without selecting a company or changing any record.
- The visible companies were `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC`.
- The earlier Zapier MCP setup path is superseded while this interim authorization remains active.

Before every invoice, require authenticated access, visible exact-company confirmation from the handoff, action-log reconciliation by dispatch id, duplicate search, exact customer and line mappings, one save, and full read-back verification. A login challenge, uncertain company, ambiguous duplicate, browser error after submission, or failed read-back is a blocker. Never blindly retry creation.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Room Delegation Contract.md`, and `Project Room Messaging Rule.md`.
3. Read the Quickbooks Invoice README, source inventory, duplicate/conflict log, missing-context file, and action log.
4. Check `git status --short --branch` and work on `main` unless Wes explicitly asks for a branch.
5. Confirm Messaging Readiness, Interim Browser Readiness, and every per-invoice gate before accepting production work.

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
3. Confirm messaging readiness, authenticated Chrome access, and the exact visible company named in the handoff.
4. Search for likely duplicates using all supplied fields. Stop without creation when a match or ambiguity exists.
5. Resolve the exact customer and every line-item mapping without creating or changing unrelated QuickBooks entities or settings.
6. Review the staged invoice, save exactly once, and record the QuickBooks identifier immediately when visible. If the browser result after submission is ambiguous, stop and reconcile before any retry.
7. Read the saved invoice back and compare company, customer, number, dates, currency, line items, mappings, total, and QuickBooks invoice identifier.
8. Log the outcome in `working\quickbooks-invoice-action-log.md` and return the QuickBooks invoice id, company/file, customer, amount, creation timestamp, and verification result to Invoice Entry under the same dispatch id.
9. Do not send the invoice or perform payment, paid-status, void/delete, unrelated-bookkeeping, unscoped-browser, or customer-contact actions.

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
- Do not use Chrome outside the exact authorized invoice workflow or while the interim authorization is inactive.
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
