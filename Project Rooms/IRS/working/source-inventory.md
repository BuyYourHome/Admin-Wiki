# Source Inventory

| Source | Type | Status | Notes |
| --- | --- | --- | --- |
| Wes instruction creating the IRS Project Room | User instruction | authoritative | The room must identify everything needed to file taxes for all entities. |
| `Project Room Workflow.md` | Wiki rule | authoritative | Defines source preparation, evidence, and output standards. |
| `Agents and Automations Registry.md` | Registry | authoritative | Identifies related Project Rooms and current operating roles. |
| `Project Rooms\Entity Relationship\` | Related Project Room | background | Expected source for entity and relationship mapping; facts must be independently verified for tax use. |
| `Project Rooms\Operating Agreements\` | Related Project Room | background | Expected source for governing-document references and ownership questions. |
| QuickBooks company files and accounting reports | External accounting source through Quickbooks PR | access route identified; records pending | Wes confirmed access to QuickBooks via the Quickbooks Invoice PR. Use the owning Quickbooks PR and its current registered task for scoped access requests. Exact entity/company mappings, tax periods, report availability, and reconciliation status remain to be verified. Current documented Invoice mode does not by itself establish tax-report extraction capability. |
| Prior federal, state, and local tax returns | Secure tax source | source identified; review pending | Wes confirmed all prior returns are in Teams. Screenshot shows `Office Admin > 2024 > CPA`. Start there; verify other years and entity coverage from the actual records. Do not copy sensitive returns into Git or infer filing acceptance from their presence. |
| Payroll and information-return records | External tax source | missing | Identify providers, quarters, Forms 941/940/W-2/W-3/1099 and applicable state filings. |
| Tax notices, extensions, elections, and acceptance confirmations | Secure tax source | missing | Needed to establish authoritative status and carryforwards. |


## Entity Documentation Source - Wes Instruction, 2026-09-11

Wes confirmed that the entity list and entity information are in Teams. All Teams folders whose names start with `Corp` provide the documentation about the entities. Use these folders as the starting source for the master entity inventory and entity-document review before asking Wes to supply entity information again.

The source location is confirmed by Wes; individual folder paths, document contents, and tax-year completeness have not yet been reviewed. Record minimal secure references here and keep sensitive entity and tax documents outside Git. The Admin wiki working repository remains `C:\Codex\Wiki Files`.