# Dashboard Bridge Test Spec

Date: 2026-08-05

## Purpose

Prove whether the Dashboard host can reliably deliver one structured request to another Codex Project Room task and receive a truthful return status back without browser deep links, popups, or manual paste steps.

Do not build a general action queue, PR deletion workflow, or other delegated Dashboard actions until this bridge test passes.

## Test Scope

Source PR:

- `Dashboard`
- Task/thread id: `019fc52f-858a-72e1-926b-a0f6fbf0fd89`

Target PR:

- `Create PR`
- Task/thread id: `019f583e-7f14-7ae2-aa24-4e991544e306`

Test action type:

- `bridge-test`

This is a transport proof only. It is not a deletion request and must not create, rename, move, delete, or standardize any Project Room.

## Goal

Demonstrate all of the following in one end-to-end test:

1. Dashboard creates one structured outbound request.
2. The host-side bridge delivers that request to the exact `Create PR` task/thread id.
3. `Create PR` can return one truthful status to the bridge using the standard status vocabulary.
4. Dashboard can display the returned status and message for the originating request id.
5. The request is not duplicated by refreshes or retries once a terminal result is recorded.

## Required Transport Properties

The bridge must:

- be host-side, not browser deep-link based
- avoid custom-protocol popups
- avoid manual clipboard paste
- target one exact Codex task/thread id
- record one stable request id
- record send time, receive time, and returned status
- dedupe retries by request id

## Required Return Statuses

The bridge test must support these returned states:

- `accepted`
- `done`
- `blocked`
- `needs Wes`
- `rejected as wrong room`

For the first bridge test, `accepted` or `done` is sufficient to prove the path works.

## Canonical Test Payload

Use this exact semantic payload shape, even if the final wire format differs:

```json
{
  "request_id": "dashboard-bridge-test-YYYYMMDD-HHMMSS",
  "request_type": "bridge-test",
  "created_at": "UTC timestamp",
  "source_pr": "Dashboard",
  "source_thread_id": "019fc52f-858a-72e1-926b-a0f6fbf0fd89",
  "target_pr": "Create PR",
  "target_thread_id": "019f583e-7f14-7ae2-aa24-4e991544e306",
  "requested_by": "Wes",
  "requested_action": "Acknowledge this bridge test and return accepted or done without performing any PR creation or deletion.",
  "notes": "Transport proof only. No filesystem or governance action is authorized by this test."
}
```

## Expected Target Behavior

`Create PR` should reply with the same `request_id` and one of the standard statuses. The minimum successful reply is:

```text
accepted
request_id: <same request id>
message: Create PR received the Dashboard bridge test.
```

or:

```text
done
request_id: <same request id>
message: Bridge delivery and reply path verified.
```

The target must not treat the test as authorization to perform PR work.

## Dashboard-Side Evidence Required

Dashboard should be able to show:

- request id
- target PR
- target thread id
- delivery attempt timestamp
- current status
- returned message
- terminal timestamp when complete

Minimum proof of success:

- the request appears in Dashboard with a non-local status from `Create PR`
- the returned status references the same request id

## Failure Conditions

The bridge test fails if any of these occur:

- the request cannot be targeted to the exact `Create PR` thread id
- the bridge depends on a browser popup or manual paste
- the request is sent more than once for the same request id
- Dashboard cannot distinguish `sent` from `accepted`
- Dashboard cannot record the returned status
- the bridge requires editing another PR's files as a substitute for delivery

## Implementation Boundary

Allowed for the bridge test:

- Dashboard-owned local host code
- Dashboard-owned local status files or logs
- transport-specific message formatting
- read-only use of canonical task/thread ids

Not allowed for the bridge test:

- deleting a Project Room
- editing `Create PR` files merely to fake a result
- building the full action queue before the bridge works
- treating a missing bridge capability as success

## Decision Gate

Proceed to general delegated Dashboard actions only after this bridge test is proven end-to-end.

If the bridge test fails, stop the delegated-action architecture and redesign transport before adding queue UX or execution logic.
