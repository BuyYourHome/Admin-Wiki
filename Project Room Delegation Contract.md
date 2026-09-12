# Project Room Delegation Contract

This is the universal delegation contract between Jean Wright / Office Assistant and every Buy Your Home Project Room (PR).

## Action Ownership And Delegation Rule

This rule applies to every existing and future PR, whether a request arrives from Wes, Jean, Dashboard, another PR, an automation, or another intake surface.

1. Each PR owns only its documented files, actions, and workflow responsibilities.
2. When a requested action belongs to the current PR, that PR may perform it under its own documented rules.
3. When a requested action belongs to another PR, the current PR must not perform it locally. It must delegate the action to the owning PR's registered task/thread.
4. A missing, pending, or unavailable owning task/thread id is a blocker. It never permits local substitution, a new substitute task, or an undocumented cross-PR execution exception.
5. Dashboard and other non-owning PRs may gather requests, prepare manifests, display status, or identify the owning workflow. They may not execute an action owned by another PR.
6. The receiving PR may reject a handoff that is outside its documented scope. It must not treat the handoff as permission to execute another PR's work.

## Standard Return States

For delegated action work, valid return states remain `accepted`, `done`, `blocked`, `needs Wes`, and `rejected as wrong room`. Preserve the same `dispatch_id` throughout the handoff and return.

## Delegated Authorization Classes

Some delegated requests may carry Wes authorization for one exact action class when that class is documented centrally and by the owning workflow. This is not a general delegation exception.

Current approved delegated authorization class:

- `Dashboard` exact-scope Project Room deletion request to `Create PR`

For a delegated request to count as Wes authorization, every condition below must be true:

1. The request comes from a documented intake surface that is allowed to collect one explicit confirmation from Wes for that action class.
2. The request type and owning PR match a documented delegated authorization class.
3. The request identifies the exact scope and exact resources to be changed.
4. The request record states that Dashboard or the other approved surface already captured Wes's explicit confirmation for that exact scoped action.
5. The receiving PR can execute the request without guessing, broadening scope, substituting a different action, or pulling in undocumented resources.

When every condition is true, the receiving PR may treat that delegated request as Wes authorization for that exact scoped action and does not need to stop merely to ask Wes the same confirmation again.

This exception does not permit:

- broader workflow changes,
- undocumented cross-PR execution,
- partial deletion when one included resource is unresolved,
- substituting archive for delete or delete for archive without that exact authorization,
- ignoring any other blocker unrelated to the repeated-confirmation question.

If any condition fails, the receiving PR must return `blocked` or `needs Wes` truthfully.

## Parties And Registry

- Jean Wright is the dispatcher for requests received in the Jean Wright chat that belong to a specialized PR.
- Each PR owns only the work described in its canonical `README.md` and matching skill, when one exists.
- `Project Rooms\Jean Wright\working\dispatcher-routing-map.md` is the live registry of the sole task/thread Jean may use for each PR.
- A `pending` task/thread id is an explicit blocker. It does not permit Jean, another PR, Dashboard, or Create PR to perform the specialized work as a substitute.

## Dispatch Contract

1. Jean first identifies whether a specialized PR owns a request. Jean retains only general Office Assistant work and unowned cross-PR coordination.
2. For specialized work, Jean assigns a stable `dispatch_id` and writes an immutable durable message on the shared Project Room messaging host before task notification, unless an owning workflow documents an equivalent durable queue.
3. Jean sends the scoped handoff only to the destination task recorded in the routing map. Task messaging is a best-effort wake-up signal, not the authoritative copy.
4. The receiving PR must write `accepted` with the same `dispatch_id` to the durable record before durable edits, external actions, or onward handoffs. It should also return `accepted: <dispatch_id>` in the task when available.
5. The receiving PR deduplicates by dispatch ID and payload hash, works only within its documented scope, and writes `Processing`, then `Completed` or `Failed`, while returning the applicable standard status with the same dispatch ID.
6. A send timeout or busy destination is `Delivery Ambiguous`, not proof of delivery. Reconcile the durable record and destination history before retrying. Retry the same immutable dispatch only when the destination is idle, the ID is absent, and the bounded attempt limit permits it.
7. Jean reports the returned result to Wes. A missing receipt is unresolved; Jean must not assume the work started or complete it locally. When the owning workflow requires email escalation, send and verify that notice independently of task-message delivery.

