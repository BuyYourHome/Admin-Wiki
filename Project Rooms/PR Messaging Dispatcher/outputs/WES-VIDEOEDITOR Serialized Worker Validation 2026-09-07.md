# WES-VIDEOEDITOR serialized worker validation

## Authority and scope

Wes directly authorized implementation in owning task `01a05d0c-8031-7d92-9474-ab2330008ddb` on September 7, 2026. Scope: implement destination serialization without the unavailable desktop busy/pending-status connection and test worker restart recovery, concurrent submissions, outages and duplicate prevention. Development began at `2026-09-07T12:25:57Z` on clean, fetched `main`, base commit `65d53443bdcdf0a696319b3a31773394a54a6a9d`.

All heartbeats remain paused. Production mode, real CLI submission and installation remain hard-disabled. No task notification, new central message, production claim, business action, actual machine reboot, desktop restart, live-network/SMB interruption, credential change or approval bypass is part of this implementation run.

## Prior real behavior evidence

The separately authorized bounded test earlier today used one `codex queue` submission to Quickbooks task `01a05967-9a05-7081-a62e-616b2d8e61fd` during a controlled synthetic turn. Fresh anchor `prmsg-wve-busy-anchor-20260907-1207-7e31` and follow-up `prmsg-wve-busy-followup-20260907-1207-7e31` each completed one canonical lifecycle. The CLI returned exit 0 at `12:11:50.0292615Z`; the anchor turn completed normally at `12:16:13Z`; distinct follow-up turn `01a07bcc-2c76-7f00-9978-96f13023263d` then ran and completed. No same-turn steering or interruption was observed. Follow-up acceptance occurred at `12:17:36.5296231Z`, approximately 347 seconds after submission. Desktop read-only task tools worked in the receiving turn.

These completed records are evidence references only and must never be replayed. They do not establish real CLI crash durability, power-loss behavior or universal exactly-once execution.

## Development release 0.2.0

- One durable outstanding slot per destination, maintained through acceptance until verified Completed. Accepted/Processing is not slot release. Ambiguous, invalid, Blocked, Needs Wes and rejected results remain held for review.
- Same-destination exclusion is checked both in the local journal and under the staged manager's central queue lock. Independent worker state directories cannot bypass the locked claim gate.
- No dependency on a desktop busy/pending connection or fixture busy inventory.
- Queue acknowledgments require an exact message/task/attempt match, queue UUID and successful process result. They do not count as acceptance.
- Queued receipt age generates attention, not an automatic retry, failure or slot release. Default recommended warning threshold is 600 seconds; each worker tick remains bounded to at most 55 seconds.
- Journal schema 2 adds destination identity, queue acknowledgment evidence, awaiting-completion and unresolved phases. Submission-start evidence is flushed before invoking the adapter. Recovery never repeats an existing uncertain attempt.
- Lost journals conservatively reconstruct owned attempts, including ambiguous and accepted attempts. Missing/stale central state, corruption, ownership drift and old journal schemas fail closed; evidence is preserved.
- The canonical live manager/helper and production policy are not modified. The staged manager imports the revised development-only checks. No automatic migration of existing journals or configuration occurs.

## Validation evidence

Initial regression run: 50 passed, 0 failed, completed `2026-09-07T12:40:56.6389366Z`.

Initial regression artifact: `C:\Users\IRAMa\AppData\Local\Temp\byh-serialized-regression-20260907\test-results.json`.

Expanded process-recovery suite: 33 passed, 0 failed, completed `2026-09-07T12:49:56.6787166Z`; complete summary and fixture paths are retained in this task's tool output. The harness's evidence-directory forwarding was corrected for subsequent runs.

After that full run, review tightened claim-denial recovery, attempt ownership/generation checking and refusal to retry uncertain historical attempts even with unused budget. The fake adapter now writes one flushed CreateNew evidence file per invocation, so concurrent writes cannot hide duplicates. Final focused checks use this final package and stronger invocation counter; the full suites were not repeated wholesale after those small hardening changes.

Final package SHA-256: `35036894f80a4544b0df891b4901d719664ae23b7c4746957827131d339745cd` (local PowerShell source package).

