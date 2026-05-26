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

Status: installed and confirmed for `Wes@myBrowning.net`; not yet confirmed for Buy Your Home shared/delegated mailboxes.

Connector profile confirmed:

- `Wes@myBrowning.net`

Shared/delegated mailbox access tested on 2026-05-26:

- `OfficeAssist@BuyYourHomeLLC.com` - shared mailbox folder listing failed with `Default folder Root not found`.
- `WesWill@BuyYourHomeLLC.com` - shared mailbox folder listing failed with `Default folder Root not found`.
- `Jenny@BuyYourHomeLLC.com` - shared mailbox folder listing failed with `Default folder Root not found`.

Use when available for:

- More dependable mailbox reading.
- Full-folder email summaries.
- Sending from the correct mailbox.
- Sent-message verification.
- Calendar availability checks.

Priority:

- Higher priority than GitHub for office automation reliability.

Fallback:

- Until the Outlook/email connector is confirmed available for the correct Buy Your Home mailboxes, use the local Outlook safety rules in `AGENTS.md`.

Required mailboxes:

- `OfficeAssist@BuyYourHomeLLC.com`
- `WesWill@BuyYourHomeLLC.com`
- `Jenny@BuyYourHomeLLC.com` when Jenny summary/calendar workflows resume.

Next setup step:

- In Microsoft 365 / Exchange, verify that `Wes@myBrowning.net` has Full Access and Send As or Send on behalf permissions for the required Buy Your Home mailboxes, then retest shared mailbox folder listing through the connector.

## Current Priority Order

1. Outlook/email connector, when available for the correct mailboxes.
2. Spreadsheets plugin for local workbook work.
3. GitHub connector for repository inspection and optional GitHub workflow features.
4. Browser plugin for REI and web workflows.
