# Agents And Automations Registry

This is the human-readable control panel for agent-like work in the Buy Your Home admin system.

Codex does not currently show every role below in one unified "Agents" list. Some are scheduled automations, some are skills, some are durable wiki rules, and some are project rooms. This registry maps the practical role name to where it is actually defined.

Use [[Agent Unit Standard]] for the standard package behind an agent-like operating unit: Project Room, skill, registry entry, chat/thread when any, and automation only when needed. Use [[Project Room Chat Startup Rule]] when creating or resuming Project Room chats.

## Summary

| Name | Type | Status | Schedule | Primary Definition |
|---|---|---|---|---|
| Jean Wright / Office Assistant | Wiki-managed skill plus project room plus assistant profile and operating role | Active | On demand and through related automations | `skills\jean-wright\SKILL.md`; `Project Rooms\Jean Wright\README.md`; `C:\Codex\Office Assistant Profile.md`; `AGENTS.md` |
| REI Text Message Watcher | Heartbeat automation | Active | Every 15 minutes during 8:00 AM-9:00 PM Eastern; adaptive 1-minute checks during activity | `C:\Users\wesbr\.codex\automations\morning-weswill-email-summary\automation.toml` |
| OfficeAssist Instruction Inbox Monitor | Behavior inside Email Monitor heartbeat | Active | Runs every day; starts at 7:45 AM Eastern, then every 15 minutes through 11:00 PM Eastern; checks email and takes defined actions | `AGENTS.md`; `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml` |
| Gracious Millionaire Project Room Heartbeat | Project-room heartbeat automation | Active | Every 15 minutes from 8:00 AM-11:45 PM Eastern; project-room Markdown intake processing only | `Project Rooms\Gracious Millionaire\README.md`; `Project Rooms\Gracious Millionaire\working\intake-heartbeat-rules.md`; `C:\Users\wesbr\.codex\automations\gracious-millionaire-project-room-heartbeat\automation.toml` |
| Email Monitor | Wiki-managed skill plus heartbeat automation, project room, and direct Email Delivery endpoint | Active | Heartbeat runs every day from 7:45 AM through 11:00 PM Eastern; direct authorized Project Room delivery handoffs trigger immediately and do not wait for the heartbeat | `skills\email-monitor\SKILL.md`; `Project Rooms\Email Monitor\README.md`; `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml` |
| Email Delivery | Wiki-managed support skill | Active | Called by email-capable Admin workflows | `skills\email-delivery\SKILL.md` |
| Doc Scan | Wiki-managed skill plus heartbeat automation plus project room | Active | Every 15 minutes on weekdays from 10:00 AM through 4:45 PM Eastern | `skills\doc-scan\SKILL.md`; `Project Rooms\Doc Scan\README.md`; `C:\Users\wesbr\.codex\skills\doc-scan\SKILL.md`; app automation id `doc-scan` |
| Codex Skill Source Control | Wiki-managed skill system | Active | On demand after skill changes or wiki pulls | `Codex Skill Source Rule.md`; `tools\sync-codex-skills.ps1`; `skills\` |
| Admin Request Wrapup | Wiki-managed skill | Active | At the end of Admin wiki requests | `skills\admin-request-wrapup\SKILL.md`; `AGENTS.md` |
| Create PR | Wiki-managed skill plus project room plus dedicated chat | Active | On demand | `skills\create-pr\SKILL.md`; `Project Rooms\Create PR\README.md` |
| Brynda Suit | Wiki-managed skill plus project room plus dedicated chat | Draft | On demand | `skills\brynda-suit\SKILL.md`; `Project Rooms\Brynda Suit\README.md` |
| LD Evans | Wiki-managed skill plus project room plus dedicated chat | Draft | On demand | `skills\ld-evans\SKILL.md`; `Project Rooms\LD Evans\README.md` |
| Jennys Drawings | Wiki-managed skill plus project room plus dedicated chat | Draft | On demand | `skills\jennys-drawings\SKILL.md`; `Project Rooms\Jennys Drawings\README.md` |
| Lowes Order | Wiki-managed skill plus project room plus dedicated chat | Draft | On demand | `skills\lowes-order\SKILL.md`; `Project Rooms\Lowes Order\README.md` |
| Manager | Wiki-managed skill plus project room plus dedicated chat | Draft | On demand | `skills\manager\SKILL.md`; `Project Rooms\Manager\README.md` |
| Codex Environment Deployment | Wiki-managed skill plus project room plus dedicated chat | Draft | On demand | `skills\codex-environment-deployment\SKILL.md`; `Project Rooms\Codex Environment Deployment\README.md` |
| SOPs | Wiki-managed skill plus project room | Active | On demand | `skills\sops\SKILL.md`; `Project Rooms\SOPs\README.md`; `Project Rooms\SOPs\outputs\SOP Index.md` |
| Credit Worthiness Evaluator | Wiki-managed skill plus project room | Active | On demand | `skills\credit-worthiness-evaluator\SKILL.md`; `Project Rooms\Credit Worthiness Evaluator\README.md` |
| Contract for Deed | Wiki-managed skill plus project room | Active | On demand | `skills\contract-for-deed\SKILL.md`; `Project Rooms\Contract for Deed\README.md` |
| Operating Agreement | Wiki-managed skill plus project room | Draft | On demand | `skills\operating-agreement\SKILL.md`; `Project Rooms\Operating Agreements\README.md` |
| Amortization | Wiki-managed support skill plus project room | Draft | Called by Contract for Deed or other seller-financing workflows | `skills\amortization\SKILL.md`; `Project Rooms\Amortization\README.md` |
| CMA Report | Wiki-managed skill | Active | On demand when a CMA or property report is created | `skills\cma-report\SKILL.md` |
| Grocery List Handler | Wiki rule and data workflow | Active | On demand, including approved Boss/Jenny text instructions | `operations/grocery-list/` |
| AI Project Room Workflow | Wiki workflow | Active | On demand before complex multi-source work | `Project Room Workflow.md` |
| AIOS | Wiki-managed skill plus project room | Active/planning | On demand | `skills\aios\SKILL.md`; `Project Rooms\AIOS\README.md`; `AIOS\start-here.md` |
| Entity Relationship | Wiki-managed skill plus project room | Active/planning | On demand | `skills\entity-relationship\SKILL.md`; `Project Rooms\Entity Relationship\README.md` |
| Gracious Millionaire | Wiki-managed skill plus project room plus heartbeat automation | Active | Project-room heartbeat every 15 minutes during active window; on demand otherwise | `skills\gracious-millionaire\SKILL.md`; `Project Rooms\Gracious Millionaire\README.md`; `Project Rooms\Gracious Millionaire\working\intake-heartbeat-rules.md`; automation id `gracious-millionaire-project-room-heartbeat` |
| Template to Project | Wiki-managed skill plus project room | Active | On demand | `skills\template-to-project\SKILL.md`; `Project Rooms\Template to Project\README.md`; `Project Rooms\Template to Project\Project Spreadsheet Expense Placement Rules.md` |
| Invoice Entry | Wiki-managed skill plus project room plus backup heartbeat automation plus dedicated chat | Active | Direct message handoff is primary; backup heartbeat checks hourly for structured invoice/receipt packets that were not delivered by direct message | `skills\invoice-entry\SKILL.md`; `Project Rooms\Invoice Entry\README.md`; app automation id `invoice-entry-to-projects-backup-heartbeat` |
| Project Management Spreadsheet Rewrite | Planning/history project room now covered by Template to Project | Active/planning | On demand | `skills\template-to-project\SKILL.md`; `Project Rooms\Project Management Spreadsheet Rewrite\README.md` |
| Property Trade Evaluation | Wiki-managed skill plus project room | Active | On demand | `skills\property-trade-evaluation\SKILL.md`; `Project Rooms\Property Trade Evaluation\README.md` |
| Voices | Wiki-managed skill plus project room | Planning | On demand | `skills\voices\SKILL.md`; `Project Rooms\Voices\README.md` |
| New Project | Wiki-managed skill plus project room | Draft | On demand | `skills\new-project\SKILL.md`; `Project Rooms\New Project\README.md` |
| Confidential | Wiki-managed skill plus project room plus dedicated chat | Draft | On demand | `skills\confidential\SKILL.md`; `Project Rooms\Confidential\README.md` |
| REI BlackBook | Wiki-managed skill plus project room plus dedicated chat | Draft | On demand | `skills\rei-blackbook\SKILL.md`; `Project Rooms\REI BlackBook\README.md`; thread id `019f4691-5466-7f72-9683-ab5d3b750c25` |
| GM Mode Site Iteration | GM Mode heartbeat automation plus REI BlackBook project room | Active | Every 30 minutes; each acquired run chains coherent book-site iterations for approximately 45-90 minutes, then emails Wes the remaining backlog from OfficeAssist | `skills\rei-blackbook\SKILL.md`; `Project Rooms\REI BlackBook\README.md`; automation id `gm-mode-site-iteration` |
| Investigate Computer | Wiki-managed skill plus project room plus heartbeat automation | Active | Daily at 6:00 AM Eastern; email Wes only when an issue is detected | `skills\investigate-computer\SKILL.md`; `Project Rooms\Investigate Computer\README.md`; app automation id `investigate-computer-daily-check` |
| Jenny Email Summary | Behavior inside Email Monitor heartbeat | Active | Runs once daily at/after 8:00 AM Eastern with the Email Monitor heartbeat; emails Jenny from OfficeAssist and verifies Sent Items | `skills\email-monitor\SKILL.md`; `Email Monitor` prompt notes |

## Jean Wright / Office Assistant

Type: assistant profile and operating role.

Status: active.

Purpose:

- Act as the office assistant for Buy Your Home, LLC.
- Handle safe administrative tasks, email drafting/sending under approved rules, grocery list updates, document workflow coordination, and office process support.

Defined in:

- `C:\Codex\Wiki Files\skills\jean-wright\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Jean Wright\README.md`
- `C:\Codex\Office Assistant Profile.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- Related workflow pages in this wiki.

