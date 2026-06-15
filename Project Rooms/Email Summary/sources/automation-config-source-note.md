# Automation Config Source Note

Source path:

`C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml`

Status: authoritative for the live local automation configuration.

Related run memory:

`C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\memory.md`

Status: authoritative for persistent run state, including verified send history, cutoff decisions, summary topics, blockers, and Jenny pause notes.

Current observed values as of 2026-06-15:

| Field | Value |
|---|---|
| id | `officeassist-morning-email-summary` |
| kind | `heartbeat` |
| name | `OfficeAssist morning email summary` |
| status | `ACTIVE` |
| schedule | Daily at 8:00 AM Eastern via `FREQ=DAILY;BYHOUR=8;BYMINUTE=0;BYSECOND=0` |
| target thread | `OfficeAssist Morning Email Summary Status` |
| target thread id | `019ecba7-f1cc-7ac1-aaf7-d89a3f21b582` |

The automation prompt points to:

- `C:\Codex\Office Assistant Profile.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\skills\officeassist-morning-email-summary\SKILL.md`

Important notes:

- The automation currently has a `target_thread_id` for status/failure visibility. Do not change that target merely because this project room or a development chat exists. Change it only when Wes explicitly asks to move the live automation status thread.
- On 2026-06-15, Wes approved moving the automation to a dedicated email-summary status thread because the previous cron automation was creating a new standalone chat each morning.
