# Email Monitor

This project room holds development notes, source inventory, and review artifacts for the Email Monitor workflow.

## Purpose

- Keep Email Monitor development separate from the general Admin Operations chat.
- Preserve the active automation id: `officeassist-morning-email-summary-and-instruction-monitor`.
- Keep the canonical workflow source in `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md`.
- Track the active OfficeAssist heartbeat config at `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`.
- Keep OfficeAssist instruction-email monitor memory in `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`.
- Record open decisions before changing mailbox scope, cutoff behavior, delivery behavior, or automation thread targeting.

## Current Status

- Status: active for Wes, Jenny, and Josh.
- Active automation id: `officeassist-morning-email-summary-and-instruction-monitor`.
- Schedule: starts at 7:45 AM Eastern, then every 15 minutes from 8:00 AM through 11:00 PM Eastern.
- Jenny summary: active as of 2026-06-29; scan `Jenny@BuyYourHomeLLC.com` and email the summary to `Jenny@BuyYourHomeLLC.com` from OfficeAssist with Sent Items verification.
- Josh summary: active as of 2026-07-21; scan `IRAManager@SellYourHomeRaleigh.com`, obtain the Manager Tasks section directly from the Manager task, and email the summary to Josh from OfficeAssist with Wes and Jenny copied and Sent Items verification.
- Send identity: `OfficeAssist@BuyYourHomeLLC.com`.
- Recipient for Wes summary: `WesWill@BuyYourHomeLLC.com`.
- Preferred mailbox/send path: Outlook Email connector, with OfficeAssist sent-item verification.
- Fallback: local Outlook only when connector send or verification cannot complete safely.
- Automation type: heartbeat, attached to the dedicated `Email Monitor` thread.
- Responsibility boundary: the heartbeat checks email and takes defined actions. Separately, direct authorized Email Delivery handoffs from other Project Rooms trigger immediately without waiting for the heartbeat or scanning a mailbox. Email Monitor coordinates delivery but does not take ownership of the requesting workflow's purpose, content, authorization, recipients, attachments, or restrictions.
- Status thread id: `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`.

## Room Layout

