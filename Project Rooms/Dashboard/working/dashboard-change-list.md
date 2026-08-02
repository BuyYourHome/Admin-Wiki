# Dashboard Change List

| ID | Requested change | Status | Implementation boundary |
| --- | --- | --- | --- |
| DASH-001 | Give every Project Room card side panel at least one starter action and support several future actions. | completed | `Open Project Room README` is the truthful default; room-specific actions are appended. |
| DASH-002 | Allow Wes to initiate deletion of an unwanted Project Room from its side panel. | workflow preview implemented | `Review deletion` presents one confirmation without name typing, names only the selected room and its documented matching skill/task, exposes unresolved resources, and downloads an audit-plan record. It does not delete, archive, hide, rename, route, or alter anything. |
| DASH-003 | Show canonical documented modes in a selected-room side-panel combo box. | completed | Modes are extracted from the room README and matching skill when available. Selection is interface-only and activates nothing. |
| DASH-004 | Codify the current grouping and place the future group-change control in the displayed Group property. | completed | Current assignments and group definitions live in `config\project-room-groups.json`. A selection previews another group but is not saved or applied. |
| DASH-005 | Provide a second Quick action position for later assignment. | completed | Rooms with fewer than two actions show a disabled `Future action available` slot. Rooms that already have a README action and a room-specific action do not receive a third slot. |
| DASH-006 | Open Dashboard document actions without replacing the Dashboard page. | completed | Dashboard links use the browser's normal new-tab/window behavior with `target="_blank"`; the browser controls final tab handling. |
| DASH-007 | Assign Gracious Millionaire's available second Quick action to its website. | completed | `Open GraciousMillionaire.com` opens `https://graciousmillionaire.com` in a separate browser tab/window context. |
