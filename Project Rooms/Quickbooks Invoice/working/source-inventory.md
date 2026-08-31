# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| Durable message `prmsg-jean-create-quickbooks-invoice-20260831-001` | Wes-authorized Create PR handoff | authoritative | Defines the room, skill, dedicated task, Invoice Entry handoff boundary, connector gates, prohibited actions, messaging manifest, and non-dispatchable requirement. |
| Durable message `prmsg-create-pr-quickbooks-connector-readiness-20260831-001` | Wes-authorized readiness handoff | authoritative | Selects Zapier QuickBooks Online MCP, authorizes interactive Chrome OAuth and read-only validation, requires five named company connections and the four-tool allowlist, and prohibits all production invoice and unrelated bookkeeping actions. |
| Durable message `prmsg-jean-quickbooks-browser-control-decision-20260831-001` | Wes-authorized operating-method decision | authoritative | Supersedes the connector-only/browser-prohibited rule with authenticated Chrome browser control as the interim invoice method while preserving exact-company, duplicate, one-create, read-back, and no-unrelated-action gates. |
| `Project Room Workflow.md` | Central wiki rule | authoritative | Defines required Project Room structure and durable outcome logging. |
| `Project Room Chat Startup Rule.md` | Central wiki rule | authoritative | Defines startup, task creation, dispatcher intake, and return states. |
| `Project Room Delegation Contract.md` | Central wiki rule | authoritative | Defines action ownership and durable handoff acceptance. |
| `Project Room Messaging Rule.md` | Central wiki rule | authoritative | Defines central record authority and exact-identity lifecycle requirements. |
| `config\pr-messaging-manifests\README.md` | Manifest standard | authoritative | Defines the mandatory messaging-readiness gate and schema. |
| `Project Rooms\Invoice Entry\README.md` and `skills\invoice-entry\SKILL.md` | Upstream workflow references | background | Invoice Entry owns intake, validation, mapping, approval gates, and the structured handoff. Reading does not authorize edits. |
| Zapier MCP sign-in and QuickBooks Online connection surfaces | External service | superseded | The attempted Zapier readiness path was blocked at login and was later superseded by Wes's interim authenticated Chrome browser-control decision. |
| Authenticated QuickBooks Online company chooser in Chrome | External live system | authoritative readiness evidence | At `2026-08-31T16:51:43Z`, the chooser visibly listed five QuickBooks Online companies. No company was selected and no business record was created or changed. |
