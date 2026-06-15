---
name: officeassist-morning-email-summary
description: Create Wes's daily OfficeAssist morning mailbox summary for Buy Your Home. Use when Codex needs to scan `WesWill@BuyYourHomeLLC.com`, apply the stored cutoff, select priority unread or newly received business messages across Inbox and rule-routed folders, draft the plain-text morning summary, and hand the send step to `email-delivery`.
---

# OfficeAssist Morning Email Summary

## Overview

Create the daily Boss summary for `WesWill@BuyYourHomeLLC.com`, then hand off delivery to the shared `email-delivery` skill.

This skill owns mailbox scanning, cutoff selection, message prioritization, summary drafting, token-summary inclusion, and summary-run state updates. It does not own sender safety or send verification.

Development notes, source inventory, and open questions for this workflow live in `C:\Codex\Wiki Files\Project Rooms\Email Summary\`.

## Inputs

Before using this skill, have:

- the global profile at `C:\Codex\Office Assistant Profile.md`,
- the admin rules in `C:\Codex\Wiki Files\AGENTS.md`,
- the automation memory file for this workflow,
- access to `WesWill@BuyYourHomeLLC.com` mailbox contents,
- access to `C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1` when token totals are needed.

## Workflow

1. Read the automation memory file and find the last verified Boss summary send time.
2. Use that verified send time as the cutoff unless a newer verified Boss summary is already present in `OfficeAssist@BuyYourHomeLLC.com` Sent Items for the same day.
3. Scan only `WesWill@BuyYourHomeLLC.com`.
4. Review the entire mailbox recursively, including Inbox and rule-routed subfolders.
5. Focus on:
   - unread messages, and
   - newly received messages after the cutoff.
6. Keep only messages that are financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented.
7. Exclude routine promotional, automated, and newsletter traffic unless it is time-sensitive, financial, legal, property-related, or requires action.
8. Keep older unread items in scope when they are still priority business items.

## Priority Selection

Prefer these message classes in the summary:

- same-day deadlines or fraud/banking actions,
- legal bills, invoices, insurance issues, or title/closing items,
- property-specific operational issues,
- direct human follow-ups that block work,
- vendor/admin items with due dates, money movement, or approvals needed.

Do not pad the summary with low-signal marketing mail just because it is unread.

## Token Section

Before finalizing the summary body, run:

`powershell -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\get-codex-token-summary.ps1"`

Use the helper's JSON output to include:

- yesterday total tokens,
- week-to-date total tokens,
- rate-limit remaining percentages,
- weekly token budget remaining only when `configured` is true.

If the helper fails or returns unreliable totals, state that token totals were unavailable. Do not estimate them.

## Summary Body

Write a concise plain-text email to Boss.

Include:

- the cutoff used,
- a short priority list ordered by urgency,
- the token section,
- a one-line note that low-priority promotional/newsletter traffic was excluded when applicable,
- signature as `Jean Wright` / `Office Assistant`.

Do not say the email is on Wes's behalf unless the actual sending identity requires that wording.

## Attachment Decision

Default to no attachments.

Only include attachments when the workflow specifically requires them and the exact files are already known. This skill decides whether attachments are needed, but it does not perform attachment-upload logic itself.

## Delivery Handoff

For the send step only, call the shared `email-delivery` skill and pass:

- sender: `OfficeAssist@BuyYourHomeLLC.com`,
- recipient: `WesWill@BuyYourHomeLLC.com`,
- subject,
- plain-text body,
- attachment paths if any,
- the rule that send or verification failure must be reported in the OfficeAssist thread.

Let `email-delivery` handle Outlook connector preference, sender safety, attachment input format, Sent Items verification, local Outlook fallback, and failure reporting.

## Failure Handling

If mailbox access, token-summary generation, or message selection is blocked before handoff, notify Wes in the OfficeAssist thread with:

- what failed,
- the summary draft if one was generated,
- what action was or was not taken.

Do not treat a failed summary run as quiet.

## State Update

After a successful verified send, update the automation memory with:

- the subject,
- the cutoff used,
- the summary topics sent,
- the verified send timestamp from OfficeAssist Sent Items,
- any note about a verification draft remaining in OfficeAssist Drafts.

If the send fails or verification fails, record the blocker and the action taken.
