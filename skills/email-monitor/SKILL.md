---
name: email-monitor
description: Create Wes's, Jenny's, and Josh's daily OfficeAssist mailbox summaries, run Email Routing and Wes mailbox organization, execute authorized Email Delivery handoffs, and maintain the Email Monitor Health Check watchdog pattern. Use for mailbox summaries, routed-email intake, direct delivery requests, Jean Wright folder organization, health-state diagnostics, or workflow-specific watchdog configuration.
---

# Email Monitor

## Overview

Create daily summaries for Boss at `WesWill@BuyYourHomeLLC.com`, Jenny at `Jenny@BuyYourHomeLLC.com`, and Josh at `IRAManager@SellYourHomeRaleigh.com`, then hand off delivery to the shared `email-delivery` skill. Josh's summary also includes the current Manager Task mode list. Email Monitor also receives complete, authorized outbound-email delivery packages directly from other Project Rooms, executes them immediately through Email Delivery, and organizes Jean's messages in Wes's mailbox after verified deliveries to Wes.

For summaries and routing, this skill owns mailbox scanning, cutoff selection, message prioritization, summary drafting, Wes's usage-summary inclusion, and summary-run state updates. For direct delivery handoffs, the requesting Project Room owns the message purpose, authorization, recipients, subject, body, attachments, and workflow-specific restrictions. Email Monitor owns package validation, duplicate prevention, delivery coordination through `email-delivery`, durable delivery-request state, callback reporting, and escalation. The shared `email-delivery` skill owns sender safety, connector handling, Sent Items verification, and delivery failure mechanics.

