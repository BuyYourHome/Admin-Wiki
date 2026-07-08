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

Do not edit or recreate the live automation yet. The next safe step is to verify the app-managed automation details, then update the registry/project-room notes if the actual config location differs from the wiki path.
