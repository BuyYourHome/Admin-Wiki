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
4. Before running Python project-room scripts, follow `Codex Python Runtime Rule.md`; use the Codex workspace Python executable instead of bare `python`.
5. Check `git status --short --branch`.

## Discussion Before Action

Treat Wes's questions, process-design discussion, and sequences of instructions as discussion-only until Wes clearly says to act. Do not make file changes, start or restart CWE, delete handoffs, regenerate documents, sync skills, commit, push, send emails, or run external workflow actions merely because Wes is describing what he wants.

Proceed only after an explicit action instruction such as `proceed`, `implement`, `do it`, `make the change`, `run it`, `start`, or another clear instruction to act.

If Wes says to write or implement one specific rule, keep the work limited to that rule and do not expand into related process changes unless he separately authorizes them.

## Installed Skill And Development Mode

Default operational mode is to use the current installed skill from `%USERPROFILE%\.codex\skills\contract-for-deed\SKILL.md`.

When acting in an existing chat after a skill update, reread the relevant installed skill before acting if the installed copy is expected to be current. A new chat should use the synced installed skill when the skill triggers.

If Wes says `do not use compiled skills`, `do not use installed skills`, or similar, treat the task as process-development mode. In process-development mode, reason from the current discussion and canonical source files instead of assuming the installed runtime copy controls.

## Operating Modes

CFD work should be understood in these operating modes:

1. **Full English Package**
   Confirm the project and buyer, refresh the project spreadsheet, check/read the current CWE handoff, start CWE if a current handoff is missing and the workflow calls for it, use the handoff to identify closing-package items, read affidavit/support documents already created and stored in Teams by CWE, regenerate the clean Contract for Deed Agreement, Memorandum, Promissory Note, Term Sheet, Buyer Acknowledgment Addendum, Amortization Chart PDF, and include the closing checklist / cover page. Produce versioned project-room outputs and versioned Teams copies for CFD-created deliverables.

2. **Attorney Review Package**
   Create attorney-review versions with contextual review blocks. Produce versioned project-room outputs and versioned Teams copies.

3. **Spanish Add-On**
   Generate the bilingual Spanish Contract for Deed Agreement only, unless Wes explicitly expands the Spanish scope. This mode is additive and does not run the full English package unless Wes asks for the full package too. Produce versioned project-room output and versioned Teams copy.

4. **Email Package**
   Prepare a package email to Wes only so Wes can review and forward it himself. When Wes says `Email Package`, assume the last project/buyer being processed, but confirm that project and buyer with Wes before preparing or sending anything. The email body should include the format and content of the Closing Checklist and list package files as clickable Teams/SharePoint links when those links can be generated from the Teams-synced file paths. Build one complete package ZIP containing every file listed in the Closing Checklist, unless Wes explicitly asks for individual attachments for that specific run. If any listed file is missing or cannot be included in the ZIP, do not silently omit it and do not send a partial package; report the missing file before sending. Use the `email-delivery` skill for OfficeAssist sender safety, attachment upload handling, delivery, and sent-item verification. Never send the package email directly to outside parties, buyers, attorneys, agents, Jenny, or anyone else unless Wes later creates a separate explicit rule changing that restriction.

5. **Maintenance**
   Update canonical CFD skill rules and/or project-room generator scripts, keep scripts aligned with skill rules, sync the installed Codex skill when requested, and commit or push only under the normal Admin wiki rules.

Teams delivery is not a standalone mode. Every mode that creates or updates a delivery document should place a versioned copy in the appropriate Teams buyer folder unless Wes says project-room only.

Checklist/cover-page handling is not a standalone mode. It belongs inside Full English Package mode.

Affidavit packaging is not a standalone CFD output mode. CFD reads, references, and packages around affidavit/support documents created and stored in Teams by CWE; CFD should not reauthor or generate affidavit outputs unless Wes explicitly changes that division of responsibility.

## Email Package Delivery

When sending a CFD Email Package:

