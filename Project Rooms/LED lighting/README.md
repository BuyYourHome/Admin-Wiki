# LED lighting

## Purpose And Scope

Plan and document 24-volt lighting for a house remodel: LED fixtures and strips, switches, dimmers, controls, power supplies/drivers, wiring accessories, and related components. Compare compatibility and prepare source-backed load plans and review-ready component schedules.

This room is for planning and selection support. No purchases, live electrical work, device configuration, or contractor instructions are authorized by its creation. Final installation and code compliance require review by the responsible qualified electrician. Do not invent a property, budget, quantities, layout, or technical decisions.

## Status And Ownership

- Package: prepared for discovery; messaging setup pending.
- Matching skill: `C:\Codex\Wiki Files\skills\led-lighting\SKILL.md`.
- Dedicated task: `LED lighting`, id `01a0b696-05a2-7291-a857-084a6f2bc2eb`.
- Execution machine: `WESSTUDIO`.
- Branch and repository: `main` in `C:\Codex\Wiki Files`; never the Teams-synced wiki.
- Trigger: on demand. No automation requested or created.
- Authorization: `prmsg-jean-create-led-lighting-20260918-002`, hash `292e6d64b9c7e0e12942f1631835d47fe659a37cc61298baa102d9651f90a694`; Wes directly authorized acceptance in Create PR on 2026-09-18.

## Messaging Readiness

- Pending messaging registration - not dispatchable.
- Manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\led-lighting.json`.
- Registration, authenticated host access, exact-recipient synthetic lifecycle, worker destination enrollment, and readiness validation must be recorded before promotion.
- A task id or startup acknowledgment alone is not messaging readiness. No manual paste is to be represented as unattended validation.
- Exact local registration and authenticated messaging-host access are verified. Remaining blocker: the existing WESSTUDIO worker has not enrolled this destination; synthetic validation and promotion are pending. See `working/setup-status.md`.

## Folder Map

- `sources/README.md`: source-reference and external-artifact policy.
- `working/source-inventory.md`: authoritative sources and missing inputs.
- `working/duplicate-and-conflict-log.md`: conflicting specifications and superseded sources.
- `working/missing-context.md`: discovery questions.
- `working/setup-status.md`: setup and readiness evidence.
- `outputs/README.md`: planning-output conventions.

## Planning Workflow

1. Establish the house/project, rooms and zones, desired lighting, installation constraints, and existing equipment from Wes's sources.
2. Inventory manufacturer documents, drawings, measurements, and model numbers before recommendations. Keep facts, assumptions, and decisions distinct.
3. Confirm each load's actual electrical requirements; do not assume every LED product is 24 V or uses the same supply/control method. Verify driver, dimmer, controller, and load compatibility against the exact model documentation.
4. For load planning, record quantities, lengths, rated power, calculation units, supply capacity/derating, controller/channel limits, run lengths, and voltage-drop assumptions. Flag missing evidence rather than guessing. Leave final wiring/protection and installation approval to the electrician.
5. Prepare comparison tables, zone/load schedules, component lists, unresolved compatibility questions, and an approval package. Record Wes's selections separately from recommendations.

## Records And Boundaries

Use the central message record for routine routed intake and outcomes; do not append routine transactions to Git. Git holds durable requirements, design decisions, source references, and approved summaries. Store PDFs, images, drawings, spreadsheets, and other binary deliverables outside Git in an explicitly approved Teams/SharePoint location; none has been assigned yet.

This room owns lighting planning only. Home Assistant owns live Home Assistant configuration; Lowes Order owns authorized Lowe's cart work; other specialized actions must be delegated under their own rules. Do not contact vendors, send email, order equipment, change live systems, or edit another room without the required authority.

## Central Rules

Start PR: Before durable work, follow Start PR in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow C:\Codex\Wiki Files\Project Room Messaging Rule.md. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

Follow [[Project Room File Ownership And Git Coordination Rule]] and [[Git Work Scope Rule]]. Commit only owned durable work; push only when authorized or final under the current rules. Preserve unrelated changes.

## Next Actions

Complete dedicated-task registration and messaging readiness. Then gather the discovery inputs in [[Project Rooms/LED lighting/working/missing-context]]. No product selection or purchase has occurred.
