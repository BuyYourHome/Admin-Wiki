# 24/7 Deterministic Worker Release 0.4.7

Date: 2026-09-30

## Purpose

Release `0.4.7` implements Wes's acceptance-based notification rule. A verified canonical recipient acceptance releases the destination's notification hold without representing or waiting for business completion.

## Behavior

- Verify the immutable hash, message ID, dispatch ID, destination task, destination machine, receipt timestamp, and authoritative acceptance evidence.
- Reconcile the delivery attempt as `Delivered` and retain its closed journal entry, submission evidence, receipt, events, attempts, results, and central record.
- Leave `Accepted` and `Processing` records nonterminal so the receiving Project Room continues tracking unfinished work.
- Keep missing, invalid, mismatched, ambiguous, or conflicting evidence held. Never resubmit an already submitted or uncertain request.
- Re-evaluate the exact same destination predicate from a fresh inventory under the canonical queue lock before the atomic claim.
- Preserve Invoice Entry's oldest-first nonterminal processing and immediate pre-output queue-drain gate.

## Upgrade

Use `Install-LowTokenWorker.ps1 -Action UpgradeLive` on an existing Live worker. The guarded upgrade preserves owner generation, production state, journal, task identity, hidden launcher, one-minute schedule, Live mode, destination pins, attempts, receipts, results, and central records. It also refreshes the reviewed normal-user Codex CLI path and SHA-256.

Do not create a validation record, force a tick, reset attempts, manually notify a destination, or retry an ambiguous submission for this in-place upgrade.
