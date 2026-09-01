# WES-VIDEOEDITOR PR Messaging Dispatcher Deployment

## Target

- Computer: `WES-VIDEOEDITOR`
- Task name: `PR Messaging Dispatcher - WES-VIDEOEDITOR`
- Automation id: `pr-messaging-dispatcher-wes-videoeditor`
- Schedule: every five minutes
- Project: canonical Admin Wiki repo at `C:\Codex\Wiki Files`

## Startup Prompt

Create this task locally on WES-VIDEOEDITOR, then use this startup prompt:

> Work only from `C:\Codex\Wiki Files` on `main`. This is the dedicated machine-local task `PR Messaging Dispatcher - WES-VIDEOEDITOR`. Read `AGENTS.md`, `Project Room Messaging Rule.md`, `Project Room Delegation Contract.md`, `Project Rooms\PR Messaging Dispatcher\README.md`, `Project Rooms\PR Messaging Dispatcher\working\heartbeat-prompt.md`, and `skills\pr-messaging-dispatcher\SKILL.md`. Verify the computer name is exactly `WES-VIDEOEDITOR`, the central queue is accessible under the normal Codex Windows profile, and the task has no other heartbeat. Create one active heartbeat automation named `PR Messaging Dispatcher - WES-VIDEOEDITOR` with id `pr-messaging-dispatcher-wes-videoeditor`, running every five minutes and using the canonical heartbeat prompt. Register this exact Project Room/task identity in the machine-local messaging client. Do not process production work during setup. Return the task id, automation status, registration result, and any blocker. Do not mark deployment complete until an unattended synthetic message created on another computer reaches an exact local destination task through this dispatcher without manual pasting.

## Validation

After the task and heartbeat exist, Create PR must initiate one immutable synthetic message from another computer to a registered WES-VIDEOEDITOR destination. The local dispatcher must discover it automatically, write `StartAttempt`, send one notification, and obtain `Accepted`, `Processing`, and `Completed`. Record the dispatcher task id, automation id, source and destination machines, timestamps, and `manual_intervention: false` before restoring remote destination dispatchability.