1. Confirm the project and buyer before preparing or sending anything.
2. Use the Closing Checklist / cover-page content as the email body.
   - When package-file links are included, build an HTML email body so each link displays as the file name instead of showing the full SharePoint URL.
   - Use the reference card-style cover-page layout from `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\reference\email-format-reference\DRAFT_ 320 Rose _ Ever Cardoza cover page body test.html`: light page background, centered white card, blue header rule, readiness table, clean section headings, normal bullet lists, and affidavit/support blocks.
   - Preserve the friendly cover-page structure in the email body: current readiness, current document package, required closing deliverables, funds and identity items, and attorney/compliance review items.
   - Display package links as short document labels, such as `Contract for Deed Agreement`, `12 Month Amortization Chart`, and `Attorney-review package`, instead of full filenames or full SharePoint URLs.
   - Do not add a repeated metadata footer after the attorney/compliance section listing the ZIP, property address, buyer names, or seller name.
   - Do not use a plain-text-only send path when Wes has asked for clean display links; plain text may expose long SharePoint URLs and lose the polished checklist formatting.
3. Verify every file listed in the Closing Checklist exists and is readable, including the Amortization Chart PDF.
4. Put every checklist-listed package file in the Teams `Clean Package` folder before building the email body, including the polished closing cover page/checklist output and package copies of CWE-authored affidavit/support documents.
5. Generate clickable Teams/SharePoint links from the Teams `Clean Package` paths and include those links next to the listed package files in the email body when possible.
6. Build one complete package ZIP containing every checklist-listed file unless Wes explicitly asks for individual attachments for that run.
7. Verify the ZIP was created and is readable before sending.
8. Send to `WesWill@BuyYourHomeLLC.com` only so Wes can review and forward it himself.
9. Send from `OfficeAssist@BuyYourHomeLLC.com`.
10. Use a subject beginning with `DRAFT:` unless Wes provides a different review-submission subject for that specific run.
11. Do not say the message is "on Wes's behalf" unless Wes explicitly asks for that wording for that specific message.
12. Call/use `email-delivery` for OfficeAssist sender safety, Outlook connector handling, attachment input format, Sent Items verification, local Outlook fallback rules, and failure handling.

Use the CFD Teams-link helper for link generation:

`C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\teams_link_from_local_path.py`

Use the CFD closing-package email-body builder for the polished HTML body:

`C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\build_closing_package_email_body.py`

The builder should produce both HTML and plain-text fallback body files in the Teams `Email Package` folder. If the builder is stale or missing a new package item, update the builder before sending the package email.

For routine email-format maintenance, follow the `CFD Email Package Maintenance` section in `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\PROJECT-ROOM.md` and avoid reworking the reference layout from scratch.

The helper reads the local OneDrive/Teams sync metadata and converts a local Teams-synced path, such as a file under `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\...`, into the matching SharePoint web URL. If the helper cannot map a file, do not invent a web link. In that case, list the exact filename and local Teams path, and report that link generation failed for that item.

If Wes asks for `Anyone with the link` or other external-access links, do not treat the Teams-link helper output as sufficient. Use the SharePoint plugin's sharing-link action to create actual anonymous view/read links for each displayed package file, or for the package ZIP/folder if Wes asks for a single package link. Do not create edit links unless Wes explicitly asks for edit access. Do not create broad property-folder sharing links. If no verified path can create and confirm permission-granting links, stop and report the blocker before sending an external-access email; ask Wes whether to create the sharing links manually or proceed with the ZIP attachment only.

When the Outlook connector only supports plain-text message bodies, do not use it for a linked/polished Email Package unless Wes explicitly accepts plain text for that run. Use a send path that supports HTML, normally local Outlook automation with `HTMLBody`, while still following `email-delivery` sender safety: send from `OfficeAssist@BuyYourHomeLLC.com`, send only to Wes, verify the draft/sender when possible, attach the complete package ZIP, and verify the sent copy in OfficeAssist Sent Items.

CFD must track two email send methods:

- **Plain-text OfficeAssist connector method:** use when the email body does not need hidden/display hyperlinks or polished HTML formatting. This method sends from `OfficeAssist@BuyYourHomeLLC.com` through the Outlook connector and verifies OfficeAssist Sent Items.
- **HTML cover-sheet email method:** use when sending the CFD cover-sheet / closing-package email with clean filename links. This method uses local Outlook automation with `HTMLBody`, displays each Teams/SharePoint link as the package file name, attaches the complete package ZIP, sends to Wes only, and verifies the sent copy in Sent Items. Because OfficeAssist is not mounted in local Outlook on Wes's current machine, this method uses `WesWill@BuyYourHomeLLC.com` as the sending account when Wes has authorized that sender for the run. Do not fall back to a plain-text connector email for the cover-sheet package merely because the connector is available.

