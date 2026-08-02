# Dashboard Change List

| ID | Requested change | Status | Implementation boundary |
| --- | --- | --- | --- |
| DASH-001 | Give every Project Room card side panel at least one starter action and support several future actions. | completed | `Open Project Room README` is the truthful default; room-specific actions are appended. |
| DASH-002 | Allow Wes to initiate deletion of an unwanted Project Room from its side panel. | design implemented | `Request deletion` requires the exact room name and prepares a copyable owner-review request. It does not delete, archive, rename, route, or alter anything. |
| DASH-003 | Show canonical documented modes in a selected-room side-panel combo box. | completed | Modes are extracted from the room README and matching skill when available. Selection is interface-only and activates nothing. |
| DASH-004 | Codify the current grouping and place the future group-change control in the displayed Group property. | completed | Current assignments and group definitions live in `config\project-room-groups.json`. A selection previews another group but is not saved or applied. |
