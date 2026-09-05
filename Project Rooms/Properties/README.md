# Properties

This Project Room owns the Properties setup workflow for Buy Your Home properties.

## Purpose

- Create the standard folder and file package for a new Buy Your Home property project after Wes confirms the project address and template source.
- Track all properties processed or queued through this workflow.
- Maintain the authoritative Admin wiki index for property information found in the Teams-synced Property area, including rents, lease evidence, insurance evidence, purchase price or cost, and sales price.
- Preserve source materials, setup decisions, template choices, cleanup notes, and open questions before any project package is treated as production-ready.

## Current Status

- Status: active draft workflow.
- Owner intent: create property project folders/files and maintain a tracker for all properties handled by this PR.
- Next action: keep `working\property-tracker.md` for setup requests and maintain `working\property-information-ledger.md` as the Teams property information source of truth.
- Related skill: `C:\Codex\Wiki Files\skills\properties\SKILL.md`.

## Room Layout

- `sources\` - raw inputs, source notes, copied reference files, or source summaries.
- `working\` - inventories, audits, open questions, property tracker, Teams property information ledger, setup notes, and per-property cleanup reviews.
- `outputs\` - address-specific folders containing created project files or review-ready setup outputs.

## Operating Rules

- Track every property setup request in `working\property-tracker.md`, including address, status, confirmed template, output folder, spreadsheet path, cleanup status, blockers, and handoff notes.
- Track every Teams property record in `working\property-information-ledger.md`.
- For rents, leases, insurance, purchase price or cost, and sales price, record the Teams source path or workbook cell used as evidence.
- Do not treat a value as final unless the cited Teams evidence directly supports it. Mark ambiguous spreadsheet values, stale workbooks, duplicate folders, backup files, and `DONT USE` files for review instead of blending them into final property facts.
- When Wes says to create a new project, first suggest an existing project to use as the template for the new project spreadsheet and associated folders.
- Wait for Wes to confirm the suggested template project or provide another project to use instead.
- Wes will provide the new project address. Use that address for the new project spreadsheet and associated folders after the template project is confirmed.
- Create an address-specific output folder and any standard working/review files needed to support the property setup.
- When the new project spreadsheet is created, review the `Profit` sheet and blank out values that were specific to the prototype/template project. Preserve formulas, labels, structural formatting, and reusable assumptions unless Wes says otherwise.
- If it is unclear whether a `Profit` sheet value is prototype-specific or reusable, record it for review instead of deleting it.
- Do not mark a property setup complete until the tracker identifies the created folder, created file paths, template used, Profit cleanup status, and any remaining review items.
- Preserve originals.
- Do not blend unsupported facts into final outputs.
- Use authoritative sources only for factual claims.
- Record missing context before drafting.
## Start PR Pointer

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; the PR must accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
