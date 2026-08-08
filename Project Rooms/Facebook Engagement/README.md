# Facebook Engagement Project Room

## Purpose

Prepare engaging Facebook Page post drafts from photos that Wes later makes available through an authorized Google Photos source. This room supports photo review, content planning, and draft preparation only until a specific external action is authorized.

## Scope

In scope:

- Review photos or photo references that Wes explicitly makes available.
- Identify photo groupings, sequence, observable details, and story angles.
- Prepare Page post drafts with suggested photo order, captions, optional calls to action, hashtags, and accessibility notes.
- Separate facts visible in photos from Wes-supplied facts and drafting assumptions.
- Save drafts under `outputs\` and log outcomes in `working\facebook-engagement-action-log.md`.

Out of scope unless separately authorized under a documented workflow:

- Accessing Google Photos, opening albums, downloading photos, or changing Google account/album state.
- Publishing or scheduling Facebook posts.
- Reacting, commenting, messaging, contacting anyone, managing Page settings, buying ads, or taking another external Facebook action.
- Facebook Marketplace sourcing or seller conversations; those belong to Marketplace.

Each external Facebook post requires Wes's specific final authorization unless a later documented workflow explicitly grants that exact authority.

## Required Inputs

- The Google Photos album, photo set, or other source Wes explicitly makes available.
- The intended Facebook Page, audience, purpose, timing, tone, facts, and call to action.
- Consent, privacy, copyright, location, identity, or photo-use restrictions.

Do not infer consent, ownership, identity, location, or sensitive facts from photos.

## Folder Map

- `sources\` - authorized source references and notes; do not commit private photos or credentials.
- `working\source-inventory.md` - source status and authority.
- `working\duplicate-and-conflict-log.md` - duplicate, outdated, conflicting, or unclear inputs.
- `working\missing-context.md` - decisions or facts needed before drafting or external action.
- `working\facebook-engagement-action-log.md` - durable outcomes, approvals, blockers, and authorized external results.
- `outputs\` - review-ready Page post drafts.

## Workflow

1. Confirm Wes explicitly made the source available.
2. Confirm the intended Page, audience, purpose, tone, timing, facts, and restrictions.
3. Review only the authorized photos or references and update the source inventory.
4. Record conflicts, privacy concerns, and missing facts without guessing.
5. Prepare drafts that identify proposed photo order and distinguish observed facts, supplied facts, and assumptions.
6. Save drafts under `outputs\` and update the action log.
7. Return drafts to Wes. Do not take any external Google/Facebook action.
8. For a later posting request, verify the exact Page, draft, photos, timing, and specific final authorization immediately before acting.

## Current Status

Status: active and dispatchable.

The dedicated Facebook Engagement task is registered. No Google Photos or Facebook action has been performed.

## Matching Skill

- `C:\Codex\Wiki Files\skills\facebook-engagement\SKILL.md`

## Dedicated Chat

- Chat name: `Facebook Engagement`
- Thread id: `019fe20a-db88-7602-a4a7-544d1be0ceee`
- Purpose: review authorized photo sources and prepare Page post drafts under this room's approval boundaries.

## Automation

- None.

## Main And Push

- Work on `main`.
- Follow `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`.
- Commit only Facebook Engagement files and specifically authorized registry, routing, and index updates.
- Push only under the Admin wiki push rules.

## Start PR Pointer

Start PR: Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.

## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.

## Next Actions

1. Wait for Wes to make a specific photo source available and request a draft run.
