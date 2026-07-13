# Project Room File Ownership And Git Coordination Rule

Use this rule for Codex work in the Admin Wiki when work is being done from multiple Project Room chats or multiple machines.

## Core Ownership Rule

Each Project Room has an owning chat. That chat is responsible for durable work inside that Project Room.

A Project Room chat must not create, edit, move, delete, commit, or push files that belong to another Project Room.

This segregation is intentional. It prevents mixed commits, stale context, accidental cross-project edits, and unsafe pushes.

## What Counts As Another Project Room's Files

A file belongs to another Project Room when it is inside:

```text
C:\Codex\Wiki Files\Project Rooms\<Other Project Room>\
```

A matching skill source also belongs to that Project Room when the skill is specific to that workflow:

```text
C:\Codex\Wiki Files\skills\<other-project-skill>\SKILL.md
```

A Project Room chat must not edit another Project Room's matching skill source unless Wes explicitly authorizes that specific cross-PR edit.

## Shared Admin Files

Some Admin Wiki files are shared across Project Rooms and affect the whole operating system, not just one Project Room. Examples include:

```text
C:\Codex\Wiki Files\AGENTS.md
C:\Codex\Wiki Files\Agents and Automations Registry.md
C:\Codex\Wiki Files\Project Room Workflow.md
C:\Codex\Wiki Files\Git Work Scope Rule.md
C:\Codex\Wiki Files\Codex Skill Source Rule.md
```

Shared Admin files should normally be edited from the Jean Wright/Admin operations chat.

A Project Room chat may edit a shared Admin file only when Wes explicitly authorizes that specific shared-rule edit.

When shared Admin files are edited:

- keep the change narrowly tied to the authorized rule,
- avoid mixing the shared-rule edit with unrelated Project Room manuscript or output work,
- commit the shared-rule edit separately unless Wes explicitly approves one combined commit.

## Global Governance Updates

A global governance update is a rule change that Wes explicitly authorizes to apply across all Project Rooms, skills, or Admin Wiki operating rules.

Examples of explicit authorization include:

- "apply this to every PR,"
- "write this rule to control all PRs,"
- "update every Project Room README with this pointer,"
- "make this a global Admin Wiki rule."

A global governance update may be performed from the Jean Wright/Admin operations chat because it is system administration work, not ordinary Project Room content work.

When performing a global governance update:

- identify it as a global governance update before editing,
- keep the change limited to the authorized rule or pointer,
- do not alter Project Room content, sources, outputs, drafts, or deliverables unless Wes specifically authorizes those content changes,
- commit the governance update separately from ordinary Project Room work,
- push only under the normal Git push rules.

## Reading Versus Writing

A Project Room chat may read another Project Room's files for context when needed, unless that other Project Room's rules prohibit reading.

Reading another PR's files does not grant authority to edit them.

If the requested work requires changing another PR's files, stop and tell Wes which Project Room should handle the work.

## Cross-PR Work

Cross-PR edits are not allowed by default.

A cross-PR edit is allowed only when Wes explicitly says that the current chat is authorized to edit the named other Project Room for the specific task.

Even when Wes authorizes a cross-PR edit:

- identify the other Project Room by name before editing,
- keep the changed files tightly scoped,
- do not mix unrelated current-PR work with the cross-PR work,
- commit the cross-PR work separately unless Wes explicitly approves one combined commit.

## General/Admin Chat Rule

A general Admin or Jean Wright chat may route, coordinate, and document where specialized work belongs by default.

A general Admin or Jean Wright chat should not perform durable edits inside a specialized Project Room unless Wes explicitly authorizes that specific edit.

For example, Jean Wright may identify that a task belongs to Contract for Deed, but Jean Wright should not edit:

```text
C:\Codex\Wiki Files\Project Rooms\Contract for Deed\
```

or:

```text
C:\Codex\Wiki Files\skills\contract-for-deed\SKILL.md
```

unless Wes specifically authorizes Jean Wright to make that edit.

## Work Status Files

Each substantial Project Room may maintain:

```text
C:\Codex\Wiki Files\Project Rooms\<Project Room>\working\work-status.md
```

The purpose of `work-status.md` is status visibility, not file ownership.

It may record:

- current status,
- active or unfinished body of work,
- machine name when known,
- chat/task name when known,
- intended files or folders,
- last update time,
- commit id when work is completed,
- whether the work was pushed,
- blockers or waiting decisions.

A `work-status.md` file is not a technical lock. It does not give another chat permission to edit that PR's files. The ownership rule controls.

## Start Work Check

Before durable Project Room work, Codex should:

1. confirm it is working from `C:\Codex\Wiki Files`,
2. confirm the current branch is `main`,
3. check `git status --short --branch`,
4. fetch GitHub,
5. confirm local `main` is not behind GitHub,
6. read the current Project Room README and matching skill source when one exists,
7. confirm the requested edits belong to the current Project Room.

Fetching GitHub means checking what changed remotely before changing local files. It does not mean merging over local work.

If the local worktree has unrelated dirty files, do not pull, stage, commit, or push them automatically. Report the blocker.

If GitHub has newer changes and the local worktree is clean, update from GitHub before editing.

If GitHub has newer changes and the local worktree is dirty, stop and report the situation.

Never merge, rebase, or pull over dirty local work unless Wes explicitly authorizes that specific recovery step.

## Commit Scope Rule

Commit only the current chat's authorized body of work.

Do not commit:

- another Project Room's files,
- another Project Room's skill source,
- unauthorized shared Admin files,
- unrelated dirty files,
- temporary files,
- generated scratch files,
- Obsidian local settings,
- old work merely because it is present in the worktree.

A commit should usually represent one of these:

- one Project Room update,
- one skill update owned by the current PR,
- one durable rule update,
- one automation update,
- one finished document or workflow package.

## Push Safety Rule

Before pushing to GitHub, Codex must:

1. check `git status --short --branch`,
2. fetch GitHub,
3. confirm local `main` includes current GitHub `main`,
4. confirm the commits being pushed belong to the intended scoped body of work,
5. confirm no unrelated local work is being pushed.

If GitHub moved ahead after the local commit, do not force-push and do not guess. Stop and report the blocker.

Never force-push `main`.

## Routing Rule

If Wes asks a PR chat to do work that belongs to another PR, Codex should respond with the routing issue instead of editing.

Example response:

```text
That belongs to the Contract for Deed Project Room. This chat should not write those files. I can either summarize what needs to be done for the Contract for Deed chat, or you can explicitly authorize this chat to make that specific cross-PR edit.
```

## Reversal Rule

Systemwide Project Room governance updates should be committed as a single focused governance commit whenever practical.

If unintended consequences appear, reverse the governance rollout with a normal Git revert of that commit instead of hand-editing scattered files.

Do not use `git reset --hard`, force-push, or destructive cleanup to reverse these rules unless Wes explicitly asks for that recovery method.

## Final Reporting

When work is completed, Codex should report:

- what Project Room or rule was changed,
- whether any cross-PR edit was requested or avoided,
- whether any shared Admin file was changed,
- commit id if a commit was made,
- whether the commit was pushed,
- whether unrelated local work was left alone,
- total elapsed time.
