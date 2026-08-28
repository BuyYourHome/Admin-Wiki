# Bathroom Fixtures Project Room

## Purpose

Research, compare, select, and document bathroom fixtures and fixture systems for Buy Your Home properties and projects.

## Status

- Project Room: `Bathroom Fixtures`
- Setup status: Active discovery
- Dedicated task ID: `01a0432b-d780-7b01-aed3-e0af40daa663`
- Dispatchable: Yes
- Current phase: Smart-shower system comparison and requirements discovery

## Default Workflow

Use `Compare` unless Wes names another mode.

## Modes

### Compare

Compare fixture systems using current manufacturer information, practical installation requirements, expected ownership costs, compatibility, serviceability, and project-specific needs.

### Specify

Develop a review-ready fixture schedule or system specification after the property, room, budget, finishes, plumbing conditions, and approved products are known.

### Source

Find current products, availability, pricing, and approved purchasing options without placing an order unless Wes separately authorizes the purchase.

## Scope

- Showers, digital and smart shower controls, valves, showerheads, handshowers, body sprays, tub fillers, faucets, toilets, sinks, accessories, and related bathroom fixtures.
- Manufacturer and model comparisons.
- Plumbing, electrical, networking, access-panel, hot-water-capacity, finish, warranty, maintenance, and replacement-part considerations.
- Fixture schedules, product shortlists, budgets, and review-ready recommendations.
- Coordination with Home Assistant when an approved fixture needs home-automation integration.

## Boundaries

- Do not purchase products, place orders, authorize installation, or change a construction scope without Wes's specific approval.
- Do not present preliminary prices as contractor quotes or guaranteed installed costs.
- Verify current specifications and availability before making a final recommendation.
- Do not infer plumbing capacity, electrical readiness, code compliance, or fit from product literature alone.
- Network and Home Assistant configuration belongs to their owning Project Rooms.

## Folder Map

- `sources/`: manufacturer references, approved product information, and conversation handoffs.
- `working/`: source inventory, comparison notes, conflicts, requirements, and open questions.
- `outputs/`: review-ready comparisons, fixture schedules, specifications, and budgets.

## Diagram Standard

- In fixture and plumbing diagrams, make every identified product or selected model a clickable link to its source page.
- Keep products that have not yet been selected labeled as pending rather than linking them to an assumed model.

## Required Pointers

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

## Next Actions

1. Confirm which property and bathroom the smart-shower decision applies to.
2. Record the desired outlets, finishes, budget, water-heater capacity, plumbing access, electrical access, and smart-home priorities.
3. Refresh the Moen Smart Shower and Kohler Anthem comparison when a purchase decision is approaching.
4. Create a fixture schedule after the broader bathroom scope is known.
