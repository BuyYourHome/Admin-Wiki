# Email Monitor

This project room holds development notes, source inventory, and review artifacts for the Email Monitor workflow.

## Purpose

- Keep Email Monitor development separate from the general Admin Operations chat.
- Preserve the active automation id: `officeassist-morning-email-summary-and-instruction-monitor`.
- Keep the canonical workflow source in `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md`.
- Track the active OfficeAssist heartbeat config at `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`.
- Keep compact current state in `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`; it is not a heartbeat-history file.
- Keep one seven-day rolling operational log in Teams at `Office Admin/Codex Logs/Email Monitor/Email Monitor - Rolling 7 Days.md`.
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
- Current-computer fallback: when the connector is definitively unavailable and no send occurred, use only the locally mounted `WesWill@BuyYourHomeLLC.com` mailbox under the temporary Jean fallback rules. OfficeAssist is never mounted locally on this computer.
- Automation type: heartbeat, attached to the dedicated `Email Monitor` thread.
- Responsibility boundary: the heartbeat checks email and takes defined actions. Separately, direct authorized Email Delivery handoffs from other Project Rooms trigger immediately without waiting for the heartbeat or scanning a mailbox. Email Monitor coordinates delivery but does not take ownership of the requesting workflow's purpose, content, authorization, recipients, attachments, or restrictions.
- Status thread id: `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`.
- Task lifecycle: keep one dedicated active task and keep routine heartbeat history outside task context. Do not replace it for ordinary compaction; use the controlled, Wes-approved rollover procedure only when multiple measured health signals justify it.
- Durable dispatch queue: `\\WES-VIDEOEDITOR\BYH-PRMessaging$\records`, managed by `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1`. Queue records are runtime state outside Git. The former Email Monitor queue is read-only legacy history.

## Room Layout

