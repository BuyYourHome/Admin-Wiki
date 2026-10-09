# Codex Environment additive enrollment - 2026-10-09

Status: implemented and fixture-tested; owner coordination, publication, live enrollment, unattended validation, readiness promotion, and coordinator acceptance remain pending. This is not overall system recovery.

## Exact authorization and identities

Wes directly authorized the narrowly scoped `EnrollValidationDestination` installer change, its specified safeguards, isolated tests, and synthetic-only endpoint completion on October 9. No invoice, email, payment, workbook change, production replay, attempt reset, replacement chat, or WES-VIDEOEDITOR destination enrollment is authorized.

- Endpoint: Codex Environment / `019f84d0-78d4-7013-8c07-42c01f961be1` / WESSTUDIO.
- Existing local chat and `C:\Codex\Wiki Files` cwd were verified with the app thread tool; the saved Wiki Files project uses that same canonical repository.
- Local dispatcher: `01a06337-1b59-7dc2-9586-6660eb7b5da7`.
- Registered worker-code owner: PR Messaging Dispatcher - WES-VIDEOEDITOR / `01a05d0c-8031-7d92-9474-ab2330008ddb`.
- Existing repair: `prmsg-codex-environment-handoff-repair-20261008-create-pr-001`, immutable hash `8c24cac3979098f48bb8766c943c0ec8f177d04a674860ca83e32746eabdeb1e`.

The repair remains hash-valid, Accepted then Processing then terminal Blocked, with one Delivered attempt. Its existing receipt, final result, immutable payload and attempt history were preserved. No duplicate repair was created, and no terminal lifecycle was reset.

## Implementation and review

Scoped files:

- `tools\pr-messaging\low-token\Install-LowTokenWorker.ps1`: additive action and four required expected guards; exact endpoint/machine restriction.
- `tools\pr-messaging\low-token\installer\Enrollment.ps1`: lock-protected validation, additive transformation, prepared receipt, before-image, atomic local replacement and read-only idempotent repeat.
- `tools\pr-messaging\low-token\tests\Test-Enrollment.ps1`: isolated fixture suite.
- `tools\pr-messaging\low-token\README.md`: deployment contract and limitations.

Review verified that the new action never calls task enable/disable, registration overwrite, manager mutation, CLI notification, recipient lifecycle, or rollback. It holds the same exclusive `worker.lock` as a tick and writes only the new local config, enrollment receipt, before-image and transient evidence. Prior pins and all other config fields retain their values/order. No installed worker, adapter, manager, schedule, owner or journal is changed by publishing this installer-only source revision.

The current config is authenticated before its executable paths are used. Repeat enrollment proves the current config is exactly the authorized append to the hash-verified before-image; it cannot adopt an unexplained existing pin. An unresolved recipient submission does not cause a second write or notification. Failures retain evidence and never automatically remove a pin or restore a prior config.

The production action rejects a different machine/dispatcher. The helper also requires the manifest-authorized synthetic to originate from an approved different computer. A WESSTUDIO-created record labeled as another machine would not be valid evidence and was not created.

## Test evidence

Windows PowerShell 5.1 final suite: **23 passed, 0 failed**, zero real notifications and zero production configuration changes.

Coverage includes:

- successful one-pin append and preservation of all non-destination config plus owner/journal/schedule evidence;
- repeat enrollment after an unresolved submission, with byte-stable config and unchanged record;
- mismatched or absent expected config, manifest, payload and CLI hashes, and wrong generation;
- owner, scheduled action, registration, manifest, executable, package, source, production flag, prior-attempt and journal-history failures;
- a held worker lock, guard changes during retrieval, and two competing hidden child processes sharing the same lock/config;
- normal worker rejection of production and wrong synthetic IDs;
- independent atomic-manager rejection of production with zero attempts added.

The first harness run exposed a fixture path assertion issue; a PowerShell-job concurrency harness also failed to finish in the managed environment. These were corrected in the test harness. The final suite uses bounded hidden child processes and passed. No production workaround was applied.

Final evidence: `C:\Users\wesbr\AppData\Local\Temp\byh-enrollment-evidence-feda166233c34559a98563ddd8481a17\enrollment-tests.json`. Fixture data stays outside Git. PowerShell parsing and `git diff --check` passed. Fixture success is not evidence of real recipient delivery.

## Live state preserved

- Existing schema-2 endpoint manifest and exact local client registration remain present, `dispatchable: false`, readiness `pending`.
- Canonical manager List found **zero records addressed to the exact Codex Environment task**, including no synthetic to reuse. No new synthetic was created.
- Active WESSTUDIO config SHA-256 remains `7398B1ED4E0B7A01729E3B7251D249E8756D7C180F034170F1E9F8E09895AB26`.
- Owner generation remains `0.4.0`; existing pins remain Create PR and Bathroom Fixtures only.
- Current installed CLI file still matches its recorded pin.
- No installer enrollment, forced tick, direct recipient notification, recipient lifecycle action, readiness promotion, recovery handoff, or coordinator acceptance occurred.

## Remaining gates and resumption

The code-owner thread read returned: `Could not determine whether Codex thread 01a05d0c-8031-7d92-9474-ab2330008ddb exists. Unavailable or failed hosts: durable`. This is an access/coordination failure, not proof that the existing owner chat disappeared. Wes was given a paste-ready coordination request for that exact existing chat. No substitute or self-addressed central message was created. Publication/deployment is held pending the requested owner coordination.

After owner coordination:

1. Review/publish the scoped correction under shared-main Git rules; do not rewrite or silently bundle questionable earlier commits.
2. Have an authenticated approved second-machine owner reconcile and originate one authorized synthetic via the canonical manager, or reuse an exact existing record if one subsequently appears. Return its verified ID/hash and source identity. Maximum one attempt; all business-action flags false.
3. Create PR records that exact ID, source machine and dispatcher identity in `validation_ready`, keeping `dispatchable: false`.
4. Capture fresh config hash, owner generation, manifest-file hash and synthetic payload hash. Run the canonical installer action on WESSTUDIO only. A busy lock is a no-change result, not a transport retry.
5. Observe a natural worker tick; require exactly one notification and the recipient's own Accepted, Processing and Completed. Preserve uncertainty without retry or manual lifecycle.
6. Verify every readiness gate and promote only after successful evidence. Then send the single recovery handoff through normal transport and verify exact coordinator acceptance.

Recovery handoff content to retain, not yet delivered:

> WES-VIDEOEDITOR reports guarded upgrade to release 0.4.7, preserved valid journal and owner generation 0.4.0, matching CLI/manager pins, passing diagnostic tests, and two natural TickComplete runs with zero submissions. Its local worker is healthy, but recipient delivery and overall system recovery remain unverified. Codex Environment must coordinate fresh OA and WESSTUDIO installation checks, producer-contract consistency, synthetic end-to-end delivery, workbook identity, and downstream continuation. This is endpoint setup and synthetic integration authority only; no invoice, email, payment, workbook, production replay or attempt reset is authorized.

This WES-VIDEOEDITOR status is Wes-provided evidence, not an independent remote verification by Create PR.
