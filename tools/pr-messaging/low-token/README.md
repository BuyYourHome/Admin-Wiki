# Low-token dispatcher development release 0.1.0

Owner: PR Messaging Dispatcher on WES-VIDEOEDITOR. Direct Wes authorization and central record `prmsg-jean-wve-lowtoken-worker-development-20260905-001` control; older WESSTUDIO-first wording is superseded for implementation ownership only.

## Deployment boundary

This is an isolated development package, not an installed worker. Existing heartbeat, active manager/helper, manifests, registrations, ACLs, credentials and other PRs remain unchanged. No recurring task is registered. No production claims are enabled.

- `Manage-ProjectRoomMessage.Development.ps1` is a staged copy of the active manager with additive conditional claim/reconciliation operations. Every operation requires a marked fixture under the current profile's temporary directory. It cannot be used against the central share.
- `Invoke-LowTokenWorker.ps1` runs one bounded tick. Default `Shadow` calls only the configured canonical manager's `List`; it writes only its separate profile-local health file. `Validation` and `Drain` require fixtures; `Live` fails closed; `Paused` does no queue processing.
- `Invoke-CodexQueueAdapter.ps1` validates exact IDs, forbids self-notification, pins the CLI executable, and builds the constant argv message. `-DescribeOnly` is safe. Real submissions deliberately fail closed in this development release. `Process.ps1` supplies tested structured Windows argument quoting, redirected output and bounded child execution for the later reviewed adapter.
- `Install-LowTokenWorker.ps1 -PlanOnly` emits a versioned, hashed installation/rollback plan. Actual installation fails closed.

## Atomic manager behavior

`ConditionalClaim` re-reads the record under the existing `.queue.lock`, verifies immutable hash, expected full-record version, client/manifest snapshot, exact recipient identity and registration, explicit synthetic authorization, one-attempt budget, validation-manifest ID, retry delay and no pending same-destination attempt. The fixture ownership file binds worker name, generation, machine, Windows SID and exact synthetic ID. Existing same-attempt claims are idempotent and **never** grant another submission.

`ReconcileAttempt` operates under the same lock, requires the original hash/attempt/ownership, validates recipient identity, and lets an exact receipt win over prior ambiguity. It does not overwrite newer recipient state/result. Legacy `StartAttempt` is rejected once exclusive ownership is installed in the staged fixture manager; without ownership, existing operations retain their original behavior. This guard is not deployed to the active manager yet.

## Journal and bounded execution

The per-profile singleton lock encloses the tick. Manager subprocesses are bounded by the remaining tick budget (maximum 55 seconds); adapter subprocesses are bounded too. `Invoke-ManagerCommand.ps1` is a fixed, hash-pinned UTF-8 relay: real manager access is List-only; mutations require the staged fixture manager. No polling loop, sleep, model request, task creation or business operation is used by the worker.

Journal phases are `planned`, `claimed`, `submission_started`, `submitted`, `closed`. Entries retain message/dispatch/attempt/hash, UTC timestamps, adapter release/hash and hashed output/exit/timeout evidence, never payload copies. Journal/health writes use flushed sibling temporary files plus atomic replacement. The submission-start marker precedes the external effect. Recovery never re-submits an existing attempt: pre-submission proof closes NotDelivered; possible submission waits for the receipt deadline and becomes ambiguous. Missing/corrupt journal is not proof of non-delivery. Unknown pending entries are conservatively reconstructed as potentially submitted. A corrupt journal blocks and is preserved.

Reconciliation precedes candidate evaluation. Same-destination pending/busy work is deferred; other destinations remain evaluable. Fixture busy inventory is not proof of a real desktop busy-task probe. Terminal/exhausted exact validation never selects another ID. Retry delay/budget checks are preserved even if migration/rollback configuration changes; live mode is unavailable regardless.

## Testing

Run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File <release>\tests\Test-LowTokenWorker.ps1 -EvidenceDirectory <profile-temp-output>` under the intended Windows identity. Tests create unique marked temporary fixtures and fake adapters. They never notify real tasks. Test evidence/fixtures stay outside Git and are retained for review.

Use `Invoke-LowTokenWorker.ps1 -ConfigPath <profile-local-shadow-config> -Mode Shadow` for a bounded real-queue observation. Config pins `package_sha256` (Get-LtPackageHash), `manager_sha256`, expected machine/SID, `release: 0.1.0`, `max_tick_seconds` (5–55), `acceptance_deadline_seconds` (1–120), canonical manager/share, normal client path, manifest directory and separate state directory under `%LOCALAPPDATA%\BuyYourHome\PRMessaging\low-token`. `tests/Invoke-BoundedShadow.ps1 -Ticks 3` creates that isolated evidence configuration under the normal WVE identity, captures before/after record fingerprints and verifies zero claims/submissions/model requests. No owner file or live queue configuration is written by shadow mode.

## Review before canary or installation

1. Preserve the successful CLI gate (`prmsg-wve-cli-queue-wakeup-validation-20260905-001`); do not repeat it or either prior synthetic.
2. Review the staged manager diff and all failure results. The existing heartbeat must stay unchanged until a separately approved cutover.
3. Implement/verify a read-only busy/pending-task probe and safe unavailable-runtime behavior. The fixture adapter is not real desktop concurrency proof.
4. Approve one fresh exact synthetic for the worker canary, with one submission and exclusive test ownership; update its validation manifest only through the owning workflow.
5. Pin the reviewed adapter/release, exercise actual worker-to-recipient receipts and tool parity, then restart/login/offline behavior without production work.
6. Only after reviewed compatibility and exclusive ownership may the active manager be replaced. If deployment requires pausing transport, obtain approval first. Live activation remains a separate decision.

Integration handoffs (not performed here): Jean owns shared policy/registry cutover; Email Monitor owns removal of its embedded dispatcher and mailbox regression; Dashboard owns transport/stalled-work attention views; Create PR owns onboarding/readiness changes. WESSTUDIO Email Monitor remains paused.
