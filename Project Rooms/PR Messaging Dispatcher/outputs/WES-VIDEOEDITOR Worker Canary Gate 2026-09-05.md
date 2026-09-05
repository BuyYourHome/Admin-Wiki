# WES-VIDEOEDITOR Worker Canary Gate

Date: 2026-09-05. Status: **Blocked before fresh synthetic creation/claim**.

## Scope and reconciliation

Direct Wes authorization and central gate `prmsg-jean-wve-lowtoken-worker-canary-gate-20260905-001`, immutable hash `8a29a54a15eb28b6a3c5c08d7581e1e97295d08d7a51c578217b7ac6484ee569`, were reconciled in exact owning task `01a05d0c-8031-7d92-9474-ab2330008ddb`. The owner wrote Accepted/Processing without a transport attempt or self-notification.

Base `5be606d2b08dc26a5dbecb1b4fe45417c1cde5dd` on canonical `C:\Codex\Wiki Files`, branch main, was clean and equal to origin/main after safe fetch. WES-VIDEOEDITOR remains implementation owner; no other PR or machine was changed.

The exact prospective canary is `prmsg-wve-lowtoken-worker-canary-20260905-001`, recipient Quickbooks / `01a05967-9a05-7081-a62e-616b2d8e61fd` / WES-VIDEOEDITOR. Canonical manager Get returned **Message record not found**. No canary was created because the record requires supported busy/pending checks first. Therefore canary payload hash and lifecycle timestamps are not available, attempts/submissions are zero, and no recipient acceptance/completion is claimed. No prior synthetic was reused or changed.

## Actual runtime evidence

Normal identity: `WES-VIDEOEDITOR\IRAMa`. CLI: `0.153.1`, path `C:\Users\IRAMa\AppData\Local\OpenAI\Codex\bin\1e3e57cdf0634c02\codex.exe`, SHA-256 `56A84DE2B617AF6B95B0C5C5D8AE120D3C2FB69008AB330C7E7DF3945B98B782`.

The installed help advertises a shared-runtime `app-server proxy`. The generated experimental 0.153.1 JSON schema provides non-resuming `thread/read` runtime status and `thread/queue/list` pending submissions (with pagination). The schema was generated outside Git at `C:\Users\IRAMa\AppData\Local\Temp\byh-canary-protocol-20260905`. Method availability does not prove endpoint availability.

Actual proxy command:

```text
codex app-server proxy
```

Exact stderr, exit 1:

```text
Error: failed to connect to socket at C:\Users\IRAMa\.codex\app-server-control\app-server-control.sock

Caused by:
    A socket operation encountered a dead network. (os error 10050)
```

`C:\Users\IRAMa\.codex\app-server-control` did not exist. The separate read-only command `codex app-server daemon version` returned:

```text
Error: codex app-server daemon lifecycle is only supported on Unix platforms
```

No start/restart/bootstrap/remote-control command was run. No socket/ACL/credential/network setting was changed. No private runtime DB, guessed endpoint or second runtime was substituted. This failure does not establish an SMB outage; the canonical messaging manager was reachable.

The app's read-only task tool independently reported Quickbooks `idle`, cwd `C:\Codex\Wiki Files`, latest completed turn `01a07318-460c-75c3-94a0-59fe0f70ee24`. That model-facing observation does not satisfy a deterministic worker's pending-task probe and does not prove real busy behavior. No active destination was interrupted and no artificial business task was started to create busy state.

## Additive probe and tests

New source only: `tools\pr-messaging\low-token-canary\CodexReadOnlyProbe.ps1`, `Get-CodexTaskReadiness.ps1`, `tests\Test-CodexReadOnlyProbe.ps1` and README. Existing worker release, active manager/helper, adapter real-submission guard and fixture guards remain unchanged. No real validation path was enabled before the prerequisite passed.

