---
name: email-monitor
description: Create Wes's and Jenny's daily OfficeAssist morning mailbox summaries for Buy Your Home. Use when Codex needs to scan `WesWill@BuyYourHomeLLC.com` or `Jenny@BuyYourHomeLLC.com`, apply the stored cutoff, select priority unread or newly received business messages across Inbox and rule-routed folders, draft the plain-text morning summary, and hand Wes's send step to `email-delivery`.
---

# Email Monitor

## Overview

Create the daily Boss summary for `WesWill@BuyYourHomeLLC.com`, then hand off delivery to the shared `email-delivery` skill. Create the daily Jenny summary for `Jenny@BuyYourHomeLLC.com`, then hand off delivery to the shared `email-delivery` skill for sending to Jenny from OfficeAssist.

This skill owns mailbox scanning, cutoff selection, message prioritization, summary drafting, usage-summary inclusion, and summary-run state updates. It does not own sender safety or send verification.

Development notes, source inventory, and open questions for this workflow live in `C:\Codex\Wiki Files\Project Rooms\Email Monitor\`.

## Inputs

Before using this skill, have:

- the global profile at `C:\Codex\Office Assistant Profile.md`,
- the admin rules in `C:\Codex\Wiki Files\AGENTS.md`,
- the automation memory file for this workflow at `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`,
- access to `WesWill@BuyYourHomeLLC.com` mailbox contents,
- access to `Jenny@BuyYourHomeLLC.com` mailbox contents when running Jenny's summary,
- access to `C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1` when usage totals are needed.

## Workflow

1. Read `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` and find the last verified Boss summary send time and the last verified Jenny summary send time.
2. Use that verified send time as the cutoff unless a newer verified Boss summary is already present in `OfficeAssist@BuyYourHomeLLC.com` Sent Items for the same day.
3. Use the last verified Jenny summary send time as Jenny's cutoff unless a newer Jenny summary is already recorded in the memory file for the same day. If there is no prior Jenny summary record, use the 2026-06-29 resume timestamp as the initial new-mail cutoff.
4. Scan only the intended mailbox for the current summary: `WesWill@BuyYourHomeLLC.com` for Boss, or `Jenny@BuyYourHomeLLC.com` for Jenny.
5. Review the entire mailbox recursively, including Inbox and rule-routed subfolders.
6. Focus on:
   - unread messages, and
   - newly received messages after the cutoff.
7. Keep only messages that are financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented.
8. Exclude routine promotional, automated, and newsletter traffic unless it is time-sensitive, financial, legal, property-related, or requires action.
9. Keep older unread items in scope when they are still priority business items. For Jenny's first resumed run, avoid treating the entire historic unread backlog as new.

## Modes

### Daily Email Summary Mode

Use Daily Email Summary Mode for the once-daily Boss and Jenny Outlook mailbox summaries.

This mode owns mailbox scanning, cutoff selection, priority selection, summary drafting, usage-summary inclusion, attachment decision, and summary-run state updates for:

- Boss summary mailbox: `WesWill@BuyYourHomeLLC.com`;
- Boss summary recipient: `WesWill@BuyYourHomeLLC.com`;
- Jenny summary mailbox: `Jenny@BuyYourHomeLLC.com`;
- Jenny summary recipient: `Jenny@BuyYourHomeLLC.com`;
- sender for both summaries: `OfficeAssist@BuyYourHomeLLC.com`.

Activation:

- run once per calendar day at the 8:00 AM Eastern heartbeat run, or the first run after 8:00 AM Eastern if the 8:00 AM run was missed;
- skip a same-day summary when that recipient's summary has already been sent and verified for the calendar day;
- later same-day heartbeat runs use instruction-email monitoring and routing modes only unless a summary send or verification failure still needs attention.

Cutoff and mailbox scan:

- read `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`;
- use the last verified Boss summary send time as the Boss cutoff unless a newer verified Boss summary is already present in `OfficeAssist@BuyYourHomeLLC.com` Sent Items for the same day;
- use the last verified Jenny summary send time as Jenny's cutoff unless a newer Jenny summary is already recorded in memory for the same day;
- if no prior Jenny summary record exists, use the 2026-06-29 resume timestamp as Jenny's initial new-mail cutoff;
- scan only the intended mailbox for the current summary;
- review the entire mailbox recursively, including Inbox and rule-routed subfolders;
- focus on unread messages and newly received messages after the cutoff;
- include older unread messages only when they are still priority business items, and do not treat Jenny's historic unread backlog as new.

Priority selection:

- keep financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented messages;
- prefer same-day deadlines, fraud or banking actions, invoices, insurance issues, title or closing items, property operations, direct human follow-ups, and vendor/admin items with due dates, money movement, or approvals needed;
- exclude routine promotional, automated, and newsletter traffic unless it is time-sensitive, financial, legal, property-related, or requires action.

Summary body:

- include the mailbox scanned, cutoff used, priority items, low-priority exclusions when applicable, and a clear note if no priority messages were found;
- include the Codex usage section from `C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1` when reliable totals are available;
- use the same day and week wall-clock total-time and token totals in both Boss and Jenny summaries;
- sign as `Jean Wright` / `Office Assistant`;
- do not say the email is on Wes's behalf unless the actual sending identity requires that wording.

Delivery handoff:

- hand the send step to `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`;
- pass sender, recipient, subject, plain-text body, attachment paths if any, and the rule that send or verification failure must be reported in the OfficeAssist thread;
- let `email-delivery` handle Outlook connector preference, sender safety, attachment input format, Sent Items verification, local Outlook fallback, and failure reporting;
- if the summary cannot be sent or verified, notify Wes immediately in the OfficeAssist thread and use the available text/SMS fallback when one is available.

State update:

- after a successful verified send, update the automation memory with the summary date or subject, cutoff used, topics sent, verified send timestamp from OfficeAssist Sent Items, and any unusual routing, blocker, or verification-draft note;
- if mailbox access, token-summary generation, send, or verification fails, record the blocker and action taken;
- do not treat a failed summary run as quiet.

### Gracious Millionaire Email Routing Mode

Use Gracious Millionaire Email Routing Mode when the Email Monitor workflow or OfficeAssist instruction monitor sees an email that belongs to Gracious Millionaire.

This mode owns source routing and direct project-room handoff only. It does not own Gracious Millionaire manuscript processing, book-response drafting, external email sending, or mailbox monitoring from the Gracious Millionaire project-room heartbeat.

Activation:

- the email subject contains `gracious millionaire`; or
- the email otherwise clearly belongs to the Gracious Millionaire book/project-room workflow.

For each routed email:

- preserve the email as its own Markdown source file under `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\sources\email\`;
- include sender, recipients, sent time when available, received time, subject, Outlook message id or web link when available, and body text;
- use a stable, filesystem-safe filename that starts with the email date/time and a short subject slug;
- update `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\officeassist-intake-log.md` when the current Gracious Millionaire project-room rules require the intake ledger;
- update `C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire\working\source-inventory.md` when the routed source becomes part of the durable source inventory;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing Gracious Millionaire project-room thread with the routed source path and a short summary of the email.

Direct message handoff is the primary trigger for Gracious Millionaire project-room processing. The `gracious-millionaire-project-room-heartbeat` remains only a backup processor for files that have already been routed into the project room.

Current Gracious Millionaire project-room thread id: `019eb9b0-6780-7fb3-a278-29a18d17998c`.

Do not attach mailbox checking to the Gracious Millionaire heartbeat. Do not create a new Gracious Millionaire chat. Do not draft, edit, or send the requested book response from this Email Monitor or OfficeAssist monitor thread unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

### Web Site Email Routing Mode

Use Web Site Email Routing Mode when the Email Monitor workflow or OfficeAssist instruction monitor sees an instruction email from Wes or Jenny that belongs to REI BlackBook website work.

This mode owns source routing and direct REI BlackBook project-room handoff only. It does not own live REI BlackBook website editing, browser automation, public-site publishing, external email sending, or creating a new REI BlackBook chat.

Activation:

- the email subject contains `GM Site`; or
- the email otherwise clearly belongs to REI BlackBook WebTools Sites or Gracious Millionaire website workflow.

For each routed email:

- preserve the email as its own Markdown source file under `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\sources\email\`;
- include sender, recipients, sent time when available, received time, subject, Outlook message id or web link when available, and body text;
- use a stable, filesystem-safe filename that starts with the email date/time and a short subject slug;
- update `C:\Codex\Wiki Files\Project Rooms\REI BlackBook\working\source-inventory.md` when the routed email becomes part of the durable source set;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing REI Blackbook project-room thread with the routed source path, a short summary of the email, and the instruction to process the website request.

Current REI Blackbook project-room thread id: `019f4691-5466-7f72-9683-ab5d3b750c25`.

Do not create a new REI Blackbook chat for this routing unless Wes explicitly asks. Do not process the REI BlackBook website request from this Email Monitor or OfficeAssist monitor thread unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

### Brynda Suit Email Routing Mode

Use Brynda Suit Email Routing Mode when the Email Monitor workflow or OfficeAssist instruction monitor sees an instruction email from Wes or Jenny that belongs to Brynda Suit.

This mode owns source routing and direct Brynda Suit task handoff only. It does not own Brynda Suit response drafting, external email sending, or creating a new Brynda Suit task.

Activation:

- the email subject contains `brynda suit`; or
- the email otherwise clearly belongs to the Brynda Suit workflow.

For each routed email:

- preserve the email as its own Markdown source file under `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\sources\email\`;
- include sender, recipients, sent time when available, received time, subject, Outlook message id or web link when available, and body text;
- use a stable, filesystem-safe filename that starts with the email date/time and a short subject slug;
- update `C:\Codex\Wiki Files\Project Rooms\Brynda Suit\working\source-inventory.md` when the routed email becomes part of the durable source set;
- record the routed Outlook message id in this workflow's monitor memory so the same email is not routed repeatedly;
- send a direct follow-up message to the existing Brynda Suit task with the routed source path, a short summary of the email, and the instruction to wake up and respond to the email.

Current Brynda Suit task id: `019f61c3-d4c0-7a52-a5a0-e4066ea9b303`.

Do not create a new Brynda Suit task for this routing unless Wes explicitly asks. Do not process the Brynda Suit response from this Email Monitor or OfficeAssist monitor thread unless Wes explicitly asks for processing here. The default action is source routing plus direct project-room handoff only.

## Priority Selection

Prefer these message classes in the summary:

- same-day deadlines or fraud/banking actions,
- legal bills, invoices, insurance issues, or title/closing items,
- property-specific operational issues,
- direct human follow-ups that block work,
- vendor/admin items with due dates, money movement, or approvals needed.

Do not pad the summary with low-signal marketing mail just because it is unread.

## Usage Section

Before finalizing the summary body, run:

`powershell -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1"`

