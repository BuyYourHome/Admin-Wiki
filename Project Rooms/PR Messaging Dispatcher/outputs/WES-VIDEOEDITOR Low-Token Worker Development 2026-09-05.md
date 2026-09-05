# WES-VIDEOEDITOR Low-Token Worker Development

Date: 2026-09-05. Release: 0.1.0, isolated development package; **not installed or enabled for real submissions**.

## Authority and preserved boundaries

Central record `prmsg-jean-wve-lowtoken-worker-development-20260905-001`, verified hash `96ef71430764f41d1e9f7ab165f96238b6dbd763a562489778bcb12622d7e611`, controls this work. Wes directly authorized implementation in existing owner task `01a05d0c-8031-7d92-9474-ab2330008ddb`. The exact owner wrote Accepted and Processing without a transport attempt or self-notification. WES-VIDEOEDITOR supersedes the design's older WESSTUDIO-first implementation wording, not its safety gates.

No production claims, real recipient notifications, business actions, new tasks, recurring installation, cutover, registration/manifest promotion, credential/ACL changes or other PR edits occurred. Existing heartbeat and active manager/helper were not edited. This result completes a development gate, not deployment readiness.

The prior independent CLI gate was re-read, not repeated: `prmsg-wve-cli-queue-wakeup-validation-20260905-001`, hash `cd41b2c4993e3214557fccf906e5e508cc38f3ef60580a9b1106e75c870ae3c0`, Completed at `2026-09-05T19:46:45.2167014Z`, one permitted submission to distinct Quickbooks task `01a05967-9a05-7081-a62e-616b2d8e61fd`. That gate demonstrated idle task activation and a desktop read-only tool probe. Browser capability was present but not exercised. It does not prove busy/restart/offline behavior or the new worker canary.

Installed local CLI: `0.153.1`, `C:\Users\IRAMa\AppData\Local\OpenAI\Codex\bin\1e3e57cdf0634c02\codex.exe`, SHA-256 `56A84DE2B617AF6B95B0C5C5D8AE120D3C2FB69008AB330C7E7DF3945B98B782`. Do not substitute the design's other-machine version.

## Source delivered

All new executable source is under `tools\pr-messaging\low-token\`:

| File | Implemented boundary |
| --- | --- |
| `Common.ps1` | Immutable payload/version/config hashes, path/fixture checks, UTF-8 atomic journal writes, exact synthetic/identity/registration eligibility and receipt predicate. |
| `Manage-ProjectRoomMessage.Development.ps1` | Staged legacy manager copy, fixture-only; additive operations enter the existing queue lock. Active manager remains unchanged. |
| `Manager.Extensions.ps1` | Expected-version/config conditional claim, idempotent same-attempt recovery, owner/generation/SID/task validation, legacy-owner guard, receipt-preserving reconciliation. |
| `Invoke-LowTokenWorker.ps1` | Singleton, bounded tick, reconcile-first journal, at most one fixture claim/submission, explicit Shadow/Validation/Live/Drain/Paused modes, no blind resubmission. Live fails closed. |
| `Invoke-ManagerCommand.ps1` | Pinned fixed-parameter UTF-8 relay; real manager List only; mutations require the staged fixture manager. |
| `Process.ps1` | Windows argv quoting, non-shell hidden child process, redirected output, bounded timeout. No approval-bypass CLI flags. |
| `Invoke-CodexQueueAdapter.ps1` | Exact UUID/hash constant wake-up template, CLI executable pin, self-notification rejection and submission-versus-acceptance classification. Describe-only works; real submission entry point remains disabled. |
| `Install-LowTokenWorker.ps1` | Versioned/hash-pinned plan and rollback prerequisites only; actual installation is disabled. |
| `tests\Test-LowTokenWorker.ps1` | Isolated fixture/failure test harness; evidence retained outside Git. |
| `tests\FakeAdapter.ps1`, `tests\Echo-Arguments.ps1` | Fake submission/failure/timeout and argv fixtures; no real task operations. |
| `tests\Invoke-BoundedShadow.ps1` | One to three read-only real-queue ticks under the intended WVE identity, with before/after fingerprints. |
| `README.md` | Configuration, safety boundaries, reproduction commands, canary/rollback review and owner handoffs. |

Journal entries retain message/dispatch/hash/attempt, profile/owner generation, UTC transition evidence, adapter release/hash and hashed stdout/stderr plus exit/timeout. Missing/corrupt journal never justifies resubmission. Closed ambiguity remains reconcilable when a later exact recipient receipt appears. New behavior exists only in the development copy; staged legacy compatibility is not permission to deploy it.

## Tests

Final intended-identity suite: **50 passed, zero failed**, exit 0, completed `2026-09-05T20:25:12.1937177Z` under `WES-VIDEOEDITOR\IRAMa`. Evidence: `C:\Users\IRAMa\AppData\Local\Temp\byh-lowtoken-results-20260905-final\test-results.json`. Twelve PowerShell source files also passed syntax parsing. The earlier stable run passed 47/48; the busy-task test exposed a singleton-array diagnostic bug, subsequently fixed. Earlier iterations also exposed Windows PowerShell 5.1 File.Replace null conversion, argument-array construction and JSON-array enumeration issues. Those were corrected before the final passing suite.

Reproduction command (isolated fixtures and fake adapters only):

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\tests\Test-LowTokenWorker.ps1" -EvidenceDirectory "C:\Users\IRAMa\AppData\Local\Temp\byh-lowtoken-results-20260905-final"
```

