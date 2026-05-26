# Buy Your Home Admin Wiki Rules

This workspace is the working knowledge base for Buy Your Home office-admin operations.

## Source Of Truth

- Working folder: `C:\Codex\Wiki Files`
- GitHub repository: `BuyYourHome/Admin-Wiki`
- Obsidian vault: `C:\Codex\Wiki Files`
- Teams folders are not the default wiki location. Copy files to Teams only when the user explicitly asks for a final deliverable there.

Use this repo when formulating solutions for office-admin workflows, SOPs, automations, document scanning, invoice routing, grocery-list handling, and related operating rules.

## Start Here

- Read `Admin Home.md` first for the current operating map.
- Use `Repository Location Rule.md` for repo/location policy.
- Use `SOP Spreadsheet Maintenance Rule.md` before editing the SOP workbook.
- Use `Document Scanning SOP.md`, `Document Scanning Skill Spec.md`, and `Document Scanning Folder Map.md` for scanned statement workflows.
- Use `Invoice and Receipt Processing Notes.md` and `Invoice Project List.md` for invoice/receipt routing.
- Use `operations/grocery-list/` for grocery-list rules and data.

## Editing Rules

- Keep durable operating instructions in Markdown.
- Prefer concise sections with clear routing rules, exception rules, and human responsibilities.
- Use Obsidian-style links for related local docs, such as `[[Invoice Project List]]`.
- When the user gives a durable instruction, update the relevant Markdown file and commit it.
- After committing, push to GitHub unless the user says not to.
- Do not commit Obsidian local settings, temporary scan previews, logs, or generated scratch files.

## Git Workflow

1. Check `git status --short --branch`.
2. Edit the relevant Markdown files.
3. Review the diff.
4. Commit with a plain-English message.
5. Push to GitHub.
6. Tell the user what changed and the commit id.

## Teams Workflow

- Do not use Teams as the working wiki repository.
- Copy one-off final files to Teams only when requested.
- If an SOP spreadsheet is updated, follow `SOP Spreadsheet Maintenance Rule.md`.

## Automation And Skill Notes

- Automation prompts should point to the relevant Markdown instructions when possible.
- If a workflow becomes repeatable, document it here before or while creating the automation.
- Keep review folders separate when the user has specified separate workflows, such as statement review versus invoice review.
- If a mailbox, folder, or external service is unavailable, do not substitute a similar one without explicit permission.

## Email Sender Safety

- When sending email as Jean or Office Assistant, use only `OfficeAssist@BuyYourHomeLLC.com` unless the user explicitly names another sender for that specific message.
- When sending any email on Wes's behalf from any account, always copy `WesWill@BuyYourHomeLLC.com` unless Wes explicitly says not to copy himself for that specific message.
- Do not rely on a script variable alone to prove the sender. Before sending, create/save the draft in the OfficeAssist mailbox and verify the draft is stored under the OfficeAssist Drafts folder.
- Outlook may leave the internal `SendUsingAccount` field blank even when the visible From line is correctly OfficeAssist. A blank `SendUsingAccount` is acceptable only when the draft is stored in the OfficeAssist mailbox and the draft's visible sender/From identity is OfficeAssist.
- If Outlook shows a non-blank `SendUsingAccount` other than `OfficeAssist@BuyYourHomeLLC.com`, or the draft is not stored in the OfficeAssist mailbox, do not send automatically. Notify the user that Outlook is falling back to another account and either provide a draft for manual send or wait until the mailbox/account configuration is fixed.
- After any automated send, verify the message appears in the OfficeAssist Sent Items folder. If it appears under a different mailbox or shows a non-blank `SendUsingAccount` other than `OfficeAssist@BuyYourHomeLLC.com`, notify the user immediately and treat the sender configuration as broken until corrected.
