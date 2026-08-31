# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| Durable message `prmsg-jean-create-quickbooks-invoice-20260831-001` | Wes-authorized Create PR handoff | authoritative | Defines the room, skill, dedicated task, Invoice Entry handoff boundary, connector gates, prohibited actions, messaging manifest, and non-dispatchable requirement. |
| Durable message `prmsg-create-pr-quickbooks-connector-readiness-20260831-001` | Wes-authorized readiness handoff | authoritative | Selects Zapier QuickBooks Online MCP, authorizes interactive Chrome OAuth and read-only validation, requires five named company connections and the four-tool allowlist, and prohibits all production invoice and unrelated bookkeeping actions. |
| `Project Room Workflow.md` | Central wiki rule | authoritative | Defines required Project Room structure and durable outcome logging. |
| `Project Room Chat Startup Rule.md` | Central wiki rule | authoritative | Defines startup, task creation, dispatcher intake, and return states. |
| `Project Room Delegation Contract.md` | Central wiki rule | authoritative | Defines action ownership and durable handoff acceptance. |
| `Project Room Messaging Rule.md` | Central wiki rule | authoritative | Defines central record authority and exact-identity lifecycle requirements. |
| `config\pr-messaging-manifests\README.md` | Manifest standard | authoritative | Defines the mandatory messaging-readiness gate and schema. |
| `Project Rooms\Invoice Entry\README.md` and `skills\invoice-entry\SKILL.md` | Upstream workflow references | background | Invoice Entry owns intake, validation, mapping, approval gates, and the structured handoff. Reading does not authorize edits. |
| Zapier MCP sign-in and QuickBooks Online connection surfaces | External service | blocked | Zapier sign-in page reached in Chrome. Wes login is required before QuickBooks OAuth, company identity capture, tool-set verification, or read-only validation can continue. |
