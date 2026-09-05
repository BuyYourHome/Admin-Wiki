# WES-VIDEOEDITOR One-Hour Synthetic Exception Setup

Date: 2026-09-05
Status: revised authorized local setup instructions prepared; remote exception **not installed** from WESSTUDIO. A supported, verified hard automatic schedule stop remains mandatory before activation. Exact original settings may be restored later by Codex or manually.

## Exact Authority And Target

- Current decision: `prmsg-jean-wve-synthetic-hours-exception-20260905-002`.
- Current decision SHA-256: `f17dc89713811160343e395ce057ca8f4350cc5e2203fb4845ba48a688bbffbd`.
- Prior decision retained as history: `prmsg-jean-wve-synthetic-hours-exception-20260905-001`, SHA-256 `68f29c5b33e768376652f1b9f4983c2f47eedd437b8a7ba5ef0a99de1618b2b7`.
- Decision destination: Create PR / `019fdc5e-a1da-7e10-b388-a3be3830ac89` / WESSTUDIO. The local dispatcher reads the decision as linked authority; it must not accept/finalize this Create PR-addressed record.
- Existing local owner: `PR Messaging Dispatcher - WES-VIDEOEDITOR`, task `01a05d0c-8031-7d92-9474-ab2330008ddb`.
- Existing automation: `pr-messaging-dispatcher-wes-videoeditor`.
- Only test: `prmsg-create-pr-wve-dispatcher-recipient-validation-20260905-001`.
- Test SHA-256: `3920b0a0251234448410c1763bc8c33dab8370278e71ef29629b79974d4a89fe`.
- Initial preparation commit: `1c4a51f3`, verified published. The final decision result identifies the subsequent published exception-instructions commit to pull.

Wes permits a temporary outside-hours exception **today, September 5, 2026, America/New_York**, only for the immutable synthetic test above. This supersedes that test's older weekday-wait/earliest-window restriction through linked authority, not an edit to its payload. It grants no general all-hours schedule, production action, readiness promotion, or design implementation.

Historical blocker: WES-VIDEOEDITOR reported that the prior independent automatic-restoration requirement prevented activation; the synthetic remained Queued with zero attempts. Decision `002` supersedes only that restoration prerequisite. It permits a later Codex turn or explicit manual restoration of the exact captured original prompt/schedule/status. It does not waive the verified hard automatic one-hour schedule stop. Prior decisions and failure evidence remain unchanged.

## Local Setup Only

1. Work in the existing owner task on WES-VIDEOEDITOR under the intended normal Windows identity. Verify `Get-Location`, exact task/machine, canonical `C:\Codex\Wiki Files` project, and `main`. Safely pull and verify the published instructions/manifest through normal Git rules; stop on dirty/diverged work rather than stashing, resetting, merging, or overwriting. Do not use Teams as the repo.
2. Read the canonical Messaging Rule, dispatcher skill/heartbeat prompt, this report, the manifest, and both central records through `Manage-ProjectRoomMessage.ps1`. Independently verify exact IDs, hashes, and linked authority. Keep the synthetic immutable. Before any automation mutation, require Queued, zero attempts/notifications, no receipt/result, and maximum attempts one. If already attempted or terminal, reconcile; do not retrigger or reset.
3. Use the supported **local automation tool** to inspect the actual existing automation. Capture its original ID, name, kind, target, model/reasoning, notification policy, prompt, schedule, and status in durable profile-local recovery state outside Git. Preserve the exact original values, not a reconstructed approximation. Store no secrets in reports/messages.
4. Preserve the **same existing automation** and its ID/name/kind/target/model/notification policy throughout. Retain the captured exact original prompt/schedule/status for later restoration. Independent automatic restoration is no longer a prerequisite: a later Codex turn or explicit manual restoration is permitted. No new task, automation, background service, or separate scheduled watchdog is authorized.
5. Require a temporary five-minute schedule with an absolute end no later than activation plus 60 minutes. Set and record actual activation/expiry in UTC at installation; do not extend them on later runs. Do not activate on a later local date using this today-only decision. A missed/suspended run must not leave an all-hours schedule active past expiry.
6. **Fail closed before activation if the supported hard automatic schedule expiry cannot be configured and verified.** The scheduler must stop temporary invocations by the fixed expiry without depending on another model turn or manual intervention. A prompt-only promise to stop later is insufficient. Schedule expiry may leave the original settings unrestored until a later Codex turn or manual action. Until restoration is verified, the expired/terminal override must permit no further claims and no fallback to unfiltered production. Report an unsupported hard-expiry feature or access error; do not invent scheduler fields, edit app storage directly, change machine policy, or install a workaround.
7. Only after all checks pass, configure the existing heartbeat locally using its supported automation tool. Save a short temporary pointer prompt to reread this report, the current canonical heartbeat/Messaging Rule, both exact central records, and the saved recovery state on every scheduled run. Include the exact test ID and fixed activation/expiry. The linked decision overrides only the outside-hours restriction; the exact-message restriction persists for the full temporary exception, not merely the setup turn. Never fall back to normal unfiltered processing during the exception.
8. Read back the actual automation and verify every preserved field, five-minute bounded schedule, fixed hard expiry, and exact filter pointer. On setup failure, keep claims disabled, restore the captured original when safely possible, verify it, and report any outstanding restoration. Do not claim/StartAttempt, notify the synthetic recipient, manually run the helper, write its receipt/lifecycle, or force a heartbeat during setup.
9. Return installed/blocked, actual activation/expiry, captured-original reference, verified hard-expiry mechanism/read-back, restoration status, and current test state to Create PR via a linked canonical status. If restoration is still needed after expiry or terminal result, report it explicitly for a later Codex turn or manual completion. Do not mark `manual_intervention: false` or readiness complete based on this manually initiated setup.

