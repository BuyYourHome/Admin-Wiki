# Agents And Automations Registry

This is the human-readable control panel for agent-like work in the Buy Your Home admin system.

Codex does not currently show every role below in one unified "Agents" list. Some are scheduled automations, some are skills, some are durable wiki rules, and some are project rooms. This registry maps the practical role name to where it is actually defined.

Use [[Agent Unit Standard]] for the standard package behind an agent-like operating unit: Project Room, skill, registry entry, chat/thread when any, and automation only when needed. Use [[Project Room Chat Startup Rule]] when creating or resuming Project Room chats.

## Summary

| Name | Type | Status | Schedule | Primary Definition |
|---|---|---|---|---|
| Jean Wright / Office Assistant | Assistant profile and operating role | Active | On demand and through related automations | `C:\Codex\Office Assistant Profile.md`; `AGENTS.md` |
| REI Text Message Watcher | Heartbeat automation | Active | Every 15 minutes during 8:00 AM-9:00 PM Eastern; adaptive 1-minute checks during activity | `C:\Users\wesbr\.codex\automations\morning-weswill-email-summary\automation.toml` |
| OfficeAssist Instruction Inbox Monitor | Behavior inside Email Summary heartbeat | Active | Runs every day; starts at 7:45 AM Eastern, then every 15 minutes through 11:00 PM Eastern; checks email and takes defined actions | `AGENTS.md`; `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml` |
| Gracious Millionaire Project Room Heartbeat | Project-room heartbeat automation | Active | Every 15 minutes from 8:00 AM-11:45 PM Eastern; project-room Markdown intake processing only | `Project Rooms\Gracious Millionaire\README.md`; `Project Rooms\Gracious Millionaire\working\intake-heartbeat-rules.md`; `C:\Users\wesbr\.codex\automations\gracious-millionaire-project-room-heartbeat\automation.toml` |
| Email Summary | Wiki-managed skill plus heartbeat automation plus project room | Active | Runs every day; starts at 7:45 AM Eastern, then every 15 minutes through 11:00 PM Eastern; Boss and Jenny summaries run once daily at/after 8:00 AM, and instruction monitoring checks OfficeAssist email | `skills\email-summary\SKILL.md`; `Project Rooms\Email Summary\README.md`; `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml` |
| Email Delivery | Wiki-managed support skill | Active | Called by email-capable Admin workflows | `skills\email-delivery\SKILL.md` |
| Document Scanning | Wiki-managed skill plus heartbeat automation plus project room | Active | Every 30 minutes from 10:00 AM through 4:30 PM Eastern | `skills\document-scanning\SKILL.md`; `Project Rooms\Document Scan\README.md`; `C:\Users\wesbr\.codex\skills\document-scanning\SKILL.md`; app automation id `document-scanning` |
| Codex Skill Source Control | Wiki-managed skill system | Active | On demand after skill changes or wiki pulls | `Codex Skill Source Rule.md`; `tools\sync-codex-skills.ps1`; `skills\` |
| Admin Request Wrapup | Wiki-managed skill | Active | At the end of Admin wiki requests | `skills\admin-request-wrapup\SKILL.md`; `AGENTS.md` |
| SOPs | Wiki-managed skill plus project room | Active | On demand | `skills\sops\SKILL.md`; `Project Rooms\SOPs\README.md`; `Project Rooms\SOPs\outputs\SOP Index.md` |
| Credit Worthiness Evaluator | Wiki-managed skill plus project room | Active | On demand | `skills\credit-worthiness-evaluator\SKILL.md`; `Project Rooms\Credit Worthiness Evaluator\README.md` |
| Contract for Deed | Wiki-managed skill plus project room | Active | On demand | `skills\contract-for-deed\SKILL.md`; `Project Rooms\Contract for Deed\PROJECT-ROOM.md` |
| Operating Agreement | Wiki-managed skill plus project room | Draft | On demand | `skills\operating-agreement\SKILL.md`; `Project Rooms\Operating Agreements\README.md` |
| Amortization | Wiki-managed support skill plus project room | Draft | Called by Contract for Deed or other seller-financing workflows | `skills\amortization\SKILL.md`; `Project Rooms\Amortization\README.md` |
| CMA Report | Wiki-managed skill | Active | On demand when a CMA or property report is created | `skills\cma-report\SKILL.md` |
| Grocery List Handler | Wiki rule and data workflow | Active | On demand, including approved Boss/Jenny text instructions | `operations/grocery-list/` |
| AI Project Room Workflow | Wiki workflow | Active | On demand before complex multi-source work | `Project Room Workflow.md` |
| AIOS | Wiki-managed skill plus project room | Active/planning | On demand | `skills\aios\SKILL.md`; `Project Rooms\AIOS\README.md`; `AIOS\start-here.md` |
| Entity Relationship | Wiki-managed skill plus project room | Active/planning | On demand | `skills\entity-relationship\SKILL.md`; `Project Rooms\Entity Relationship\README.md` |
| Gracious Millionaire | Wiki-managed skill plus project room plus heartbeat automation | Active | Project-room heartbeat every 15 minutes during active window; on demand otherwise | `skills\gracious-millionaire\SKILL.md`; `Project Rooms\Gracious Millionaire\README.md`; `Project Rooms\Gracious Millionaire\working\intake-heartbeat-rules.md`; automation id `gracious-millionaire-project-room-heartbeat` |
| Project Management Spreadsheet Redesign | Wiki-managed skill plus project room | Active | On demand | `skills\project-management-spreadsheet-redesign\SKILL.md`; `Project Rooms\Project Management Spreadsheet Redesign\README.md`; `Project Rooms\Project Management Spreadsheet Redesign\Project Spreadsheet Expense Placement Rules.md` |
| Project Spreadsheet Invoice Entry | Wiki-managed skill plus project room plus heartbeat automation plus dedicated chat | Active | Every 15 minutes; inspects the project room for structured invoice/receipt packets after Document Scan or another approved workflow hands them off | `skills\project-spreadsheet-invoice-entry\SKILL.md`; `Project Rooms\Project Spreadsheet Invoice Entry\README.md`; `C:\Users\wesbr\.codex\automations\project-spreadsheet-invoice-entry-heartbeat\automation.toml` |
| Project Management Spreadsheet Rewrite | Planning project room, now covered by Spreadsheet Redesign skill | Active/planning | On demand | `skills\project-management-spreadsheet-redesign\SKILL.md`; `Project Rooms\Project Management Spreadsheet Rewrite\README.md` |
| Property Trade Evaluation | Wiki-managed skill plus project room | Active | On demand | `skills\property-trade-evaluation\SKILL.md`; `Project Rooms\Property Trade Evaluation\README.md` |
| Wes's Voice | Wiki-managed skill plus project room | Planning | On demand | `skills\wes-voice\SKILL.md`; `Project Rooms\Wes's Voice\README.md` |
| New Project | Wiki-managed skill plus project room | Draft | On demand | `skills\new-project\SKILL.md`; `Project Rooms\New Project\README.md` |
| Investigate Computer | Wiki-managed skill plus project room plus heartbeat automation | Active | Daily at 6:00 AM Eastern; email Wes only when an issue is detected | `skills\investigate-computer\SKILL.md`; `Project Rooms\Investigate Computer\README.md`; app automation id `investigate-computer-daily-check` |
| Jenny Daily Email Summary | Behavior inside Email Summary heartbeat | Active | Runs once daily at/after 8:00 AM Eastern with the Email Summary heartbeat; emails Jenny from OfficeAssist and verifies Sent Items | `skills\email-summary\SKILL.md`; `Email Summary` prompt notes |

