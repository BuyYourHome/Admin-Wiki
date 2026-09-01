# Quickbooks Invoice Project Room

## Purpose

Enter vendor invoices as QuickBooks bills from validated, authorized, structured handoffs received from Invoice Entry. This room owns controlled bill creation and read-back verification through the currently approved execution method only.

## Scope

In scope:

- Receive immutable durable handoffs only from the registered Invoice Entry task.
- Verify the handoff identity, authorization, target company file, property entity, vendor, vendor-invoice fields, bill lines, totals, and supporting references.
- Check for an existing QuickBooks bill before creation.
- Create a vendor bill—or, with Wes's explicit authorization, update an unpaid vendor bill—through authenticated Chrome browser control after every readiness and per-bill gate passes while Wes's interim authorization remains active.
- Read the created record back, compare the controlling fields, log the durable outcome, and return the result to Invoice Entry.

Out of scope:

- Vendor-invoice intake, source validation, project/vendor mapping, approval decisions, or handoff preparation; Invoice Entry owns those actions.
- Creating or sending a customer invoice.
- Paying a bill, applying or receiving a payment, marking a bill paid, or changing payment status.
- Voiding, deleting, or altering a saved bill after creation, except for Wes's explicit correction or same-batch instruction to add another approved source invoice to the same unpaid bill.
- Unrelated bookkeeping, reconciliation, journal entries, expenses, estimates, credits, vendor/customer changes, or company settings.
- Any browser action outside the controlled invoice workflow and the exact authorized handoff.
- Vendor/customer contact or any other external communication.

## Transaction And Company-File Rule

- Invoices sent through this Project Room are vendor invoices and must be entered as QuickBooks **Bills**, not customer invoices.
- Preserve the property/project entity separately from the QuickBooks company file.
- Current rule: both Buy Your Home and Heritage Management property transactions are held in the `Buy Your Home LLC` QuickBooks company file.
- A Heritage Management property bill must therefore be entered in `Buy Your Home LLC` while retaining its Heritage Management property/project coding.
- Other entities require an exact company-file selection in the validated handoff; do not infer or substitute one.
- When several approved source invoices have the same vendor and are tracked in the same QuickBooks company file, they may be represented by one QuickBooks bill with a separate category line for each source invoice. Preserve each source invoice identity, property/project coding, and amount on its own line; stop on conflicting bill dates, terms, currencies, or other controlling fields instead of silently combining them.

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
- If Intuit presents its sign-in page, continue once through the normal retained-account flow when Chrome or Intuit recognizes the authorized account or fills its saved credentials. Do not view, copy, edit, or record the credentials. The sign-in page by itself is not a blocker and must not be returned as `Needs Wes` before this recognized flow is attempted.
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

### Recorded Chrome Navigation

The current validated workflow records navigation incrementally as Wes confirms each step:

1. When Intuit presents sign-in, use the authorized account offered by Intuit or credentials retained and filled by Chrome, then attempt the normal sign-in flow once. Do not reveal, copy, edit, or record credentials. A sign-in page alone is not a blocker. Stop for Wes only if a password must be entered manually, a verification code, MFA, CAPTCHA, account recovery, or account-identity choice is required, or the recognized retained-account attempt fails.
2. At `Choose your company`, select the exact company file from the validated handoff and visibly verify the company name after it opens.
3. Use the QuickBooks left sidebar: `Bookmarks` > `Vendors`.
4. Locate the exact vendor before reviewing its transactions or staging a bill.
5. Stay on the vendor record and choose `New transaction` > `Bill`; do not detour through the general Bills page when the exact vendor is already open.
6. If the authorized batch contains multiple source invoices for that vendor in the same company file, add each as a separate category line and preserve the full source invoice identity in that line's description.

QuickBooks may truncate a long value entered in `Bill no.`. Read back the exact saved value and do not rely on that field alone for duplicate protection; preserve every full source invoice identity in its line description and in the durable action log.

## Messaging Readiness