Use the helper's JSON output to include a usage section in every daily summary email, both Boss and Jenny:

- yesterday total wall-clock process time from `yesterday.elapsed.human`,
- week-to-date total wall-clock process time from `week_to_date.elapsed.human`,
- yesterday total tokens,
- week-to-date total tokens,
- rate-limit remaining percentages,
- weekly token budget remaining only when `configured` is true.

Lead this section with total wall-clock time. Tokens and rate-limit details are secondary.

If the helper fails or returns unreliable totals, state that usage totals were unavailable. Do not estimate them.

## Summary Body

Write a concise plain-text email to Boss.

Include:

- the cutoff used,
- a short priority list ordered by urgency,
- the usage section,
- a one-line note that low-priority promotional/newsletter traffic was excluded when applicable,
- signature as `Jean Wright` / `Office Assistant`.

Do not say the email is on Wes's behalf unless the actual sending identity requires that wording.

For Jenny's summary, write a concise plain-text email to Jenny. Include the mailbox scanned, cutoff used, priority items, low-priority exclusions when applicable, and a clear note if no priority messages were found.

Also include the usage section in Jenny's daily summary, using the same day and week wall-clock total-time and token totals included in Boss's summary.

## Attachment Decision

Default to no attachments.

Only include attachments when the workflow specifically requires them and the exact files are already known. This skill decides whether attachments are needed, but it does not perform attachment-upload logic itself.

