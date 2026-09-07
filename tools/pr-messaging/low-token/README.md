# Low-token dispatcher development release 0.2.0

Owner: PR Messaging Dispatcher on WES-VIDEOEDITOR. Direct Wes authorization and central record `prmsg-jean-wve-lowtoken-worker-development-20260905-001` control; older WESSTUDIO-first wording is superseded for implementation ownership only.

Wes directly authorized the serialized-worker change and isolated restart, concurrency, outage and duplicate-prevention tests in owning task `01a05d0c-8031-7d92-9474-ab2330008ddb` on 2026-09-07. Keep all heartbeats paused. Passing these development tests does not activate or authorize production deployment.

## Deployment boundary

This is an isolated development package, not an installed worker. Existing heartbeat, active manager/helper, manifests, registrations, ACLs, credentials and other PRs remain unchanged. No recurring task is registered. No production claims are enabled.

- `Manage-ProjectRoomMessage.Development.ps1` is a staged copy of the active manager with additive conditional claim/reconciliation operations. Every operation requires a marked fixture under the current profile's temporary directory. It cannot be used against the central share.
- `Invoke-LowTokenWorker.ps1` runs one bounded tick. Default `Shadow` calls only the configured canonical manager's `List`; it writes only its separate profile-local health file. `Validation` and `Drain` require fixtures; `Live` fails closed; `Paused` does no queue processing.
- `Invoke-CodexQueueAdapter.ps1` validates exact IDs, forbids self-notification, pins the CLI executable, and builds the constant argv message. `-DescribeOnly` is safe. Real submissions deliberately fail closed in this development release. `Process.ps1` supplies tested structured Windows argument quoting, redirected output and bounded child execution for the later reviewed adapter.
- `Install-LowTokenWorker.ps1 -PlanOnly` emits a versioned, hashed installation/rollback plan. Actual installation fails closed.

## Atomic manager behavior

`ConditionalClaim` re-reads the record under the existing `.queue.lock`, verifies immutable hash, expected full-record version, client/manifest snapshot, exact recipient identity and registration, explicit synthetic authorization, one-attempt budget, validation-manifest ID, retry delay and no outstanding same-destination work. Accepted/Processing, ambiguous or invalid completion records retain the destination; only verified Completed or proven non-submission releases it. Blocked/Needs Wes/rejection stay held for review. The fixture ownership file binds worker name, generation, machine, Windows SID and exact synthetic ID. Existing same-attempt claims are idempotent and **never** grant another submission.

`ReconcileAttempt` operates under the same lock, requires the original hash/attempt/ownership, validates recipient identity, and lets an exact receipt win over prior ambiguity. It does not overwrite newer recipient state/result. Legacy `StartAttempt` is rejected once exclusive ownership is installed in the staged fixture manager; without ownership, existing operations retain their original behavior. This guard is not deployed to the active manager yet.

## Journal and bounded execution

The per-profile singleton lock encloses the tick. Manager subprocesses are bounded by the remaining tick budget (maximum 55 seconds); adapter subprocesses are bounded too. `Invoke-ManagerCommand.ps1` is a fixed, hash-pinned UTF-8 relay: real manager access is List-only; mutations require the staged fixture manager. No polling loop, sleep, model request, task creation or business operation is used by the worker.

Journal schema 2 phases are `planned`, `claimed`, `submission_started`, `submitted`, `awaiting_completion`, `unresolved`, `closed`. Entries retain message/dispatch/destination/attempt/hash, UTC timestamps, adapter release/hash, queue acknowledgment ID and hashed output/exit/timeout evidence, never payload copies. Journal/health writes use flushed sibling temporary files plus atomic replacement. The submission-start marker precedes the external effect. Recovery never re-submits an existing attempt: pre-submission proof closes NotDelivered; possible submission without a verified durable queue acknowledgment becomes ambiguous and retains its destination. Exact acceptance marks delivery but retains the slot until verified completion. Missing journals reconstruct owned attempts conservatively, including already ambiguous or accepted attempts. A corrupt/old-schema journal or missing/stale canonical record blocks without discarding evidence. There is no automatic journal migration or erasure.

