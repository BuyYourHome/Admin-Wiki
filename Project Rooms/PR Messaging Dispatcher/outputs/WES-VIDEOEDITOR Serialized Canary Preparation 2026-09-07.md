# Serialized worker canary preparation — stopped at reconciliation

Subsequent update: Wes approved the exact administrative closure and worker corrections. See [[WES-VIDEOEDITOR Administrative Closure and Integrity Correction 2026-09-07]] for the resolved serialization diagnosis, verified closure and current evidence. The original findings below are preserved as the review-time snapshot, not current unresolved-hash claims.

## Decision and authority

Wes requested review of the finished tests and preparation of one fresh end-to-end synthetic worker canary, with outstanding submissions reconciled first. This is preparation only, not launch authorization. Owning task: `01a05d0c-8031-7d92-9474-ab2330008ddb` on WES-VIDEOEDITOR.

The isolated development tests passed. The real canary is **not ready to launch**: current destination serialization holds historical records, three legacy snapshots fail the worker's hash predicate, and the old self-notification remains ambiguous. No record was created, claimed, notified, retried, edited or marked delivered during this review. No worker code, manifest, registration, runtime memory, automation or production policy was changed.

## Reviewed evidence

- Implementation commit `590701c5`, release 0.2.0, package hash `35036894f80a4544b0df891b4901d719664ae23b7c4746957827131d339745cd`, rechecked under Windows PowerShell on September 7.
- [[WES-VIDEOEDITOR Serialized Worker Validation 2026-09-07]] reports 50 initial regression + 33 expanded + 20 final focused successful executions, zero failures, 85 distinct cases. The expanded 33-case result is retained in the prior task tool output, not a saved JSON artifact. The full suites were not rerun wholesale after final hardening.
- This review re-read the five saved JSON artifacts: 50 regression, 4 hard restart, 2 concurrent workers, 5 guards, 9 recovery checks; each reports zero failures. All were finished before this request's review. No tests were rerun or forced.
- Final restart evidence covers four deliberately killed child worker processes. Final concurrent evidence covers shared and separate journals, each with one fixture adapter invocation and one attempt. Outages were fixture-only, not live SMB, desktop restart, reboot or power-loss tests.

Artifact root: `C:\Users\IRAMa\AppData\Local\Temp\`.

| Artifact | SHA-256 |
| --- | --- |
| `byh-serialized-regression-20260907\test-results.json` | `210E58D984E65923B5EBD5020FE42677630B04E1880122662513E511E10F8814` |
| `byh-serialized-final-crash-20260907\serialized-results.json` | `07726F3B113658C3C6DC94FDC32C7C151272F959B862EE658AAF463675F176C3` |
| `byh-serialized-final-concurrency-20260907\serialized-results.json` | `B899C8C95E08719162835FD782E603AAAB8134106A1D1663BA58541994F6FFE2` |
| `byh-serialized-final-guards-20260907\test-results.json` | `C66876F65ECCD37F933F7FE971BA5E8156DEC99EE7BDD54D224D354145FF7B46` |
| `byh-serialized-final-recovery-20260907\serialized-results.json` | `C2BE4AAF4045F1F262255F7F21BD7C852D92D3544097D291DE7BFE2F3E82B354` |

## Canonical reconciliation, read-only

The documented `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1" -Action List` wrapper succeeded under the approved normal Windows identity. Pure release functions evaluated its snapshots under Windows PowerShell; no manager mutation or worker claim was invoked. At `2026-09-07T13:03:31.9447257Z`, 29 local-destination records were inspected.

Both September 7 busy-test records have matching immutable hashes, exact recipient receipts, valid Completed results and one Delivered attempt each:

| Record | Accepted UTC | Completed UTC |
| --- | --- | --- |
| `prmsg-wve-busy-anchor-20260907-1207-7e31` | 12:09:52.4757901 | 12:15:57.8798688 |
| `prmsg-wve-busy-followup-20260907-1207-7e31` | 12:17:36.5296231 | 12:18:37.0019543 |

Quickbooks task `01a05967-9a05-7081-a62e-616b2d8e61fd` was idle; the two latest turns were completed with no error. Follow-up turn `01a07bcc-2c76-7f00-9978-96f13023263d` followed the normally completed anchor. The canonical follow-up result reports one execution and a successful read-only desktop task-tool probe. These are prior CLI behavior evidence, not a new worker canary. Never reuse them.