Development notes, source inventory, and open questions for this workflow live in `C:\Codex\Wiki Files\Project Rooms\Email Monitor\`.

## Inputs

Before using this skill, have:

- the global profile at `C:\Codex\Wiki Files\Office Assistant Profile.md`,
- the admin rules in `C:\Codex\Wiki Files\AGENTS.md`,
- the automation memory file for this workflow at `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`,
- the compact-state specification at `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\memory-state-spec.md`,
- the seven-day rolling-log config at `C:\Codex\Wiki Files\Project Rooms\Email Monitor\config\email-monitor-log.json`,
- access to `WesWill@BuyYourHomeLLC.com` mailbox contents,
- access to `Jenny@BuyYourHomeLLC.com` mailbox contents when running Jenny's summary,
- access to `IRAManager@SellYourHomeRaleigh.com` mailbox contents when running Josh's summary,
- direct task messaging access to Manager task `019f8274-5b7e-7170-a051-f7944954de82`,
- the routing action log at `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\routing-action-log.md` when routing or delivery outcomes need durable tracking,
- access to `C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1` when Wes's usage totals are needed.

The automation path above is the only Email Monitor runtime memory file. Do not create or update `Project Rooms\Email Monitor\working\memory.md`.

## Workflow

1. Read `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` and find the last verified Boss, Jenny, and Josh summary send times.
2. Use that verified send time as the cutoff unless a newer verified Boss summary is already present in `OfficeAssist@BuyYourHomeLLC.com` Sent Items for the same day.
3. Use the last verified Jenny summary send time as Jenny's cutoff unless a newer Jenny summary is already recorded in the memory file for the same day. If there is no prior Jenny summary record, use the 2026-06-29 resume timestamp as the initial new-mail cutoff.
4. Use the last verified Josh summary send time as Josh's cutoff. The verified manual Josh summary sent at `2026-07-21T12:24:17Z` is the initial cutoff.
5. Scan only the intended mailbox for the current summary: `WesWill@BuyYourHomeLLC.com` for Boss, `Jenny@BuyYourHomeLLC.com` for Jenny, or `IRAManager@SellYourHomeRaleigh.com` for Josh.
6. Review the entire mailbox recursively, including Inbox and rule-routed subfolders.
7. Focus on:
   - unread messages, and
   - newly received messages after the cutoff.
8. Keep only messages that are financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented.
9. Exclude routine promotional, automated, and newsletter traffic unless it is time-sensitive, financial, legal, property-related, or requires action.
10. Keep older unread items in scope when they are still priority business items. Do not treat a historic unread backlog as new.
11. For Josh, request the current formatted `Manager Tasks` section from the Manager task and use its response without reading or changing the Manager register from Email Monitor.

## Modes

Formal modes are `Email Summary`, `Health Check`, `Task Health`, `Email Routing`, `Route Vendor Invoice`, `Organize`, and `Email Delivery`. Email Routing may invoke a specialized routing mode, but the invoked mode keeps its own acceptance, state, retry, and escalation rules.

### Email Summary

Use Email Summary for the once-daily Boss, Jenny, and Josh Outlook mailbox summaries.

This mode owns mailbox scanning, cutoff selection, priority selection, summary drafting, Wes's usage-summary inclusion, attachment decision, and summary-run state updates for:

- Boss summary mailbox: `WesWill@BuyYourHomeLLC.com`;
- Boss summary recipient: `WesWill@BuyYourHomeLLC.com`;
- Jenny summary mailbox: `Jenny@BuyYourHomeLLC.com`;
- Jenny summary recipient: `Jenny@BuyYourHomeLLC.com`;
- Josh summary mailbox: `IRAManager@SellYourHomeRaleigh.com`;
- Josh summary recipient: `IRAManager@SellYourHomeRaleigh.com`;
- Manager task source for Josh: direct request to Manager task `019f8274-5b7e-7170-a051-f7944954de82`;
- sender for all summaries: `OfficeAssist@BuyYourHomeLLC.com`.

Activation:

- run once per calendar day at the 8:00 AM Eastern heartbeat run, or the first run after 8:00 AM Eastern if the 8:00 AM run was missed;
- skip a same-day summary when that recipient's summary has already been sent and verified for the calendar day;
- later same-day heartbeat runs use Email Routing only unless a summary send or verification failure still needs attention.

Cutoff and mailbox scan:

- read `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`;
- use the last verified Boss summary send time as the Boss cutoff unless a newer verified Boss summary is already present in `OfficeAssist@BuyYourHomeLLC.com` Sent Items for the same day;
- use the last verified Jenny summary send time as Jenny's cutoff unless a newer Jenny summary is already recorded in memory for the same day;
- if no prior Jenny summary record exists, use the 2026-06-29 resume timestamp as Jenny's initial new-mail cutoff;
- use the last verified Josh summary send time as Josh's cutoff, with `2026-07-21T12:24:17Z` as the initial verified cutoff;
- scan only the intended mailbox for the current summary;
- review the entire mailbox recursively, including Inbox and rule-routed subfolders;
- focus on unread messages and newly received messages after the cutoff;
- include older unread messages only when they are still priority business items, and do not treat Jenny's historic unread backlog as new.

Priority selection:

- keep financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented messages;
- prefer same-day deadlines, fraud or banking actions, invoices, insurance issues, title or closing items, property operations, direct human follow-ups, and vendor/admin items with due dates, money movement, or approvals needed;
- exclude routine promotional, automated, and newsletter traffic unless it is time-sensitive, financial, legal, property-related, or requires action.

Summary body:

- include the mailbox scanned, cutoff used, priority items, low-priority exclusions when applicable, and a clear note if no priority messages were found;
- include the Codex usage section only in Wes's summary, using `C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1` when reliable totals are available;
- do not include Codex usage or token information in Jenny's or Josh's summary;
- for Josh, send Manager task `019f8274-5b7e-7170-a051-f7944954de82` a direct request for the current formatted `Manager Tasks` section, then wait for and use Manager's response;
- ask Manager to group tasks as `New`, `Delivered`, `Acknowledged`, `In Progress`, `Waiting`, `Completed`, and `Cancelled`, ordering each group `Critical`, `High`, `Normal`, then `Low`, and showing task id, priority, task, and due date when present;
- state when Manager reports no tasks; if Manager cannot respond, state that the section is unavailable, report the blocker to Wes, and do not read the register as a fallback;
- keep mailbox-derived action items in the mailbox-summary section unless they already correspond to a registered Manager task;
- use Manager's returned task labels exactly and do not infer a status change, create a task, or edit or read the Manager task register from Email Monitor;
- sign as `Jean Wright` / `Office Assistant`;
- do not say the email is on Wes's behalf unless the actual sending identity requires that wording.

Subject stability:

- treat each Monday-through-Sunday period in Eastern Time as one summary week;
- calculate the `Week of` date as the Monday that begins the current Eastern Time summary week;
- use these exact subject formats, substituting that Monday in `MM-DD-YY` format:
  - `Wes Email Summary Week of MM-DD-YY`;
  - `Jenny Email Summary Week of MM-DD-YY`;
  - `Josh Email Summary Week of MM-DD-YY`;
- use the resulting subject for every summary and retry to that recipient during the same week;
- do not change the subject midweek because of the summary date, mailbox contents, priority items, Manager tasks, missed runs, or a send retry;
- record each recipient's calculated weekly subject and Monday week-start date in monitor memory before delivery.

Delivery handoff:

- hand the send step to `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`;
- pass sender, recipient, subject, plain-text body, attachment paths if any, and the rule that send or verification failure must be reported in the OfficeAssist thread;
- let `email-delivery` handle Outlook connector preference, sender safety, attachment input format, Sent Items verification, local Outlook fallback, and failure reporting;
- if the summary cannot be sent or verified, notify Wes immediately in the OfficeAssist thread and use the available text/SMS fallback when one is available.

State update:

- after a successful verified send, rewrite compact automation memory with the summary date, weekly subject and Monday-through-Sunday week identifier, cutoff used, verified send timestamp, and any unresolved blocker;
- if mailbox access, Wes token-summary generation, Manager response, send, or verification fails, keep only the current unresolved blocker in compact memory;
- record meaningful delivery, failure, or recovery history through `Update-EmailMonitorRollingLog.ps1` rather than appending a heartbeat narrative to memory;
- do not treat a failed summary run as quiet.

### Health Check

Use Health Check to maintain the shared independent Windows workflow-health supervisor. Follow `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\health-check-spec.md`, the registry at `config\workflow-health-registry.json`, and the workflow-specific JSON configurations.

At Email Monitor heartbeat start, call the health updater with `Started` and the intended mode. Before returning, call it with `Completed`; on failure call it with `Failed`, a stage, and a concise message. Preserve the existing Email Monitor health file and its 7:45 AM through 11:00 PM active window, 35-minute warning, and 60-minute critical threshold.

The scheduled supervisor runs every 10 minutes independently on each assigned machine. `workflow-health-registry.json` keeps Invoice Entry enabled on `WESSTUDIO` and Email Monitor disabled there. `officeassist-workflow-health-registry.json` enables Email Monitor on `OFFICEASSIST`, where its lifecycle configuration and automation runtime live. Each supervisor evaluates only its machine's enabled entries, uses a machine-specific mutex, isolates malformed configurations, refuses the wrong machine, and does not depend on Outlook or another connector it supervises.

The separate Invoice Entry packet-backup automation remains a detached cron job, so each scheduled run receives its own execution task. A clean completed run must obtain its actual current execution task id from runtime metadata, suppress routine inbox and final output, and archive only that execution task with `set_thread_archived({ threadId: currentExecutionThreadId, archived: true })`. The id is required: never omit it, guess it from a title or timestamp, or substitute the active Invoice Entry operational task id. If the runtime does not expose an unambiguous current execution id, leave the execution visible and report the archival limitation.

After an otherwise clean packet scan, the backup cron may reconcile no more than the five most recent unarchived predecessor executions from the prior 14 days. A predecessor qualifies only when its task history explicitly records the exact automation id `invoice-entry-to-projects-backup-heartbeat`; a matching title or timestamp is insufficient. Exclude the current execution and active Invoice Entry operational task. Archive only a verified completed clean run, or an interrupted clean run conclusively superseded by a later successful run with no unique packet, unresolved blocker, decision, meaningful failure, or uncertain side effect. Leave every uncertain or attention-bearing task visible. Record reviewed ids, classifications, and outcomes compactly in automation memory. If authoritative task-history or archive tools are unavailable, do not guess; record and report the limitation on its first occurrence or material change and suppress repeated visible reports for the same unchanged limitation.

Alerts are transition-based and deduplicated: one warning when entering warning, one critical alert when entering critical, and one recovery after returning healthy. Unchanged warning or critical states and routine healthy checks write diagnostics but do not create visible notifications or operational-task messages.

Keep detailed processing history in durable Project Room files or approved Teams logs. Use concise reference-based handoffs. Keep each enrolled PR's `working\work-status.md` current after meaningful changes. Task growth beyond 150 observable turns or five observable compactions triggers review only. The supervisor may recommend rollover only when multiple measured signals support it; it must never create or archive a task. Wes must separately approve a controlled rollover, which keeps one active operational task and verifies the replacement before archiving the predecessor.

Keep the existing Email Monitor task. Routine checks remain silent. Create a visible task update only for initial failure, critical escalation, recovery, significant routing action, verified delivery, unresolved delivery, or a decision needed from Wes. Write those same meaningful events to the single seven-day Teams rolling log. Do not log routine no-activity checks.

When Wes addresses Health Check in plain language, use `C:\Codex\Wiki Files\Project Rooms\Email Monitor\tools\Manage-CodexWorkflowHealth.ps1` as the control surface. Map the request to exactly one of `Options`, `Status`, `Enable`, `Disable`, `Configure`, `Test`, or `TestAlert`, execute it, and report the resulting effective settings. When Wes asks what the mode can do, asks for available commands, or says “Health Check, what are my options?”, run `Options`; do not rely on memory to enumerate the choices.

For `Configure`, pass only values Wes requested. Ask a clarifying question when “interval” or “run every” could mean either the Email Monitor heartbeat schedule or the watchdog polling interval. Configuration changes require healthy state by default. Use `AllowUnhealthy` only when Wes explicitly authorizes changing Health Check while unhealthy. Disabling the watchdog stops independent alerts but does not stop heartbeat health-state writes. Treat machine reassignment as a guided migration: verify the destination machine and its scheduled task before disabling the current machine or changing the canonical assignment.

`Status` and `Test` may target one workflow or all workflows. `Configure` must target one workflow and distinguish heartbeat interval, supervisor polling, and substantive evaluation interval. Disabling one workflow leaves the shared supervisor active for other enabled workflows. Machine reassignment remains guided and requires destination verification before the current supervisor is disabled.

### Task Health

Use Task Health for Email Monitor task-context review and Wes-approved controlled rollover. This is distinct from Health Check: Health Check evaluates workflow and heartbeat liveness; Task Health evaluates the size, durability, and reliability of the operational Codex task. A Windows alert file alone does not invoke Codex. Activate this mode only from a Wes request, an authorized context-health alert handoff, or observable performance degradation.

#### Health Review Stage

- Read `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\work-status.md`, current delivery state, unresolved delivery requests, routing records, heartbeat state, and Git status.
- Inspect task turns, context compactions, stalled responses, timeouts, and duplicate external-action attempts when those metrics are observable. Record unavailable metrics as unavailable and never invent them.
- Confirm whether an operation or delivery is in flight, current work is durable, delivery evidence is recorded, open routing/delivery blockers are current, and Git/working files are classified.
- Keep detailed history in durable files or the approved rolling Teams log. Do not reproduce full email bodies, delivery packages, standing rules, or task history in the operational task.
- Present the measured signals, readiness findings, and recommendation to Wes. Do not create or archive a task during review.

#### Approved Rollover Stage

- Proceed only after Wes explicitly approves Email Monitor rollover and the exact dependency changes required.
- Preserve the same Project Room and skill and maintain exactly one active Email Monitor operational task.
- Create one replacement from a concise durable handoff and verify that it can read the skill, Project Room state, unresolved delivery requests, duplicate-prevention records, heartbeat contract, and authorization boundaries.
- Inventory every Email Monitor task-ID reference, direct-delivery destination, callback dependency, registry entry, and heartbeat target. Update the existing heartbeat target and specifically authorized routing references; do not create duplicate automations or delivery endpoints.
- Do not archive the predecessor while any send or delivery verification is ambiguous or in flight. Archive only after replacement verification, dependency retargeting, and durable recording of predecessor/replacement task IDs.
- Reset task-health review counters for the replacement. Do not create another Project Room, skill, or Git branch.

### Email Routing

Use Email Routing as the OfficeAssist mailbox intake funnel during the configured active window.

For each new message:

- check `OfficeAssist@BuyYourHomeLLC.com` Inbox, Task Instructions, and Accts Payable;
- use monitor memory so the same Outlook message id is not processed repeatedly;
- recognize instructions from Wes at `WesWill@BuyYourHomeLLC.com` or `Wes@myBrowning.net`, Jenny at `Jenny@BuyYourHomeLLC.com`, and Josh Kennedy at `IRAManager@SellYourHomeRaleigh.com`;
- treat both Wes addresses as the same authorized instruction identity, subject to the same workflow-specific safety gates; when a reply is required, address it to the Wes address that originated the instruction and copy `WesWill@BuyYourHomeLLC.com` unless Wes directs otherwise;
- perform a safe, in-scope admin action or start the applicable workflow when current Admin wiki rules authorize it;
- hold and report a decision needed when authorization, routing, or high-impact action authority is incomplete;
- apply the specialized routing branch when the message matches Lowes Order, Gracious Millionaire, Web Site, Brynda Suit, Manager Routing, or Route Vendor Invoice rules;
- return quietly when no new actionable or routable message is found.

Email Routing is not the trigger for the scheduled Email Summary mode or a direct Project Room Email Delivery handoff.

#### Routed Source Retention

Do not routinely save routed email bodies or attachments into Git-tracked Project Room folders. Treat the Outlook message as the authoritative source and preserve the Outlook message id or web link in monitor memory, the Email Monitor routing log when an audit entry is needed, and the handoff to the owning Project Room.

If a routed email or attachment must be materialized as a file, save it outside the Admin wiki Git repo in the owning Project Room's Teams source/reference, working, or archive location according to that room's current rules. Keep only the path, message id, short summary, and outcome log in Git. If the owning Project Room has no external retention rule yet, ask or hand off the decision to that Project Room instead of creating a new Git `sources\email` folder.

#### General Instruction Handling

Use General Instruction Handling for an authorized Wes, Jenny, or Josh instruction that does not match a specialized routing branch. Determine the applicable Admin wiki rule or workflow, complete safe authorized work, or route it to the owning workflow. Josh's authorization permits safe instruction intake and workflow routing; it does not authorize purchases, payments, approvals, legal or financial changes, or another high-impact action that remains reserved to Wes or separately gated by the owning workflow. Do not invent authority or bypass a specialized Project Room's ownership boundary.

#### Lowes Order Email Routing

Use Lowes Order Email Routing when an authorized instruction email clearly requests Lowe's product research, cart preparation, cart changes, or order review.

Activation:

- the subject contains `Lowes Order`, `Lowe's Order`, or a normal reply or forward of that subject; or
- the subject or body otherwise clearly requests adding Lowe's item numbers or products to a Lowe's cart.