| Final focused group | Result | Completed UTC | Evidence under `C:\Users\IRAMa\AppData\Local\Temp\` |
| --- | --- | --- | --- |
| Hard termination/restart | 4 passed, 0 failed | 12:53:30.4009861 | `byh-serialized-final-crash-20260907\serialized-results.json` |
| Concurrent workers | 2 passed, 0 failed | 12:52:32.4880201 | `byh-serialized-final-concurrency-20260907\serialized-results.json` |
| Live/CLI/install/identity/no-busy-probe guards | 5 passed, 0 failed | 12:52:35.4610165 | `byh-serialized-final-guards-20260907\test-results.json` |
| Receipt/journal/duplicate recovery | 9 passed, 0 failed | 12:55:03.5559852 | `byh-serialized-final-recovery-20260907\serialized-results.json` |

PowerShell parsing completed with zero errors. No real CLI submissions or production actions occurred in any suite.

Outcome: 50 initial regression checks, 33 initial expanded checks, and 20 final focused checks passed with no failures (103 successful case executions, 85 distinct cases). The final focused run verifies the review-hardening changes, not a second full-suite run. The authorized isolated development gate is complete; production and operational restart/outage gates remain closed.

Final hard-kill evidence (each terminated process returned exit -1; each subsequent worker was a fresh process):

| Termination point | Validated child PID | Adapter invocations after recovery | Canonical fixture state |
| --- | --- | --- | --- |
| After durable plan, before claim | 18896 | 1 legitimate fresh attempt | Delivery Attempted; queued acknowledgment retained |
| After claim, before submission-start marker | 29836 | 0 | Queued with consumed one-attempt budget; proven NotDelivered |
| After submission-start marker, before adapter | 9140 | 0 | Delivery Ambiguous; destination held |
| After adapter, before durable acknowledgment | 29772 | 1 | Delivery Ambiguous; no repeat; destination held |

Final concurrency used PID pairs `12868/16368` (shared journal) and `31440/37592` (separate journals). Each pair produced exactly one independent invocation file and one central attempt. The shared-journal loser reported WorkerAlreadyRunning; both separate-journal workers completed their ticks. Subsequent recovery ticks completed cleanly without resubmission.

Reproduction: run `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\tests\Test-LowTokenWorker.ps1" -EvidenceDirectory "<new profile-temp evidence directory>"`, then the same wrapper for `Test-SerializedWorker.ps1`. Optional `-NameRegex` selects focused independent cases; final groups used `hard process`, `concurrent workers`, `delayed queued|acceptance retains|uncertain target|journaled claim denial|lost journal|repeated completion|restored stale|missing canonical`, and regression guards `CLI adapter|installer|live fails|ownership generation|busy inventory`. Repeated runs create new isolated fixtures, never reuse real validation records.

The fixtures use unique marked directories under the normal user's temporary directory. Hard-termination tests validate the exact PID and rendezvous marker before killing only the child test worker. Concurrency tests start real PowerShell worker processes, but their adapters and destination receipts are synthetic. Outages are confined to fixture queue availability/locks and injected adapter errors/timeouts. No business service is stopped.

## Preserved boundaries and remaining gates

- Heartbeat `pr-messaging-dispatcher-wes-videoeditor`: PAUSED; settings file SHA-256 `0CA185E83670F01538B373E8DADF4DA7DA41E9BCD044A1699277EE71D9A0687C`.
- Cron `sync-gethub-daily`: ACTIVE and unchanged; SHA-256 `76FED9C693D5D0B0D9C4E461CB195F6D34E6FEF69A18DF89D3505F4B772EBE24`.
- Active manager SHA-256: `7742BD122E23DC2F2189FC847126800E8CE52047F6EB77539CCBA92604809314`.
- Active claim helper SHA-256: `79B4DC9D7CB936A31ABF80E97FBC95691F03B7A9AEA5B49761DCA8946FFB8130`.
- Production configuration SHA-256: `C6206A3637A89002EDC179984BEA8D0FD1A47517267FE530F981E1D8D6B518AD`.

Passing isolated tests can support a separately reviewed fresh synthetic worker-to-real-CLI canary. It cannot establish actual Codex restart/login, machine reboot, SMB authentication interruption or power-loss durability. Those require explicitly bounded operational validation. Exclusive transport ownership, safe journal migration, real recipient/tool verification, rollout/rollback review and Wes's explicit production/heartbeat-resume authorization remain gates. Nothing in this report authorizes automatic activation.

Tradeoff: conservative no-retry handling can leave a possibly unsubmitted message held for human reconciliation. This intentionally favors duplicate prevention over automatic recovery of uncertain delivery.