- `sources\` - source notes for controlling rules, skill source, automation config, connector behavior, and related files.
- `working\` - inventories, conflicts, missing context, development notes, and proposed changes.
- `outputs\` - review-ready specs, handoffs, runbooks, or finalized drafts.
- Durable routing and delivery outcomes are recorded in `working\routing-action-log.md`; record what happened to the email or delivery request instead of preserving connector scratch output in Git.
- Routed emails and attachments should not be saved as routine source files in the Admin wiki Git repo. Preserve Outlook message ids or web links, short summaries, statuses, and external Teams paths in Git logs and inventories. If a routed source must be materialized, store it outside Git in the owning Project Room's Teams source/reference, working, or archive location under that room's rules.

## Modes

Formal modes are Email Summary, Health Check, Task Health, Email Routing, Route Vendor Invoice, Organize, and Email Delivery.

### Email Summary

Use this mode for the once-daily Boss, Jenny, and Josh Outlook mailbox summaries.

This mode scans `WesWill@BuyYourHomeLLC.com` for Boss, `Jenny@BuyYourHomeLLC.com` for Jenny, and `IRAManager@SellYourHomeRaleigh.com` for Josh, using the last verified send time in OfficeAssist monitor memory as each mailbox cutoff. Josh's initial cutoff is the verified manual summary send at `2026-07-21T12:24:17Z`. It scans each mailbox recursively, including rule-routed folders, and summarizes unread or newly received priority business messages: financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented.

This mode sends Boss's summary to `WesWill@BuyYourHomeLLC.com`, Jenny's summary to `Jenny@BuyYourHomeLLC.com`, and Josh's summary to `IRAManager@SellYourHomeRaleigh.com` with Wes and Jenny copied, from `OfficeAssist@BuyYourHomeLLC.com`. Josh's summary obtains its `Manager Tasks` section directly from Manager task `019f8274-5b7e-7170-a051-f7944954de82`; Email Monitor does not read or edit the Manager register. Codex Usage appears only in Wes's summary and is omitted from Jenny's and Josh's summaries. The shared `email-delivery` skill owns the send step, OfficeAssist sender safety, and Sent Items verification.

This mode runs only once per calendar day per recipient at the first eligible heartbeat at or after 8:00 AM Eastern. Later same-day heartbeat runs skip summaries that were already sent and verified.

For each recipient, keep the Email Summary subject unchanged throughout the Monday-through-Sunday week in Eastern Time. Calculate the `Week of` date as that week's Monday and use `MM-DD-YY` format. The exact subject patterns are `Wes Email Summary Week of MM-DD-YY`, `Jenny Email Summary Week of MM-DD-YY`, and `Josh Email Summary Week of MM-DD-YY`. Use the resulting subject for all daily summaries and retries during that week, and record it with the Monday week-start date in monitor memory before delivery.

### Health Check

Use this mode to own one independent Windows workflow-health supervisor for multiple registered workflows. The shared registry enrolls Email Monitor and Invoice Entry while keeping separate configurations, health snapshots, alert transitions, current-alert files, and diagnostic logs.

The Windows task `Codex - Workflow Health Supervisor` runs every 10 minutes on `WESSTUDIO`. Email Monitor keeps its heartbeat lifecycle, 7:45 AM through 11:00 PM active window, 35-minute warning, and 60-minute critical threshold. Invoice Entry receives a daily substantive Project Room/task-health review; intervening supervisor runs perform only a due check unless warning, critical, or active-operation follow-up is required.

Routine healthy and unchanged-state checks are diagnostic-only. Visible warning, critical, and recovery alerts occur only on state transitions. The supervisor uses a named mutex for overlap protection, isolates malformed workflow configurations, refuses the wrong machine, and does not depend on Outlook or another supervised connector.

Meaningful Email Monitor history is written to the central Teams rolling log through `tools\Update-EmailMonitorRollingLog.ps1`. The file retains seven days and excludes routine no-activity checks. Active `memory.md` follows `working\memory-state-spec.md` and remains compact.

Wes can manage this mode in plain language, including asking “Health Check, what are my options?” The mode can show status, enable or disable the watchdog, change intervals, thresholds, or the active window, run a quiet diagnostic, and send a visible test alert. Configuration changes require current healthy state by default. Machine reassignment remains guided and requires destination verification before the old watchdog is disabled.

Invoice Entry task-growth thresholds trigger review only. The supervisor may recommend controlled rollover but cannot create or archive a task; Wes must approve rollover separately.

Specification: `working\health-check-spec.md`. Registry: `config\workflow-health-registry.json`. Control surface: `tools\Manage-CodexWorkflowHealth.ps1`. Supervisor: `tools\Invoke-CodexWorkflowHealthSupervisor.ps1`.

### Task Health

Task Health reviews Email Monitor's operational Codex task rather than heartbeat liveness. Activate it from a Wes request, an authorized context-health transition handoff, or observable task degradation. Read `working\work-status.md`, current delivery state, unresolved requests, routing evidence, heartbeat state, and Git classification; measure turns, compactions, stalls, timeouts, and duplicate external actions only when observable.

The review reports readiness and stops for Wes's approval. An approved rollover keeps one active Email Monitor task, verifies one replacement from durable state, inventories all task-ID and callback dependencies, retargets the existing heartbeat and authorized routing references without duplication, and archives the predecessor only after no delivery remains ambiguous or in flight. Task Health does not create another Project Room, skill, Git branch, heartbeat, or delivery endpoint.

### Email Routing

Use Email Routing as the OfficeAssist mailbox intake funnel. It checks Inbox, Task Instructions, and Accts Payable during the active window, prevents duplicate processing by Outlook message id, handles safe authorized instructions from Wes, Jenny, or Josh Kennedy, and applies the appropriate specialized routing branch. Josh may initiate safe workflows but may not authorize purchases, payments, approvals, or another Wes-gated action. It reports incomplete authority or high-impact decisions and returns quietly when no message requires action.

Email Routing contains General Instruction Handling, Lowes Order Email Routing, Gracious Millionaire Email Routing, Web Site Email Routing, Brynda Suit Email Routing, Manager Routing, and Route Vendor Invoice. It does not trigger the scheduled Email Summary mode or direct Project Room Email Delivery handoffs.

#### Lowes Order Email Routing

Use this branch when an authorized sender requests Lowe's product research, cart preparation, cart changes, or order review, including messages containing Lowe's item numbers. Preserve the Outlook reference and extracted order details, record missing quantities or other ambiguities without guessing, and send a direct handoff to Lowes Order task `019f5845-fb96-7370-baf2-b8f00fddffae`.

Lowes Order owns browser and cart work. When the cart is filled to the extent safely possible, it confirms completion to the sender and separately asks Wes to review and approve the cart on the Lowe's website. When uncertainties prevent or limit cart preparation, it emails the sender with Wes copied. Every follow-up subject uses `[Lowes Order]`, and the body states that future source emails should identify Lowes Order mode in the subject. Checkout, payment, substitutions, paid services, and account changes remain gated by Wes's specific approval.

#### Gracious Millionaire Email Routing

Use this branch when Email Routing sees an email with a subject containing `gracious millionaire`, or an email that otherwise clearly belongs to the Gracious Millionaire book/project-room workflow.

This mode routes the email to Gracious Millionaire by preserving the Outlook message id or web link, sender, recipients, subject, received time, short summary, and any external Teams source path in Email Monitor memory and the Gracious Millionaire handoff. It updates Gracious Millionaire intake/source records when required by that room's rules and sends a direct follow-up message to the existing Gracious Millionaire project-room thread.

This mode does not draft, edit, or send the requested Gracious Millionaire book response from the Email Monitor task unless Wes explicitly asks for processing here. It also does not attach mailbox checking to the Gracious Millionaire heartbeat or create a new Gracious Millionaire chat.

#### Brynda Suit Email Routing

Use this branch when Email Routing sees an email from Wes or Jenny with a subject containing `brynda suit`, or an email that otherwise clearly belongs to the Brynda Suit workflow.

This mode routes the email to Brynda Suit by preserving the Outlook message id or web link, sender, recipients, subject, received time, short summary, and any external Teams source path in Email Monitor memory and the Brynda Suit handoff. It updates the Brynda Suit source inventory with references and external paths when the routed email becomes part of the durable source set, and sends a direct follow-up message to the existing Brynda Suit task with the instruction to wake up and respond.

This mode does not draft, edit, or send the requested Brynda Suit response from the Email Monitor task unless Wes explicitly asks for processing here. It also does not create a new Brynda Suit task.

#### Manager Routing

Use this branch when Email Routing sees an email whose subject contains `Manager Task`, matched case-insensitively, including the established bracketed Manager subject format and normal reply or forward prefixes.

This mode preserves the Outlook message id or web link, sender, summary, and attachment metadata in Email Monitor memory. Safely retrievable attachments are saved outside Git in Manager's Teams source/reference or working location according to Manager rules. It sends a direct follow-up message to the existing Manager task `019f8274-5b7e-7170-a051-f7944954de82`; the handoff includes the Outlook reference, external attachment paths or blocker, sender, a short summary, and an instruction to process the email under Manager Tasks mode.

Email Monitor does not create or edit Manager tasks, infer task status changes, or perform the requested business action. Manager owns sender and task-id validation, task classification, status interpretation, authorization checks, and task-register updates.

### Route Vendor Invoice

Use this branch for invoice, bill, receipt, statement, pay-application, payment-request, project-cost, and exact-subject `Time Card` sources that belong to Invoice Entry.

This mode creates the durable central message before task notification, verifies the destination is idle before attempting a wake-up message, requires the exact dispatch ID in a durable `Accepted` receipt, retries the same immutable message only after reconciliation, and emails Wes once through verified OfficeAssist delivery if acknowledgment is missing before the routing run ends. See `working\dispatch-queue-spec.md` and `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1`.

Send Invoice Entry one concise handoff with these fields in order: exact `mailbox`, `outlook_message_id`, `outlook_link`, attachment paths or exact blocker, short factual `summary`, `requested_operation`, and `unique_warning`. Use `none` when there is no attachment or source-specific warning. Apply the same format to Time Card, approval, correction, and paid-receipt routing.

Do not put Invoice Entry's standing rules, the full email body, quoted thread text, or prior processing history in the task message. Preserve detailed sender/recipient metadata, timestamps, attachment metadata, routing evidence, duplicate notes, and reconciliation history in Email Monitor compact state and `working\routing-action-log.md` as appropriate.

The durable queue record is authoritative; a task message is a best-effort wake-up signal. Do not treat a completed tool call as acceptance, and do not lose or duplicate a dispatch when the destination is busy.

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

For an accepted connector send, use `OfficeAssist@BuyYourHomeLLC.com` unless the package contains specific Wes authorization for another sender. Prefer the Outlook connector, enable Sent Items saving, pass structured recipient objects, preserve the exact plain-text subject/body, and pass attachments as a list of absolute paths. Never omit a required attachment. Make only the documented schema-correct retry when the first connector error clearly explains it.

On this computer, OfficeAssist has no local Outlook mailbox. If the connector is definitively unavailable before sending and Email Monitor can prove that no send occurred, use `WesWill@BuyYourHomeLLC.com` as the temporary local Outlook fallback. Preserve the authorized recipients, subject, body, and attachments; sign as Jean Wright / Office Assistant; disclose that Wes's mailbox was used because OfficeAssist was unavailable; and verify the result in WesWill Sent Items. If connector delivery is ambiguous or verification failed after a send attempt, do not use the fallback because duplicate delivery is possible. Do not use `Wes@myBrowning.net`.

If required attachments exceed connector limits or otherwise cannot be uploaded, Email Monitor must preserve the delivery request as unresolved unless `email-delivery` can use a verified OfficeAssist-capable alternate path. It must not substitute SharePoint links, compressed/reduced files, split packages, another sender, or a no-attachment email unless the requesting workflow or Wes explicitly authorizes that alternate package.

After sending, verify the OfficeAssist Sent Items copy for sender, To, CC, BCC, subject, and attachment presence. On success, immediately return only the compact delivery result: request ID, `Sent and Verified`, sent message ID, sent timestamp, verified To/CC/BCC recipients, subject, and attachment verification. Preserve sender verification, connector retries, and other detailed evidence in Email Monitor's own records unless a mismatch or blocker must be reported. On send or verification failure, preserve the unresolved request, report the blocker to Wes immediately, and return a compact failure result with the request ID, unresolved status, failure stage, exact blocker, whether a send might have occurred, and required decision.

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

- 2026-08-14: Made Route Vendor Invoice a formal mode and added a durable runtime dispatch queue, payload hashing, idempotent receipts, explicit lifecycle states, idle-only bounded notification attempts, independent acceptance verification, and verified OfficeAssist escalation for missing acknowledgments.

- 2026-08-01: Standardized concise Invoice Entry routing handoffs for invoices, Time Cards, approvals, corrections, and paid receipts; moved detailed evidence to Email Monitor records; required reconciliation before any slow-response resend; and reduced successful delivery callbacks to verified result fields only.

- 2026-08-01: Kept one stable Email Monitor chat, converted active memory to compact current state, added a single seven-day Teams rolling log at `Office Admin/Codex Logs/Email Monitor`, limited visible chat activity to meaningful events, and authorized `WesWill@BuyYourHomeLLC.com` as the temporary sender only when the OfficeAssist connector is definitively unavailable before send.

- 2026-07-30: Authorized Josh Kennedy for safe OfficeAssist instructions and added Lowes Order Email Routing with sender confirmation, Wes cart-approval notification, uncertainty questions, `[Lowes Order]` subject guidance, and continued checkout/payment safeguards.

- 2026-07-24: Added the large-required-attachment delivery rule: unresolved required attachments may not be silently replaced with links, reduced files, split packages, another sender, or no-attachment emails without explicit authorization.

- 2026-07-24: Changed Email Routing source retention so routed emails and attachments are preserved by Outlook reference and external Teams paths instead of routine Git `sources\email` files.

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

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; the PR must accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.

## PR Messaging

PR Messaging: Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md`. The central message record is authoritative; task messages are wake-up signals, not delivery proof.