For each routed email:

- preserve the Outlook message id or web link, sender, recipients, sent time when available, received time, subject, body summary, item numbers, quantities when stated, project/property clues, pickup or delivery instructions, and attachment metadata in the handoff and monitor memory;
- record missing quantities, project/property context, pickup or delivery method, timing, budget, or product ambiguity in the handoff without guessing;
- record the routed Outlook message id in monitor memory so the message is not routed repeatedly;
- send a direct follow-up message to the existing Lowes Order task with the Outlook reference, sender, extracted order details, missing details, and the instruction to process the request under Lowes Order Cart Fill Workflow;
- mark the source email read only after the durable handoff is accepted.

Current Lowes Order task id: `019f5845-fb96-7370-baf2-b8f00fddffae`.

The Lowes Order task owns Lowe's website work and the required follow-up emails. When the cart is filled to the extent safely supported by the source, it sends the sender a confirmation and sends Wes a separate approval notification. If uncertainties prevent or limit cart preparation, it sends the questions to both the sender and Wes. These messages must use an `[Lowes Order]` subject prefix and state that future source emails should identify `Lowes Order` mode in the subject. Email Monitor does not check out, place the order, spend money, choose paid services, or approve substitutions.

#### Gracious Millionaire Email Routing

Use Gracious Millionaire Email Routing when Email Routing sees an email that belongs to Gracious Millionaire.