Current chat:

- Current Admin Operations / Jean Wright chat.
- Do not create another Jean Wright chat unless Wes explicitly asks.

Important rules:

- The Admin Operations / Jean Wright chat functions as Jean Wright / Office Assistant unless Wes routes work to a specialized Project Room.
- Use `OfficeAssist@BuyYourHomeLLC.com` when sending as Jean or Office Assistant unless Wes explicitly names another sender for that specific message.
- Sending to `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com` is pre-approved under the Office Assistant Profile.
- Sending to anyone else requires explicit approval before sending unless a specialized workflow grants specific authority.
- When Wes asks Jean to write a draft email, do not leave the proposed message in Outlook Drafts. Send the proposed draft to Wes from OfficeAssist with a `DRAFT:` subject prefix when the send path can be verified.
- Use the Outlook Email connector as the preferred mailbox path when documented and available.
- Route specialized work to the matching Project Room and skill when one exists.
- Jean Wright work uses `main`; do not create a new branch unless Wes explicitly asks.
- Jean Wright supports `Start PR`, `Commit`, and `Push` modes as defined in `Project Rooms\Jean Wright\README.md` and `skills\jean-wright\SKILL.md`.
- Do not delete emails, change mailbox settings, spend money, place orders, or send external texts without explicit approval.

Where to inspect:

- Open `Project Rooms\Jean Wright\README.md` for the Jean Wright PR.
- Open `skills\jean-wright\SKILL.md` for the Jean Wright workflow skill.
- Open `AGENTS.md` for durable operating rules.
- Open `C:\Codex\Office Assistant Profile.md` for the global persona/profile.

## REI Text Message Watcher

Type: planned heartbeat automation.

Status: pending activation.

Automation id:

- `morning-weswill-email-summary`

Note: the id is misleading. The current name and purpose are REI text watching.

Schedule:

- Active only between 8:00 AM and 9:00 PM Eastern.
- Default active-hours interval is every 15 minutes.
- Adaptive rule: switch to every 1 minute when new relevant Boss/Jenny text activity is found or an action is taken.
- Return to every 15 minutes after 5 consecutive quiet minutes.

Purpose:

- Check REI BlackBook / Profit Dial texts for Jean's assigned number `(919) 899-2310`.
- Treat internal texts from Boss `(213) 293-7539` and Mrs Boss/Jenny `(703) 346-1256` as approved instructions for safe in-scope tasks.
- Reply in REI with concise acknowledgement or action confirmation when safe.
- Notify Wes only for new messages, completed actions, blockers, or decisions needed.

Defined in:

- `C:\Users\wesbr\.codex\automations\morning-weswill-email-summary\automation.toml`

Tools/services used:

- Codex heartbeat automation.
- Browser automation against REI BlackBook / Profit Dial.

Current notification behavior:

- Quiet runs use `DONT_NOTIFY`.
- Non-Boss/Jenny texts are not answered; notify Wes if action is needed.

## OfficeAssist Instruction Inbox Monitor

Type: behavior inside the `officeassist-morning-email-summary-and-instruction-monitor` heartbeat automation.

Status: active as behavior inside the Email Monitor heartbeat.

Automation id:

- `officeassist-morning-email-summary-and-instruction-monitor`

Schedule:

- Starts at 7:45 AM Eastern.
- Then runs every 15 minutes from 8:00 AM through 11:00 PM Eastern.

Purpose:

- Monitor `OfficeAssist@BuyYourHomeLLC.com` for instruction emails from Wes or Jenny.
- Treat emails from `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com` as OfficeAssist instruction intake.
- Carry out safe, in-scope admin actions when the email instruction and applicable workflow rules allow it.
- Route Gracious Millionaire email into the Gracious Millionaire project room as Markdown source files, update the intake/source ledger when required, and send a direct follow-up message to the Gracious Millionaire project-room thread with the routed source path and short summary. Do not process the manuscript from the OfficeAssist monitor thread.
- Route Brynda Suit email into the Brynda Suit project room as Markdown source files, update the source inventory when needed, and send a direct follow-up message to the Brynda Suit task with the routed source path, short summary, and instruction to wake up and respond to the email. Do not process the Brynda Suit response from the OfficeAssist monitor thread.
- Route `GM Site` / REI BlackBook website instruction emails into the REI BlackBook project room as Markdown source files, update the source inventory when needed, and send a direct follow-up message to the REI Blackbook project-room thread with the routed source path, short summary, and instruction to process the website request. Do not process the website request from the OfficeAssist monitor thread.
- Use `Route Vendor Invoice` mode to route contractor/vendor invoice emails into the Invoice Entry project room as Markdown source files, save available invoice attachments when safely retrievable, update the source inventory or intake ledger when needed, and send a direct follow-up message to the Invoice Entry task with the routed source path, attachment paths or blocker, vendor/project summary, and instruction to process the invoice under Invoice Entry rules. Do not approve, pay, contact vendors, make live spreadsheet entries, or move files into Teams from the OfficeAssist monitor thread.
- Report blockers, ambiguous authority, mailbox failures, or decisions needed in the attached status thread.
- Avoid repeated processing by tracking handled message ids in local monitor memory.
- Keep routine no-new-instruction checks quiet with `DONT_NOTIFY`.

Special routing:

