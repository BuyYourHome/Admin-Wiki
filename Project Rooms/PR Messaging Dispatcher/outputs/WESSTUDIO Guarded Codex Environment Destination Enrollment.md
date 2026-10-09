# WESSTUDIO Guarded Codex Environment Destination Enrollment

Status: implementation ready for Create PR deployment preparation; no live enrollment or recipient lifecycle performed.

## Exact Scope

- Execution machine: `WESSTUDIO`
- Existing destination: `Codex Environment`
- Destination task: `019f84d0-78d4-7013-8c07-42c01f961be1`
- Dispatcher task: `01a06337-1b59-7dc2-9586-6660eb7b5da7`
- Dispatcher automation: `pr-messaging-dispatcher`
- Installer action: `EnrollValidationDestination`
- Release: `0.4.8`

The installer rejects WES-VIDEOEDITOR and any other destination room/task pair.

## Create PR Prerequisites

Create PR retains ownership of these readiness steps:

1. Create `config\pr-messaging-manifests\codex-environment.json` as schema 2 with `dispatchable: false` and `messaging_readiness.status: validation_ready`.
2. Bind that manifest to one fresh immutable synthetic validation record by exact `validation_message_id`.
3. Record dispatcher task `01a06337-1b59-7dc2-9586-6660eb7b5da7`, automation `pr-messaging-dispatcher`, a source machine other than WESSTUDIO, and `manual_intervention: null`.
4. On WESSTUDIO under the normal Codex Windows identity, register exactly one `Codex Environment` / `019f84d0-78d4-7013-8c07-42c01f961be1` identity and verify authenticated central-queue access.
5. Leave the validation record Queued with zero attempts, `max_attempts: 1`, no receipt/result, `synthetic_test: true`, and all business-action flags false.
6. Record the manifest file SHA-256, validation payload hash, current installed config SHA-256, and current owner generation. Do not derive or repair any of these values inside the enrollment action.

## Supported WESSTUDIO Deployment

First pull the published release and refresh the installed package and CLI pin through the guarded installer:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\Install-LowTokenWorker.ps1" -Action UpgradeLive -ExpectedMachine WESSTUDIO -DispatcherTaskId "01a06337-1b59-7dc2-9586-6660eb7b5da7" -LegacyAutomationId "pr-messaging-dispatcher"
```

After verifying release `0.4.8`, the current normal-user `codex.exe` path/hash, the Live owner, and the unchanged journal/task, calculate the four exact evidence values and run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\Wiki Files\tools\pr-messaging\low-token\Install-LowTokenWorker.ps1" `
  -Action EnrollValidationDestination `
  -ExpectedMachine WESSTUDIO `
  -DispatcherTaskId "01a06337-1b59-7dc2-9586-6660eb7b5da7" `
  -LegacyAutomationId "pr-messaging-dispatcher" `
  -DestinationProjectRoom "Codex Environment" `
  -DestinationTaskId "019f84d0-78d4-7013-8c07-42c01f961be1" `
  -ValidationMessageId "<exact fresh synthetic message id>" `
  -ExpectedManifestSha256 "<SHA-256 of codex-environment.json>" `
  -ExpectedValidationPayloadHash "<canonical record payload_hash>" `
  -ExpectedConfigSha256 "<SHA-256 of installed 0.4.8 config.json>" `
  -ExpectedOwnerGeneration "<current preserved owner generation>"
```

Do not run `StartValidation`, force the scheduled task, notify the destination manually, or edit the record. Observe the next natural Live tick. The exact synthetic record must be the only validation-ready exception for this destination.

## Required Verification

- Installer result is `ValidationDestinationEnrolled` or the exact idempotent `ValidationDestinationAlreadyEnrolled`.
- Every prior destination remains present exactly once and Codex Environment appears exactly once.
- Owner, generation, journal SHA-256, state directory, scheduled-task action, hidden launcher, principal, triggers, settings, and one-minute Live schedule are unchanged.
- The scheduled task is enabled after enrollment.
- The central validation record remains Queued with zero attempts immediately after enrollment; `recipient_lifecycle_started` is false.
- A later natural tick may create exactly one attempt. Recipient acceptance, processing, completion, readiness validation, and dispatchable promotion remain Create PR responsibilities.
- Any identity, hash, registration, manifest, task, CLI, journal, owner, or record mismatch fails closed. Do not bypass the installer, reset attempts, or recreate/retry an uncertain record.

This local implementation and enrollment procedure do not prove system recovery or destination readiness.

## Isolated Verification

- Destination-enrollment suite: 15 passed, 0 failed.
- Existing worker claim, pin, release, scheduler, validation-ready, and concurrency subset: 11 passed, 0 failed.
- Serialized journal, outage, ambiguity, acceptance, and no-replay subset: 5 passed, 0 failed.
- PowerShell parsing: 6 changed scripts parsed with zero errors.
- Direct scope probes: WES-VIDEOEDITOR rejected with `DestinationEnrollmentScopeMismatch`; attempting to name WESSTUDIO while running elsewhere rejected with `InstallationMachineMismatch`.
- Test production actions: 0.
- Test real CLI submissions: 0.
