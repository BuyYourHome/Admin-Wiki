# Dashboard Project Room Deletion Workflow

## Purpose

Define the future execution contract behind Dashboard's local deletion-review interface. The current Dashboard only creates a deletion plan and must not delete any resource.

## Scope

Each plan is limited to the exact selected Project Room, its canonical folder, its documented matching skill when that source exists, and its documented task/chat when one is recorded. The Dashboard card is derived from the Project Room folder and disappears only after an authorized folder deletion followed by a Dashboard refresh.

The workflow must not infer or add registry entries, automations, installed skill copies, Teams files, external files, sibling Project Rooms, or unrelated chats to the deletion scope.

## Future Execution Gate

1. Display the exact selected Project Room and its resource manifest in one confirmation dialog. Wes's single explicit confirmation is required; name typing is not required.
2. Create a durable audit entry in `C:\Codex\Wiki Files\Project Rooms\Dashboard\working\project-room-deletion-log.md` before any destructive action. Record the plan timestamp, Wes confirmation, every resource, planned order, outcome, and any blocker.
3. Verify the Project Room folder and matching skill path immediately before execution.
4. Verify the documented task/chat has a supported delete capability. The currently available Codex task operation is archive, not delete. Do not silently archive a task as a substitute for deletion; stop and require Wes's separate authorization or a supported deletion capability.
5. If any included resource is unavailable, unresolved, or lacks a supported delete path, stop before changing any resource. Report the exact blocker. Do not perform partial deletion.
6. When every included resource is resolvable and Wes has authorized the executable scope, delete only the selected Project Room, documented matching skill, and documented task/chat. Refresh the Dashboard so the derived card disappears.
7. Append final results to the audit log outside the deleted Project Room. Commit the scoped deletion record and Dashboard refresh update separately from unrelated work; push only under the Admin wiki rules.

## Dashboard Self-Protection

Dashboard must not delete itself from its own interface. Its deletion would remove the local interface and its audit log. A separate explicitly authorized Admin workflow is required for any future Dashboard removal.
