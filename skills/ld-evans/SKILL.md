---
name: ld-evans
description: Use for Buy Your Home LD Evans project-room work, including organizing sources, tracking missing context, drafting review-ready outputs, and maintaining materials under `Project Rooms\LD Evans`.
---

# LD Evans

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\LD Evans`
- Skill source: `C:\Codex\Wiki Files\skills\ld-evans\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`

Use this skill when Wes asks Codex to work on LD Evans source organization, analysis, drafting, review, or documentation for Buy Your Home.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before LD Evans file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\LD Evans\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, and `Git Work Scope Rule.md`.
5. Check `git status --short --branch`.

## Workflow

1. Identify the LD Evans task, intended output, and any deadline or external-action limit.
2. Put source material, exports, notes, screenshots, or source summaries in `sources\`.
3. Update `working\source-inventory.md` before drafting outputs.
4. Record duplicate, outdated, conflicting, or unclear source material in `working\duplicate-and-conflict-log.md`.
5. Record missing facts, documents, deadlines, and decision points in `working\missing-context.md`.
6. Draft outputs in `outputs\` using authoritative sources only.
7. Mark unsupported assumptions as `[UNSUPPORTED]` instead of smoothing them into a final recommendation.
8. Commit only scoped LD Evans room, matching skill, registry, and index changes.

## Boundaries

- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Do not create Teams folders unless Wes explicitly asks.
- Do not move source files from another Project Room unless Wes authorizes that move.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not send emails, file external documents, approve legal or financial decisions, or take external workflow action unless Wes explicitly authorizes that specific action and the applicable Admin wiki rules allow it.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\LD Evans\outputs` for review-ready drafts, summaries, checklists, handoff notes, and final deliverables.

## Manuscript And Deliverable Email Rule

Whenever the LD Evans manuscript or another review-ready file under `outputs\` is created or materially changed:

1. Finish and verify the changed deliverable.
2. Commit the scoped LD Evans change when the Admin wiki rules call for a durable commit.
3. Prepare the final delivery package to `WesWill@BuyYourHomeLLC.com` from `OfficeAssist@BuyYourHomeLLC.com`.
4. Use a plain subject that identifies the LD Evans deliverable and that it was updated. Do not use the `DRAFT:` prefix merely because a manuscript is a working draft; the email is delivering a file for Wes's review, not proposing an outbound email message.
5. Attach the changed deliverable. Do not silently request delivery without the attachment.
6. Send a direct handoff to the existing Email Monitor status task `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`, explicitly requesting Email Delivery mode. Include sender, To, CC/BCC, subject, plain-text body, absolute attachment paths, authorization basis, and any stricter LD Evans restrictions.
7. Email Monitor's Email Delivery mode must use `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md` for OfficeAssist sender safety, connector/local-Outlook handling, attachment validation, Sent Items verification, delivery logging, and failure reporting.
8. Treat the manuscript or deliverable update as incomplete until Email Monitor returns a verified OfficeAssist Sent Items result with the sent message id and timestamp. Report any send or verification failure immediately in the LD Evans thread.

Working-note, transcript, source-inventory, and administrative-only changes do not trigger an email unless they also create or materially change a review-ready file under `outputs\`. This boundary prevents delivery-log or housekeeping changes from creating a recursive email loop.
