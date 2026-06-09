---
name: contract-for-deed
description: Use when refreshing, regenerating, reviewing, or packaging contract-for-deed seller documents from a real estate project spreadsheet, including buyer-specific transaction folders, Credit Worthiness handoffs, closing document checklists, affidavits, the 320 Rose package, and future similar Buy Your Home seller document packages.
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

1. Identify the buyer-specific transaction folder when the task is buyer-specific.
2. Read `TRANSACTION.md` and any Credit Worthiness handoff before compiling closing documents or buyer-specific affidavits.
3. Check the output folder for Word lock files: `~$*.docx`.
4. Compare each draft output timestamp against its prototype.
5. If any draft is newer than its prototype, inspect it for generated review blocks.
6. Save clean newer drafts as the current prototype before regenerating. Do not preserve generated attorney-review notes as template content.
7. Refresh the staged project spreadsheet from the live project spreadsheet.
8. Read document values from the workbook `Docs` worksheet only. If a value is calculated elsewhere in the workbook, it must be exposed as a `Docs` field before the document generator uses it.
9. Regenerate the standard clean draft files, overwriting the existing drafts unless Wes asks for revision copies.
10. Verify clean drafts contain no generated attorney-review or management-review blocks.
11. Verify key values from the `Docs` worksheet appear in the generated documents.
12. Report output file locations and elapsed time for each major task.

## Buyer Transaction Folders

Use a transaction folder for buyer-specific work:

`C:\Codex\Wiki Files\Project Rooms\Contract for Deed\transactions\<Property> - <Buyer>\`

Each transaction folder should include:

- `TRANSACTION.md` for property, buyer, seller, spreadsheet, package scope, and linked CWE report/handoff.
- `handoffs\credit-worthiness\Credit Worthiness Handoff.md` for the current CWE handoff.
- `output\clean\` for transaction-specific clean signing copies when the package is moved out of the legacy top-level `output\` folder.
- `output\attorney-review\` for attorney-review copies.
- `output\closing-checklist\` for closing checklist outputs.

During the 320 Rose transition, the existing top-level `source`, `reference`, `working`, and `output` folders remain the active script/prototype locations. Still use the buyer transaction folder for cross-skill handoffs, buyer-specific checklist work, and transaction metadata.

## Credit Worthiness Handoff

Before producing buyer-specific closing documents or affidavits, read the CWE handoff if present. Treat it as an input, not as the source of contract terms.

The handoff may provide:

- buyer legal names and roles,
- credit decision/status,
- affidavit requirements and purpose,
- funds-to-close status,
- underwriting assumptions,
- unresolved legal/compliance items,
- source report path and cutoff date.

Use the project spreadsheet `Docs` worksheet and document prototypes for contract terms, property data, seller data, and document formatting. If the handoff conflicts with the spreadsheet or prototype, log the conflict and ask Wes or counsel only when the conflict would affect a signed document.

## Affidavit Ownership

Credit Worthiness Evaluator identifies affidavit needs. Contract for Deed produces signature-ready affidavits when the affidavit belongs in the contract, closing, or attorney-review package.

For each affidavit request, confirm:

- purpose and gap addressed,
- required/recommended/optional status,
- signer and signer capacity,
- facts to be sworn or acknowledged,
- notary requirement,
- whether the affidavit is underwriting-only or closing-package material,
- source used for names, entity capacity, and transaction terms.

Do not convert underwriting-only affidavits into closing documents unless Wes or counsel asks for that treatment.

## 320 Rose Current Paths

For the current 320 Rose package:

- Transaction folder: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\transactions\320 Rose Pl - Ever Cardoza`
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
- Document generators must read contract values from the `Docs` worksheet, not directly from other workbook tabs. Add/correct `Docs` fields when new values are needed.
- Earnest money paid at contract signing comes from `Selling Earnest Money:` on the `Docs` worksheet. Do not use buying-side `BinderDeposit` / `Binder Deposit:` fields for seller documents.
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
3. Commit and push the Admin wiki changes.
4. Do not sync the installed local skill merely because project-room scripts, prototypes, or drafts changed. Sync after the new prototypes/workflow are completed, or when Wes explicitly asks to update the installed skill.
