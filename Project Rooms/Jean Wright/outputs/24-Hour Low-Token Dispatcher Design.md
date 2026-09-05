# 24-Hour Low-Token Dispatcher Design

Date: 2026-09-05
Status: Review-ready coordination design; not deployed.

Wes requested continuous dispatcher availability without consuming model tokens on every scheduled queue check and authorized proceeding with the design. This proposal does not supersede the current Messaging Rule, authorize business work, or change an automation. No queue claims or task notifications were made to prepare it.

## Decision

Replace recurring model-driven dispatcher turns with one deterministic Windows scheduled worker per execution computer. Check the central queue every 60 seconds, continuously. Invoke Codex only when a validated record needs its owning task, or when a new actionable exception needs human-facing escalation.

Retain the canonical PowerShell messaging manager and immutable central records. Do not introduce another broker, cloud subscription, external listener, or parallel queue. The model performs destination work, not empty-queue checking.

First implementation gate: prove exact-task wake-up compatibility. The installed CLI exposes `codex queue --thread <UUID> --message <TEXT>`, but command availability does not prove it wakes an idle desktop task with its required browser/connectors. Do not disable a working heartbeat before this proof.

## Cost And Availability

- Empty polling, eligibility, receipt reconciliation, retry scheduling, and health updates must make zero model requests.
- Destination execution and genuine exception handling still consume tokens. Email Monitor's mailbox scans and summaries remain model work on their existing schedule.
- A continuous five-minute model heartbeat can produce 288 scheduled turns daily per dispatcher. This design removes polling turns, not a guaranteed percentage of total account usage.
- Target discovery latency is one polling interval plus network/runtime latency, not an instant-response guarantee.
- Each destination computer must be awake, connected, and running its intended Windows/Codex session. WES-VIDEOEDITOR must remain available as queue host. Sleep, logout, missing credentials, model limits, or unavailable tools can still block work.
- All computers need not be online for design/build. Each must be online under its intended login for its own installation and validation. One machine's test cannot establish another's readiness.

## Source Evidence

Inspected baseline: repository `837734fe527fe914fde5cd7d47a1bab5b7636a58`, local CLI `0.153.3`.

| Source | Observed behavior | Consequence |
| --- | --- | --- |
| [[Project Room Messaging Rule]] and [[Project Room Delegation Contract]] | Central records carry authority; notifications are wake-ups; destinations own receipts and business work. | Preserve source-ownership restrictions. A new transport needs a scoped rule update, not an implicit bypass. |
| `tools/pr-messaging/Claim-ProjectRoomDispatch.ps1` | Candidate filtering precedes a separate `StartAttempt`; pending attempts are skipped; optional exact-message filtering exists. | Enforce final predicates inside the manager's lock and add pending-attempt recovery. Reject an explicitly blank filter. |
| `tools/pr-messaging/Manage-ProjectRoomMessage.ps1` | Write locking exists. `StartAttempt` checks state and budget, but not all helper predicates or recomputed immutable-content integrity. | Extend the manager rather than write central JSON from the worker. |
| `Project Rooms/Dashboard/tools/Get-TransactionAttention.ps1` | Lists `Delivery Ambiguous`, `Blocked`, and `Needs Wes`; excludes stale `Delivery Attempted`, `Accepted`, and `Processing`. | Dashboard needs transport and stalled-work coverage. |
| `Project Rooms/Email Monitor/working/officeassist-heartbeat-prompt.md` | Mailbox and embedded dispatcher schedules differ. | Remove only the embedded dispatch stage at cutover; retain mailbox behavior/state. |
| Local `codex queue --help` | Exact-thread enqueue command is installed. | Runtime wake-up and tool parity remain unproven. Exit success is not acceptance. |

Official OpenAI documentation describes reopening threads and starting turns through app-server, but does not establish parity with this installed desktop session's complete tool environment. That remains an integration gate. [App-server documentation](https://learn.chatgpt.com/docs/app-server)

