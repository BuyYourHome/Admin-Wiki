# Dashboard Project Room Deletion Workflow

## Purpose

Define the future execution contract behind Dashboard's local deletion-review interface. The current Dashboard may record a structured deletion request for `Create PR`, but it still must not delete any resource itself.

## Scope

Each plan is limited to the exact selected Project Room, its canonical folder, its documented matching skill when that source exists, and its documented task/chat when one is recorded. The Dashboard card is derived from the Project Room folder and disappears only after an authorized folder deletion followed by a Dashboard refresh.

The workflow must not infer or add registry entries, automations, installed skill copies, Teams files, external files, sibling Project Rooms, or unrelated chats to the deletion scope.

## Current Delegated Request Path

1. Dashboard shows the exact selected Project Room and resource manifest in one confirmation dialog.
2. The full local Dashboard host may record a structured deletion request in the shared Dashboard action-request store `C:\Codex\Wiki Files\Project Rooms\Dashboard\working\tmp\dashboard-action-requests.json`.
3. The active Dashboard Codex task performs the actual task-message send to `Create PR` and writes the returned status back to that same shared runtime state.
4. WesStudio may also record that same request while using the LAN URL locally, but remote LAN-host views may only inspect the recorded request and its returned status.
5. A recorded request is not deletion by itself. It is a delegated request record, status surface, and, for the exact Dashboard-to-Create-PR deletion authorization class documented in `C:\Codex\Wiki Files\Project Room Delegation Contract.md`, the carrier of Wes's already-captured confirmation.

## Future Execution Gate

1. Display the exact selected Project Room and its resource manifest in one confirmation dialog. Wes's single explicit confirmation is required; name typing is not required.
2. Create a durable audit entry in `C:\Codex\Wiki Files\Project Rooms\Dashboard\working\project-room-deletion-log.md` before any destructive action. Record the plan timestamp, Wes confirmation, every resource, planned order, outcome, and any blocker.
3. Verify the Project Room folder and matching skill path immediately before execution.
4. Verify the documented task/chat has a supported delete capability. The currently available Codex task operation is archive, not delete. Do not silently archive a task as a substitute for deletion; stop and require Wes's separate authorization or a supported deletion capability.
5. If the action is being executed from the delegated Dashboard authorization class, verify that the request satisfies the exact-scope conditions documented in `C:\Codex\Wiki Files\Project Room Delegation Contract.md` and `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`.
6. If any included resource is unavailable, unresolved, or lacks a supported delete path, stop before changing any resource. Report the exact blocker. Do not perform partial deletion.
7. When every included resource is resolvable and Wes has authorized the executable scope, delete only the selected Project Room, documented matching skill, and documented task/chat. Refresh the Dashboard so the derived card disappears.
8. Append final results to the audit log outside the deleted Project Room. Commit the scoped deletion record and Dashboard refresh update separately from unrelated work; push only under the Admin wiki rules.

## Lessons Learned

- A delegated deletion is not visually complete in Dashboard until the generated site data is refreshed. Folder deletion alone does not remove the card from `site\project-rooms.js`.
- `config\project-room-groups.json` does not auto-prune deleted room assignments. Remove stale room keys when a Project Room is deleted so Dashboard-owned metadata stays clean.
- The Dashboard bridge depends on a healthy target PR task. If the canonical destination task is unhealthy, reroute every canonical thread-id reference together before treating the bridge as repaired.
- The returned request status in Dashboard's shared action-request store is operational state, not optional polish. If `Create PR` returns `done`, mirror that terminal status back into the Dashboard runtime store so the side panel and deletion dialog stay truthful.
- On this machine, direct script invocation can fail under the local PowerShell execution policy. The documented `powershell.exe -ExecutionPolicy Bypass -File ...` path is the reliable refresh path when a normal shell invocation is blocked.

## Dashboard Self-Protection

Dashboard must not delete itself from its own interface. Its deletion would remove the local interface and its audit log. A separate explicitly authorized Admin workflow is required for any future Dashboard removal.
