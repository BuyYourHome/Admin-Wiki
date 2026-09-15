# 24/7 Deterministic Worker Release 0.4.1

## Purpose

Release `0.4.1` is a controlled correction to the live `0.4.0` deterministic Project Room transport. It prevents weak manifest readiness from entering a staged package and distinguishes a provable pre-submission adapter failure from a possibly submitted notification.

## Changes

- Stage only exact manifests that are explicitly `ready` and dispatchable, or one exact `validation_ready` non-dispatchable destination with a named validation record.
- Write a permanent message/attempt marker immediately before the Codex queue command.
- Reconcile a non-timeout, nonzero adapter exit as `NotDelivered` only when that marker is absent.
- Preserve timeout, acknowledgment, marker-present, receipt, and conflicting-evidence cases as unresolved ambiguity with no automatic retry.
- Permit an identity-, owner-, version-, and authorization-bound administrative transport closure for an exhausted old ambiguity. The closure does not change its state or attempt history and does not claim delivery or business completion.
- Permit a guarded correction of an already-recorded ambiguity when the matching local journal proves the adapter stopped before submission. The prior ambiguity detail remains in correction evidence.
- Upgrade a live `0.4.0` installation in place while preserving task identity, owner generation, schedule, state directory, journal, and destination pins.
- Scope worker inventory to its own machine and avoid a redundant second queue read when recovery made no central change.

## WESSTUDIO Validation

WESSTUDIO upgraded in place under dispatcher task `01a06337-1b59-7dc2-9586-6660eb7b5da7`. The existing owner remained `low-token-wesstudio` with generation `0.4.0`; the model dispatcher heartbeat remained paused.

The exhausted record `prmsg-officeassist-wesstudio-low-token-worker-validation-20260914-001` was administratively closed as undelivered transport history without altering its ambiguous state, attempt history, absent receipt, or absent result.

During the upgrade, the first attempt for `prmsg-wve-synthetic-exception-setup-blocked-20260905-001` encountered the not-yet-updated adapter release gate before any submission marker or task notification. The guarded repair changed only that attempt from `DeliveryAmbiguous` to `NotDelivered`, preserved the original detail, and returned the same immutable record to `Queued`. The next normal worker tick submitted once; Create PR wrote an exact `Accepted` receipt and `Completed` result. No business action occurred.

One later historical Create PR status notification timed out without a marker or queue acknowledgment. It remains unresolved because timeout is not proof of non-submission. The worker correctly holds that destination and does not retry it automatically.

## Verification

- Integrity and closure suite: 47 passed, 0 failed.
- Full worker suite: 61 passed, 1 timing-sensitive crash-fixture assertion failed; the exact isolated test then passed 1 of 1 without a code change.
- Focused pre-submission repair suite: 12 passed, 0 failed.
- WESSTUDIO scheduled worker: enabled, hidden, Live, every 60 seconds.
- Post-install health: `TickComplete` with no worker error; unresolved notification evidence remains visible as attention.
- Production business actions performed by this release work: none.

## Rollout

WES-VIDEOEDITOR and OFFICEASSIST remain on installed release `0.4.0` until each computer pulls the published source and runs the guarded `UpgradeLive` action under its normal Windows identity. Upgrade one machine at a time and verify two healthy ticks before proceeding to the next. Do not run `Stage`, replace dispatcher tasks, reset journals, or reactivate model heartbeats for this upgrade.
