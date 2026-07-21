---
name: manager
description: Use for Buy Your Home Manager project-room work, including Task mode, source organization, status tracking, review-ready outputs, and maintaining materials under `Project Rooms\Manager`.
---

# Manager

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Manager`
- Skill source: `C:\Codex\Wiki Files\skills\manager\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`

Use this skill when Wes asks Codex to work on Manager source organization, scope definition, review, drafting, documentation, or project-room maintenance for Buy Your Home.

## Manager Attributes

User-reported facts from Wes:

- Josh Kennedy is the Manager of Sell Your Home, LLC and Investment Services.
- Josh signs on behalf of legal documents through his Investment Services role.
- Josh's annual salary is `$65,000`.
- Josh's email address is `IRAManager@SellYourHomeRaleigh.com`.
- Josh's phone number is `919-961-5574`.
- A MoU in the Sell Your Home channel gives the specifics of Josh's contract.

Treat the MoU as the controlling source for contract-specific details after it is retrieved or preserved in the Project Room.

## Modes

### Task Mode

Use Task mode when any user adds a task for the Manager, asks for the task list or a task status, requests delivery of a task to the Manager, or provides a Manager status-update email.

Task register: `C:\Codex\Wiki Files\Project Rooms\Manager\working\task-register.md`

#### Add A Task

1. Assign a stable id in the form `MGR-YYYYMMDD-NNN`, using the next available sequence for that date.
2. Record the requester, received date and time, task description, priority, status, due date when supplied, and source reference when available.
3. Use priorities `Critical`, `High`, `Normal`, and `Low`; default to `Normal` when the requester does not specify one.
4. Set the initial status to `New`.
5. Record the task even when delivery is not requested. Do not silently treat task creation as authorization for a high-impact action or work owned by another Project Room.

#### Deliver A Task

Deliver only when the requester asks to send or deliver the task, or another applicable Admin wiki rule grants that delivery authority.

1. Send to Josh Kennedy at `IRAManager@SellYourHomeRaleigh.com`.
2. Use subject `[Manager Task][<Priority>][<Task ID>] <short title>`.
3. Include the task id, priority, requester, task, due date when any, and the instruction to reply with the task id and new status.
4. Follow `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`. Normally send from `OfficeAssist@BuyYourHomeLLC.com` and copy `WesWill@BuyYourHomeLLC.com` unless Wes explicitly says not to copy himself for that message.
5. Set status to `Delivered` only after verifying the sent copy in the approved sender mailbox's Sent Items. Record the sent message id and sent timestamp when available.
6. If send or Sent Items verification fails, keep the task visible as `New` or its prior status, record the failure in Delivery/Update Notes, and report the blocker immediately.

#### Process A Manager Email Update

1. Accept a Manager status update when the email is from `IRAManager@SellYourHomeRaleigh.com` and identifies an existing task id. If either check fails, request confirmation instead of changing the register.
2. Preserve the email under `sources\email\` or preserve a durable source note with sender, recipients, timestamp, subject, message id or link when available, and body text.
3. Map the stated update to one of: `Acknowledged`, `In Progress`, `Waiting`, `Completed`, or `Cancelled`. If the wording is ambiguous, preserve it and ask for clarification.
4. Update the task status, last-updated time, and source reference without overwriting the earlier delivery record.
5. An email status change does not authorize a purchase, payment, legal or financial change, deletion, or other high-impact action.
6. Process email updates when they are supplied or routed to this Project Room. Do not create or assume continuous mailbox monitoring unless Wes separately authorizes an automation.

## Start PR

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Required Startup

Before Manager file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Confirm the current branch is `main`.
3. Read `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Project Rooms\Manager\README.md`, and this skill source.
4. Read root rules needed for the request, including `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, and `Git Work Scope Rule.md`.
5. Check `git status --short --branch`.

## Workflow

1. Identify the Manager task, intended output, controlling sources, and any privacy, sharing, deadline, or external-action limit.
2. If contract-specific Manager details are needed, retrieve or use the MoU from the Sell Your Home channel before treating those details as source-verified.
3. Preserve source notes, exported messages, references, or source summaries in `sources\` when they are part of the durable source set.
4. Update `working\source-inventory.md` before drafting outputs.
5. Record duplicate, outdated, conflicting, or unclear source material in `working\duplicate-and-conflict-log.md`.
6. Record missing source files, workflow decisions, intended audience, deadlines, and approval points in `working\missing-context.md`.
7. Draft outputs in `outputs\` using authoritative sources only.
8. Mark unsupported assumptions as `[UNSUPPORTED]` instead of smoothing them into a final recommendation.
9. Commit only scoped Manager room, matching skill, registry, and index changes.

## Boundaries

- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Do not create Teams folders unless Wes explicitly asks.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not send email, external messages, make purchases, change legal/financial documents, or perform live operational actions unless Wes explicitly authorizes the specific action and the applicable Admin wiki rules allow it.
- If Manager work requires sending email, use the Admin wiki Email Delivery workflow used by Email Monitor by following `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md` for sender safety, attachment handling, Sent Items verification, local Outlook fallback rules, and failure reporting.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Manager\outputs` for review-ready drafts, summaries, checklists, handoff notes, and final deliverables.
