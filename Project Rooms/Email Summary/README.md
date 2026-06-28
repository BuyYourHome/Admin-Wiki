# Email Summary Project Room

This project room holds development notes, source inventory, and review artifacts for the OfficeAssist morning email summary workflow.

## Purpose

- Keep daily email-summary development separate from the general Admin Operations chat.
- Preserve the existing automation id: `officeassist-morning-email-summary`.
- Keep the canonical workflow source in `C:\Codex\Wiki Files\skills\officeassist-morning-email-summary\SKILL.md`.
- Track the OfficeAssist heartbeat config at `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml`.
- Record open decisions before changing mailbox scope, cutoff behavior, delivery behavior, or automation thread targeting.

## Current Status

- Status: active for Wes.
- Jenny summary: paused until Wes explicitly resumes it.
- Send identity: `OfficeAssist@BuyYourHomeLLC.com`.
- Recipient for Wes summary: `WesWill@BuyYourHomeLLC.com`.
- Preferred mailbox/send path: Outlook Email connector, with OfficeAssist sent-item verification.
- Fallback: local Outlook only when connector send or verification cannot complete safely.
- Automation type: heartbeat, attached to the dedicated `OfficeAssist Morning Email Summary Status` thread.
- Responsibility boundary: this heartbeat checks email and takes defined actions. It may route Gracious Millionaire email into that project room as Markdown, but it does not process the Gracious Millionaire manuscript.
- Status thread id: `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`.

## Room Layout

- `sources\` - source notes for controlling rules, skill source, automation config, connector behavior, and related files.
- `working\` - inventories, conflicts, missing context, development notes, and proposed changes.
- `outputs\` - review-ready specs, handoffs, runbooks, or finalized drafts.

## Authoritative Sources

- `C:\Codex\Wiki Files\skills\officeassist-morning-email-summary\SKILL.md`
- `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml`

## Development Boundary

Use this room for development and design work. Do not change the live automation id, schedule, target thread, sender, recipient, or mailbox scope without a specific instruction from Wes.

When the workflow changes, update the skill, this project room, and the registry together.

## Change Log

- 2026-06-28: Wes clarified the separation between rooms: the Gracious Millionaire heartbeat watches for new Markdown files dropped into that project room; the OfficeAssist Morning Email Summary heartbeat watches email and takes defined actions when it finds actionable instructions.
- 2026-06-15: With Wes's approval, converted `officeassist-morning-email-summary` from a standalone cron automation to a heartbeat automation attached to the dedicated `OfficeAssist Morning Email Summary Status` thread so daily runs stop creating new chats.
