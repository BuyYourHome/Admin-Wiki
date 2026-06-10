---
name: cfd-email-package-delivery
description: Use only when the Contract for Deed skill calls for Email Package delivery to Wes for review. Sends or prepares CFD closing-package review emails through OfficeAssist sender-safety rules, attachment checks, and sent-item verification; does not determine package contents.
---

# CFD Email Package Delivery

## Scope

Use this skill only as a support skill for Contract for Deed `Email Package` mode. Contract for Deed remains responsible for confirming the project and buyer, building the package, identifying the current Closing Checklist, and deciding which files belong in the package.

This skill only handles safe delivery of that already-compiled package email.

## Recipient And Sender Rules

- Send the CFD package email to `WesWill@BuyYourHomeLLC.com` only so Wes can review and forward it himself.
- Send from `OfficeAssist@BuyYourHomeLLC.com`.
- Do not send the CFD package email directly to buyers, attorneys, agents, Jenny, outside parties, or any other recipient unless Wes later creates a separate explicit rule changing this restriction.
- Use a subject beginning with `DRAFT:` unless Wes provides a different review-submission subject for that specific run.
- Do not say the message is "on Wes's behalf" unless Wes explicitly asks for that wording for that specific message.

## Package Completeness

Before sending:

1. Use the Closing Checklist content supplied by the Contract for Deed workflow as the email body.
2. Attach every file listed in the Closing Checklist.
3. Verify each listed attachment exists and is readable.
4. If any listed file is missing or cannot be attached, do not send the email. Report the missing file and provide the proposed email body in the chat.

## Preferred Send Path

Prefer the Outlook/email connector when it can perform the needed sender and delivery verification:

1. Create or verify the message as a draft stored in `OfficeAssist@BuyYourHomeLLC.com` Drafts.
2. Confirm the visible sender/from identity is `OfficeAssist@BuyYourHomeLLC.com`.
3. Send the message.
4. Verify the sent copy appears in `OfficeAssist@BuyYourHomeLLC.com` Sent Items.

A connector-verified OfficeAssist Drafts item followed by a connector-verified OfficeAssist Sent Items record is an acceptable production send path even if the OfficeAssist mailbox root is not mounted in local Outlook on that computer.

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
- Do not send a partial package.
- Notify Wes in the chat with the blocker and the proposed email body.
- Do not send correction emails or retries without Wes's explicit instruction.
