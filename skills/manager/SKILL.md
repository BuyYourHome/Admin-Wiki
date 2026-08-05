---
name: manager
description: Use for Buy Your Home Manager project-room work, including Tasks, Time Card tracking and Invoice Entry handoffs, Email Monitor Manager Routing handoffs, source organization, status tracking, review-ready outputs, and maintaining materials under `Project Rooms\Manager`.
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

### Tasks

Use Tasks when any user adds a task for the Manager, asks for the task list or a task status, requests delivery of a task to the Manager, or provides a Manager status-update email.

Task register: `C:\Codex\Wiki Files\Project Rooms\Manager\working\task-register.md`

#### Task ID Display

- Keep the full canonical id in the form `MGR-YYYYMMDD-NNN` in the task register, routing ledger, source notes, and other internal records.
- Display only the final three digits (`NNN`) in task lists, daily-summary sections, chat status reports, and Manager task-delivery or status-update emails. For example, display `MGR-20260724-001` as `001`.
- The three-digit display number must be unique across the entire Manager task register. Assign the next unused three-digit number without resetting the sequence on a new date, and never reuse a number from a completed, cancelled, deleted, or otherwise historical task.
- Accept either the three-digit display number or the full canonical id when a user or authorized email references a task. Resolve the display number to the full internal id; ask for clarification if it does not identify exactly one task.

#### Manager Routing Intake

Use a direct `Manager Routing` handoff from the Email Monitor task as the trigger to process one routed email. Do not query or continuously monitor any mailbox.

Require the handoff to provide:

- routed Markdown source path;
- attachment paths or an attachment-access blocker;
- email sender;
- short summary;
- Outlook message ID or link when available.

Process the handoff:

