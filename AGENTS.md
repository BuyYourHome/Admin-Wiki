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
- Use `Agents and Automations Registry.md` to inspect named agent-like roles, active automations, skills, schedules, and where each is defined.
- Use `Connector and Plugin Usage Rules.md` to decide when to prefer installed connectors/plugins over local desktop automation.
- Use `LibreOffice Location Rule.md` before rendering or converting Word/PDF documents with LibreOffice.
- Use `Project Room Workflow.md` before major work that depends on multiple source files, emails, scans, notes, spreadsheets, or prior drafts.
- Use `Repository Location Rule.md` for repo/location policy.
- Use `Git Work Scope Rule.md` before committing or pushing Admin wiki work.
- Use `Codex Skill Source Rule.md` before creating, editing, syncing, or installing Admin wiki-managed Codex skills.
- Use `SOP Spreadsheet Maintenance Rule.md` before editing the SOP workbook.
- Use `Document Scanning SOP.md`, `Document Scanning Skill Spec.md`, and `Document Scanning Folder Map.md` for scanned statement workflows.
- Use `Invoice and Receipt Processing Notes.md` and `Invoice Project List.md` for invoice/receipt routing.
- Use `operations/grocery-list/` for grocery-list rules and data.

## Editing Rules

- Keep durable operating instructions in Markdown.
- Prefer concise sections with clear routing rules, exception rules, and human responsibilities.
- Use Obsidian-style links for related local docs, such as `[[Invoice Project List]]`.
- When the user gives a durable instruction, update the relevant Markdown file and commit it.
- Do not push every commit to GitHub automatically. Push only when Wes says the work is a finished product, explicitly asks for a push, or the task instructions already define the deliverable as final and ready to publish.
- Do not commit Obsidian local settings, temporary scan previews, logs, or generated scratch files.
- In final responses, report the total elapsed time for the whole request. Do not report timing for each individual step unless Wes explicitly asks for step timing.

## Discussion Before Action Rule

- Treat Wes's questions, process-design discussion, and sequences of instructions as discussion-only until Wes clearly says to act.
- Do not make file changes, start or restart processes, message other chats, delete files, sync skills, commit, push, send emails, or run external workflow actions merely because Wes is describing what he wants.
- Proceed only after an explicit action instruction such as `proceed`, `implement`, `do it`, `make the change`, `run it`, `start`, or another clear instruction to act.
- If Wes says to write or implement one specific rule, keep the work limited to that rule and do not expand into related process changes unless he separately authorizes them.

## Skill Ownership Boundary Rule

- When working from a process-specific chat, write only that process's own skill source unless Wes explicitly authorizes editing another skill.
- The Contract for Deed chat owns `skills\contract-for-deed\SKILL.md`.
- The Credit Worthiness Evaluator chat owns `skills\credit-worthiness-evaluator\SKILL.md`.
- If a proposed rule affects another process, record it as a proposed rule for that other process, tell Wes it should be written from that process's chat, or ask for explicit permission to edit both skill sources.
- A general instruction such as `write proposed rules to skills` does not override this ownership boundary. It means write the current chat's owned skill rules only unless Wes names the other skill or says to update both.

## Git Workflow

1. Check `git status --short --branch`.
2. Identify the current chat's body of work and keep commits scoped to that body of work. Do not mix unrelated project rooms, unrelated files, or prior local changes into the commit.
3. Edit the relevant Markdown files.
4. Review the diff.
5. Commit with a plain-English message.
6. Push to GitHub only when Wes says the scoped body of work is a finished product, explicitly asks for a push, or the task instructions already define that scoped deliverable as final and ready to publish.
7. If the current branch contains unrelated unpushed commits, do not make Wes choose between pushing everything and pushing nothing. Create or use a scoped branch for the current body of work, move or cherry-pick only the relevant commits there, and push that branch when pushing is approved.
8. Tell the user what changed, the commit id if a commit was made, whether it was pushed, and the total request time.

## Teams Workflow

- Do not use Teams as the working wiki repository.
- Copy one-off final files to Teams only when requested.
- When the owner asks for a property report, treat that as standing permission to copy the completed report deliverable to the matching Teams-synced property folder under `Owning`; use the `cma-report` skill.
- If an SOP spreadsheet is updated, follow `SOP Spreadsheet Maintenance Rule.md`.

## Automation And Skill Notes

- Automation prompts should point to the relevant Markdown instructions when possible.
- If a workflow becomes repeatable, document it here before or while creating the automation.
- Canonical Admin workflow skills live under `C:\Codex\Wiki Files\skills`; local `%USERPROFILE%\.codex\skills` copies are installed/synced copies, not the source of truth.
- After changing a wiki-managed skill, commit the wiki update and push to GitHub. Run `tools\sync-codex-skills.ps1` only when the updated skill is ready to become the installed local version.
- When creating, renaming, pausing, deleting, or materially changing an agent-like function, update `Agents and Automations Registry.md`.
- Keep review folders separate when the user has specified separate workflows, such as statement review versus invoice review.
- If a mailbox, folder, or external service is unavailable, do not substitute a similar one without explicit permission.

## Document Rendering Tools

- LibreOffice is installed at `C:\Program Files\LibreOffice\program\soffice.exe`.
- The LibreOffice program folder is `C:\Program Files\LibreOffice\program`.
- Do not assume `soffice.exe` is on PATH. For DOCX/PDF render or conversion commands, use the full executable path or prepend the program folder to PATH for that command.
- See [[LibreOffice Location Rule]] for the current command pattern and timeout cleanup rule.

