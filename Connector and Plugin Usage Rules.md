# Connector And Plugin Usage Rules

This file records which Codex plugins/connectors are available or desired for Buy Your Home admin work and when Codex should use them.

## General Rule

When a connector or plugin provides a more reliable path than local desktop automation, prefer the connector/plugin.

Use local desktop automation as a fallback when the connector is unavailable, lacks the needed mailbox/file/account, or cannot perform the required action.

## GitHub Connector

Status: installed and confirmed.

Confirmed repository:

- `BuyYourHome/Admin-Wiki`

Use for:

- Confirming GitHub repository visibility.
- Reading GitHub repository metadata.
- Comparing commits or refs when useful.
- Reviewing pull requests or issues if the workflow starts using them.

Continue using local Git for:

- Editing local files in `C:\Codex\Wiki Files`.
- Committing and pushing normal wiki changes.
- Checking local working tree status.

Reason:

The working source of truth is still the local wiki folder. The GitHub connector helps inspect GitHub state, but local Git remains the most direct way to make durable wiki changes.

## Spreadsheets Plugin

Status: installed and available.

Use for:

- Creating, reading, editing, formatting, analyzing, or rebuilding `.xlsx`, `.xls`, `.csv`, and `.tsv` files.
- The Project Management spreadsheet rewrite.
- SOP workbook maintenance.
- Spreadsheet formulas, tables, charts, validation, and review-ready workbook outputs.

Important:

- The installed spreadsheet capability is a local file plugin, not a confirmed Google Sheets or cloud Excel connector.
- It is appropriate for files stored locally or in Teams-synced folders.
- Before major spreadsheet rewrites, use `Project Room Workflow.md`.

## SharePoint / Teams Connector

Status: installed and preferred for Teams/SharePoint file discovery in document workflows.

Use first when available for:

- Locating scanned files in Teams/SharePoint.
- Confirming whether a scan exists when the local synced folder appears empty.
- Finding destination folders for property, entity, insurance, closing-package, operating-agreement, invoice, receipt, and statement documents.
- Searching property or entity folders for existing unsigned, approved-final, filed, declaration, evidence-of-insurance, or other matching source documents.
- Resolving folder ambiguity when local sync is stale, incomplete, or missing a Teams folder.

Continue using local synced folders for:

- Scanner drop-zone intake when the scanner writes directly to the local `Scanned Files` folder.
- Temporary working copies for PDF inspection, OCR/visual parsing, splitting, report generation, logs, and archive movement.
- Filing when the connector cannot perform the write safely or when local sync provides the same Teams-backed folder with clearer overwrite control.

Required behavior:

- Treat Teams/SharePoint connector discovery as the default for locating scans and matching destination folders.
- Treat the local synced path as the processing and fallback path.
- Preserve source scans whether they are found through Teams/SharePoint or local sync.
- Do not delete or move the original Teams/SharePoint source scan. If a cloud-only file must be processed, download a working copy, process the working copy, and log the SharePoint URL.
- Never overwrite filed PDFs or image files silently through either path.

## Browser Plugin

Status: installed and available.

Use for:

- REI BlackBook / Profit Dial text checks.
- Inspecting or operating the current in-app browser tab when browser automation is needed.
- Website verification, screenshots, or local web app testing.

Important:

- Keep browser work in the background unless Wes asks to watch or see the page.
- For REI, do not send external lead/customer texts without exact approval.
- Internal Boss/Jenny REI text instructions are handled under the REI Text Message Watcher rules.

## Outlook / Email Connector

Status: installed and confirmed for `Wes@myBrowning.net` and delegated/shared mailbox folder access is confirmed for the required Buy Your Home mailboxes.

Connector profile confirmed:

- `Wes@myBrowning.net`

Shared/delegated mailbox access initially failed on 2026-05-26, then was fixed after Exchange permissions were added. Retest succeeded on 2026-05-26:

- `OfficeAssist@BuyYourHomeLLC.com` - folder listing succeeded.
- `WesWill@BuyYourHomeLLC.com` - folder listing succeeded.
- `Jenny@BuyYourHomeLLC.com` - folder listing succeeded.

Use when available for:

- More dependable mailbox reading.
- Full-folder email summaries.
- Sending from the correct mailbox.
- Sent-message verification.
- Calendar availability checks.

Priority:

- Higher priority than GitHub for office automation reliability.

Fallback:

- Use the local Outlook safety rules in `AGENTS.md` only when the Outlook/email connector cannot perform the needed action, lacks the needed write permission, or returns an access error.

Required mailboxes:

- `OfficeAssist@BuyYourHomeLLC.com`
- `WesWill@BuyYourHomeLLC.com`
- `Jenny@BuyYourHomeLLC.com` when Jenny summary/calendar workflows resume.

Remaining setup checks:

- Before using the connector for production sending from OfficeAssist, send one explicit test message only if Wes approves, then verify the Sent Items behavior.
- Calendar access still needs separate confirmation before relying on the connector for Wes/Jenny availability checks.

## Current Priority Order

1. Outlook/email connector, when available for the correct mailboxes.
2. SharePoint/Teams connector for Teams/SharePoint file discovery and folder matching.
3. Spreadsheets plugin for local workbook work.
4. GitHub connector for repository inspection and optional GitHub workflow features.
5. Browser plugin for REI and web workflows.
