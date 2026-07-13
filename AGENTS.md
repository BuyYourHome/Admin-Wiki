# Buy Your Home Admin Wiki Rules

This workspace is the working knowledge base for Buy Your Home office-admin operations.

## Source Of Truth

- Working folder: `C:\Codex\Wiki Files`
- GitHub repository: `BuyYourHome/Admin-Wiki`
- Obsidian vault: `C:\Codex\Wiki Files`
- Teams folders are not the default wiki location. Copy files to Teams only when the user explicitly asks for a final deliverable there.

Use this repo when formulating solutions for office-admin workflows, SOPs, automations, Doc Scan, invoice routing, grocery-list handling, and related operating rules.

## Start Here

- Read `Admin Home.md` first for the current operating map.
- Use `Agents and Automations Registry.md` to inspect named agent-like roles, active automations, skills, schedules, and where each is defined.
- Use `Connector and Plugin Usage Rules.md` to decide when to prefer installed connectors/plugins over local desktop automation.
- Use `Codex Python Runtime Rule.md` before running Python scripts for Admin wiki, project-room, document, spreadsheet, or skill-support work.
- Use `LibreOffice Location Rule.md` before rendering or converting Word/PDF documents with LibreOffice.
- Use `Project Room Workflow.md` before major work that depends on multiple source files, emails, scans, notes, spreadsheets, or prior drafts.
- Use `Project Room File Ownership And Git Coordination Rule.md` before durable Project Room edits, cross-PR work, shared Admin rule edits, commits, pulls, or pushes.
- Use `Project Rooms\SOPs\` for SOP source emails, extracted notes, SOP pages, SOP index, source map, and SOP review questions.
- Use `Project Rooms\Email Summary\` for development work on the Email Summary workflow, including source inventory, automation notes, open questions, and review-ready handoffs.
- Use `Project Rooms\Doc Scan\` for development work on scanned document processing, including scan routing, automation notes, source inventory, and review-ready handoffs.
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
2. Work on `main` by default. Do not create a new branch unless Wes explicitly asks for one.
3. Follow `Project Room File Ownership And Git Coordination Rule.md` for Project Room ownership, shared Admin files, cross-PR edits, fetch/pull safety, commit scope, and push safety.
4. Identify the current chat's body of work and keep commits scoped to that body of work. Do not mix unrelated project rooms, unrelated files, or prior local changes into the commit.
5. Edit the relevant Markdown files.
6. Review the diff.
7. Commit with a plain-English message.
8. Push to GitHub only when Wes says the scoped body of work is a finished product, explicitly asks for a push, or the task instructions already define that scoped deliverable as final and ready to publish.
9. Tell the user what changed, the commit id if a commit was made, whether it was pushed, and the total request time.

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

## Python Runtime

- Do not call bare `python` or `python3` for routine Codex work in this repository.
- Use the Codex workspace Python executable returned by workspace dependencies, currently `C:\Users\wesbr\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe`.
- Do not ask Wes to install Python, add Python to `PATH`, or change Windows app execution aliases merely so Codex can run Admin wiki or project-room scripts.
- See [[Codex Python Runtime Rule]].

## Document Rendering Tools

- LibreOffice is installed at `C:\Program Files\LibreOffice\program\soffice.exe`.
- The LibreOffice program folder is `C:\Program Files\LibreOffice\program`.
- Do not assume `soffice.exe` is on PATH. For DOCX/PDF render or conversion commands, use the full executable path or prepend the program folder to PATH for that command.
- If LibreOffice headless conversion still fails after using the documented path, follow [[LibreOffice Location Rule]]: retry from a short local workspace copy, then use Microsoft Word PDF export as the Windows visual-QA fallback when needed.
- See [[LibreOffice Location Rule]] for the current command pattern, timeout cleanup rule, and fallback rule.

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

## OfficeAssist Instruction Inbox

- OfficeAssist should use the `officeassist-morning-email-summary-and-instruction-monitor` heartbeat to monitor `OfficeAssist@BuyYourHomeLLC.com` for instruction emails from Wes and Jenny during the configured active window.
- The OfficeAssist heartbeat owns email checking and defined email-triggered actions. The Gracious Millionaire project-room heartbeat does not check email.
- The current OfficeAssist heartbeat starts at 7:45 AM Eastern, then runs every 15 minutes through 11:00 PM Eastern unless Wes changes the schedule.
- Use the Outlook Email connector as the preferred mailbox access path.
- Treat emails from `WesWill@BuyYourHomeLLC.com` and `Jenny@BuyYourHomeLLC.com` as OfficeAssist instruction intake.
- Keep local monitor memory so the same instruction email is not processed repeatedly.
- Quiet checks with no new actionable instruction email should not create routine visible messages.
- If an instruction email asks for a safe, in-scope admin action and the applicable Admin wiki or workflow rules allow it, carry out the task or start the correct workflow.
- If an instruction email asks for a high-impact action such as sending external email, moving money, approving invoices, deleting files, changing automations, or updating legal/financial documents, proceed only when the email clearly authorizes the specific action and the workflow safety rules allow it. Otherwise report the decision needed.
- Jenny's daily email summary is active as of 2026-06-29 because Wes explicitly asked to resume it and the Outlook Email connector can read `Jenny@BuyYourHomeLLC.com`.
- If an OfficeAssist instruction email has a subject containing `gracious millionaire`, or otherwise clearly belongs to the Gracious Millionaire book/project-room workflow, route the email into `Project Rooms\Gracious Millionaire\` as book source material from the OfficeAssist monitor. Preserve the email as its own Markdown source file under `Project Rooms\Gracious Millionaire\sources\email\`, including sender, recipients, sent/received time, subject, message id or web link when available, and body text. Update the Gracious Millionaire project-room intake/source ledger when required by the current project-room rules. Then send a direct follow-up message to the existing Gracious Millionaire project-room thread with the routed source path and a short summary. Direct message handoff is the primary trigger; the separate `gracious-millionaire-project-room-heartbeat` is only a backup processor for Markdown/source files already dropped into the project room. Do not attach an OfficeAssist mailbox-monitoring heartbeat to the Gracious Millionaire thread. Do not create a new chat for Gracious Millionaire routing. Do not draft, edit, or send the requested book response from the OfficeAssist monitor thread unless Wes explicitly asks for processing there; the default action is source routing plus direct handoff only.
- If Wes authorizes any Codex role to check email and that check finds a Gracious Millionaire email, route the found email into `Project Rooms\Gracious Millionaire\` before ending the request. Preserve it as its own Markdown source file under `Project Rooms\Gracious Millionaire\sources\email\`, update the project-room intake ledger, and send the same direct Gracious Millionaire project-room thread handoff with the routed source path and short summary. This rule does not authorize the Gracious Millionaire project-room heartbeat to query any mailbox directly.
- Do not use the name `Project LumenScale` for Gracious Millionaire work. Use plain labels such as `Gracious Millionaire project-room process`, `Gracious Millionaire project-room heartbeat`, or `Gracious Millionaire project room`.

## Email Summary Scope

- Morning email summaries for Wes must scan the entire `WesWill@BuyYourHomeLLC.com` Outlook mailbox store, including all subfolders where Outlook rules may move messages.
- Morning email summaries for Jenny are resumed as of 2026-06-29. Scan the entire `Jenny@BuyYourHomeLLC.com` Outlook mailbox store, including all subfolders where Outlook rules may move messages.
- For Jenny's first resumed summary, use the 2026-06-29 resume timestamp as the new-mail cutoff unless a prior Jenny summary record is later found. Include older unread Jenny items only when they are clearly priority business items.
- Do not limit the summary to Inbox unless Wes explicitly asks for an Inbox-only summary.
- Focus on unread or newly received messages since the last successful summary. Include rule-routed folders when messages are financial, legal, property-related, vendor/admin-related, time-sensitive, or action-oriented.
- Exclude routine promotional, automated, or newsletter messages unless they are time-sensitive, financial, legal, property-related, or require action.
- When the OfficeAssist heartbeat runs every 15 minutes for email monitoring, run each morning summary only once per calendar day: the first eligible run at or after 8:00 AM Eastern sends Boss's summary if it has not already been sent and verified, and sends Jenny's summary to `Jenny@BuyYourHomeLLC.com` from `OfficeAssist@BuyYourHomeLLC.com` if it has not already been sent and verified. Later same-day heartbeat runs perform instruction-email monitoring only.
- Record the summary cutoff time used so the next summary can avoid both missed rule-routed messages and duplicate reporting.
- The email-summary workflow owns the mailbox scan, cutoff logic, priority selection, summary body, and attachment decision for Wes and Jenny.
- For the send step only, use the shared `skills\email-delivery\SKILL.md` workflow by passing sender, recipient, subject, plain-text body, attachment paths if any, and the rule that send or verification failure must be reported in the OfficeAssist thread.
- If the morning summary cannot be sent by email, notify Wes immediately and use the available text/SMS fallback when one is available. A failed send or unverified send is not a quiet/no-news run.
- Jenny's summary is emailed to `Jenny@BuyYourHomeLLC.com` from `OfficeAssist@BuyYourHomeLLC.com` under the current global profile. Verify the sent copy in OfficeAssist Sent Items and report any send or verification failure in the Email Summary thread.

## Calendar Scheduling

- When checking availability for calls, meetings, or appointment replies, check both Wes's calendar and Jenny's calendar whenever Jenny's calendar is available in Outlook.
- Do not send or approve a calendar request, meeting time, or availability response that conflicts with either Wes's or Jenny's calendar unless Wes explicitly approves the conflict for that specific request.
- If Jenny's calendar is unavailable locally, do not assume she is free. Tell Wes that Jenny's calendar could not be checked before sending or approving the meeting time.
