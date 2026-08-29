---
name: create-pr
description: Use when Wes asks Codex to create, set up, standardize, or continue a Buy Your Home Project Room, PR, matching skill, dedicated chat, startup handoff, branch rule, or registry entry under `Project Rooms\Create PR`.
---

# Create PR

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Create PR`
- Skill source: `C:\Codex\Wiki Files\skills\create-pr\SKILL.md`
- Admin wiki source: `C:\Codex\Wiki Files`
- Registry: `C:\Codex\Wiki Files\Agents and Automations Registry.md`
- Chat startup rule: `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`
- Ownership and Git coordination rule: `C:\Codex\Wiki Files\Project Room File Ownership And Git Coordination Rule.md`

Use this skill for creating or maintaining the standard Buy Your Home Project Room package: Project Room, matching wiki-managed skill, registry entry when needed, and dedicated Codex chat.

## Messaging Readiness

- Dispatchable: Yes
- Destination manifest: `C:\Codex\Wiki Files\config\pr-messaging-manifests\create-pr.json`
- Execution machine: `WESSTUDIO`
- Exact task id: `019fdc5e-a1da-7e10-b388-a3be3830ac89`
- Synthetic lifecycle: `prmsg-create-pr-readiness-validation-20260829-1726` completed after exactly one notification under the exact registered identity.

## Required Startup

Before Create PR file work:

1. Confirm the working folder is `C:\Codex\Wiki Files`.
2. Read `Admin Home.md`, `AGENTS.md`, `Project Room Workflow.md`, `Project Room Chat Startup Rule.md`, `Project Room File Ownership And Git Coordination Rule.md`, `Agent Unit Standard.md`, `Codex Skill Source Rule.md`, and `Git Work Scope Rule.md`.
3. Read `Project Rooms\Create PR\README.md`, `working\source-inventory.md`, `working\duplicate-and-conflict-log.md`, and `working\missing-context.md`.
4. Check `git status --short --branch`.

## Workflow

1. Confirm the requested Project Room name.
2. Normalize the skill name to lower-case hyphen-case.
3. Work from `main` before creating the new PR:
   - Check `git status --short --branch`.
   - If the repo is not on `main`, switch to `main` only when the worktree is clean or the dirty files are clearly part of the current scoped Create PR setup and can safely move with the branch.
   - If unrelated dirty work, Git locks, or branch conflicts block switching to `main`, stop and report the blocker. Do not force, stash, reset, delete, or carry unrelated work into the new PR.
   - Do not create a new Git branch unless Wes explicitly asks for one.
4. Check whether the Project Room, skill, registry entry, or chat already exists. If an existing Project Room or project-specific skill would need to be moved, renamed, deleted, or edited, follow the explicit yes/no authorization rule in `Project Room File Ownership And Git Coordination Rule.md` before making any change.
5. Create the Project Room folders under `Project Rooms\<Project Name>\`: `sources\`, `working\`, and `outputs\`.
6. Create the room README with purpose, scope, folder map, status, matching skill, dedicated chat when any, Start PR pointer, standardized Action Ownership pointer, dispatcher intake/return expectation, branch rule, and next actions.
7. Create the standard working files:
   - `working\source-inventory.md`
   - `working\duplicate-and-conflict-log.md`
   - `working\missing-context.md`
8. Apply the Durable Outcome Log Pattern from `Project Room Workflow.md`: decide whether the room needs a durable outcome log, and create a workflow-named Markdown log under `working\` when the room handles repeatable intake, routing, processing, delivery, filing, document movement, scan handling, email handling, spreadsheet insertion, or external workflow handoffs.
9. Include this short pointer in the README and matching skill instead of copying the full central rule: `Start PR: Before durable work, follow Start PR in C:\Codex\Wiki Files\Project Room Chat Startup Rule.md. Interpret unqualified requests under the Current PR Scope Rule in that file. Work on main unless Wes explicitly asks for a branch.`
10. Include this short delegation-contract pointer in the README and matching skill: `Delegation Contract: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Jean may delegate this PR's work only to its registered task; accept and return the same dispatch id under the central contract.`
11. Include this exact short Action Ownership pointer in the README and matching skill: `Action Ownership: Follow C:\Codex\Wiki Files\Project Room Delegation Contract.md. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return accepted, done, blocked, needs Wes, or rejected as wrong room.`
12. Include this short PR Messaging pointer in the README and matching skill: `PR Messaging: Follow C:\Codex\Wiki Files\Project Room Messaging Rule.md. The central message record is authoritative; task messages are wake-up signals, not delivery proof.`
13. Make the new room dispatcher-ready by relying on the central Dispatcher Intake And Return Rule in `Project Room Chat Startup Rule.md`; do not copy the full dispatcher rule into the PR unless Wes explicitly asks for a local exception.
14. If the new room has a dedicated task/thread id, record it in the README, matching skill when useful, registry entry, and Jean routing map.
15. Create the matching skill under `skills\<skill-name>\SKILL.md` with source paths, required startup, workflow, boundaries, outputs, Git rules, Start PR pointer, Action Ownership pointer, and PR Messaging pointer.
16. Make the new Project Room subject to `Project Room File Ownership And Git Coordination Rule.md`; do not set up a new room so it can edit other PR files by default.
17. Add `skills\<skill-name>\agents\openai.yaml` when practical.
18. Update `Agents and Automations Registry.md` when the room is repeatable, agent-like, has a dedicated chat, or may later have automation.
19. Add `Admin Home.md` links when the room should be visible from the wiki start page.
20. Commit the scoped Project Room, skill, registry, and index changes before attempting dedicated task creation.
21. Mark the Project Room `pending setup` and `Pending messaging registration - not dispatchable` until it passes the Mandatory Messaging Readiness Gate. A task/thread id by itself is not enough.
22. Treat the request to create the new PR as authorization to provide its dedicated chat. Reuse a verified existing matching task when one already owns the room; otherwise attempt chat creation once using `Project Room Chat Startup Rule.md`. If the task cannot be created or a usable id is not returned, record that explicit blocker; do not silently treat the new room as ready or route its work through another chat.
23. If a dedicated chat is created, record the returned thread id in the README, registry, and Jean routing map, then complete the destination manifest, execution-machine registration, host-access, and exact-identity synthetic lifecycle checks before marking it dispatchable. Commit the metadata and readiness evidence update separately.
24. Push only under the Admin wiki push rules.

