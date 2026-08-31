# Quickbooks Invoice Project Room

## Purpose

Enter vendor invoices as QuickBooks bills from validated, authorized, structured handoffs received from Invoice Entry. This room owns controlled bill creation and read-back verification through the currently approved execution method only.

## Scope

In scope:

- Receive immutable durable handoffs only from the registered Invoice Entry task.
- Verify the handoff identity, authorization, target company file, property entity, vendor, vendor-invoice fields, bill lines, totals, and supporting references.
- Check for an existing QuickBooks bill before creation.
- Create one bill through authenticated Chrome browser control after every readiness and per-bill gate passes while Wes's interim authorization remains active.
- Read the created record back, compare the controlling fields, log the durable outcome, and return the result to Invoice Entry.

Out of scope:

- Vendor-invoice intake, source validation, project/vendor mapping, approval decisions, or handoff preparation; Invoice Entry owns those actions.
- Creating or sending a customer invoice.
- Paying a bill, applying or receiving a payment, marking a bill paid, or changing payment status.
- Voiding, deleting, or altering a bill after creation.
- Unrelated bookkeeping, reconciliation, journal entries, expenses, estimates, credits, vendor/customer changes, or company settings.
- Any browser action outside the controlled invoice workflow and the exact authorized handoff.
- Vendor/customer contact or any other external communication.

## Transaction And Company-File Rule

- Invoices sent through this Project Room are vendor invoices and must be entered as QuickBooks **Bills**, not customer invoices.
- Preserve the property/project entity separately from the QuickBooks company file.
- Current rule: both Buy Your Home and Heritage Management property transactions are held in the `Buy Your Home LLC` QuickBooks company file.
- A Heritage Management property bill must therefore be entered in `Buy Your Home LLC` while retaining its Heritage Management property/project coding.
- Other entities require an exact company-file selection in the validated handoff; do not infer or substitute one.

## Required Invoice Entry Handoff

Each request must provide or reference:

- Durable dispatch id and payload hash.
- Evidence that Invoice Entry validated the source and authorized the QuickBooks creation handoff.
- Exact target QuickBooks company/file selection and separate property/project entity.
- Exact vendor identifier and vendor name.
- Source vendor-invoice identity, proposed QuickBooks bill/vendor invoice number when controlled, bill date, due date or terms, currency, and total.
- Complete line items, including description, quantity, rate, amount, and required item/account, class, location, project, job, tax, or other mappings.
- Supporting source references without copying credentials, tokens, or unnecessary financial documents into Git or Project Room messages.
- Stable duplicate-check fields and any known prior QuickBooks transaction id.

Missing, conflicting, or unsupported controlling data is a blocker. Do not guess.

## Interim Browser Readiness

Status: **Ready for validated Invoice Entry handoffs under Wes's interim Chrome authorization**.

Authorized method:

- Use Chrome browser control with the existing authenticated Intuit/QuickBooks Online session.
- Before every bill, visibly select and verify the exact company named in the validated Invoice Entry handoff.
- Check the durable action log by dispatch id and search QuickBooks using the supplied vendor-invoice identity, vendor, amount, date, vendor invoice number, property/project, and any known transaction id before creation.
- Create exactly one bill, save once, and read the saved record back before returning success.
- A login challenge, uncertain company, ambiguous duplicate, browser error after submission, or failed read-back is a blocker. Reconcile before any retry.

No-production-impact validation completed at `2026-08-31T16:51:43Z`:

- Chrome control reached the authenticated QuickBooks Online company chooser.
- The chooser visibly listed exactly five QuickBooks Online companies: `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC`.
- No company was selected because no Invoice Entry handoff identified a target.
- No bill, vendor, customer, item, payment, setting, or bookkeeping record was created or changed.

The earlier Zapier MCP setup path is superseded by Wes's later interim browser-control decision. Credentials and session data remain outside Git and Project Room messages.

## Messaging Readiness

- Dispatchable: Yes, only for validated Invoice Entry handoffs under the interim Chrome policy
- State: Messaging transport and interim browser readiness complete; per-bill gates required
- Destination manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\quickbooks-invoice.json`
- Execution machine: `WESSTUDIO`
- Dedicated task id: `01a05809-d732-7b80-80b9-63602b8a6032`
- Machine registration: verified at `2026-08-31T13:39:19.8514402Z`
- Host access: verified at `2026-08-31T13:39:20.8539842Z`
- Synthetic lifecycle: corrected record `prmsg-quickbooks-invoice-readiness-validation-20260831-1342-correction-001` completed at `2026-08-31T13:48:19.9819523Z` after exactly one notification with Accepted, Processing, Completed, and explicit notification-count evidence under the exact destination identity

Passing Project Room messaging readiness does not override the per-bill browser safety gates.

## Workflow

1. Reconcile the authoritative central message, verify the exact destination identity and payload hash, deduplicate by dispatch id, and write `Accepted` before substantive work.
2. Confirm the request came from the registered Invoice Entry task and contains the required validated handoff fields.
3. Confirm the Chrome session is authenticated, then visibly select and verify the exact company from the handoff. Stop on any login challenge or company uncertainty.
4. Reconcile the action log by dispatch id and search the target company for likely duplicates using all supplied duplicate-check fields. If a match or ambiguity exists, stop without creating a bill and return the existing transaction id or the review needed.
5. Resolve the exact vendor and every bill-line mapping in QuickBooks without creating or editing vendors, customers, items, accounts, classes, locations, projects, jobs, tax settings, or terms.
6. Review the staged bill against the authorized vendor invoice, then save exactly once. If the browser errors or becomes ambiguous after submission, do not retry creation; reconcile through the action log and QuickBooks search first.
7. Read the saved bill back and compare company file, property entity, vendor, dates, number, currency, line items, mappings, total, and QuickBooks bill identifier to the authorized handoff.
8. Record the outcome in `working\quickbooks-invoice-action-log.md` and return the QuickBooks bill id, company/file, property entity, vendor, amount, creation timestamp, and verification result to Invoice Entry.
9. Do not pay the bill or take any paid-status, void/delete, unrelated-bookkeeping, unscoped-browser, vendor-contact, or customer-invoice action.

## Folder Map

- `sources\` - approved source references or source notes; no credentials, tokens, or unnecessary financial documents.
- `working\source-inventory.md` - controlling source inventory.
- `working\duplicate-and-conflict-log.md` - duplicate risks, conflicts, and superseded information.
- `working\missing-context.md` - readiness and per-request decisions still needed.
- `working\quickbooks-invoice-action-log.md` - durable intake, duplicate-check, creation, verification, blocker, and return outcomes.
- `outputs\` - review-ready validation or outcome reports when needed.

## Current Status

Status: dispatchable for validated Invoice Entry handoffs under the interim Chrome policy.

The local Project Room package, dedicated task, messaging lifecycle, and no-production-impact Chrome readiness validation are complete. Every vendor bill remains subject to exact target-company, duplicate-search, one-save, read-back, and reconciliation gates.

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

1. Accept only validated and authorized Invoice Entry handoffs containing the exact target company, property entity, vendor, and complete bill fields.
2. Apply the target-company, action-log, duplicate-search, one-save, and read-back gates for every invoice.
3. Reconcile any ambiguous browser result before retrying; never blindly create a second invoice.
4. Revisit connector/API adoption separately if Wes replaces the interim Chrome authorization.
