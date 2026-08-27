---
name: bathroom-fixtures
description: Use for Buy Your Home bathroom fixture research, comparison, selection, specification, sourcing, and fixture schedules, including smart showers, valves, faucets, toilets, sinks, accessories, installation requirements, pricing, and materials under `Project Rooms\Bathroom Fixtures`.
---

# Bathroom Fixtures

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\Bathroom Fixtures`
- README: `C:\Codex\Wiki Files\Project Rooms\Bathroom Fixtures\README.md`
- Smart shower handoff: `C:\Codex\Wiki Files\Project Rooms\Bathroom Fixtures\sources\smart-shower-comparison-handoff-2026-08-26.md`

## Required Startup

1. Read the Project Room README.
2. Read `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
3. Check current manufacturer information when specifications, pricing, availability, warranty, or compatibility may have changed.
4. Confirm the property, room, remodel stage, and decision being made before producing a final specification.

## Default Workflow

Use `Compare` unless Wes names another mode.

## Modes

- `Compare`: Compare exact fixture models and systems using current sources and project requirements.
- `Specify`: Produce a review-ready fixture schedule or system specification.
- `Source`: Research current availability and pricing without ordering.

## Workflow

1. Identify the property, bathroom, fixture category, budget, finish, and decision deadline.
2. Record existing plumbing, electrical, hot-water, networking, structural, and service-access constraints.
3. Compare exact manufacturer and model numbers.
4. Separate manufacturer facts, dated pricing, installer assumptions, and unresolved questions.
5. Evaluate installation complexity, compatibility, warranty, serviceability, replacement parts, and expected ownership cost.
6. Produce a shortlist, recommendation, or fixture schedule with explicit exclusions and open decisions.
7. Recheck specifications, price, and availability before purchase.

## Boundaries

- Do not order fixtures or authorize construction without Wes's specific approval.
- Do not treat web pricing as a contractor quote or installed cost.
- Do not claim code compliance or installation suitability without project-specific professional verification.
- Route Home Assistant configuration to Home Assistant and network architecture to Network Roadmap.

## Outputs

- Product comparisons and recommendation memos.
- Fixture schedules and model lists.
- Equipment budgets and dated sourcing tables.
- Installation requirement and open-question checklists.

## Required Pointers

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

## Completion

Report sources checked, exact models compared, recommendation, pricing date, installation constraints, unresolved questions, Git status, and total request time.