This mode owns source routing and direct project-room handoff only. It does not own Gracious Millionaire manuscript processing, book-response drafting, external email sending, or mailbox monitoring from the Gracious Millionaire project-room heartbeat.

Activation:

- the email subject contains `gracious millionaire`; or
- the email otherwise clearly belongs to the Gracious Millionaire book/project-room workflow.

For each routed email:

- preserve the Outlook message id or web link, sender, recipients, sent time when available, received time, subject, and a short summary in the handoff and monitor memory;
- if Gracious Millionaire rules require a materialized source file, save it outside Git in the room's Teams source/reference location and record that external path;
- update `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\officeassist-intake-log.md` when the current Gracious Millionaire project-room rules require the intake ledger;
- update `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\source-inventory.md` only with the Outlook reference, Teams path if any, summary, and status when the routed source becomes part of the durable source inventory;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing Gracious Millionaire project-room thread with the Outlook reference, Teams path if any, and a short summary of the email.

Direct message handoff is the primary trigger for Gracious Millionaire project-room processing. The `gracious-millionaire-project-room-heartbeat` remains only a backup processor for external source references or files that have already been routed to the project room.

Current Gracious Millionaire project-room thread id: `019eb9b0-6780-7fb3-a278-29a18d17998c`.

Do not attach mailbox checking to the Gracious Millionaire heartbeat. Do not create a new Gracious Millionaire chat. Do not draft, edit, or send the requested book response from this Email Monitor task unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

#### Web Site Email Routing

Use Web Site Email Routing when Email Routing sees an instruction email from Wes or Jenny that belongs to REI BlackBook website work.

This mode owns source routing and direct REI BlackBook project-room handoff only. It does not own live REI BlackBook website editing, browser automation, public-site publishing, external email sending, or creating a new REI BlackBook chat.

Activation:

- the email subject contains `GM Site`; or
- the email otherwise clearly belongs to REI BlackBook WebTools Sites or Gracious Millionaire website workflow.

For each routed email:

