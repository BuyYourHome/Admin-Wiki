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

## Delegated Authorization

Apply `Project Room Delegation Contract.md`, section `Email Delivery Authorization Evidence`, before sending. Read the verified originating instruction into the receiving task's execution context and preserve exact denial evidence. Do not infer that an external recipient or cross-task handoff always requires fresh permission. Actual platform denials remain controlling and must not be bypassed.

Another registered Project Room may carry Wes's authorization into Email Monitor through a complete, verifiable Email Delivery package. Do not require Wes to repeat the same authorization inside the Email Monitor task when all of these conditions pass:

1. The source Project Room and exact source task are registered and authorized for the workflow.
2. Email Monitor retrieves the authoritative central record or durable delivery package instead of relying only on inter-task message text.
3. The source identity, destination identity, delivery request ID, dispatch ID when applicable, and payload hash match exactly.
4. The immutable package contains the unique delivery request ID, origin Project Room and task ID, authorization basis, applicable Wes instruction or canonical standing authorization, sender, exact To/CC/BCC recipients, exact subject and plain-text body, exact attachment paths and required status, workflow restrictions, and callback Project Room and task ID.
5. The requested send remains within the cited authority.
6. No prior successful or unresolved ambiguous send exists for the same delivery request ID and payload hash.

Recognized authorization sources are an exact Wes instruction preserved by the originating Project Room, a documented standing workflow rule that expressly requires the email, or a previously authorized workflow whose required next step is the specified email delivery. An originating Project Room cannot manufacture authority merely by stating that a send is authorized. Verify the cited instruction or standing rule and confirm that the package does not broaden it. Dispatcher notifications provide transport only and never create authority.

Stop and request Wes only when authorization is absent, unverifiable, ambiguous, or narrower than the requested send; the source or destination identity is wrong; the immutable payload changed; the recipients, subject, body, or attachments materially differ; a required recipient or attachment is unknown; the action includes payment, legal approval, account changes, filing approval, or another Wes-reserved decision; or a possibly submitted connector result cannot be resolved through Sent Items. Do not impose a new direct-in-Email-Monitor confirmation merely because valid authorization originated in another registered Project Room.

### Tim Fleming Standing Authorization

Invoice Entry's canonical Time Card rule provides standing authorization for each meaningful Tim Fleming time update to produce and send one refreshed accuracy-review draft to Tim at his established verified address, with `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com` copied. A no-correction response from Tim or Wes confirms factual correctness; a correction from either requires a revised draft. Jenny is copied for visibility only. No response at this stage authorizes payment, filing, posting, finalization, or paid status, and only Wes may approve the final invoice after the weekly pay period closes. A complete immutable package from the registered Invoice Entry task that matches this rule does not require another direct authorization inside Email Monitor.

### Josh And Final Time Card Deliveries

Josh Kennedy's canonical Invoice Entry Time Card rule also supplies standing authority for meaningful updated accuracy-review drafts to his verified recipient address with Wes and Jenny copied, and the prescribed closed-period approval package to Wes. Final approved Tim and Josh invoice copies to Wes and Jenny follow Invoice Entry's approved-invoice rule. Verify each exact package against the relevant rule and period; draft delivery never grants final invoice or payment approval.

## Exactly-Once Delivery

Before sending, deduplicate by both delivery request ID and payload hash, check the durable delivery record, and search OfficeAssist Sent Items for the exact package. If a prior attempt definitively failed before connector submission, record it as `NotDelivered`; the same immutable request may be retried under its existing verified authorization. If connector submission may have occurred, record the attempt as ambiguous and do not retry until Sent Items resolves whether it was sent. After sending, verify the OfficeAssist sender, exact recipients, subject, required attachments, and Sent Items copy, then record one final success or unresolved failure and return it to the callback task.

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

### Temporary Email Monitor WesWill Fallback

For Email Monitor on the current computer, `OfficeAssist@BuyYourHomeLLC.com` is never mounted in local Outlook. Wes has authorized this narrower temporary fallback:

- use it only when the connector is definitively unavailable before sending and the workflow can prove no connector send occurred;
- use only the locally mounted `WesWill@BuyYourHomeLLC.com` mailbox; never use `Wes@myBrowning.net`;
- preserve the caller-authorized To, CC, BCC, subject, body, attachments, and restrictions;
- sign as `Jean Wright` / `Office Assistant`;
- add a plain disclosure that the message was sent by Jean Wright using Wes Browning's mailbox because OfficeAssist was unavailable;
- save to and verify the result in `WesWill@BuyYourHomeLLC.com` Sent Items;
- report the requested OfficeAssist sender and the actual verified WesWill fallback sender in the delivery result;
- record the substitution and reason in Email Monitor compact state and the seven-day rolling log.

Do not use this fallback after a connector send attempt might have succeeded, after ambiguous connector output, or after connector Sent Items verification fails. Those states remain unresolved until reconciled because a second send could create a duplicate. This authorization is temporary and should be removed after Jean's dedicated computer provides verified direct local OfficeAssist access.

Before sending through local Outlook:

- Create or save the draft under the `OfficeAssist@BuyYourHomeLLC.com` Drafts folder.
- Verify the saved draft is physically stored in the OfficeAssist Drafts folder.
- Verify the visible sender/from identity is `OfficeAssist@BuyYourHomeLLC.com`.
- Except for the temporary Email Monitor WesWill fallback above, if `OfficeAssist@BuyYourHomeLLC.com` is not mounted as a local Outlook mailbox store, local Outlook is not a safe fallback for OfficeAssist delivery. Do not send or leave a draft from another mailbox; report that a verified OfficeAssist-capable send path or explicit alternate-package authorization is required.

Outlook may leave `SendUsingAccount` blank after save/reopen. A blank value is acceptable only when the draft is in the OfficeAssist Drafts folder and the visible sender/from identity is OfficeAssist. If Outlook shows a non-blank sending account other than `OfficeAssist@BuyYourHomeLLC.com`, or if the draft is stored in any other mailbox, do not send automatically.

## Failure Handling

If sender verification fails, the email cannot be sent, an attachment is missing, or the OfficeAssist Sent Items record cannot be verified:

- Do not leave a silent Outlook draft for later manual sending.
- Do not send a partial or altered message unless the caller explicitly approves that fallback.
- Notify Wes in the chat with the blocker and the proposed email body.
- Do not send a correction email. Retry only when the prior attempt is proven `NotDelivered` before connector submission and the same immutable package remains authorized, or when Wes explicitly directs a different authorized action. Never retry an ambiguous or possibly submitted send.

## Change Log

- 2026-09-16: Added durable delegated authorization, exact authority verification, Tim Fleming standing accuracy-review authority, and request-ID-plus-payload-hash exactly-once retry rules without changing sender, recipient, attachment, Sent Items, or Wes-reserved decision controls.
## Start PR Pointer

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