Non-interactive session resume is documented too, but must not be silently substituted for desktop task wake-up. [Non-interactive documentation](https://learn.chatgpt.com/docs/non-interactive-mode)

## Architecture

```text
Source PR -> canonical manager -> central SMB record
                                      |
                     local Windows worker, every minute
                                      |
                    validate / claim / journal / notify
                                      |
                         exact local destination task
                                      |
                 Accepted -> Processing -> final central state
                                      |
                 deterministic reconciliation / attention feed
```

Proposed components, owned by PR Messaging Dispatcher:

1. A short-lived scheduled worker with a machine/profile singleton lock, bounded runtime, and structured result JSON. Reconcile outstanding attempts first, then claim at most one new record per tick. Delayed destinations must not starve other destinations.
2. Conditional/idempotent claim and recovery operations in the canonical manager.
3. A narrow notification adapter using fixed validated identifiers, never executable payload text.
4. Durable per-profile attempt journal and health files outside Git under `%LOCALAPPDATA%\BuyYourHome\PRMessaging`.
5. Local Windows-task installer, version verifier, and rollback evidence. Use the intended non-administrator interactive Windows account, not the sandbox account or SYSTEM. Store no passwords in scripts.

| Worker mode | Permitted behavior |
| --- | --- |
| `shadow` | Read candidates/health; no claims, notifications, or lifecycle writes. |
| `validation` | One nonempty exact message ID, synthetic-only, one permitted attempt, no production fallback. |
| `live` | Approved local destinations, normal per-record budgets and authority. |
| `drain` | Reconcile existing attempts, no new claims or notifications. |
| `paused` | No queue processing; preserve evidence. |

Only one transport owner may claim a machine's records. Enforce a transport generation/owner through the manager so stale heartbeats/direct senders cannot race the worker. After cutover, source workflows enqueue and leave notifications to that transport. Introduce this compatibly per machine; do not break senders on unmigrated machines.

## Atomic Claim Contract

Within the existing central lock, re-read and verify:

- Exact message/dispatch ID, recomputed payload hash using existing manager serialization, source authorization, destination PR/task/machine, and expected record version or equivalent compare-and-set fields.
- Queued or retry-eligible ambiguous state; no receipt/final result; no unresolved prior attempt; remaining budget; retry delay elapsed.
- Exact local registration, current manifest readiness, accepted message type, transport owner/generation, and execution identity. Configuration drift since candidate inspection is a conflict, not permission to guess.
- Validation requires exact equality between the explicitly supplied nonempty message ID and manifest validation ID; boolean `synthetic_test: true`; explicit false business permissions. Missing, blank, malformed, wrong-host, or terminal targets return no claim and never select another record.
- Preserve synthetic-only restrictions whenever config activates legacy-authority rollback.

Generate a stable attempt ID before manager invocation. An uncertain claim result is reconciled by that ID, never by issuing another attempt blindly. Conflicts trigger re-reading, not notification from stale data. Release the central lock before Codex invocation or receipt waiting.

Hash consistency is not authorization. Trusted transport, central authority, and the receiving PR's source-ownership gates remain necessary. Never present routed task content as a newly typed Wes instruction or bypass host approval/security controls.

## Journal And Recovery

Atomically persist journal transitions before external effects. Key by machine, message ID, dispatch ID, hash, and attempt ID. Include UTC timestamps, transport generation, adapter version, and submission evidence. Central state takes precedence over local state.

| Reconciled evidence | Required behavior |
| --- | --- |
| No central attempt | No notification; conditional claim may proceed if eligible. |
| Central attempt exists; journal proves submission never began | Close `NotDelivered` through the manager; any retry consumes the existing bounded budget. |
| Submission-start marker exists; outcome unknown | Never rerun that attempt's submission. Record ambiguity and check receipts. |
| Adapter reports successful submission | Record submitted evidence; wait for exact acceptance, not presumed delivery. |
| Matching Accepted/Processing/final receipt | Stop delivery retries; reconcile delivered attempt without overwriting newer destination state. |
| No receipt by acceptance deadline | Mark `Delivery Ambiguous`; schedule same-ID retry only after reconciliation. |
| Accepted/Processing exceeds workflow deadline | Expose stalled execution to owner; do not automatically redeliver business instructions. |
| Attempt budget exhausted | Stop submissions; expose actionable transport attention; no replacement ID to reset budget. |
| Host unavailable or journal missing/corrupt | No new notification; retain evidence and classify uncertainty. Missing journal is not proof of non-delivery. |

Proposed initial settings: acceptance deadline 120 seconds; retry delays 5 minutes then 15 minutes, never exceeding the record's `max_attempts`. Reconcile on later ticks instead of sleeping inside a model turn. One-attempt synthetic records never gain extra attempts.

Keep one unaccepted submission per destination. Prove safe busy-task enqueue behavior or defer that destination and try another. Never interrupt an active user turn. Before ambiguous retries, reconcile adapter pending-message evidence too; still queued in Codex does not mean it should be submitted again.

SMB writes and Codex submission are not one atomic transaction. Promise one submission per attempt, bounded retries, and destination deduplication, not unconditional exactly-once delivery. Retain workflow duplicate searches, single-save rules, verified returns, and payment/send restrictions.

## Wake-Up Gate

Test the installed `codex queue` first, using exact UUIDs, structured argument passing, and a constant wake-up template with only validated IDs/hash and the canonical-manager pointer. Do not use task display names, `--last`, new tasks, payload-generated shell commands, secrets, or full email bodies.

Required proof on WESSTUDIO:

1. Existing idle synthetic recipient starts without a model dispatcher, manual paste, or manual wake-up.
2. Busy-task notification queues without interruption or duplicate turns.
3. Correct Windows/Codex profile, task, repository, permissions, and required tools remain available.
4. Adapter submission is distinguished from authoritative acceptance; timeout is reconcilable.
5. Normal approvals are preserved. No bypass-sandbox/approval flags.
6. App restart and reboot/login behavior are tested. Unavailable runtime reports blocked, not success.

If enqueue does not wake an idle task, stop that adapter's rollout. A separately scoped app-server adapter may be evaluated against the same exact-task, tool, concurrency, and approval gates. Do not launch a second runtime against an active task blindly. The model-only `send_message_to_thread` tool is not a callable PowerShell API.

## Health And Attention

Separate worker execution, host access, reconciliation, pending submission, acceptance, and workflow completion. A successful claim is not a completed healthy transaction.

Health fields: schema/version, expected/observed machine and Windows SID, mode, release/config hash, run timestamps, next tick, queue reachability, outstanding attempts, retry deadlines, adapter errors, last receipt, and last successful reconciliation. No secrets or payload copies.

Dashboard changes should distinguish Needs Wes decisions, system blockers, scheduled retries, stale unaccepted attempts, and stalled accepted work. Identify transactions by exact message/dispatch and explicit supersession relationships. Invoice number alone is not a safe cross-company deduplication key.

Use deterministic watchdog evaluation and local notification for a new actionable failure, with persistent dashboard visibility. Deduplicate unchanged alerts and record recovery once. Any email/SMS escalation remains subject to its owning workflow and cannot depend exclusively on the failed transport. Do not wake Email Monitor to announce empty polls.

After cutover, overnight/weekend dispatcher inactivity is no longer expected. Mailbox health retains its separate schedule. Workflow deadlines must be explicit per workflow; missing deadlines are configuration gaps, not permission to invent a universal timeout or repeat business work.

## Machine Plan

| Machine | Transport to replace | Must preserve |
| --- | --- | --- |
| WESSTUDIO | `pr-messaging-dispatcher`, task `01a06337-1b59-7dc2-9586-6660eb7b5da7` | Temporary all-hours override until actual cutover or Wes closes it. Source Email Monitor stays paused. |
| WES-VIDEOEDITOR | `pr-messaging-dispatcher-wes-videoeditor`, task `01a05d0c-8031-7d92-9474-ab2330008ddb` | SMB queue host and exact local registrations, including Quickbooks. |
| OFFICEASSIST | Embedded stage in task `01a03956-fe55-7f62-9c0a-17c18f763320` | Email Monitor automation `officeassist-morning-email-summary-and-instruction-monitor`, daily 7:45 AM-11:00 PM Eastern every 15 minutes; all summaries, cutoffs, deduplication, delivery and health. |

These are planning identities, not fresh remote attestations. Verify settings locally before changes. OFFICEASSIST gets a deterministic Windows worker, not a second Codex dispatcher heartbeat. A delivery wake-up must not become an extra mailbox scan or summary.

Rollout order:

1. Synthetic-only wake-up prototype on WESSTUDIO. Use a new exact validation record, never an old completed/failed one. No production claims.
2. Manager/worker hardening and isolated fixture/failure-injection tests.
3. WESSTUDIO shadow comparison, then validation-only canary, with explicit transport ownership for the test.
4. Capture configuration/state and in-flight inventory. Drain/reconcile, pause old transport, switch ownership generation, then validate unattended cross-machine delivery. Leave production disabled until the full gate passes.
5. Repeat on WES-VIDEOEDITOR, then OFFICEASSIST, under each intended login. Verify browser/connector readiness without business action. Email Monitor owns embedded-stage removal and unchanged memory/runtime verification.
6. Validate backlog eligibility, existing attempts, and historical/superseded exclusions. No bulk resets or historical replay. Enable normal dispatch and verify a real authorized end-to-end return.

Before each machine change, snapshot scheduler/automation configs, prompts, registrations, runtime state, health settings, and executable versions. Journals stay out of Git. Pin tested code/config hashes; fail closed on unapproved changes. Drain before a pull/deployment affecting runtime scripts; verify the complete release before resuming. Never execute half-updated shared-checkout code.

Rollback: drain and disable new claims; reconcile pending submissions; switch transport owner before restoring saved old dispatcher settings. Never run both claimers. Do not reactivate WESSTUDIO Email Monitor, remove history, reset budgets, or undo business outcomes. Ambiguous submissions block resending their records, not unrelated work.

## Acceptance Tests

| Test | Required result |
| --- | --- |
| Empty queue for 24 hours | Script checks/health updates, zero dispatcher model turns and zero destination wake-ups. |
| Unattended synthetic | Cross-machine creation, exact local claim, one submission, exact-identity Accepted/Processing/Completed. |
| Exact filter missing/blank/wrong/terminal | No fallback and no other record changed. |
| Invalid source/task/machine/hash/registration/readiness | No notification; specific diagnostic. |
| Concurrent worker or legacy/new race | One successful claim; loser never sends. |
| Crash before/after claim and submission | No permanently ignored pending attempt and no repeat submission within an attempt. |
| Late receipt or adapter timeout | Reconciliation wins; no overwrite of Accepted/Completed. |
| Busy/offline/sleep/reboot/app restart | No interruption, false delivery, or token loop; recovery under intended identity. |
| Stalled accepted work or exhausted attempts | Owner/Needs Wes visibility without automatic business replay. |
| Code/adapter version change | Fail closed until compatibility validated. |
| OFFICEASSIST regression | Schedule, summaries, cutoffs, pending deliveries and paused WESSTUDIO source preserved. |
| Rollback with ambiguity | One transport owner; no blind resend. |

## Ownership And Next Deliverable

- PR Messaging Dispatcher: worker, manager/helper, tests, transport contract and deployment evidence.
- Email Monitor: embedded-stage removal, mailbox regression and health configuration.
- Dashboard: attention views and stalled-state coverage.
- Create PR: onboarding gate requiring verified local transport, not necessarily a Codex heartbeat.
- Jean: shared-rule/registry coordination and rollout tracking. Network Roadmap/Computers: separately needed identity or host-availability work.

Reading this design does not grant permission to edit those workflows. Scoped implementation handoffs must follow the existing delegation contract.

Next deliverable: synthetic-only exact-task wake-up proof on WESSTUDIO, then implementation and failure-injection evidence. Live deployment remains gated on that proof. This design changed no live automation, manager, manifest, queue record, or business workflow.
