# OFFICEASSIST journal encoding repair evidence

Status: root cause reproduced read-only; owner implementation and guarded deployment pending.

Wes authorized reconciliation, guarded repair preserving uncertainty and history, two natural post-repair ticks, retained per-tick diagnostics, and visible pre-claim failures. Shared-code owner: PR Messaging Dispatcher on WES-VIDEOEDITOR, task `01a05d0c-8031-7d92-9474-ab2330008ddb`. OA supplies evidence and deploys only a verified repair. The completed October 23 Tim approval must not be retried or replaced.

## Exact evidence

- Normal identity: `OfficeAssist\OfficeAssistLogin`.
- Installed worker: 0.4.7, Live.
- Record: `prmsg-invoice-entry-email-delivery-tim-pond-approved-20261008-001`.
- Journal attempt: `lt-8be621d704e74884a01c8085669c7a87`, phase `planned`, created `2026-10-08T11:35:50.5183911Z`.
- Journal submission start/completion/evidence: null. No matching file in production/submissions. Central attempts: zero, empty history. Absence of local evidence is not a claim of business completion or permission to retry.
- Record and journal dispatch ID: null. Preserve this legacy condition; do not invent an ID.
- Destination: Email Monitor, `01a03956-fe55-7f62-9c0a-17c18f763320`, OFFICEASSIST.
- Stored payload hash in both: `efd36685cbd39ab27443570504b5805fc6dc0d7d8da1f35a9e0b122cea452455`.
- Central acceptance: `2026-10-08T11:35:07.4092669Z`; result: Needs Wes at `2026-10-08T11:35:42.3237526Z`. Both precede the planned journal entry. Recipient result reports no email submission; this investigation did not perform email work.
- Journal SHA-256: `AC4A07153EA1DB67A9422A763850CBCAC54D7CA70F454102400DF578FDDA86DE`.
- Installed config SHA-256: `AA55F7C8956DE6A89C1C17B2E67625CCC93C7927CB6F1DCA74E48AF8F5A833F2`.
- Central record file SHA-256: `95C007E04281FBDDA0FF589295D9AE31305830FD4B9CE431E534D7923BA0E598`.

## Reproduction and first failing check

The installed read-only manager relay and process helper were exercised under Windows PowerShell `5.1.26100.9711`, with Action List and DestinationMachine OFFICEASSIST. This was not a worker run or claim. Relay exit 0; 192 inventory records; target present. Message ID, dispatch ID, stored payload hash, destination task, and destination machine comparisons all passed. Computed integrity alone failed.

`tools/pr-messaging/Manage-ProjectRoomMessage.ps1`, function Read-Record, uses `Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json` without explicit encoding.

Same file, same Windows PowerShell process and verifier:

| Read | Integrity | HTML-compatible computed hash |
| --- | --- | --- |
| Default encoding | false | `a973f51f771fe310e9c26c71350c001699ce684db85ad4d6b6f0fd68ceec7184` |
| Explicit `-Encoding UTF8` | true | `efd36685cbd39ab27443570504b5805fc6dc0d7d8da1f35a9e0b122cea452455` |

The default computed hash was `d65a3f51ebf6651f770551107de2cdf83a7c419cccf5d02abedae79c71f8128b`; explicit UTF-8 default hash was `425c89815dc1d3939561914fdc265ca8f42f3d8bf477292dedf810acb90bc0e9`. No payload or hash was rewritten. This isolates text decoding rather than a destination mismatch or demonstrated immutable-file corruption.

## Owner repair and verification criteria

1. Make canonical record decoding explicitly compatible with the writer's UTF-8 contract; test Windows PowerShell 5.1 and current PowerShell with non-ASCII and timestamp fixtures. Altered content must still fail integrity verification.
2. Test planned-entry recovery with absent central attempt, pre-existing recipient activity, and null legacy dispatch ID. Preserve history. Marker, timeout, submission, identity, or conflicting evidence must remain fail-closed; never manufacture delivery.
3. Retain bounded per-tick diagnostic history outside Git: run ID, UTC start/end, phase, outcome/error, inventory count, candidate reasons, claim/submission counts, and safe evidence identifiers. Include pre-lock/pre-claim failures. Exclude payloads and secrets. Surface actionable failures through the existing authorized health/attention mechanism without creating a second dispatcher.
4. Verify guarded installer refresh of manager/package/CLI pins, preserving owner generation, journal, state, task, schedule, and destinations. The currently configured CLI executable is missing; refresh must use the installer-reviewed current CLI, not hand-edited hashes.
5. Observe two natural OA ticks reaching candidate evaluation; retain exact outcomes and any claims/submissions/receipts. Do not force runs or recreate work. Never claim recovery from scheduler result 0.

## Deployment and handoff blockers

The registered WVE owner task was not accessible through this session's thread read. Its local manifest is non-dispatchable; dispatcher maintenance must start in its existing WVE task, not through self-notification or a substitute destination. No owner notification was sent and no acceptance claimed.

OA checkout was main at `4f5b6fd827a9c561f2bbb8e0c15bd7057c28ac2e`, one commit ahead and eight behind cached origin/main, with unrelated Invoice Entry edits and scratch files. No pull, reset, stash, or unrelated staging is permitted. Reconcile repository ownership before deployment. No implementation, runtime repair, or central mutation was performed in this investigation.
