# Email Summary

This project room holds development notes, source inventory, and review artifacts for the Email Summary workflow.

## Purpose

- Keep daily email-summary development separate from the general Admin Operations chat.
- Preserve the active automation id: `officeassist-morning-email-summary-and-instruction-monitor`.
- Keep the canonical workflow source in `C:\Codex\Wiki Files\skills\email-summary\SKILL.md`.
- Track the active OfficeAssist heartbeat config at `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`.
- Keep OfficeAssist instruction-email monitor memory in `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`.
- Record open decisions before changing mailbox scope, cutoff behavior, delivery behavior, or automation thread targeting.

## Current Status

- Status: active for Wes and Jenny.
- Active automation id: `officeassist-morning-email-summary-and-instruction-monitor`.
- Schedule: starts at 7:45 AM Eastern, then every 15 minutes from 8:00 AM through 11:00 PM Eastern.
- Jenny summary: active as of 2026-06-29; scan `Jenny@BuyYourHomeLLC.com` and email the summary to `Jenny@BuyYourHomeLLC.com` from OfficeAssist with Sent Items verification.
- Send identity: `OfficeAssist@BuyYourHomeLLC.com`.
- Recipient for Wes summary: `WesWill@BuyYourHomeLLC.com`.
- Preferred mailbox/send path: Outlook Email connector, with OfficeAssist sent-item verification.
- Fallback: local Outlook only when connector send or verification cannot complete safely.
- Automation type: heartbeat, attached to the dedicated `Email Summary` thread.
- Responsibility boundary: this heartbeat checks email and takes defined actions. It may route Gracious Millionaire email into that project room as Markdown, but it does not process the Gracious Millionaire manuscript.
- Status thread id: `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`.

## Room Layout

- `sources\` - source notes for controlling rules, skill source, automation config, connector behavior, and related files.
- `working\` - inventories, conflicts, missing context, development notes, and proposed changes.
- `outputs\` - review-ready specs, handoffs, runbooks, or finalized drafts.

## Modes

### Gracious Millionaire Email Routing Mode

Use this mode when the Email Summary workflow or OfficeAssist instruction monitor sees an email with a subject containing `gracious millionaire`, or an email that otherwise clearly belongs to the Gracious Millionaire book/project-room workflow.

This mode routes the email into `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\` as source material, preserves it as Markdown under `sources\email\`, updates Gracious Millionaire intake/source records when required by that room's rules, records the Outlook message id in Email Summary monitor memory, and sends a direct follow-up message to the existing Gracious Millionaire project-room thread with the routed source path and a short summary.

This mode does not draft, edit, or send the requested Gracious Millionaire book response from the Email Summary or OfficeAssist monitor thread unless Wes explicitly asks for processing here. It also does not attach mailbox checking to the Gracious Millionaire heartbeat or create a new Gracious Millionaire chat.

## Authoritative Sources

- `C:\Codex\Wiki Files\skills\email-summary\SKILL.md`
- `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`

## Development Boundary

Use this room for development and design work. Do not change the live automation id, schedule, target thread, sender, recipient, or mailbox scope without a specific instruction from Wes.

When the workflow changes, update the skill, this project room, and the registry together.

## Change Log

- 2026-07-15: Defined Gracious Millionaire Email Routing Mode and moved the existing Gracious Millionaire routed-email handoff behavior under that mode in the Email Summary skill.
- 2026-07-02: Wes changed Jenny's daily summary routing so the summary is emailed to `Jenny@BuyYourHomeLLC.com` from OfficeAssist with Sent Items verification.
- 2026-06-29: Resumed Jenny's daily email summary after Wes explicitly requested it and the Outlook Email connector verified access to `Jenny@BuyYourHomeLLC.com`.
- 2026-07-01: Extended the OfficeAssist Email Summary heartbeat schedule to run every 15 minutes through 11:00 PM Eastern.
- 2026-06-28: Updated the live heartbeat prompt so OfficeAssist instruction-email monitoring runs every day during the configured active window, not weekdays only.
- 2026-06-28: Wes clarified the separation between rooms: the Gracious Millionaire heartbeat watches for new Markdown files dropped into that project room; the Email Summary heartbeat watches email and takes defined actions when it finds actionable instructions.
- 2026-06-28: Renamed the project room, chat, and skill to `Email Summary`; the live automation id remains `officeassist-morning-email-summary-and-instruction-monitor`.
- 2026-06-28: Removed the stale local `officeassist-morning-email-summary` automation folder after moving monitor memory into the active `officeassist-morning-email-summary-and-instruction-monitor` folder.
- 2026-06-28: Recreated the OfficeAssist heartbeat in the app under `officeassist-morning-email-summary-and-instruction-monitor` after the old app id was missing, and changed the active schedule to start at 7:45 AM Eastern.
- 2026-06-15: With Wes's approval, converted `officeassist-morning-email-summary` from a standalone cron automation to a heartbeat automation attached to the dedicated `Email Summary` thread so daily runs stop creating new chats.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
