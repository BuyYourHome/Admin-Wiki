---
name: admin-request-wrapup
description: Use for Buy Your Home Admin wiki work when finishing any user request, especially tasks involving file edits, project rooms, documents, skills, commits, or GitHub. Ensures Codex reports total request elapsed time and does not push Git changes unless Wes says the work is a finished product, explicitly asks for a push, or the deliverable is clearly final and ready to publish.
---

# Admin Request Wrapup

## Purpose

Apply Wes's Admin wiki wrap-up rules at the end of each request:

- Report the total elapsed time for the whole request.
- Do not report timing for individual steps unless Wes explicitly asks.
- Do not push Git changes by default.

## Git Rule

When work creates or changes durable Admin wiki files:

1. Commit appropriate durable changes locally when the task calls for it.
2. Do not push automatically.
3. Push only when one of these is true:
   - Wes says the work is a finished product.
   - Wes explicitly asks for a push.
   - The task instructions already define the deliverable as final and ready to publish.
4. In the final response, say whether a commit was made and whether it was pushed.

If the branch is ahead of GitHub because a local commit was not pushed, say that plainly.

## Timing Rule

In the final response, include one total request duration, such as:

`Request time: about 8 minutes.`

Use a reasonable estimate from the current turn/session timing. Do not include per-step timing unless Wes asks for it.

## Final Response Checklist

Before final response, include only what matters:

- Output file or edited file links, if any.
- Key result or decision.
- Commit id, if committed.
- Push status.
- Total request time.

Do not mention generated scratch files, render images, temporary tools, or raw processing artifacts unless Wes asks or they affect the deliverable.
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
