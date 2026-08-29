# Create PR Project Room

## Purpose

This Project Room defines the repeatable workflow for creating a new Buy Your Home Project Room, matching Codex skill, and dedicated startup chat.

Use this room when Wes asks to create a new PR, Project Room, room-specific skill, or room-specific chat for a recurring body of work.

## Scope

In scope:

- New Project Room setup under `C:\Codex\Wiki Files\Project Rooms\<Project Name>`.
- Matching wiki-managed skill setup under `C:\Codex\Wiki Files\skills\<skill-name>`.
- Startup prompt or handoff text for a new Codex chat.
- Registry updates in `Agents and Automations Registry.md` when the new room is agent-like or repeatable.
- Links from `Admin Home.md` when the room should be visible from the Admin wiki start page.

Out of scope:

- Creating Teams folders unless Wes explicitly asks for a final deliverable there.
- Moving, renaming, deleting, or editing any existing Project Room folder or project-specific skill folder unless Wes answers yes to the exact proposed change under `Project Room File Ownership And Git Coordination Rule.md`.
- Creating automations unless Wes explicitly asks for a scheduled or event-triggered runner.
- Publishing or pushing unrelated dirty work.

## Folder Map

- `sources\` - examples, source notes, or prior room-creation instructions.
- `working\source-inventory.md` - inventory of source rules and examples used to build PR setup instructions.
- `working\duplicate-and-conflict-log.md` - conflicting or superseded room-creation rules.
- `working\missing-context.md` - open decisions about room, skill, chat, Git handling, or automation setup.
- `outputs\` - review-ready startup prompts, checklists, or templates for future PR creation.

## Current Status

Status: active.

This room was created to hold the standard Create PR process.

## Matching Skill

- Skill source: `C:\Codex\Wiki Files\skills\create-pr\SKILL.md`

## Dedicated Chat

- Chat name: `Create PR`
- Thread id: `019fdc5e-a1da-7e10-b388-a3be3830ac89`
- Purpose: continue developing and using this Project Room creation workflow.

## Messaging Readiness

- Dispatchable: Yes
- Destination manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\create-pr.json`
- Execution machine: `WESSTUDIO`
- Exact machine registration: verified for task `019fdc5e-a1da-7e10-b388-a3be3830ac89`
- Host access: verified to `\\WES-VIDEOEDITOR\BYH-PRMessaging$`
- Synthetic lifecycle: `prmsg-create-pr-readiness-validation-20260829-1726` completed after exactly one notification with Accepted, Processing, and Completed under the exact destination identity.

## Main And Push

- Working branch: `main`
- Before durable file work, confirm the repo is `C:\Codex\Wiki Files` and switch to `main` when safe.
- Do not create a new Git branch for a new PR unless Wes explicitly asks for a branch.
- If Git processes, lock files, or unrelated dirty files block switching to `main`, report the blocker instead of forcing, stashing, resetting, or deleting files.
- Follow `Project Room File Ownership And Git Coordination Rule.md` for PR file ownership, shared Admin file edits, cross-PR edits, fetch/pull safety, and push safety.
- When Wes says `Push` in this PR, commit only the Create PR room, matching skill, and directly related registry/index changes.

## Start PR Pointer

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Main Branch Rule

When creating a new PR, work from `main`.

1. Check `git status --short --branch`.
2. If the repo is not on `main`, switch to `main` only when the worktree is clean or the dirty files are clearly part of the current scoped setup and can safely move with the branch.
3. If unrelated dirty work, Git locks, or branch conflicts block switching to `main`, stop and report the blocker. Do not force, stash, reset, delete, or carry unrelated work into the new PR.
4. Create the Project Room, skill, registry, and index files on `main`.
5. Treat a request to create a new PR as authorization to provide its dedicated chat. Reuse a verified existing matching chat when one already owns the work; otherwise create one after the local PR package is committed.

## Dedicated Chat Connector Rule

Every new PR requires a dedicated Codex task. A request to create the PR includes authorization for this task-creation attempt; Wes does not need to request the chat separately.