- If an instruction email has a subject containing `gracious millionaire`, or otherwise clearly belongs to the Gracious Millionaire book/project-room workflow, route it into `Project Rooms\Gracious Millionaire\` as book source material from the OfficeAssist monitor.
- Preserve each routed Gracious Millionaire email as its own Markdown file under `Project Rooms\Gracious Millionaire\sources\email\`, including available sender, recipient, timestamp, subject, message id or web link, and body text.
- Update `Project Rooms\Gracious Millionaire\working\officeassist-intake-log.md` and the durable source inventory when required by the project-room rules.
- Send a direct follow-up message to the existing Gracious Millionaire project-room thread with the routed source path and a short summary. Direct message handoff is the primary trigger; the project-room heartbeat is only a backup processor for routed files already in the project room.
- Use plain names for this workflow. Do not call it `Project LumenScale`; refer to it as the Gracious Millionaire project-room process or Gracious Millionaire project-room heartbeat.
- Current Gracious Millionaire project-room thread id for manual project-room work: `019eb9b0-6780-7fb3-a278-29a18d17998c`.
- Do not attach an OfficeAssist mailbox-monitoring heartbeat to the Gracious Millionaire thread; the separate `gracious-millionaire-project-room-heartbeat` owns project-room Markdown/source processing in that thread and must not check email.
- Do not create a new chat for Gracious Millionaire routing unless Wes explicitly asks for a new chat.
- Do not draft, edit, or send the requested Gracious Millionaire book response from the OfficeAssist monitor thread unless Wes explicitly asks for processing there; the default action is source routing plus direct handoff only.
- If an instruction email has a subject containing `brynda suit`, or otherwise clearly belongs to the Brynda Suit workflow, route it into `Project Rooms\Brynda Suit\` as source material from the OfficeAssist monitor.
- Preserve each routed Brynda Suit email as its own Markdown file under `Project Rooms\Brynda Suit\sources\email\`, including available sender, recipient, timestamp, subject, message id or web link, and body text.
- Update `Project Rooms\Brynda Suit\working\source-inventory.md` when the routed email becomes part of the durable source set.
- Send a direct follow-up message to the existing Brynda Suit task with the routed source path, a short summary, and the instruction to wake up and respond to the email.
- Current Brynda Suit task id: `019f61c3-d4c0-7a52-a5a0-e4066ea9b303`.
- Do not create a new Brynda Suit task for routing unless Wes explicitly asks for one.
- Do not draft, edit, or send the requested Brynda Suit response from the OfficeAssist monitor thread unless Wes explicitly asks for processing there; the default action is source routing plus direct handoff only.
- If an instruction email has a subject containing `GM Site`, or otherwise clearly belongs to the REI BlackBook WebTools Sites / Gracious Millionaire website workflow, route it into `Project Rooms\REI BlackBook\` as source material from the OfficeAssist monitor.
- Preserve each routed REI BlackBook website email as its own Markdown file under `Project Rooms\REI BlackBook\sources\email\`, including available sender, recipient, timestamp, subject, message id or web link, and body text.
- Update `Project Rooms\REI BlackBook\working\source-inventory.md` when the routed email becomes part of the durable source set.
- Send a direct follow-up message to the existing REI Blackbook project-room thread with the routed source path, a short summary, and the instruction to process the website request.
- Current REI Blackbook project-room thread id: `019f4691-5466-7f72-9683-ab5d3b750c25`.
- Do not create a new REI Blackbook chat for routing unless Wes explicitly asks for one.
- Do not draft, edit, publish, or send the requested REI BlackBook website response from the OfficeAssist monitor thread unless Wes explicitly asks for processing there; the default action is source routing plus direct handoff only.
- In `Route Vendor Invoice` mode, if a contractor, subcontractor, vendor, supplier, utility, service-provider, or project-cost email appears to contain or request processing of an invoice, bill, receipt, statement, pay application, draw request, payment request, or other invoice-entry source, route it into `Project Rooms\Invoice Entry\` as source material from the OfficeAssist monitor.
- Route an email when the sender display name is `Josh Kennedy` and the subject is exactly `Time Card`, matched case-insensitively, even when the message has no invoice keyword or attachment.
- Preserve each routed Invoice Entry email as its own Markdown file under `Project Rooms\Invoice Entry\sources\email\`, including available sender, recipient, timestamp, subject, message id or web link, body text, and available attachment names/metadata.
- Save invoice attachments beside the routed email source when the connector or local mailbox path can safely retrieve them. If an apparent invoice attachment cannot be retrieved, preserve the Outlook message link and report the blocker in the Invoice Entry handoff.
- Update `Project Rooms\Invoice Entry\working\source-inventory.md` or the current Invoice Entry intake ledger when the routed source becomes part of the durable source set.
- Send a direct follow-up message to the existing Invoice Entry task with the routed source path, attachment paths or blocker, a short vendor/project summary, and the instruction to process the invoice under Invoice Entry rules.
- Current Invoice Entry task id: `019f3d56-b310-75c0-b084-616bfc1e9f59`.
- Do not create a new Invoice Entry task for routing unless Wes explicitly asks for one.
- Do not approve invoices, pay invoices, contact vendors, make live project-spreadsheet entries, or move invoice files into Teams from the OfficeAssist monitor thread unless Wes explicitly asks for processing there and the Invoice Entry rules allow it; the default action is source routing plus direct handoff only.

Defined in:

- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` for local message-id memory.

Activation note:

- The former `gracious-millionaire-officeassist-email-intake` heartbeat was deleted on 2026-06-18 at Wes's request. All OfficeAssist email monitoring now belongs to the Email Monitor heartbeat.

Tools/services used:

- Outlook Email connector for OfficeAssist mailbox reads.
- Admin wiki workflow rules for action safety.

Important limitations:

- Do not use the instruction inbox monitor to resume Jenny's morning email summary unless Wes explicitly says to resume it.
- Do not execute high-impact actions from email unless the email clearly authorizes the specific action and the applicable workflow rules allow it.
- Do not substitute another mailbox if OfficeAssist mailbox access fails.

## Gracious Millionaire Project Room Heartbeat

Type: project-room heartbeat automation.

Status: active.

Automation id:

- `gracious-millionaire-project-room-heartbeat`

Schedule:

- Every 15 minutes from 8:00 AM through 11:45 PM Eastern.

Purpose:

