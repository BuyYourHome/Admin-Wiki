# Agents And Automations Registry

This is the human-readable control panel for agent-like work in the Buy Your Home admin system.

Codex does not currently show every role below in one unified "Agents" list. Some are scheduled automations, some are skills, some are durable wiki rules, and some are project rooms. This registry maps the practical role name to where it is actually defined.

## Summary

| Name | Type | Status | Schedule | Primary Definition |
|---|---|---|---|---|
| Jean Wright / Office Assistant | Assistant profile and operating role | Active | On demand and through related automations | `C:\Codex\Office Assistant Profile.md`; `AGENTS.md` |
| REI Text Message Watcher | Heartbeat automation | Active | Every 15 minutes during 8:00 AM-9:00 PM Eastern; adaptive 1-minute checks during activity | `C:\Users\wesbr\.codex\automations\morning-weswill-email-summary\automation.toml` |
| OfficeAssist Morning Email Summary | Cron automation | Active | Daily at 8:00 AM Eastern | `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml` |
| Document Scanning | Skill plus cron automation | Active | Daily at 10:00 AM, 12:00 PM, 2:00 PM, and 4:00 PM | `C:\Users\wesbr\.codex\skills\document-scanning\SKILL.md`; `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml` |
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

Type: cron automation.

Status: active for Wes; Jenny summary paused.

Automation id:

- `officeassist-morning-email-summary`

Schedule:

- Daily around 8:00 AM Eastern.

Purpose:

- Recursively review the full `WesWill@BuyYourHomeLLC.com` Outlook mailbox, including rule-routed subfolders.
- Summarize unread or newly received financial, legal, property, vendor/admin, time-sensitive, or action-oriented messages.
- Send Wes a concise priority summary from `OfficeAssist@BuyYourHomeLLC.com`.

Defined in:

- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml`
- Email safety rules in `AGENTS.md`.

Important limitations:

- Jenny's summary is paused until `Jenny@BuyYourHomeLLC.com` is available locally or through a reliable connector.
- Do not substitute another mailbox for Jenny.

Tools/services used:

- Local Outlook profile, unless replaced by a future Outlook connector.
- OfficeAssist mailbox for sending.

## Document Scanning

Type: custom skill plus cron automation.

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

Defined in:

- Skill: `C:\Users\wesbr\.codex\skills\document-scanning\SKILL.md`
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
