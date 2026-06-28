---
name: email-delivery
description: Use when an Admin wiki workflow needs to send or prepare an email from OfficeAssist@BuyYourHomeLLC.com with Outlook connector preference, sender safety, attachment handling, sent-item verification, and failure reporting. Intended as a shared support skill for workflows such as Contract for Deed Email Package and Email Summary; it does not decide the workflow-specific email content.
---

# Email Delivery

## Scope

Use this as a shared support skill for OfficeAssist email delivery. The calling workflow remains responsible for deciding the email purpose, recipients, subject, body, attachments, and any workflow-specific restrictions.

This skill only handles sender safety, Outlook connector preference, attachment input handling, sent-item verification, and failure reporting.

## Caller Responsibilities

Before calling this skill, the calling workflow must provide:

- sender mailbox, normally `OfficeAssist@BuyYourHomeLLC.com`,
- approved recipient list,
- subject,
- plain-text body,
- attachment paths, if any,
- any workflow-specific restrictions, such as `send to Wes only` or `do not attach partial packages`.

Do not use this skill to invent recipients, summarize source material, choose package contents, or decide whether an external party should receive a message.

## Sender And Recipient Safety

- Send from `OfficeAssist@BuyYourHomeLLC.com` when acting as Jean or Office Assistant unless Wes explicitly names another sender for that specific message.
- Do not say the message is "on Wes's behalf" unless Wes explicitly asks for that wording for that specific message or the actual sending identity is a delegated/on-behalf-of Wes identity.
- For OfficeAssist emails concerning Wes's business or requested by Wes, copy or send to `WesWill@BuyYourHomeLLC.com` unless the calling workflow has a stricter rule or Wes explicitly says not to copy himself for that specific message.
- Do not add recipients, CC, or BCC beyond the approved caller-provided list.
- If the caller's recipient instructions conflict with a stricter workflow rule, stop and ask Wes.

## Preferred Send Path

Prefer the Outlook/email connector when it can perform the needed sender and delivery verification:

1. Use the exact shared/delegated mailbox address supplied by the caller.
2. Send from `OfficeAssist@BuyYourHomeLLC.com` with Sent Items saving enabled when the connector supports it.
3. Verify the sent copy appears in `OfficeAssist@BuyYourHomeLLC.com` Sent Items.

When the connector exposes a draft-first shared-mailbox path, create or verify the message as a draft stored in `OfficeAssist@BuyYourHomeLLC.com` Drafts before sending, then verify the sent copy in Sent Items. A connector-verified OfficeAssist Drafts item followed by a connector-verified OfficeAssist Sent Items record is an acceptable production send path even if the OfficeAssist mailbox root is not mounted in local Outlook on that computer.

If the connector can send from the exact OfficeAssist shared mailbox and verify the OfficeAssist Sent Items record, that satisfies the sender verification requirement even when no draft-first shared-mailbox tool is available.

## Attachments

- Verify each caller-provided attachment path exists and is readable before sending.
- For connector send tools, pass attachment paths in the input shape the connector currently requires. If the connector rejects a plain path string and reports that it expects an array, retry with an attachment-path array.
- Do not use newline-separated attachment paths unless the specific connector tool documents and accepts that format in the current session.
- If an attachment cannot be uploaded, do not silently omit it. Stop, report the failed attachment, and provide the proposed email body in the chat unless the caller explicitly allows a no-attachment send.

## Local Outlook Fallback

Use local Outlook only when the Outlook/email connector cannot perform the needed send or verification step.

Before sending through local Outlook:

- Create or save the draft under the `OfficeAssist@BuyYourHomeLLC.com` Drafts folder.
- Verify the saved draft is physically stored in the OfficeAssist Drafts folder.
- Verify the visible sender/from identity is `OfficeAssist@BuyYourHomeLLC.com`.

Outlook may leave `SendUsingAccount` blank after save/reopen. A blank value is acceptable only when the draft is in the OfficeAssist Drafts folder and the visible sender/from identity is OfficeAssist. If Outlook shows a non-blank sending account other than `OfficeAssist@BuyYourHomeLLC.com`, or if the draft is stored in any other mailbox, do not send automatically.

## Failure Handling

If sender verification fails, the email cannot be sent, an attachment is missing, or the OfficeAssist Sent Items record cannot be verified:

- Do not leave a silent Outlook draft for later manual sending.
- Do not send a partial or altered message unless the caller explicitly approves that fallback.
- Notify Wes in the chat with the blocker and the proposed email body.
- Do not send correction emails or retries without Wes's explicit instruction.
