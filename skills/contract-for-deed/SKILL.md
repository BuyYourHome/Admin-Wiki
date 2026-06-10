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

## Discussion Before Action

Treat Wes's questions, process-design discussion, and sequences of instructions as discussion-only until Wes clearly says to act. Do not make file changes, start or restart CWE, delete handoffs, regenerate documents, sync skills, commit, push, send emails, or run external workflow actions merely because Wes is describing what he wants.

Proceed only after an explicit action instruction such as `proceed`, `implement`, `do it`, `make the change`, `run it`, `start`, or another clear instruction to act.

If Wes says to write or implement one specific rule, keep the work limited to that rule and do not expand into related process changes unless he separately authorizes them.

## Installed Skill And Development Mode

Default operational mode is to use the current installed skill from `%USERPROFILE%\.codex\skills\contract-for-deed\SKILL.md`.

When acting in an existing chat after a skill update, reread the relevant installed skill before acting if the installed copy is expected to be current. A new chat should use the synced installed skill when the skill triggers.

If Wes says `do not use compiled skills`, `do not use installed skills`, or similar, treat the task as process-development mode. In process-development mode, reason from the current discussion and canonical source files instead of assuming the installed runtime copy controls.

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
11. If the Spanish flag is active, generate the Spanish/bilingual deliverables described in the Spanish Translation Flag section after the standard English clean drafts are current.
12. Verify clean drafts contain no generated attorney-review or management-review blocks.
13. Verify key values from the `Docs` worksheet appear in the generated documents.
14. Report output file locations and elapsed time for each major task.

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

## Visible Chat Routing

Run CFD work in the regular visible `Contract for Deed` chat whenever possible. Run CWE work in the regular visible `Credit Worthiness Evaluator` chat whenever possible.

If a CFD request starts in another chat, route or message the regular visible CFD chat instead of carrying out the CFD process in a hidden or projectless delegated thread. If the visible CFD chat cannot be found or messaged, tell Wes and wait for direction.

If CFD needs CWE, message the regular visible `Credit Worthiness Evaluator` chat with the minimal file-based kickoff request. Do not spawn hidden/projectless delegated CWE threads for normal CFD/CWE coordination. If a new CWE chat is truly needed, ask Wes first and make sure it will be visible and inspectable.

## Teams Copy Rule

Keep all source files, prototypes, scripts, handoffs, working drafts, clean outputs, attorney-review outputs, and checklist outputs in the Contract for Deed project room. Also copy current buyer-specific deliverables to the matching Teams property buyer folder so Wes can find and share them from the property file.

