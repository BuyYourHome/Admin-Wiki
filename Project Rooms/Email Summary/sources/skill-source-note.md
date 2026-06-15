# Skill Source Note

Source path:

`C:\Codex\Wiki Files\skills\officeassist-morning-email-summary\SKILL.md`

Status: authoritative for the reusable OfficeAssist morning email summary workflow.

The skill owns:

- mailbox scanning,
- cutoff selection,
- message prioritization,
- summary drafting,
- token-summary inclusion,
- summary-run state updates,
- attachment decisions before delivery handoff.

The skill does not own:

- sender safety,
- OfficeAssist send verification,
- connector versus local Outlook fallback decisions.

Those send-step responsibilities are owned by:

`C:\Codex\Wiki Files\skills\email-delivery\SKILL.md`

Current boundaries to preserve:

- Scan only `WesWill@BuyYourHomeLLC.com` unless Wes changes the scope.
- Review the full mailbox recursively, including rule-routed folders.
- Focus on unread or newly received priority business messages.
- Jenny summary remains paused until Wes explicitly resumes it.
- Do not treat a failed or unverified summary as quiet.