## Delegated Dashboard Deletion Authorization

`Create PR` may treat a Dashboard delegated deletion request as Wes authorization for one exact deletion action class when the request satisfies the central delegated authorization rule in `C:\Codex\Wiki Files\Project Room Delegation Contract.md`.

Required conditions:

1. The request source is `Dashboard`.
2. The request type is the Dashboard exact-scope Project Room deletion class.
3. The request identifies the exact Project Room path and any exact matching skill or documented task/chat in scope.
4. The request states that Dashboard already captured Wes's explicit confirmation for that exact scoped deletion action.
5. `Create PR` can execute the request without guessing, broadening scope, substituting archive for delete, or performing partial deletion.

When every condition is true, `Create PR` should not stop merely to ask Wes the same confirmation again. It should either proceed under the owning workflow rules or return a different truthful blocker if one remains.

## Dedicated Chat Connector Rule

Every new PR requires a dedicated Codex task. A request to create the PR includes authorization for this task-creation attempt; Wes does not need to request the chat separately.

1. Complete and commit the local PR package first.
2. Try the Codex app task-creation connector once.
3. If the connector does not return promptly or does not return a usable thread id, stop waiting on it and leave the README and registry `Thread id` as `pending until the dedicated chat is created`.
4. Report the local PR package as complete and the dedicated task as pending because the connector did not return.
5. Do not let task creation block the whole PR setup, and do not retry indefinitely in the same turn.
6. When the connector later succeeds, record the returned thread id in the PR README and registry, then commit that metadata update separately.

## Mandatory Messaging Readiness Gate

Every generated Project Room package must contain a `## Messaging Readiness` section in its README and matching skill. New rooms start as `Pending messaging registration - not dispatchable`.

After a dedicated task is created:

