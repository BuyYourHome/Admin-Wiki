---
name: irs
description: Use for Buy Your Home tax-readiness work across all entities, including entity and filing inventories, federal/state/local return checklists, source-document completeness, bookkeeping and reconciliation gaps, filing calendars, CPA-ready packages, notices, extensions, and authoritative filing-status evidence under `Project Rooms\IRS`.
---

# IRS

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\IRS`
- README: `C:\Codex\Wiki Files\Project Rooms\IRS\README.md`
- Filing status: `C:\Codex\Wiki Files\Project Rooms\IRS\working\tax-filing-status.md`

## Required Startup

1. Read the Project Room README.
2. Read `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, `working\missing-context.md`, and `working\tax-filing-status.md`.
3. Confirm the entity or taxpayer, tax year, jurisdiction, filing type, requested output, and authoritative source locations.
4. Verify current forms, deadlines, thresholds, and filing rules from official tax-authority sources whenever they matter.
5. Check `git status --short --branch` and leave unrelated work untouched.

## Default Workflow

Use `Inventory` unless Wes names another mode.

## Modes

- `Inventory`: Build the authoritative entity, taxpayer, filing-obligation, jurisdiction, preparer, deadline, and source-category inventory.
- `Tax Package`: Assemble a CPA-ready checklist and secure-source index for one entity and tax year.
- `Gap Review`: Compare expected requirements with authoritative available evidence and identify unresolved items.
- `Filing Status`: Track extensions, preparation, review, filing, acceptance, payment, notices, amendments, and closure from direct evidence.

## Workflow

1. Establish the complete entity and taxpayer population without assuming tax classification from legal names.
2. Create one controlled row per entity, tax year, jurisdiction, and filing obligation.
3. Inventory prior returns, registrations, notices, extensions, elections, estimated payments, carryforwards, and acceptance evidence.
4. Map each entity to its exact books, bank and credit-card accounts, payroll provider, properties, fixed assets, debts, intercompany balances, and responsible preparer.
5. Define the expected source package and record secure locations without copying sensitive records into Git.
6. Reconcile source completeness, duplicate versions, accounting close status, intercompany activity, owner activity, payroll, contractor reporting, property transactions, and supporting schedules.
7. Separate supported facts, professional determinations, recommendations, assumptions, and unresolved questions.
8. Produce entity-by-entity gap reports, filing calendars, CPA request lists, tax-package indexes, and filing-status reports.
9. Require authoritative evidence before marking a return filed, accepted, paid, amended, or closed.

## Boundaries

- Coordinate readiness; do not act as the final tax professional for unsupported filing positions or legal conclusions.
- Do not file, sign, transmit, amend, elect, pay, or authorize taxes without Wes's specific approval and required professional review.
- Do not store returns, SSNs, EIN documents, credentials, or full sensitive financial records in Git.
- Route QuickBooks changes to Quickbooks, invoice intake to Invoice Entry, scans to Doc Scan, entity diagrams to Entity Relationship, and governing-document work to Operating Agreements.
- Do not infer filing status from draft documents, emails, or verbal statements.

## Outputs

- Master entity and filing-obligation inventory.
- Annual filing calendar and responsibility matrix.
- Entity-by-entity tax source checklist.
- CPA-ready source-package index.
- Bookkeeping and reconciliation gap report.
- Extension, notice, filing, acceptance, payment, and amendment status report.

## Messaging Readiness

- Dispatchable: No
- Status: Pending messaging registration - not dispatchable
- Destination manifest: pending dedicated task creation

## Required Pointers

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

## Completion

Report scope, entities and years covered, authoritative sources checked, missing items, filing-status evidence, professional decisions needed, Git status, and total request time.

