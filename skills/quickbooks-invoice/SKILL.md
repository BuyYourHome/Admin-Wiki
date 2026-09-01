---
name: quickbooks-invoice
description: Enter and verify vendor invoices as QuickBooks bills from validated, authorized Invoice Entry handoffs through Wes-authorized authenticated Chrome browser control or a later approved method. Use for Quickbooks Invoice vendor-bill intake, duplicate protection, controlled one-bill creation, read-back verification, outcome logging, and return to Invoice Entry. Do not use for invoice intake or approval, customer invoices, bill payment, paid status, void/delete, unrelated bookkeeping, or unscoped browser action.
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
- Thread id: `01a05967-9a05-7081-a62e-616b2d8e61fd`
- Execution machine: `WES-VIDEOEDITOR`
- Accept work only through this exact registered task after all readiness gates pass.

## Messaging Readiness

- Dispatchable: Yes - on `WES-VIDEOEDITOR` for validated Invoice Entry handoffs only
- State: Unattended cross-machine dispatcher validation completed successfully.
- Exact task id: `01a05967-9a05-7081-a62e-616b2d8e61fd`
- Machine registration verified at `2026-08-31T21:43:02.1661378Z`; host access verified at `2026-08-31T22:31:07.8796039Z` on `WES-VIDEOEDITOR`
- Synthetic lifecycle: corrected record `prmsg-quickbooks-invoice-wve-readiness-correction-20260831-001` completed after exactly one notification with `synthetic_test: true`, exact identity and payload-hash verification, and no QuickBooks business action
- Dispatcher validation: task `01a05d0c-8031-7d92-9474-ab2330008ddb` and automation `pr-messaging-dispatcher-wes-videoeditor` delivered `prmsg-invoice-entry-wve-dispatcher-unattended-validation-20260901-001` exactly once. The exact destination wrote `Accepted`, `Processing`, and `Completed` with `manual_intervention: false` and no business action.

Messaging readiness alone does not override the interim browser and per-bill safety gates.

## Interim Browser Readiness

Status: ready for validated Invoice Entry handoffs on `WES-VIDEOEDITOR` under Wes's interim Chrome authorization.

- Use the existing authenticated Intuit/QuickBooks Online session through Chrome browser control.
- No-production-impact validation on `WES-VIDEOEDITOR` at `2026-08-31T22:31:07.0879564Z` reached the authenticated company chooser and verified five visible companies without selecting a company or changing any record.
- The visible companies were `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC`.
- The earlier Zapier MCP setup path is superseded while this interim authorization remains active.

Before every vendor invoice, require authenticated access, visible exact-company confirmation from the handoff, action-log reconciliation by dispatch id, duplicate search, exact vendor and bill-line mappings, one save, and full read-back verification. A login challenge, uncertain company, ambiguous duplicate, browser error after submission, or failed read-back is a blocker. Never blindly retry creation.

## Transaction And Company-File Rule

- Vendor invoices received through this Project Room are entered as QuickBooks **Bills**, not customer invoices.
- Use the exact vendor identity from the validated Invoice Entry handoff. Do not create or alter a vendor.
- The project/property entity and the QuickBooks company file are separate controlling fields. Preserve both.
- Current company-file rule: transactions for both `Buy Your Home LLC` properties and `Heritage Management LLC` properties are held in the `Buy Your Home LLC` QuickBooks company file.
- Therefore, a Heritage Management property invoice must retain its Heritage Management property/project coding while the visible QuickBooks company selection is `Buy Your Home LLC`.
- Do not infer the company file for another entity. Require the handoff to name it and stop on any conflict with the current documented rule.

## Chrome Navigation

Use the recorded QuickBooks Online path and extend it only as later steps are validated:

1. Continue through the existing Intuit sign-in when the session recognizes the authorized account. A password, verification-code, CAPTCHA, or other user-only challenge requires Wes.
2. At `Choose your company`, select the exact company file required by the handoff and visibly verify the company name after it opens.
3. In the QuickBooks left sidebar, open `Bookmarks`, then choose `Vendors`.
4. Locate the exact vendor from the handoff before reviewing transactions or staging a bill.
5. Stay on the exact vendor record and choose `New transaction` > `Bill`.
6. If several approved source invoices for the same vendor belong in the same QuickBooks company file, they may be entered as separate category lines on one QuickBooks bill. Preserve each source invoice identity, property/project coding, and amount on its own line; stop on conflicting controlling fields rather than silently combining them.

