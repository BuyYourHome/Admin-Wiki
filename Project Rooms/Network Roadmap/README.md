# Network Roadmap Project Room

## Purpose

Plan and govern Buy Your Home network and device-management modernization across WesStudio, OfficeAssist, WES-VIDEOEDITOR, and future business computers.

The initial direction is to evaluate Microsoft Entra ID join and Intune through a noncritical pilot instead of deploying traditional on-premises Active Directory solely to solve current workgroup credential friction.

## Status

- Project Room: `Network Roadmap`
- Setup status: Active planning
- Dedicated task ID: `01a02e19-01af-79a1-a770-42298d31eed6`
- Dispatchable: Yes
- Current phase: Phase 0 - baseline and prerequisites

## Default Workflow

Use `Roadmap` mode unless Wes names another mode.

## Modes

- `Roadmap`: Maintain the phased modernization plan, decisions, dependencies, and rollout gates.
- `Audit`: Inventory identity, Windows edition, licensing, network, SMB, remote access, and device-management state without making changes.
- `Pilot`: Prepare and execute an explicitly approved noncritical Entra ID and Intune pilot.
- `Rollout`: Plan and execute explicitly approved staged production enrollment after pilot acceptance.
- `Messaging Transport`: Evaluate and implement an explicitly approved replacement or hardening plan for the Project Room messaging transport.

## Scope

- Microsoft Entra ID and Intune readiness, licensing, and pilot planning.
- Windows device identity and management baselines.
- Network and remote-access inventory relevant to business workflows.
- Credential, SMB, and Project Room messaging transport architecture.
- Migration sequencing, rollback plans, validation, and operating documentation.

## Actions Requiring Exact Approval

Do not perform these merely because they appear in the roadmap:

- Join, leave, enroll, reset, or rename a device.
- Change user accounts, credentials, security policy, firewall, VPN, sharing, or access control.
- Purchase or change Microsoft licensing or another service.
- Move, replace, or reconfigure the authoritative Project Room messaging queue.
- Install server roles or create a traditional Active Directory domain.
- Interrupt Email Monitor, Doc Scan, Invoice Entry, or another production workflow.

## Initial Milestones

1. Verify Microsoft 365 licensing and Windows editions.
2. Complete a read-only identity, network, and workflow dependency baseline.
3. Select one noncritical Windows Pro device for the pilot.
4. Define pilot success, rollback, and support criteria.
5. Execute the pilot only after Wes approves the exact device and changes.
6. Stage production rollout only after pilot acceptance.
7. Evaluate messaging transport separately from device enrollment.

## Folder Map

- `sources/`: authoritative references and the originating recommendation.
- `working/`: inventories, open questions, decision logs, and implementation records.
- `outputs/`: review-ready roadmap and future approved implementation packages.

## Operating Rules

- Work on `main` unless Wes explicitly directs otherwise.
- Keep commits limited to Network Roadmap-owned files and explicitly authorized shared metadata.
- Before delegated work, reconcile the durable dispatch record, return `accepted`, record `Processing`, and finish with a valid final state under the exact task identity.

## Ownership

- Network Roadmap owns this room and `skills/network-roadmap/`.
- Computers owns the durable business-computer inventory.
- Codex Environment owns approved installation and environment replication work on other computers.
- Changes to shared Project Room messaging rules require explicit authorization and coordinated ownership.

## Required Operating Rules

- [[Project Room Chat Startup Rule]]
- [[Project Room Delegation Contract]]
- [[Project Room File Ownership And Git Coordination Rule]]
- [[Project Room Messaging Rule]]
- [[Git Work Scope Rule]]
- [[Codex Skill Source Rule]]