Use the Teams buyer folder pattern:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\<Property Project>\Selling\<Buyer>\Contract Package\`

Recommended subfolders:

- `Clean Package\` for current clean signing/review copies.
- `Attorney Review Package\` for current attorney-review copies and ZIPs.
- `Closing Checklist\` for buyer-specific checklist outputs.
- `Affidavits\` for closing-package affidavits.

Copy project-room outputs to Teams after each requested regeneration or package update unless Wes says project-room only. The project-room copy remains authoritative. If a Teams copy is edited and Wes says to keep those edits, bring that edited file back into the project room and apply the normal edit-preservation/prototype rule before regenerating.

Do not copy scratch files, extracted text, rendered QA images, logs, staged spreadsheets, prototypes, or temporary working files to Teams. Do not use Teams copies as the source for regeneration unless Wes identifies a Teams-edited file as the version to preserve.

## Credit Worthiness Handoff

For every buyer-specific CFD startup, check the matching transaction folder for the current CWE handoff before messaging CWE:

`transactions\<Property> - <Buyer>\handoffs\credit-worthiness\Credit Worthiness Handoff.md`

If the handoff exists, read and use it. Do not call CWE again merely because a `CWE Kickoff.md` file also exists. The handoff is the current cross-skill input and the kickoff never replaces it.

Do not delete, refresh, or ignore an existing handoff unless Wes says it is stale, aborted, or should be regenerated. If Wes does say to delete or regenerate the handoff, remove the stale handoff first, then restart CWE through the file-based kickoff process.

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

When Wes starts a new buyer-specific Contract for Deed matter for a verified project and no current CWE handoff exists in the transaction folder, use the verified project spreadsheet as the active-buyer source and get CWE started instead of treating the missing handoff as a blocker.

Use this rule when:

- the task is for a real buyer-specific sale or closing package,
- the project/property has been verified,
- the project spreadsheet identifies the current buyer or buyers,
- no current `Credit Worthiness Handoff.md` exists in the transaction folder,
- Wes has not asked for draft-only documents that intentionally bypass underwriting.

In that situation:

1. Create or update the buyer transaction folder from the spreadsheet buyer/property fields.
2. Create or update the file-based CWE kickoff described below.
3. Message the regular visible Credit Worthiness Evaluator chat with a minimal instruction to process the pending file-based CFD kickoff from the project files.
4. Establish a visible handoff check plan before pausing CFD work.
5. Tell Wes that CWE has been started and that its report/handoff will identify missing buyer files.
6. Do not represent the buyer as approved until the CWE handoff or report supports that result.

Because Wes normally works one active buyer prospect at a time and updates the verified project spreadsheet when the prospect changes, the spreadsheet buyer fields are the default current-buyer source after project verification. If the spreadsheet buyer conflicts with a named buyer in the request or multiple buyer folders appear active, ask Wes before starting CWE.

## CWE File-Based Kickoff

Do not pass buyer, seller, payment, affidavit, or transaction facts to CWE in the kickoff prompt. CWE owns the rule to derive those facts from the verified project spreadsheet and durable project files.

When a CWE handoff is missing and CWE should get started, write a kickoff file in the transaction folder:

`handoffs\credit-worthiness\CWE Kickoff.md`

The kickoff file should contain only routing/source-control information:

- verified project/property name,
- live project spreadsheet path,
- CFD transaction folder path,
- required CFD handoff destination,
- date/time of kickoff.

The kickoff file is only a pointer file; the CWE skill and project-room instructions define how CWE evaluates files and derives facts.

Then message CWE with a minimal prompt such as:

`Please process the pending file-based CFD kickoff under your current Credit Worthiness Evaluator rules. Do not push unless Wes explicitly asks.`

If Wes says to start the process as a new buyer, use this prompt:

`Please process the pending file-based CFD kickoff as a new-buyer restart under your current Credit Worthiness Evaluator rules. Do not push unless Wes explicitly asks.`

Do not include spreadsheet values, buyer names, payment amounts, seller names, source-folder guesses, affidavit conclusions, or CWE operating rules in the CWE prompt. If CWE cannot act from the short prompt plus the kickoff file, update the CWE skill rules instead of making the CFD prompt longer.

## Handoff Watch And No Auto-Restart

A handoff file is durable communication, not automatic notification. If CFD starts CWE, CFD must not assume it will be notified when CWE finishes.

After messaging CWE, CFD must create a visible follow-up check in the same CFD chat when the app supports it. The check should inspect the expected `Credit Worthiness Handoff.md` path every 2-5 minutes until one of these occurs:

- the handoff appears,
- CWE reports a blocker,
- Wes pauses or stops the process,
- or a reasonable timeout is reached.

CFD must not rely on Wes to manually prompt the handoff check. If no follow-up/check mechanism is available, disclose that before starting CWE and ask whether to proceed without monitoring.

When the handoff appears, notify Wes that the handoff is ready, summarize the readiness result, and continue the CFD package.

Do not automatically regenerate documents merely because CWE created a handoff.

## Fresh Evaluation Restart

If Wes says to `start the process as a new buyer`, restart as if the buyer has not been evaluated. First verify the project. After project verification, delete or move aside the current CFD handoff if one exists.

Then message the regular visible CWE chat with the short new-buyer restart prompt from the kickoff section. Do not restate CWE's evidence rules in the prompt; CWE owns those rules.

## Affidavit Ownership

Credit Worthiness Evaluator owns the substantive drafting of creditworthiness, funds, rent-history, receipt-review, business-judgment, and underwriting-support affidavits. Contract for Deed packages those CWE-authored affidavits when they belong in the contract, closing, or attorney-review package.

When a CWE handoff lists affidavit package items, treat those affidavits as CWE-authored documents. Do not rewrite them from summary metadata and do not generate substitute affidavits from metadata-only handoff rows.

For each affidavit item in the CWE handoff, verify:

- the affidavit title,
- file name,
- full file path,
- that the file exists at that path,
- that the file is a DOCX affidavit draft,
- whether it is intended as a closing-package deliverable,
- signer and signer capacity,
- required/recommended/optional status,
- notary requirement,
- known conflicts or cautions to carry into the closing checklist.

If the CWE-provided affidavit file exists, copy it into the buyer transaction folder under `output\affidavits\` as the package record copy and copy it to the matching Teams buyer folder under `Contract Package\Affidavits\` when package deliverables are copied to Teams.

CFD may make only package-level changes unless Wes specifically approves substance edits. Package-level changes include file naming consistency, placement in the correct CFD transaction folder, copying to the correct Teams folder, checklist updates, and clearly authorized formatting or notary-block standardization.

CFD must not:

- convert CWE affidavit wording into technical handoff language,
- replace first-person sworn statements with summary statements,
- change who is swearing to which facts,
- remove limitation or caution language,
- change signer capacity,
- change required/recommended/optional status,
- treat missing affidavit files as ready for packaging,
- generate substitute affidavits from metadata-only handoff rows.

If an affidavit listed in the handoff is missing from the provided path, mark it as missing on the closing checklist and report the missing file to Wes.

If the affidavit text conflicts with the current project spreadsheet, contract terms, or another source document, do not silently resolve the conflict. Flag the conflict and either preserve the affidavit as received or wait for direction, depending on whether the conflict affects a signed statement.

If the handoff identifies an affidavit as still needing attorney/compliance review, CFD may package it as a draft but must keep that status visible in the closing checklist.

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

## Version Prefix Rule

Generated buyer-specific package files should use a version prefix before the existing descriptive file name. The default first version is:

`v01 - <existing descriptive file name>`

For example:

`v01 - 320 Rose - Contract for Deed Agreement - DRAFT.docx`

Use the same version-prefixed names in the project-room output folder and the Teams delivery mirror. Each generated delivery run should create the next available version number, such as moving from `v01 -` to `v02 -`, then `v03 -`. Do not overwrite an existing version-prefixed delivery file unless Wes explicitly instructs Codex to replace that exact version.

Do not add version prefixes to prototypes, staged spreadsheets, source files, scripts, handoffs, temporary files, or other non-delivery working files unless Wes gives a separate instruction.

## Spanish Translation Flag

Wes may invoke the Spanish translation mode by saying `Spanish flag`, `Spanish version`, `bilingual version`, `Spanish contract`, or similar when starting or rerunning CFD.

The Spanish flag can be supplied by Wes's chat instruction. A spreadsheet field is not required for the flag to apply. If a future `Docs` worksheet field is added for Spanish/bilingual output, an explicit chat instruction from Wes controls for that run.

The Spanish flag is additive. It does not replace the normal English package and does not alter the English signing copies. First generate or confirm the current English clean package, then create separate Spanish/bilingual deliverables.

For the first implementation, the Spanish flag applies to the Contract for Deed Agreement only unless Wes explicitly expands the scope. The default output name is:

`<Property> - Contract for Deed Agreement - BILINGUAL SPANISH DRAFT.docx`

Save the bilingual output in the project-room output folder and copy it to the matching Teams buyer folder under:

`Contract Package\Spanish Package\`

The current project-room generator for the Spanish Contract for Deed deliverable is:

`C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\generate_spanish_contract.py`

Before rerunning Spanish output, inspect that generator and confirm it implements the current Spanish Translation Flag rules in this skill. If the Spanish rules have changed, update the generator script before rerunning the Spanish output. Do not assume the script automatically changed merely because this skill source changed.

Spanish translation rules:

- Keep the English text, numbering, paragraph order, and formatting intact.
- Insert the Spanish translation immediately below each eligible English paragraph text.
- Spanish translation paragraphs must be blue, smaller than the English body text, and use a dedicated non-numbered style.
- If the English paragraph is centered by direct paragraph formatting or by its Word style, center the Spanish translation paragraph as well.
- For centered English paragraphs, do not apply a left or right indent to the Spanish translation paragraph in a way that pulls it off center.
- For ordinary non-centered translated paragraph text, start the Spanish translation 4 points to the right of the English text it translates. Calculate this offset from the English paragraph's actual visual start, including direct paragraph indentation and style-based indentation. Do not use Word's `right indent` setting for this purpose, because right indent changes the right edge rather than moving the paragraph start to the right.
- Spanish paragraphs must not be part of any Word numbered-list structure.
- Do not insert the English-control notice in English into the bilingual body. Insert only the Spanish-language English-control notice, place it immediately above the actual visible numbered paragraph 2, currently `2. Date of Agreement: This Contract for Deed is made and effective as of the date of the last signature set forth below each party's signature.`, and format it bold, blue, and 12 point. If Wes refers to a paragraph by number, locate the actual visible numbered paragraph in the Word document rather than mapping the number to a nearby section label.
- Translate ordinary paragraph text and main numbered/heading paragraphs, including a section heading paragraph that contains explanatory text.
- Do not translate itemized lists, checkbox lists, payment schedules, table-like rows, address blocks, names, standalone factual identifiers, or structured/listed content unless Wes specifically requests translation for that section.
- If a section begins with a numbered/heading paragraph followed by itemized or structured content, translate the main numbered/heading paragraph but leave the list or structured rows below it untranslated unless Wes specifically requests otherwise. For example, translate `ADDITIONAL CHARGES AND FEES: Purchaser agrees...`, but do not translate the checkbox/payment-responsibility list below it unless requested.
- Use paragraph 7, `Installment Payments`, as the layout model for structured payment content: keep the table/values intact and avoid line-by-line Spanish duplication that clutters or moves the layout.
- Do not add Spanish text inside tables.
- Do not add Spanish text in signature blocks.
- Do not add Spanish text in notary blocks.
- Do not add Spanish text to signature lines, initials, acknowledgment blanks, or notary certificate language.
- Do not change paragraph numbers to accommodate Spanish text.
- Mark the Spanish text as a draft convenience translation unless Wes, counsel, or a qualified translator approves final translation wording.
- Do not represent the Spanish version as a certified legal translation unless Wes provides that certification or explicitly instructs that a certified translator has approved it.