## Jean Wright / Office Assistant

Type: assistant profile and operating role.

Status: active.

Purpose:

- Act as the office assistant for Buy Your Home, LLC.
- Handle safe administrative tasks, email drafting/sending under approved rules, grocery list updates, document workflow coordination, and office process support.

Defined in:

- `C:\Codex\Office Assistant Profile.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- Related workflow pages in this wiki.

Important rules:

- When sending directly as Jean/Office Assistant, use `OfficeAssist@BuyYourHomeLLC.com`.
- State that Jean is sending on Wes's behalf when appropriate.
- Copy `WesWill@BuyYourHomeLLC.com` on outbound emails sent on Wes's behalf unless Wes explicitly says not to for that specific message.
- Do not delete emails, change mailbox settings, spend money, place orders, or send external texts without explicit approval.

Where to inspect:

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

Status: active as behavior inside the Email Summary heartbeat.

Automation id:

- `officeassist-morning-email-summary-and-instruction-monitor`

Schedule:

- Starts at 7:45 AM Eastern.
- Then runs every 15 minutes from 8:00 AM through 11:00 PM Eastern.

Purpose:

- Monitor `OfficeAssist@BuyYourHomeLLC.com` for instruction emails from Wes or Jenny.
- Treat emails from `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com` as OfficeAssist instruction intake.
- Carry out safe, in-scope admin actions when the email instruction and applicable workflow rules allow it.
- Route Gracious Millionaire email into the Gracious Millionaire project room as Markdown source files, but do not process the manuscript from the OfficeAssist monitor thread.
- Report blockers, ambiguous authority, mailbox failures, or decisions needed in the attached status thread.
- Avoid repeated processing by tracking handled message ids in local monitor memory.
- Keep routine no-new-instruction checks quiet with `DONT_NOTIFY`.

Special routing:

- If an instruction email has a subject containing `gracious millionaire`, route it into `Project Rooms\Gracious Millionaire\` as book source material from the OfficeAssist monitor.
- Preserve each routed Gracious Millionaire email as its own Markdown file under `Project Rooms\Gracious Millionaire\sources\email\`, including available sender, recipient, timestamp, subject, message id or web link, and body text.
- Use plain names for this workflow. Do not call it `Project LumenScale`; refer to it as the Gracious Millionaire project-room process or Gracious Millionaire project-room heartbeat.
- Current Gracious Millionaire project-room thread id for manual project-room work: `019eb9b0-6780-7fb3-a278-29a18d17998c`.
- Do not attach an OfficeAssist mailbox-monitoring heartbeat to the Gracious Millionaire thread; the separate `gracious-millionaire-project-room-heartbeat` owns project-room Markdown/source processing in that thread and must not check email.
- Do not create a new chat for Gracious Millionaire routing unless Wes explicitly asks for a new chat.
- Do not draft, edit, or send the requested Gracious Millionaire book response from the OfficeAssist monitor thread unless Wes explicitly asks for processing there; the default action is source routing only.

Defined in:

- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` for local message-id memory.