- preserve the Outlook message id or web link, sender, recipients, sent time when available, received time, subject, and a short summary in the handoff and monitor memory;
- if REI BlackBook rules require a materialized source file, save it outside Git in the room's Teams source/reference location and record that external path;
- update `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\working\source-inventory.md` only with the Outlook reference, Teams path if any, summary, and status when the routed email becomes part of the durable source set;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing REI Blackbook project-room thread with the Outlook reference, Teams path if any, a short summary of the email, and the instruction to process the website request.

Current REI Blackbook project-room thread id: `019f4691-5466-7f72-9683-ab5d3b750c25`.

Do not create a new REI Blackbook chat for this routing unless Wes explicitly asks. Do not process the REI BlackBook website request from this Email Monitor task unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

#### Brynda Suit Email Routing

Use Brynda Suit Email Routing when Email Routing sees an instruction email from Wes or Jenny that belongs to Brynda Suit.

This mode owns source routing and direct Brynda Suit task handoff only. It does not own Brynda Suit response drafting, external email sending, or creating a new Brynda Suit task.

Activation:

- the email subject contains `brynda suit`; or
- the email otherwise clearly belongs to the Brynda Suit workflow.

For each routed email:

- preserve the Outlook message id or web link, sender, recipients, sent time when available, received time, subject, and a short summary in the handoff and monitor memory;
- if Brynda Suit rules require a materialized source file, save it outside Git in the room's Teams source/reference location and record that external path;
- update `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\working\source-inventory.md` only with the Outlook reference, Teams path if any, summary, and status when the routed email becomes part of the durable source set;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing Brynda Suit task with the Outlook reference, Teams path if any, a short summary of the email, and the instruction to wake up and respond to the email.

Current Brynda Suit task id: `019f61c3-d4c0-7a52-a5a0-e4066ea9b303`.

Do not create a new Brynda Suit task for this routing unless Wes explicitly asks. Do not process the Brynda Suit response from this Email Monitor task unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

#### Manager Routing

Use Manager Routing when Email Routing sees an email whose subject contains `Manager Task`, matched case-insensitively. This includes the established `[Manager Task][<Priority>][<Task ID>] <short title>` format and normal reply or forward prefixes.

Preserve the Outlook message id or web link, sender, summary, and attachment metadata in Email Monitor memory and the Manager handoff. Save safely retrievable attachments outside Git in Manager's Teams source/reference or working location according to Manager rules; otherwise preserve the Outlook link and report the blocker. Update the Manager source inventory when applicable with references and external paths only, and send Manager task `019f8274-5b7e-7170-a051-f7944954de82` a direct handoff with the Outlook reference, external attachment paths or blocker, sender, summary, and instruction to process it under Manager Tasks mode.

Manager must determine whether the email is a new task request, delivery-related message, or status update and apply its existing sender, task-id, status, authorization, and task-register rules. Email Monitor must not infer a status change, create or edit a Manager task, or perform the requested business action from this routing branch.

### Route Vendor Invoice

Use Route Vendor Invoice when Email Routing sees a contractor or vendor email that appears to contain or request processing of an invoice, bill, receipt, payment request, statement, pay application, draw request, or project-cost document.

This is a formal Email Monitor mode, not an informal Email Routing label. It owns source routing, durable dispatch creation, Invoice Entry notification, acceptance verification, bounded retry, and missing-acknowledgment escalation. It does not own invoice approval, payment, vendor contact, final accounting judgment, live project-spreadsheet entry, Teams filing, or creating a new Invoice Entry chat.

Activation:

- the sender display name is `Josh Kennedy` and the subject is exactly `Time Card`, matched case-insensitively;
- the email is from a contractor, subcontractor, vendor, supplier, utility, service provider, or property/project cost sender and the subject, body, attachment name, or message context contains `invoice`, `bill`, `receipt`, `statement`, `pay app`, `payment request`, `draw`, or another clear invoice-entry signal;
- the email is from Wes or Jenny and forwards, attaches, or explicitly routes a contractor/vendor invoice or project-cost email for processing;
- the email otherwise clearly belongs to the Invoice Entry workflow.

For each routed email:

- preserve the exact mailbox identity, Outlook message id and web link when available, attachment names/metadata, sender/recipient metadata, subject, timestamps, and routing evidence in Email Monitor compact state or `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\routing-action-log.md` when needed for duplicate prevention, audit, debugging, or follow-up;
- when the connector or local mailbox path can safely retrieve attachments, save invoice attachments outside Git in the Invoice Entry Teams source/working archive location required by Invoice Entry's current rules and reference those external paths;
- if an apparent invoice attachment cannot be retrieved, preserve the Outlook link and exact attachment-access blocker;
- update `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\source-inventory.md` or the current Invoice Entry intake ledger only with the Outlook reference, external path if any, summary, and status when the routed email becomes part of the durable source set;
- record the routed Outlook message id in Email Monitor compact state so the same source is not routed repeatedly;
- create the durable message before any task-message call by using `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1 -Action Send`; use the shared runtime queue and state contract in `working\dispatch-queue-spec.md`; never create a new record in the legacy Email Monitor queue;
- use one stable dispatch ID and immutable payload; idempotent creation with the same payload is safe, but the same ID with different content is a blocker;
- store the source and concise handoff fields in the queue record, then send the existing Invoice Entry task one wake-up message containing the dispatch ID, queue-record path, and these fields in this exact order:
  - `mailbox`: exact mailbox identity;
  - `outlook_message_id`: exact Outlook message id;
  - `outlook_link`: direct Outlook link when available, otherwise `unavailable`;
  - `attachments`: absolute saved paths, `none`, or `blocked: <exact blocker>`;
  - `summary`: short factual source summary;
  - `requested_operation`: the specific operation requested by the source;
  - `unique_warning`: only a warning specific to this source, such as a duplicate, amount conflict, missing quantity, ambiguous project, or authority limit; otherwise `none`.

