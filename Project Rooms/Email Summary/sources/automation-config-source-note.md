# Automation Config Source Note

Source path:

`C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\automation.toml`

Status: authoritative for the live local automation configuration.

Related run memory:

`C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary-and-instruction-monitor\memory.md`

Status: authoritative for persistent run state, including verified send history, cutoff decisions, summary topics, blockers, and Jenny pause notes.

Current observed values as of 2026-06-28:

| Field | Value |
|---|---|
| id | `officeassist-morning-email-summary-and-instruction-monitor` |
| kind | `heartbeat` |
| name | `Email Summary` |
| status | `ACTIVE` |
| schedule | Starts at 7:45 AM Eastern, then every 15 minutes from 8:00 AM through 4:45 PM Eastern |
| target thread | `Email Summary` |
| target thread id | `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582` |

The automation prompt points to:

- `C:\Codex\Office Assistant Profile.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\skills\email-summary\SKILL.md`

Important notes:

- The automation currently has a `target_thread_id` for status/failure visibility. Do not change that target merely because this project room or a development chat exists. Change it only when Wes explicitly asks to move the live automation status thread.
- On 2026-06-15, Wes approved moving the automation to a dedicated email-summary status thread because the previous cron automation was creating a new standalone chat each morning.
