# 24/7 Deterministic Worker Release 0.4.4

Date: 2026-09-16

## Purpose

Release `0.4.4` follows the OFFICEASSIST `0.4.3` deployment. Natural ticks skipped closed journal history and no longer reported `TickBudgetExhausted`, but authoritative remote-SMB scans still took 64–78 seconds. A completed Tim approval record also failed immutable-hash validation and correctly held the Invoice Entry destination.

## Changes

- Increase the bounded production tick from 50 to 180 seconds for release `0.4.4` while retaining the one-minute non-overlapping task schedule.
- Preserve release `0.4.3` closed-history skipping, indexed attempt lookup, and one-claim-per-tick behavior.
- Add `AdministrativeQuarantineIntegrityFailure` for a structurally terminal, hash-invalid record.
- Require exact live transport ownership, machine identity, task identity, stored hash, current record version, Wes authorization reference, and terminal receipt/result identity before quarantine.
- Preserve the record's stored hash, immutable fields, receipt, result, and events. Append both recomputed hashes and an administrative event.
- Release only the destination transport hold. Do not claim delivery or business completion through the quarantine action.

## OFFICEASSIST Recovery Target

The exact held record is `prmsg-email-monitor-route-vendor-invoice-20260916-wes-tim-closed-weekly-approval-001`. Its stored hash is `a57fed491a27af96b0dcb30d4aefa6ed15f8652da99fcf3bf10c30b51a5c2878`; the observed default and HTML-compatible recomputations are `b8dc5eb7145002746df56f46835047f9e39973369d16ca2b7fb5b14c698871a5` and `1906a72f657a9a1209134f6715dbab15e5d7720f9d6aac2599d67693ab63cd6d`. Quarantine must be applied from OFFICEASSIST under dispatcher task `01a09d84-a309-7591-a790-e770fcb53dee` only after the current record version is fetched immediately before the action.

## Verification

- Worker regression suite: `65` passed, `0` failed.
- Integrity and administrative-closure suite: `49` passed, `0` failed.
- New quarantine tests prove the invalid immutable record is preserved, the transport hold is released, and valid records or wrong actors are rejected.
- Canonical writes and real task submissions during testing: `0`.