1. Record the exact task id in the README, `Agents and Automations Registry.md`, and Jean's routing map.
2. Create `config\pr-messaging-manifests\<skill-name>.json` with `dispatchable: false`, the exact task id, and the exact execution machine.
3. On that machine, register the exact Project Room/task identity with `tools\pr-messaging\Register-ProjectRoomMessagingClient.ps1` under the normal Codex Windows profile.
4. Verify authenticated access to `\\WES-VIDEOEDITOR\BYH-PRMessaging$` with `Manage-ProjectRoomMessage.ps1`.
5. Create an immutable synthetic validation record, write `StartAttempt` before exactly one task notification, and require `Accepted`, `Processing`, and `Completed` under the exact destination identity.
6. Record the lifecycle evidence in the manifest and run `tools\pr-messaging\Test-ProjectRoomMessagingReadiness.ps1` on the exact execution machine.
7. Set `dispatchable: true` and `Dispatchable: Yes` only when the validator returns `ready: true`.

If any check fails, preserve `Pending messaging registration - not dispatchable`. Do not substitute tasks or machines, store credentials in Git, or alter existing registrations merely to make an audit pass. Follow `config\pr-messaging-manifests\README.md` for the required manifest evidence.

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
8. Build a startup prompt for each chat using the New Chat Startup Requirements in this skill.
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

## Chat Startup Prompt Requirements

When creating a new PR chat, include:

- `C:\Codex\Wiki Files` as the required working repo.
- A warning not to use the Teams-synced wiki folder.
- Required startup reads from `Project Room Chat Startup Rule.md`.
- The Project Room path.
- The matching skill path.
- The working branch, normally `main`.
- Current status, open decisions, and any automation id or thread id.
- A reminder to leave unrelated dirty work alone.
- The dispatcher return expectation: respond with `accepted`, `done`, `blocked`, `needs Wes`, `rejected as wrong room`, or `routed onward with approval` when receiving a Jean handoff.

## Dispatcher-Ready PR Standard

Every new PR should be able to receive a Jean Dispatcher handoff without adding room-specific dispatcher text. The standard is:

- README and skill include the Start PR pointer to `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.
- The central Dispatcher Intake And Return Rule governs incoming Jean handoffs.
- The registry entry identifies the Project Room, matching skill, status, schedule, and primary definition.
- Jean's routing map records the PR, skill, task/thread id or `pending`, and routing notes.
- `config\pr-messaging-manifests\<skill-name>.json` records the exact task id, execution machine, gate evidence, and dispatchability state.
- The exact Project Room/task identity is registered on the execution machine and has passed one immutable synthetic Accepted, Processing, and Completed lifecycle after exactly one notification.
- README and skill include the short PR Messaging pointer to `C:\Codex\Wiki Files\Project Room Messaging Rule.md`.
- `pending` means the new room cannot receive routine delegation. Jean must return the task-creation blocker to Wes rather than creating a substitute chat or performing the new room's work.
- If the room receives substantial routed work, create or update `working\work-status.md`; do not create work-status files for trivial questions or quiet checks.

## Start PR Pointer

Before durable work, follow Start PR in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.

## Boundaries

- Do not create Teams folders unless Wes explicitly asks.
- Do not move, rename, delete, or edit an existing Project Room folder or project-specific skill folder merely because Wes asks to create, clean up, align, consolidate, reorganize, standardize, or rename Project Rooms or workflows.
- Before any existing PR or project-specific skill move/rename/delete/edit, state the exact old path, proposed new path, known owning chat/workflow, and whether registry entries, automations, installed skills, or chat titles are affected; then ask `Do you authorize moving/renaming <old path> to <new path>?` and wait for a yes to that specific proposal.
- Do not create automations unless Wes asks for scheduled or event-triggered behavior.
- Do not commit unrelated dirty work or generated scratch folders.
- Do not push unless Wes asks, says the setup is finished, or the applicable Admin wiki rules make the deliverable ready to publish.

## Action Ownership

Action Ownership: Follow `C:\Codex\Wiki Files\Project Room Delegation Contract.md`. Perform only this PR's documented actions. Delegate another PR's action to its registered task; a missing task/thread id is a blocker, never permission to perform it locally. Return `accepted`, `done`, `blocked`, `needs Wes`, or `rejected as wrong room`.