## AI Project Rooms

- Use Project Rooms for substantial drafting, analysis, redesign, or automation work that depends on multiple sources.
- Project Rooms live under `Project Rooms\<Project Name>\` with `sources\`, `working\`, and `outputs\` subfolders.
- Build source inventory, duplicate/conflict log, and missing-context notes before drafting final outputs.
- Draft from authoritative sources only. Mark unsupported claims instead of blending or guessing.

## Email Sender Safety

- When sending email as Jean or Office Assistant, use only `OfficeAssist@BuyYourHomeLLC.com` unless the user explicitly names another sender for that specific message.
- When sending an email directly as Jean/Office Assistant, send from `OfficeAssist@BuyYourHomeLLC.com` and do not say the message is "on Wes's behalf" unless Wes explicitly asks for that wording for that specific message.
- Use "on behalf of Wes" wording only when Wes explicitly requests it or when the actual email-sending identity is a delegated/on-behalf-of Wes identity. If the message is sent from Jean's/OfficeAssist's own mailbox, write as Jean/Office Assistant.
- When sending any email from Jean/OfficeAssist that concerns Wes's business or was requested by Wes, copy `WesWill@BuyYourHomeLLC.com` unless Wes explicitly says not to copy himself for that specific message.
- When Wes asks Jean to write a draft email, or says to "write a draft email" without naming another workflow, create the proposed message and send it to `WesWill@BuyYourHomeLLC.com` from `OfficeAssist@BuyYourHomeLLC.com` with a subject prefix such as `DRAFT:`. Do not leave the proposed message saved in any Outlook Drafts folder for later manual sending. Wes will forward the draft himself if he wants it sent to another recipient.
- If a draft-review email cannot be sent safely from OfficeAssist, do not create or leave an Outlook draft. Provide the proposed email text in the thread and explain the sending blocker.
- Do not rely on a script variable alone to prove the sender.
- Preferred send path: use the Outlook/email connector when it can create or verify a draft stored in `OfficeAssist@BuyYourHomeLLC.com` Drafts and can verify the sent copy in `OfficeAssist@BuyYourHomeLLC.com` Sent Items. A connector-verified OfficeAssist draft plus a connector-verified OfficeAssist Sent Items record counts as a valid sender verification, even if the OfficeAssist mailbox root is not mounted in local Outlook on that machine.
- Local Outlook is the fallback path when the connector cannot perform the needed send or verification step. In that fallback path, before sending, create/save the draft in the OfficeAssist mailbox and verify the draft is stored under the OfficeAssist Drafts folder.
- Outlook may leave the internal `SendUsingAccount` field blank even when the visible From line is correctly OfficeAssist. A blank `SendUsingAccount` is acceptable only when the draft is stored in the OfficeAssist mailbox and the draft's visible sender/From identity is OfficeAssist.
- If Outlook shows a non-blank `SendUsingAccount` other than `OfficeAssist@BuyYourHomeLLC.com`, or the draft is not stored in the OfficeAssist mailbox, do not send automatically. Notify the user that Outlook is falling back to another account and either provide a draft for manual send or wait until the mailbox/account configuration is fixed.
- After any automated send, verify the message appears in the OfficeAssist Sent Items folder. If it appears under a different mailbox or shows a non-blank `SendUsingAccount` other than `OfficeAssist@BuyYourHomeLLC.com`, notify the user immediately and treat the sender configuration as broken until corrected.
- Jean is responsible for completing assigned email tasks, including the morning email summary. If an email task fails, if the email cannot be sent, or if successful delivery cannot be verified, do not stay quiet. Notify Wes immediately in the thread and, when a reliable text/SMS path is available, text Wes that the email task failed.

## Email Summary Scope

- Morning email summaries for Wes must scan the entire `WesWill@BuyYourHomeLLC.com` Outlook mailbox store, including all subfolders where Outlook rules may move messages.
- Do not limit the summary to Inbox unless Wes explicitly asks for an Inbox-only summary.
- Focus on unread or newly received messages since the last successful summary. Include rule-routed folders when messages are financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented.
- Exclude routine promotional, automated, or newsletter messages unless they are time-sensitive, financial, legal, property-related, or require action.
- Record the summary cutoff time used so the next summary can avoid both missed rule-routed messages and duplicate reporting.
- For the Boss summary send path, prefer the Outlook/email connector when it can verify the draft in `OfficeAssist@BuyYourHomeLLC.com` Drafts and the sent message in `OfficeAssist@BuyYourHomeLLC.com` Sent Items. Do not block a connector-verified send merely because the OfficeAssist mailbox root is absent from local Outlook.
- If the morning summary cannot be sent by email, notify Wes immediately and use the available text/SMS fallback when one is available. A failed send or unverified send is not a quiet/no-news run.

## Calendar Scheduling

- When checking availability for calls, meetings, or appointment replies, check both Wes's calendar and Jenny's calendar whenever Jenny's calendar is available in Outlook.
- Do not send or approve a calendar request, meeting time, or availability response that conflicts with either Wes's or Jenny's calendar unless Wes explicitly approves the conflict for that specific request.
- If Jenny's calendar is unavailable locally, do not assume she is free. Tell Wes that Jenny's calendar could not be checked before sending or approving the meeting time.
