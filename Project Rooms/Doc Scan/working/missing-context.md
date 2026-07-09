# Missing Context

These items should be resolved before major live automation changes.

| Question | Why It Matters | Status |
|---|---|---|
| Should the root document-scanning SOP/spec/map eventually move into this project room? | Moving them would require updating many wiki links and may affect Obsidian navigation. | Needs Wes decision. |
| Should Doc Scan automation status use a dedicated development/status chat? | The registry says the automation should resume one dedicated status chat; recent thread search did not find a dedicated Doc Scan thread before recreation. | Resolved for now: `doc-scan` heartbeat was created on 2026-07-08 and attached to the current Doc Scan discussion thread. |
| Is the live automation config aligned with the canonical skill after recent JPG/JPEG processing changes? | The old wiki path `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml` was not present during the 2026-06-15 audit. | Resolved for now: app automation id `doc-scan` and local config `C:\Users\wesbr\.codex\automations\doc-scan\automation.toml` were recreated on 2026-07-08 after syncing the installed `doc-scan` skill. |
| Are all current scan intake, archive, review, and filed-document folders still accurate? | Folder paths can drift as Teams/SharePoint organization changes. | Needs periodic route audit. |
