# Minimum PR Chat Set Run Manifest

Run date: 2026-08-24

## Target

- Computer: `WES-VIDEOEDITOR`
- Windows sign-in: `IRAManagerBYH@outlook.com`
- Windows profile: `WES-VIDEOEDITOR\IRAMa`
- Assigned user: Josh Kennedy
- Business identity: `IRAManager@SellYourHomeRaleigh.com`
- Codex project: `Admin Wiki` / `Wiki Files`
- Canonical repository: `C:\Codex\Wiki Files`
- Branch: `main`
- Readiness source: Codex Environment and Computers registers verified the target profile and Codex/Admin wiki environment on 2026-08-24.

## Connection Verification

- Wes authorized this Wes-VideoEditor remote session and named the `IRAManagerBYH` login.
- An open, unlocked Remote Desktop session titled `Wes-VideoEditor - Remote Desktop Connection` was observed.
- Codex Desktop was visible in the remote session.
- The available Codex task connector exposed only the current computer's local `Wiki Files` project and no Wes-VideoEditor host/project destination.
- Windows UI automation cannot control the Codex/ChatGPT desktop application, so it could not create the target-profile tasks through the remote window.

## Default Minimum Set Results

| Chat title | README | Skill | IRAManagerBYH task status | Thread id | Blocker |
| --- | --- | --- | --- | --- | --- |
| Codex Environment | present | `codex-environment` present | pending creation on target | pending | Remote Wes-VideoEditor project is not exposed to the task connector. |
| Jean Wright | present | `jean-wright` present | pending creation on target | pending | Remote Wes-VideoEditor project is not exposed to the task connector. |
| Email Monitor | present | `email-monitor` present | pending creation on target | pending | Remote Wes-VideoEditor project is not exposed to the task connector. |
| Doc Scan | present | `doc-scan` present | pending creation on target | pending | Remote Wes-VideoEditor project is not exposed to the task connector. |
| Invoice Entry | present | `invoice-entry` present | pending creation on target | pending | Remote Wes-VideoEditor project is not exposed to the task connector. |
| Manager | present | `manager` present | pending creation on target | pending | Remote Wes-VideoEditor project is not exposed to the task connector. |
| Lowes Order | present | `lowes-order` present | pending creation on target | pending | Remote Wes-VideoEditor project is not exposed to the task connector. |
| Marketplace | present | `marketplace` present | pending creation on target | pending | Remote Wes-VideoEditor project is not exposed to the task connector. |

## Duplicate And Registration Decision

The 2026-08-20 Wes-VideoEditor run created eight tasks under the former `WesBr` profile. Those task ids were not treated as tasks for the `IRAManagerBYH` / `IRAMa` profile, and no duplicates were created during this run because the current tools could not inspect or create tasks in the remote Codex task surface.

Existing central dispatcher destinations remain unchanged. This run does not replace registered owning tasks, activate Marketplace, or change any automation.

## Recovery Step

From the open Codex Desktop app on Wes-VideoEditor under `IRAMa`, create or open one local `Create PR` task in the `Admin Wiki` project and run:

```text
Minimum PR Chat Set for WES-VIDEOEDITOR using the default set. Work from C:\Codex\Wiki Files on main. Reuse verified matching tasks in this IRAMa profile and do not create duplicates. Record the task ids and startup-verification results in the Create PR run manifest. Do not replace central dispatcher destinations unless Wes separately authorizes that registration change.
```

That target-local task can use its own Codex task connector to create or reuse the eight tasks and complete startup verification.