QuickBooks may truncate a long `Bill no.` value. Read back the saved value and preserve each full source invoice identity in its category-line description and the durable action log so duplicate protection does not depend on the bill-number field alone.

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Room Delegation Contract.md`, and `Project Room Messaging Rule.md`.
3. Read the Quickbooks Invoice README, source inventory, duplicate/conflict log, missing-context file, and action log.
4. Check `git status --short --branch` and work on `main` unless Wes explicitly asks for a branch.
5. Confirm Messaging Readiness, Interim Browser Readiness, and every per-bill gate before accepting production work.

## Required Handoff

Accept only an immutable durable message from the registered Invoice Entry task containing or referencing:

- dispatch id and payload hash;
- Invoice Entry validation and authorization evidence;
- exact target QuickBooks company/file and the separate property/project entity;
- exact vendor identity;
- source vendor-invoice identity, bill date, due date or terms, currency, vendor invoice number when controlled, and total;
- complete line items and every required accounting/project mapping;
- source references and stable duplicate-check fields;
- any known prior QuickBooks transaction id.

Do not infer missing company, property entity, vendor, dates, line items, totals, accounts, items, classes, locations, projects, jobs, tax, terms, or approval state.

## Workflow

1. Reconcile the authoritative central message with `Manage-ProjectRoomMessage.ps1`, verify the exact destination and payload hash, deduplicate by dispatch id, and write `Accepted` before substantive work.
2. Confirm the source is the registered Invoice Entry task and the handoff is complete, internally consistent, and authorized.
3. Confirm messaging readiness and authenticated Chrome access, select and visibly verify the exact company named in the handoff, then navigate through `Bookmarks` > `Vendors` to the exact vendor.
4. Review the vendor's transactions and search for likely duplicate bills using all supplied fields. Stop without creation when a match or ambiguity exists.
5. From the exact vendor record, choose `New transaction` > `Bill`. Represent multiple approved same-vendor source invoices in the same company file as separate category lines on one bill when their controlling fields do not conflict. With Wes's explicit same-batch instruction, an additional approved source invoice may be added to an existing unpaid bill only after verifying that bill and source are not duplicates.
6. Resolve the exact vendor and every bill-line mapping without creating or changing unrelated QuickBooks entities or settings.
7. Review the staged bill against every authorized source invoice represented on it, save exactly once, and record the QuickBooks bill identifier immediately when visible. If the browser result after submission is ambiguous, stop and reconcile before any retry.
8. Read the saved bill back and compare company file, property entity, vendor, number, dates, currency, line items, mappings, total, and QuickBooks bill identifier.
9. Log the outcome in `working\quickbooks-invoice-action-log.md` and return the QuickBooks bill id, company/file, property entity, vendor, amount, creation or update timestamp, and verification result to Invoice Entry under the same dispatch id.
10. Do not pay the bill or perform paid-status, void/delete, unrelated-bookkeeping, unscoped-browser, vendor-contact, or customer-invoice actions.

## Duplicate Protection

- Treat dispatch id and payload hash as immutable request identity.
- Search QuickBooks before creation using source vendor-invoice identity, vendor, amount, bill date, vendor invoice number, property/project, and any external reference or transaction id.
- Record the created QuickBooks bill/transaction id immediately after a successful response.
- On retry, reconcile the action log and QuickBooks search results before any create call.
- An ambiguous connector result is not permission to retry creation. Return a blocker for reconciliation.

## Outputs And Delivery

- Durable outcomes: `C:\Codex\Wiki Files\Project Rooms\Quickbooks Invoice\working\quickbooks-invoice-action-log.md`
- Review-ready reports when needed: `C:\Codex\Wiki Files\Project Rooms\Quickbooks Invoice\outputs\`
- Return to Invoice Entry: QuickBooks bill id, company/file, property entity, vendor, amount, creation timestamp, read-back verification, duplicate-check result, and any blocker.

## Boundaries

- Invoice Entry owns intake, source validation, mappings, approval gates, and structured handoff preparation.
- Do not create or send customer invoices.
- Do not pay a bill, apply or receive payments, mark paid, void, delete, or alter a saved bill after creation except for Wes's explicit correction or same-batch instruction to add another approved source invoice to that same unpaid bill.
- Do not perform unrelated bookkeeping or change QuickBooks vendors, customers, items, accounts, classes, locations, projects, jobs, tax settings, terms, or company settings.
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
