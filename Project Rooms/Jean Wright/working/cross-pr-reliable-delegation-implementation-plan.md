# Cross-PR Messaging and Reliable Delegation Plan

## Status

Implementation in progress as of 2026-08-20. The shared schema, tools, deployment package, pilot manifests, and governance pointers are being built and locally validated. Existing live dispatch traffic remains on the Email Monitor queue until the `WES-VIDEOEDITOR` host and clients pass end-to-end validation.

## Objective

Give every Project Room a reliable, observable messaging path. A request, question, status update, correction, or final result must have one durable record, a known owner, a visible delivery state, and a recoverable return path. Project Rooms learn from failures through owned correction records instead of relying on chat history or memory.

## Messaging Model

### Planned Host And Clients

- Central messaging host: `WES-VIDEOEDITOR` (`Wes-VideoEditor`).
- `WES-VIDEOEDITOR` will hold the authoritative message store, PR inboxes/outboxes, delivery history, acknowledgments, and queue-health state.
- WesStudio and every other approved computer will operate as authenticated messaging clients. PR ownership follows the Project Room, not the computer executing the work.
- A client that cannot reach `WES-VIDEOEDITOR` keeps outbound work in a local pending spool and reports it as not delivered. It must not claim acceptance or completion until the central host records the corresponding state.
- The host service must be restricted to the approved private network and registered clients. The implementation must define authentication, firewall scope, backup, restoration, and host-unavailable behavior before activation.
- Live message records remain outside Git. Git contains only schemas, client/host code, configuration templates, and durable governance documentation.

### One Durable Message Record

- Every inter-PR message receives a stable `message_id`; a work request also receives a stable `dispatch_id`.
- The record stores sender PR/task, destination PR/task, message type, authorization, references, immutable payload hash, timestamps, delivery attempts, current owner, and the full state history.
- The durable record is authoritative. Chat/task messages are only notifications that a message is waiting.
- A corrected request creates a linked successor record; it never silently overwrites the original request.

### Standard Message Types

- `request`: asks the owning PR to perform work.
- `question`: asks another PR for bounded clarification or source context.
- `status`: reports meaningful progress, delay, or a changed blocker.
- `decision`: asks Wes for the smallest needed choice.
- `result`: returns `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
- `improvement`: records a failure, ambiguity, workaround, or missing rule that requires correction.

### Standard Conversation States

`Queued` -> `Delivery Attempted` -> `Accepted` -> `Processing` -> one final state: `Completed`, `Blocked`, `Needs Wes`, or `Rejected as Wrong Room`.

`Delivery Ambiguous` means the receiving task may or may not have been notified. It must be reconciled against the durable record before the same message is retried. A missing task/thread id remains a blocker, never authority for local execution.

### Responsibilities

- The sending PR creates the durable record before any task notification and watches for the required receipt.
- The receiving PR reads its inbox, verifies the target and payload hash, writes `Accepted` before substantive work, posts meaningful status updates, and writes exactly one final result.
- Jean routes, monitors, and reconciles messages but does not perform a specialized PR's work.
- The owning PR may delegate a sub-action only to another registered owning PR, preserving the parent message and return path.
- Dashboard presents truthful counts and attention states, not message bodies or sensitive sources.

## Implementation Steps

1. Define the shared message envelope and state machine.
   Specify the stable identifiers, message types, authorization/reference fields, payload hashing, parent/successor links, timestamps, ownership, attempt history, status updates, and final result format.

2. Establish the durable PR message bus on `WES-VIDEOEDITOR` outside Git.
   Give each PR an inbox and outbox within the central host store. Install a client on every approved computer, with a local pending spool for temporary host outages. Keep live messages and source references out of Git; keep schemas, templates, host/client code, and operational rules in the Admin Wiki.

3. Update the central delegation contract.
   Require the durable record before notification; require acceptance before work; define reconciliation, retries, corrections, and all valid return states. Make clear that task chat is a notification channel, not the transport.

4. Implement one standard PR messaging adapter.
   The adapter must support send, receive, acknowledge, progress update, result, correction, retry, deduplication, and inbox reconciliation. Every PR uses this common adapter rather than custom messaging code.

5. Add a PR capability and contact manifest.
   Each PR declares its task/thread id, owned actions, accepted message types, required approvals, inputs/outputs, related PRs, Teams locations, and known limitations. Jean uses it for routing; Dashboard uses it for truthful status.

6. Update Jean Dispatcher as the message coordinator.
   Jean validates the owner and manifest, creates the durable request, sends the wake-up notice, watches for acceptance, reconciles ambiguity, and relays only verified outcomes to Wes.

7. Give every PR a work inbox and return queue.
   A PR must surface new requests, messages awaiting acceptance, active work, waiting-on-other-PR messages, and final returns. It must not rely on unread chat turns as its source of truth.

8. Create the correction and learning queue.
   Any failed delivery, unclear ownership, missing source, repeated question, unsupported tool, or workaround becomes an `improvement` message. The owning PR records the proposed correction, validation result, and whether Wes approval is needed. Shared problems route to global governance review.

9. Add queue and conversation health checks.
   Detect unaccepted messages, stale processing, missing final returns, repeated delivery ambiguity, task/runtime failures, and blocked corrections. Notify Wes only when attention or a decision is needed.

10. Add Dashboard messaging visibility.
    Show per-PR inbox/outbox counts, oldest waiting message, current blocker, approval-needed state, health, and last verified contact. Keep detailed contents, sources, and private data out of the shared view.

11. Run a controlled messaging pilot.
    Start with Jean Wright, Email Monitor, Invoice Entry, Doc Scan, and Marketplace. Test request, question, correction, timeout, duplicate delivery, task failure, status update, approval pause, retry, and final-return paths.

12. Expand to every remaining Project Room.
    Add the common adapter and manifest, validate the task identity and inbox/return path, migrate open work safely, and only then retire any legacy one-off messaging pattern.

## Estimated Effort

- First working messaging pilot for Jean Wright, Email Monitor, Invoice Entry, Doc Scan, and Marketplace: 7-10 unattended hours.
- Full all-PR rollout, Dashboard status, testing, documentation, and correction workflow: 20-32 unattended hours, likely across 3-4 work sessions.

## Preconditions Before Starting

- Wes explicitly authorizes implementation.
- `WES-VIDEOEDITOR` is online, reachable from each approved client over the private network, and has a stable host address or resolvable hostname.
- Host authentication, client registration, firewall scope, service startup, backup, restore, and outage behavior are approved and tested before live PR traffic is migrated.
- Current task-message bridge and project/task registrations are checked.
- Existing live dispatch records, active work, and current task-message dependencies are inventoried before schema or runtime changes.
- A rollback point and restoration instructions are documented before changing any automation or shared routing rule.

## Success Criteria

- No inter-PR request, question, update, correction, or result can disappear because a task message times out.
- Jean and the owning PR can determine, from durable state, who owns the next action and whether every message is queued, accepted, active, waiting, blocked, or complete.
- Every PR exposes its owned capabilities, task identity, and messaging readiness in a standard manifest.
- Repeated failures produce a visible, owned correction item with a validation outcome.
- Dashboard reports message-queue health accurately without exposing sensitive work details.
