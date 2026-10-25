# Smart House

## Purpose And Scope

Plan the digital identity, website/digital twin, buyer demonstrations, owner knowledge, and transferable digital package for **Pondster, the house at 908 Pond Street**. This is more than a property listing. It connects source-backed house information with a public educational experience, a constrained showing experience, and a future authenticated owner portal.

Wes authorized beginning the Pond Street website in this chat on 2026-10-18, then reported purchasing `Pondstr.com` through GoDaddy and requested ChatGPT hosting. The first implementation under `site/` includes simulated lighting and a planned owner-information library. ChatGPT Sites hosting and connecting the purchased domain are now in scope. Purchases, live device connections/control, and production home automations remain outside scope. Wes requested public access without login on 2026-10-23; the existing website is now public.

On 2026-10-24 Wes clarified that he does not need to approve every routine website action. A direct website request authorizes its ordinary implementation, checks, and publication; do not add separate conversational approval questions for those steps. Reuse established permissions where available. Required app access controls and the existing boundaries for purchases, private records, audience changes, and live devices still apply.

**Pondster is the public voice and identity of the house. Jean Wright is its SI designer.** Wes corrected the designer's name on 2026-10-24; the earlier Dean wording is superseded. All authored website storytelling, metadata, gallery descriptions, feedback, and guide responses use Pondster's first-person voice: I, my, and me, including "Meet Ashley, my realtor." Preserve visitors' comments and composed email text, external credits, and required notices in their original voices; functional menus, labels, and names may remain neutral. The designer credit is static text. Every question goes to Pondster through the persistent typed/optional-voice guide across Design, Explore, View, Own, and Built By; only Pondster is a voice wake name. Public comment sections remain available for thoughts, with an Ask me control for questions. See [[Project Rooms/Smart House/working/pondster-identity-and-guide]].

As clarified on 2026-10-24, only the property's location and address are confidential; Pondster's identity is public. The opening introduces Pondster clearly and makes a playful witness-protection joke about keeping the location secret. Keep the internal property association for room operations; do not include the location in public copy, metadata, guide answers, or viewing-request links. Ashley's verified official portrait is featured on View.

Wes requested a comment section on every page on 2026-10-24. Each of the five main pages has its own public, saved conversation without sign-in; see [[Project Rooms/Smart House/working/page-comments]].

## Status And Ownership

- Status: public website with no visitor login required, deployed through ChatGPT Sites at https://pondstr.com . DNS, domain routing, and HTTPS certificate verified active. Messaging ready and dispatchable on WESSTUDIO.
- Dedicated chat: `Smart House`, task `01a14585-ffe6-7850-8db1-efcdd58e7071`.
- Execution machine: WESSTUDIO.
- Matching skill: `C:\Codex\Wiki Files\skills\smart-house\SKILL.md`.
- Repository: `C:\Codex\Wiki Files`; branch `main`.
- Schedule: on demand; no automation requested or created.
- Setup authority: central message `prmsg-jean-create-pr-smart-house-20261016-001`; dispatch `jeans-voice-20261016-create-smart-house-project-room-v1`.
- Start with [[Project Rooms/Smart House/working/planning-context]] and the preserved [[Project Rooms/Smart House/sources/planning-conversation-2026-10-16]].

## Messaging Readiness

Ready and dispatchable for authorized Smart House handoffs on WESSTUDIO. The exact task, registration, host access, guarded worker enrollment, and unattended cross-machine synthetic lifecycle were verified. Messaging readiness does not expand business authority.

Exact local registration verified on WESSTUDIO at 2026-10-16T16:23:10.0889494Z; authenticated central-manager access verified. Synthetic `prmsg-wve-smart-house-validation-20261016-001` completed after one delivered natural-worker attempt at 2026-10-17T01:49:56.633467Z without manual intervention or business action. Canonical manifest: `config\pr-messaging-manifests\smart-house.json`.

## Planning Workflow

1. Read the source inventory and planning context; distinguish Wes requirements, assistant proposals, and verified implementation facts.
2. Locate exact property Teams references and current specifications when authorized; preserve references rather than duplicating binaries.
3. Coordinate lighting specifications with LED lighting and live integrations/configuration with Home Assistant. Do not recreate or edit their owned specifications.
4. Develop property-level information architecture and system records only when Wes authorizes the next phase.
5. Keep public, showing, owner, and internal BYH information/access distinct. Public demonstrations are simulated; real controls require approved authenticated boundaries.
6. Prepare an exportable owner package separately from BYH costs, negotiations, construction notes, and sales strategy. Verify account-transfer/service capabilities before depending on them.

## Folder Map And Records

- `sources/`: source conversation and authoritative external references.
- `working/`: planning brief, source inventory, conflicts, missing context, and setup evidence.
- `outputs/`: review-ready Markdown plans when authorized.
- `site/index.html`: the earlier portable website concept. Current gallery application sources are in `site/gallery-source/`; the supported Sites runtime and deployment checkout are in ignored `site/.hosting-work/`. Scenes and architectural illustrations are conceptual, not actual plans or device controls.

This planning-only room does not need a routine transaction log at setup. Central messages own delegated operational receipts/results. Record durable design decisions with source references when future work warrants them. Store binary source material and deliverables outside Git in a verified approved location.

## Boundaries And Next Actions

Wes authorized Pondster's natural OpenAI voice connection on 2026-10-25. The implementation is prepared locally, with public-only house context and browser speech retained; activation is waiting for the required secure OpenAI Developers API setup. Production is version 31, adding the full theater/staircase image and 12-second film in both Media Center and Spiral Staircase without publishing the pending voice integration. See [[Project Rooms/Smart House/working/pondster-natural-voice]] for verification limits and the automatic continuation, and [[Project Rooms/Smart House/working/theater-and-staircase]] for the new assets.

Wes subsequently authorized website implementation and public Sites hosting at `https://pondstr.com`. Preserve public browsing without a login gate. See [[Project Rooms/Smart House/working/hosting-and-domain]] for deployment identity and [[Project Rooms/Smart House/working/design-galleries-and-voting]] for the Design, Explore, View, Manage navigation and gallery voting requirements. View now features Ashley Morello and a clearly labeled self-viewing calendar/code demonstration; see [[Project Rooms/Smart House/working/viewing-and-realtor]]. The current menu order is Design, Explore, View, Own, Built By. Own is the renamed Manage page; legacy #manage links continue to open Own. The Built By menu features Buy Your Home, LLC using its official website; see [[Project Rooms/Smart House/working/built-by-page]]. Live device configuration and private owner records remain outside this public website.

## Central Rules

Start PR: Before durable work, follow Start PR in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

Delegation Contract: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

Action Ownership: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

PR Messaging: Follow C:\Codex\Wiki Files\Project Room Messaging Rule.md. The central message record is authoritative; task messages are wake-up signals, not delivery proof.

Follow C:\Codex\Wiki Files\Project Room Confirmation And Resume Rule.md for genuine approval blockers and automatic continuation. Follow Project Room File Ownership And Git Coordination Rule.md and Git Work Scope Rule.md; commit only owned authorized work, preserve unrelated edits, and push only under the normal rules.
