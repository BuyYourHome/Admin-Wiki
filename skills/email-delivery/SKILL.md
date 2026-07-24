---
name: email-delivery
description: Use when an Admin wiki workflow needs to send or prepare an email from OfficeAssist@BuyYourHomeLLC.com with Outlook connector preference, sender safety, attachment handling, sent-item verification, and failure reporting. Intended as a shared support skill for workflows such as Contract for Deed Email Package and Email Monitor; it does not decide the workflow-specific email content.
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

## Outlook Connector Send Logistics

When sending from `OfficeAssist@BuyYourHomeLLC.com`, prefer the Outlook Email connector shared/delegated mailbox send action.

Use these values when the action supports them:

- mailbox or user principal name: `OfficeAssist@BuyYourHomeLLC.com`;
- save to sent items: `true`;
- `to`, `cc`, and `bcc`: structured recipient objects with `email` and optional `name`;
- subject: a plain subject string;
- body: plain text;
- attachments: an array or list of absolute local file paths, even when the connector schema appears to describe the field as a string.

For attachments:

1. Verify every attachment path exists and is readable before sending.
2. Prefer one combined PDF when the calling workflow produces several related attachments for the same email.
3. If the connector rejects `attachment_files` as a string, retry with `attachment_files` as a list of absolute paths.
4. If the connector rejects a list, retry only when the tool error clearly identifies the expected shape.
5. Do not send without required attachments unless the calling workflow explicitly allows a no-attachment fallback.
6. If required attachments exceed the current connector's direct-attachment size limit, do not silently substitute SharePoint links, compressed/reduced files, split packages, or a no-attachment email. Use a verified OfficeAssist-capable alternate path if one exists; otherwise stop and report the unresolved blocker with the proposed email body, recipients, and attachment paths.

After sending:

1. Query `OfficeAssist@BuyYourHomeLLC.com` Sent Items through the shared-mailbox connector.
2. Verify that a sent message exists with the expected subject, recipients, CC recipients, sender, and attachment flag.
3. Record the sent message id, sent timestamp, and verification result in the calling workflow's log.
4. If Sent Items verification fails, report the blocker immediately and do not assume delivery succeeded.

If the first connector send attempt fails because of parameter shape, attachment handling, or mailbox-send semantics, make one schema-correct retry only when the error clearly explains the correction. If that retry fails, stop and report the proposed email body, recipients, sender, and attachment paths.

## Attachments

- Verify each caller-provided attachment path exists and is readable before sending.
- For connector send tools, follow the `Outlook Connector Send Logistics` attachment-shape and retry rules above.
- Do not use newline-separated attachment paths unless the specific connector tool documents and accepts that format in the current session.
- If an attachment cannot be uploaded, do not silently omit it. Stop, report the failed attachment, and provide the proposed email body in the chat unless the caller explicitly allows a no-attachment send.

## Local Outlook Fallback

Use local Outlook only when the Outlook/email connector cannot perform the needed send or verification step.

Before sending through local Outlook:

- Create or save the draft under the `OfficeAssist@BuyYourHomeLLC.com` Drafts folder.
- Verify the saved draft is physically stored in the OfficeAssist Drafts folder.
- Verify the visible sender/from identity is `OfficeAssist@BuyYourHomeLLC.com`.
- If `OfficeAssist@BuyYourHomeLLC.com` is not mounted as a local Outlook mailbox store, local Outlook is not a safe fallback for OfficeAssist delivery. Do not send or leave a draft from another mailbox; report that a verified OfficeAssist-capable send path or explicit alternate-package authorization is required.

Outlook may leave `SendUsingAccount` blank after save/reopen. A blank value is acceptable only when the draft is in the OfficeAssist Drafts folder and the visible sender/from identity is OfficeAssist. If Outlook shows a non-blank sending account other than `OfficeAssist@BuyYourHomeLLC.com`, or if the draft is stored in any other mailbox, do not send automatically.

## Failure Handling

If sender verification fails, the email cannot be sent, an attachment is missing, or the OfficeAssist Sent Items record cannot be verified:

- Do not leave a silent Outlook draft for later manual sending.
- Do not send a partial or altered message unless the caller explicitly approves that fallback.
- Notify Wes in the chat with the blocker and the proposed email body.
- Do not send correction emails or retries without Wes's explicit instruction.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
