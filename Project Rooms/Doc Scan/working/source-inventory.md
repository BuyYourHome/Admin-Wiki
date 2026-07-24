# Source Inventory

| Source | Location | Status | Notes |
|---|---|---|---|
| Doc Scan SOP | `C:\Codex\Wiki Files\Document Scanning SOP.md` | authoritative | Human-facing workflow for scanned document processing. |
| Doc Scan Skill Spec | `C:\Codex\Wiki Files\Document Scanning Skill Spec.md` | authoritative | Detailed behavior for the document-scanning skill and automation. |
| Doc Scan Folder Map | `C:\Codex\Wiki Files\Document Scanning Folder Map.md` | authoritative | Routing authority for scanned document destinations. |
| Doc Scan skill source | `C:\Codex\Wiki Files\skills\doc-scan\SKILL.md` | authoritative | Canonical wiki-managed skill source. |
| Installed Doc Scan skill copy | `C:\Users\wesbr\.codex\skills\doc-scan\SKILL.md` | installed copy | Runtime copy only; update from canonical skill source when ready. |
| Live automation config | `C:\Users\wesbr\.codex\automations\doc-scan\automation.toml` | active local heartbeat config | Recreated on 2026-07-08 as app automation id `doc-scan`; runs every 15 minutes on weekdays from 10:00 AM through 4:45 PM Eastern. |
| Invoice and Receipt Processing Notes | `C:\Codex\Wiki Files\Invoice and Receipt Processing Notes.md` | authoritative for invoice/receipt routing | Used when scans are invoices or receipts. |
| Invoice Project List | `C:\Codex\Wiki Files\Invoice Project List.md` | authoritative for project invoice matching | Used to route project invoices to the correct property/project folder. |
| Property/Credit Cards Sheet | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\Credit Cards Sheet.xlsx` | authoritative for current property/mortgage context | Use worksheet `Mortgages` when matching insurance-related scanned documents to current properties. |
| Doc Scan Modes | `Project Rooms\Doc Scan\working\doc-scan-modes.md` | project-room operating index | Defines the project-room mode names used for scan-category development and cross-mode routing discussion. |
| Scanned Document Action Log | `Project Rooms\Doc Scan\working\scanned-document-action-log.md` | authoritative outcome log | Durable Admin wiki summary of what happened to source scans, filed/review documents, register alerts, and Project Room handoffs. |
| Teams Working Archive Map | `Project Rooms\Doc Scan\working\teams-working-archive-map.md` | authoritative archive map | Records where generated output packets, OCR working files, and scan-run logs were moved in Teams instead of Git. |
| Insurance Document Rules | `Project Rooms\Doc Scan\working\insurance-document-rules.md` | working rule context | Development notes for insurance-company and mortgage-company property insurance document handling. |
| Workflow source note | `Project Rooms\Doc Scan\sources\workflow-source-note.md` | background | Summary of controlling sources and runtime locations. |
| Email insurance attachment index | `Project Rooms\Doc Scan\sources\email-insurance-2026-06-15\attachment-index.csv` | retained source inventory | Text index kept in Git for the email-insurance source-document cleanup. |

## Source Document Cleanup Log

| Cleanup date | Local repo source path removed | Teams destination | Files | Bytes | Category/source group | Notes |
| --- | --- | --- | ---: | ---: | --- | --- |
| 2026-07-24 | `Project Rooms\Doc Scan\sources\*.pdf`, `Project Rooms\Doc Scan\sources\email-insurance-2026-06-15\**\*.pdf`, `*.jpg`, `*.png`, and `*.xlsx` source binaries | `C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files\Doc Scan Working Archive\Source Documents\2026-07-24 source cleanup` | 269 | 71,192,214 | Doc Scan retained source documents; scanned PDFs and email-insurance attachments | Source documents retained in Teams, not generated scratch. Relative folder structure from `Project Rooms\Doc Scan\sources` was preserved. `workflow-source-note.md` and `email-insurance-2026-06-15\attachment-index.csv` remain in Git as text/source inventory files. |

## Inventory Notes

- Keep raw source paths in this inventory.
- Do not copy or edit the installed skill copy directly unless troubleshooting runtime behavior.
- If scan routing rules change, update the folder map, skill spec, skill source, and registry in the same work group.
- Before changing the `doc-scan` automation, verify the app-managed automation and local `automation.toml` agree, then update the registry and project-room notes in the same change.
