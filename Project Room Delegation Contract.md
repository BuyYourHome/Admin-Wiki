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

## Parties And Registry

- Jean Wright is the dispatcher for requests received in the Jean Wright chat that belong to a specialized PR.
- Each PR owns only the work described in its canonical `README.md` and matching skill, when one exists.
- `Project Rooms\Jean Wright\working\dispatcher-routing-map.md` is the live registry of the sole task/thread Jean may use for each PR.
- A `pending` task/thread id is an explicit blocker. It does not permit Jean, another PR, Dashboard, or Create PR to perform the specialized work as a substitute.

## Dispatch Contract

1. Jean first identifies whether a specialized PR owns a request. Jean retains only general Office Assistant work and unowned cross-PR coordination.
2. For specialized work, Jean assigns a stable `dispatch_id` and sends the scoped handoff only to the destination task recorded in the routing map.
3. The receiving PR must return `accepted` with the same `dispatch_id` before durable edits, external actions, or onward handoffs.
4. The receiving PR works only within its documented scope and returns `done`, `blocked`, `needs Wes`, `rejected as wrong room`, or `routed onward with approval` using the same `dispatch_id`.
5. Jean reports the returned result to Wes. A missing receipt is unresolved; Jean must not assume the work started or complete it locally.

## Direct Work

A direct request from Wes inside the actual owning PR task remains direct work for that PR. This contract governs delegation and does not require Jean to sit between Wes and the owning PR.

## Future PRs

Create PR must add the standardized Action Ownership pointer and this contract pointer to every new PR README and matching skill. A new PR is not dispatchable until its dedicated task/thread id, or an explicit task-creation blocker, is recorded in the routing map.

## Reversal

This contract and its rollout are global governance. Revert the focused governance commit if the rollout has unintended consequences; do not remove or rewrite individual PR pointers ad hoc.