1. Create and commit the Project Room files, matching skill, registry entry, and Admin Home link first.
2. Try the Codex app task-creation connector once.
3. If the connector does not return promptly or does not return a usable thread id, stop waiting on the connector.
4. Leave the README and registry `Thread id` as `pending until the dedicated chat is created`.
5. Report that the local PR package is complete and the dedicated task creation is pending because the connector did not return.
6. Do not let task creation block the whole PR setup, and do not retry indefinitely in the same turn.
7. When the connector later succeeds, record the returned thread id in the PR README and registry, then commit that small metadata update separately.

## Mandatory Messaging Readiness Gate

Every generated Project Room package must contain a `## Messaging Readiness` section in its README and matching skill. A new room starts as `Pending messaging registration - not dispatchable`.

Create PR must complete this checklist after the dedicated task is created:

1. Record the exact task id in the Project Room README, `Agents and Automations Registry.md`, and `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`.
2. Create `config\pr-messaging-manifests\<skill-name>.json` with `dispatchable` set to `false`, the exact task id, and the exact execution machine.
3. On that execution machine, register the exact Project Room/task identity with `tools\pr-messaging\Register-ProjectRoomMessagingClient.ps1` under the normal Windows profile that runs Codex.
4. Verify authenticated access to `\\WES-VIDEOEDITOR\BYH-PRMessaging$` with the canonical message tool.
5. Create an immutable synthetic validation message with `Manage-ProjectRoomMessage.ps1`, write `StartAttempt` before exactly one task notification, and require `Accepted`, `Processing`, and `Completed` under the exact destination identity.
6. Record the validation message id and timestamps in the destination manifest.
7. Run `tools\pr-messaging\Test-ProjectRoomMessagingReadiness.ps1` on the exact execution machine.
8. Change `dispatchable` to `true` and mark `Dispatchable: Yes` only after the validator returns `ready: true`.

If any check fails, keep the README, registry, routing map, manifest, and setup report marked `Pending messaging registration - not dispatchable`. Do not substitute a task or machine, store credentials in Git, or change an existing machine registration merely to make an audit pass.

## Delegated Dashboard Deletion Authorization

`Create PR` may treat a Dashboard delegated deletion request as Wes authorization for one exact deletion action class when the request satisfies the central delegated authorization rule in `C:\Codex\Wiki Files\Project Room Delegation Contract.md`.

Required conditions:

1. The request source is `Dashboard`.
2. The request type is the Dashboard exact-scope Project Room deletion class.
3. The request identifies the exact Project Room path and any exact matching skill or documented task/chat in scope.
4. The request states that Dashboard already captured Wes's explicit confirmation for that exact scoped deletion action.
5. `Create PR` can execute the request without guessing, broadening scope, substituting archive for delete, or performing partial deletion.

When every condition is true, `Create PR` should not stop merely to ask Wes the same confirmation again. It should either proceed under the owning workflow rules or return a different truthful blocker if one remains.

## Mode Documentation Standard

Use this standard when documenting Project Room modes in READMEs, matching skills, and Create PR templates:

- Use `## Modes` as the container section when a room has more than one mode.
- Use the invocation name only as the mode heading; do not append `Mode` to the heading.
- In a PR-dedicated chat, an unqualified request to list, show, display, or identify `modes` must return the workflow modes defined in that PR's README and matching skill, including a named default workflow documented outside `## Modes`. Codex collaboration modes such as `Default` and `Plan` are returned only when Wes explicitly asks for collaboration modes.
- In prose, write "Use this mode..." or "this mode..." when explanation needs the generic noun.
- Preserve existing filenames, folder names, automation ids, task names, historical logs, and external references unless Wes separately authorizes those exact renames.
- New Project Room packages should follow this standard from creation.

## Diagram

Use this mode when Wes runs `Diagram` or asks Create PR to make, refresh, display, or maintain a relationship diagram of Buy Your Home Project Rooms.

Purpose:

