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
- Schedule: starts at 7:45 AM Eastern, then every 15 minutes from 8:00 AM through 4:45 PM Eastern.
- Jenny summary: active as of 2026-06-29; scan `Jenny@BuyYourHomeLLC.com` and post the summary in this Email Summary thread.
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

- 2026-06-29: Resumed Jenny's daily email summary after Wes explicitly requested it and the Outlook Email connector verified access to `Jenny@BuyYourHomeLLC.com`; Jenny's summary posts in the Email Summary thread under the current global profile.
- 2026-06-28: Updated the live heartbeat prompt so OfficeAssist instruction-email monitoring runs every day during the configured active window, not weekdays only.
- 2026-06-28: Wes clarified the separation between rooms: the Gracious Millionaire heartbeat watches for new Markdown files dropped into that project room; the Email Summary heartbeat watches email and takes defined actions when it finds actionable instructions.
- 2026-06-28: Renamed the project room, chat, and skill to `Email Summary`; the live automation id remains `officeassist-morning-email-summary-and-instruction-monitor`.
- 2026-06-28: Removed the stale local `officeassist-morning-email-summary` automation folder after moving monitor memory into the active `officeassist-morning-email-summary-and-instruction-monitor` folder.
- 2026-06-28: Recreated the OfficeAssist heartbeat in the app under `officeassist-morning-email-summary-and-instruction-monitor` after the old app id was missing, and changed the active schedule to start at 7:45 AM Eastern.
- 2026-06-15: With Wes's approval, converted `officeassist-morning-email-summary` from a standalone cron automation to a heartbeat automation attached to the dedicated `Email Summary` thread so daily runs stop creating new chats.
