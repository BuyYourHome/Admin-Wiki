---
name: medicare
description: Compare Medicare plan options using authorized prescription and coverage inputs, including Jenny's emailed list, in the Medicare Project Room. Prepare source-backed recommendations; do not enroll, change insurance, or advise medication changes.
---

# Medicare

## Source Of Truth

- Room: `C:\Codex\Wiki Files\Project Rooms\Medicare`.
- Skill: `C:\Codex\Wiki Files\skills\medicare\SKILL.md`.
- Read the room README and working source inventory, conflict log and missing-context notes before comparison work.
- Task id: pending until the dedicated chat is created. Machine: WESSTUDIO.

## Workflow

Use the README's intake and comparison workflow. Jenny's email is expected, not yet received. Confirm the plan year explicitly; do not interpret "this year" as a settled 2027 choice. Confirm ZIP/county, current coverage, plan category, exact drugs/doses/forms/quantities/refills and pharmacies. For Medicare Advantage also consider doctors, hospitals and medical benefits; prescriptions alone cannot establish the best overall plan.

Prefer authorized Outlook connector references through Email Monitor/Jean intake. Do not scan mailboxes or install polling merely because an email is expected. Direct user-provided intake is allowed. Preserve originals and resolve ambiguous medication details with Jenny.

Use live official Medicare/insurer sources for the exact year and location before making recommendations. Compare total estimated annual costs, formulary restrictions, pharmacy/network fit and relevant medical exposure; disclose assumptions and gaps. No recommendation until sufficient inputs and current authoritative evidence exist. If browsing is restricted in the active comparison session, report the evidence limitation or use authorized official documents supplied by the user.

Keep prescription lists, diagnoses, identifiers, full emails and individualized reports outside Git and shared transport payloads. Confirm private storage/audience before saving or disclosing health information. Public research queries must not identify Jenny or expose her complete medication profile; use only the minimal data necessary in an authorized official comparison tool. Never request SSN or Medicare/member numbers merely to compare plans.

No enrollment, cancellation, payment, insurer contact, account changes or medication changes. Provide decision support with sources, not a coverage guarantee. Follow the confirmation/resume rule if a new action needs approval; retain existing authority without asking for a repeated go.

## Outputs And Logging

Return a private, evidence-backed comparison and recommendation with alternatives, annual cost assumptions, restrictions, exact plan IDs and dates. Follow the room's output and outcome-logging policies. No routine personal transaction rows in Git.

## Messaging Readiness

- Status: Pending messaging registration - not dispatchable.
- Dispatchable: No.
- Manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\medicare.json`.
- Task identity, local registration, host access, guarded worker enrollment and unattended synthetic validation must pass before production routing. No automation is configured.

## Operating Rules

Start PR: Before durable work, follow Start PR in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow C:\Codex\Wiki Files\Project Room Messaging Rule.md. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

Follow `Project Room File Ownership And Git Coordination Rule.md`, `Project Room Confirmation And Resume Rule.md`, `Git Work Scope Rule.md`, `Codex Skill Source Rule.md`, and `skills\admin-request-wrapup\SKILL.md`. Commit only scoped non-sensitive policy; preserve unrelated work; push only when authorized or final. No authority to edit other rooms or skills.
