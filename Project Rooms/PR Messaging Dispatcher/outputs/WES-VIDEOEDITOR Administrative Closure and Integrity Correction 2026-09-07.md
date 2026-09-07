# Administrative closure and integrity correction

## Authorization and boundaries

Wes explicitly approved adding a narrowly scoped administrative closure for the one remaining invalid/superseded record, with no delivery or business-completion claim, then continuing worker corrections in owning task `01a05d0c-8031-7d92-9474-ab2330008ddb`. This does not authorize a real canary submission, recurring worker, production dispatch, heartbeat resume, reboot, live network changes or another record closure.

## Diagnosis

The nine-record read-only review found seven verified non-Completed final results, one verified Completed result rejected only by its hash encoding, and one invalid/superseded record without a recipient receipt/result. All three apparent hash discrepancies exactly reproduce PowerShell's default-versus-HTML JSON escaping difference. Of 29 local records, 28 match default escaping, 26 match HTML escaping, and all match at least one. Simply switching every hash to PowerShell 7 default would break a different historical record.

The correction compares only those two byte encodings of the same ordered immutable JSON. It preserves numeric spelling, dates, property order and escaped-backslash text; it does not alter hashes or payloads. The original record-creation hash implementation remains unchanged.

The prior hold predicate recognized only Completed. The corrected predicate recognizes all four final states in the canonical messaging rule, but only with a matching receipt identity, matching result state/machine, final timestamp after acceptance and valid immutable hash. This closes a transport slot, not the underlying business issue. Accepted/Processing, ambiguous submissions, malformed receipts/results and unknown closures remain held. No retry budget is replenished.

## Exact administrative closure

- Message: `prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-001`.
- Hash: `c796ce3a15c09244bc8de8af3ea7c893928862e462bb13cc8421012b7c79f91c`.
- Disposition: `administrative_closure.disposition = SupersededUndelivered`.
- Closure UTC: `2026-09-07T13:31:11.0718072Z`; verified `13:31:12.6268013Z`.
- Canonical state remains Blocked. The original single Failed attempt is unchanged. Receipt and result remain null. No Accepted or Completed event was fabricated.
- Exact successor `prmsg-invoice-entry-poyner-spruill-qb-existence-audit-20260831-002`, hash `7b40a78b7e551453e98310a56287550848a3cd3c31ca0767be6acb9e8a56fb57`, was verified Completed before closure.
- All-record file fingerprint comparison showed exactly one changed record: the named superseded record. Zero production claims, notifications or business actions.

Execution: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\Close-WveSupersededRecord.ps1" -Apply`. Exit 0, verification true. The wrapper uses the canonical manager's queue lock and optimistic record-version check. The additive manager action is fixed to this exact identity/hash/failed attempt, approved actor and exact completed successor. It is idempotent; conflicting closures, wrong actor, wrong version, modified immutable content or absent successor proof fail closed.

Backup and machine-readable evidence are outside Git at `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\recovery\administrative-closure-20260907T133108Z-65872a882bad4a49b4f65f8d6a4e881a\`. Backup SHA-256 `8B2A4549A83AF2C924BC5B22A132B3EB7711847CE1F4A367FEA37757D28B3719`; after-record SHA-256 `3BD16CEA33BEE1D156178551420D8AA16A2BB80ACD04E12037E2FD3AF3272FD4`. Restore is not automatic and must preserve later evidence.

## Verification and remaining gates

Initial integrity/closure suite: 25 passed, zero failures, completed `2026-09-07T13:28:41.0087240Z`. Tests include literal-backslash escape round trips, changed-content rejection, four terminal states through atomic claim and journal recovery, invalid-terminal holds, exact administrative closure preservation/idempotency and six rejection cases. All closure test writes were confined to fresh marked temporary fixture queues; canonical reads supplied the two legacy snapshots.

Full regression/recovery and final bounded shadow results are recorded below. No passing isolated result by itself authorizes activation.

- Full 50-test regression suite passed with zero failures at `2026-09-07T13:33:50.9814059Z`; artifact `C:\Users\IRAMa\AppData\Local\Temp\byh-integrity-regression-20260907\test-results.json`.
- Read-only predicate reconciliation at `13:31:50.4355870Z`: no Quickbooks destination holds remain under the corrected code. No business state was changed to achieve this. The exhausted old self-test still has no receipt/result and remains Delivery Ambiguous.
- Initial one-tick bounded shadow completed at `13:34:20.7089313Z`; actual tick 5,294 ms, zero claims/submissions/model requests. All 146 canonical record fingerprints were unchanged (digest `2640f50c39d44b752154a2c5cadc3d86467722384f748ea3ef0f8293f2f20e91` before/after), as were automation and active-manager files during the observation. Candidate diagnostics: two SelfNotificationForbidden, one ManifestMissingOrDuplicate. Artifact: `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token\shadow-20260907T133405Z\shadow-results.json`.
- Full 35-case serialized recovery/concurrency/outage/duplicate suite passed with zero failures at `13:40:50.9422705Z`; artifact `C:\Users\IRAMa\AppData\Local\Temp\byh-integrity-serialized-20260907\serialized-results.json`. Hard kills were only fixture child workers; outages affected temporary queues/fake adapters, not computers or live network access.
- After making the test harness repeatable against the now-closed canonical snapshot, 12 focused integrity/closure checks passed at `13:40:18.4205634Z`. It reconstructs a pre-closure copy only inside a fresh test fixture; it never removes the real disposition.
- Final packaging review added the integrity dependency's hash and version-local layout to the plan-only installer. Four package/live/CLI/install guards passed at `13:41:42.2755086Z`. No worker execution logic changed after the full suites. Totals: 110 main cases plus 16 focused repeat executions, all successful, zero failures.
- Final package SHA-256: `7071a952a4eb3a375942f9cf072576d8a477bd3cce6e09a1538cbf76265f0a53`. Package identity retains development schema/release 0.2.0 with this new pinned content hash; existing configurations are not silently migrated. Required integrity-module hash: `68C458189E4B7728C21B8C24BFCA0A69E95075282AF2109744357C2770847A9B`. Active manager hash after the approved additive change: `3E6427FF063E480E5349CFA01632DEAC6AC209D0EC9F191276BDDD4849E2B80E`.
- Final shadow on that package completed at `13:42:01.0487465Z`, tick 5,263 ms. Again zero claims/submissions/model requests and unchanged fingerprints for all 146 records, automation and manager during observation. Artifact `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token\shadow-20260907T134146Z\shadow-results.json`.
- Heartbeat SHA-256 remains `0CA185E83670F01538B373E8DADF4DA7DA41E9BCD044A1699277EE71D9A0687C`, PAUSED. Cron `sync-gethub-daily` remains ACTIVE and unchanged. Claim-helper and production-config hashes remain `79B4DC9D7CB936A31ABF80E97FBC95691F03B7A9AEA5B49761DCA8946FFB8130` and `C6206A3637A89002EDC179984BEA8D0FD1A47517267FE530F981E1D8D6B518AD` respectively. PowerShell syntax checks report zero errors.

The old exhausted dispatcher self-notification is not this record and remains untouched; it must never be retried or represented as delivered. Real one-shot worker/CLI adapter authorization, exact fresh validation manifest and exclusive ownership, actual recipient/tool canary evidence, later operational recovery validation and explicit deployment/resume decisions remain separate gates. The working transport is preserved but paused; the real worker adapter and production/installation guards remain disabled.
