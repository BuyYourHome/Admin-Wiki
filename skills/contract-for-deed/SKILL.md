---
name: contract-for-deed
description: Use when refreshing, regenerating, reviewing, or packaging contract-for-deed seller documents from a real estate project spreadsheet, including the 320 Rose package and future similar Buy Your Home seller document packages.
---

# Contract For Deed

## Source Of Truth

Use the Admin wiki as the source of truth.

- Wiki repository: `C:\Codex\Wiki Files`
- Current project room: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed`
- Current project room instructions: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\PROJECT-ROOM.md`

This skill is a reusable workflow wrapper. Project-specific source files, prototypes, generated outputs, and history stay in the project room unless Wes explicitly asks to move or copy a final deliverable elsewhere.

## Required Startup

Before file work:

1. Confirm the working folder with `Get-Location`.
2. If it is not `C:\Codex\Wiki Files`, use `C:\Codex\Wiki Files` explicitly as the shell workdir and use absolute paths under `C:\Codex\Wiki Files`.
3. Read `Admin Home.md`, `AGENTS.md`, `Repository Location Rule.md`, `Codex Skill Source Rule.md`, and the active project room `PROJECT-ROOM.md`.
4. Check `git status --short --branch`.

## Core Workflow

Use this workflow when Wes asks to refresh or recreate contract-for-deed sale documents.

1. Check the output folder for Word lock files: `~$*.docx`.
2. Compare each draft output timestamp against its prototype.
3. If any draft is newer than its prototype, inspect it for generated review blocks.
4. Save clean newer drafts as the current prototype before regenerating. Do not preserve generated attorney-review notes as template content.
5. Refresh the staged project spreadsheet from the live project spreadsheet.
6. Read document values from the workbook `Docs` worksheet.
7. Regenerate the standard clean draft files, overwriting the existing drafts unless Wes asks for revision copies.
8. Verify clean drafts contain no generated attorney-review or management-review blocks.
9. Verify key values from the `Docs` worksheet appear in the generated documents.
10. Report output file locations and elapsed time for each major task.

## 320 Rose Current Paths

For the current 320 Rose package:

- Live spreadsheet: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28_Project Management - 320 Rose Pl.xlsm`
- Staged spreadsheet: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\source\320 Rose project spreadsheet\28_Project Management - 320 Rose Pl.xlsm`
- Output folder: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\output`
- Contract generator: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\format_contract_from_reference.py`
- Memorandum generator: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\format_memo_from_prototype.py`
- Note generator: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\format_note_from_reference.py`
- Attorney-review package generator: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\make_attorney_review_copies.py`

## Document Rules

- Do not include a deed in the package unless Wes changes the scope.
- Use only `LoanStart1` and `LoanEnd1`; ignore `LoanStart2` and `LoanEnd2`.
- Earnest money paid at contract signing comes from `BinderDeposit` / `Binder Deposit:` on the `Docs` worksheet unless a more specific `Selling Earnest Money` field is added.
- `Selling Down Payment:` is the total down payment; remaining down payment due at closing is total down payment minus earnest money.
- Preserve Wes-edited purchase-price table formatting, including row height and justification, when refreshing table values.
- Seller signature stays anonymous as the trust/trustee structure: `Investment Services LLC, Trustee - Wes Browning, Manager`.
- The ACH draft paragraph belongs where Wes placed it as section 7(d).
- Buyer ACH account/routing blanks stay on the buyer signature page.
- Notary blocks must preserve underlined notary-name blanks and include notary signature lines.
- If the spreadsheet has no adverse-condition text, keep one section 9 `NOTE FOR ATTORNEY REVIEW` placeholder in the clean contract.
- Attorney-review mode overwrites the standard `ATTORNEY REVIEW PACKAGE` files and adds blue contextual review blocks. Clean drafts must not contain those blocks.

## Skill Maintenance

Canonical skill source lives in the wiki under `C:\Codex\Wiki Files\skills`. Installed local copies under `%USERPROFILE%\.codex\skills` are generated copies.

When changing this skill:

1. Make the change in the wiki copy first.
2. If project-room scripts or instructions change, update the project room at the same time.
3. Run `C:\Codex\Wiki Files\tools\sync-codex-skills.ps1` to refresh the local installed copy.
4. Commit and push the Admin wiki changes.