The probe allowlists only initialize/initialized, thread/read (includeTurns false), thread/queue/list (limit one) and a second thread/read. Busy, pending, unknown, malformed, missing or unavailable observations defer. It does not answer server-initiated approvals or perform task mutations. Two idle reads are only a momentary observation; `canary_gate_satisfied` remains false until actual runtime proof and reviewed worker integration exist.

Real probe at `2026-09-05T20:47:28.1902377Z` returned:

- `disposition: Unknown`, `defer: true`, `reason: RuntimeUnavailable`.
- Exception type `System.Management.Automation.RuntimeException`, error `ProxyClosedBeforeReadOnlyResponse`.
- Preserved exact proxy stderr above and exit 1; only initialize was attempted, no read result received.
- Zero claims, submissions or model requests; `canary_gate_satisfied: false`.
- Probe executable-source hash `2c273a5c8561880ca2d100a31d2acffe11578af2c6029c05b2719f57b16e4974`.
- Evidence: `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token-canary\20260905\recipient-probe.json`.

The 22 isolated probe tests passed under the normal identity at `2026-09-05T20:47:47.7086637Z`: active/pending deferral, unknown status, missing/malformed data, identity/cwd mismatch, pagination, idle-to-active race, missing second read, read-only method allowlist, busy early exit and unavailable executable. They are fixture evidence, not claims of successful real busy/pending inspection. Evidence: `C:\Users\IRAMa\AppData\Local\Temp\byh-canary-probe-tests-normal-20260905\results.json`.

The existing isolated worker regression rerun passed **50/50**, zero failures, exit 0, at `2026-09-05T20:52:58.6497894Z` under the normal Windows identity. It includes crash, late-receipt, timeout, busy/pending, singleton and concurrent-claimer behavior; no real notifications or central mutations occurred. Evidence: `C:\Users\IRAMa\AppData\Local\Temp\byh-canary-worker-regression-20260905\test-results.json`. Combined isolated checks: **72 passed, zero failed**. Three new PowerShell files also passed syntax parsing and Git whitespace checks. These results do not establish actual recipient activation or completion.

## Preserved transport and remaining gates

The exact Quickbooks manifest is ready/dispatchable and the normal-profile client has exactly one matching Quickbooks/task registration. No registration or readiness edits were made.

Automation `pr-messaging-dispatcher-wes-videoeditor` is unchanged: ACTIVE, every five minutes, 24/7/no expiry, same task and persistent old completed-test filter `prmsg-create-pr-wve-quickbooks-transport-validation-20260905-001`. It excludes the prospective worker canary. TOML hash: `396A76280B0FD3364CC1346FFA0E0D7605C017B5E6296E92E86252D0BBB4F8DB`.

Existing worker package SHA-256 remains `1e3deadb6b3da8dbcfa386513b4ae88240286e7dd32e1c31d188308e1bba523a`; active manager `7742BD122E23DC2F2189FC847126800E8CE52047F6EB77539CCBA92604809314`; active helper `79B4DC9D7CB936A31ABF80E97FBC95691F03B7A9AEA5B49761DCA8946FFB8130`. No existing executable source was modified.

There were no production claims, real queue submissions, business/browser/QuickBooks/mailbox actions, recurring installations, new tasks/automations, app restarts, reboots/logouts, SMB disconnects, outage simulation, global transport-generation changes or other-machine changes. WESSTUDIO Email Monitor was not resumed.

Immediate blocker: no usable supported connection to the existing Windows desktop runtime was established for busy/pending reads. Establish that connection without interrupting work, then verify real busy/pending behavior and review/regression-test the exact canary-only manager/worker/adapter path before creating or claiming the approved single synthetic. Do not resolve this by treating unknown as idle or invoking a model dispatcher.

After an actual canary, restart/login/outage/24-hour soak, unattended recurring installation, controlled transport cutover and production authorization remain separate gates. Commit/push evidence for this scoped probe and blocker report is returned in the owning task and canonical gate result. Publishing this prerequisite source does not enable any new transport.