- Dispatchable: Yes - on `WES-VIDEOEDITOR` for validated Invoice Entry handoffs only
- State: Unattended cross-machine dispatcher validation completed successfully.
- Destination manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\quickbooks-invoice.json`
- Execution machine: `WES-VIDEOEDITOR`
- Dedicated task id: `01a05967-9a05-7081-a62e-616b2d8e61fd`
- Machine registration: verified at `2026-08-31T21:43:02.1661378Z` on `WES-VIDEOEDITOR`
- Host access: verified at `2026-08-31T22:31:07.8796039Z` on `WES-VIDEOEDITOR`
- Synthetic lifecycle: corrected record `prmsg-quickbooks-invoice-wve-readiness-correction-20260831-001` completed at `2026-08-31T22:35:23.2843551Z` after exactly one notification with `synthetic_test: true`, exact identity and payload-hash verification, and no QuickBooks business action
- Dispatcher validation: task `01a05d0c-8031-7d92-9474-ab2330008ddb` and automation `pr-messaging-dispatcher-wes-videoeditor` delivered `prmsg-invoice-entry-wve-dispatcher-unattended-validation-20260901-001` exactly once. Quickbooks Invoice wrote `Accepted`, `Processing`, and `Completed` by `2026-09-01T16:15:32.4201488Z` with `manual_intervention: false` and no business action.
- Readiness validator: `ready: true` on `WES-VIDEOEDITOR` at `2026-09-01T16:26:05.5963715Z`; every check passed.

Passing Project Room messaging readiness does not override the per-bill browser safety gates.

## Workflow

1. Reconcile the authoritative central message, verify the exact destination identity and payload hash, deduplicate by dispatch id, and write `Accepted` before substantive work.
2. Confirm the request came from the registered Invoice Entry task and contains the required validated handoff fields.
3. Confirm Chrome access. If Intuit presents sign-in, first attempt the one recognized retained-account flow allowed under Recorded Chrome Navigation and stop only on its documented user-only challenges or failure. After authentication, visibly select and verify the exact company from the handoff, then use `Bookmarks` > `Vendors` to locate the exact vendor. Stop on company uncertainty, a browser-control blocker, or vendor ambiguity.
4. Reconcile the action log by dispatch id, review the vendor's transactions, and search the target company for likely duplicate bills using all supplied duplicate-check fields. If a match or ambiguity exists, stop without creating a bill and return the existing transaction id or the review needed.
5. From the exact vendor record, choose `New transaction` > `Bill`. When multiple approved source invoices in the same authorized batch share the vendor and QuickBooks company file, use separate category lines on one bill and preserve each source identity and property coding on its line. If an explicitly authorized same-batch source must be added to an existing unpaid bill, verify that exact bill and source are not duplicates before editing it.
6. Resolve the exact vendor and every bill-line mapping in QuickBooks without creating or editing vendors, customers, items, accounts, classes, locations, projects, jobs, tax settings, or terms.
7. Review the staged bill against every authorized source invoice represented on it, then save exactly once. If the browser errors or becomes ambiguous after submission, do not retry creation or update; reconcile through the action log and QuickBooks search first.
8. Read the saved bill back and compare company file, property entity, vendor, dates, number, currency, line items, mappings, total, and QuickBooks bill identifier to the authorized handoff.
9. Record the outcome in `working\quickbooks-invoice-action-log.md` and return the QuickBooks bill id, company/file, property entity, vendor, amount, creation or update timestamp, and verification result to Invoice Entry.
10. Do not pay the bill or take any paid-status, void/delete, unrelated-bookkeeping, unscoped-browser, vendor-contact, or customer-invoice action.

## Folder Map

- `sources\` - approved source references or source notes; no credentials, tokens, or unnecessary financial documents.
- `working\source-inventory.md` - controlling source inventory.
- `working\duplicate-and-conflict-log.md` - duplicate risks, conflicts, and superseded information.
- `working\missing-context.md` - readiness and per-request decisions still needed.
- `working\quickbooks-invoice-action-log.md` - durable intake, duplicate-check, creation, verification, blocker, and return outcomes.
- `outputs\` - review-ready validation or outcome reports when needed.

## Current Status

Status: Active and dispatchable on `WES-VIDEOEDITOR` for validated Invoice Entry handoffs only. The interim Chrome and per-bill controls remain unchanged.

The exact task identity is registered on `WES-VIDEOEDITOR`, central host access is verified, and the required one-notification messaging lifecycle completed. At `2026-08-31T22:31:07.0879564Z`, read-only Chrome validation reached the authenticated `Choose your company` screen and showed `Buy Your Home LLC`, `BYH 401K LLC`, `Heritage Management LLC`, `Home Acct`, and `Sell Your Home LLC`. No company was selected and no QuickBooks data changed. Every vendor bill remains subject to validated Invoice Entry authorization, visible exact-company confirmation, dispatch/action-log reconciliation, duplicate search, exact vendor and bill-line mappings, one save, saved-bill read-back, ambiguous-result stop, no-payment, no-send, and no-unrelated-bookkeeping controls.

## Matching Skill

- `C:\Codex\Wiki Files\skills\quickbooks-invoice\SKILL.md`

## Dedicated Task

- Task name: `Quickbooks Invoice`
- Thread id: `01a05967-9a05-7081-a62e-616b2d8e61fd`
- Execution machine: `WES-VIDEOEDITOR`

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
