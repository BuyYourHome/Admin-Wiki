# Email Summary Development Handoff

Use this handoff when resuming development in a dedicated chat.

## Work From

- Canonical repo: `C:\Codex\Wiki Files`
- Project room: `C:\Codex\Wiki Files\Project Rooms\Email Summary`
- Skill source: `C:\Codex\Wiki Files\skills\officeassist-morning-email-summary\SKILL.md`
- Send-step skill: `C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`
- Live automation config: `C:\Users\wesbr\.codex\automations\officeassist-morning-email-summary\automation.toml`

## Preserve

- Automation id: `officeassist-morning-email-summary`
- Sender: `OfficeAssist@BuyYourHomeLLC.com`
- Recipient: `WesWill@BuyYourHomeLLC.com`
- Wes mailbox scope: full recursive mailbox scan, including rule-routed folders
- Jenny summary status: paused
- Preferred connector: Outlook Email connector
- Failure handling: report failed or unverified sends immediately

## First Development Tasks

1. Confirm where the run memory file lives and whether the skill should name it explicitly.
2. Decide whether the new development chat should become the live automation status thread.
3. Test Outlook Email connector access for OfficeAssist, Wes delegated mailbox, and OfficeAssist Sent Items verification.
4. Review whether the current token-summary section is still useful in the daily email.