- Inspect `Project Rooms\Gracious Millionaire\` for routed Markdown/source files and intake-log entries dropped by OfficeAssist or another approved process when direct message handoff was missed or needs backup processing.
- Process newly routed Gracious Millionaire writing instructions into project-room working notes, chapter drafts, manuscript revisions, and ledger updates.
- This process works from emails that have already been received and routed as Markdown files into the Gracious Millionaire project room; it is not a separate branded role and should not be called `Project LumenScale`.
- Keep routine no-new-source checks silent with no user-visible notification.

Defined in:

- `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\README.md`
- `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\intake-heartbeat-rules.md`
- `C:\Users\wesbr\.codex\automations\gracious-millionaire-project-room-heartbeat\automation.toml`

Important limitations:

- This heartbeat must not read Outlook, OfficeAssist mail, Wes mail, Jenny mail, or any mailbox directly.
- OfficeAssist remains responsible for email monitoring and source routing.
- Do not create new chats, delete source files, push Git changes, or take unrelated external actions from this heartbeat.
- After a significant manuscript change, the Jenny clickable chapter review packet is the one allowed email exception: send it through the OfficeAssist email-delivery workflow from `OfficeAssist@BuyYourHomeLLC.com` to `Jenny@BuyYourHomeLLC.com`, copy `WesWill@BuyYourHomeLLC.com`, and verify the sent copy.
- If a routed source requests email sending or a major manuscript direction decision, mark the item blocked or deferred and notify Wes in the Gracious Millionaire thread.

Tools/services used:

- Local project-room Markdown files and ledgers.
- Admin wiki project-room workflow rules.
- Git for scoped local commits when durable project-room changes are made.

## Email Monitor

Type: wiki-managed skill plus heartbeat automation and direct Email Delivery endpoint.

Status: active for Wes, Jenny, and Josh.

Automation id:

- `officeassist-morning-email-summary-and-instruction-monitor`

Schedule:

- Runs every day.
- Starts at 7:45 AM Eastern.
- Then runs every 15 minutes from 8:00 AM through 11:00 PM Eastern.
- Runs in the dedicated `Email Monitor` Codex thread instead of creating a new standalone run chat each morning.

Purpose:

- Recursively review the full `WesWill@BuyYourHomeLLC.com` Outlook mailbox, including rule-routed subfolders.
- Recursively review the full `Jenny@BuyYourHomeLLC.com` Outlook mailbox, including rule-routed subfolders.
- Recursively review the full `IRAManager@SellYourHomeRaleigh.com` Outlook mailbox, including rule-routed subfolders.
- Summarize unread or newly received financial, legal, property, vendor/admin, time-sensitive, or action-oriented messages.
- Monitor the OfficeAssist mailbox for instruction emails and take defined actions when the email instruction and safety rules allow it.
- Receive complete, authorized outbound-email delivery packages directly from other Project Rooms, including Invoice Entry, and execute them immediately through the shared Email Delivery skill without mailbox scanning or heartbeat delay.
- Route Gracious Millionaire and Brynda Suit instruction emails into their owning project rooms as source material and hand them off to their existing threads/tasks.
- Send Wes a concise priority summary from `OfficeAssist@BuyYourHomeLLC.com`.
- Email Jenny's concise priority summary to `Jenny@BuyYourHomeLLC.com` from `OfficeAssist@BuyYourHomeLLC.com` under the current global profile, and verify the sent copy in OfficeAssist Sent Items.
- Email Josh's concise priority summary to `IRAManager@SellYourHomeRaleigh.com` from `OfficeAssist@BuyYourHomeLLC.com`, copy `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com`, and verify the sent copy in OfficeAssist Sent Items.
- Include a Manager Task mode section in Josh's summary by reading `Project Rooms\Manager\working\task-register.md`; group by Manager status and order within each group by `Critical`, `High`, `Normal`, then `Low`. Email Monitor must not edit the Manager task register.
- Include a short token-usage section for yesterday and the current week to date when reliable token totals are available; if not available, say so rather than estimating.
- Jean is responsible for confirming the summary is actually delivered. If the summary cannot be sent, if sender verification fails, or if delivery cannot be confirmed, do not stay quiet. Notify Wes immediately in the thread and, when a reliable text/SMS path is available, text Wes that the email summary failed.
- Resume one dedicated Codex status chat for failures, blockers, and notable summary-task visibility instead of creating separate standalone run chats.
- Maintain a workflow-specific Health Check mode with plain-language option discovery, status, enable/disable, configuration, diagnostic testing, and visible test alerts through `Project Rooms\Email Monitor\tools\Manage-CodexWorkflowHealth.ps1`.

Defined in:

- `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Email Monitor\README.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`
- Email safety rules in `AGENTS.md`.

Important limitations:

- Jenny's summary is active as of 2026-06-29 because Wes explicitly asked to resume it and the Outlook Email connector can read `Jenny@BuyYourHomeLLC.com`.
- Josh's summary is active as of 2026-07-21 because Wes explicitly requested it and delegated Outlook connector access to `IRAManager@SellYourHomeRaleigh.com` was verified.
- Do not substitute another mailbox for Jenny.
- Keep the automation attached to one dedicated status thread via `target_thread_id` so failure notifications and follow-up stay in one chat.
- Current status thread id: `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`.

Tools/services used:

- Shared send-step skill: `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`
- Outlook/email connector as the preferred production path for Wes mailbox reads and OfficeAssist send verification.
- Local Outlook profile as fallback only when the connector cannot perform the needed send or verification step.
- OfficeAssist mailbox for sending.
- Live Codex session token helper: `C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1`
- Token budget config for optional weekly remaining-percent reporting: `C:\Codex\Wiki Files\tools\codex-token-summary.config.json`
- Text/SMS fallback for failed email summary delivery, when available.

Persistent send-verification rule:

- As confirmed from the successful 2026-06-09 run, a connector-verified OfficeAssist Drafts item followed by a connector-verified OfficeAssist Sent Items record is an acceptable production send path even when `OfficeAssist@BuyYourHomeLLC.com` is not mounted as a local Outlook mailbox root on that machine.

Workflow boundary:

- The morning-summary automation keeps responsibility for mailbox scanning, cutoff selection, message prioritization, summary drafting, and attachment decisions.
- The shared `email-delivery` skill handles the send step only: Outlook connector preference, sender safety, attachment input shape, Sent Items verification, local Outlook fallback, and failure reporting.
- For direct Project Room handoffs, the requester owns purpose, authorization, sender request, To/CC/BCC, subject, exact plain-text body, attachments and required status, and workflow restrictions. Email Monitor owns package completeness checks, request-ID duplicate prevention, durable delivery state, delivery coordination, callback reporting, and escalation to Wes.
- Defined mode: Email Summary scans Boss's, Jenny's, and Josh's Outlook mailboxes once daily, drafts priority summaries with usage totals, adds the read-only Manager Task mode list to Josh's summary, hands delivery to `email-delivery`, verifies OfficeAssist Sent Items, and updates summary state.
- Defined mode: Health Check writes heartbeat lifecycle state, runs an independent machine-local Windows watchdog, and lets Wes request options, status, enable/disable, interval or threshold changes, active-window changes, diagnostics, and test alerts in plain language. Configuration changes require healthy state by default, and machine reassignment requires destination verification.
- Defined mode: Gracious Millionaire Email Routing routes Gracious Millionaire emails into the Gracious Millionaire project room as Markdown source files, records the Outlook message id in Email Monitor memory, and sends a direct project-room thread handoff without drafting the book response in this Email Monitor thread.
- Defined mode: Brynda Suit Email Routing routes Brynda Suit emails into the Brynda Suit project room as Markdown source files, records the Outlook message id in Email Monitor memory, and sends a direct task handoff without drafting the Brynda Suit response in this Email Monitor thread.
- Defined mode: Web Site Email Routing routes `GM Site` / REI BlackBook website emails into the REI BlackBook project room as Markdown source files, records the Outlook message id in Email Monitor memory, and sends a direct REI Blackbook thread handoff without editing or publishing the website in this Email Monitor thread.
- Defined mode: Email Delivery handles authorized Email Monitor sends and immediate direct handoffs from other Project Rooms through the shared `email-delivery` skill. Each direct package must include a unique request ID, origin Project Room and task/thread ID, authorization basis, sender, To/CC/BCC, subject, exact plain-text body, absolute attachment paths, attachment-required status, workflow restrictions, and callback task/thread ID. Email Monitor rejects incomplete packages, checks durable request records before sending, prevents duplicate sends, verifies sender/recipients/subject/attachments in OfficeAssist Sent Items, and returns a fixed success or unresolved-failure result to the callback task.
- Invoice Entry may submit properly authorized delivery packages for vendor invoice-accuracy verification, Time Card invoice verification, Wes approval/payment review, or post-Wes-approval status notices. Route Vendor Invoice's no-vendor-contact rule applies during intake routing and does not override a later delivery specifically authorized under Invoice Entry's saved rules.
- Development work, source inventory, open questions, and review-ready handoffs for this workflow live in `C:\Codex\Wiki Files\Project Rooms\Email Monitor\`.

## Email Delivery

Type: wiki-managed support skill.

Status: active.

Purpose:

- Provide shared OfficeAssist email sender-safety, Outlook connector preference, attachment input handling, sent-item verification, and failure reporting for Admin workflows that send from `OfficeAssist@BuyYourHomeLLC.com`.
- Execute Email Monitor delivery packages received directly from authorized Project Rooms while the requesting workflow retains all message and authorization decisions.
- Keep workflow-specific email content and package rules in the calling workflow.

Defined in:

- `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`

Important rules:

- The calling workflow supplies recipients, subject, body, attachments, and any stricter recipient/package limits.
- Prefer the Outlook Email connector shared/delegated mailbox send action, enable Sent Items saving, use structured recipient objects, and pass attachments as a list of absolute local paths.
- Verify the expected subject, To/CC/BCC recipients, sender, and required attachment presence in OfficeAssist Sent Items; record the sent message id, timestamp, and verification result in the calling workflow's log.
- Make one schema-correct retry only when the first connector error clearly identifies the correction; otherwise stop and report the proposed message details and attachment paths.
- Use local Outlook only as fallback when connector send or verification is unavailable.

## Doc Scan

Type: wiki-managed skill plus heartbeat automation.

Status: active.

Automation id:

- `doc-scan`

Schedule:

- Every 15 minutes on weekdays from 10:00 AM through 4:45 PM Eastern.

Purpose:

- Check scanned PDFs in the Office Admin scan intake folder.
- Use the SharePoint/Teams connector as the default discovery path for scans and destination-folder matching when available, with local synced folders as the scanner drop-zone, processing workspace, archive/log path, and fallback.
- Split combined scans into separate financial/admin documents, including property closing packages and signed operating-agreement packages.
- Name outputs using approved conventions.
- Route mortgage statements, credit card statements, bank statements, invoices, receipts, property closing documents, signed operating agreements, tax forms, and related documents to the correct Teams/SharePoint folder.
- Write logs and archive original scans.
- Resume one dedicated Codex chat for status, follow-up, and automation tuning instead of creating a fresh standalone run thread each time.

Defined in:

- Canonical skill source: `C:\Codex\Wiki Files\skills\doc-scan\SKILL.md`
- Project room: `C:\Codex\Wiki Files\Project Rooms\Doc Scan\README.md`
- Installed local skill copy: `C:\Users\wesbr\.codex\skills\doc-scan\SKILL.md`
- Automation: `C:\Users\wesbr\.codex\automations\doc-scan\automation.toml`
- Wiki support:
  - `Document Scanning SOP.md`
  - `Document Scanning Skill Spec.md`
  - `Document Scanning Folder Map.md`
  - `Invoice and Receipt Processing Notes.md`
  - `Invoice Project List.md`

Important rules:

- Never delete source scans.
- Never overwrite filed PDFs.
- Never pay invoices or contact vendors.
- If routing confidence is low, route to review and log why.
- Keep the automation attached to one dedicated status thread via `target_thread_id` so the user can review run history and adjust behavior in one place.
- Use quiet-run behavior with `DONT_NOTIFY` when no new scans are found so routine empty checks do not create visible chat noise.

## Codex Skill Source Control

Type: wiki-managed skill system.

Status: active.

Purpose:

- Keep Buy Your Home admin skills versioned in the Admin wiki.
- Sync canonical wiki skill folders into each computer's local Codex skills folder.
- Make skill updates portable across computers through the normal GitHub pull and local sync process.

Defined in:

- `C:\Codex\Wiki Files\Codex Skill Source Rule.md`
- `C:\Codex\Wiki Files\tools\sync-codex-skills.ps1`
- `C:\Codex\Wiki Files\skills\`

Important rules:

- Edit canonical skill source under `C:\Codex\Wiki Files\skills`.
- Treat `%USERPROFILE%\.codex\skills` as the installed local copy only.
- After changing a wiki-managed skill, commit locally. Sync or push only when Wes says the skill is ready, asks for it, or the skill change is a finished product.

## Admin Request Wrapup

Type: wiki-managed skill.

Status: active.

Purpose:

- Apply Wes's request wrap-up rules for Admin wiki work.
- Report one total elapsed time for each request.
- Prevent automatic Git pushes until Wes says the work is a finished product, explicitly asks for a push, or the deliverable is clearly final and ready to publish.

Defined in:

- `C:\Codex\Wiki Files\skills\admin-request-wrapup\SKILL.md`
- `C:\Codex\Wiki Files\AGENTS.md`

Important rules:

- Include total request time in final responses.
- Say whether a commit was made and whether it was pushed.
- Do not report per-step timing unless Wes asks.

## Create PR

Type: wiki-managed skill plus project room plus dedicated chat.

Status: active.

Purpose:

- Create and maintain the standard Buy Your Home Project Room package.
- Set up new Project Room folders, README files, working ledgers, matching wiki-managed skills, registry entries, and dedicated startup chats.
- Preserve the canonical Admin wiki location and leave unrelated dirty work alone.

Defined in:

- `C:\Codex\Wiki Files\skills\create-pr\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Create PR\README.md`

Dedicated chat:

- Chat name: `Create PR`
- Thread id: `019f583e-7f14-7ae2-aa24-4e991544e306`

Important rules:

- Use the standard Project Room startup text from `Project Room Chat Startup Rule.md`.
- Create new PR materials on `main` unless Wes explicitly asks for a branch.
- Add `main` working-branch guidance to each new Project Room README.
- Do not create Teams folders, automations, or external deliverables unless Wes explicitly asks.
- Commit only the scoped Project Room, skill, registry, and index files for the room being created.

## Brynda Suit

Type: wiki-managed skill plus project room plus dedicated chat.

Status: draft.

Purpose:

- Organize Brynda Suit source material, missing details, review questions, and outputs.
- Prepare review-ready drafts, summaries, checklists, or handoffs from authoritative source material.
- Keep external actions, email sending, filing, and legal or financial decisions gated behind explicit Wes approval and applicable workflow rules.

Defined in:

- `C:\Codex\Wiki Files\skills\brynda-suit\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\README.md`

Dedicated chat:

- Chat name: `Brynda Suit`
- Thread id: `019f61c3-d4c0-7a52-a5a0-e4066ea9b303`

Important rules:

- Work on `main` unless Wes explicitly asks for a branch.
- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Use the Project Room source inventory before drafting review-ready outputs.
- Do not create Teams folders or automations unless Wes explicitly asks.

## LD Evans

Type: wiki-managed skill plus project room plus dedicated chat.

Status: draft.

Purpose:

- Organize LD Evans source material, missing details, review questions, and outputs.
- Prepare review-ready drafts, summaries, checklists, or handoffs from authoritative source material.
- Keep external actions, email sending, filing, and legal or financial decisions gated behind explicit Wes approval and applicable workflow rules.

Defined in:

- `C:\Codex\Wiki Files\skills\ld-evans\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\LD Evans\README.md`

Dedicated chat:

- Chat name: `LD Evans`
- Thread id: `019f6ffe-d7b7-71f0-87d7-17b8e453f59e`

Important rules:

- Work on `main` unless Wes explicitly asks for a branch.
- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Use the Project Room source inventory before drafting review-ready outputs.
- Do not create Teams folders or automations unless Wes explicitly asks.

## Jennys Drawings

Type: wiki-managed skill plus project room plus dedicated chat.

Status: draft.

Purpose:

- Organize Jennys Drawings source images, notes, missing details, review questions, and outputs.
- Prepare review-ready drafts, summaries, captions, checklists, or handoffs from authoritative source material.
- Keep publication, sharing, sending, and external posting gated behind explicit Wes approval and applicable workflow rules.

Defined in:

- `C:\Codex\Wiki Files\skills\jennys-drawings\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Jennys Drawings\README.md`

Dedicated chat:

- Chat name: `Jennys Drawings`
- Thread id: `019f700e-419a-7280-ba62-c01fe032b5b7`

Important rules:

- Work on `main` unless Wes explicitly asks for a branch.
- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Use the Project Room source inventory before drafting review-ready outputs.
- Do not publish, share, send, or externally post drawings unless Wes explicitly authorizes that specific action.
- Do not create Teams folders or automations unless Wes explicitly asks.

## Lowes Order

Type: wiki-managed skill plus project room plus dedicated chat.

Status: draft.

Purpose:

- Organize Buy Your Home Lowe's order source material, missing details, review checklists, and order handoffs.
- Use Chrome with Wes's existing Lowe's session to add email-requested items to the Lowe's cart for review.
- Prepare order drafts or summaries from authoritative source material.
- Keep purchase submission gated behind Wes's explicit approval for the specific order action.

Defined in:

- `C:\Codex\Wiki Files\skills\lowes-order\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Lowes Order\README.md`

Dedicated chat:

- Chat name: `Lowes Order`
- Thread id: `019f5845-fb96-7370-baf2-b8f00fddffae`

Important rules:

- Do not place purchases, spend money, submit orders, change payment details, or approve substitutions unless Wes explicitly approves the specific order action.
- Filling the cart is allowed from authoritative email instructions; checkout and payment remain approval-gated.
- Use the Project Room source inventory before drafting review-ready order outputs.
- Do not create Teams folders or automations unless Wes explicitly asks.

## Manager

Type: wiki-managed skill plus project room plus dedicated chat.

Status: draft.

Purpose:

- Hold Manager source material, missing details, review questions, and outputs.
- Maintain user-reported Manager attributes for Josh Kennedy and preserve the controlling MoU source once retrieved from the Sell Your Home channel.
- Define the recurring Manager workflow once Wes provides the remaining triggers and expected outputs.
- Prepare review-ready drafts, summaries, checklists, or handoffs from authoritative source material.

Defined in:

- `C:\Codex\Wiki Files\skills\manager\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Manager\README.md`

Dedicated chat:

- Chat name: `Manager`
- Thread id: `019f8274-5b7e-7170-a051-f7944954de82`

Important rules:

- Work on `main` unless Wes explicitly asks for a branch.
- Do not edit another Project Room's files or matching skill unless Wes explicitly authorizes that specific cross-PR edit.
- Use the Project Room source inventory before drafting review-ready outputs.
- Use the Admin wiki Email Delivery workflow used by Email Monitor for any authorized Manager email send.
- Do not send email, external messages, make purchases, change legal/financial documents, or perform live operational actions unless Wes explicitly authorizes the specific action.
- Do not create Teams folders or automations unless Wes explicitly asks.

## Codex Environment Deployment

Type: wiki-managed skill plus project room plus dedicated chat.

Status: draft.

Purpose:

- Inventory the WesStudio Codex/Admin wiki working environment as the baseline.
- Remote into other computers only when Wes authorizes the specific target computer and setup session.
- Install and configure approved apps, runtimes, repository paths, Codex skills, connectors, and verification checks needed to replicate the WesStudio Codex environment.
- Preserve target-computer setup notes, missing prerequisites, blockers, and verification results.

Defined in:

- `C:\Codex\Wiki Files\skills\codex-environment-deployment\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Codex Environment Deployment\README.md`

Dedicated chat:

- Chat name: `Codex Environment Deployment`
- Thread id: `019f84d0-78d4-7013-8c07-42c01f961be1`

Important rules:

- Work on `main` unless Wes explicitly asks for a branch.
- Do not remote into any computer unless Wes authorizes that target computer and setup session.
- Do not store passwords, tokens, recovery codes, license keys, or live secrets in the wiki, Project Room, skill, git history, scripts, or chat handoff notes.
- Do not install paid apps, remote-control tools, VPNs, credential managers, browser extensions, system-level agents, or make security-setting changes unless Wes explicitly approves the exact item.
- Use `C:\Codex\Wiki Files` as the Admin wiki working repo path on target computers; do not treat Teams-synced wiki folders as the working repo.
- Use the Project Room target-computer register and verification outputs before marking a computer ready.

## Credit Worthiness Evaluator

Type: wiki-managed skill plus project room.

Status: active.

Purpose:

- Refresh buyer source documents into the Credit Worthiness Evaluator project room.
- Evaluate tenant-buyer creditworthiness and ability to repay for seller-financed or Contract for Deed transactions.
- Produce/update an Investment Services, LLC formal report and copy that report back into the live buyer source folder.

Defined in:

- `C:\Codex\Wiki Files\skills\credit-worthiness-evaluator\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Credit Worthiness Evaluator\README.md`

Important rules:

- Distinguish gross business deposits from verified borrower-level net income.
- Keep project-room outputs in the project room, and copy the final formal report to the buyer folder where the source files were retrieved.
- Do not push Git changes unless Wes says the work is finished or explicitly asks for a push.

## Contract for Deed

Type: wiki-managed skill plus project room.

Status: active.

Purpose:

- Refresh and regenerate contract-for-deed seller document packages from project spreadsheets.
- Preserve Wes-edited prototypes, refresh values from the `Docs` worksheet, and generate clean drafts or attorney-review packages.
- Current active package is 320 Rose.

Defined in:

- Skill source: `C:\Codex\Wiki Files\skills\contract-for-deed\SKILL.md`
- Project room: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\README.md`