## Completion Ownership And Route-And-Monitor

- Choose the completion owner before sending a handoff. The completion owner is the PR that remains responsible for the final outcome Wes requested, including integrating a returned result, completing remaining authorized steps, and reporting the verified outcome.
- Use `route-and-return` only when the destination PR owns the final requested outcome and the source PR has no remaining integration, verification, or reporting obligation.
- Use `route-and-monitor` whenever the source PR remains the completion owner. Wes does not need to request monitoring separately.
- Before the source PR suspends for a destination result, it must preserve a durable waiting state containing the parent dispatch id, child message id, destination PR and task, expected return, resume condition, and next authorized source action. Waiting for a genuine external result is not `Needs Wes` and must not ask Wes to type `go`, `continue`, or `finish`.
- The destination writes the child message's final central state. When the source remains the completion owner, the destination must also create exactly one immutable `result` message addressed to the source PR's registered task, linked through `parent_message_id` and carrying the original dispatch id or an unambiguous correlated return id. The result payload contains only the outcome, evidence references, remaining blocker or decision, and whether any external action occurred.
- The result message uses the normal central queue and machine-local dispatcher. It is a wake-up signal for the source PR, not new authorization and not permission to repeat a completed or ambiguous external action.
- On receipt, the source PR verifies the linked message identity and payload hash, reconciles the destination's final state, resumes the recorded next authorized action, and closes or updates the parent workflow. A status question or context compaction does not cancel this responsibility.
- If the source has no dispatchable registered task, the destination cannot create a safe automatic return. Record that exact infrastructure blocker rather than treating a manual user wake-up as the normal design.

## Durable Queue Standard

- Shared queue: `\\WES-VIDEOEDITOR\BYH-PRMessaging$\records`.
- Shared tool: `C:\Codex\Wiki Files\tools\pr-messaging\Manage-ProjectRoomMessage.ps1`.
- Standard states: `Pending Host`, `Queued`, `Delivery Attempted`, `Delivery Ambiguous`, `Accepted`, `Processing`, `Completed`, `Blocked`, `Needs Wes`, and `Rejected as Wrong Room`.
- A duplicate dispatch ID with identical content is idempotent. The same ID with different content is a blocker.
- Operational queue records remain outside Git. Canonical tools and rules remain in the Admin wiki.
- The former Email Monitor queue is preserved read-only as legacy history. Do not create new records there after the 2026-08-21 cutover.

## Shared Multi-Machine Messaging

- Follow `C:\Codex\Wiki Files\Project Room Messaging Rule.md` for the `WES-VIDEOEDITOR` shared host, standard message types, cross-machine locking, offline spooling, correction messages, and PR manifests.
- Host transport, automatic task wake-up, acceptance, final return, offline spool, locking, correction, wrong-room, blocked, and Needs Wes behavior were validated before production cutover.
- The former Email Monitor queue contained 16 completed records, no unresolved states, and no duplicate IDs or hashes at cutover. Preserve those records without replaying or copying them.

## Direct Work

A direct request from Wes inside the actual owning PR task remains direct work for that PR. This contract governs delegation and does not require Jean to sit between Wes and the owning PR.

## Future PRs

Create PR must add the standardized Action Ownership pointer and this contract pointer to every new PR README and matching skill. A new PR is not dispatchable until its dedicated task/thread id, or an explicit task-creation blocker, is recorded in the routing map.

## Reversal

This contract and its rollout are global governance. Revert the focused governance commit if the rollout has unintended consequences; do not remove or rewrite individual PR pointers ad hoc.
