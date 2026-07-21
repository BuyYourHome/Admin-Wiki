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
- Josh summary: active as of 2026-07-21; scan `IRAManager@SellYourHomeRaleigh.com`, include the Manager Task mode list from `Project Rooms\Manager\working\task-register.md`, and email the summary to Josh from OfficeAssist with Wes copied and Sent Items verification.
- Send identity: `OfficeAssist@BuyYourHomeLLC.com`.
- Recipient for Wes summary: `WesWill@BuyYourHomeLLC.com`.
- Preferred mailbox/send path: Outlook Email connector, with OfficeAssist sent-item verification.
- Fallback: local Outlook only when connector send or verification cannot complete safely.
- Automation type: heartbeat, attached to the dedicated `Email Monitor` thread.
- Responsibility boundary: this heartbeat checks email and takes defined actions. It may route Gracious Millionaire email into that project room as Markdown, but it does not process the Gracious Millionaire manuscript.
- Status thread id: `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582`.

## Room Layout

- `sources\` - source notes for controlling rules, skill source, automation config, connector behavior, and related files.
- `working\` - inventories, conflicts, missing context, development notes, and proposed changes.
- `outputs\` - review-ready specs, handoffs, runbooks, or finalized drafts.

## Modes

### Email Summary

Use this mode for the once-daily Boss, Jenny, and Josh Outlook mailbox summaries.

This mode scans `WesWill@BuyYourHomeLLC.com` for Boss, `Jenny@BuyYourHomeLLC.com` for Jenny, and `IRAManager@SellYourHomeRaleigh.com` for Josh, using the last verified send time in OfficeAssist monitor memory as each mailbox cutoff. Josh's initial cutoff is the verified manual summary send at `2026-07-21T12:24:17Z`. It scans each mailbox recursively, including rule-routed folders, and summarizes unread or newly received priority business messages: financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented.

This mode sends Boss's summary to `WesWill@BuyYourHomeLLC.com`, Jenny's summary to `Jenny@BuyYourHomeLLC.com`, and Josh's summary to `IRAManager@SellYourHomeRaleigh.com` with Wes copied, from `OfficeAssist@BuyYourHomeLLC.com`. Josh's summary includes a `Manager Tasks` section read from the Manager task register. It groups tasks by Manager status and orders each group by `Critical`, `High`, `Normal`, then `Low`; Email Monitor does not edit that register. The Email Monitor workflow owns scanning, cutoff logic, priority selection, summary drafting, usage-section inclusion, attachment decisions, and state updates. The shared `email-delivery` skill owns the send step, OfficeAssist sender safety, and Sent Items verification.

This mode runs only once per calendar day per recipient at the first eligible heartbeat at or after 8:00 AM Eastern. Later same-day heartbeat runs skip summaries that were already sent and verified.

### Email Delivery

Use this mode when this project room has an authorized email ready to send or when another Email Monitor mode reaches its send step.

This mode is connected directly to `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`. The calling Email Monitor workflow owns the approved recipients, subject, plain-text body, required attachments, and workflow-specific restrictions. The Email Delivery mode owns OfficeAssist sender safety, the Outlook connector shared/delegated mailbox send action, attachment-path validation and connector parameter-shape handling, Sent Items verification, delivery logging, local Outlook fallback, and failure reporting.

For a connector send, use `OfficeAssist@BuyYourHomeLLC.com`, enable Sent Items saving, pass structured recipient objects, and pass attachments as a list of absolute local paths. After sending, verify the expected subject, recipients, CC recipients, sender, and attachment flag in OfficeAssist Sent Items, then record the sent message id, sent timestamp, and verification result in the calling workflow's log. Make only one schema-correct retry when the first error clearly identifies the correction. A failed send or unverified send must be reported immediately.

This mode does not invent recipients, message content, attachment requirements, or authorization. It does not send without required attachments unless the calling workflow explicitly allows that fallback.

### Gracious Millionaire Email Routing

Use this mode when the Email Monitor workflow or OfficeAssist instruction monitor sees an email with a subject containing `gracious millionaire`, or an email that otherwise clearly belongs to the Gracious Millionaire book/project-room workflow.

This mode routes the email into `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\` as source material, preserves it as Markdown under `sources\email\`, updates Gracious Millionaire intake/source records when required by that room's rules, records the Outlook message id in Email Monitor memory, and sends a direct follow-up message to the existing Gracious Millionaire project-room thread with the routed source path and a short summary.

This mode does not draft, edit, or send the requested Gracious Millionaire book response from the Email Monitor or OfficeAssist monitor thread unless Wes explicitly asks for processing here. It also does not attach mailbox checking to the Gracious Millionaire heartbeat or create a new Gracious Millionaire chat.

### Brynda Suit Email Routing

Use this mode when the Email Monitor workflow or OfficeAssist instruction monitor sees an email from Wes or Jenny with a subject containing `brynda suit`, or an email that otherwise clearly belongs to the Brynda Suit workflow.

This mode routes the email into `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\` as source material, preserves it as Markdown under `sources\email\`, updates the Brynda Suit source inventory when the routed email becomes part of the durable source set, records the Outlook message id in Email Monitor memory, and sends a direct follow-up message to the existing Brynda Suit task with the routed source path, a short summary, and the instruction to wake up and respond.

This mode does not draft, edit, or send the requested Brynda Suit response from the Email Monitor or OfficeAssist monitor thread unless Wes explicitly asks for processing here. It also does not create a new Brynda Suit task.

## Authoritative Sources

- `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md`
- `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`

## Development Boundary

Use this room for development and design work. Do not change the live automation id, schedule, target thread, sender, recipient, or mailbox scope without a specific instruction from Wes.

When the workflow changes, update the skill, this project room, and the registry together.

## Change Log

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