Important rules:

- Use the project room for project-specific prototypes, scripts, staged spreadsheets, outputs, and source history.
- Use the skill as the reusable workflow wrapper.
- Do not include deed documents unless Wes changes the package scope.

## Amortization

Type: wiki-managed support skill plus project room.

Status: draft.

Purpose:

- Create a formal 12-month amortization chart from a Buy Your Home project spreadsheet.
- Read the worksheet currently referred to as `amateurization`, with `amortization` as the normalized spelling for skill/output language.
- Accept a caller-supplied output folder and drop the finished chart there.
- Support Contract for Deed and other seller-financing workflows that need a reusable amortization output.

Defined in:

- `C:\Codex\Wiki Files\skills\amortization\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Amortization\README.md`

Important rules:

- Do not infer or search for the output folder when called by another skill.
- Do not modify the source spreadsheet unless Wes explicitly asks.
- Stop and report missing or ambiguous spreadsheet terms rather than guessing.

## CMA Report

Type: wiki-managed skill.

Status: active.

Purpose:

- When the owner asks for a report for a property, keep the working report in the wiki/project room and copy the completed report to the matching Teams-synced property folder.
- Use the matched property folder under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property`, then copy the report into that property's `Owning` folder.
- Avoid silent overwrites. If a report with the same name already exists, create a timestamped copy unless the owner explicitly approves replacement.

Defined in:

- `C:\Codex\Wiki Files\skills\cma-report\SKILL.md`

Important rules:

- A request for a property report counts as standing permission to copy the final report deliverable into Teams `Owning`.
- Use `Owner-provided` in report assumptions and valuation reasoning instead of the owner's personal name.
- Do not create new Teams property folders or choose between multiple possible property matches without the owner's approval.

## Grocery List Handler

Type: wiki rule and data workflow.

Status: active.

Purpose:

- Maintain the grocery list when Boss or Jenny asks through approved channels.
- For full-list requests, group items logically by how they are found in the store.

Defined in:

- `C:\Codex\Grocery List`
- `C:\Codex\Wiki Files\operations\grocery-list\`

Triggered by:

- Direct user requests in Codex.
- Approved Boss/Jenny REI texts handled by the REI Text Message Watcher.

## AI Project Room Workflow

Type: wiki workflow.

Status: active.

Purpose:

- Prepare sources before drafting or redesigning complex deliverables.
- Inventory sources, identify duplicates/conflicts, record missing context, and draft only from authoritative inputs.

Defined in:

- `Project Room Workflow.md`
- `prompts\build-project-room.md`
- `templates\project-room-readme.md`

Use when:

- A task depends on multiple source files, emails, scans, notes, spreadsheets, or prior drafts.

## Template to Project

Type: wiki-managed skill plus project room.

Status: active.

Purpose:

- Migrate approved worksheet, workbook, and worksheet-mode designs from a prototype workbook into active Buy Your Home project-management spreadsheets.
- Maintain worksheet-mode rules, rollout target lists, rollback procedures, validation logs, migration logs, and lessons learned.
- Keep active project spreadsheet structures consistent across projects after Wes approves a design change.

Defined in:

- `C:\Codex\Wiki Files\skills\template-to-project\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Template to Project\README.md`
- `C:\Codex\Wiki Files\Project Rooms\Template to Project\Project Spreadsheet Expense Placement Rules.md`
- `C:\Codex\Wiki Files\Project Rooms\Template to Project\Worksheet Modes`

Important boundaries:

- Does not insert individual invoice, receipt, or statement-line records into project spreadsheets; that belongs to Invoice Entry.
- Does not inspect scans, split documents, OCR invoices, or route invoice files; that belongs to Doc Scan.
- Does not edit another project room's files or skill source without exact Wes approval.

## Project Management Spreadsheet Rewrite

Type: planning/history project room.

Status: active/planning.

Purpose:

- Preserve earlier planning for a broader project-management spreadsheet rewrite.
- Use `Template to Project` for current template-to-active-project migration work unless Wes specifically asks to work in this planning room.

Defined in:

- `Project Rooms\Project Management Spreadsheet Rewrite\README.md`
- `Project Rooms\Project Management Spreadsheet Rewrite\working\source-inventory.md`
- `Project Rooms\Project Management Spreadsheet Rewrite\working\duplicate-and-conflict-log.md`
- `Project Rooms\Project Management Spreadsheet Rewrite\working\missing-context.md`

Next needed inputs:

- Current Project Management spreadsheet or master template.
- At least one good project instance.
- At least one messy or frustrating project instance.
- Desired reports and project lifecycle stages.

## New Project

Type: wiki-managed skill plus project room.

Status: draft.

Purpose:

- Hold a newly scoped Buy Your Home admin project once Wes defines the goal.
- Keep source files, working notes, open questions, and review-ready outputs separated from other project rooms.

Defined in:

- `C:\Codex\Wiki Files\skills\new-project\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\New Project\README.md`

Important rules:

- Record the project goal and controlling sources before drafting final outputs.
- When Wes says to create a new project, first suggest an existing project to use as the template for the new project spreadsheet and associated folders.
- Wait for Wes to confirm the suggested template project or provide another project to use instead.
- Use the confirmed template project and Wes-provided address for the new project spreadsheet and associated folders.
- When creating the new project spreadsheet, review the `Profit` sheet and blank out prototype/template-specific values while preserving formulas, labels, structural formatting, and reusable assumptions.
- If it is unclear whether a `Profit` sheet value is template-specific or reusable, record it for review instead of deleting it.
- Do not use New Project when an existing specialized project room is the better fit.

## Confidential

Type: wiki-managed skill plus project room plus dedicated chat.

Status: draft.

Purpose:

- Hold sensitive Buy Your Home Admin wiki work that Wes explicitly routes to Confidential.
- Keep confidential source notes, working analysis, open questions, privacy notes, and review-ready outputs separated from other Admin wiki work.
- Prevent accidental sharing of Confidential materials outside the Admin wiki unless Wes specifically authorizes the transfer or an existing workflow rule clearly requires it.

Defined in:

- `C:\Codex\Wiki Files\skills\confidential\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Confidential\README.md`

Dedicated chat:

- Thread id: `019f47a8-b32a-73a0-9bc4-9e493f1b0c5e`

Important rules:

- Do not store passwords, authentication tokens, payment card numbers, bank login credentials, seed phrases, or other live secrets in the project room, skill, git history, or chat handoff notes.
- Do not copy Confidential files to Teams, SharePoint, email, another project room, or an external service unless Wes explicitly asks for that specific transfer or an existing rule clearly requires it.
- Use specialized project rooms instead when Wes names a specific workflow such as Doc Scan, Email Monitor, Contract for Deed, Credit Worthiness Evaluator, or Gracious Millionaire.
- No automation is currently attached.

## REI BlackBook

Type: wiki-managed skill plus project room.

Status: draft.

Purpose:

- Plan, draft, build, QA, and document Buy Your Home REI BlackBook work, including websites, WebTools Sites, lead/contact workflows, text or Profit Dial-related workflows, account-access notes, and future REI BlackBook modules Wes asks Codex to support.
- Use `https://my.reiblackbook.com/webtools/sites` as the current primary work surface through an authorized logged-in browser session when implementation is needed.
- Keep credentials out of the wiki, skill, project room, and git history.