Activation note:

- The former `gracious-millionaire-officeassist-email-intake` heartbeat was deleted on 2026-06-18 at Wes's request. All OfficeAssist email monitoring now belongs to the Email Summary heartbeat.

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

- Inspect `Project Rooms\Gracious Millionaire\` for routed Markdown/source files and intake-log entries dropped by OfficeAssist or another approved process.
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

## Email Summary

Type: wiki-managed skill plus heartbeat automation.

Status: active for Wes and Jenny.

Automation id:

- `officeassist-morning-email-summary-and-instruction-monitor`

Schedule:

- Runs every day.
- Starts at 7:45 AM Eastern.
- Then runs every 15 minutes from 8:00 AM through 11:00 PM Eastern.
- Runs in the dedicated `Email Summary` Codex thread instead of creating a new standalone run chat each morning.

Purpose:

- Recursively review the full `WesWill@BuyYourHomeLLC.com` Outlook mailbox, including rule-routed subfolders.
- Recursively review the full `Jenny@BuyYourHomeLLC.com` Outlook mailbox, including rule-routed subfolders.
- Summarize unread or newly received financial, legal, property, vendor/admin, time-sensitive, or action-oriented messages.
- Monitor the OfficeAssist mailbox for instruction emails and take defined actions when the email instruction and safety rules allow it.
- Send Wes a concise priority summary from `OfficeAssist@BuyYourHomeLLC.com`.
- Email Jenny's concise priority summary to `Jenny@BuyYourHomeLLC.com` from `OfficeAssist@BuyYourHomeLLC.com` under the current global profile, and verify the sent copy in OfficeAssist Sent Items.
- Include a short token-usage section for yesterday and the current week to date when reliable token totals are available; if not available, say so rather than estimating.
- Jean is responsible for confirming the summary is actually delivered. If the summary cannot be sent, if sender verification fails, or if delivery cannot be confirmed, do not stay quiet. Notify Wes immediately in the thread and, when a reliable text/SMS path is available, text Wes that the email summary failed.
- Resume one dedicated Codex status chat for failures, blockers, and notable summary-task visibility instead of creating separate standalone run chats.

Defined in:

- `C:\Codex\Wiki Files\skills\email-summary\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Email Summary\README.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`
- Email safety rules in `AGENTS.md`.

Important limitations:

- Jenny's summary is active as of 2026-06-29 because Wes explicitly asked to resume it and the Outlook Email connector can read `Jenny@BuyYourHomeLLC.com`.
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
- Development work, source inventory, open questions, and review-ready handoffs for this workflow live in `C:\Codex\Wiki Files\Project Rooms\Email Summary\`.

## Email Delivery

Type: wiki-managed support skill.

Status: active.

Purpose:

- Provide shared OfficeAssist email sender-safety, Outlook connector preference, attachment input handling, sent-item verification, and failure reporting for Admin workflows that send from `OfficeAssist@BuyYourHomeLLC.com`.
- Keep workflow-specific email content and package rules in the calling workflow.

Defined in:

- `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`

Important rules:

- The calling workflow supplies recipients, subject, body, attachments, and any stricter recipient/package limits.
- Prefer the Outlook/email connector and verify the sent copy in OfficeAssist Sent Items.
- Use local Outlook only as fallback when connector send or verification is unavailable.

## Document Scanning

Type: wiki-managed skill plus heartbeat automation.

Status: active.

Automation id:

- `document-scanning`

Schedule:

- Every 30 minutes from 10:00 AM through 4:30 PM Eastern.

Purpose:

- Check scanned PDFs in the Office Admin scan intake folder.
- Use the SharePoint/Teams connector as the default discovery path for scans and destination-folder matching when available, with local synced folders as the scanner drop-zone, processing workspace, archive/log path, and fallback.
- Split combined scans into separate financial/admin documents, including property closing packages and signed operating-agreement packages.
- Name outputs using approved conventions.
- Route mortgage statements, credit card statements, bank statements, invoices, receipts, property closing documents, signed operating agreements, tax forms, and related documents to the correct Teams/SharePoint folder.
- Write logs and archive original scans.
- Resume one dedicated Codex chat for status, follow-up, and automation tuning instead of creating a fresh standalone run thread each time.

Defined in:

- Canonical skill source: `C:\Codex\Wiki Files\skills\document-scanning\SKILL.md`
- Project room: `C:\Codex\Wiki Files\Project Rooms\Document Scan\README.md`
- Installed local skill copy: `C:\Users\wesbr\.codex\skills\document-scanning\SKILL.md`
- Automation: `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml`
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
- Project room: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\PROJECT-ROOM.md`

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

