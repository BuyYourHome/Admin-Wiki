# WES-VIDEOEDITOR Distinct Recipient Transport Validation

Date: 2026-09-05
Status: one new synthetic queued; local persistent-filter replacement pending. No test claim, notification, or destination lifecycle was performed by Create PR.

## Authority And Exact Identities

- Design handoff: `prmsg-jean-wve-distinct-recipient-validation-design-20260905-001`.
- Handoff hash: `3a314e7160c4618d2c2f0a4db9128ec00d370840585c4884c477e66eeeac73ca`.
- New test: `prmsg-create-pr-wve-quickbooks-transport-validation-20260905-001`.
- New test hash: `43274ae2364f5d2f23a6b4bfc308761d02276e62c0e2b02d3ee851b3c2711f83`.
- Source: Create PR / `019fdc5e-a1da-7e10-b388-a3be3830ac89` / WESSTUDIO.
- Existing dispatcher: `01a05d0c-8031-7d92-9474-ab2330008ddb`, automation `pr-messaging-dispatcher-wes-videoeditor`, WES-VIDEOEDITOR.
- Distinct existing recipient: **Quickbooks** / `01a05967-9a05-7081-a62e-616b2d8e61fd` / WES-VIDEOEDITOR.
- Recipient manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\quickbooks.json`.
- Created through canonical manager at `2026-09-05T19:17:25.7546493Z`; type status; synthetic true; max attempts **one**; at preparation Queued / zero attempts / no receipt or result.

Wes explicitly authorized this changed-recipient test. It is not permission to evade the old test's attempt budget, retry self-notification, open a business workflow, or create another task.

## Failed Self-Test Preserved

`prmsg-create-pr-wve-dispatcher-recipient-validation-20260905-001`, hash `3920b0a0251234448410c1763bc8c33dab8370278e71ef29629b79974d4a89fe`, remains Delivery Ambiguous with one of one attempts used. The recorded attempt began `2026-09-05T18:52:34.9950721Z` and ended `2026-09-05T18:55:44.3107967Z`. The notification appeared in the active polling turn rather than a separately evidenced recipient turn; no acceptance/result followed the bounded wait. This describes that self-notification run, not a general failure of task notification.

Do not change, reset, retry, reopen, delete, or backfill that record. The old setup/queue reports are retained as historical evidence. Its failed proof is separated from current dispatcher recipient readiness, which remains pending/non-dispatchable.

## Recipient Eligibility

The existing Quickbooks manifest records the exact distinct WVE task, dispatchable true, readiness ready, acceptance of status messages, exact registration/host-access verification at `2026-09-02T02:08:10.9144177Z`, and successful exact-machine readiness validation. Its README/skill also document a no-QuickBooks-action synthetic lifecycle separately from Invoice mode.

The canonical manager confirmed prior exact-task synthetic `prmsg-quickbooks-renamed-identity-validation-20260902-correction-001`, hash `1368f6cec891d2ca8e12e9f37282d135c6beaf83f9c415820bfd76a83a25d1bb`, Completed at `2026-09-02T09:40:19.2516703Z` after one notification with the exact Quickbooks/WVE receipt, no business action and `manual_intervention: false`.

These are recorded eligibility and prior registration evidence, not a fresh remote client-file inspection. Before replacing the filter, the local WVE owner must recheck that its current normal-profile client configuration contains exactly one matching Quickbooks/task registration and the local manifest matches. Stop on drift; no registration edits or alternative recipient. The helper enforces the exact registration again at claim time.

This new status record requests only central messaging verification and lifecycle. It is **not Invoice mode**: no Invoice Entry packet, company selection, Chrome/QuickBooks access, connector action, invoice, bill, payment, financial change, or external communication is requested or authorized. Preserve all normal Invoice-mode source/approval requirements. Do not edit the recipient's existing good readiness evidence, manifest, README, or skill.

## Local Setup: Replace Only The Persistent Filter

1. In the existing WVE dispatcher task, verify Get-Location, exact task/machine/profile, canonical `C:\Codex\Wiki Files`, and main. Safely pull the published setup commit from the final design result. Do not overwrite dirty/diverged work or use a Teams working repo.
2. Read this report, current canonical rules, the exact design/new-test/failed-test records through the manager, and the recipient manifest. Verify all exact IDs/hashes and current Queued/zero-attempt/no-receipt/no-result state for the new test. Reconcile if it changed; never reset it.
3. Recheck the exact distinct recipient registration as above and inspect the actual existing local automation using the supported automation tool. Preserve its ID/name/kind/target/model/reasoning/notification policy and current **ACTIVE every-five-minutes 24/7/no-expiry** schedule. Do not create a task/automation, change hours, introduce expiry, or edit app storage.
4. Save a profile-local backup of the existing prompt/configuration outside Git, then replace **only** the persistent exact test filter/pointer: old failed self-test ID -> `prmsg-create-pr-wve-quickbooks-transport-validation-20260905-001`. Use a short pointer rereading this report and canonical rules every run. Exact filtering must persist across ALL subsequent scheduled turns, including after terminal/exhausted state; no unfiltered production fallback.
5. Read back the exact new filter and unchanged automation settings. Return filter-installed/blocked, read-back evidence, recipient registration check, and current test state to Create PR. This setup turn must not invoke the helper, claim, StartAttempt, notify the test recipient, write its lifecycle, force a run, or touch the old failed record.

## Normal Scheduled Test

Only a normal scheduled turn of the existing WVE dispatcher may invoke this exact filtered helper under approved normal-Windows-identity access:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'C:\Codex\Wiki Files\tools\pr-messaging\Claim-ProjectRoomDispatch.ps1' -ActorTaskId '01a05d0c-8031-7d92-9474-ab2330008ddb' -MessageId 'prmsg-create-pr-wve-quickbooks-transport-validation-20260905-001'
```

