# OA Build Modes

Use these modes before creating or modifying any operating agreement draft in this project room.

The selected mode determines the entity being drafted for, the working folder, the likely source class, and the entity-specific facts that must be confirmed before drafting.

## Mode Selection Rule

- Every OA drafting request must be assigned one mode before work begins.
- Do not carry facts from one mode into another mode unless the rule or source explicitly says the fact applies across modes.
- If the user asks for an OA without naming the entity, ask or infer from the immediate context and state the selected mode.
- Keep outputs separated by mode-specific working folders.
- All new OA drafts that use the SYH/Simplified OA framework must begin from the Reassembled OA Check unless Wes explicitly names a different source for that specific draft.
- New derivative OAs must be built from the verified Simplified OA subfile set. The Reassembled OA Check is the assembled starting `.docx`, but the subfiles remain the controlled building blocks and article-level map.
- When a draft uses SYH source language as a building block for another entity, preserve the distinction between source-origin language and target-entity changes.

## Modes

| Mode | Entity | Working Folder | Primary Use | Current Source / Starting Point |
| --- | --- | --- | --- | --- |
| `SYH` | Sell Your Home, LLC | `working\SYH\` | Sell Your Home OA revisions and SYH manager/member updates. | Reassembled OA Check unless Wes names another SYH source. |
| `BYH` | Buy Your Home, LLC | `working\BYH\` | Buy Your Home OA conversion from SYH/Jeff Watson building blocks. | Reassembled OA Check plus cumulative BYH rules and `BYH OA Process Control.xlsx`, unless Wes names another source. |
| `Investment Services` | Investment Services LLC | `working\Investment Services\` | Investment Services OA conversion from SYH/Jeff Watson building blocks, similar to BYH but with Investment Services-specific facts. | Reassembled OA Check plus Investment Services mode rules, unless Wes names another source. The Wyoming Investment Services OA is reference/background only unless Wes explicitly names it as the source. |
| `BYH 401K` | BYH 401K LLC | `working\BYH 401K\` | BYH 401K OA drafting where no copied OA source has yet been confirmed. | Missing-source mode until an OA source or drafting direction is provided. |
| `Heritage Management` | Heritage Management LLC | `working\Heritage Management\` | Heritage Management OA revisions or new drafts. | Inventory-controlled Heritage Management source files until a specific source is selected. |

## Cross-Mode Controls

- Use `sources\` only for original, copied, refreshed, or reference source files.
- Use `working\<Mode>\` for drafts, build notes, comparisons, and mode-specific process notes.
- Use `outputs\` only for review-ready or final deliverables when requested.
- Add a footer to assembled OA drafts showing page number and draft/version identifier, following the Contract for Deed footer pattern.
- When an OA is finalized, copy it to the appropriate Teams channel/folder for that entity and move prior existing OA files there into an `Operating Agreement Archive` folder.
- Keep Jeff Watson drafting files segregated under `sources\Jeff Watson\`.
- Refresh Teams/SharePoint sources before derivative work when the controlling source is a Teams file that Wes may edit.
- Record new source or draft files in `working\source-inventory.md`.
- Structural and visual QA rules for Word documents apply to all modes.
- Manager and certification blocks must support entity Managers as well as individual Managers. If Investment Services LLC serves as Manager, include it in the certification block and identify the signer in capacity, such as `[Signer Name], Manager of Investment Services LLC, Manager of [Company Name]`.

## BYH Mode Differentiation From SYH

BYH mode is a conversion mode, not a simple SYH rename.

When using SYH/Simplified OA language as source material for BYH:

- Treat SYH/Jeff Watson language as source-origin language.
- Treat BYH additions and replacements as target-entity changes.
- Preserve Jeff Watson red edits as source edits.
- Use green font for BYH additions and replacement text unless Wes changes the color rule.
- Strike SYH/retirement-account language that does not apply to BYH, except where a clean-edit exception applies.
- Use clean edits for certification/signature pages and Exhibit A when historical redline text would confuse signing or ownership records.
- Apply the cumulative BYH rules in `oa-revision-rules.md` and `BYH OA Process Control.xlsx`.

## Open Mode Facts

Before treating a draft as final, confirm each mode's controlling facts:

| Mode | Facts To Confirm |
| --- | --- |
| `SYH` | Current members, manager(s), retirement-account structure, effective date, certification/signature requirements, and whether the Simplified OA or another source controls. |
| `BYH` | Browning Family Revocable Trust authority, current managers, S-corp tax language, Exhibit A details, effective date, and attorney/CPA review. |
| `Investment Services` | Current members/owners, manager(s), tax classification, current controlling OA, and whether it serves as manager for other entities. |
| `BYH 401K` | Whether an existing OA source exists, members/owners, manager(s), retirement-plan ownership details, tax/ERISA implications, and drafting authority. |
| `Heritage Management` | Current members/owners, manager(s), tax classification, controlling OA version, and any later amendments. |