The September 5 distinct transport and CLI wake-up synthetics also have valid hashes and Completed receipts. Historic attempt labels can remain DeliveryAmbiguous even after a later receipt/final result; they must not be mistaken for permission to replay.

### Unresolved self-notification

`prmsg-create-pr-wve-dispatcher-recipient-validation-20260905-001` remains Delivery Ambiguous, attempts 1/1, no receipt or result. Hash `3920b0a0251234448410c1763bc8c33dab8370278e71ef29629b79974d4a89fe` verifies. Attempt `dispatcher-wes-videoeditor-prmsg-create-pr-wve-dispatcher-recipient-validation-20260905-001-1` began `2026-09-05T18:52:34.9950721Z`, was marked DeliveryAmbiguous at `18:55:44.3107967Z`, and records that the wake-up appeared in the active dispatcher turn rather than an evidenced separate recipient turn. No honest Delivered or Completed disposition is available. No retry budget remains. This is a different destination from Quickbooks; it is not itself a Quickbooks slot, but remains an unresolved migration/reconciliation item. Do not self-notify or manufacture a receipt to clear it.

### Quickbooks destination is held by current code

`Test-LtDestinationOutstanding` returns true for these nine historical records. This is the implemented conservative predicate, not proof that nine tasks are running:

| Message ID | Central state | Hold evidence |
| --- | --- | --- |
| `prmsg-create-pr-quickbooks-wve-machine-readiness-20260831-001` | Blocked | Recipient receipt/final Blocked, despite earlier NotDelivered attempt |
| `prmsg-jean-quickbooks-wve-browser-readiness-retry-20260831-001` | Blocked | Hash discrepancy and non-Completed final |
| `prmsg-jean-josh-qb-readonly-mapping-discovery-20260831-001` | Needs Wes | Delivered receipt, non-Completed final |
| `prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-001` | Blocked | Hash discrepancy, Failed attempt, no receipt/result |
| `prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-002` | Completed | Hash discrepancy despite matching receipt/completion identity |
| `prmsg-invoice-entry-quickbooks-poyner-1277608-20260901-001` | Needs Wes | Delivered receipt, non-Completed final |
| `prmsg-quickbooks-renamed-identity-validation-20260902-001` | Blocked | Recipient receipt/final Blocked |
| `prmsg-jean-quickbooks-poyner-1277608-resume-20260902-001` | Rejected as Wrong Room | Late recipient receipt, non-Completed final |
| `prmsg-invoice-entry-quickbooks-poyner-1277608-resume-corrected-20260902-001` | Needs Wes | Late recipient receipt, non-Completed final |

Zero-attempt Queued records are unsubmitted backlog, not pending CLI submissions; they remain untouched and excluded from any synthetic canary. There is no authority here to process business work to clear these holds, override hash validation, or declare historical terminal work Completed.

Three hash discrepancies reproduced using release 0.2.0 against canonical manager output:

| ID suffix (full IDs above) | Stored hash | Worker-computed hash |
| --- | --- | --- |
| `browser-readiness-retry-20260831-001` | `9fc66b70607f827990fa9bbb281ba84844df6354d0cdda9dc9a644a82eabb618` | `287725fcf03f2df108b0e0ec4607e06a0b315d02bb049030d13a1ecad382c0f2` |
| `qb-existence-audit-20260831-001` | `c796ce3a15c09244bc8de8af3ea7c893928862e462bb13cc8421012b7c79f91c` | `3f4fed48e3fd080c39d69bb4ca4a19491b02082bf0cacd0e0a2e43204e70c4e9` |
| `qb-existence-audit-20260831-002` | `7b40a78b7e551453e98310a56287550848a3cd3c31ca0767be6acb9e8a56fb57` | `ed41323ee8c0f92a563c7db395ffb224b4a89f7f841824e915d0128905acb699` |

Cause is unresolved: this review does not assert tampering or distinguish original serialization/round-trip compatibility from subsequent immutable-content changes. Preserve originals and investigate read-only before any compatibility exception. Local normal-profile inventory contains only prior shadow configs/health/locks and the old read-only canary probe, no submission journal in the worker's prescribed state tree. Absence of that journal is not evidence that historic app submissions never occurred.

