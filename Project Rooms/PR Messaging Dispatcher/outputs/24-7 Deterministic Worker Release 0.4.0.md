# 24/7 Deterministic Worker Release 0.4.0

## Outcome

Release `0.4.0` is ready in the canonical repository for a WES-VIDEOEDITOR-first staged validation. It is not deployed by this source change. The existing WES-VIDEOEDITOR QuickBooks-only assisted worker remains the current runtime until cutover.

## Behavior

- Runs as a limited Windows scheduled task every 60 seconds, 24/7.
- Reads the central queue without starting a model on empty polls.
- Pins exact locally registered destinations from canonical manifests at staging.
- Claims at most one eligible record per tick under the canonical queue lock.
- Uses one machine-scoped exclusive transport owner, allowing independent machine migration.
- Writes a durable journal before submission and a permanent marker per message and attempt.
- Queues one CLI wake-up to the exact destination task.
- Treats CLI queue acknowledgment as pending, not as acceptance.
- Never automatically retries a possibly submitted attempt.
- Holds each destination until exact authoritative receipt and terminal evidence are verified.

## WES-VIDEOEDITOR Gate

1. Pull the release on WES-VIDEOEDITOR and verify a clean `main`.
2. Run `Install-LowTokenWorker.ps1 -Action Stage`. This creates a disabled task and does not claim or change queue ownership.
3. Create one fresh cross-machine synthetic addressed to a pinned WES-VIDEOEDITOR destination. It must allow one attempt and no business action. Update that destination manifest to `validation_ready` with the exact message id when needed.
4. Run `-Action StartValidation -ValidationMessageId <exact-id>` on WES-VIDEOEDITOR. This disables the old QuickBooks-assisted scheduled task, installs validation-only ownership, and enables only the exact synthetic.
5. Verify one attempt and exact `Accepted`, `Processing`, and `Completed` evidence.
6. Promote the destination manifest to `ready` and `dispatchable: true`, pull that change on WES-VIDEOEDITOR, then run `-Action PromoteLive`.
7. Verify at least one empty tick reports zero model requests and one new synthetic result return reaches the correct local destination exactly once.

## Rollback

Run `-Action Rollback` under the same Windows identity. It removes only release `0.4.0`'s scheduled task and its own machine-scoped owner. It preserves local journals and all central records. Restore the prior dispatcher explicitly only after reconciling any unresolved attempt.

## Following Machines

After WES-VIDEOEDITOR passes, create or verify one separate dispatcher task on OFFICEASSIST and WESSTUDIO. Repeat the same staged lifecycle on each machine. OFFICEASSIST removes only Email Monitor's embedded dispatcher stage after its worker is live; Email Monitor mailbox and summary functions remain active on their own schedule.

## Verification

The primary fixture suite passed 56 checks on September 13, 2026. The 34-check one-shot compatibility suite and focused crash-boundary reruns also passed. Coverage includes atomic claims, version/config conflicts, destination serialization, restart boundaries, timeout ambiguity, late receipts, queue outage recovery, singleton execution, machine-scoped ownership, legacy-owner exclusion, fresh worker validation without overwriting historical room readiness evidence, per-attempt submission markers, Unicode transport, and competing claimers. The tests made zero production changes and zero real CLI submissions. One administrative-closure test remains intentionally WES-VIDEOEDITOR-bound and cannot pass on WESSTUDIO because the canonical operation rejects the wrong machine identity.
