---
name: contract-for-deed
description: Use when refreshing, regenerating, reviewing, or packaging contract-for-deed seller documents from a confirmed real estate project spreadsheet, including buyer-specific transaction folders, Credit Worthiness handoffs, closing document checklists, affidavits, and Buy Your Home seller document packages.
---

# Contract For Deed

## Source Of Truth

Use the Admin wiki as the source of truth.

- Wiki repository: `C:\Codex\Wiki Files`
- Current project room: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed`
- Current project room instructions: `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\PROJECT-ROOM.md`

This skill is a reusable workflow wrapper. It is not tied to one property or buyer. Project-specific source files, prototypes, generated outputs, and history stay in the confirmed project room. For buyer-specific Contract for Deed work, copy current deliverables to the matching Teams buyer folder as a delivery mirror; do not use Teams as the working source.

## Required Startup

Before file work:

1. Confirm the working folder with `Get-Location`.
2. If it is not `C:\Codex\Wiki Files`, use `C:\Codex\Wiki Files` explicitly as the shell workdir and use absolute paths under `C:\Codex\Wiki Files`.
3. Read `Admin Home.md`, `AGENTS.md`, `Repository Location Rule.md`, `Codex Skill Source Rule.md`, and the active project room `PROJECT-ROOM.md`.
4. Check `git status --short --branch`.

## Core Workflow

Use this workflow when Wes asks to refresh or recreate contract-for-deed sale documents.

1. Verify the project before acting. You may propose the last active CFD project, but do not proceed until Wes confirms it remains the project to use.
2. Identify the confirmed project spreadsheet and buyer-specific transaction folder when the task is buyer-specific.
3. Read `TRANSACTION.md` and any Credit Worthiness handoff before compiling closing documents or buyer-specific affidavits.
4. Check the output folder for Word lock files: `~$*.docx`.
5. Compare each draft output timestamp against its prototype.
6. If any draft is newer than its prototype, inspect it for generated review blocks.
7. Save clean newer drafts as the current prototype before regenerating. Do not preserve generated attorney-review notes as template content.
8. Refresh the staged project spreadsheet from the live project spreadsheet.
9. Read document values from the workbook `Docs` worksheet only. If a value is calculated elsewhere in the workbook, it must be exposed as a `Docs` field before the document generator uses it.
10. Regenerate the standard clean draft files, overwriting the existing drafts unless Wes asks for revision copies.
11. Verify clean drafts contain no generated attorney-review or management-review blocks.
12. Verify key values from the `Docs` worksheet appear in the generated documents.
13. Report output file locations and elapsed time for each major task.

## Project Verification Rule

Always verify the project before starting a new buyer-specific CFD process, refreshing a package, or kicking off CWE.

Verification can come from:

- Wes naming the project/property in the request,
- Wes providing the live project spreadsheet path,
- Wes confirming a project that Codex proposes from nearby context or the last active CFD project.

If the request does not name a project, propose the last active CFD project if one is clear, and ask Wes to verify it remains the project to use. Do not treat the current chat's prior project as enough by itself, and do not proceed with file work or message CWE until Wes verifies the project. After the project is verified, use that project's spreadsheet `Docs` worksheet as the buyer/source-of-truth input.

For example, if Wes says only `start the CFD process`, respond in substance: `I am assuming the last active CFD project is 320 Rose. Please confirm that is still the project to use.` If Wes says `start the CFD process for 320 Rose`, proceed and read the 320 Rose spreadsheet buyer fields.

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

## Teams Copy Rule

Keep all source files, prototypes, scripts, handoffs, working drafts, clean outputs, attorney-review outputs, and checklist outputs in the Contract for Deed project room. Also copy current buyer-specific deliverables to the matching Teams property buyer folder so Wes can find and share them from the property file.

Use the Teams buyer folder pattern:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\<Property Project>\Selling\<Buyer>\Contract Package\`

Recommended subfolders:

- `Clean Package\` for current clean signing/review copies.
- `Attorney Review Package\` for current attorney-review copies and ZIPs.
- `Closing Checklist\` for buyer-specific checklist outputs.
- `Affidavits\` for CFD-generated closing-package affidavits.

Copy project-room outputs to Teams after each requested regeneration or package update unless Wes says project-room only. The project-room copy remains authoritative. If a Teams copy is edited and Wes says to keep those edits, bring that edited file back into the project room and apply the normal edit-preservation/prototype rule before regenerating.

Do not copy scratch files, extracted text, rendered QA images, logs, staged spreadsheets, prototypes, or temporary working files to Teams. Do not use Teams copies as the source for regeneration unless Wes identifies a Teams-edited file as the version to preserve.

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

## CWE Readiness Status Rule

Do not treat a CWE `conditional` label as an automatic stop. Separate the credit/evaluation status from CFD package readiness.

Read the CWE handoff for two distinct decisions:

1. Can CFD prepare documents?
2. What must be completed before final closing/execution?

Use these readiness meanings:

- `Not ready for documents`: core underwriting or identity facts are missing. Do not prepare closing documents except rough drafts if Wes explicitly asks.
- `Ready for document preparation`: buyer appears supportable enough for CFD to prepare the package, but listed items still need to be signed, notarized, verified, or reviewed.
- `Ready for closing execution`: final package can be used for closing, with listed closing deliverables to be completed at signing/closing.
- `Closed / completed`: required documents have been signed/notarized and copied, recorded, or delivered as applicable.

If the handoff says affidavits are required but expected to be signed/notarized at closing, treat those affidavits as closing deliverables, not blockers to document preparation.

When the file is ready for document preparation, CFD may prepare the closing package before the affidavits are signed or notarized, provided the closing checklist clearly lists the affidavits and other unresolved items. Do not label the file `closed`, `complete`, `final approval complete`, or equivalent until the required closing deliverables are actually completed.

For 320 Rose / Ever Cardoza, if the handoff says `Ready for document preparation; closing execution subject to required affidavits, funds proof, name/role confirmation, and attorney/compliance review`, proceed with document preparation and carry those items into the closing checklist.

## Missing Handoff Startup Rule

When Wes starts a new buyer-specific Contract for Deed matter for a verified project and no CWE handoff exists, use the verified project spreadsheet as the active-buyer source and get CWE started instead of treating the missing handoff as a blocker.

Use this rule when:

- the task is for a real buyer-specific sale or closing package,
- the project/property has been verified,
- the project spreadsheet identifies the current buyer or buyers,
- no current `Credit Worthiness Handoff.md` exists in the transaction folder,
- Wes has not asked for draft-only documents that intentionally bypass underwriting.

In that situation:

1. Create or update the buyer transaction folder from the spreadsheet buyer/property fields.
2. Create or update the file-based CWE kickoff described below.
3. Start or message a Credit Worthiness Evaluator thread with a minimal instruction to process the pending file-based CFD kickoff from the project files.
4. Tell Wes that CWE has been started and that its report/handoff will identify missing buyer files.
5. Do not represent the buyer as approved until the CWE handoff or report supports that result.

Because Wes normally works one active buyer prospect at a time and updates the verified project spreadsheet when the prospect changes, the spreadsheet buyer fields are the default current-buyer source after project verification. If the spreadsheet buyer conflicts with a named buyer in the request or multiple buyer folders appear active, ask Wes before starting CWE.

## CWE File-Based Kickoff

Do not pass buyer, seller, payment, affidavit, or transaction facts to CWE in the kickoff prompt. Let CWE derive those facts from the verified project spreadsheet and durable project files.

When a CWE handoff is missing and CWE should get started, write a kickoff file in the transaction folder:

`handoffs\credit-worthiness\CWE Kickoff.md`

The kickoff file should contain only routing/source-control information:

- verified project/property name,
- live project spreadsheet path,
- CFD transaction folder path,
- required CFD handoff destination,
- date/time of kickoff,
- instruction that the project spreadsheet and durable project files control all buyer, seller, payment, affidavit, and transaction facts.

Then message CWE with a minimal prompt such as:

`Please process the pending file-based CFD kickoff from the Contract for Deed project files. Derive all buyer, seller, payment, source-folder, affidavit, and transaction facts from the files. If the files do not provide enough context, report exactly what is missing.`

Do not include spreadsheet values, buyer names, payment amounts, seller names, source-folder guesses, or affidavit conclusions in the CWE prompt. If CWE needs those details, it must read them from the kickoff file, project spreadsheet, transaction metadata, project-room instructions, or other durable source files.

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