Dispatch lifecycle:

1. Treat the durable queue record as the authoritative handoff and task messaging as a best-effort wake-up signal.
2. Establish that Invoice Entry is idle before `StartAttempt`. If status is unavailable or busy, leave the record `Queued`; do not start a blocking task-message call.
3. Mark `StartAttempt`, send the wake-up message, and request `accepted: <dispatch_id>` before substantive work.
4. Verify acceptance independently in both the durable queue record and Invoice Entry history. Tool completion alone is not proof.
5. If the call times out or ends without proof, mark `Delivery Ambiguous`. Reconcile before retrying.
6. Retry only when Invoice Entry is idle, the exact dispatch ID is absent from its history, the durable record is not accepted, and fewer than three attempts have occurred. Reuse the same dispatch ID and payload.
7. If no accepted receipt exists before the routing run ends, send Wes one OfficeAssist email with subject `[Email Monitor] Invoice Entry dispatch not acknowledged - <short source>` and verify it in OfficeAssist Sent Items. Record the verified message ID with `MarkAlertSent`. This first alert is required even when Health Check is already warning or critical; later unchanged checks do not resend it.
8. Continue queue reconciliation on later Email Monitor runs. On acceptance, record recovery in the routing log and compact state. Do not repeat the failure email unless the incident materially changes or Wes directs another notice.
9. Mark the source email read only after the durable dispatch is `Accepted`.

Do not reproduce Invoice Entry's standing rules, the full email body, quoted thread text, or prior processing history in the task handoff. Keep detailed routing evidence in Email Monitor's own state and logs. Use the same concise field format for Time Card, approval, correction, and paid-receipt routing.

On each heartbeat, reconcile every unresolved `Route Vendor Invoice` queue record before treating the run as a quiet no-mail check. A queued or ambiguous record is meaningful unresolved work, not `DONT_NOTIFY`; suppress only duplicate visible/chat and email alerts after the first verified alert.

Current Invoice Entry task id: `019fbf4f-c629-7dd1-a3f6-0de33de0ed8f`.

Do not create a new Invoice Entry task for this routing unless Wes explicitly asks. During intake routing, do not approve, pay, reply to the contractor/vendor, make live spreadsheet entries, or move files into Teams from this Email Monitor task unless Wes explicitly asks for processing here and the Invoice Entry rules allow it. This intake-stage prohibition on contractor/vendor contact does not block a later Email Delivery request when Invoice Entry's saved rules and the delivery package explicitly authorize that specific message. The default intake action remains source routing plus direct Invoice Entry handoff only.

### Organize

Use Organize to file messages that Wes's Outlook rule has already moved into `Inbox/Jean Wright` in `WesWill@BuyYourHomeLLC.com`.

Activation:

- run after every successful, Sent Items-verified Email Delivery when `WesWill@BuyYourHomeLLC.com` appears in To or CC;
- do not run merely because a send was attempted or remains unverified;
- process all messages sitting directly in `Inbox/Jean Wright` so the mode is idempotent and also clears any prior backlog;
- do not organize Jenny's mailbox unless Wes separately activates and proves that scope.

Folder set:

- `Brynda Law Suit`
- `Daily Summaries`
- `Invoice Entry`
- `Manager Tasks`
- `Project Rooms`
- `Drafts for Review`
- `Approvals Needed`
- `Sent Confirmations`
- `Health and Failures`
- `Other`

Create any missing folder beneath `Inbox/Jean Wright`. Leave existing folders, including `Fraud`, `Invoices`, and `Time Cards`, intact.

Classification precedence:

1. `Health and Failures`: failures, failed checks, health alerts, fraud alerts, or rollback instructions.
2. `Brynda Law Suit`: subjects identifying Brynda Suit or the associated mediation, possession, counterclaim, witness, settlement-position, or settlement-proposal work.
3. `Drafts for Review`: subjects identifying a draft, revised draft, or draft attachment.
4. `Approvals Needed`: subjects requesting approval, asking Wes to approve, or stating that Wes approval is needed.
5. `Daily Summaries`: Wes, Boss, Morning, OfficeAssist, Jenny, or Josh email/mailbox summaries.
6. `Manager Tasks`: subjects containing `Manager Task`, matched case-insensitively.
7. `Sent Confirmations`: approved-status notices, sent-and-verified notices, delivery verification, completed/run-complete notices, sender tests, or display-name verification.
8. `Invoice Entry`: invoices, Time Cards, cost-allocation reports, hours or vendor verification, and related payment-report messages not already classified as approval or confirmation.
9. `Project Rooms`: Gracious Millionaire, GM Site, manuscript, Codex/dispatcher/computer setup, document-scan, closing-document, MOU, insurance-report, or other identifiable Project Room work.
10. `Other`: anything that does not match a class above.

Execution rules:

- prefer the Outlook Email connector for delegated Wes mailbox folder discovery, message listing, and moves;
- use the mounted local Outlook profile only when the connector cannot create the required delegated-mailbox folders or cannot complete the move safely;
- never hardcode folder IDs; resolve the exact mailbox path each run;
- move only messages directly inside `Inbox/Jean Wright`; do not reclassify messages already in a child folder;
- preserve read/unread state, flags, categories, attachments, conversation state, and message content;
- if Outlook rule processing has not yet placed the newly sent message in `Jean Wright`, retry the folder check briefly, then leave it for the next Organize run rather than moving a message from another folder;
- record and report a folder-access, creation, or move failure; routine successful organization does not require a user notification.

### Email Delivery

