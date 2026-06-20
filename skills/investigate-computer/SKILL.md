---
name: investigate-computer
description: Daily or on-demand Windows compromise diagnostics for Wes's computer. Use when Wes asks to run Investigate Computer, check for ScreenConnect/RMM or other remote-access persistence, verify cleanup after reboot, document computer incident evidence, or prepare an OfficeAssist email report about security diagnostics.
---

# Investigate Computer

## Purpose

Run a repeatable local diagnostic pass for remote-access compromise indicators, with special attention to the June 2026 ScreenConnect/RMM incident. Keep findings factual, preserve evidence before cleanup, and clearly separate active risk from historical artifacts.

Project room:

`C:\Codex\Wiki Files\Project Rooms\Investigate Computer`

## Standard Workflow

1. Confirm the request scope:
   - Daily diagnostic/checkup.
   - Post-reboot verification.
   - Incident investigation.
   - Removal follow-up.
   - Email documentation.
2. Run `scripts\diagnose-investigate-computer.ps1`.
3. Review the report for:
   - Active ScreenConnect/RMM processes or services.
   - Remote-access install folders.
   - Uninstall entries.
   - Startup entries.
   - Scheduled tasks.
   - Active connections to known incident hosts.
4. If active remote access is found:
   - Tell Wes plainly that the machine may still be accessible.
   - Recommend disconnecting from the internet.
   - Preserve evidence before removal.
   - Do not delete evidence unless Wes explicitly asks.
5. If cleanup/removal is requested:
   - Preserve relevant logs/installers/service state first.
   - Use Administrator-approved removal for protected services or folders.
   - Reboot and rerun diagnostics.
6. If Wes asks for email documentation:
   - Use the `email-delivery` skill.
   - Send from `OfficeAssist@BuyYourHomeLLC.com`.
   - Attach the current report when practical.
   - Verify the sent copy in OfficeAssist Sent Items.

## Diagnostic Script

Run from the Admin wiki root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\skills\investigate-computer\scripts\diagnose-investigate-computer.ps1"
```

The script writes reports under:

`C:\Users\wesbr\Documents\Security Incident Evidence\Investigate Computer`

Use the newest report as the working artifact for email, comparison, or follow-up cleanup.

## Known June 2026 Incident Indicators

Known suspicious indicators from the June 2026 incident:

- ScreenConnect service id: `a2274db645c550f8`
- ScreenConnect host: `trews.cfd`
- ScreenConnect port: `8041`
- ScreenConnect IP observed: `173.214.166.76`
- RMM IP observed: `52.20.40.101`
- Fake Zoom page: `us06web.zoom.kubevekt.com`
- RMM installer name pattern: `nsciotti_rmm_v2.4.0.68_oid972cd6b7-ceda-42fc-889f-8e5d1a4e7b65_bidbAdCnT-Gtk2-s8kVYe2EuA*.exe`

Treat these as incident indicators, not as the only possible threats. Also flag other obvious remote-control tools only if they are newly installed, suspiciously configured, or directly tied to the incident evidence.

## Reporting Rules

Include:

- Whether active remote-access processes or services were found.
- Whether known suspicious network connections were found.
- Whether known folders/uninstall/startup/task entries remain.
- Where the report was saved.
- Whether email was sent and verified, if requested.

Avoid overclaiming identity. The `nsciotti` string in the installer name is an evidence identifier, not proof of a specific person by itself.
