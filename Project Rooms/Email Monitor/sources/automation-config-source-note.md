# Automation Config Source Note

Source path:

`C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`

Status: authoritative for the live local automation configuration.

Related run memory:

`C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`

Status: authoritative for persistent run state, including verified send history, cutoff decisions, summary topics, blockers, and Jenny pause notes.

Current observed values as of 2026-07-21:

| Field | Value |
|---|---|
| id | `officeassist-morning-email-summary-and-instruction-monitor` |
| kind | `heartbeat` |
| name | `Email Monitor` |
| status | `ACTIVE` |
| schedule | Runs every day; starts at 7:45 AM Eastern, then every 15 minutes from 8:00 AM through 11:00 PM Eastern |
| target thread | `Email Monitor` |
| target thread id | `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582` |

The automation prompt points to:

- `C:\Codex\Office Assistant Profile.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\skills\email-monitor\SKILL.md`

The prompt defines Email Delivery as an Email Monitor mode connected to `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`. It requires the OfficeAssist shared/delegated connector send path, absolute attachment-path lists, one clearly directed schema-correct retry, OfficeAssist Sent Items verification, delivery logging, and immediate failure reporting.

The prompt also defines recurring daily summaries for Wes, Jenny, and Josh. Josh's summary scans `IRAManager@SellYourHomeRaleigh.com`, uses the prior verified Josh send as its cutoff, includes a read-only Manager Task mode list from `Project Rooms\Manager\working\task-register.md`, sends to Josh with Wes and Jenny copied, and requires OfficeAssist Sent Items verification.

Important notes:

- The automation currently has a `target_thread_id` for status/failure visibility. Do not change that target merely because this project room or a development chat exists. Change it only when Wes explicitly asks to move the live automation status thread.
- On 2026-06-15, Wes approved moving the automation to a dedicated Email Monitor status thread because the previous cron automation was creating a new standalone chat each morning.
- On 2026-06-28, Wes clarified that OfficeAssist instruction-email monitoring should run every day during the configured active window, not weekdays only.