For connector send tools, pass the package ZIP path in the attachment input shape the connector currently requires. If the connector rejects a plain path string and reports that it expects an array, retry with an attachment-path array. Do not pass newline-separated paths.

Do not send the CFD package email directly to outside parties, buyers, attorneys, agents, Jenny, or anyone else unless Wes later creates a separate explicit rule changing that restriction. If any checklist-listed file is missing, unreadable, or cannot be included in the ZIP, do not send the email; report the blocker and provide the proposed email body in the chat.

## Amortization Chart

The CFD closing package includes an Amortization Chart PDF.

When building or refreshing the Full English Package:

1. Confirm the active project spreadsheet path.
2. Call/use the `amortization` skill and its Amortization project-room generator. CFD must not generate the amortization chart itself.
3. Pass the amortization generator:
   - project/property name,
   - `project_spreadsheet_path`: the full path to the active project spreadsheet,
   - `caller_destination_folder`: the CFD buyer transaction destination folder where the finished Amortization Chart PDF should be copied,
   - `output_format`: `PDF` unless Wes specifically asks for the populated workbook too.
4. Require a PDF output for the CFD closing package unless Wes explicitly asks for a different format.
5. Use the returned/copied PDF path from Amortization. CFD should only package the returned PDF and list it on the closing checklist / cover page.
6. Do not place intermediate Amortization working XLSX files in the CFD project room by default.
7. Include the returned Amortization Chart PDF in the closing checklist / cover page, the project-room package output, the Teams buyer package folder, and the Email Package ZIP.

Use the project spreadsheet already verified for the CFD package. Do not ask Wes to re-enter loan terms that should be available from the project spreadsheet. If the amortization skill reports missing or ambiguous source data, carry that blocker into the CFD package report instead of creating a guessed amortization chart.

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

