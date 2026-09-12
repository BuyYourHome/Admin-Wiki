# IRS Project Room

## Purpose

Identify, organize, and track everything needed to prepare and file federal, state, and local tax returns for every Buy Your Home entity and tax-reporting owner or activity in scope.

## Status

- Project Room: `IRS`
- Setup status: Pending setup
- Dedicated task ID: pending until the dedicated task is created
- Dispatchable: No - pending messaging registration
- Current phase: Entity and filing-obligation inventory

## Default Workflow

Use `Inventory` unless Wes names another mode.

## Modes

### Inventory

Build the authoritative entity-by-entity, owner-by-owner, and tax-year filing inventory. Identify required returns, jurisdictions, preparers, accounts, deadlines, extensions, elections, and source-document categories without guessing unsupported facts.

### Tax Package

Assemble a CPA-ready checklist and indexed source package for one entity and tax year. Track references to secure source locations, reconciliation status, unresolved questions, and delivery evidence without placing sensitive tax documents in Git.

### Gap Review

Compare the expected filing package with available authoritative records and identify missing, conflicting, duplicate, or unreconciled items that require Wes, the bookkeeper, payroll provider, attorney, or tax professional.

### Filing Status

Track preparation, extension, signature, filing, acceptance, payment, notice, amendment, and retention milestones from authoritative evidence. Do not infer filing or payment from a draft return or verbal statement.

## Scope

- Legal entities, disregarded entities, partnerships, corporations, retirement-plan entities, trusts, individuals, properties, and activities that may create a filing or information-reporting obligation.
- Federal, state, and local income, franchise, sales/use, payroll, property, information, retirement-plan, and other applicable tax filings.
- Prior returns, notices, extensions, elections, entity documents, ownership records, books, bank and credit-card records, payroll reports, contractor/vendor reporting, fixed assets, debt, property transactions, and supporting schedules.
- Entity-to-QuickBooks-company mapping, accounting-period readiness, balance-sheet and profit-and-loss reconciliation, intercompany balances, owner activity, and open bookkeeping issues.
- Filing calendars, responsible parties, preparer requests, missing-item lists, CPA handoff packages, and authoritative filing/acceptance evidence.

## Boundaries

- This room coordinates tax readiness; it does not replace a CPA, enrolled agent, attorney, payroll provider, or other qualified professional.
- Do not file, sign, amend, transmit, elect, pay, or authorize a tax return or tax liability without Wes's specific approval and the required professional review.
- Do not determine a filing position, entity classification, deduction, basis, allocation, nexus, reasonable compensation, or legal conclusion without authoritative support and appropriate professional review.
- Do not put tax returns, Social Security numbers, EIN documents, bank credentials, tax-software credentials, or full sensitive financial records in Git. Store them only in an approved secure location and record a minimal reference here.
- QuickBooks changes belong to Quickbooks; invoice intake belongs to Invoice Entry; entity ownership diagrams belong to Entity Relationship; governing documents belong to Operating Agreements; source scanning belongs to Doc Scan.
- Treat IRS, state, and local tax authority websites, deadlines, forms, and filing rules as time-sensitive and verify them from current official sources.

## Folder Map

- `sources/`: sanitized source references and approved non-sensitive source notes.
- `working/`: inventories, conflicts, missing context, tax-year readiness matrices, and CPA request lists.
- `outputs/`: review-ready checklists, filing calendars, gap reports, and CPA handoff indexes.

## Source And Evidence Rules

- Maintain one row per entity, tax year, jurisdiction, and filing obligation.
- Link every status claim to authoritative evidence: accepted return, extension confirmation, tax-authority transcript or notice, payment confirmation, preparer communication, or approved accounting record.
- Separate `required`, `not applicable`, `unknown`, `in preparation`, `ready for review`, `filed`, `accepted`, `paid`, `amended`, and `closed` statuses.
- Never mark an item filed, accepted, or paid without direct evidence.
- Preserve source-system identifiers and secure file locations without copying sensitive content into Git.

## Messaging Readiness

- Status: Pending messaging registration - not dispatchable
- Destination manifest: pending dedicated task creation
- Execution machine: pending
- Synthetic lifecycle: pending

## Required Pointers

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

## Next Actions

1. Build the authoritative master entity and taxpayer inventory.
2. Confirm each entity's legal name, tax classification, EIN reference, ownership, jurisdictions, accounting file, tax preparer, and filing history.
3. Select the first tax year to reconcile and identify every expected return and information filing.
4. Inventory secure source locations and identify missing documents without copying sensitive records into Git.
5. Produce the first entity-by-entity gap report and CPA request list.


## Current 2025 Deliverable

[[outputs/2025-return-checklist-and-gaps|2025 return checklist and open questions]] records the first substantive review, selected source evidence, expected and conditional forms, remaining work and focused questions. Use [[working/tax-filing-status]] for filing evidence status.