## Project Management Spreadsheet Rewrite

Type: Project Room.

Status: active/planning.

Purpose:

- Begin an extensive rewrite of the Project Management spreadsheet used for real estate projects.
- The current workflow uses a new spreadsheet instance for each real estate project.

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

## Project Spreadsheet Invoice Entry

Type: wiki-managed skill plus project room plus heartbeat automation plus dedicated chat.

Status: active.

Purpose:

- Receive structured invoice packets after Document Scan has completed the normal scanned invoice/receipt intake path: inspection/OCR, splitting when needed, invoice/receipt identification, project/property routing, Teams/project-folder save or copy, scan log entry, and packet creation.
- Receive structured invoice packets from Email Summary, OfficeAssist, or another approved workflow only as a secondary or future handoff source when it provides a complete structured packet.
- Resolve the active Teams/SharePoint project-management workbook and target worksheet.
- Check for duplicate invoice records.
- Insert invoice records into approved project-spreadsheet expense areas, starting with Vendor Tabs Mode yellow actual-invoice sections.
- Validate affected totals, downstream `Gnatt Chart` values, workbook links, and clean Excel open/save behavior.
- Report uncertain routing or duplicate risk to Wes instead of guessing.

Defined in:

- `C:\Codex\Wiki Files\skills\project-spreadsheet-invoice-entry\SKILL.md`
- `C:\Codex\Wiki Files\Project Rooms\Project Spreadsheet Invoice Entry\README.md`

