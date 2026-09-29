# Doc Scan Automation Audit

Audit date: 2026-06-15

## Scope

This audit covers the first development handoff task: compare the live `document-scanning` automation assumptions against the canonical wiki sources.

Sources checked:

- `C:\Codex\Wiki Files\Document Scanning SOP.md`
- `C:\Codex\Wiki Files\Document Scanning Skill Spec.md`
- `C:\Codex\Wiki Files\Document Scanning Folder Map.md`
- `C:\Codex\Wiki Files\skills\doc-scan\SKILL.md`
- `C:\Codex\Wiki Files\Invoice and Receipt Processing Notes.md`
- `C:\Codex\Wiki Files\Invoice Project List.md`
- `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml`

## Findings

| Item | Finding | Follow-up |
|---|---|---|
| Live automation config file | The wiki points to `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml`, but that file was not present on disk during this audit. The local automations folder only showed `officeassist-morning-email-summary` and `.run-jitter-salt`. | Verify whether the app-managed `document-scanning` automation exists outside the local TOML path or needs to be recreated. Do not change the schedule until the live source is identified. |
| Dedicated status/development chat | Recent thread search for `Doc Scan` and `document-scanning` did not find a dedicated status chat. | Confirm whether a dedicated thread should be created or linked before changing automation config. |
| Canonical skill versus installed copy | The canonical wiki skill has newer content than the installed copy. The installed copy should be treated as runtime-only. | Sync only after Wes says the updated skill is ready to become the installed local version. |
| JPG/JPEG support | The SOP and skill spec include JPG/JPEG processing. The canonical skill still had PDF-only wording in key workflow and mortgage-routing lines. | Updated canonical skill wording to include PDF, JPG, and JPEG sources. |
| Invoice review separation | Invoice notes require a separate invoice review folder under `Invoices & Receipts\_Needs Review`. The skill reference routing still used a generic `_Needs Review` rule. | Updated canonical skill and routing reference to keep invoice review separate from statement review. |

## Current Decision

Historical 2026-06-15 decision: do not edit or recreate the live automation until the app-managed automation details are verified.

Current 2026-07-08 status: Wes directed the old missing `document-scanning` automation to be replaced. The app reported `document-scanning` did not exist, and a new active heartbeat automation was created with id `doc-scan`, local config `C:\Users\wesbr\.codex\automations\doc-scan\automation.toml`, and schedule every 15 minutes on weekdays from 10:00 AM through 4:45 PM Eastern.

## OFFICEASSIST Restoration - 2026-09-29

- Verified the registered current Doc Scan task as `01a07d59-9052-7623-a03c-f2b80b9116e0` on `OFFICEASSIST`.
- Audited every local automation definition and found one scan-intake automation: `doc-scan`. No second active scan schedule or WESSTUDIO predecessor was present.
- Retargeted the existing automation from obsolete task `01a03956-f670-7482-8a73-f85b85dd64b4` to the registered current task, aligned its prompt with the current connector-first Doc Scan rules, and resumed it.
- Preserved the established schedule, every 15 minutes on weekdays from 10:00 AM through 4:45 PM Eastern, and the `failed_runs_only` notification policy.
- Verified an actual backlog run. It processed 44 source PDFs into 119 outputs, confirmed four exact duplicate sources, reused the prior completed True Service invoice record without repeating it, wrote 44 per-source logs plus one run report, archived all 44 originals after read-back verification, and created one authoritative six-record Invoice Entry handoff.
- SharePoint read-back showed 103 new review outputs, the filed statement and utility outputs, the six-record packet, 45 run logs, and an Archived count increase from 82 to 126 items.
