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

- Push only when Wes says the current body of work is finished, explicitly asks for a push, or the task instructions define the scoped deliverable as final and ready to publish.
- Before pushing, verify the push would include only the intended body of work.
- If a push would include unrelated local work, stop and report the blocker instead of pushing.
- Leave unrelated modified files and unrelated untracked files out of the push.

## Reporting Rule

Final responses should say:

- what scoped body of work was committed,
- the commit id or branch name when relevant,
- whether it was pushed,
- whether unrelated local work was left alone,
- total request time.
