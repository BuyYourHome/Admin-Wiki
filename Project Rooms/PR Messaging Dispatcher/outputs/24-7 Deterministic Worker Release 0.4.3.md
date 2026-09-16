# 24/7 Deterministic Worker Release 0.4.3

Date: 2026-09-16

## Purpose

Release `0.4.3` corrects a live-worker starvation condition observed on OFFICEASSIST. A growing journal caused each tick to revisit and rewrite already closed transport history before evaluating new eligible records. The 50-second tick could therefore end before reaching an Invoice Entry approval message.

## Change

- Validate every journal entry and preserve every closed entry.
- Recover only journal entries whose phase is not `closed`.
- Index journal attempt IDs once per tick.
- Stop candidate traversal after the one permitted successful claim.
- Report the number of retained closed entries skipped by routine recovery.
- Preserve release `0.4.2` ownership, journal, state, task, schedule, destination pins, hidden launcher, immutable-hash checks, destination locking, and exactly-once submission controls.

## Regression Requirement

The isolated suite must retain 750 closed journal entries, claim and submit one eligible synthetic record within 25 seconds, keep all closed entries unchanged, and perform no production action or real task notification. The complete worker and serialized recovery suites must pass before publication.

## Verification

Verified on 2026-09-16:

- Worker regression suite: `65` passed, `0` failed.
- Serialized crash, concurrency, outage, and exactly-once suite: `35` passed, `0` failed.
- Integrity and administrative-closure suite: `47` passed, `0` failed.
- The 750-entry closed-history fixture retained every closed entry and reached the one eligible claim within the required 25-second bound.
- Production actions and real task submissions during testing: `0`.

## Deployment

Use `Install-LowTokenWorker.ps1 -Action UpgradeLive` under the existing machine identity. The upgrade must preserve the owner generation, production state directory, journal, scheduled-task identity and 60-second schedule, and exact destination pins. Verify two natural ticks and the pending authoritative lifecycle before upgrading another machine.
