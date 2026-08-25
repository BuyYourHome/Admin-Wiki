# OfficeAssist Minimum PR Chat Set Run Manifest

- Target computer: `OfficeAssist`
- Run date: 2026-08-25
- Canonical repository: `C:\Codex\Wiki Files`
- Requested set: Codex Environment, Computers, Jean Wright, Email Monitor, Doc Scan, Invoice Entry, Marketplace, Manager, and Sync GetHub
- Git verification: `main` clean and synchronized with `origin/main` (`0` behind, `0` ahead)
- Central dispatcher destinations: unchanged

| Task | README | Skill | Task/thread id | Task action | Startup verification |
| --- | --- | --- | --- | --- | --- |
| Codex Environment | present | present | `01a03571-c5b7-7511-bf61-a3d209dc5606` | reused | Pending: verification retry completed without a usable returned status. |
| Computers | present | present | `01a038e3-b856-7763-bf65-9a5a3fab74b0` | created | Verified: canonical repo `C:\Codex\Wiki Files`, branch `main`, clean worktree, no blocker. |
| Jean Wright | present | present | `01a03571-c86f-7163-9396-35ef3051917e` | reused | Pending: verification retry completed without a usable returned status. |
| Email Monitor | present | present | `01a03571-cace-7071-9eda-c961679f6a1b` | reused | Pending: verification retry completed without a usable returned status. |
| Doc Scan | present | present | `01a03571-cd24-7952-b6b4-bec9130384be` | reused | Pending: verification retry completed without a usable returned status. |
| Invoice Entry | present | present | `01a03571-cfab-7981-8550-f69a71fea813` | reused | Pending: verification retry completed without a usable returned status. |
| Marketplace | present | present | `01a03571-d69b-7f32-924c-08983e257389` | reused | Pending: verification retry completed without a usable returned status. |
| Manager | present | present | `01a03571-d1e4-72a2-ad4e-fbdb9b6807eb` | reused | Pending: verification retry completed without a usable returned status. |
| Sync GetHub | present | present | `01a038e3-bb52-7d31-a0d0-7c64b620fe13` | created | Blocked: task-local command runner could not start; repo, branch, and Git state were not verified inside the task. |

## Sync GetHub Automation Verification

- Required machine-local automation id: `sync-gethub-daily`
- Required schedule: daily at 5:30 AM Eastern
- OfficeAssist automation status: **pending** — no machine-local automation record was found, and the Codex automation lookup did not return a configured schedule.
- First safe run status: **pending** — no OfficeAssist automation exists, so no first scheduled safe run can be verified.
- Deployment note: installation belongs to Codex Environment and was not performed because this request authorizes verification and pending-status recording, not automation deployment.

## Notes

- No duplicate tasks were created for the seven verified title matches already present on this computer.
- The saved Codex project still defaults to `C:\Users\OfficeAssistLogin\Documents\ChatGPT\Admin WIKI`; task prompts explicitly require `C:\Codex\Wiki Files` for every operation.
- No central dispatcher destination was changed.
