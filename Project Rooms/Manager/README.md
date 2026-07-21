# Manager Project Room

## Purpose

This Project Room holds source material, working notes, open questions, and review-ready outputs for the Manager workflow.

Use this room when Wes asks Codex to organize, define, draft, review, or maintain materials specifically routed to Manager.

## Scope

In scope:

- Manager-related source notes, documents, emails, screenshots, references, and source summaries.
- Working inventories, missing-context notes, duplicate/conflict tracking, and review questions.
- Review-ready outputs under `outputs\`.
- Matching wiki-managed skill instructions under `C:\Codex\Wiki Files\skills\manager\SKILL.md`.

Out of scope:

- Editing another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Creating Teams folders unless Wes explicitly asks for a final deliverable there.
- Creating automations unless Wes explicitly asks for scheduled or event-triggered behavior.
- Sending email, external messages, purchases, legal/financial changes, or live operational actions unless Wes explicitly authorizes the specific action and the applicable workflow rules allow it.

## Folder Map

- `sources\` - source notes, exported messages, references, and source summaries.
- `working\source-inventory.md` - inventory of source material and authority status.
- `working\duplicate-and-conflict-log.md` - duplicate, outdated, conflicting, or unclear source notes.
- `working\missing-context.md` - facts, decisions, or source material still needed.
- `outputs\` - review-ready drafts, summaries, handoffs, or final deliverables.

## Current Status

Status: active draft.

The room has been created as a standard Project Room shell. Wes has provided initial Manager attributes for Josh Kennedy. The controlling MoU source still needs to be retrieved from the Sell Your Home channel before contract-specific details are treated as source-verified.

## Manager Attributes

User-reported facts from Wes:

- Josh Kennedy is the Manager of Sell Your Home, LLC and Investment Services.
- Josh signs on behalf of legal documents through his Investment Services role.
- Josh's annual salary is `$65,000`.
- Josh's email address is `IRAManager@SellYourHomeRaleigh.com`.
- Josh's phone number is `919-961-5574`.
- A MoU in the Sell Your Home channel gives the specifics of Josh's contract.

## Email Delivery Rule

If Manager work requires sending email, use the Admin wiki Email Delivery workflow used by Email Monitor:

- Follow `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md` for sender safety, approved recipients, attachment handling, Outlook connector preference, Sent Items verification, local Outlook fallback rules, and failure reporting.
- Do not send email from Manager work unless Wes explicitly authorizes the specific email action or an applicable Admin wiki rule already grants that authority.
- If the MoU or another source changes email authority, record the source and update this rule before relying on it.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\manager\SKILL.md`

## Dedicated Chat

- Chat name: `Manager`
- Thread id: `pending until the dedicated chat is created`

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Ownership And Git Mode

- Working branch: `main`
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and the current branch is `main`.
- Follow `Project Room File Ownership And Git Coordination Rule.md` for Project Room ownership, shared Admin files, cross-PR edits, fetch/pull safety, commit scope, and push safety.
- Commit only scoped Manager room, matching skill, and directly related registry/index changes.
- Push only when Wes explicitly asks, says the work is finished, or the applicable Admin wiki rules define the deliverable as final and ready to publish.

## Next Actions

1. Retrieve or preserve the MoU from the Sell Your Home channel as a controlling source.
2. Confirm the exact legal name behind "Investment Services" when legal-document signature wording matters.
3. Decide whether Manager needs a dedicated chat, automation, or only an on-demand Project Room.