- `sources\` - source notes for controlling rules, skill source, automation config, connector behavior, and related files.
- `working\` - inventories, conflicts, missing context, development notes, and proposed changes.
- `outputs\` - review-ready specs, handoffs, runbooks, or finalized drafts.
- Durable routing and delivery outcomes are recorded in `working\routing-action-log.md`; record what happened to the email or delivery request instead of preserving connector scratch output in Git.

## Modes

### Email Summary

Use this mode for the once-daily Boss, Jenny, and Josh Outlook mailbox summaries.

This mode scans `WesWill@BuyYourHomeLLC.com` for Boss, `Jenny@BuyYourHomeLLC.com` for Jenny, and `IRAManager@SellYourHomeRaleigh.com` for Josh, using the last verified send time in OfficeAssist monitor memory as each mailbox cutoff. Josh's initial cutoff is the verified manual summary send at `2026-07-21T12:24:17Z`. It scans each mailbox recursively, including rule-routed folders, and summarizes unread or newly received priority business messages: financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented.

This mode sends Boss's summary to `WesWill@BuyYourHomeLLC.com`, Jenny's summary to `Jenny@BuyYourHomeLLC.com`, and Josh's summary to `IRAManager@SellYourHomeRaleigh.com` with Wes and Jenny copied, from `OfficeAssist@BuyYourHomeLLC.com`. Josh's summary obtains its `Manager Tasks` section directly from Manager task `019f8274-5b7e-7170-a051-f7944954de82`; Email Monitor does not read or edit the Manager register. Codex Usage appears only in Wes's summary and is omitted from Jenny's and Josh's summaries. The shared `email-delivery` skill owns the send step, OfficeAssist sender safety, and Sent Items verification.

This mode runs only once per calendar day per recipient at the first eligible heartbeat at or after 8:00 AM Eastern. Later same-day heartbeat runs skip summaries that were already sent and verified.

For each recipient, keep the Email Summary subject unchanged throughout the Monday-through-Sunday week in Eastern Time. Calculate the `Week of` date as that week's Monday and use `MM-DD-YY` format. The exact subject patterns are `Wes Email Summary Week of MM-DD-YY`, `Jenny Email Summary Week of MM-DD-YY`, and `Josh Email Summary Week of MM-DD-YY`. Use the resulting subject for all daily summaries and retries during that week, and record it with the Monday week-start date in monitor memory before delivery.

### Health Check

Use this mode to hold the Email Monitor health specification, maintain machine-local run state, configure the independent Windows watchdog, and provide a reusable pattern for other Project Rooms.

Email Monitor writes `Started`, `Completed`, or `Failed` state to its local `health.json`. Windows Task Scheduler runs the watchdog every 10 minutes on assigned machine `WESSTUDIO`. During the 7:45 AM through 11:00 PM Eastern active window, it warns after 35 minutes without a completed heartbeat, escalates at 60 minutes, and issues one recovery notice when service resumes.

The watchdog runs PowerShell hidden, writes a durable log, alert state, current-alert file, and attempts a Windows toast plus Application event-log entry. It does not use the Outlook connector and does not provide remote SMS or email until an independent delivery channel is configured.

Wes can manage this mode in plain language, including asking “Health Check, what are my options?” The mode can show status, enable or disable the watchdog, change intervals, thresholds, or the active window, run a quiet diagnostic, and send a visible test alert. Configuration changes require current healthy state by default. Machine reassignment remains guided and requires destination verification before the old watchdog is disabled.

Specification: `working\health-check-spec.md`. Control surface: `tools\Manage-CodexWorkflowHealth.ps1`. Reusable tools: `tools\Update-CodexWorkflowHealth.ps1`, `tools\Invoke-CodexWorkflowWatchdog.ps1`, and `tools\Install-CodexWorkflowWatchdog.ps1`. Email Monitor configuration: `config\email-monitor-health.json`.

### Email Routing

Use Email Routing as the OfficeAssist mailbox intake funnel. It checks Inbox, Task Instructions, and Accts Payable during the active window, prevents duplicate processing by Outlook message id, handles safe authorized instructions from Wes or Jenny, and applies the appropriate specialized routing branch. It reports incomplete authority or high-impact decisions and returns quietly when no message requires action.

Email Routing contains General Instruction Handling, Gracious Millionaire Email Routing, Web Site Email Routing, Brynda Suit Email Routing, Manager Routing, and Route Vendor Invoice. It does not trigger the scheduled Email Summary mode or direct Project Room Email Delivery handoffs.

#### Gracious Millionaire Email Routing

Use this branch when Email Routing sees an email with a subject containing `gracious millionaire`, or an email that otherwise clearly belongs to the Gracious Millionaire book/project-room workflow.

This mode routes the email into `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\` as source material, preserves it as Markdown under `sources\email\`, updates Gracious Millionaire intake/source records when required by that room's rules, records the Outlook message id in Email Monitor memory, and sends a direct follow-up message to the existing Gracious Millionaire project-room thread with the routed source path and a short summary.

This mode does not draft, edit, or send the requested Gracious Millionaire book response from the Email Monitor task unless Wes explicitly asks for processing here. It also does not attach mailbox checking to the Gracious Millionaire heartbeat or create a new Gracious Millionaire chat.

#### Brynda Suit Email Routing

Use this branch when Email Routing sees an email from Wes or Jenny with a subject containing `brynda suit`, or an email that otherwise clearly belongs to the Brynda Suit workflow.

This mode routes the email into `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\` as source material, preserves it as Markdown under `sources\email\`, updates the Brynda Suit source inventory when the routed email becomes part of the durable source set, records the Outlook message id in Email Monitor memory, and sends a direct follow-up message to the existing Brynda Suit task with the routed source path, a short summary, and the instruction to wake up and respond.

This mode does not draft, edit, or send the requested Brynda Suit response from the Email Monitor task unless Wes explicitly asks for processing here. It also does not create a new Brynda Suit task.

#### Manager Routing

Use this branch when Email Routing sees an email whose subject contains `Manager Task`, matched case-insensitively, including the established bracketed Manager subject format and normal reply or forward prefixes.

This mode preserves the email as Markdown under `C:\Codex\Wiki Files\Project Rooms\Manager\sources\email\`, saves safely retrievable attachments beside it, records the Outlook message id in Email Monitor memory, and sends a direct follow-up message to the existing Manager task `019f8274-5b7e-7170-a051-f7944954de82`. The handoff includes the routed source path, attachment paths or blocker, sender, a short summary, and an instruction to process the email under Manager Tasks mode.

Email Monitor does not create or edit Manager tasks, infer task status changes, or perform the requested business action. Manager owns sender and task-id validation, task classification, status interpretation, authorization checks, and task-register updates.

### Email Delivery

Use this mode when this project room has an authorized email ready to send, another Email Monitor mode reaches its send step, or an authorized Project Room, including Invoice Entry, sends a complete direct delivery handoff. A direct handoff triggers immediately. It does not require mailbox scanning, an instruction email, the Email Monitor heartbeat, or a rerun of the originating workflow.

This mode is connected directly to `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`. The requesting Project Room owns the message purpose, authorization, sender request, To/CC/BCC recipients, subject, exact plain-text body, attachment paths and required status, and workflow-specific restrictions. Email Monitor owns package validation, request-ID duplicate prevention, delivery coordination, durable delivery-request state, failure escalation, and callback reporting. The shared Email Delivery skill owns OfficeAssist sender safety, connector handling, attachment-path validation and parameter shape, Sent Items verification, its documented retry, and delivery failure mechanics.

Every direct package must provide:

- delivery request ID;
- originating Project Room and task/thread ID;
- authorization basis;
- sender mailbox;
- To, CC, and BCC recipients, with unused recipient classes explicitly empty;
- subject and exact plain-text body;
- absolute attachment paths, including an explicit empty list when unused;
- attachment-required status;
- workflow-specific restrictions;
- callback task/thread ID.

Reject or hold incomplete or conflicting packages. Do not invent or change any caller-owned field. Before sending, search durable Email Monitor delivery records and automation memory for the request ID. A request already marked `Sent and Verified` must not be sent again; return its existing result. A request already unresolved must not start a parallel send. Record a new accepted request before invoking the connector and update that record with the result. The default durable record is `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` unless Email Monitor establishes a dedicated delivery ledger.

A properly authorized Invoice Entry package may request vendor invoice-accuracy verification, Time Card invoice verification, Wes approval/payment review, or a post-Wes-approval status notice. Route Vendor Invoice's prohibition on contacting a vendor applies to intake routing; it does not block a later, specifically authorized Email Delivery package under Invoice Entry's saved rules.

For an accepted connector send, use `OfficeAssist@BuyYourHomeLLC.com` unless the package contains specific Wes authorization for another sender. Prefer the Outlook connector, enable Sent Items saving, pass structured recipient objects, preserve the exact plain-text subject/body, and pass attachments as a list of absolute paths. Never omit a required attachment. Make only the documented schema-correct retry when the first connector error clearly explains it. Do not fall back to another mailbox after failure.

After sending, verify the OfficeAssist Sent Items copy for sender, To, CC, BCC, subject, and attachment presence. On success, immediately return to the callback task/thread: request ID, `Sent and Verified`, sent message ID, sent timestamp, verified sender and recipients, subject, attachment verification, and delivery notes. On send or verification failure, preserve the unresolved request, report the blocker to Wes immediately, and return the failure stage and required decision to the callback task/thread without claiming success.

## Authoritative Sources

- `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md`
- `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Email Monitor\working\routing-action-log.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`

## Development Boundary

Use this room for development and design work. Do not change the live automation id, schedule, target thread, sender, recipient, or mailbox scope without a specific instruction from Wes.

When the workflow changes, update the skill, this project room, and the registry together.

## Change Log

- 2026-07-24: Added `working\routing-action-log.md` as the durable outcome log for routed emails and Email Delivery requests.

- 2026-07-24: Added conversational Health Check management for option discovery, status, enable/disable, configuration, diagnostics, and test alerts, with healthy-state and machine-migration safeguards.

- 2026-07-24: Added Health Check mode with reusable health-state, watchdog, installer, machine-assignment config, local alerts, diagnostics, and Windows Task Scheduler pattern.

- 2026-07-24: Changed Josh's `Manager Tasks` source to a direct Manager-task response and removed Codex Usage from Jenny's and Josh's summaries; Wes's usage section remains active.

- 2026-07-24: Added Manager Routing for email subjects containing `Manager Task`, with durable Manager source preservation, duplicate prevention, attachment handling, and direct handoff to the existing Manager task.

- 2026-07-24: Renamed Instruction Email Monitoring to Email Routing and made the specialized project routes explicit branches under that intake mode; behavior and automation identity remain unchanged.

- 2026-07-24: Standardized weekly subjects as `[Wes/Jenny/Josh] Email Summary Week of MM-DD-YY`, using the Monday that begins the Eastern Time summary week.

- 2026-07-24: Required a separate stable Email Summary subject for Boss, Jenny, and Josh throughout each Monday-through-Sunday Eastern Time week, with monitor-memory tracking and Sent Items recovery.

- 2026-07-22: Expanded Email Delivery to accept immediate authorized handoffs from other Project Rooms, including Invoice Entry; added the complete delivery-package schema, request-ID duplicate prevention, durable request state, fixed success/failure callbacks, and the intake-routing versus later-authorized-delivery distinction.

- 2026-07-21: Added Jenny as a required CC on Josh's recurring Email Summary while preserving Wes as CC.

- 2026-07-21: Added Josh's recurring Email Summary for `IRAManager@SellYourHomeRaleigh.com`, with Wes copied, full recursive mailbox scanning, verified-send cutoff state, and a read-only Manager Task mode list grouped by status and ordered by priority.

- 2026-07-20: Renamed Daily Email Summary to Email Summary without changing its existing Wes/Jenny mailbox-summary behavior.
- 2026-07-20: Defined Email Delivery as an Email Monitor project-room mode connected directly to the shared `email-delivery` skill and added the Outlook shared-mailbox send, attachment retry, Sent Items verification, and delivery-log contract.
- 2026-07-16: Renamed the project room, chat, and skill from `Email Summary` / `email-summary` to `Email Monitor` / `email-monitor`; the live automation id remains `officeassist-morning-email-summary-and-instruction-monitor`.
- 2026-07-16: Defined Brynda Suit Email Routing for routed-source preservation and direct handoff to the existing Brynda Suit task.
- 2026-07-15: Defined the mode now named Email Summary for Boss and Jenny mailbox summaries, including mailbox scan, cutoff, summary drafting, OfficeAssist delivery handoff, Sent Items verification, and state update boundaries.
- 2026-07-15: Defined Gracious Millionaire Email Routing and moved the existing Gracious Millionaire routed-email handoff behavior under that mode in the Email Monitor skill.
- 2026-07-02: Wes changed Jenny's daily summary routing so the summary is emailed to `Jenny@BuyYourHomeLLC.com` from OfficeAssist with Sent Items verification.
- 2026-06-29: Resumed Jenny's daily email summary after Wes explicitly requested it and the Outlook Email connector verified access to `Jenny@BuyYourHomeLLC.com`.
- 2026-07-01: Extended the OfficeAssist Email Monitor heartbeat schedule to run every 15 minutes through 11:00 PM Eastern.
- 2026-06-28: Updated the live heartbeat prompt so OfficeAssist instruction-email monitoring runs every day during the configured active window, not weekdays only.
- 2026-06-28: Wes clarified the separation between rooms: the Gracious Millionaire heartbeat watches for new Markdown files dropped into that project room; the Email Monitor heartbeat watches email and takes defined actions when it finds actionable instructions.
- 2026-06-28: Renamed the project room, chat, and skill to `Email Summary`; the live automation id remains `officeassist-morning-email-summary-and-instruction-monitor`.
- 2026-06-28: Removed the stale local `officeassist-morning-email-summary` automation folder after moving monitor memory into the active `officeassist-morning-email-summary-and-instruction-monitor` folder.
- 2026-06-28: Recreated the OfficeAssist heartbeat in the app under `officeassist-morning-email-summary-and-instruction-monitor` after the old app id was missing, and changed the active schedule to start at 7:45 AM Eastern.
- 2026-06-15: With Wes's approval, converted `officeassist-morning-email-summary` from a standalone cron automation to a heartbeat automation attached to the dedicated `Email Monitor` thread so daily runs stop creating new chats.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