## Scheduled Test Contract

Only a normal scheduled turn of that existing heartbeat may execute the test. At each temporary run, verify machine/task, fixed expiry, exact test ID/hash, unchanged one-attempt limit, and matching `validation_ready` manifest with `dispatchable: false`. If terminal or expired, end without claims or unfiltered fallback. The scheduler's hard expiry stops temporary invocations independently. Restore the exact saved original prompt/schedule/status in the current or a later Codex turn, or explicitly by manual action, and verify read-back before treating restoration as complete. Preserve recovery evidence until verified restoration; an expired/terminal override is never permission for production claims.

Immediately before any helper call, recheck current UTC against the fixed expiry and require the literal nonblank exact MessageId below, even if the scheduled turn began before expiry. After any intervening wait/tool work, recheck again at the invocation boundary. An expired, missing/blank/wrong/attempted/terminal target must never select another record. This is the only permitted claim command, **for a scheduled turn, never the setup turn**:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'C:\Codex\Wiki Files\tools\pr-messaging\Claim-ProjectRoomDispatch.ps1' -ActorTaskId '01a05d0c-8031-7d92-9474-ab2330008ddb' -MessageId 'prmsg-create-pr-wve-dispatcher-recipient-validation-20260905-001'
```

Use approved normal-Windows-identity execution so existing SMB authentication is available; the process-scoped wrapper does not change machine execution policy. Do not run the unfiltered example in the normal heartbeat prompt during this temporary exception. The helper must filter before selection and write StartAttempt through the manager. Never bypass an explained no-claim result.

After one claim, issue only one supported local notification to the exact recipient. The dispatcher is also the recipient, so safe self-task enqueue remains unproven: do not fabricate a recipient receipt from the polling/setup turn, interrupt a running turn, substitute a task, start another runtime, or count an enqueue acknowledgment as delivery. Follow bounded central reconciliation for an ambiguous/unsupported notification and never reset the one-attempt budget. No manual paste or direct user activation may count as the unattended lifecycle.

Once the destination writes its own exact-identity Accepted, Processing, and terminal outcome, no further test claim is permitted. Failure or expiry also permits no new claims. Restore the saved original settings later through Codex or manual action when not already restored, and record/read back the exact result. Report pending or failed restoration; do not label it successful or enable unfiltered production before verification. Production routing, mailbox/email/QuickBooks/business actions, credentials/ACL changes, and readiness promotion remain prohibited.

## Paste Into The Existing WES-VIDEOEDITOR Owner Task

```text
Set up only Wes's authorized temporary synthetic-hours exception in this existing WES-VIDEOEDITOR PR Messaging Dispatcher task 01a05d0c-8031-7d92-9474-ab2330008ddb. This manual setup turn must not claim, StartAttempt, notify the synthetic recipient, or write its lifecycle.

Verify Get-Location and use only C:\Codex\Wiki Files on main with explicit shell workdir/absolute paths. Safely pull the published exception instructions, then read C:\Codex\Wiki Files\Project Rooms\Create PR\outputs\WES-VIDEOEDITOR One-Hour Synthetic Exception Setup.md and the current canonical rules. Reconcile decision prmsg-jean-wve-synthetic-hours-exception-20260905-002 through the canonical manager and independently verify hash f17dc89713811160343e395ce057ca8f4350cc5e2203fb4845ba48a688bbffbd. Do not accept/finalize that Create PR-addressed decision. It supersedes only the prior independent automatic-restoration gate.

The only test is prmsg-create-pr-wve-dispatcher-recipient-validation-20260905-001, hash 3920b0a0251234448410c1763bc8c33dab8370278e71ef29629b79974d4a89fe. Keep it unchanged; require Queued, zero attempts/notifications, no receipt/result, max attempts one. Keep dispatchable false. Use only existing automation pr-messaging-dispatcher-wes-videoeditor; preserve its ID/name/kind/target/model/notification policy and capture original prompt/schedule/status outside Git.

Before activation, verify a supported hard automatic schedule stop with fixed absolute UTC expiry no later than one hour after activation. A prompt-only stop is insufficient; if supported hard expiry is unavailable, stop before activation. Independent automatic restoration is no longer required: restore the exact captured original prompt/schedule/status in a later Codex turn or manually and verify it. Until restoration is verified, terminal/expired override permits no claims or unfiltered fallback. Configure only a five-minute temporary schedule for today, with a short pointer requiring this report and the exact MessageId filter on every temporary run. Recheck literal MessageId and expiry immediately before the helper, even if the turn began before expiry. Read back all preserved settings and hard-expiry controls. No new task/automation/watchdog, expiry extension, forced run, manual helper call, or machine execution-policy change.

Only a normal scheduled turn may use the exact filtered helper command in the report and issue one supported self-task notification. No unfiltered fallback, production claim, business action, fabricated receipt, promotion, or early implementation. Return local installed/blocked status, actual activation/expiry, verified hard-expiry evidence, restored or pending-restoration status, and current test state in a linked canonical status to Create PR task 019fdc5e-a1da-7e10-b388-a3be3830ac89 on WESSTUDIO.
```

## WESSTUDIO Completion Boundary

Create PR prepared only the scoped revised setup instructions and decision note; the current central final result records actual publication evidence. This app cannot configure the remote automation, and no remote installation, activation, expiration timestamp, or hard-expiry capability is claimed. The unchanged synthetic remains queued until a supported, safely configured local exception runs, or the normal weekday window applies. Missing independent automatic restoration is no longer a blocker under decision `002`; missing verified hard automatic schedule expiry remains a blocker. Original settings may be restored later by Codex or manually, with no further claims or unfiltered fallback while restoration is pending.