1. Verify the routed Markdown source exists under `C:\Codex\Wiki Files\Project Rooms\Manager\sources\`. Read it completely and review available routed attachments when needed. Do not substitute another mailbox, source, or attachment when access is blocked.
2. Check `working\manager-routing-ledger.md`, `working\source-inventory.md`, and `working\task-register.md` for the routed source path and Outlook message ID or link. If already processed, do not process it again; report the prior result.
3. Classify the email as one of:
   - new Manager task request;
   - delivery-related message;
   - Manager status update;
   - clarification required.
4. For a new task, follow **Add A Task** below. Use the email received date for `MGR-YYYYMMDD-NNN` when available, otherwise use the processing date. Default priority to `Normal` and status to `New`.
5. For a delivery-related message, identify the existing task ID and record supported delivery evidence or notes without overwriting prior history. Mark `Delivered` only from verified Email Monitor or approved-sender Sent Items evidence.
6. For a status update, follow **Process A Manager Email Update** below. Accept it only from `IRAManager@SellYourHomeRaleigh.com` when it identifies an existing task ID and maps clearly to an allowed status.
7. If the sender, task ID, requested status, source, attachment access, or authority is ambiguous, preserve the source and request clarification without changing task status.
8. Do not treat the routed email as authorization for payment, purchases, legal or financial changes, deletion, or any other high-impact action.
9. Add or update the routed source in `working\source-inventory.md` when it becomes part of the durable source set. Record the Outlook ID/link, classification, result, task ID when any, and attachment paths or blocker in `working\manager-routing-ledger.md`.
10. Report the resulting new task ID, delivery update, status change, duplicate result, or clarification request in the Manager task.

#### Add A Task

1. Assign a stable id in the form `MGR-YYYYMMDD-NNN`. Use the received or processing date for `YYYYMMDD` and the next unused three-digit display number across the entire register for `NNN`; do not reset or reuse the suffix by date.
2. Record the requester, received date and time, task description, priority, status, due date when supplied, and source reference when available.
3. Use priorities `Critical`, `High`, `Normal`, and `Low`; default to `Normal` when the requester does not specify one.
4. Set the initial status to `New`.
5. Record the task even when delivery is not requested. Do not silently treat task creation as authorization for a high-impact action or work owned by another Project Room.

#### Deliver A Task

Deliver only when the requester asks to send or deliver the task, or another applicable Admin wiki rule grants that delivery authority.

1. Prepare the delivery package to Josh Kennedy at `IRAManager@SellYourHomeRaleigh.com`.
2. Use subject `[Manager Task][<Priority>][<three-digit display number>] <short title>`.
3. Include the three-digit display number, priority, requester, task, due date when any, and the instruction to reply with that display number and the new status.
4. Normally set sender to `OfficeAssist@BuyYourHomeLLC.com` and copy `WesWill@BuyYourHomeLLC.com` unless Wes explicitly says not to copy himself for that message.
5. Send a direct handoff to the existing Email Monitor status task `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`, explicitly requesting Email Delivery mode. Include sender, To, CC/BCC, subject, plain-text body, attachment paths if any, authorization basis, and any stricter Manager restrictions.
6. Set status to `Delivered` only after Email Monitor returns a verified sent copy in the approved sender mailbox's Sent Items. Record the sent message id and sent timestamp when available.
7. If send or Sent Items verification fails, keep the task visible as `New` or its prior status, record the failure in Delivery/Update Notes, and report the blocker immediately.

#### Process A Manager Email Update

1. Accept a Manager status update when the email is from `IRAManager@SellYourHomeRaleigh.com` and identifies an existing task id. If either check fails, request confirmation instead of changing the register.
2. Preserve the email under `sources\email\` or preserve a durable source note with sender, recipients, timestamp, subject, message id or link when available, and body text.
3. Map the stated update to one of: `Acknowledged`, `In Progress`, `Waiting`, `Completed`, or `Cancelled`. If the wording is ambiguous, preserve it and ask for clarification.
4. Update the task status, last-updated time, and source reference without overwriting the earlier delivery record.
5. An email status change does not authorize a purchase, payment, legal or financial change, deletion, or other high-impact action.
6. Process email updates when they are supplied directly or arrive through a direct Email Monitor `Manager Routing` handoff. Do not query or continuously monitor a mailbox.

### Time Card

Use Time Card when Wes asks to record, correct, display, total, or hand off time worked by the Manager and the tasks performed.

Time register: `C:\Codex\Wiki Files\Project Rooms\Manager\working\time-card-register.md`

Invoice Entry contract: `C:\Codex\Wiki Files\Project Rooms\Manager\working\time-card-invoice-entry-handoff-contract.md`

Handoff log: `C:\Codex\Wiki Files\Project Rooms\Manager\working\time-card-handoff-log.md`

#### Record Time

1. Accept a time line when Wes supplies it directly, Josh Kennedy supplies it through a source with verified identity, or an authorized handoff supplies sufficient source evidence. A third party may propose a line, but keep it `Needs Clarification` until Wes or Josh confirms it.
2. Require the work date, task description, exact duration or supported start/end times, and the project/property or `BackOffice` destination. Record the source reference and received timestamp when available.
3. If start and end times are supplied, calculate exact elapsed time. Subtract breaks only when the source states them. If only duration is supplied, preserve it as exact hours and minutes.
4. Do not infer time from Tasks status, calendars, email activity, message timestamps, or the time between task creation and completion.
5. Assign the canonical id `MTC-YYYYMMDD-NNN`, using the work date for `YYYYMMDD` and the next unused three-digit suffix across the full Time Card register. Display it as `TC-NNN`; never reset or reuse the suffix.
6. Use statuses `Recorded`, `Needs Clarification`, `Ready for Invoice Entry`, `Handed Off`, `Accepted by Invoice Entry`, `Drafted`, `Finalized`, `Held`, `Superseded`, and `Cancelled`.
7. Group entries into semimonthly periods: the 1st through the 15th and the 16th through the last calendar day. Display exact hours and minutes for each line and period total.
8. Preserve corrections. Add the corrected line as a new record, mark the prior line `Superseded`, and cross-reference both ids. Do not delete historical time lines.

#### Display Time

- Show display id, work date, exact time, task, project/property or `BackOffice`, and status.
- Group by semimonthly period unless the requester asks for another view.
- Exclude `Superseded` and `Cancelled` lines from active totals, but retain them in history and show them when requested.
- Do not show invoice amounts unless Invoice Entry has returned a source-backed draft or final result for that period.

#### Hand Off To Invoice Entry

1. Manager owns time intake, the source ledger, clarification, display, period totals, and the structured handoff packet. It does not create or finalize an invoice, determine rates or amounts, approve payment, file documents, or edit project spreadsheets.
2. Invoice Entry owns semimonthly accumulation, rate and amount handling, destination allocation, draft/final invoice generation, correction review, Wes approval, filing, and project-spreadsheet insertion under its own skill.
3. Send a handoff only when Wes requests draft/final processing or otherwise authorizes Invoice Entry processing. Use the registered Invoice Entry task `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f` and the packet fields in `working\time-card-invoice-entry-handoff-contract.md`.
4. Assign and preserve a dispatch id in the form `manager-dispatch-YYYYMMDD-time-card-vN`. Include the worker, semimonthly period, packet version, canonical entry ids, work dates, exact durations, task descriptions, destinations, source references, corrections, unresolved items, requested Invoice Entry operation, and authorizing Wes instruction.
5. Deduplicate by dispatch id, packet version, and canonical entry id. Do not resend an unchanged packet after an ambiguous or missing result.
6. Keep entries `Handed Off` until Invoice Entry returns `accepted` with the same dispatch id. Apply `Accepted by Invoice Entry`, `Drafted`, `Finalized`, or `Held` only from that task's explicit return; preserve its artifact paths and notes in the handoff log.
7. Invoice Entry's current Time Card trigger accepts only Email Monitor email handoffs. Until Invoice Entry explicitly accepts and documents Manager-source packets, keep the packet held, report the receiver-side blocker, and do not claim a draft or final invoice exists.
8. An Invoice Entry handoff does not authorize payment, invoice approval, filing, spreadsheet insertion, or external email beyond what Invoice Entry's own rules and Wes's approvals permit.

## Start PR

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

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
- If Manager work requires sending email, Manager prepares the final delivery package and hands it to the existing Email Monitor status task `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582` requesting Email Delivery mode. Email Monitor's Email Delivery mode uses `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md` for sender safety, attachment handling, Sent Items verification, local Outlook fallback rules, and failure reporting.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Outputs

Use `C:\Codex\Wiki Files\Project Rooms\Manager\outputs` for review-ready drafts, summaries, checklists, handoff notes, and final deliverables.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