Use Email Delivery when this project room has an authorized email ready to send, another Email Monitor mode reaches its send step, or another authorized Project Room sends Email Monitor a complete direct delivery handoff. Invoice Entry is an authorized requesting Project Room when its package is supported by Invoice Entry's saved rules and includes a specific authorization basis.

A direct delivery handoff is an immediate trigger. Process it without scanning a mailbox, finding an instruction email, waiting for the Email Monitor heartbeat, or rerunning the originating workflow.

#### Ownership Boundary

The requesting Project Room owns:

- message purpose and authorization;
- sender requested, To, CC, and BCC recipients;
- subject and exact plain-text body;
- attachment selection and whether each attachment is required;
- workflow-specific restrictions.

Email Monitor owns:

- validating the delivery package and request ID;
- checking durable delivery records before sending;
- invoking `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`;
- recording the delivery result;
- immediately returning the result to the callback task/thread;
- reporting unresolved failures to Wes.

Email Delivery owns OfficeAssist sender safety, shared/delegated Outlook connector use, attachment-path validation and connector parameter-shape handling, Sent Items verification, the documented retry, and failure reporting. Email Monitor must not reinterpret or alter caller-owned fields.

#### Required Delivery Package

Require every direct delivery handoff to contain all of these fields:

- `delivery_request_id`: stable, unique request ID;
- `originating_project_room`: requesting Project Room name;
- `originating_task_thread_id`: task/thread that owns the request;
- `authorization_basis`: the exact saved rule or specific Wes authorization allowing this delivery;
- `sender_mailbox`;
- `to_recipients`;
- `cc_recipients`, explicitly `none` or an empty list when unused;
- `bcc_recipients`, explicitly `none` or an empty list when unused;
- `subject`;
- `plain_text_body`;
- `absolute_attachment_paths`, explicitly an empty list when there are no attachments;
- `attachment_required_status`, identifying whether attachments are required and which paths are mandatory;
- `workflow_specific_restrictions`;
- `callback_task_thread_id` for the result.

Reject or hold an incomplete or internally conflicting package. Return the missing or conflicting fields to the callback task/thread and record the request as unresolved. Do not invent, infer, remove, add, or change recipients, content, attachments, authorization, or workflow restrictions.

#### Duplicate Prevention And Durable State

Before any send attempt, search compact Email Monitor state, the seven-day rolling log, and the durable routing action log for `delivery_request_id`.

- If that request is already `Sent and Verified`, do not send it again; return the existing verified result to the callback task/thread.
- If it is `Sending`, `Held`, `Failed - Unresolved`, or otherwise unresolved, do not create a second send attempt until the existing record is reconciled under the shared Email Delivery retry rules.
- If it is new and complete, create a durable request record before invoking the connector, then update that same record with the final result.

Keep unresolved delivery requests and requests completed within the last seven days in compact state. Record meaningful outcomes in the seven-day Teams rolling log and use `working\routing-action-log.md` for durable audit entries when needed. Do not append full completed delivery narratives indefinitely to `memory.md`.

#### Invoice Entry Requests

A properly authorized Invoice Entry delivery handoff may request:

- vendor invoice-accuracy verification;
- Time Card invoice verification;
- Wes approval/payment review;
- a post-Wes-approval status notice.

The Invoice Entry package still controls the exact recipient set, content, attachments, required-attachment status, and restrictions. Authorization for one category or message does not authorize a different recipient, purpose, or follow-up.

#### Send And Verification

For each accepted package:

- use `OfficeAssist@BuyYourHomeLLC.com` unless the package contains specific Wes authorization for another sender;
- prefer the Outlook Email connector shared/delegated mailbox send action with Sent Items saving enabled;
- pass To, CC, and BCC as structured recipient objects;
- pass the caller's subject and body as plain-text values without rewriting them;
- validate every attachment path and pass attachments as a list of absolute local paths;
- never silently omit a required attachment;
- when required attachments cannot be sent through the connector because of size or transport limits, preserve the package as unresolved unless the shared `email-delivery` skill can use a verified OfficeAssist-capable fallback; do not replace required attachments with links, reduced files, split emails, or a no-attachment message without explicit authorization from the requesting workflow or Wes;
- make only the schema-correct retry documented in `email-delivery`, and only when the first connector error clearly explains the correction;
- after sending through the connector, query OfficeAssist Sent Items and verify sender, To, CC, BCC, subject, and required attachment presence;
- after a successful verified send, run Organize when Wes appears in To or CC;
- if the connector is definitively unavailable before a send attempt and no message was sent, the temporary current-computer fallback may use only `WesWill@BuyYourHomeLLC.com` through local Outlook under the shared Email Delivery rules;
- do not use `Wes@myBrowning.net` as a sending-account fallback; it remains authorized only as Wes's instruction identity and as the reply destination for messages originating there;
- do not use the fallback after an ambiguous connector result, a connector send attempt that might have succeeded, or a Sent Items verification failure.

The temporary WesWill fallback is standing Wes authorization for Email Monitor delivery continuity only under the exact pre-send connector-unavailable conditions above. It does not change caller-owned recipients, content, attachments, authorization, or restrictions. Preserve the requested OfficeAssist sender in the delivery record and report the actual verified fallback sender.

#### Callback Contract

After successful delivery, immediately return this result to `callback_task_thread_id`:

- `delivery_request_id`;
- `status: Sent and Verified`;
- `sent_message_id`;
- `sent_timestamp`;
- `recipients`, listing verified To, CC, and BCC values;
- `subject`;
- `attachment_verification`, listing verified attachment names or the verified no-attachment state.

Keep the callback to those fields. Preserve sender verification, connector retry details, and other evidence in Email Monitor's own delivery records unless a mismatch or blocker must be reported.

