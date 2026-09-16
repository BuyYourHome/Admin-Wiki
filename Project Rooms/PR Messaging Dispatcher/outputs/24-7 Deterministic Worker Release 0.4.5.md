# 24/7 Deterministic Worker Release 0.4.5

Date: 2026-09-16

## Purpose

Release `0.4.5` corrects the manager subprocess timeout exposed after OFFICEASSIST successfully applied the `0.4.4` integrity quarantine.

## Verified Failure

The production worker retained a 180-second overall tick, but its canonical manager wrapper still limited non-list actions to 15 seconds. OFFICEASSIST required longer than that to complete an atomic conditional claim against the remote SMB queue, producing `ManagerTimeoutUncertain` while the eligible Invoice Entry record remained queued with zero attempts.

## Change

- Manager list calls are bounded at 60 seconds.
- Other manager calls, including atomic conditional claim, are bounded at 120 seconds.
- Each call remains capped by the time left in the existing 180-second tick.
- Owner generation, journal, state directory, task identity, hidden launcher, schedule, destination pins, immutable records, and exactly-once behavior are unchanged.

## Deployment

Use `UpgradeLive` on an existing live worker. After upgrade, observe natural scheduled ticks and verify that the queued Invoice Entry record receives at most one attempt and proceeds only through authoritative destination receipts.