The helper filters before selection and writes StartAttempt through the canonical manager. Never run without the literal nonblank exact MessageId or reinterpret a no-claim result. After one claim, send exactly one supported local notification to **Quickbooks task `01a05967-9a05-7081-a62e-616b2d8e61fd`**, not to the dispatcher. Do not interrupt active work or substitute a task/runtime.

The actual recipient turn verifies the central record and writes its own Accepted, Processing, and one final result. Record notification count one, exact identities/machines, and `manual_intervention: false` only from actual unattended evidence. Require no browser/business action. The dispatcher never performs recipient work or manufactures its receipts. Follow bounded canonical ambiguity handling; one attempt means no additional claim/reset. After terminal/exhausted state, report once, remain quiet on unchanged state, and keep the exact filter so no other record is selected.

## What This Test Proves And Does Not Prove

Success proves current unattended cross-machine discovery and delivery from the WVE dispatcher to this **distinct existing recipient**. It does not prove the dispatcher itself can receive arbitrary implementation work, and must not be copied into dispatcher-recipient readiness fields. Quickbooks' good existing readiness evidence stays unchanged. Do not reintroduce self-notification as a prerequisite for this test.

The remaining low-token implementation gate is a separately authorized and deliverable handoff to the owning workflow, then actual exact-task CLI wake-up proof and isolated worker/manager tests from the approved design before deployment. This task neither implements that worker nor certifies its readiness. Permanent low-token 24/7 operation remains future intent, not current production authority.

Prior publication correction: `e6f28d04dc5fffb29d8e0c8ce564fced338f98ae` was verified on GitHub before this preparation. Prior Blocked publication finals remain historical. The new final design result records actual new commit/push evidence.

## Short WVE Paste Prompt

```text
In existing WES-VIDEOEDITOR dispatcher task 01a05d0c-8031-7d92-9474-ab2330008ddb, safely pull the published correction into C:\Codex\Wiki Files on main and read C:\Codex\Wiki Files\Project Rooms\Create PR\outputs\WES-VIDEOEDITOR Distinct Recipient Transport Validation.md. Verify Get-Location first and reconcile the exact central IDs/hashes in that report.

Preserve existing automation pr-messaging-dispatcher-wes-videoeditor and its ACTIVE five-minute 24/7/no-expiry schedule plus identity/model/notification settings. Verify current exact local registration and manifest for Quickbooks task 01a05967-9a05-7081-a62e-616b2d8e61fd. Replace only the persistent test filter/pointer with prmsg-create-pr-wve-quickbooks-transport-validation-20260905-001, hash 43274ae2364f5d2f23a6b4bfc308761d02276e62c0e2b02d3ee851b3c2711f83. Back up/read back settings. No new task, automation, expiry gate, or unfiltered fallback.

This setup turn must not claim, StartAttempt, notify the recipient, write test lifecycle, or force a run. Preserve the old failed self-test and its exhausted budget. Only a normal scheduled turn may deliver the new one-attempt synthetic to the DISTINCT Quickbooks task. No Chrome/QuickBooks/business action or readiness promotion. After terminal/exhausted state, keep exact filtering, report once and stay quiet on unchanged state. Return local filter-install evidence or the exact blocker.
```
