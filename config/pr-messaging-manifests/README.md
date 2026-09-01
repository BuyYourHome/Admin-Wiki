# Project Room Messaging Destination Manifests

Each dispatchable Project Room must have one canonical JSON manifest in this folder. The filename should use the matching skill slug, such as `create-pr.json`.

## Mandatory Readiness Gate

New Project Rooms begin with `"dispatchable": false`. Create PR may change that value to `true` only after all of these checks pass:

1. The exact task id is recorded in the Project Room README, `Agents and Automations Registry.md`, and Jean's dispatcher routing map.
2. The manifest records the exact Project Room, skill, task id, and execution machine.
3. The exact Project Room/task identity is registered on that execution machine with `tools\pr-messaging\Register-ProjectRoomMessagingClient.ps1`.
4. The normal Codex Windows profile on that machine has authenticated access to `\\WES-VIDEOEDITOR\BYH-PRMessaging$`.
5. A synthetic message is created with `Manage-ProjectRoomMessage.ps1`, `StartAttempt` is written before exactly one task notification, and the destination writes `Accepted`, `Processing`, and `Completed` under the exact registered identity.
6. For a cross-machine destination, the execution computer has one verified machine-local dispatcher task/heartbeat and completes an unattended lifecycle initiated from another computer without manual pasting or direct user activation.
7. `tools\pr-messaging\Test-ProjectRoomMessagingReadiness.ps1` returns `"ready": true` on the recorded execution machine.

If any check fails, use `Pending messaging registration - not dispatchable` in the Project Room README, registry, routing map, and setup report. A task id by itself is not messaging readiness.

## Required Manifest Fields

Use schema version 2 for newly created or newly validated manifests:

```json
{
  "schema_version": 2,
  "project_room": "Example",
  "skill": "example",
  "task_id": "exact-task-id",
  "dispatchable": false,
  "execution_machine": "EXACT-COMPUTER-NAME",
  "owned_actions": [],
  "accepted_message_types": ["request", "question", "status", "decision", "result", "improvement"],
  "related_project_rooms": [],
  "limitations": [],
  "messaging_readiness": {
    "status": "pending",
    "machine_registration_verified_at_utc": null,
    "host_access_verified_at_utc": null,
    "validation_message_id": null,
    "lifecycle_completed_at_utc": null,
    "notification_count": 0,
    "dispatcher_task_id": null,
    "dispatcher_automation_id": null,
    "cross_machine_source": null,
    "manual_intervention": null
  }
}
```

Do not store credentials, tokens, passwords, SMB secrets, or copied payloads in a manifest.

## Validation Command

Run this on the manifest's exact execution machine after the synthetic lifecycle is complete and the evidence fields are populated:

```powershell
& "C:\Codex\Wiki Files\tools\pr-messaging\Test-ProjectRoomMessagingReadiness.ps1" `
  -ProjectRoom "Example" `
  -TaskId "exact-task-id" `
  -ReadmePath "C:\Codex\Wiki Files\Project Rooms\Example\README.md" `
  -ManifestPath "C:\Codex\Wiki Files\config\pr-messaging-manifests\example.json"
```

The validator is read-only. Existing registrations must not be changed merely to make an audit pass.
