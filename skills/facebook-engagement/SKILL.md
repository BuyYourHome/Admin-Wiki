---
name: facebook-engagement
description: Prepare Facebook Page post drafts from photos or photo references that Wes explicitly makes available, including future authorized Google Photos sources. Use for Facebook Engagement Project Room intake, photo review, post-angle development, caption drafting, photo sequencing, accessibility notes, approval packaging, and outcome logging. Do not use for Facebook Marketplace seller work or for unapproved external Google/Facebook actions.
---

# Facebook Engagement

## Source Of Truth

- Project Room: `C:\Codex\Wiki Files\Project Rooms\Facebook Engagement`
- Skill source: `C:\Codex\Wiki Files\skills\facebook-engagement\SKILL.md`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Routing map: `C:\Codex\Wiki Files\Project Rooms\Jean Wright\working\dispatcher-routing-map.md`

## Required Startup

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `AGENTS.md`, `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, and `Project Room Delegation Contract.md`.
3. Read the Facebook Engagement README and its source inventory, conflict log, and missing-context file.
4. Check `git status --short --branch` and work on `main` unless Wes explicitly asks for a branch.

## Required Inputs

- A photo source Wes explicitly makes available for the requested run.
- The intended Facebook Page and audience.
- The post purpose, tone, timing, required facts, and desired call to action.
- Any consent, privacy, copyright, location, identity, or photo-use restrictions.

## Workflow

1. Confirm the source and requested draft belong to Facebook Engagement.
2. Confirm Wes explicitly made the photos or references available. Do not access Google Photos merely because a link, account, or connector exists.
3. Review only the authorized source set. Record source references without committing private photos, credentials, tokens, or unnecessary personal data.
4. Identify candidate photos, proposed order, observable details, and possible story angles.
5. Separate visible facts, Wes-supplied facts, recommendations, assumptions, and missing facts.
6. Prepare review-ready Facebook Page post drafts with suggested photo order, caption, optional call to action, hashtags, and accessibility notes when useful.
7. Save drafts under `C:\Codex\Wiki Files\Project Rooms\Facebook Engagement\outputs\` with descriptive Markdown filenames.
8. Update `working\facebook-engagement-action-log.md` with the source, output, status, approval state, and external outcome.
9. Return drafts to Wes for review. Do not publish, schedule, react, comment, message, contact anyone, or take another external Facebook action.
10. For any later posting request, verify Wes's specific final authorization for the exact Page, draft, photos, and timing immediately before acting, unless a later documented workflow explicitly grants that exact authority.

## Draft Standards

- Write for the stated Page audience and objective.
- Do not invent names, locations, dates, relationships, achievements, consent, or ownership from photos.
- Flag unsupported facts, privacy concerns, child-safety concerns, copyright risk, sensitive locations, or reputational concerns.
- Keep captions natural and engaging without fabricated testimonials or unsupported claims.

## Boundaries

- Do not access Google Photos or take Google account/album action during setup.
- Do not publish or schedule Facebook content without the required specific authorization.
- Do not react, comment, message, contact anyone, manage Page settings, buy ads, or take another external Facebook action unless explicitly authorized under a documented workflow.
- Do not handle Facebook Marketplace sourcing, seller evaluation, offers, or seller conversations; route those to Marketplace.
- Do not store passwords, session cookies, MFA codes, tokens, or other live secrets.
- Do not treat approval of a draft as approval to post it.

## Connector Preference

Use a purpose-built Google Photos or Facebook connector only when available, specifically required, and authorized for the exact access or external action. Otherwise use files, links, exports, screenshots, or source notes Wes explicitly provides. Do not substitute browser automation for missing authority.

## Outputs And Delivery

- Save drafts under `Project Rooms\Facebook Engagement\outputs\`.
- Return the draft path, source references, assumptions, open questions, and approval state.
- Report blocked access, missing facts, privacy concerns, or ambiguous authorization instead of guessing.

## Git Rules

- Commit only Facebook Engagement files and specifically authorized registry, routing, and index updates.
- Leave unrelated dirty work untouched.
- Push only under the Admin wiki push rules.

## Start PR Pointer

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.
