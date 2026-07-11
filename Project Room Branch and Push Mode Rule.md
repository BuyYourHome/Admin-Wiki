# Project Room Branch And Push Mode Rule

Use this rule for every Buy Your Home Project Room that has durable work in the Admin wiki Git repository.

## Purpose

Each Project Room should keep its work on a predictable project branch so work from different rooms does not pile onto the same branch.

When Wes says `Push` in a Project Room chat, treat it as permission to make that room's intentional durable work safe in Git and GitHub without sweeping in unrelated dirty files.

## Branch Naming

Use this pattern for durable Project Room branches:

```text
project/<project-room-slug>
```

Examples:

- `project/doc-scan`
- `project/email-summary`
- `project/gracious-millionaire`
- `project/invoice-entry`
- `project/rei-blackbook`

The slug should be the Project Room name in lowercase, with spaces and punctuation converted to hyphens.

Use `codex/<short-task-name>` only for one-off work that does not belong to a durable Project Room.

## Startup Rule

When a Project Room chat starts, resumes, or is asked to do durable file work:

1. Verify the canonical repo with `Get-Location`.
2. Work only from `C:\Codex\Wiki Files`.
3. Read the Project Room README and matching skill source when one exists.
4. Determine the room branch from the README or derive it as `project/<project-room-slug>`.
5. Fetch GitHub state.
6. If the room branch exists locally, switch to it.
7. If the room branch exists on GitHub but not locally, create the local branch tracking `origin/project/<project-room-slug>`.
8. If the room branch does not exist, create it from current `origin/main`.
9. Announce the project branch being used before durable edits.

If unrelated uncommitted files would block switching branches, do not force, stash, reset, or move them without Wes's explicit approval. Instead, report the blocker and either continue with absolute paths only when safe or ask for a cleanup decision.

## Push Mode

When Wes says `Push` in a Project Room chat:

1. Verify the canonical repo and current branch.
2. Confirm the branch is the Project Room branch or switch to it safely.
3. Run `git status --short --branch`.
4. Identify the intentional file scope:
   - the Project Room folder,
   - the matching skill source,
   - required registry, rule, or index files directly tied to that room.
5. Leave unrelated dirty files unstaged.
6. Exclude scratch outputs, rendered previews, cache folders, `__pycache__`, temporary backups, and generated work folders unless Wes explicitly says they are final deliverables.
7. Review the scoped diff.
8. Stop and report before committing if the scoped diff contains passwords, tokens, payment-card data, full SSNs, bank credentials, or other live secrets.
9. Commit only the scoped durable files with a plain-English message.
10. Push the Project Room branch to GitHub.
11. Report the branch, commit id, push status, included files, and any intentionally ignored dirty files.

`Push` does not update GitHub `main` unless Wes explicitly says `Push to main`, `promote to main`, or equivalent.

## Push To Main

When Wes says `Push to main`, `promote to main`, or equivalent:

1. First complete normal `Push` for the Project Room branch.
2. Confirm the Project Room branch is clean and pushed.
3. Confirm the promotion can be done without force-pushing.
4. Fast-forward or merge the Project Room branch into local `main`.
5. Push `main` to GitHub.
6. Verify local `main` and `origin/main` point to the promoted commit.

Do not force-push `main` unless Wes explicitly authorizes a force push after the risk is explained.

## Scope Rules

- A branch is repo-wide; the branch itself cannot be limited to one folder.
- The discipline is in switching to the correct Project Room branch and staging only that room's intentional files.
- Shared files such as `Agents and Automations Registry.md`, `Admin Home.md`, or central workflow rules may be included only when the current Project Room work actually changes those shared rules.
- If two Project Rooms need the same shared rule changed, make the shared-rule update its own scoped commit or clearly explain why it belongs with the current room.

## Reporting

Final responses after Push Mode should state:

- Project Room branch used.
- Commit id and message.
- Whether the branch was pushed.
- Whether `main` was updated.
- Unrelated dirty files left alone.
- Total request time.
