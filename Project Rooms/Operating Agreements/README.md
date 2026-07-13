# Operating Agreements

## Purpose

Create a dedicated Project Room for operating agreements so entity governance documents, amendments, notes, and future agreement-related questions are reviewed from a clean source inventory.

## Intended Output

- Organized operating-agreement source set.
- Source inventory showing which documents are authoritative, background, duplicate, outdated, unclear, or missing.
- Duplicate and conflict log for superseded, inconsistent, or unclear entity documents.
- Review-ready summaries, comparison notes, or action lists in `outputs\` when requested.

## Current Scope

Included:

- Operating agreements for Buy Your Home-related entities when provided by Wes.
- Amendments, consents, membership schedules, ownership notes, attorney correspondence, or related source summaries.
- Questions and answers about operating agreements, only when supported by inventoried sources.

Excluded unless Wes specifically adds them:

- Final legal advice.
- Unsourced assumptions about ownership, authority, tax treatment, member rights, dissolution, buyout rights, or entity status.
- Teams copies or external deliveries, except approved final OA delivery and archiving.

## Source Locations

- Room sources: `sources\`
- Jeff Watson drafting sources: `sources\Jeff Watson\`
- Simplified OA subfiles: `sources\Jeff Watson\Simplified OA Subfiles\`
- Working notes: `working\`
- OA build mode register: `working\oa-build-modes.md`
- BYH process control workbook: `working\BYH OA Process Control.xlsx`
- Outputs: `outputs\`

## Segregation Rule

- Keep Jeff Watson drafting files segregated in `sources\Jeff Watson\`.
- Do not merge, rename, flatten, or mix those files into the main Sell Your Home source folder.
- Treat the Jeff Watson folder as a separate drafting reference set for new OA versions, not as the same source class as current or potentially controlling operating agreements.
- When drafting new OA versions, cite whether a source came from the Jeff Watson drafting folder or from the main copied OA source set.

## OA Revision Process Rules

1. The base file for the new Sell Your Home OA revision process is Jeff Watson's authored operating agreement: `sources\Jeff Watson\Jeff Base OA - Sell Your Home LLC (Browning & Hollinger) AMENDED AND RESTATED IRA-OWNED LLC OPERATING AGREEMENT.docx`. Teams file name: `Sell Your Home LLC (Browning & Hollinger) AMENDED AND RESTATED IRA-OWNED LLC OPERATING AGREEMENT.docx`.
2. A derivative of that base file is `sources\Jeff Watson\Wes Simplified Draft - 25-06-25 SELL_YOUR_HOME_LLC Jeff Watson's Original with Simplified Addition.docx`. Teams file name: `25-06-25 SELL_YOUR_HOME_LLC Jeff Watson's Original with Simplified Addition.docx`. This derivative contains many simplified paragraphs and a prolog/summary of the whole document by Wes Browning. Treat the prolog/summary as wholly authored by Wes. Treat Wes's replacement paragraphs as blue-font text. Treat Jeff Watson's original text as black-font text. Treat Jeff's later review pass as red-font edits.
3. All new Sell Your Home OA versions should be derived from `sources\Jeff Watson\Simplified OA - 25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx`, which is the working "simplified OA" and includes Jeff Watson's tracked edits and later approved source-stack edits. Teams file name: `25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx`. Do not refresh or replace this controlled local file from Teams before derivative work. Use this project-room file as the tracked source unless Wes explicitly identifies a different source for that specific work.
4. Before creating downstream subfiles or entity variants from the Simplified OA, create an accepted-build copy at `sources\Jeff Watson\Simplified OA Accepted Build Copy - 25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx`. Accept Word tracked insertions and deletions in that copy only, leaving the tracked Simplified OA intact. Derivative subfiles and entity drafts should use the accepted-build copy so later variants do not carry purple tracked insertions or struck tracked deletions.
5. For further analysis or derivative drafting, break the accepted-build copy of the simplified OA into separate reassemblable files before making substantive changes. Segment it by opening paragraphs, summary, and each article. Preserve a clear reassembly order so the separate files can be recombined into a complete OA. When creating subfiles, retain the Word formatting that remains after accepting tracked changes in the accepted-build copy, including font color, paragraph styles, numbering, spacing, page-break behavior, and other visible formatting. Verify that the subfiles can be reassembled into the same accepted-build copy before using them for analysis, drafting, or derivative work.
6. Give each simplified OA subfile a meaningful name. Include the reassembly order and the segment subject in the filename, such as `01 - Opening Paragraphs`, `02 - Summary`, and `03 - Article 1 - Offices and Records`.
7. Keep the simplified OA subfiles in the Jeff Watson subfolder `sources\Jeff Watson\Simplified OA Subfiles\`. Do not place those subfiles in the Jeff Watson root folder, the main Sell Your Home source folder, or another project-room folder unless Wes explicitly asks.
8. Build new derivative OAs from the verified Simplified OA subfile set. Use the Reassembled OA Check as the assembled starting `.docx` because it is the verified recombination of those subfiles, while treating the subfiles as the controlled building blocks and article-level map.
9. Add a footer to assembled OA drafts showing page number and draft/version identifier, following the Contract for Deed footer pattern.
10. Put the Drafting Legend at the end of review/redline OA `.docx` files in a separate final section with no page number or draft footer, so it can persist in the file but be omitted from print/PDF output when needed. Format each legend entry in the same visible style it describes, including matching font color and strikethrough. When splitting the Simplified OA stack, keep the legend as the separate `14 - Drafting Legend.docx` subfile.
11. When an OA is finalized, copy the finalized agreement to the appropriate Teams channel/folder for that entity and move prior existing OA files there into an `Operating Agreement Archive` folder.

## Teams Delivery Rule

- Teams is not the drafting source for OA builds.
- Do not pull or refresh OA drafting files from Teams merely because a derivative, subfile regeneration, or new draft is requested.
- Use the Admin Wiki project-room source stack as the working source of truth.
- Copy files to Teams only when Wes approves a final OA version for that entity, or when Wes explicitly identifies a Teams file as a new source for a specific task.
- When a final OA is copied to Teams, move prior existing OA files in that Teams channel/folder into `Operating Agreement Archive`.

## Source Inventory Status

- Approved final OAs: Sell Your Home LLC and Investment Services LLC were approved by Wes on 2026-06-18 and delivered to their Teams folders. Prior operating-agreement files in those Teams folders were moved into `Operating Agreement Archive`.
- Authoritative sources: approved final OAs are recorded in `outputs\` and `working\source-inventory.md`; other copied sources remain unclear unless separately confirmed.
- Copied sources: 10 operating-agreement files from Teams/SharePoint `Corp` channels, plus 4 Jeff Watson drafting files for new Sell Your Home OA versions. `Corp-Providence Landing Management LLC` remains excluded.
- Duplicate/outdated sources: multiple versions exist and need review before one agreement is treated as controlling.
- Missing context: BYH 401K LLC has a local working folder but no OA source file yet; attorney/CPA confirmation is still needed for controlling versions.

## Review Rules

- Preserve original source files. Edit only working notes or output drafts.
- Select the correct OA build mode before drafting. Current modes are `SYH`, `BYH`, `Investment Services`, `BYH 401K`, and `Heritage Management`.
- Keep mode-specific drafts in their corresponding `working\<Mode>\` folder.
- Keep drafting reference files separated from current/potentially controlling OA source files.
- Manager and certification/signature blocks must support entity Managers as well as individual Managers. If Investment Services LLC serves as Manager, include it in the certification block and identify the signer in representative capacity.
- Treat signed agreements, signed amendments, and attorney-confirmed documents as potentially authoritative, subject to inventory review.
- Mark unsupported items as `[UNSUPPORTED]` instead of filling gaps.
- Flag legal, tax, authority, ownership, member-rights, or entity-formation questions that need attorney or CPA review.
- Cite the source file or source note used for factual claims in summaries or answers.

## Decisions Needed

- Which entities should be included in this room.
- Which source folders, emails, scans, or prior notes should be copied or summarized into `sources\`.
- Whether Wes wants a simple inventory only, entity-by-entity summaries, missing-document checklist, or attorney-review packet.

## Next Actions

1. Confirm whether there is a sixth `Corp` channel outside the visible SharePoint document-library root.
2. Review copied agreements for signatures, amendments, effective dates, and superseded versions.
3. Use the Jeff Watson folder files as starting points when developing new Sell Your Home OA versions, but do not treat them as controlling until reviewed.
4. Mark controlling documents as `authoritative` only after version review.
5. Record duplicates, outdated documents, and contradictions in `working/duplicate-and-conflict-log.md`.
6. Draft summaries or review packets only after the relevant source set is inventoried.

## Related Wiki Links

- [[Project Room Workflow]]
- [[Project Rooms/Operating Agreements/working/oa-build-modes|OA Build Modes]]
- [[Project Rooms/Operating Agreements/working/oa-revision-rules|Operating Agreement Revision Rules]]
- [[Project Rooms/Operating Agreements/working/oa-version-shortcuts|OA Version Shortcuts]]
## Start PR Pointer

Before durable work, follow Start PR Mode in `C:\Codex\Wiki Files\Project Room Chat Startup Rule.md`.

Interpret unqualified requests under the Current PR Scope Rule in that file. Work on `main` unless Wes explicitly asks for a branch.
