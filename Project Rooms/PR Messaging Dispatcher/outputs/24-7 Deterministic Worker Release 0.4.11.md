# 24/7 Deterministic Worker Release 0.4.11

Date: 2026-11-01

## Scope

Release `0.4.11` adds guarded validation enrollment support for exactly one additional endpoint:

- project room: `Medicare`
- task: `01a198bd-6bd0-7013-bd02-2b26a715e552`
- machine: `WESSTUDIO`
- skill: `medicare`
- manifest: `config\pr-messaging-manifests\medicare.json`

It does not create a general destination editor. Codex Environment, Smart House, and House Render remain supported; every other endpoint remains rejected.

## Preserved controls

The installer still requires exact config, manifest, payload, registration, owner-generation, package, manager, adapter, reviewed CLI, scheduled-action, journal, and destination identity evidence. It retains the worker lock, atomic replacement, flushed before-image and receipt evidence, idempotent repeat behavior, existing pins and their order, owner and task identity, journal, state directory, hidden launcher, Live mode, and one-minute schedule.

The validation-ready gate still admits only the manifest-named synthetic with `max_attempts: 1`, a distinct approved source machine, `authorized_by: Wes`, `synthetic_test: true`, and all business-action authorization/performed flags explicitly false. Production messages and any different synthetic ID remain ineligible in both local worker evaluation and the atomic manager.

## Guarded WESSTUDIO sequence

1. Create PR reconciles the verified Medicare registration and host-access evidence, and confirms the canonical schema-2 `medicare.json` manifest exists with the exact task and WESSTUDIO identity.
2. Reconcile the central queue and reuse an exact authorized Medicare validation record if one exists. Never duplicate or retry uncertain submission evidence.
3. If none exists, Create PR may create one immutable remote-source status synthetic with matching message/dispatch ID, one attempt, and no business action.
4. Create PR updates only the Medicare manifest to `validation_ready`, retaining `dispatchable: false`, and records the exact synthetic ID, cross-machine source, dispatcher identity, and `manual_intervention: null`.
5. Safely fast-forward WESSTUDIO and run guarded `UpgradeLive` for dispatcher `01a06337-1b59-7dc2-9586-6660eb7b5da7` and legacy automation `pr-messaging-dispatcher`. The installer must review and pin the current normal-user `codex.exe` path and SHA-256 while preserving all existing destinations and runtime evidence.
6. Capture fresh config, owner-generation, manifest, and payload-hash guards and run `EnrollValidationDestination` for the exact Medicare endpoint.
7. Do not force a worker run or notify Medicare manually. A natural worker tick must claim and submit exactly once.
8. Require canonical recipient-authored `Accepted`, `Processing`, and `Completed`. Only Create PR may then mark the manifest ready and `dispatchable: true` under its normal readiness procedure.

No Medicare advice, enrollment, coverage selection, insurance action, email, production processing, or other business action is authorized by this release or its synthetic validation.

## Verification evidence

Windows PowerShell 5.1 isolated tests passed on WES-VIDEOEDITOR under `IRAMa`:

- `Test-DestinationEnrollment.ps1`: 19 passed, 0 failed, 0 production actions, 0 real CLI submissions.
- `Test-Enrollment.ps1`: 26 passed, 0 failed, 0 production changes, 0 real notifications.
- `Test-LowTokenWorker.ps1`: 69 passed, 0 failed, 0 production actions, 0 real CLI submissions.

The 114 passing tests cover exact Medicare skill mapping, additive pin preservation, repeat idempotence, config/manifest/payload/owner/CLI/schedule/journal guards, worker-lock and concurrent-enrollment behavior, restart and ambiguity handling, preserved runtime evidence, and rejection of production or any different synthetic ID. Fixture success is code evidence only; it is not WESSTUDIO enrollment or Medicare dispatchability evidence.