## Prepared next gate — not executable yet

1. Obtain scoped authority for read-only diagnosis and a reviewed treatment of historical terminal holds/hash compatibility. Preserve business states and ambiguity; do not simply ignore all preexisting work, change hashes, or widen eligibility. Any implementation change needs new isolated regression evidence, including legacy snapshots, before this gate reopens.
2. Obtain explicit approval to implement and run one real, one-shot synthetic canary after reconciliation passes. Release 0.2.0 currently rejects real adapter execution (`RealSubmissionDisabledInDevelopmentRelease`, `RealAdapterDisabledInDevelopmentRelease`), central mutations through its relay, and installation. Do not bypass these guards with manual StartAttempt plus direct CLI and call that worker evidence.
3. Review a narrowly scoped canary release with atomic claim/reconciliation and exclusive ownership of exactly one fresh ID, destination, immutable hash, one-attempt budget, machine/SID and release/CLI hashes. No active manager replacement or broad live mode is authorized here. The existing manifest still names `prmsg-quickbooks-renamed-identity-validation-20260902-correction-001`; a fresh validation ID needs the owning workflow's explicit manifest authorization, not reuse of an old record or an unreviewed bypass.
4. Generate the new synthetic record and hash only after those gates pass. Require explicit no-business flags, no production, no heartbeat processing, one permitted submission, exact existing Quickbooks task, finite claim/submission authorization and no retry of uncertainty. Do not choose a past validation ID. No new ID is created or reserved by this preparation.
5. Recheck paused automation hashes, canonical outstanding records and recipient context immediately before execution. Keep legacy transport intact but paused; prevent competing claimers from taking the exact canary. If exclusivity is unproven, stop.
6. Run only the approved bounded worker tick and bounded reconciliation ticks, never a recurring worker or forced heartbeat. Capture start/end UTC, exact CLI argv/version/hash, process exit/stdout/stderr/queue UUID, journal phase ordering and canonical attempt identity. Queue acknowledgment is not delivery. Keep the slot held through Accepted/Processing until exact hash/identity/Completed verification.
7. Require the distinct recipient's own Accepted, Processing and one Completed result, actual turn ID, execution count and successful permitted read-only desktop task-tool probe. No browser, mailbox, QuickBooks, notifications or business action. Reconcile again and prove no resubmission. If uncertain, preserve evidence and stop with no retry.

## Remaining deployment gates

- Resolve the historic-record compatibility/hold policy and the exhausted self-test disposition through appropriate owner review; no fabricated business completion or receipt.
- Review/pin the real one-shot canary release and exact manifest/ownership authorization; rerun impacted isolated failure cases on that release.
- Pass the actual serialized worker-to-real-CLI-to-recipient canary with canonical lifecycle, no duplicate and desktop-tool evidence. This preparation does not pass it.
- Separately authorize and validate operational restart/login, real queue/credential outage recovery and power-loss assumptions as required by the design. Fixture kills/outages do not establish these. No reboot or live network change is authorized now.
- Review journal migration, exclusive transport cutover, compatibility with other claimers, drain/rollback, stalled-work observability and cross-PR policy integration. Preserve completed records and uncertain attempts.
- Obtain Wes's explicit recurring installation/production activation and heartbeat-resume decisions. Passing a synthetic alone never enables production or resumes paused schedules.

## Preserved configuration

The only local heartbeat found, `pr-messaging-dispatcher-wes-videoeditor`, is PAUSED; full settings SHA-256 remains `0CA185E83670F01538B373E8DADF4DA7DA41E9BCD044A1699277EE71D9A0687C`. Five-minute schedule, target, prompt and notification settings were not edited. Runtime memory was not written.

Cron `sync-gethub-daily` remains ACTIVE and unchanged, hash `76FED9C693D5D0B0D9C4E461CB195F6D34E6FEF69A18DF89D3505F4B772EBE24`.

Active manager, claim helper and production configuration hashes match the preceding validation report. Repository fetch succeeded; local main includes current origin/main and the prior scoped implementation commit. No pull, deployment, recurring installation, restart, reboot, live access change or push was performed.
