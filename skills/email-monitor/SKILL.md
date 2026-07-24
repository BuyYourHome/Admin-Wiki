---
name: email-monitor
description: Create Wes's, Jenny's, and Josh's daily OfficeAssist mailbox summaries, run Email Routing, execute authorized Email Delivery handoffs, and maintain the Email Monitor Health Check watchdog pattern. Use for mailbox summaries, routed-email intake, direct delivery requests, health-state diagnostics, or workflow-specific watchdog configuration.
---

# Email Monitor

## Overview

Create daily summaries for Boss at `WesWill@BuyYourHomeLLC.com`, Jenny at `Jenny@BuyYourHomeLLC.com`, and Josh at `IRAManager@SellYourHomeRaleigh.com`, then hand off delivery to the shared `email-delivery` skill. Josh's summary also includes the current Manager Task mode list. Email Monitor also receives complete, authorized outbound-email delivery packages directly from other Project Rooms and executes them immediately through Email Delivery.

For summaries and routing, this skill owns mailbox scanning, cutoff selection, message prioritization, summary drafting, Wes's usage-summary inclusion, and summary-run state updates. For direct delivery handoffs, the requesting Project Room owns the message purpose, authorization, recipients, subject, body, attachments, and workflow-specific restrictions. Email Monitor owns package validation, duplicate prevention, delivery coordination through `email-delivery`, durable delivery-request state, callback reporting, and escalation. The shared `email-delivery` skill owns sender safety, connector handling, Sent Items verification, and delivery failure mechanics.

