# Agents And Automations Registry

This is the human-readable control panel for agent-like work in the Buy Your Home admin system.

Codex does not currently show every role below in one unified "Agents" list. Some are scheduled automations, some are skills, some are durable wiki rules, and some are project rooms. This registry maps the practical role name to where it is actually defined.

## Summary

| Name | Type | Status | Schedule | Primary Definition |
|---|---|---|---|---|
| Jean Wright / Office Assistant | Assistant profile and operating role | Active | On demand and through related automations | `C:\Codex\Office Assistant Profile.md`; `AGENTS.md` |
| REI Text Message Watcher | Heartbeat automation | Active | Every 15 minutes during 8:00 AM-9:00 PM Eastern; adaptive 1-minute checks during activity | `C:\Users\wesbr\.codex\automations\morning-weswill-email-summary\automation.toml` |
| OfficeAssist Morning Email Summary | Wiki-managed skill plus cron automation | Active | Daily at 8:00 AM Eastern | `skills\officeassist-morning-email-summary\SKILL.md`; `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml` |
| Email Delivery | Wiki-managed support skill | Active | Called by email-capable Admin workflows | `skills\email-delivery\SKILL.md` |
| Document Scanning | Wiki-managed skill plus heartbeat automation | Active | Daily at 10:00 AM, 12:00 PM, 2:00 PM, and 4:00 PM | `skills\document-scanning\SKILL.md`; `C:\Users\wesbr\.codex\skills\document-scanning\SKILL.md`; `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml` |
| Codex Skill Source Control | Wiki-managed skill system | Active | On demand after skill changes or wiki pulls | `Codex Skill Source Rule.md`; `tools\sync-codex-skills.ps1`; `skills\` |
| Admin Request Wrapup | Wiki-managed skill | Active | At the end of Admin wiki requests | `skills\admin-request-wrapup\SKILL.md`; `AGENTS.md` |
| Credit Worthiness Evaluator | Wiki-managed skill plus project room | Active | On demand | `skills\credit-worthiness-evaluator\SKILL.md`; `Project Rooms\Credit Worthiness Evaluator\README.md` |
| Contract for Deed | Wiki-managed skill plus project room | Active | On demand | `skills\contract-for-deed\SKILL.md`; `Project Rooms\Contract for Deed\PROJECT-ROOM.md` |
| CMA Report | Wiki-managed skill | Active | On demand when a CMA or property report is created | `skills\cma-report\SKILL.md` |
| Grocery List Handler | Wiki rule and data workflow | Active | On demand, including approved Boss/Jenny text instructions | `operations/grocery-list/` |
| AI Project Room Workflow | Wiki workflow | Active | On demand before complex multi-source work | `Project Room Workflow.md` |
| Project Management Spreadsheet Rewrite | Project Room | Active/planning | On demand | `Project Rooms\Project Management Spreadsheet Rewrite\README.md` |
| Jenny Daily Email Summary | Planned/paused automation behavior | Paused | Would run daily with Wes summary after Jenny mailbox is available | `officeassist-morning-email-summary` prompt notes |

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

Type: heartbeat automation.

Status: active.

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

## OfficeAssist Morning Email Summary

Type: wiki-managed skill plus cron automation.

Status: active for Wes; Jenny summary paused.

Automation id:

- `officeassist-morning-email-summary`

Schedule:

- Daily around 8:00 AM Eastern.

Purpose:

- Recursively review the full `WesWill@BuyYourHomeLLC.com` Outlook mailbox, including rule-routed subfolders.
- Summarize unread or newly received financial, legal, property, vendor/admin, time-sensitive, or action-oriented messages.
- Send Wes a concise priority summary from `OfficeAssist@BuyYourHomeLLC.com`.
- Include a short token-usage section for yesterday and the current week to date when reliable token totals are available; if not available, say so rather than estimating.
- Jean is responsible for confirming the summary is actually delivered. If the summary cannot be sent, if sender verification fails, or if delivery cannot be confirmed, do not stay quiet. Notify Wes immediately in the thread and, when a reliable text/SMS path is available, text Wes that the email summary failed.
- Resume one dedicated Codex status chat for failures, blockers, and notable summary-task visibility instead of creating separate standalone run chats.

Defined in:

- `C:\Codex\Wiki Files\skills\officeassist-morning-email-summary\SKILL.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml`
- Email safety rules in `AGENTS.md`.

Important limitations:

- Jenny's summary is paused until `Jenny@BuyYourHomeLLC.com` is available locally or through a reliable connector.
- Do not substitute another mailbox for Jenny.
- Keep the automation attached to one dedicated status thread via `target_thread_id` so failure notifications and follow-up stay in one chat.

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

- Daily at 10:00 AM, 12:00 PM, 2:00 PM, and 4:00 PM.

Purpose:

- Check scanned PDFs in the Office Admin scan intake folder.
- Split combined scans into separate financial/admin documents.
- Name outputs using approved conventions.
- Route mortgage statements, credit card statements, bank statements, invoices, receipts, tax forms, and related documents to the correct Teams/SharePoint folder.
- Write logs and archive original scans.
- Resume one dedicated Codex chat for status, follow-up, and automation tuning instead of creating a fresh standalone run thread each time.

Defined in:

- Canonical skill source: `C:\Codex\Wiki Files\skills\document-scanning\SKILL.md`
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

## Jenny Daily Email Summary

Type: planned/paused automation behavior.

Status: paused.

Purpose:

- Eventually send Jenny a daily summary of her new email at the same time as Wes's morning summary.

Why paused:

- `Jenny@BuyYourHomeLLC.com` mailbox is not currently available on this machine.
- Wes instructed that Jenny summary should remain paused until the mailbox is added.

Defined in:

- Pause rule inside `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml`

Resume condition:

- Wes confirms Jenny's mailbox has been added and explicitly asks to resume the Jenny summary.

## How To Inspect Actual Automations

Local automation definitions live under:

```text
C:\Users\wesbr\.codex\automations\
```

Current automation folders:

```text
document-scanning\
morning-weswill-email-summary\
officeassist-morning-email-summary\
```

Each folder contains an `automation.toml` file with the real schedule, prompt, status, and execution settings.

## Related Connector Rules

Use `Connector and Plugin Usage Rules.md` to see which installed plugins/connectors should be preferred for GitHub, spreadsheet, browser, and Outlook/email work.

## Maintenance Rule

When creating, renaming, pausing, deleting, or materially changing an agent-like function, update this registry in the same change.
