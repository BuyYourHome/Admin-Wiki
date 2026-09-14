# 24/7 Deterministic Worker Release 0.4.0

## Outcome

Release `0.4.0` is live on WES-VIDEOEDITOR and OFFICEASSIST after their staged validations completed. WESSTUDIO remains pending its separate machine-local cutover.

## Behavior

- Runs as a limited Windows scheduled task every 60 seconds, 24/7.
- Runs PowerShell in hidden-window mode so scheduled ticks do not display a console or interrupt typing.
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

## WES-VIDEOEDITOR Result

Synthetic `prmsg-wve-low-token-worker-validation-20260913-001` completed through one delivered attempt with exact Accepted, Processing, and Completed events. The read-only recipient self-task check succeeded and no business action occurred. After the SMB-safe owner replacement hotfix in `f13c56fa`, WES-VIDEOEDITOR promoted at `2026-09-14T01:04:33.2988501Z`. Scheduled task `BYH PR Messaging Worker - WES-VIDEOEDITOR` runs every 60 seconds in `Live` mode for Quickbooks. The old assisted worker is disabled and the model heartbeat remains paused. Two empty live ticks made zero claims, submissions, model requests, or notifications.

## OFFICEASSIST Result

OFFICEASSIST staged the worker under dedicated dispatcher task `01a09d84-a309-7591-a790-e770fcb53dee`, separately from Doc Scan, Email Monitor, and Invoice Entry. Synthetic `prmsg-officeassist-low-token-worker-docscan-validation-20260914-001` completed through one delivered attempt with exact Accepted, Processing, and Completed events and no business action. After Doc Scan was promoted to ready and dispatchable, OFFICEASSIST promoted owner `low-token-officeassist` to `Live`. Scheduled task `BYH PR Messaging Worker - OFFICEASSIST` now runs every 60 seconds in `Live` mode for Email Monitor, Doc Scan, and Invoice Entry. One eligible production record was delivered to Email Monitor and ended Blocked under destination rules because required delivery-package fields were missing; no email or Outlook draft was created. Two subsequent empty live ticks made zero claims, submissions, model requests, notifications, or errors. Email Monitor's embedded dispatcher stage was then removed while its existing active mailbox heartbeat, schedule, target, notification policy, and mailbox functions were preserved.

## Deployment Lessons

- Machine-local scheduled tasks, installed packages, health files, and central owner records are runtime state outside Git. Record verified status in Git from the coordinating task; do not create empty commits on deployment machines.
- Pulling a source hotfix does not update a profile-local staged package. Refresh that package before retrying validation or promotion.
- A successful CLI queue result is not acceptance. The validation remained pending while Quickbooks was `notLoaded`; opening the existing task allowed the original queued request to complete. No duplicate wake-up was required or permitted.
- Each computer needs a dedicated dispatcher task identity separate from every operational destination. This is required on OFFICEASSIST so Email Monitor can remain a destination after its embedded dispatcher stage is removed.

## Verification

The primary fixture baseline passed 56 checks on September 13, 2026. A focused restricted-share-compatible owner-replacement regression, the 34-check one-shot compatibility suite, and focused crash-boundary reruns also passed. Coverage includes atomic claims, version/config conflicts, destination serialization, restart boundaries, timeout ambiguity, late receipts, queue outage recovery, singleton execution, machine-scoped ownership, legacy-owner exclusion, fresh worker validation without overwriting historical room readiness evidence, per-attempt submission markers, Unicode transport, and competing claimers. The tests made zero production changes and zero real CLI submissions. One administrative-closure test remains intentionally WES-VIDEOEDITOR-bound and cannot pass on WESSTUDIO because the canonical operation rejects the wrong machine identity.
