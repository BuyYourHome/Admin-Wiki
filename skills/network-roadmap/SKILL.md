---
name: network-roadmap
description: Use for Buy Your Home Network Roadmap project-room work, including network and Windows identity inventories, Microsoft Entra ID and Intune readiness, noncritical pilot planning, staged device rollout, SMB and Project Room messaging transport architecture, rollback plans, and materials under `Project Rooms\Network Roadmap`.
---

# Network Roadmap

## Start Here

1. Read `Project Rooms\Network Roadmap\README.md`.
2. Read `Project Rooms\Network Roadmap\working\network-baseline.md`.
3. Read `Project Rooms\Network Roadmap\outputs\Network Modernization Roadmap.md`.
4. Read `Project Room File Ownership And Git Coordination Rule.md` before durable edits.

## Modes

- `Roadmap`: Maintain phases, decisions, gates, dependencies, and next actions.
- `Audit`: Perform read-only inventory and record verified versus unverified facts.
- `Pilot`: Design or perform an exactly approved noncritical Entra ID and Intune pilot.
- `Rollout`: Plan or perform an exactly approved staged production enrollment.
- `Messaging Transport`: Evaluate or perform an exactly approved messaging transport change.

## Operating Rules

- Default to `Roadmap` mode.
- Keep verified facts separate from recommendations and missing context.
- Prefer current Microsoft primary documentation for Entra ID, Intune, and Windows requirements.
- Do not assume a license, Windows edition, join state, encryption state, or policy assignment.
- Do not deploy traditional Active Directory merely to resolve isolated workgroup credential friction.
- Keep device-management modernization separate from Project Room messaging transport changes.
- Preserve the current messaging lifecycle, deduplication, immutable payload, and audit requirements in any replacement design.

## Approval Boundary

Wes must approve the exact device and action before joining, leaving, enrolling, renaming, resetting, changing credentials or security, purchasing licensing, changing shares, installing server roles, moving the central queue, or interrupting a production workflow.

## Ownership Boundary

- Edit this room and this skill for Network Roadmap work.
- Coordinate computer inventory changes with Computers.
- Route approved remote setup or environment replication through Codex Environment.
- Do not edit another Project Room's owned files without explicit authorization.

## Completion

Record durable findings and decisions in the room. Report what was verified, what changed, what remains unverified, the next approval gate, Git status, and total request time.