## Delivery Handoff

For Boss's send step, call the shared `email-delivery` skill and pass:

- sender: `OfficeAssist@BuyYourHomeLLC.com`,
- recipient: `WesWill@BuyYourHomeLLC.com`,
- subject,
- plain-text body,
- attachment paths if any,
- the rule that send or verification failure must be reported in the OfficeAssist thread.

Let `email-delivery` handle Outlook connector preference, sender safety, attachment input format, Sent Items verification, local Outlook fallback, and failure reporting.

For Jenny's send step, call the shared `email-delivery` skill and pass:

- sender: `OfficeAssist@BuyYourHomeLLC.com`,
- recipient: `Jenny@BuyYourHomeLLC.com`,
- subject,
- plain-text body,
- attachment paths if any,
- the rule that send or verification failure must be reported in the OfficeAssist thread.

Jenny's summary is emailed to Jenny under the current global profile unless Wes explicitly changes the routing.

## Failure Handling

If mailbox access, token-summary generation, or message selection is blocked before handoff, notify Wes in the OfficeAssist thread with:

- what failed,
- the summary draft if one was generated,
- what action was or was not taken.

Do not treat a failed summary run as quiet.

## State Update

After a successful verified Boss send, update the automation memory with:

- the subject,
- the cutoff used,
- the summary topics sent,
- the verified send timestamp from OfficeAssist Sent Items,
- any note about a verification draft remaining in OfficeAssist Drafts.

After a successful verified Jenny send, update the automation memory with:

- the summary date,
- the cutoff used,
- the summary topics sent,
- the verified send timestamp from OfficeAssist Sent Items,
- any mailbox-access blocker or unusual routing note.

If the send fails or verification fails, record the blocker and the action taken.

Use `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md` as the persistent run memory unless Wes explicitly changes the live automation storage location.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
