# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| Durable message `prmsg-jean-create-quickbooks-invoice-20260831-001` | Wes-authorized Create PR handoff | authoritative | Defines the room, skill, dedicated task, Invoice Entry handoff boundary, connector gates, prohibited actions, messaging manifest, and non-dispatchable requirement. |
| `Project Room Workflow.md` | Central wiki rule | authoritative | Defines required Project Room structure and durable outcome logging. |
| `Project Room Chat Startup Rule.md` | Central wiki rule | authoritative | Defines startup, task creation, dispatcher intake, and return states. |
| `Project Room Delegation Contract.md` | Central wiki rule | authoritative | Defines action ownership and durable handoff acceptance. |
| `Project Room Messaging Rule.md` | Central wiki rule | authoritative | Defines central record authority and exact-identity lifecycle requirements. |
| `config\pr-messaging-manifests\README.md` | Manifest standard | authoritative | Defines the mandatory messaging-readiness gate and schema. |
| `Project Rooms\Invoice Entry\README.md` and `skills\invoice-entry\SKILL.md` | Upstream workflow references | background | Invoice Entry owns intake, validation, mapping, approval gates, and the structured handoff. Reading does not authorize edits. |
| QuickBooks connector/API documentation for the selected integration | External technical source | missing | Must be supplied or available through the approved connector before authentication, permissions, target-company, duplicate, and safe-validation gates can pass. |