If sending or verification fails:

- do not report success;
- do not send through another mailbox;
- keep the durable request status unresolved;
- immediately report the blocker to Wes;
- return a compact failure result to `callback_task_thread_id` with the request ID, unresolved status, failure stage, exact blocker, whether a send might have occurred, and required next decision.

## Priority Selection

Prefer these message classes in the summary:

- same-day deadlines or fraud/banking actions,
- legal bills, invoices, insurance issues, or title/closing items,
- property-specific operational issues,
- direct human follow-ups that block work,
- vendor/admin items with due dates, money movement, or approvals needed.

Do not pad the summary with low-signal marketing mail just because it is unread.

## Usage Section

Before finalizing the summary body, run:

`powershell -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1"`

Use the helper's JSON output to include only in Wes's daily summary: yesterday and week-to-date wall-clock process time, yesterday and week-to-date tokens, rate-limit remaining percentages, and weekly token budget remaining when configured.

Lead this section with total wall-clock time. Tokens and rate-limit details are secondary.

If the helper fails or returns unreliable totals, state that usage totals were unavailable. Do not estimate them.

## Summary Body

Write a concise plain-text email to Boss.

Include:

- the cutoff used,
- a short priority list ordered by urgency,
- the usage section,
- a one-line note that low-priority promotional/newsletter traffic was excluded when applicable,
- signature as `Jean Wright` / `Office Assistant`.

Do not say the email is on Wes's behalf unless the actual sending identity requires that wording.

For Jenny's summary, write a concise plain-text email to Jenny. Include the mailbox scanned, cutoff used, priority items, low-priority exclusions when applicable, and a clear note if no priority messages were found.

For Josh's summary, write a concise plain-text email to Josh. Include the mailbox scanned, cutoff used, priority items, low-priority exclusions when applicable, a clear note if no priority messages were found, and the Manager Tasks section defined above.

Do not include Codex usage, token totals, rate-limit information, or process-time totals in Jenny's or Josh's summary.

## Attachment Decision

Default to no attachments.

Only include attachments when the workflow specifically requires them and the exact files are already known. This skill decides whether attachments are needed, but it does not perform attachment-upload logic itself.

## Delivery Handoff

For Boss's send step, call the shared `email-delivery` skill and pass:

- sender: `OfficeAssist@BuyYourHomeLLC.com`,
- recipient: `WesWill@BuyYourHomeLLC.com`,
- subject,
- plain-text body,
- attachment paths if any,
- the rule that send or verification failure must be reported in the OfficeAssist thread.

Let `email-delivery` handle Outlook connector preference, sender safety, attachment input format, Sent Items verification, local Outlook fallback, and failure reporting.

For Jenny's send step, call the shared `email-delivery` skill and pass:

- sender: `OfficeAssist@BuyYourHomeLLC.com`,
- recipient: `Jenny@BuyYourHomeLLC.com`,
- subject,
- plain-text body,
- attachment paths if any,
- the rule that send or verification failure must be reported in the OfficeAssist thread.

Jenny's summary is emailed to Jenny under the current global profile unless Wes explicitly changes the routing.

For Josh's send step, call the shared `email-delivery` skill and pass:

- sender: `OfficeAssist@BuyYourHomeLLC.com`,
- recipient: `IRAManager@SellYourHomeRaleigh.com`,
- CC: `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`,
- subject,
- plain-text body,
- attachment paths if any,
- the rule that send or verification failure must be reported in the OfficeAssist thread.

Josh's summary is emailed to Josh with Wes and Jenny copied under the current global profile unless Wes explicitly changes the routing.

## Failure Handling

If mailbox access, Wes token-summary generation, Manager response, or message selection is blocked before handoff, notify Wes in the OfficeAssist thread with:

- what failed,
- the summary draft if one was generated,
- what action was or was not taken.

Do not treat a failed summary run as quiet.

## State Update

After a successful verified Boss send, update the automation memory with:

- the subject,
- the cutoff used,
- the summary topics sent,
- the verified send timestamp from OfficeAssist Sent Items,
- any note about a verification draft remaining in OfficeAssist Drafts.

After a successful verified Jenny send, update the automation memory with:

- the summary date,
- the cutoff used,
- the summary topics sent,
- the verified send timestamp from OfficeAssist Sent Items,
- any mailbox-access blocker or unusual routing note.

After a successful verified Josh send, update the automation memory with:

- the summary date and subject,
- the cutoff used,
- the mailbox topics and Manager task statuses sent,
- the verified send timestamp and message id from OfficeAssist Sent Items,
- any mailbox-access, Manager-response, send, or verification blocker.

If the send fails or verification fails, record the blocker and the action taken.

Use `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` only as compact current state under `working\memory-state-spec.md`. Rewrite it instead of appending heartbeat history.

Use `C:\Codex\Wiki Files\Project Rooms\Email Monitor\tools\Update-EmailMonitorRollingLog.ps1` with `config\email-monitor-log.json` for meaningful operational history. Retain seven days in the single Teams file at `Office Admin/Codex Logs/Email Monitor/Email Monitor - Rolling 7 Days.md`. Exclude routine no-activity checks. If Teams is unavailable, use the one capped pending file defined by the config and merge it on the next successful log write.

For routed emails and direct Email Delivery requests that matter for audit, debugging, or follow-up, also update `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\routing-action-log.md` with the durable outcome: Outlook message or delivery request, mode or branch, preserved Outlook reference, external source path if any, delivery record, handoff/recipient, status, and notes. Do not commit connector search scratch output, temporary drafts, duplicate fetched message bodies, routed email body files, or routed attachments merely to show how the routing decision was made.
## Start PR Pointer

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
