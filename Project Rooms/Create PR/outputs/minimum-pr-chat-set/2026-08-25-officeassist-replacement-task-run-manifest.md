# OFFICEASSIST Minimum PR Chat Set Replacement-Task Run Manifest

- Target computer: `OFFICEASSIST`
- Run date: 2026-08-25
- Dispatch: `jean-dispatch-20260825-officeassist-local-pr-project-migration-v1`
- Canonical repository: `C:\Codex\Wiki Files`
- Branch and Git status: `main`; clean; tracking `origin/main`
- Approved set: Codex Environment, Jean Wright, Email Monitor, Doc Scan, Invoice Entry, Manager, Lowes Order, Marketplace, and Sync GetHub
- Task action: reused the nine supplied OFFICEASSIST-local replacement tasks; no duplicate or substitute task was created
- Routing, registrations, global metadata, automations, and original tasks: unchanged

## Results

| Project Room / chat title | README | Installed matching skill | Replacement task id | Result | Exact pending item or blocker |
| --- | --- | --- | --- | --- | --- |
| Codex Environment | Ready | Ready; matches canonical source | `01a03957-0232-7250-ae9d-88f70908d96c` | **READY** | None |
| Jean Wright | Ready | Ready; matches canonical source | `01a03956-def7-78b3-ac32-353f5ac55a0d` | **READY** | None |
| Email Monitor | Ready | Ready; matches canonical source | `01a03956-fe55-7f62-9c0a-17c18f763320` | **READY** | None |
| Doc Scan | Ready | Ready; matches canonical source | `01a03956-f670-7482-8a73-f85b85dd64b4` | **READY** | None |
| Invoice Entry | Ready | Ready; matches canonical source | `01a03956-fa4f-77c1-9ab7-f709e5f1174e` | **READY** | None |
| Manager | Ready | Ready; matches canonical source | `01a03956-f27a-7340-a8b2-bce9f38b638d` | **READY** | None |
| Lowes Order | Ready | Ready; matches canonical source | `01a03957-060c-7f21-8cd0-182af7280757` | **READY** | None |
| Marketplace | Ready | Ready; matches canonical source | `01a03956-ee95-7133-ba68-cb742753b4a0` | **READY** | None |
| Sync GetHub | Ready | Ready; matches canonical source | `01a03956-e6d4-7433-b992-1b951d1a4330` | **PENDING** | The OFFICEASSIST machine-local `sync-gethub-daily` automation at 5:30 AM Eastern is not installed or otherwise verifiable, so a first safe run cannot be verified. Deployment was not attempted because this run prohibits automation changes. |

Each replacement task is a local Codex task titled for its Project Room with task cwd `C:\Codex\Wiki Files`. Each completed the requested read-only startup turn without a task error. The shared canonical checkout was verified on `main` with a clean `git status --short --branch`. Every listed README is readable, and every installed matching skill exists and has the same SHA-256 content as its canonical source under `C:\Codex\Wiki Files\skills`.

## Old-to-new mapping

| Project Room | Original task id | OFFICEASSIST replacement task id |
| --- | --- | --- |
| Codex Environment | `01a03571-c5b7-7511-bf61-a3d209dc5606` | `01a03957-0232-7250-ae9d-88f70908d96c` |
| Jean Wright | `01a03571-c86f-7163-9396-35ef3051917e` | `01a03956-def7-78b3-ac32-353f5ac55a0d` |
| Email Monitor | `01a03571-cace-7071-9eda-c961679f6a1b` | `01a03956-fe55-7f62-9c0a-17c18f763320` |
| Doc Scan | `01a03571-cd24-7952-b6b4-bec9130384be` | `01a03956-f670-7482-8a73-f85b85dd64b4` |
| Invoice Entry | `01a03571-cfab-7981-8550-f69a71fea813` | `01a03956-fa4f-77c1-9ab7-f709e5f1174e` |
| Manager | `01a03571-d1e4-72a2-ad4e-fbdb9b6807eb` | `01a03956-f27a-7340-a8b2-bce9f38b638d` |
| Lowes Order | `01a03571-d451-76c1-adac-6e5a981bb14e` | `01a03957-060c-7f21-8cd0-182af7280757` |
| Marketplace | `01a03571-d69b-7f32-924c-08983e257389` | `01a03956-ee95-7133-ba68-cb742753b4a0` |
| Sync GetHub | `01a038e3-bb52-7d31-a0d0-7c64b620fe13` | `01a03956-e6d4-7433-b992-1b951d1a4330` |

## Overall status

**PENDING** — eight rooms are ready. Sync GetHub's task startup, README, and installed skill are ready, but the Minimum PR Chat Set cannot mark Sync GetHub fully ready until OFFICEASSIST has the required local 5:30 AM Eastern automation and one verified safe run.
