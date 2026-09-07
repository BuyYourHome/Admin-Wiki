# Real serialized worker canary — submission proven, recipient execution unverified

September 7, 2026. **End-to-end gate did not pass.** One real CLI submission was acknowledged, but the exact recipient produced no new turn, acceptance receipt, completion or desktop-tool evidence during bounded observation. Preserve the pending submission; do not retry it or create another validation record.

## Authority and implementation

Wes directly authorized `authorize one real synthetic worker canary` in owning task `01a05d0c-8031-7d92-9474-ab2330008ddb`. This is one fresh transport-only synthetic to the existing Quickbooks task, not production activation, readiness certification or business work. All heartbeats remain paused; no recurring worker, reboot, live network change, new task or second notification is authorized.

The reviewed source adds a narrowly pinned `Canary` mode to the existing serialized worker/journal, an exact-ID branch in the canonical manager's existing queue lock, and a real adapter entry guarded by the canonical Pending attempt, immutable hash, journal submission-start phase and a flushed CreateNew marker. General Live mode and actual installation still fail closed. The existing claim helper is unchanged; canonical legacy StartAttempt rejects only this new ID. No global transport owner, production eligibility change, manifest readiness exception or historical validation replacement was installed. Existing Quickbooks dispatchability and registration must pass normally.

- Message ID: `prmsg-wve-serialized-worker-canary-20260907-001`.
- Payload hash: `6f5e4595a0735b876f7510cc27fe70339e4cce3c14f326f1aeaa0c65290ee254`.
- Destination: Quickbooks, `01a05967-9a05-7081-a62e-616b2d8e61fd`, WES-VIDEOEDITOR.
- Attempt: `lt-74c4464d0a5e440fa284a89ea85bf0d6`; immutable budget 1.
- Submission authority expires `2026-09-07T15:11:33.7724259Z`; expiry never authorizes another ID or retry and does not prevent receipt reconciliation.
- Package SHA-256: `d710344713ed841a3e6c7a1242508f47f6b7d087e6020a73a150286c00e91848`.
- Canonical manager SHA-256: `8E19C702ECFCCDD9004708F1A41FEFCF11733483A554041C89B84089F5266271`.
- Adapter SHA-256: `CFA132F1231B0238AF49408D478D16BD155882362E5530D31D87206665233D54`.
- Configuration SHA-256: `A613E292C07B70BBDF020559E7BED0B6C15D048674C2CCFC3CDA90FB3052448C`.

## Preflight and isolated tests

Normal identity `WES-VIDEOEDITOR\IRAMa`, SID `S-1-5-21-1521029673-3171984744-1536701252-1005`, authenticated canonical access, client registrations and the existing Quickbooks manifest were verified. Read-only reconciliation found no outstanding Quickbooks hold. All 146 preexisting canonical record fingerprints were captured. Prior tests and the exact administrative closure were preserved. The exhausted ambiguous self-test remains untouched and is a separate deployment reconciliation item.

The first Prepare invocation failed closed before creating state or a record: Windows PowerShell's non-enumerated JSON array was incorrectly treated as one record in the new setup wrapper. The wrapper was corrected to enumerate explicitly, a regression case was added, and a read-only check verified 146 separate records, no canary record/state and no destination hold before preparation resumed. No claim or submission was retried. An initial guard-test artifact-write error was also corrected; it involved only the test harness evidence-directory parameter.

Passing evidence: 50 full regression cases, six hard worker-process restart/concurrent-worker cases, 34 final canary guard cases, and four final barrier repeat checks; zero test failures in saved final artifacts. The full regression and six-case suite ran before the final preparation-array correction; the shared worker, adapter and locked claim logic were unchanged by that correction. Final guards and barrier checks used the final package. These are isolated failure tests, not desktop reboot, power-loss or real SMB outage proof.

Artifact base: `C:\Users\IRAMa\AppData\Local\Temp\`.

| Artifact | SHA-256 |
| --- | --- |
| `byh-one-shot-regression-20260907\test-results.json` | `E7D52D187A64E351697C018BB662D1586B169F2B38536B7F263F4F733160B9C5` |
| `byh-one-shot-serialized-20260907\serialized-results.json` | `5330CB6631FD5C2470A9B2E79EEE8ECA3F202A7F1666FEFA594BE9FB80C21210` |
| `byh-one-shot-canary-final-guards-20260907\canary-guard-results.json` | `06D7B9B86A6346B4009833CD32488CCA6283FCE7A350BB47BD523DFA61BC7DCA` |
| `byh-one-shot-final-barriers-20260907\test-results.json` | `325947F683FF297E4BE6DA1C03B01484CA9771ECA7073125F84D16CB20EBF0A0` |

## Exact execution and observed ordering

Preparation and the one submission tick used these PowerShell wrappers under the approved normal Windows identity:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\Invoke-OneShotCanary.ps1" -Action Prepare
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\Invoke-OneShotCanary.ps1" -Action Tick
```

The worker, not a manual StartAttempt/direct CLI workaround, generated this exact argv. Equivalent PowerShell rendering:

