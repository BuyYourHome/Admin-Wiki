# Source Inventory

| Source | Status | Purpose |
| --- | --- | --- |
| `Project Room Messaging Rule.md` | authoritative | Queue, delivery, security, recovery, and machine-local dispatcher contract. |
| `Project Room Delegation Contract.md` | authoritative | Destination ownership and return states. |
| `Project Rooms\Create PR\README.md` | authoritative | Creation, migration, and unattended readiness gates. |
| `skills\create-pr\SKILL.md` | authoritative | Installed Create PR workflow source. |
| `config\pr-messaging.json` | authoritative | Host and migration state. |
| `config\pr-messaging-manifests\` | authoritative | Destination task, machine, and dispatchability records. |
| `%LOCALAPPDATA%\BuyYourHome\PRMessaging\client.json` | machine-local authority | Project Room/task registrations for the local Codex Windows profile. |
| Wes instruction on 2026-09-01 | authoritative | Require one machine-local dispatcher and unattended cross-machine validation; create the WES-VIDEOEDITOR dispatcher. |
| `prmsg-jean-wve-lowtoken-worker-development-20260905-001`, hash `96ef71430764f41d1e9f7ab165f96238b6dbd763a562489778bcb12622d7e611` | authoritative central reference; directly authorized by Wes in owning task | Isolated worker/adapter development and bounded read-only shadow; WES-VIDEOEDITOR owns implementation; heartbeat unchanged, no production or cutover. |
| `Project Rooms\Jean Wright\outputs\24-Hour Low-Token Dispatcher Design.md` | design, not deployment authority | Atomic claim, journal/recovery, modes, health and rollout gates. Older WESSTUDIO-first implementation wording is superseded by the September 5 development record. |
| `prmsg-wve-cli-queue-wakeup-validation-20260905-001`, hash `cd41b2c4993e3214557fccf906e5e508cc38f3ef60580a9b1106e75c870ae3c0` | completed central gate, re-read September 5 | One prior CLI 0.153.1 queue wake-up, distinct Quickbooks recipient acceptance/completion and desktop read-only probe. Not worker/busy/reboot proof; never replay this test. |
| `tools\pr-messaging\low-token\` | isolated development release 0.2.0 | Dispatcher-owned serialized source and fixture recovery tests; no active manager or heartbeat replacement. |
| `prmsg-jean-wve-lowtoken-worker-canary-gate-20260905-001`, hash `8a29a54a15eb28b6a3c5c08d7581e1e97295d08d7a51c578217b7ac6484ee569` | direct authorized next gate | Real supported read-only busy/pending probe before one exact worker synthetic; no heartbeat change, production, installation or reboot/outage testing. |
| `tools\pr-messaging\low-token-canary\` and `outputs\WES-VIDEOEDITOR Worker Canary Gate 2026-09-05.md` | additive prerequisite, blocked before canary creation | Fail-closed read-only runtime probe, isolated tests and exact unavailable-control-endpoint evidence; prior worker/transport untouched. |
| Wes direct instructions in owning WES-VIDEOEDITOR task, 2026-09-07 | authoritative for scoped development | Implement destination serialization without the unavailable status connection; test restart recovery, concurrency, outages and duplicates. Heartbeats remain paused and production deployment disabled. |
| `prmsg-wve-busy-anchor-20260907-1207-7e31` and `prmsg-wve-busy-followup-20260907-1207-7e31` | completed bounded behavior evidence; never replay | One CLI submission while controlled Quickbooks turn active. Distinct subsequent turn, one receipt lifecycle, no interruption. Does not prove real CLI restart/outage durability. |
| Canonical manager List snapshots and release 0.2.0 pure predicates, 2026-09-07 13:03 UTC | read-only reconciliation evidence | 29 local records checked; prior busy tests Completed; nine Quickbooks historical holds, three hash discrepancies and one exhausted ambiguous self-test require review before canary. See serialized canary preparation output; no queue changes. |
| Wes's explicit yes to exact administrative closure and worker corrections, 2026-09-07 | authoritative scoped change | One invalid record administratively retired with Failed history and absent receipt/result preserved; dual-encoding verification and verified-terminal transport release approved. No other closure, business processing, production activation or heartbeat resume. |
| `outputs\WES-VIDEOEDITOR Administrative Closure and Integrity Correction 2026-09-07.md` | subsequent implementation/evidence | Supersedes unresolved-hash diagnosis in the earlier preparation report; records exact administrative disposition, tests, read-only shadow and remaining gates. |
