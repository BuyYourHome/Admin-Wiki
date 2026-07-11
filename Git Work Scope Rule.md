# Git Work Scope Rule

Use this rule before committing or pushing Admin wiki work.

## Scope Unit

The default Git scope unit is the current chat's body of work.

Examples:

- one Project Room,
- one SOP update,
- one skill update,
- one document package,
- one automation or agent-like workflow change.

Do not bundle unrelated project rooms, unrelated files, prior local changes, or scratch outputs into the same commit just because they are present in the working tree.

## Commit Rule

- Check `git status --short --branch` before editing and before committing.
- Stage only files that belong to the current body of work.
- If unrelated modified or untracked files exist, leave them unstaged unless Wes explicitly says they belong in this body of work.
- Use plain-English commit messages that describe the scoped work.
- If the body of work spans multiple logical steps, multiple focused commits are acceptable.

## Push Rule

Pushing should be scoped the same way commits are scoped.

- Do not ask Wes to decide between pushing every unpushed local commit and pushing nothing when he is only working in one chat or one body of work.
- If the current branch has unrelated unpushed commits, create or use a scoped branch for the current body of work.
- Put only the relevant commits for that body of work on the scoped branch, using a clean branch from GitHub's current `main` and cherry-picking when needed.
- Push that scoped branch only when Wes says that body of work is finished, explicitly asks for a push, or the task instructions define the scoped deliverable as final and ready to publish.
- Leave unrelated local commits, unrelated modified files, and unrelated untracked files out of the push.

## Branch Naming

For durable Project Room work, use the Project Room branch pattern:

```text
project/<project-room-slug>
```

Examples:

- `project/operating-agreements`
- `project/doc-scan`
- `project/gracious-millionaire`

Use a descriptive `codex/<short-task-name>` branch only for one-off work that does not belong to a durable Project Room.

See [[Project Room Branch and Push Mode Rule]].

## Project Room Push Mode

When Wes says `Push` in a Project Room chat, treat it as permission to commit and push only that Project Room's intentional durable work on its `project/<project-room-slug>` branch.

`Push` does not update GitHub `main` unless Wes explicitly says `Push to main`, `promote to main`, or equivalent.

## Reporting Rule

Final responses should say:

- what scoped body of work was committed,
- the commit id or branch name when relevant,
- whether it was pushed,
- whether unrelated local work was left alone,
- total request time.