Dedicated chat:

- Thread id: `019f3d56-b310-75c0-b084-616bfc1e9f59`

Automation:

- Heartbeat id: `project-spreadsheet-invoice-entry-heartbeat`.
- Schedule: every 15 minutes.
- Automation file: `C:\Users\wesbr\.codex\automations\project-spreadsheet-invoice-entry-heartbeat\automation.toml`
- Scope: inspect the Project Spreadsheet Invoice Entry project room for new or changed structured invoice/receipt packets only. Do not scan inboxes, inspect raw scan folders, copy files into Teams, approve or pay invoices, contact vendors, redesign workbook templates, or create new chats.
- Live workbook edits remain gated by clear Wes authorization or an approved automation rule for the exact insertion type.

Important limitations:

- Does not scan inboxes or copy invoice attachments into Teams folders.
- Does not design or roll out workbook templates; that belongs to Project Management Spreadsheet Redesign.
- Does not approve invoices, pay invoices, contact vendors, or make accounting entries.
- Uses Teams/SharePoint as the source of truth for active project-management workbooks.

Current status:

- First supported worksheet group is Vendor Tabs Mode.
- First workbook for proving the workflow is Outrigger after Wes approves the Vendor Tabs Mode design.
- Heartbeat automation is active every 15 minutes for project-room packet intake monitoring.

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

## Jenny Daily Email Summary

Type: behavior inside the Email Summary heartbeat.

Status: active as of 2026-06-29.

Purpose:

- Produce a daily summary of Jenny's new email at the same first eligible Email Summary heartbeat run used for Wes's morning summary.
- Email Jenny's summary to `Jenny@BuyYourHomeLLC.com` from `OfficeAssist@BuyYourHomeLLC.com` unless Wes explicitly changes the routing.

Activation note:

- Wes explicitly asked to resume Jenny's daily email summary on 2026-06-29.
- The Outlook Email connector can read `Jenny@BuyYourHomeLLC.com` folders, including Inbox and rule-routed subfolders.
- Initial cutoff for new Jenny mail is the 2026-06-29 resume timestamp unless a prior Jenny summary record is later found. Older unread items may still be included when they are clearly priority business items.

Defined in:

- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`
- `C:\Codex\Wiki Files\skills\email-summary\SKILL.md`

Operating rule:

- Run once per calendar day at the first eligible Email Summary heartbeat at or after 8:00 AM Eastern if Jenny's daily summary has not already been sent and verified.
- Email Jenny's summary to Jenny under the current global profile, verify the OfficeAssist Sent Items copy, and report any send or verification failure in the Email Summary thread.

## How To Inspect Actual Automations

Local automation definitions live under:

```text
C:\Users\wesbr\.codex\automations\
```

Current automation folders:

```text
document-scanning\
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