A verified adapter acknowledgment must bind the exact message, destination and attempt to a queue UUID, report submitted=true and accepted=false, and have a successful process result. A queue acknowledgment is not a recipient receipt. Long waits retain Pending and the slot; `queued_receipt_warning_seconds` (recommended 600, allowed 1–86400) emits `QueuedReceiptOverdue` attention only, not a retry or automatic failure/release. Error/timeout/malformed/wrong-target responses remain uncertain. There is no deadline that makes a possibly submitted message safe to repeat.

Reconciliation precedes candidate evaluation. The local durable slot and the central manager's locked same-destination check serialize worker submissions, including workers with separate journals. Other destinations remain evaluable unless evidence integrity blocks the tick. No busy inventory or desktop busy/pending-status connection is required. This change relies on the bounded real CLI test on 2026-09-07, which queued one follow-up behind a controlled active turn and delivered it in a separate subsequent turn without interruption. It is not universal crash/outage proof. Terminal/exhausted exact validation never selects another ID; live mode remains unavailable.

## Testing

Run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File <release>\tests\Test-LowTokenWorker.ps1 -EvidenceDirectory <profile-temp-output>` under the intended Windows identity. Tests create unique marked temporary fixtures and fake adapters. They never notify real tasks. Test evidence/fixtures stay outside Git and are retained for review.

Run `tests\Test-SerializedWorker.ps1 -EvidenceDirectory <profile-temp-output>` through the same PowerShell wrapper for hard process termination at four durable boundaries, actual competing worker processes with shared/separate journals, delayed acceptance/completion, outage recovery, stale/lost/corrupt journals and duplicate-prevention checks. `CrashTestPauseAt` is a fixture-only 30-second rendezvous; the harness kills only its own validated child PID. This is worker-process restart and simulated queue/adapter outage testing, not a machine reboot, desktop restart, SMB credential outage or power-loss test. Fake receivers do not prove real CLI crash durability.

Use `Invoke-LowTokenWorker.ps1 -ConfigPath <profile-local-shadow-config> -Mode Shadow` for a separately authorized bounded real-queue observation. Config pins `package_sha256` (Get-LtPackageHash), `manager_sha256`, expected machine/SID, `release: 0.2.0`, `max_tick_seconds` (5–55), `queued_receipt_warning_seconds` (1–86400), canonical manager/share, normal client path, manifest directory and separate state directory under `%LOCALAPPDATA%\BuyYourHome\PRMessaging\low-token`. `tests/Invoke-BoundedShadow.ps1 -Ticks 3` creates that isolated evidence configuration under the normal WVE identity, captures before/after record fingerprints and verifies zero claims/submissions/model requests. No owner file or live queue configuration is written by shadow mode.

## Review before canary or installation

1. Preserve the successful CLI gate (`prmsg-wve-cli-queue-wakeup-validation-20260905-001`); do not repeat it or either prior synthetic.
2. Review the staged manager diff and all failure results. The existing heartbeat must stay unchanged until a separately approved cutover.
3. Review serialized queue recovery and duplicate controls. The unavailable desktop status connection is not a dependency of release 0.2.0; the fixture adapter is not real CLI restart/outage proof.
4. Approve one fresh exact synthetic for the worker canary, with one submission and exclusive test ownership; update its validation manifest only through the owning workflow.
5. Pin the reviewed adapter/release, exercise actual worker-to-recipient receipts and tool parity, then restart/login/offline behavior without production work.
6. Only after reviewed compatibility and exclusive ownership may the active manager be replaced. If deployment requires pausing transport, obtain approval first. Live activation remains a separate decision.

Integration handoffs (not performed here): Jean owns shared policy/registry cutover; Email Monitor owns removal of its embedded dispatcher and mailbox regression; Dashboard owns transport/stalled-work attention views; Create PR owns onboarding/readiness changes. WESSTUDIO Email Monitor remains paused.