Development notes, source inventory, and open questions for this workflow live in `C:\Codex\Wiki Files\Project Rooms\Email Monitor\`.

## Inputs

Before using this skill, have:

- the global profile at `C:\Codex\Office Assistant Profile.md`,
- the admin rules in `C:\Codex\Wiki Files\AGENTS.md`,
- the automation memory file for this workflow at `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`,
- access to `WesWill@BuyYourHomeLLC.com` mailbox contents,
- access to `Jenny@BuyYourHomeLLC.com` mailbox contents when running Jenny's summary,
- access to `IRAManager@SellYourHomeRaleigh.com` mailbox contents when running Josh's summary,
- direct task messaging access to Manager task `019f8274-5b7e-7170-a051-f7944954de82`,
- access to `C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1` when Wes's usage totals are needed.

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

- after a successful verified send, update the automation memory with the summary date, weekly subject and Monday-through-Sunday week identifier, cutoff used, topics sent, verified send timestamp from OfficeAssist Sent Items, and any unusual routing, blocker, or verification-draft note;
- if mailbox access, Wes token-summary generation, Manager response, send, or verification fails, record the blocker and action taken;
- do not treat a failed summary run as quiet.

### Health Check

Use Health Check to maintain Email Monitor's workflow-specific liveness state and independent Windows watchdog. Follow `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\health-check-spec.md` and its JSON config and PowerShell tools.

At heartbeat start, call the health updater with `Started` and the intended mode. Before returning, call it with `Completed`; on failure call it with `Failed`, a stage, and a concise message. The scheduled watchdog on the assigned machine owns stale-run evaluation, deduplicated warning/critical/recovery alerts, diagnostics, and wrong-machine refusal. It must not depend on the Outlook connector it supervises.

When Wes addresses Health Check in plain language, use `C:\Codex\Wiki Files\Project Rooms\Email Monitor\tools\Manage-CodexWorkflowHealth.ps1` as the control surface. Map the request to exactly one of `Options`, `Status`, `Enable`, `Disable`, `Configure`, `Test`, or `TestAlert`, execute it, and report the resulting effective settings. When Wes asks what the mode can do, asks for available commands, or says “Health Check, what are my options?”, run `Options`; do not rely on memory to enumerate the choices.

For `Configure`, pass only values Wes requested. Ask a clarifying question when “interval” or “run every” could mean either the Email Monitor heartbeat schedule or the watchdog polling interval. Configuration changes require healthy state by default. Use `AllowUnhealthy` only when Wes explicitly authorizes changing Health Check while unhealthy. Disabling the watchdog stops independent alerts but does not stop heartbeat health-state writes. Treat machine reassignment as a guided migration: verify the destination machine and its scheduled task before disabling the current machine or changing the canonical assignment.

### Email Routing

Use Email Routing as the OfficeAssist mailbox intake funnel during the configured active window.

For each new message:

- check `OfficeAssist@BuyYourHomeLLC.com` Inbox, Task Instructions, and Accts Payable;
- use monitor memory so the same Outlook message id is not processed repeatedly;
- recognize instructions from `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`;
- perform a safe, in-scope admin action or start the applicable workflow when current Admin wiki rules authorize it;
- hold and report a decision needed when authorization, routing, or high-impact action authority is incomplete;
- apply the specialized routing branch when the message matches Gracious Millionaire, Web Site, Brynda Suit, Manager Routing, or Route Vendor Invoice rules;
- return quietly when no new actionable or routable message is found.

Email Routing is not the trigger for the scheduled Email Summary mode or a direct Project Room Email Delivery handoff.

#### General Instruction Handling

Use General Instruction Handling for an authorized Wes or Jenny instruction that does not match a specialized routing branch. Determine the applicable Admin wiki rule or workflow, complete safe authorized work, or route it to the owning workflow. Do not invent authority or bypass a specialized Project Room's ownership boundary.

#### Gracious Millionaire Email Routing

Use Gracious Millionaire Email Routing when Email Routing sees an email that belongs to Gracious Millionaire.

This mode owns source routing and direct project-room handoff only. It does not own Gracious Millionaire manuscript processing, book-response drafting, external email sending, or mailbox monitoring from the Gracious Millionaire project-room heartbeat.

Activation:

- the email subject contains `gracious millionaire`; or
- the email otherwise clearly belongs to the Gracious Millionaire book/project-room workflow.

For each routed email:

- preserve the email as its own Markdown source file under `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\sources\email\`;
- include sender, recipients, sent time when available, received time, subject, Outlook message id or web link when available, and body text;
- use a stable, filesystem-safe filename that starts with the email date/time and a short subject slug;
- update `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\officeassist-intake-log.md` when the current Gracious Millionaire project-room rules require the intake ledger;
- update `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\source-inventory.md` when the routed source becomes part of the durable source inventory;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing Gracious Millionaire project-room thread with the routed source path and a short summary of the email.

Direct message handoff is the primary trigger for Gracious Millionaire project-room processing. The `gracious-millionaire-project-room-heartbeat` remains only a backup processor for files that have already been routed into the project room.

Current Gracious Millionaire project-room thread id: `019eb9b0-6780-7fb3-a278-29a18d17998c`.

Do not attach mailbox checking to the Gracious Millionaire heartbeat. Do not create a new Gracious Millionaire chat. Do not draft, edit, or send the requested book response from this Email Monitor task unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

#### Web Site Email Routing

Use Web Site Email Routing when Email Routing sees an instruction email from Wes or Jenny that belongs to REI BlackBook website work.

This mode owns source routing and direct REI BlackBook project-room handoff only. It does not own live REI BlackBook website editing, browser automation, public-site publishing, external email sending, or creating a new REI BlackBook chat.

Activation:

- the email subject contains `GM Site`; or
- the email otherwise clearly belongs to REI BlackBook WebTools Sites or Gracious Millionaire website workflow.

For each routed email:

- preserve the email as its own Markdown source file under `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\sources\email\`;
- include sender, recipients, sent time when available, received time, subject, Outlook message id or web link when available, and body text;
- use a stable, filesystem-safe filename that starts with the email date/time and a short subject slug;
- update `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\working\source-inventory.md` when the routed email becomes part of the durable source set;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing REI Blackbook project-room thread with the routed source path, a short summary of the email, and the instruction to process the website request.

Current REI Blackbook project-room thread id: `019f4691-5466-7f72-9683-ab5d3b750c25`.

Do not create a new REI Blackbook chat for this routing unless Wes explicitly asks. Do not process the REI BlackBook website request from this Email Monitor task unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

#### Brynda Suit Email Routing

Use Brynda Suit Email Routing when Email Routing sees an instruction email from Wes or Jenny that belongs to Brynda Suit.

This mode owns source routing and direct Brynda Suit task handoff only. It does not own Brynda Suit response drafting, external email sending, or creating a new Brynda Suit task.

Activation:

- the email subject contains `brynda suit`; or
- the email otherwise clearly belongs to the Brynda Suit workflow.

For each routed email:

- preserve the email as its own Markdown source file under `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\sources\email\`;
- include sender, recipients, sent time when available, received time, subject, Outlook message id or web link when available, and body text;
- use a stable, filesystem-safe filename that starts with the email date/time and a short subject slug;
- update `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\working\source-inventory.md` when the routed email becomes part of the durable source set;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing Brynda Suit task with the routed source path, a short summary of the email, and the instruction to wake up and respond to the email.

Current Brynda Suit task id: `019f61c3-d4c0-7a52-a5a0-e4066ea9b303`.

Do not create a new Brynda Suit task for this routing unless Wes explicitly asks. Do not process the Brynda Suit response from this Email Monitor task unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

#### Manager Routing

Use Manager Routing when Email Routing sees an email whose subject contains `Manager Task`, matched case-insensitively. This includes the established `[Manager Task][<Priority>][<Task ID>] <short title>` format and normal reply or forward prefixes.

Preserve it as Markdown under `C:\Codex\Wiki Files\Project Rooms\Manager\sources\email\` with message and attachment metadata. Save safely retrievable attachments beside the source; otherwise preserve the Outlook link and report the blocker. Update the Manager source inventory when applicable, record the Outlook message id in Email Monitor memory, and send Manager task `019f8274-5b7e-7170-a051-f7944954de82` a direct handoff with the source path, attachment paths or blocker, sender, summary, and instruction to process it under Manager Tasks mode.

Manager must determine whether the email is a new task request, delivery-related message, or status update and apply its existing sender, task-id, status, authorization, and task-register rules. Email Monitor must not infer a status change, create or edit a Manager task, or perform the requested business action from this routing branch.

#### Route Vendor Invoice

Use Route Vendor Invoice when Email Routing sees a contractor or vendor email that appears to contain or request processing of an invoice, bill, receipt, payment request, statement, pay application, draw request, or project-cost document.

This mode owns source routing and direct Invoice Entry task handoff only. It does not own invoice approval, payment, vendor contact, final accounting judgment, live project-spreadsheet entry, Teams filing, or creating a new Invoice Entry chat.

Activation:

- the sender display name is `Josh Kennedy` and the subject is exactly `Time Card`, matched case-insensitively;
- the email is from a contractor, subcontractor, vendor, supplier, utility, service provider, or property/project cost sender and the subject, body, attachment name, or message context contains `invoice`, `bill`, `receipt`, `statement`, `pay app`, `payment request`, `draw`, or another clear invoice-entry signal;
- the email is from Wes or Jenny and forwards, attaches, or explicitly routes a contractor/vendor invoice or project-cost email for processing;
- the email otherwise clearly belongs to the Invoice Entry workflow.

For each routed email:

- preserve the email as its own Markdown source file under `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\sources\email\`;
- include sender, recipients, sent time when available, received time, subject, Outlook message id or web link when available, body text, and available attachment names/metadata;
- when the connector or local mailbox path can safely retrieve attachments, save invoice attachments beside the routed email source in a stable folder and reference those files from the Markdown source;
- if an apparent invoice attachment cannot be retrieved, preserve the Outlook message link and report the attachment-access blocker in the handoff;
- use a stable, filesystem-safe filename that starts with the email date/time and a short sender/subject slug;
- update `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\working\source-inventory.md` or the current Invoice Entry intake ledger when the routed email becomes part of the durable source set;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing Invoice Entry task with the routed source path, attachment paths or attachment blocker, a short summary of the vendor/project clues, and the instruction to process the invoice under Invoice Entry rules.

Current Invoice Entry task id: `019f3d56-b310-75c0-b084-616bfc1e9f59`.

Do not create a new Invoice Entry task for this routing unless Wes explicitly asks. During intake routing, do not approve, pay, reply to the contractor/vendor, make live spreadsheet entries, or move files into Teams from this Email Monitor task unless Wes explicitly asks for processing here and the Invoice Entry rules allow it. This intake-stage prohibition on contractor/vendor contact does not block a later Email Delivery request when Invoice Entry's saved rules and the delivery package explicitly authorize that specific message. The default intake action remains source routing plus direct Invoice Entry handoff only.

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

Before any send attempt, search the Email Monitor delivery records and automation memory for `delivery_request_id`.

- If that request is already `Sent and Verified`, do not send it again; return the existing verified result to the callback task/thread.
- If it is `Sending`, `Held`, `Failed - Unresolved`, or otherwise unresolved, do not create a second send attempt until the existing record is reconciled under the shared Email Delivery retry rules.
- If it is new and complete, create a durable request record before invoking the connector, then update that same record with the final result.

Use `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` as the default durable delivery-request record unless the Project Room establishes a dedicated Email Monitor delivery ledger. Record the request ID, origin and callback IDs, authorization basis, immutable delivery fields or a precise reference to them, status, timestamps, sent message ID when available, verification details, and blocker notes.

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
- make only the schema-correct retry documented in `email-delivery`, and only when the first connector error clearly explains the correction;
- after sending, query OfficeAssist Sent Items and verify sender, To, CC, BCC, subject, and required attachment presence;
- do not send through another mailbox after a send or verification failure.

If specific Wes authorization names a sender other than OfficeAssist, preserve that sender in the request but hold the request unless the shared Email Delivery rules and available connector can safely use that exact sender and still satisfy the required Sent Items verification. Do not silently fall back to another mailbox.

#### Callback Contract

After successful delivery, immediately return this result to `callback_task_thread_id`:

- `delivery_request_id`;
- `status: Sent and Verified`;
- sent message ID;
- sent timestamp;
- verified sender;
- verified To recipients;
- verified CC and BCC recipients;
- subject;
- attachment verification, including verified attachment names or the verified no-attachment state;
- delivery notes, including any documented schema-correct retry.

If sending or verification fails:

- do not report success;
- do not send through another mailbox;
- keep the durable request status unresolved;
- immediately report the blocker to Wes;
- return a failure result to `callback_task_thread_id` with the request ID, failure stage, connector or verification result, unresolved status, and required next decision.

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

Use `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` as the persistent run memory unless Wes explicitly changes the live automation storage location.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