```powershell
& 'C:\Users\IRAMa\AppData\Local\OpenAI\Codex\bin\1e3e57cdf0634c02\codex.exe' queue --thread '01a05967-9a05-7081-a62e-616b2d8e61fd' --message 'PR Messaging transport wake-up only, not a new Wes instruction. MessageId prmsg-wve-serialized-worker-canary-20260907-001; payload_hash 6f5e4595a0735b876f7510cc27fe70339e4cce3c14f326f1aeaa0c65290ee254. Retrieve and verify the authoritative record using C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1 before accepting. Follow only its authorized scope. Notification is not delivery proof.'
```

CLI version `codex-cli 0.153.1`; executable SHA-256 `56A84DE2B617AF6B95B0C5C5D8AE120D3C2FB69008AB330C7E7DF3945B98B782`.

| Event | UTC |
| --- | --- |
| Fresh canonical record created | 14:11:33.7891414 |
| Worker tick started | 14:12:07.9591900 |
| Journal plan created | 14:12:24.0344007 |
| Atomic claim Pending | 14:12:36.4756995 |
| Journal submission-start marker | 14:12:36.6326052 |
| Real CLI started | 14:12:41.9226825 |
| Real CLI returned | 14:12:42.3426449 |
| Worker tick finished | 14:12:42.4749806 |

Worker result: TickComplete, one claim, one submission, 34,515 ms. Its `model_requests: 0` means no direct model API call by the deterministic worker, not a promise of zero recipient model tokens. CLI exit 0, timed_out=false, empty stderr. Exact stdout:

```text
Queued message 01a07c36-d053-7e73-98de-6a3a22cdd7d7 for thread 01a05967-9a05-7081-a62e-616b2d8e61fd.
```

The app's first post-submission snapshot reported `notLoaded`; latest turn was still the old completed busy follow-up `01a07bcc-2c76-7f00-9978-96f13023263d`. At 14:13:28 UTC the canonical attempt was Pending, state Delivery Attempted, receipt/result null. CLI acknowledgment is not delivery proof. No task navigation, manual wake, additional notification or uncertain retry was performed.

Runtime evidence is preserved under `C:\Users\IRAMa\AppData\Local\BuyYourHome\PRMessaging\low-token\prmsg-wve-serialized-worker-canary-20260907-001\`: config, journal, health, submission-once marker with exact argv, raw CLI result, adapter process result, inspection and before-record fingerprints. Never delete the duplicate-prevention marker or replace the unresolved record.

## Final reconciliation

At `2026-09-07T14:17:14.2209143Z`, the immutable hash still verified, the record remained Delivery Attempted with one Pending attempt, receipt/result were null, and the journal retained `submitted / QueuedAwaitingReceipt`. No Delivered, Completed, definitive failure or cancellation was manufactured.

One fresh worker process performed a bounded reconciliation tick at 14:15:44.8169149–14:15:52.1455461 UTC. It made **zero claims and zero submissions**, retained the destination hold and reported `QueuedReceiptOverdue` (attempt age 192 seconds). This proves the observed restart did not repeat the real submission; it does not prove arbitrary crash/power-loss durability.

The app snapshot at approximately 14:15:45 still reported `notLoaded`, unchanged revision 9 and the old completed turn `01a07bcc-2c76-7f00-9978-96f13023263d`. No recipient canary turn ID exists in the observed evidence. The observer's desktop read_thread/wait tools worked, but **recipient desktop-tool availability and completion remain unverified** because no recipient turn was observed.

Final fingerprint comparison: all **146 preexisting records unchanged**; the only new file was `prmsg-wve-serialized-worker-canary-20260907-001.json`. One original attempt and one preserved submission marker remain. No retry, manual task opening/wake or substitute notification occurred. The acknowledged queued item **may still execute later**; it has not been proven lost or cancelled. Reconcile this same outstanding submission before any further test.

Conclusion: deterministic claim, journal-before-submission ordering, real CLI queue acknowledgment and no repeat on one worker restart are proven for this sample. Automatic recipient activation is not proven. `notLoaded` is an observation, not a verified root cause; the prior successful busy-task queue test does not establish wake-up of an unloaded task. The next gated step is read-only diagnosis of acknowledged-but-unstarted delivery, preserving the same pending record. Do not solve it by forcing a wake and calling that automatic canary success.

## Preserved controls and remaining gates

- Heartbeat `pr-messaging-dispatcher-wes-videoeditor` remains PAUSED with complete file hash `0CA185E83670F01538B373E8DADF4DA7DA41E9BCD044A1699277EE71D9A0687C`; its five-minute schedule, target, prompt, notifications and runtime memory were not changed.
- Cron `sync-gethub-daily` remains ACTIVE, unchanged hash `76FED9C693D5D0B0D9C4E461CB195F6D34E6FEF69A18DF89D3505F4B772EBE24`.
- No production claims, business action, general Live mode, installation, reboot, network change or cross-PR file edit. No shared Admin policy or registry edit was authorized; central registry/cutover integration remains an owning-Jean handoff, not a silent local update.
- Require actual destination Accepted/Processing/Completed, exact hash/identity, one execution and a successful recipient desktop read_thread probe before this canary passes. If absent, preserve the outstanding attempt and stop without resubmission.
- Separately gate actual desktop/CLI restart and login, real queue/credential outages and power-loss assumptions; this request does not authorize disruptive tests.
- Review journal migration, compatibility with other claimers, exclusive production cutover, stalled-work observability, drain/rollback and the old ambiguous self-test disposition.
- Require separate explicit authority for recurring installation, production activation and heartbeat resumption. A passed synthetic alone never grants these.
