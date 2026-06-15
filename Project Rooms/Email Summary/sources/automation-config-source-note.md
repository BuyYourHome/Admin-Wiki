# Automation Config Source Note

Source path:

`C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml`

Status: authoritative for the live local automation configuration.

Current observed values as of 2026-06-15:

| Field | Value |
|---|---|
| id | `officeassist-morning-email-summary` |
| kind | `cron` |
| name | `OfficeAssist morning email summary` |
| status | `ACTIVE` |
| schedule | Daily at 8:00 AM Eastern via `FREQ=DAILY;BYHOUR=8;BYMINUTE=0;BYSECOND=0` |
| cwd | `C:\Codex\Wiki Files` |
| model | `gpt-5` |
| reasoning effort | `medium` |
| execution environment | `local` |

The automation prompt points to:

- `C:\Codex\Office Assistant Profile.md`
- `C:\Codex\Wiki Files\AGENTS.md`
- `C:\Codex\Wiki Files\skills\officeassist-morning-email-summary\SKILL.md`

Important note:

- The automation currently has a `target_thread_id` for status/failure visibility. Do not change that target merely because this project room or a development chat exists. Change it only when Wes explicitly asks to move the live automation status thread.
