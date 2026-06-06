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

Use a descriptive branch name with the `codex/` prefix unless Wes asks for another name.

Examples:

- `codex/operating-agreements`
- `codex/estate-review`
- `codex/document-scanning-sop`

## Reporting Rule

Final responses should say:

- what scoped body of work was committed,
- the commit id or branch name when relevant,
- whether it was pushed,
- whether unrelated local work was left alone,
- total request time.
