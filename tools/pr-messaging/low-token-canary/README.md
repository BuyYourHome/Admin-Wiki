# Validation-only worker canary prerequisite

Owner: WES-VIDEOEDITOR PR Messaging Dispatcher, task `01a05d0c-8031-7d92-9474-ab2330008ddb`.

Authority: `prmsg-jean-wve-lowtoken-worker-canary-gate-20260905-001`, hash `8a29a54a15eb28b6a3c5c08d7581e1e97295d08d7a51c578217b7ac6484ee569`. This package is a **read-only prerequisite**, not an enabled worker canary. The original `low-token` development release and active manager/helper/heartbeat remain unchanged.

## Installed interface and safety

Installed CLI 0.153.1 advertises `codex app-server proxy` for an existing control socket. Its generated experimental schema includes `thread/read` and `thread/queue/list`. The probe connects only through that advertised existing proxy. It never starts a daemon/server, opens a separate runtime, reads private runtime databases, creates/resumes a task, queues a message, interrupts a turn, or answers an approval/tool request.

`Get-CodexTaskReadiness.ps1` pins the CLI executable/hash, normal WVE identity and two allowed read-only target IDs: the exact Quickbooks recipient and existing dispatcher. `CodexReadOnlyProbe.ps1` sends only initialize/initialized, metadata-only thread/read, a one-item queue/list, and a second thread/read. Pending content is never copied to evidence. An active task defers immediately; any pending item or pagination cursor defers; missing/malformed/unknown/unavailable status defers. Two idle observations and an empty pending page are a snapshot only, not atomic permission to claim or submit.

Every returned observation retains `canary_gate_satisfied: false`. The real busy/pending behavior prerequisite and worker integration are not proved on this host. There is no claim or submission code in this package, and it is not wired into the existing worker or heartbeat.

## Current blocker

The actual normal-profile proxy exited 1 before a read response:

```text
Error: failed to connect to socket at C:\Users\IRAMa\.codex\app-server-control\app-server-control.sock

Caused by:
    A socket operation encountered a dead network. (os error 10050)
```

The advertised control directory was absent. `codex app-server daemon version` separately returned `Error: codex app-server daemon lifecycle is only supported on Unix platforms`. This is a local runtime-proxy blocker, not proof that SMB or the internet is unavailable. The canonical manager remained reachable.

The app's model-accessible `read_thread` reported Quickbooks idle, but that is neither a worker-callable pending-queue probe nor proof of real busy behavior. It must not be substituted for the failed prerequisite. A fresh standalone app-server could also report a different runtime state; it is not a safe substitute for the current desktop session.

## Reproduction

Read-only real probe, no canary creation:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token-canary\Get-CodexTaskReadiness.ps1" -EvidencePath "C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token-canary\20260905\recipient-probe.json"
```

Isolated evaluator/protocol tests:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token-canary\tests\Test-CodexReadOnlyProbe.ps1" -EvidencePath "C:\Users\IRAMa\AppData\Local\Temp\byh-canary-probe-tests-normal-20260905\results.json"
```

## Next gate

Establish a supported, authenticated read-only connection to the **existing Windows desktop runtime**, then verify actual busy and pending-submission observations without interrupting work. Unknown must continue to defer. Only after those checks and reviewed canary-specific manager/worker/adapter regression tests pass may the existing authorization create `prmsg-wve-lowtoken-worker-canary-20260905-001` with max attempts/submissions one. No general real-submission path, production mode, recurring installation, reboot/outage tests or heartbeat change is authorized here.

Reference: [official App Server documentation](https://learn.chatgpt.com/docs/app-server) describes non-resuming thread/read and installed schema generation. The CLI-generated 0.153.1 schema, not a different machine's or online version's assumptions, controls exact method shapes.
