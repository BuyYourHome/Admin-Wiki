# Source Inventory

| Source | Location | Status | Notes |
|---|---|---|---|
| Document Scanning SOP | `C:\Codex\Wiki Files\Document Scanning SOP.md` | authoritative | Human-facing workflow for scanned document processing. |
| Document Scanning Skill Spec | `C:\Codex\Wiki Files\Document Scanning Skill Spec.md` | authoritative | Detailed behavior for the document-scanning skill and automation. |
| Document Scanning Folder Map | `C:\Codex\Wiki Files\Document Scanning Folder Map.md` | authoritative | Routing authority for scanned document destinations. |
| Document Scanning skill source | `C:\Codex\Wiki Files\skills\document-scanning\SKILL.md` | authoritative | Canonical wiki-managed skill source. |
| Installed Document Scanning skill copy | `C:\Users\wesbr\.codex\skills\document-scanning\SKILL.md` | installed copy | Runtime copy only; update from canonical skill source when ready. |
| Live automation config | `C:\Users\wesbr\.codex\automations\document-scanning\automation.toml` | authoritative local config | Defines live schedule, prompt, status, cwd, and execution details. |
| Invoice and Receipt Processing Notes | `C:\Codex\Wiki Files\Invoice and Receipt Processing Notes.md` | authoritative for invoice/receipt routing | Used when scans are invoices or receipts. |
| Invoice Project List | `C:\Codex\Wiki Files\Invoice Project List.md` | authoritative for project invoice matching | Used to route project invoices to the correct property/project folder. |
| Workflow source note | `Project Rooms\Document Scan\sources\workflow-source-note.md` | background | Summary of controlling sources and runtime locations. |

## Inventory Notes

- Keep raw source paths in this inventory.
- Do not copy or edit the installed skill copy directly unless troubleshooting runtime behavior.
- If scan routing rules change, update the folder map, skill spec, skill source, and registry in the same work group.