Eligibility rules:

- Translate ordinary contract body paragraphs and main numbered/heading section text.
- Skip itemized/listed content, checkbox lists, payment schedules, table-like rows, address blocks, names, standalone factual identifiers, table content, signature blocks, notary blocks, initials/signature blanks, attorney-review blocks, management-review blocks, and generated package metadata unless Wes specifically requests translation for that content.
- Do not infer paragraph numbers from nearby labels. Use the actual document structure and visible numbering before placing, removing, or skipping Spanish text based on a numbered paragraph reference.
- The latest accepted Spanish draft direction is to translate main paragraph/section text while leaving lists, tables, address blocks, names, and structured content untranslated unless Wes specifically requests that content. Future Spanish edits should adjust placement, indentation, and scope without reverting that overall direction.
- Once a signature section or notary section begins, do not insert Spanish text below later paragraphs unless a future document-specific rule says otherwise.

Before delivering a Spanish/bilingual document, verify:

- English paragraph numbering is unchanged from the English clean draft.
- No Spanish text appears in tables, signature blocks, notary blocks, or blanks.
- No Spanish text appears in itemized/listed content, checkbox lists, payment schedules, table-like rows, address blocks, names, or standalone factual identifiers unless Wes specifically requested that translation.
- Spanish text is blue and smaller than the English text.
- The Spanish-only English-control notice is present above the actual visible numbered paragraph 2 / Date of Agreement paragraph and is bold, blue, and 12 point.
- The draft translation / review status is visible.
- The English clean draft remains unchanged.

## Skill Maintenance

Canonical skill source lives in the wiki under `C:\Codex\Wiki Files\skills`. Installed local copies under `%USERPROFILE%\.codex\skills` are generated copies.

When Wes says `write the rules to skill source` or similar, interpret that as permission to write only the skill-source rules for the current process being discussed. Do not modify unrelated skills, project files, scripts, outputs, handoffs, or documents unless Wes names them.

This Contract for Deed chat owns `C:\Codex\Wiki Files\skills\contract-for-deed\SKILL.md`. Do not edit `skills\credit-worthiness-evaluator\SKILL.md` from this chat unless Wes explicitly authorizes editing the CWE skill too. If a proposed CFD/CWE coordination rule requires a CWE-side change, keep it as a proposed CWE rule and tell Wes it should be written from the Credit Worthiness Evaluator chat, unless Wes authorizes editing both skills.

When changing this skill:

1. Make the change in the wiki copy first.
2. If project-room scripts or instructions change, update the project room at the same time.
3. Commit the Admin wiki changes locally when the durable rule update is complete.
4. Do not sync the installed local skill merely because canonical source changed. Sync only when Wes explicitly asks to sync, install, or make the updated skill active.
5. Do not push unless Wes explicitly asks to push or says the update is finished and ready to publish.