- `Clean Package\` for the current buyer-review/closing package file set, including clean signing/review copies, the Amortization Chart PDF, polished closing cover/checklist output, package copies of CWE-authored affidavit/support documents, and attorney-review files when the checklist/email package lists them.
- `Attorney Review Package\` for current attorney-review copies and ZIPs.
- `Closing Checklist\` for legacy or separately requested polished checklist / cover-page outputs only.
- `Affidavits\` for CWE-authored affidavit/support source copies when CWE writes them there; CFD should copy package copies into `Clean Package\` when building the buyer-review/closing package.

Copy project-room outputs to Teams after each requested regeneration or package update unless Wes says project-room only. The project-room copy remains authoritative. If a Teams copy is edited and Wes says to keep those edits, bring that edited file back into the project room and apply the normal edit-preservation/prototype rule before regenerating.

For buyer-review and Email Package use, keep the current package files together in the Teams `Clean Package` folder so the email body can link to one coherent package file set. Do not make Wes inspect separate `Affidavits`, `Closing Checklist`, or `Attorney Review Package` folders to find the files listed in the email package. When affidavits are CWE-authored, copying them into `Clean Package` is a package copy only; it does not transfer affidavit authorship or make CFD responsible for reauthoring them.

Keep `Closing Checklist.md` in the CFD project room as the working/source checklist. Do not copy `Closing Checklist.md` to Teams by default. In Teams, provide polished user-facing checklist or cover-page deliverables, such as `Closing Package Cover Page.docx` or future PDF versions. Copy the Markdown checklist to Teams only if Wes explicitly asks for a working/source copy there.

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

## Legal-Name Handoff Handling

CWE should verify buyer legal names from available source files and tell CFD either the verified legal names or a specific unresolved name issue. CFD should use verified names from the project spreadsheet, source IDs, and CWE handoff rather than asking Wes to confirm names manually.

Do not carry buyer legal-name spelling as an unresolved checklist item merely because a generic or older handoff caution says to confirm final legal spelling. Carry a legal-name issue into the CFD checklist only when CWE reports a specific unresolved name conflict, missing source document, or uncertainty that affects the signing documents.

If the handoff contains both specific verified-name findings and generic `confirm legal spelling` language, prefer the specific verification finding. Convert generic handoff cautions into closing-practical wording instead of repeating them as drafting blockers. Use wording such as `Confirm signer identity against ID at execution.` Do not phrase that as an unresolved legal-name spelling problem unless there is an actual unresolved conflict.

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

For 320 Rose / Ever Cardoza, if the handoff says `Ready for document preparation; closing execution subject to required affidavits, funds proof, name/role confirmation, and attorney/compliance review`, proceed with document preparation. If the handoff also specifically verifies buyer names and roles, do not repeat `name/role confirmation` as an unresolved drafting blocker; convert it to `Confirm signer identity against ID at execution.` in the closing checklist.

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

## Affidavit Handling

Credit Worthiness Evaluator owns the substantive drafting, creation, and Teams storage of creditworthiness, funds, rent-history, receipt-review, business-judgment, and underwriting-support affidavits.

Contract for Deed reads and references those CWE-authored affidavit/support documents when they belong in the contract, closing, or attorney-review package. Affidavit handling is part of Full English Package mode and is not a standalone CFD output mode.

When a CWE handoff lists affidavit package items, treat those affidavits as CWE-authored Teams-stored documents. Do not rewrite them from summary metadata, do not generate substitute affidavits from metadata-only handoff rows, and do not create CFD affidavit output files unless Wes explicitly changes that division of responsibility.

For each affidavit item in the CWE handoff, verify:

- the affidavit title,
- file name,
- full file path,
- that the file exists at that path,
- that the file is a DOCX affidavit draft,
- that the file is stored in the expected Teams affidavit location or another location explicitly provided by CWE,
- whether it is intended as a closing-package deliverable,
- signer and signer capacity,
- required/recommended/optional status,
- notary requirement,
- known conflicts or cautions to carry into the closing checklist.

If the CWE-provided affidavit file exists in Teams, leave the affidavit file in place and reference that Teams path in the closing checklist, cover page, package inventory, or handoff notes as needed. Do not copy the affidavit into a CFD `output\affidavits\` folder and do not copy it back to Teams as though CFD authored or produced it.

CFD may make only package-level references unless Wes specifically approves affidavit handling changes. Package-level references include listing the affidavit in the closing checklist, identifying its Teams path, carrying signer/notary/review status into package notes, and flagging missing files or conflicts.

CFD must not:

- convert CWE affidavit wording into technical handoff language,
- replace first-person sworn statements with summary statements,
- change who is swearing to which facts,
- remove limitation or caution language,
- change signer capacity,
- change required/recommended/optional status,
- move, rename, overwrite, or copy affidavit files unless Wes explicitly asks,
- treat missing affidavit files as ready for packaging,
- generate substitute affidavits from metadata-only handoff rows,
- create CFD affidavit output files as part of the normal package.

If an affidavit listed in the handoff is missing from the provided path, mark it as missing on the closing checklist and report the missing file to Wes.

If the affidavit text conflicts with the current project spreadsheet, contract terms, or another source document, do not silently resolve the conflict. Flag the conflict and either preserve the affidavit as received or wait for direction, depending on whether the conflict affects a signed statement.

If the handoff identifies an affidavit as still needing attorney/compliance review, CFD may reference it as a draft but must keep that status visible in the closing checklist.

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
- Do not insert the English-control notice in English into the bilingual body. Insert only the Spanish-language English-control notice, place it immediately above the actual visible numbered paragraph 2, currently `2. Date of Agreement: This Contract for Deed is made and effective as of the date of the last signature set forth below each party's signature.`, and format it bold, blue, and 12 point. Add clear paragraph spacing after the Spanish-language notice before the following `Date of Agreement` paragraph. If Wes refers to a paragraph by number, locate the actual visible numbered paragraph in the Word document rather than mapping the number to a nearby section label.
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
- The Spanish-only English-control notice is present above the actual visible numbered paragraph 2 / Date of Agreement paragraph, is bold, blue, and 12 point, and has clear spacing before the Date of Agreement paragraph.
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
