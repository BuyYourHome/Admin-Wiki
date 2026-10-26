# 24/7 Deterministic Worker Release 0.4.10

Date: 2026-10-26

## Scope

Release `0.4.10` adds guarded validation enrollment support for exactly one additional endpoint:

- project room: `House Render`
- task: `01a178f1-8292-7aa3-863d-f6de8a3c44f7`
- machine: `WESSTUDIO`
- skill: `house-render`
- manifest: `config\pr-messaging-manifests\house-render.json`

It does not create a general destination editor. Codex Environment and Smart House remain supported; every other endpoint remains rejected.

## Preserved controls

The installer still requires exact config, manifest, payload, registration, owner-generation, package, manager, adapter, reviewed CLI, scheduled-action, journal, and destination identity evidence. It retains the worker lock, atomic replacement, flushed before-image and receipt evidence, idempotent repeat behavior, existing pins and their order, owner and task identity, journal, state directory, hidden launcher, Live mode, and one-minute schedule.

The validation-ready gate still admits only the manifest-named synthetic with `max_attempts: 1`, a distinct approved source machine, `authorized_by: Wes`, `synthetic_test: true`, and all business-action authorization/performed flags explicitly false. Production messages and any different synthetic ID remain ineligible in both local worker evaluation and the atomic manager.

## Guarded WESSTUDIO sequence

1. Preserve terminal setup record `prmsg-jean-create-pr-house-render-20261026-001` unchanged.
2. Reconcile the central queue and reuse an exact authorized House Render validation record if one exists. Never duplicate or retry uncertain submission evidence.
3. If none exists, Create PR may create one immutable remote-source status synthetic with matching message/dispatch ID, one attempt, and no business action.
4. Create PR updates only the House Render manifest to `validation_ready`, retaining `dispatchable: false`, and records the exact synthetic ID, cross-machine source, dispatcher identity, and `manual_intervention: null`.
5. Safely fast-forward WESSTUDIO, synchronize canonical skills, and run guarded `UpgradeLive` for dispatcher `01a06337-1b59-7dc2-9586-6660eb7b5da7` and legacy automation `pr-messaging-dispatcher`. The installer must review and pin the current normal-user `codex.exe` path and SHA-256.
6. Capture fresh config, owner-generation, manifest, and payload-hash guards and run `EnrollValidationDestination` for the exact House Render endpoint.
7. Do not force a worker run or notify House Render manually. A natural worker tick must claim and submit exactly once.
8. Require canonical recipient-authored `Accepted`, `Processing`, and `Completed`. Only Create PR may then mark the manifest ready and `dispatchable: true` under its normal readiness procedure.

No House Render rendering, website publication, device control, purchase, email, production processing, or other business action is authorized by this release or its synthetic validation.

## Verification requirements

Isolated tests must prove exact House Render enrollment, repeat idempotence, config/manifest/payload/owner/CLI/schedule/journal guard failures, lock and concurrent enrollment behavior, preservation of existing pins and runtime evidence, and rejection of production or a different synthetic ID. The test harness must perform zero production changes and zero real CLI submissions.
