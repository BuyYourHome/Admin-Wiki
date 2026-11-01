# Medicare Project Room

## Purpose

Help Jenny compare Medicare coverage using the prescriptions she provides and recommend the best-supported plan for her confirmed needs and coverage year. Wes requested this room on 2026-11-01. No plan recommendation has been made.

## Scope And Boundaries

- Own prescription-based plan research, source verification, annual-cost comparisons, and a recommendation with alternatives and uncertainties.
- Confirm the coverage year before researching plans. 2027 is a provisional interpretation of the November 2026 request, not a confirmed choice.
- Confirm standalone Part D versus Medicare Advantage before comparing; do not infer a coverage switch from a prescription list.
- No enrollment, cancellation, payment, insurance-account change, contacting insurers, or medication changes are authorized. Recommendation is decision support, not medical advice or a coverage guarantee.
- Keep personal prescription lists, diagnoses, Medicare/member numbers, birth dates, full emails, and individualized cost reports out of Git and transport payloads. Retain original email in Outlook; use access-controlled non-Git storage only after its location and audience are confirmed. Do not request SSNs or Medicare numbers for comparison.

## Workflow

1. Receive Jenny's source email through authorized Email Monitor/Jean intake or direct user-provided material. Suggested email subject: `Medicare - prescription list and plan comparison`. No new mailbox monitoring or automation is installed by this setup.
2. Confirm year, residence ZIP/county, current coverage, plan category, pharmacy preferences, medication name/strength/form, quantity and refill frequency; ask about doctors/hospitals if evaluating Medicare Advantage. Confirm any relevant assistance eligibility without collecting unnecessary financial detail.
3. Resolve missing/unclear drug names and conflicting versions with Jenny; never guess dosage or recommend changing treatment to fit a plan.
4. Research current-year official Medicare Plan Finder and insurer formulary, pharmacy/network and coverage documents. Date sources and identify exact plan IDs/year/geography. If live access or the requested year's data is unavailable, stop short of a definitive recommendation and disclose the gap.
5. Compare estimated annual premiums plus covered and uncovered drug costs, deductibles, pharmacy differences, restrictions (prior authorization, step therapy, quantity limits), and relevant medical costs/networks. Avoid double-counting deductibles already included in estimates. Do not rank solely by premium.
6. Recommend a best-fit option and practical alternatives with assumptions, tradeoffs, evidence and unresolved checks. Verify high-impact details with official plan materials; suggest independent SHIP counseling when useful. No enrollment without separate specific authorization and required beneficiary consent.

## Folder Map

- `sources/README.md`: source/privacy policy; references only.
- `working/source-inventory.md`: setup sources and missing evidence, no health details.
- `working/duplicate-and-conflict-log.md`: version/conflict handling.
- `working/missing-context.md`: required intake.
- `working/medicare-outcome-log.md`: logging policy, not a personal transaction ledger.
- `outputs/README.md`: comparison deliverable requirements and privacy boundary.

## Dedicated Chat And Skill

- Chat name: Medicare.
- Task id: `01a198bd-6bd0-7013-bd02-2b26a715e552`.
- Execution machine: WESSTUDIO; project: `C:\Codex\Wiki Files`.
- Skill: `C:\Codex\Wiki Files\skills\medicare\SKILL.md`.
- Trigger: on demand or a verified authorized handoff after readiness; no automation.

## Messaging Readiness

- Status: Pending messaging registration - not dispatchable.
- Dispatchable: No.
- Manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\medicare.json`.
- Exact WESSTUDIO client registration and authenticated host access verified 2026-11-01; all 12 prior registrations preserved.
- Blocker: guarded installer 0.4.10 admits only Codex Environment, Smart House and House Render. Medicare requires worker-owner enrollment support and unattended synthetic validation. No worker configuration or synthetic record was changed/created.
- A dedicated chat alone is not automatic email routing. Exact registration, host access, guarded enrollment and unattended synthetic lifecycle are required before delegation.

## Operating Rules

Start PR: Before durable work, follow Start PR in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow C:\Codex\Wiki Files\Project Room Messaging Rule.md. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

Follow [[Project Room File Ownership And Git Coordination Rule]], [[Project Room Confirmation And Resume Rule]], [[Git Work Scope Rule]] and [[Codex Skill Source Rule]]. Commit only scoped non-sensitive policy/configuration; push only under the normal rules. Do not edit Email Monitor or another room's skill from this room.