Defined in:

- `C:\Codex\Wiki Files\skills\rei-blackbook\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\README.md`
- Current REI Blackbook project-room thread id: `019f4691-5466-7f72-9683-ab5d3b750c25`

Important rules:

- Do not buy domains, paid add-ons, ads, templates, or subscriptions without Wes's explicit approval for the specific purchase.
- Do not publish a site, change DNS, change tracking pixels, replace live content, send texts, alter live lead workflows, or change account settings without Wes's explicit approval for that specific action.
- Record missing website goals, brand assets, compliance language, and access blockers in the project room before drafting final public-facing copy.

## GM Mode Site Iteration

Type: GM Mode heartbeat automation plus REI BlackBook project room.

Status: active.

Automation id:

- `gm-mode-site-iteration`

Schedule:

- Every 30 minutes.
- Current anchor after 2026-07-09 schedule update: first run at 7:52 PM Eastern, then every 30 minutes.

Purpose:

- Run the routine Gracious Millionaire website development loop by auditing, implementing comprehensive live site improvements, QAing the result, and refreshing the local map.
- Inspect the public Gracious Millionaire site and refresh or supersede the local element map.
- Update the improvement backlog or recommendations.
- Draft or implement replacement copy, design cleanup, navigation/page-structure improvements, sidebar/footer cleanup, approved image placement, and form-presentation improvements for mapped generic/off-topic elements when useful.
- Record QA findings for page titles, navigation, links, forms, images, sidebars, footer, generic-template remnants, public privacy risk, SSL/domain status, and next live-edit actions.

