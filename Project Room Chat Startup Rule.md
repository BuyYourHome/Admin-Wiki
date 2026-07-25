# Project Room Chat Startup Rule

Use this rule whenever Wes asks to create, move, fork, or resume a chat for a Buy Your Home Project Room.

## Canonical Working Folder

Every Project Room chat must work from:

```text
C:\Codex\Wiki Files
```

The Codex app may create a new chat with a different default folder. The chat must self-correct before doing file work.

## Required Startup Text

Any new Project Room chat-start prompt should include this instruction block:

```text
Work only from the canonical Admin wiki Git repository:
C:\Codex\Wiki Files

Before doing file work, verify the default folder with Get-Location.
If the session default is not C:\Codex\Wiki Files, still use C:\Codex\Wiki Files explicitly as the workdir for every shell command and use absolute paths under C:\Codex\Wiki Files for all file reads and edits.

If any tool would use a relative path, stop and convert it to an absolute path under C:\Codex\Wiki Files first.

First, read:
- C:\Codex\Wiki Files\Admin Home.md
- C:\Codex\Wiki Files\AGENTS.md
- C:\Codex\Wiki Files\Repository Location Rule.md
- C:\Codex\Wiki Files\Project Room Workflow.md
- C:\Codex\Wiki Files\Project Room Chat Startup Rule.md
- C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md
- C:\Codex\Wiki Files\Agent Unit Standard.md
- the Project Room README.md for the room being used
- the matching skill source under C:\Codex\Wiki Files\skills, when one exists
```

## Start PR Mode

Use Start PR Mode when Wes says `Start PR`, asks to begin or resume work in a Project Room chat, or asks a PR-scoped question that depends on current room rules.

Start PR Mode is the central refresh contract for PR chats. It should be referenced briefly by each PR README and matching skill instead of copied in full.

Steps:

1. Verify the default folder with `Get-Location`.
2. Use `C:\Codex\Wiki Files` as the explicit workdir for shell commands and absolute file paths.
3. Confirm the working branch is `main`; switch to `main` only when safe.
4. Read only the central startup rule, the Project Room file ownership and Git coordination rule, the current PR README file, and the current PR's matching skill source when one exists.
5. Read root rules needed for the request: `AGENTS.md`, `Repository Location Rule.md`, `Project Room Workflow.md`, `Agent Unit Standard.md`, and `Git Work Scope Rule.md`.
6. Do not read every Project Room, every skill, or unrelated workflow files merely because Start PR Mode was triggered.
7. If unrelated dirty files, Git processes, lock files, or branch conflicts block switching to `main` or checking status, report the blocker and do not force, stash, reset, delete, or move files.
8. Report the active repo path, active branch, current PR, and any blockers before durable file work.

## Current PR Scope Rule

In a PR-dedicated chat, interpret unqualified requests as scoped to the current PR.

- If Wes asks about `modes`, `rules`, `files`, `status`, `open issues`, or similar without saying otherwise, answer for the current PR only.
- Do not expand to all PRs, the whole wiki, or global rules unless Wes says `all`, `global`, `across PRs`, `anywhere`, `in the wiki`, or equivalent.
- If the request clearly belongs to another existing PR or specialized skill, say that briefly and ask whether to route the work there unless an existing rule already authorizes the handoff.
- If ownership is unclear and the action would create files, change rules, create chats, commit, push, send messages, or affect another PR, ask before acting.
- Keep central rules lightweight. Do not create circular read chains; read the current PR README and skill, not every related room.
- Follow `Project Room File Ownership And Git Coordination Rule.md` before editing files, committing, pulling, or pushing.
- Broad cleanup, alignment, or standardization requests do not authorize moving, renaming, deleting, or editing existing Project Room folders or project-specific skill folders. Follow the explicit rename/move authorization rule before proposing or making those changes.

## Jean Dispatcher Rule

Use this rule when Wes gives Jean Wright / Office Assistant a request that belongs to a specialized Project Room, or when Wes asks Jean to coordinate work across Project Rooms.

Jean is the dispatcher, not the owner of specialized PR work. Jean may classify the request, identify the likely owning Project Room, prepare a handoff, and send or queue that handoff through available Codex task tools when a dedicated task id is known. Jean must not perform durable edits inside another PR's files unless Wes explicitly authorizes that cross-PR edit or the work is a Wes-authorized global governance update.