- Produce a readable graphic showing how Project Rooms, skills, automations, and major handoffs relate.
- Keep the diagram grouped enough to fit on one page or screen.
- Prefer a polished SVG output unless Wes asks for another format.

Required sources:

1. `C:\Codex\Wiki Files\Agents and Automations Registry.md`
2. `C:\Codex\Wiki Files\Admin Home.md`
3. `C:\Codex\Wiki Files\Project Room Workflow.md`
4. `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`
5. Current `README.md` files under `C:\Codex\Wiki Files\Project Rooms\*\README.md` when needed for relationship details.

Workflow:

1. Confirm work is being done from `C:\Codex\Wiki Files`.
2. Read the required sources.
3. Identify all active, draft, planning, and support Project Rooms.
4. Group the rooms by practical function:
   - Intake / Coordination
   - Document Intake
   - Accounting / Project Data
   - Real Estate Transaction Work
   - Legal / Entity Work
   - Publishing / Public Work
   - System Maintenance
5. Show Jean Wright / Admin Operations as the coordination hub.
6. Show Email Monitor as the email intake and routing hub.
7. Show Doc Scan, Invoice Entry, and Template to Project as the document-to-accounting/project-data chain.
8. Show Contract for Deed relationships to Credit Worthiness Evaluator, Amortization, and Template to Project.
9. Show Gracious Millionaire and REI BlackBook as related book/public-website work.
10. Show Entity Relationship and Operating Agreements as related legal/entity-governance work.
11. Keep cross-links limited to the most important handoffs so the diagram remains readable.
12. Mark inferred relationships as inferred if they are not directly supported by the registry or README files.
13. Save the output under `C:\Codex\Wiki Files\Project Rooms\Create PR\outputs\`.
14. Use a filename such as `Project Room Relationship Diagram.svg`.
15. If the diagram is also useful globally, copy or link it from an Admin wiki index only after Wes approves that placement.
16. Review the SVG for readability before reporting completion.
17. Display or report the saved diagram path so Wes can open the current relationship view.
18. Commit only the diagram and directly related Create PR notes unless Wes authorizes broader wiki updates.
19. Push only under normal Admin wiki push rules.

Output standards:

- Use one-page grouped layout.
- Use readable labels, not tiny text.
- Avoid showing every minor edge if it makes the diagram unreadable.
- Prefer solid arrows for primary handoffs and dashed arrows for support/feedback relationships.
- Include a generated date and short source note in the diagram footer.

## Min PR Set

Use this mode when Wes asks Create PR to set up the minimum matching Codex chat / Project Room combinations on a prepared computer.

Purpose:

- Create a consistent, small set of named Codex chats for the Project Rooms Wes is most likely to use from a target computer.
- Keep chat names aligned with Project Room names without implying that chats on different computers share live conversation state.
- Make each chat start safely from `C:\Codex\Wiki Files` and verify its Project Room and matching skill before doing file work.
- Record which chats are ready and which are still pending when a usable thread id is not returned.

Default minimum set:

1. `Codex Environment`
2. `Jean Wright`
3. `Email Monitor`
4. `Doc Scan`
5. `Invoice Entry`
6. `Manager`
7. `Lowes Order`
8. `Marketplace`
9. `Sync Github`

Required sources:

1. `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`
2. `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`
3. `C:\Codex\Wiki Files\Agents and Automations Registry.md`
4. `C:\Codex\Wiki Files\Project Rooms\Jean Wright\working\dispatcher-routing-map.md`
5. The README and matching skill source for each Project Room in the approved minimum set.

Workflow:

1. Confirm the target computer has already passed Codex Environment setup or update verification.
2. Confirm the target computer's Codex Desktop project is pointed at `C:\Codex\Wiki Files`.
3. Confirm the approved Project Room list. Use the default minimum set unless Wes names a different exact list.
4. For each Project Room, verify:
   - `Project Rooms\<Project Room>\README.md` exists,
   - `skills\<skill-name>\SKILL.md` exists when the room has a matching skill,
   - the intended chat title matches the Project Room name.
5. When `Sync Github` is included, also verify the target computer has one machine-local `sync-gethub-daily` heartbeat attached to its existing `Sync Github` chat, scheduled daily at 5:30 AM Eastern, and has completed one safe run. The safe run must prove `git fetch origin` can update `.git\FETCH_HEAD`; if the managed runner is permission-denied on `.git\FETCH_HEAD`, verify a Wes-approved unsandboxed/local fetch path or mark unattended daily sync as pending. Do not create a separate `Sync Github Daily` chat or detached cron automation. Record missing installation or first-run verification as pending; route installation through Codex Environment only when that deployment is separately authorized.
6. For each Project Room in the set, check `Agents and Automations Registry.md` and the room README for required automations or heartbeats. Record whether each required automation is:
   - not needed on this target computer,
   - present and attached to the current machine-local task,
   - missing,
   - still targeting an obsolete task id,
   - present but unverified,
   - or blocked by permissions/connectors.
7. When a required automation exists for a Project Room, Min PR Set must not treat the chat alone as complete. It must either verify the automation is attached to the current task id for this target computer, or record the automation as `pending automation setup`. Creating or retargeting the automation requires Wes's separate authorization for that scheduled or event-triggered behavior.
8. Build a startup prompt for each chat using the New Chat Startup Requirements in this README.
9. Create each Codex chat only when Wes explicitly asks to create the chats or run this setup mode. If the Codex app connector returns a usable thread id, record it.
10. If chat creation does not return a usable thread id promptly, stop waiting on that chat and mark it `pending until the dedicated chat is created`.
11. Do not mark a chat as dispatchable until a usable thread id is recorded in the appropriate registry/routing metadata.
12. Do not edit the target Project Room's content files merely because this mode created or verified a chat. Limit cross-PR writes to explicit chat/thread metadata that Wes authorized for this setup run.
13. Save a run manifest under `C:\Codex\Wiki Files\Project Rooms\Create PR\outputs\minimum-pr-chat-set\` showing:
    - target computer,
    - approved Project Room list,
    - chat title,
    - README status,
    - skill status,
    - created or pending status,
    - thread id when available,
    - Sync Github automation status and first-safe-run status when applicable,
    - required per-Project-Room automation status and target task id when applicable,
    - and any blocker.
14. Commit only scoped Create PR mode outputs and authorized metadata updates.
15. Push only under normal Admin wiki push rules.

Safety rules:

- Do not create every possible Project Room chat by default.
- Do not use or point any chat to a Teams-synced wiki folder.
- Do not assume identical chat names share context. Each chat must run its own startup prompt before doing file work.
- Do not create substitute chats for a Project Room that already has a registered dedicated task/thread id unless Wes explicitly approves replacing or adding a chat for that room.
- Do not route Jean Dispatcher work to any chat marked `pending`.
- Do not create or retarget automations as part of this mode unless Wes separately asks for the exact scheduled or event-triggered behavior. Missing or obsolete automations must be recorded as pending instead of silently ignored.

## Standard Create PR Workflow

1. Confirm the requested PR name and normalize the matching skill name to lower-case hyphen-case.
2. Verify the canonical repo is `C:\Codex\Wiki Files`.
3. Work from `main` under the Main Branch Rule.
4. Check whether the Project Room, skill, registry entry, or chat already exists.
5. Create the Project Room folders: `sources\`, `working\`, and `outputs\`.
6. Create `README.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
7. Apply the Durable Outcome Log Pattern from `Project Room Workflow.md`: decide whether the room needs a durable outcome log, and create a workflow-named Markdown log under `working\` when the room handles repeatable intake, routing, processing, delivery, filing, document movement, scan handling, email handling, spreadsheet insertion, or external workflow handoffs.
8. In the new README, include the short Start PR pointer from `Project Room Chat Startup Rule.md`, the standardized Action Ownership pointer from `Project Room Delegation Contract.md`, and the short PR Messaging pointer from `Project Room Messaging Rule.md`, not the full central rule text.
9. Make the new room dispatcher-ready by relying on the central Dispatcher Intake And Return Rule in `Project Room Chat Startup Rule.md`; do not copy the full dispatcher rule into the PR unless Wes explicitly asks for a local exception.
10. If the new room has a dedicated task/thread id, record it in the README, matching skill when useful, registry entry, and Jean routing map.
11. Create the matching wiki-managed skill under `skills\<skill-name>\SKILL.md`.
12. In the new skill, include the same short Start PR, Action Ownership, and PR Messaging pointers.
13. Include the new PR under the ownership and Git coordination rule; do not set up a new room so that it can edit other PR files by default.
14. Add an `agents\openai.yaml` file for the skill when practical.
15. Update `Agents and Automations Registry.md` when the workflow is agent-like, repeatable, or expected to have a dedicated chat.
16. Add an `Admin Home.md` link when the room should be easy to find from the wiki start page.
17. Create and commit the scoped durable files locally before attempting a dedicated Codex task.
18. A Project Room is `pending setup`, not dispatchable, until it passes the Mandatory Messaging Readiness Gate. A recorded task id by itself is not enough.
19. Treat the request to create the new PR as authorization to create its dedicated Codex chat. Reuse a verified existing matching task when one already owns the room; otherwise attempt chat creation once using the Project Room Chat Startup Rule startup text. If no usable id is returned, record the explicit task-creation blocker and report that the PR package is not dispatchable.
20. If a dedicated chat is created, record the returned thread id in the README, registry, and Jean routing map, then complete the manifest, execution-machine registration, host-access, and exact-identity synthetic lifecycle checks before marking it dispatchable.
21. Push only when Wes explicitly asks, says the work is finished, or the applicable rule defines the deliverable as ready to publish.

## Existing PR Rename Or Move Rule

A broad request to clean up, standardize, align, consolidate, or reorganize Project Rooms is not enough to move, rename, delete, or edit an existing Project Room or project-specific skill.

Before any existing PR or project-specific skill move/rename/delete/edit, state the exact old path, proposed new path, known owning chat/workflow, and whether registry entries, automations, installed skills, or chat titles are affected. Then ask:

```text
Do you authorize moving/renaming <old path> to <new path>?
```

Do not make the change until Wes answers yes to that specific proposal.

## New Chat Startup Requirements

Every new PR chat created by this workflow should include:

- canonical repo path,
- warning not to use the Teams-synced wiki folder,
- required startup reads,
- Project Room path,
- matching skill path,
- working branch, normally `main`,
- current status and open decisions,
- instruction to leave unrelated dirty work alone.
- dispatcher return expectation: respond with `accepted`, `done`, `blocked`, `needs Wes`, `rejected as wrong room`, or `routed onward with approval` when receiving a Jean handoff.

## Dispatcher-Ready PR Standard

Every new PR should be able to receive a Jean Dispatcher handoff without adding room-specific dispatcher text. The standard is:

- README and skill include the Start PR pointer to `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.
- The central Dispatcher Intake And Return Rule governs incoming Jean handoffs.
- The registry entry identifies the Project Room, matching skill, status, schedule, and primary definition.
- Jean's routing map records the PR, skill, task/thread id or `pending`, and routing notes.
- `config\pr-messaging-manifests\<skill-name>.json` records the exact task id, execution machine, gate evidence, and dispatchability state.
- The exact Project Room/task identity is registered on the execution machine and has passed one immutable synthetic Accepted, Processing, and Completed lifecycle after exactly one notification.
- README and skill include the short PR Messaging pointer to `C:\Codex\Wiki Files\Project Room Messaging Rule.md`.
- A `pending` task/thread id means the room is not dispatchable. Jean must return that blocker to Wes instead of routing work to another chat, creating a substitute chat, or handling the room's specialized work locally.
- If the room receives substantial routed work, create or update `working\work-status.md`; do not create work-status files for trivial questions or quiet checks.
## Delegation Contract

Delegation Contract: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Jean may delegate this PR's work only to its registered task in `Project Rooms\Jean Wright\working\dispatcher-routing-map.md`; the PR must accept and return the same `dispatch_id` under the central contract.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