Defined in:

- `C:\Codex\Wiki Files\skills\rei-blackbook\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\README.md`
- App automation id `gm-mode-site-iteration`

Important limitations:

- Use `Project Rooms\REI BlackBook\working\gm-mode-run-lock.md` to prevent overlapping GM Mode runs. If a fresh lock exists, do not inspect or edit the live site. If the lock is 3 hours old or older, record a stale-lock takeover, replace the lock, and proceed.
- Wes broadened GM Mode on 2026-07-10: live comprehensive design, site-structure, navigation, layout, sidebar/footer, approved image-placement, visible-copy, and form-presentation improvements are authorized for the Gracious Millionaire site.
- Wes established the creative charter on 2026-07-15: treat Gracious Millionaire as a book-centered editorial experience, work in coherent 45-90 minute design iterations when useful backlog remains, preserve each run's learning in `working\gm-mode-iteration-ledger.md`, and resume from the exact prior continuation point instead of repeatedly auditing from zero.
- Current activation state: `ACTIVE`. The 30-minute cadence is a wake-up schedule, not a run-duration limit. After acquiring the lock, one invocation should complete and QA successive unblocked objectives for approximately 45-90 minutes, or until the backlog is exhausted, a required approval or external dependency blocks progress, or browser instability makes continued live work unsafe. Do not clear the lock and end merely because one small iteration finished.
- Wes authorized a standing GM completion-backlog email on 2026-07-17. At the end of every substantive GM run, send one concise email from `OfficeAssist@BuyYourHomeLLC.com` to `WesWill@BuyYourHomeLLC.com` listing completed live changes, QA status, remaining backlog in priority order, blockers or approvals needed, the recommended next objective, and lock-clear status. Follow `skills\email-delivery\SKILL.md` and verify the sent copy in OfficeAssist Sent Items. Do not send this email for fresh-lock overlap exits, no-op heartbeat checks, or runs that never began substantive work. Report send or verification failures visibly in the project-room thread.
- Do not activate outbound form/SMS/email/lead workflows, change who receives submitted leads or messages, upload personal Google Photos publicly, expose or change public contact details, change DNS/domain settings, purchase anything, push Git changes, send messages, publish manuscript content, or make legal/financial/compliance claims from the automation unless Wes explicitly approves that specific action.
- Use DONT_NOTIFY only when another fresh run owns the lock or no authorized useful design work remains. A failed builder path should cause the run to switch objectives, not end. Notify Wes when live changes were made, meaningful findings remain, new blockers occur, high-risk approval is needed, or QA finds broken pages, generic/off-topic content, public privacy risk, workflow/form risk, SSL/domain issues, or recommended next actions.

