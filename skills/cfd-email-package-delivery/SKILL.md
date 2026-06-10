---
name: cfd-email-package-delivery
description: Use only when the Contract for Deed skill calls for Email Package delivery to Wes for review. Sends or prepares CFD closing-package review emails through OfficeAssist sender-safety rules, attachment checks, and sent-item verification; does not determine package contents.
---

# CFD Email Package Delivery

## Scope

Use this skill only as a support skill for Contract for Deed `Email Package` mode. Contract for Deed remains responsible for confirming the project and buyer, building the package, identifying the current Closing Checklist, and deciding which files belong in the package.

This skill only handles safe delivery of that already-compiled package email.

After preparing the CFD package-specific email body and ZIP attachment, call/use `officeassist-email-delivery` for OfficeAssist sender safety, Outlook connector handling, Sent Items verification, local Outlook fallback rules, and failure handling.

## Recipient And Sender Rules

- Send the CFD package email to `WesWill@BuyYourHomeLLC.com` only so Wes can review and forward it himself.
- Send from `OfficeAssist@BuyYourHomeLLC.com`.
- Do not send the CFD package email directly to buyers, attorneys, agents, Jenny, outside parties, or any other recipient unless Wes later creates a separate explicit rule changing this restriction.
- Use a subject beginning with `DRAFT:` unless Wes provides a different review-submission subject for that specific run.
- Do not say the message is "on Wes's behalf" unless Wes explicitly asks for that wording for that specific message.

## Package Completeness

Before sending:

1. Use the Closing Checklist content supplied by the Contract for Deed workflow as the email body.
2. Build one complete package ZIP containing every file listed in the Closing Checklist, unless Wes explicitly asks for individual attachments for that specific run.
3. Verify each listed attachment exists and is readable.
4. Verify the ZIP was created and is readable before sending.
5. If any listed file is missing or cannot be included in the ZIP, do not send the email. Report the missing file and provide the proposed email body in the chat.

## Attachment Rule

Use a single complete package ZIP as the default CFD Email Package attachment. This is the preferred delivery format because it keeps the checklist package together and works reliably with the Outlook/email connector.

When using the Outlook/email connector, pass the ZIP path as an attachment array, even when there is only one ZIP attachment. Do not pass newline-separated paths. Do not pass a single attachment path as a plain string if the connector rejects it; retry with the array form.

If Wes specifically asks for individual attachments, verify the connector's current attachment input format first. If individual attachment upload fails or would risk omitting files, stop and report the blocker instead of sending a partial package.

## Delivery Hand Off

Pass these caller-supplied values to `officeassist-email-delivery`:

- sender mailbox: `OfficeAssist@BuyYourHomeLLC.com`,
- recipient: `WesWill@BuyYourHomeLLC.com`,
- subject beginning with `DRAFT:` unless Wes provides a different review-submission subject for that specific run,
- plain-text body containing the Closing Checklist content,
- one complete package ZIP attachment,
- strict rule that no outside recipient or partial package send is allowed.