Before routing:

1. Read Jean's routing map at `C:\Codex\Wiki Files\Project Rooms\Jean Wright\working\dispatcher-routing-map.md`.
2. Confirm whether the destination PR has a known task/thread id.
3. Assign a stable `dispatch_id` in this format: `jean-dispatch-YYYYMMDD-<short-topic>-vN`.
4. Decide whether the handoff is:
   - `route-and-return`: Jean sends the handoff and reports that the destination PR owns the work.
   - `route-and-monitor`: Jean sends the handoff and watches for a completion or blocker response because Wes asked Jean to monitor.
   - `multi-pr-bundle`: Jean splits the request into clearly scoped handoffs for more than one PR.
5. Do not create a new task, rename a task, move a PR, edit another PR's skill, or change automation settings unless Wes explicitly authorizes that exact action.

Handoff package:

```text
Dispatch id:
From PR: Jean Wright
Destination PR:
Destination task/thread id:
Requested action:
Authorizing Wes instruction:
Source paths or message ids:
Output expected:
Files or systems that must not be touched:
Email/Teams/connector authority, if any:
Return instruction:
```

Jean should record sent handoffs in `C:\Codex\Wiki Files\Project Rooms\Jean Wright\working\dispatcher-action-log.md` when the handoff is durable, cross-PR, involves email/delivery, changes files, or may need follow-up.

## Dispatcher Intake And Return Rule

Every PR that receives a Jean handoff must treat the handoff as scoped intake, not as permission to edit other PRs.

On intake, the destination PR should:

1. Read its own README, matching skill, and this startup rule.
2. Confirm the `dispatch_id`, requested action, source paths or message ids, and any explicit Wes authorization.
3. Accept the handoff only if it belongs to that PR's scope.
4. Reject or return the handoff if it belongs to another PR or would require unauthorized cross-PR edits.
5. Use Email Monitor's Email Delivery mode for outbound email when its rules require centralized OfficeAssist delivery.
6. Keep work on `main` unless Wes explicitly asks for a branch.
7. Keep commits scoped to the accepted handoff and leave unrelated dirty work alone.

Return one of these statuses to Jean or Wes:

- `accepted`: the PR owns the work and has started or queued it.
- `done`: work is complete; include changed files, commit id, push status, and delivery verification when any.
- `blocked`: work cannot continue; include the blocker and the next decision needed.
- `needs Wes`: a decision, approval, source, credential, or connector action is needed.
- `rejected as wrong room`: the work belongs elsewhere; name the likely owning PR when known.
- `routed onward with approval`: Wes explicitly authorized routing to another PR or system.

If a PR uses `working\work-status.md`, update it for substantial routed work. Do not create or update work-status files merely for quiet checks or trivial questions.

## Chat Creation Rule

When creating a new Project Room chat:

0. Create a new chat only when Wes explicitly asks or when no existing chat should own the work.
1. Name the chat after the Project Room unless Wes gives another name.
2. Include the required startup text above.
3. Include the Project Room path, matching skill path, and any automation id or thread id that belongs to the room.
4. Do not point the chat to the Teams-synced wiki folder.
5. Do not copy files to Teams merely because a chat was created. Teams receives final deliverables only when Wes explicitly asks or an established workflow says so.

## Relative Path Rule

If a Project Room chat starts outside `C:\Codex\Wiki Files`, it may still proceed only when every file operation uses:

- `C:\Codex\Wiki Files` as shell `workdir`, and
- absolute paths under `C:\Codex\Wiki Files`.

Do not use relative paths from a non-canonical default folder.

## Handoff Rule

When moving work into a new Project Room chat, include the current status, open decisions, relevant source paths, output paths, matching skill, and any connector or automation limitations. Do not assume the new chat will have remembered prior context unless the handoff states it directly.

## Branch Rule

Project Room work uses `main` by default. Do not create a new Git branch for a Project Room unless Wes explicitly asks for one.

## PR README And Skill Pointer

Each PR README and matching workflow skill should include a short pointer rather than copying this full rule:

```text
Start PR: Before durable work, follow Start PR Mode in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.
```
