---
name: led-lighting
description: Plan Buy Your Home 24-volt LED lighting for house remodels, including switches, dimmers, controls, power supplies, component compatibility, and load schedules in the LED lighting Project Room. Use for lighting discovery, source review, comparisons, and planning documentation; not purchases or live electrical installation.
---

# LED lighting

## Source Of Truth And Startup

- Repository: `C:\Codex\Wiki Files`, branch `main`.
- Room: `C:\Codex\Wiki Files\Project Rooms\LED lighting`.
- Skill: `C:\Codex\Wiki Files\skills\led-lighting\SKILL.md`.
- Read the room README, source inventory, conflict log, and missing-context notes before planning. Read only source documents needed for the current question.
- Follow `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md` before durable changes. Leave unrelated work untouched.
- Dedicated task: `01a0b696-05a2-7291-a857-084a6f2bc2eb`; execution machine `WESSTUDIO`.

## Messaging Readiness

Pending messaging registration - not dispatchable. Manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\led-lighting.json`. Task creation alone does not satisfy the exact-recipient messaging gate. No automation is authorized by setup.

## Inputs And Owned Workflow

Use Wes's confirmed property, room/zone goals, measured runs, quantities, equipment models, control preferences, budget, and installer constraints. Record missing inputs instead of inventing a design.

1. Inventory authoritative specifications and drawings with model numbers, revisions, and source dates. Distinguish supplied facts from assumptions and proposed selections.
2. Compare the exact load, supply/driver, dimmer, and controller requirements. Verify voltage, load type, output and channel ratings, dimming interface, and environmental suitability from manufacturer documentation; a generic 24 V label is not sufficient compatibility evidence.
3. Build transparent load calculations with units, quantities/lengths, rated power, supply capacity/derating, channel limits, run lengths, and voltage-drop assumptions. Explain unresolved inputs. Do not certify code compliance or present unreviewed wiring as installation instructions.
4. Prepare a source-linked component comparison, zone/load schedule, compatibility checklist, and smallest remaining decisions. Mark recommended versus Wes-approved selections.
5. Keep review-ready Markdown in the room's `outputs` folder. Store binary sources/deliverables outside Git in the explicitly approved external project location; none is assigned at setup.

## Boundaries And Records

- Planning and documentation only unless a later exact instruction authorizes more. No purchases, payments, vendor contact, live wiring, device configuration, or external delivery from this setup request.
- Final installation, protection/wiring decisions, and applicable-code review belong to the responsible qualified electrician. Escalate incomplete or incompatible source requirements rather than guessing.
- Home Assistant owns live Home Assistant changes; Lowes Order owns authorized Lowe's cart work. Do not perform another PR's action or edit another PR's files locally.
- Use current authoritative product sources when research is authorized; observe any task-specific no-browsing restriction. Do not invent specifications or availability.
- Routine routed intake, deduplication, and outcomes use central messaging/runtime records. Git stores durable requirements, decisions, configuration, and approved summaries, not ordinary transaction rows.
- Commit only scoped durable work. Push only when Wes authorizes it or the deliverable meets the repository's final-publication rule. Report exact blockers, actual changes, commit/push status, and total elapsed time.

## Central Contracts

Start PR: Before durable work, follow Start PR in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow C:\Codex\Wiki Files\Project Room Messaging Rule.md. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