## Invoice Entry

Type: wiki-managed skill plus project room plus backup heartbeat automation plus dedicated chat.

Status: active.

Purpose:

- Receive structured invoice packets after Doc Scan has completed the normal scanned invoice/receipt intake path: inspection/OCR, splitting when needed, invoice/receipt identification, project/property routing, Teams/project-folder save or copy, scan log entry, and packet creation.
- Other intake sources are out of scope unless Wes separately approves and documents them.
- Resolve the active Teams/SharePoint project-management workbook and target worksheet.
- Check for duplicate invoice records.
- Insert invoice records into approved project-spreadsheet expense areas, starting with Vendor Tabs Mode yellow actual-invoice sections.
- Validate affected totals, downstream `Gnatt Chart` values, workbook links, and clean Excel open/save behavior.
- Report uncertain routing or duplicate risk to Wes instead of guessing.

Defined in:

- `C:\Codex\Wiki Files\skills\invoice-entry\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Invoice Entry\README.md`

Dedicated chat:

- Thread id: `019f3d56-b310-75c0-b084-616bfc1e9f59`

Automation:

- Heartbeat id: `invoice-entry-to-projects-backup-heartbeat`.
- Schedule: every 60 minutes as backup.
- Storage: app automation id `invoice-entry-to-projects-backup-heartbeat`.
- Primary trigger: Doc Scan sends a direct follow-up message to the dedicated Invoice Entry chat with the packet path and summary.
- Backup scope: inspect the Invoice Entry project room for new or changed structured invoice/receipt packets that were not delivered by direct message. Do not scan inboxes, inspect raw scan folders, copy files into Teams, approve or pay invoices, contact vendors, redesign workbook templates, or create new chats.
- Live workbook edits remain gated by clear Wes authorization or an approved automation rule for the exact insertion type.

Important limitations:

- Does not scan inboxes or copy invoice attachments into Teams folders.
- Does not design or roll out workbook templates; that belongs to Template to Project.
- Does not approve invoices, pay invoices, contact vendors, or make accounting entries.
- Uses Teams/SharePoint as the source of truth for active project-management workbooks.

Current status:

- First supported worksheet group is Vendor Tabs Mode.
- First workbook for proving the workflow is Outrigger after Wes approves the Vendor Tabs Mode design.
- Direct-message handoff is the primary trigger for packet intake. Backup heartbeat automation checks hourly for missed project-room packet handoffs.

## Investigate Computer

Type: wiki-managed skill plus project room plus heartbeat automation.

Status: active.

Purpose:

- Run repeatable Windows compromise diagnostics for Wes's computer.
- Check for ScreenConnect/RMM services, processes, known folders, uninstall entries, startup entries, scheduled tasks, known suspicious remote connections, and known RMM download indicators.
- Preserve and document incident evidence before cleanup.
- Support post-reboot verification and OfficeAssist email reporting.

Defined in:

- `C:\Codex\Wiki Files\skills\investigate-computer\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Investigate Computer\README.md`

Current schedule:

- On demand.
- Daily heartbeat at 6:00 AM Eastern.
- Automation id: `investigate-computer-daily-check`.
- Clean runs should stay quiet with `DONT_NOTIFY`.
- If any issue is detected, send Wes an OfficeAssist email from `OfficeAssist@BuyYourHomeLLC.com` to `WesWill@BuyYourHomeLLC.com`, attach the diagnostic report when practical, and verify the sent copy in OfficeAssist Sent Items.

Important rules:

- Do not delete evidence unless Wes explicitly asks.
- If active remote access is found, tell Wes plainly and recommend disconnecting the computer from the internet.
- Use `email-delivery` for OfficeAssist email reports and verify sent copies in OfficeAssist Sent Items.

## Jenny Email Summary

Type: behavior inside the Email Monitor heartbeat.

Status: active as of 2026-06-29.

Purpose:

- Produce a daily summary of Jenny's new email at the same first eligible Email Monitor heartbeat run used for Wes's morning summary.
- Email Jenny's summary to `Jenny@BuyYourHomeLLC.com` from `OfficeAssist@BuyYourHomeLLC.com` unless Wes explicitly changes the routing.

Activation note:

- Wes explicitly asked to resume Jenny's daily email summary on 2026-06-29.
- The Outlook Email connector can read `Jenny@BuyYourHomeLLC.com` folders, including Inbox and rule-routed subfolders.
- Initial cutoff for new Jenny mail is the 2026-06-29 resume timestamp unless a prior Jenny summary record is later found. Older unread items may still be included when they are clearly priority business items.

Defined in:

- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`
- `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md`

Operating rule:

- Run once per calendar day at the first eligible Email Monitor heartbeat at or after 8:00 AM Eastern if Jenny's daily summary has not already been sent and verified.
- Email Jenny's summary to Jenny under the current global profile, verify the OfficeAssist Sent Items copy, and report any send or verification failure in the Email Monitor thread.

## How To Inspect Actual Automations

Local automation definitions live under:

```text
C:\Users\wesbr\.codex\automations\
```

Current automation folders:

```text
doc-scan\
gracious-millionaire-project-room-heartbeat\
investigate-computer-daily-check\
morning-weswill-email-summary\
officeassist-morning-email-summary-and-instruction-monitor\
```

Each active automation folder contains an `automation.toml` file with the real schedule, prompt, status, and execution settings. Use `officeassist-morning-email-summary-and-instruction-monitor\` for the active OfficeAssist heartbeat and its `memory.md` instruction-email monitor state.

## Related Connector Rules

Use `Connector and Plugin Usage Rules.md` to see which installed plugins/connectors should be preferred for GitHub, spreadsheet, browser, and Outlook/email work.

## Maintenance Rule

When creating, renaming, pausing, deleting, or materially changing an agent-like function, update this registry in the same change.
