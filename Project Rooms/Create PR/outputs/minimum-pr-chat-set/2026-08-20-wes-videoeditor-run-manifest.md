# Minimum PR Chat Set Run Manifest

Run date: 2026-08-20 10:59:59 -04:00

## Target

- Computer: `WES-VIDEOEDITOR`
- User: `WesBr`
- Codex project: `Wiki Files`
- Canonical repository: `C:\Codex\Wiki Files`
- Branch: `main`
- Starting Git state: clean; one existing local Create PR commit ahead of `origin/main`

## Results

| Chat title | README | Skill | Creation status | New thread id | Startup verification |
| --- | --- | --- | --- | --- | --- |
| Codex Environment | present | `codex-environment` present | created | `01a01fae-b437-74f0-b979-fd634e93b00b` | blocked by Windows execution-helper setup error |
| Jean Wright | present | `jean-wright` present | created | `01a01fae-b6dd-7b32-b9e0-a902c1ff9380` | blocked by Windows execution-helper setup error |
| Email Monitor | present | `email-monitor` present | created | `01a01fae-b9af-7661-bb91-52ef22996293` | waiting for read-only command approval after execution-helper setup error |
| Doc Scan | present | `doc-scan` present | created | `01a01fae-bcc1-7dd2-a9d7-e95159dfb8f9` | waiting for read-only command approval after execution-helper setup error |
| Invoice Entry | present | `invoice-entry` present | created | `01a01fae-c04c-7692-884f-4ab46c9b14e7` | waiting for read-only command approval after execution-helper setup error |
| Manager | present | `manager` present | created | `01a01fae-c3d2-7b43-8d23-6bcbc2b7c0fd` | blocked by Windows execution-helper setup error |
| Lowes Order | present | `lowes-order` present | created | `01a01fae-c90d-7661-99e4-315722945cf8` | waiting for read-only command approval after execution-helper setup error |
| Marketplace | present | `marketplace` present | created | `01a01fae-ce99-7c43-8f81-e6b4ca64f669` | blocked by Windows execution-helper setup error |

## Registration Decision

The new chats were added under Wes's explicit Minimum PR Chat Set instruction. Existing dedicated task/thread registrations were preserved because Wes did not authorize replacing them. The new chats are not dispatcher destinations until their startup verification succeeds and Wes separately authorizes any registration replacement.

## Blocker

Each new chat received its Project Room startup prompt. The initial read-only shell checks could not complete because the Windows execution helper returned `helper_unknown_error: setup refresh had errors`; four chats are waiting for approval to retry and four returned a blocked startup result. No Project Room content was changed by the new chats.
