# Gracious Millionaire Intake Heartbeat Rules

## Purpose

These rules define how a Gracious Millionaire project-room heartbeat may handle source files dropped into this project room by OfficeAssist or other approved processes.

The heartbeat is for project-room intake and manuscript work only. It does not own OfficeAssist mailbox monitoring and must not access mailboxes directly.

## Boundaries

- The Gracious Millionaire heartbeat may watch this project room for newly dropped files, intake-log entries, and source-material updates.
- The heartbeat must stay attached to the existing Gracious Millionaire project-room thread.
- The heartbeat must not create a new chat.
- The heartbeat must not read OfficeAssist, Wes, Jenny, or any other mailbox directly.
- A question from Wes such as "Do you see a new email?" does not expand this project-room role's scope to Outlook. Answer from routed markdown/source files and intake logs only, or say that OfficeAssist needs to route the email into the project room first.
- OfficeAssist or another approved process owns mailbox monitoring and may drop routed source files into this project room.
- The heartbeat must not send email, approve invoices, move money, modify legal or financial documents, delete source files, or take external actions.
- If a requested action would exceed manuscript or project-room processing, mark the item blocked and ask Wes.

## Intake Locations

On each heartbeat run, check these intake locations for new or changed source material:

- `sources/email/`
- `sources/officeassist-routed/`, if later created
- Any other intake folder explicitly documented in this README or an intake log

Use `working/officeassist-intake-log.md` as the durable intake ledger when OfficeAssist or another process records routed items there. If the ledger does not exist yet, create it before processing a new intake item.

## Intake Ledger

Each intake item should have one status:

- `new`
- `processing`
- `processed`
- `blocked`
- `deferred`

For each item, record:

- source file path
- email subject or source title
- received or created time when known
- message id or web link when available
- requested action, if any
- status
- action taken
- output file path, if any
- processing timestamp
- open questions or blockers

Do not process the same source file repeatedly. Use the intake ledger to identify already-handled files.

## Processing Rules

- Preserve every source file unchanged.
- Do not overwrite, rewrite, move, or delete the original source file.
- Before acting on a new intake item, read this project room README, `working/writing-style-guide.md`, the intake ledger, current manuscript outputs, and any relevant source inventory.
- Decide whether the new source is a chapter seed, chapter section, revision instruction, source note, admin/routing note, or non-actionable item.
- If the source contains a clear writing instruction from Wes, the heartbeat may process it according to the Gracious Millionaire project-room rules.
- If the source is ambiguous, conflicts with current manuscript direction, or requires a major structural decision, mark it `blocked` or `deferred` and notify Wes in the Gracious Millionaire thread.
- If multiple new source files are present, process them oldest-first unless a newer item clearly supersedes an older one.
- If a source file appears partial, malformed, duplicated, or missing metadata, log the issue and proceed only if the body content is clear enough to use.

## Output Rules

- Keep outputs inside the Gracious Millionaire project room unless Wes gives a different destination.
- Put durable manuscript or chapter outputs under `outputs/`.
- Put working notes, intake analysis, source classification, and draft planning under `working/`.
- Preserve Wes's reflective, story-driven, faith-centered voice.
- Avoid generic business prose unless Wes explicitly asks for it.
- Keep manuscript changes traceable to the source file that triggered them.
- After processing, update the intake ledger with status, action taken, output path, processing timestamp, and open questions.

## Notification Rules

- If no new intake files or new intake-log items are found, stay quiet.
- If new files are processed successfully and no decision is needed, stay quiet unless Wes requests routine notices.
- If a new file cannot be processed safely, notify Wes in the Gracious Millionaire thread with the source path and blocker.
- If a source requires a major manuscript direction decision, notify Wes before making the change.

## OfficeAssist Relationship

- OfficeAssist owns email monitoring.
- The Gracious Millionaire heartbeat owns project-room intake processing.
- OfficeAssist may drop source files and intake-log entries into this project room.
- The Gracious Millionaire heartbeat acts only on project-room files and logs, not on mailboxes.