| Injected condition | Verified result |
| --- | --- |
| Crash after plan, before claim | Recovery finds no central attempt; subsequent eligible fixture claim makes one submission. |
| Crash after central claim, before submission marker | NotDelivered, no submission; one-attempt budget remains consumed. |
| Crash after submission marker but before fake adapter | Conservatively ambiguous, no blind retry. |
| Crash after fake adapter | One submission; later tick reconciles ambiguity, never repeats it. |
| Fake adapter error or timeout | Bounded child execution; one submission; ambiguity rather than claimed delivery. |
| Late exact receipt after closed ambiguity | Delivered attempt reconciled; newer recipient completion preserved. Wrong-recipient receipt never proves delivery. |
| Concurrent worker/claimers or stale owner | Singleton/ownership/CAS guards prevent a second successful claimant or submission. |
| Busy destination or missing/corrupt journal | No unsafe new submission; corruption preserved; unrelated destination remains evaluable. |

The real-queue shadow initially exposed console encoding best-fit corruption of Unicode text into invalid JSON. A new UTF-8 relay corrected this without changing the active manager; the suite includes a Unicode subprocess regression.

Failure coverage includes CAS/config conflicts; owner/generation/legacy race; missing/blank/wrong/terminal filters; hash/task/machine/registration/authorization/synthetic/budget failures; empty shadow and paused/live barriers; duplicate submission prevention; crashes after planning, claiming, before adapter and after adapter; late exact and wrong receipts; busy/pending destination isolation; offline recovery; missing/corrupt journal; adapter failure/timeout; singleton and two-process claim race; package drift; validation rollback restriction; argv quoting; submission journal evidence; and installer/real-CLI safety barriers.

## Final bounded shadow evidence

Normal identity: `WES-VIDEOEDITOR\IRAMa`. Full 50-test/three-tick package SHA-256: `a37b62797245d423c153344a27b40d7ff13693dc2dc83201e4f5b13f50a2a280`. Final publication package SHA-256: `1e3deadb6b3da8dbcfa386513b4ae88240286e7dd32e1c31d188308e1bba523a`. The only executable-file change afterward removed one extra blank line at EOF from the staged manager for Git whitespace validation; no functional code changed. Hashes cover top-level executable source; config must pin actual local release bytes, including checkout line endings.

Final observation: `2026-09-05T20:20:10.5775650Z` through `2026-09-05T20:20:46.2221364Z`. Three ShadowComplete ticks, each below five seconds. Each read 143 canonical records through manager List and evaluated the same three local queued/ambiguous candidates: two `SelfNotificationForbidden`, one `ManifestMissingOrDuplicate`. No eligible candidate was claimed or notified. These are observations, not permission to repair or replay those records.

- Claims, submissions and worker model requests: zero on all three ticks.
- Central mutation and CLI invocation: zero; recurring installation: false.
- Before/after full-record fingerprint: `7f1f19ba7f40af6360df3889599f176ff019dd5a294a4e4f93bd5bc0f2202003`, unchanged.
- Profile-local evidence: `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token\shadow-20260905T202010Z\shadow-results.json` and individual tick files; no queue payloads copied into Git.

The final whitespace-only publication package passed syntax parsing and an additional one-tick smoke observation at `2026-09-05T20:26:55.6962415Z` through `2026-09-05T20:27:08.8290764Z`: same 143-record fingerprint/candidates, ShadowComplete, zero claims/submissions/model requests, unchanged automation/manager. Evidence: `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token\shadow-20260905T202655Z\shadow-results.json`. Final full-suite evidence SHA-256: `3F73C6CA1C5E70F6E0800A351A4678D40749DF6D5100D7FE2524BE67CD6D663C`.

Automation `pr-messaging-dispatcher-wes-videoeditor` stayed ACTIVE, every five minutes, 24/7 with no expiry, target task unchanged and persistent completed distinct-test filter unchanged. TOML SHA-256 stayed `396A76280B0FD3364CC1346FFA0E0D7605C017B5E6296E92E86252D0BBB4F8DB`.

Active manager SHA-256 stayed `7742BD122E23DC2F2189FC847126800E8CE52047F6EB77539CCBA92604809314`; active claim helper stayed `79B4DC9D7CB936A31ABF80E97FBC95691F03B7A9AEA5B49761DCA8946FFB8130`.

## Remaining gates and handoffs

1. Review the staged manager/worker and final tests. No live release is installed; the installer emits a plan, not a registered Windows task.
2. Implement and validate the real read-only desktop busy/pending-message probe. Current busy behavior is fixture evidence only; safe runtime-unavailable behavior and task concurrency remain unproved.
3. Separately authorize one fresh exact worker synthetic canary with exclusive test ownership, one submission and actual recipient receipts/tool parity. Do not replay any prior synthetic or change the working heartbeat during this gate.
4. Prove app restart, reboot/login/sleep, real SMB outage/recovery, deployment/rollback with in-flight ambiguity and a 24-hour empty-poll soak. Bounded fixture/shadow tests are not those proofs.
5. Finish reviewed installer activation and production-mode policy only after canary approval. Keep release/config pins, original transport snapshots and exclusive ownership; drain/reconcile before any eventual cutover. Production remains separately gated.
6. Jean owns shared policy/registry coordination; Email Monitor owns embedded-dispatch removal and mailbox regression; Dashboard owns transport/stalled-work attention; Create PR owns onboarding readiness. None of those files/skills were edited. WESSTUDIO Email Monitor was not resumed.

## Publication

Base: `f44cac7e767a9ba7350b31713fd046a3a528290c` on `main`, initially clean and current after safe fetch. Commit only this development package, this report and the owning source-inventory update. The final coherent scoped release is publishable under the central record's explicit instruction; publishing source is not runtime activation. Final commit/push evidence is returned in the owning task and authoritative development result.
