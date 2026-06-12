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
   Generate the bilingual Spanish Contract for Deed Agreement only, unless Wes explicitly expands the Spanish scope. This mode is additive and does not run the full English package unless Wes asks for the full package too. If Wes expands the Spanish scope to other documents, follow the document-specific Spanish rules in the Spanish Translation Flag section. Produce versioned project-room output and versioned Teams copy.

4. **Email Package**
   Prepare a package email to Wes only so Wes can review and forward it himself. When Wes says `Email Package`, assume the last project/buyer being processed, but confirm that project and buyer with Wes before preparing or sending anything. The email body should include the format and content of the Closing Checklist and list package files as clickable Teams/SharePoint links when those links can be generated from the Teams-synced file paths. Build one complete package ZIP containing every file listed in the Closing Checklist, unless Wes explicitly asks for individual attachments for that specific run. If any listed file is missing or cannot be included in the ZIP, do not silently omit it and do not send a partial package; report the missing file before sending. Use the `email-delivery` skill for OfficeAssist sender safety, attachment upload handling, delivery, and sent-item verification. Never send the package email directly to outside parties, buyers, attorneys, agents, Jenny, or anyone else unless Wes later creates a separate explicit rule changing that restriction.

5. **Maintenance**
   Update canonical CFD skill rules and/or project-room generator scripts, keep scripts aligned with skill rules, sync the installed Codex skill when requested, and commit or push only under the normal Admin wiki rules.

6. **CFD Total Update**
   Publish approved CFD process changes end to end. When Wes says `Run CFD Total Update`, write approved CFD rule/process changes to the canonical CFD skill source, update matching project-room rules when needed, commit the scoped durable CFD changes locally, run the Admin wiki Codex skill sync so the installed `%USERPROFILE%\.codex\skills\contract-for-deed` copy is current, push the scoped CFD rule/process commit or commits to GitHub, and report commit, sync, push, and elapsed-time status. This mode updates the CFD process itself; it does not regenerate the contract package unless Wes also asks for a package run.

Teams delivery is not a standalone mode. Every mode that creates or updates a delivery document should place a versioned copy in the appropriate Teams buyer folder unless Wes says project-room only.

Checklist/cover-page handling is not a standalone mode. It belongs inside Full English Package mode.

Affidavit packaging is not a standalone CFD output mode. CFD reads, references, and packages around affidavit/support documents created and stored in Teams by CWE; CFD should not reauthor or generate affidavit outputs unless Wes explicitly changes that division of responsibility.

When producing the Word closing document / closing checklist document, place a fill-in `Closing Date` field to the right of the prepared date near the top of the document. Leave the closing-date value blank for the attorney to complete and highlight the blank field yellow so it is visibly marked as needing completion.

## Email Package Delivery

When sending a CFD Email Package:

1. Confirm the project and buyer before preparing or sending anything.
2. Use the Closing Checklist / cover-page content as the email body.
   - When package-file links are included, build an HTML email body so each link displays as the file name instead of showing the full SharePoint URL.
   - Use the reference card-style cover-page layout from `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\reference\email-format-reference\DRAFT_ 320 Rose _ Ever Cardoza cover page body test.html`: light page background, centered white card, blue header rule, readiness table, clean section headings, normal bullet lists, and affidavit/support blocks.
   - Preserve the friendly cover-page structure in the email body: current readiness, current document package, required closing deliverables, funds and identity items, and attorney/compliance review items.
   - Start the body with this neutral first line before the package title/header: `Below is the current closing package cover page for review. The package ZIP is attached, and the document names below link to the package files.`
   - Do not personalize that first line with Wes's name because Wes may edit and forward the message.
   - In the email header, show a fill-in `Closing Date` field to the right of the prepared date. Leave the closing-date value blank for the attorney to complete and highlight the blank field yellow.
   - In the email readiness table, label any stop-issue row as `Closing Stop Issue`, not `CFD Stop`.
   - Display package links as short document labels, such as `Contract for Deed Agreement`, `12 Month Amortization Chart`, and `Attorney-review package`, instead of full filenames or full SharePoint URLs.
   - Do not add a repeated metadata footer after the attorney/compliance section listing the ZIP, property address, buyer names, or seller name.
   - Do not use a plain-text-only send path when Wes has asked for clean display links; plain text may expose long SharePoint URLs and lose the polished checklist formatting.
3. Verify every file listed in the Closing Checklist exists and is readable, including the Amortization Chart PDF.
4. Put every checklist-listed package file directly in the Teams `Contract Package` folder before building the email body, including the polished closing cover page/checklist output. Use `Contract Package\Affidavits\` as the current Teams location for CWE-authored affidavit/support documents.
5. Generate clickable Teams/SharePoint links from the Teams `Contract Package` paths and include those links next to the listed package files in the email body when possible.
6. Build one complete package ZIP containing every checklist-listed file unless Wes explicitly asks for individual attachments for that run.
7. Verify the ZIP was created and is readable before sending.
8. Send to `WesWill@BuyYourHomeLLC.com` only so Wes can review and forward it himself.
9. Send from `OfficeAssist@BuyYourHomeLLC.com`.
10. Do not prefix the CFD package email subject with `DRAFT:`. Use a neutral review-submission subject such as `<Property> - <Buyer> - Closing Package for Review` unless Wes provides a different subject for that specific run.
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

Include the current Credit Worthiness Report as a linked Email Package item when the current CWE handoff, transaction metadata, or CWE-produced package note identifies the latest report file name and path. Prefer the location provided by CWE over old project-room memories or version guesses. Display the link as `Credit Worthiness Report`, not the full file name. For external-access emails, create an anonymous view/read SharePoint sharing link for the report just like the other displayed package files. If the current handoff does not identify the latest report location, do not guess from prior versions; report that the CWE handoff is missing the latest report location and treat that as a proposed CWE-side rule update.

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
   - Treat `Docs` label/value pairs as the CFD source interface. Field labels may be placed in readable grouped blocks anywhere on `Docs`; read the value/formula from the cell immediately to the right of the recognized label.
   - For section 9 adverse conditions, prefer the three separate label/value fields `Adverse Conditions1`, `Adverse Conditions2`, and `Adverse Conditions3`; combine the nonblank values in order for the generated document.
   - Do not depend on the legacy horizontal `Docs` row 1 / row 2 field table. That area may be deleted or repurposed during spreadsheet refactoring.
10. Regenerate the standard clean draft files, overwriting the existing drafts unless Wes asks for revision copies.
11. If the Spanish flag is active, generate the Spanish/bilingual deliverables described in the Spanish Translation Flag section after the standard English clean drafts are current.
12. Verify clean drafts contain no generated attorney-review or management-review blocks.
13. Verify key values from the `Docs` worksheet appear in the generated documents.
14. Report output file locations and elapsed time for each major task.

## Run Optimization And Metrics

When Wes asks to benchmark, loop, stress-test, or improve CFD run efficiency:

1. Save metrics under the CFD project room, normally `working\run-metrics\<run-id>\`.
2. Record at least: run scope, script or workflow steps run, per-iteration seconds, per-step seconds, blockers, output verification status, and process-change candidates.
3. Distinguish core document-generation metrics from full production workflow metrics. A generator-only loop does not measure Teams copy/version/archive, amortization, closing cover/checklist, email, SharePoint link generation, Git, or skill sync.
4. Do not write every observation to canon immediately. Record candidate rule or script changes first, then write stable rules after repetition or Wes approval.
5. For repeated generator runs, use the CFD orchestration script instead of manually invoking separate document scripts:
   `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\run_cfd_generation.py`
6. For full production package runs, use the CFD full-package runner instead of manually composing generation, Teams copy, archive, and verification steps:
   `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\run_cfd_full_package.py`
7. The full-package runner should create a run manifest under `working\run-metrics\<run-id>\` that records the confirmed project/buyer when available, workbook path, transaction folder, Teams package root, output paths, package-copy results, archived paths, warnings, blockers, and verification status.
8. Use the shared package-delivery helper for Teams archive/copy/versioning:
   `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\working\package_delivery.py`
9. The full-package runner should include the current Amortization Chart PDF only from the Amortization workflow's returned/copied output. CFD may verify and package that PDF, but if the PDF is missing it should report the missing Amortization output rather than generating an amortization chart itself.
10. The full-package runner should prepare and verify the closing cover/checklist document. If the active Teams cover page is newer than the project-room source, preserve the newer Teams copy and report that warning in the manifest instead of silently overwriting it with an older source.
11. After the `Docs` layout stabilizes, prefer a label-location cache or manifest: verify expected labels at their mapped cells, read values from the mapped value cells, and rescan/report only when labels move.
12. If a run benchmark identifies a repeated blocker or safety issue, fix or write that rule before continuing further loops.

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

- the `Contract Package\` root for the current buyer-review/closing package file set, including clean signing/review copies, the Amortization Chart PDF, polished closing cover/checklist output, and attorney-review files when the checklist/email package lists them.
- `Affidavits\` for current CWE-authored affidavit/support documents used by the closing package.
- `Attorney Review Package\` for current attorney-review copies and ZIPs.
- `Closing Checklist\` for legacy or separately requested polished checklist / cover-page outputs only.

Copy project-room outputs to Teams after each requested regeneration or package update unless Wes says project-room only. The project-room copy remains authoritative. If a Teams copy is edited and Wes says to keep those edits, bring that edited file back into the project room and apply the normal edit-preservation/prototype rule before regenerating.

For buyer-review and Email Package use, keep the current package files together directly under the Teams `Contract Package` tree so the email body can link to one coherent package file set. Current affidavits belong in `Contract Package\Affidavits\`; do not put them loose in the `Contract Package` root. Do not make Wes inspect `Closing Checklist` or `Attorney Review Package` folders to find the files listed in the email package. When affidavits are CWE-authored and stored in `Contract Package\Affidavits\`, that location does not transfer affidavit authorship or make CFD responsible for reauthoring them.

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

Credit Worthiness Evaluator owns the substantive drafting, creation, and Teams storage of creditworthiness, funds, rent-history, receipt-review, business-judgment, and underwriting-support affidavits. The expected current Teams location for those CWE-authored documents is `Contract Package\Affidavits\`.

Contract for Deed reads and references those CWE-authored affidavit/support documents when they belong in the contract, closing, or attorney-review package. Affidavit handling is part of Full English Package mode and is not a standalone CFD output mode.

When a CWE handoff lists affidavit package items, treat those affidavits as CWE-authored Teams-stored documents. Do not rewrite them from summary metadata, do not generate substitute affidavits from metadata-only handoff rows, and do not create CFD affidavit output files unless Wes explicitly changes that division of responsibility.

For each affidavit item in the CWE handoff, verify:

- the affidavit title,
- file name,
- full file path,
- that the file exists at that path,
- that the file is a DOCX affidavit draft,
- that the file is stored in `Contract Package\Affidavits\` or another location explicitly provided by CWE for that specific item,
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
- Seller signature stays in the trust/trustee structure: `Investment Services LLC, Trustee - [Manager], Manager`, where `[Manager]` is read from the confirmed project spreadsheet `Docs` worksheet manager field, including the current workbook label `Manger` when that is the available field. Do not replace the trust/trustee structure with the seller entity name alone, and do not hardcode a manager name in reusable CFD rules or scripts.
- The ACH draft paragraph belongs where Wes placed it as section 7(d).
- Buyer ACH account/routing blanks stay on the buyer signature page.
- Notary blocks must preserve underlined notary-name blanks and include notary signature lines.
- If the spreadsheet has no adverse-condition text, keep one section 9 `NOTE FOR ATTORNEY REVIEW` placeholder in the clean contract.
- Attorney-review mode overwrites the standard `ATTORNEY REVIEW PACKAGE` files and adds blue contextual review blocks. Clean drafts must not contain those blocks.

## Package Filename And Archive Rule

Active buyer-specific package files should not use version prefixes. Use clean current filenames in active package folders.

Use the street-only property prefix in package filenames:

`<Street Address Only> - <Document Name>`

For 320 Rose, use `320 Rose Pl`, not `320 Rose` and not the full address with city, state, or ZIP.

Active examples:

- `320 Rose Pl - Contract for Deed Agreement - DRAFT.docx`
- `320 Rose Pl - Term Sheet - DRAFT.docx`
- `320 Rose Pl - Buyer Acknowledgment Addendum - DRAFT.docx`
- `320 Rose Pl - 12 Month Amortization Chart.pdf`
- `320 Rose Pl - Ever Cardoza - Closing Package for Email.zip`

Before creating a new active package version, move existing active package files to a categorized subfolder under `Archive` inside the same active folder. Add the version prefix when moving the old file into the archive, for example:

`Archive\Contract\v05 - 320 Rose Pl - Contract for Deed Agreement - DRAFT.docx`

Use these `Contract Package\Archive` subfolders:

- `Archive\Cover Letter\` for prior closing package cover page / cover letter files.
- `Archive\Affidavits\` for prior affidavit/support package-copy files.
- `Archive\Credit Worthiness\` for prior Credit Worthiness report package-copy files.
- `Archive\Attorney Review Package\` for prior attorney-review package ZIP files.
- `Archive\Contract\` for all other prior contract-package files, including contracts, memoranda, notes, term sheets, buyer acknowledgments, amortization charts, attorney-review DOCX files, signed contract PDFs, and package ZIPs unless Wes gives a document-specific archive location.

Do not keep a separate `Credit Worthiness Archive` sibling folder. Credit Worthiness archive files belong under `Contract Package\Archive\Credit Worthiness\`.

Archive only prior delivery/package files. Do not archive prototypes, staged spreadsheets, source files, scripts, handoffs, temporary files, or other non-delivery working files unless Wes gives a separate instruction.

Do not delete prior versions. Before archiving, verify the destination path is inside the same project-room output tree or Teams `Contract Package` tree as the active file being archived.

Use the same active filename convention across CFD-created documents, the Amortization Chart package copy, the email body files, the Email Package ZIP, the cover page/checklist, attorney-review package files, and Spanish package files unless Wes gives a document-specific exception.

For `Contract Package\Spanish Package\`, use the same archive convention as the main package folders: keep only the current unversioned Spanish/bilingual deliverable for each document type in the active Spanish Package folder, use the street-only property prefix, and move prior Spanish/bilingual drafts for that same document type into `Contract Package\Archive\Spanish Package\` with their version prefix preserved or added when archiving an unversioned prior active file. Do not keep a `Contract Package\Clean Package\` folder.

## Package Document Footer And Version Rule

Every CFD-produced document must include a footer with page numbering and the package/document run version.

Use this footer format:

`Page X of Y | YY-MM-DD VX`

`YY-MM-DD` means two-digit year, two-digit month, and two-digit day. `VX` means the run version for that workflow on that date, such as `V1`, `V2`, or `V3`.

Use one package-wide version for CFD-generated documents in the same run. If the CFD package is generated once on a date, all CFD-generated documents in that package use `YY-MM-DD V1`. If the current deliverables are regenerated again on the same date, increment the package version to `YY-MM-DD V2`, and apply that version consistently to all CFD-generated current deliverables from that run.

Apply this footer/version rule to all CFD-authored or CFD-generated Word documents, including the Contract for Deed Agreement, Memorandum of Contract for Deed, Promissory Note, Term Sheet, Buyer Acknowledgment Addendum, Closing Package Cover Page / Checklist, attorney-review DOCX files, and Spanish package documents generated by CFD.

For package documents generated by another workflow, do not rewrite their substantive content or footers from CFD. Pass the CFD package version to the other workflow when supported, and expect that workflow to apply the same footer/version convention to its own outputs. The Amortization Chart PDF is authored by the Amortization workflow, so CFD should request or pass the package version and package the returned PDF. Credit Worthiness reports and affidavit/support documents are CWE-authored, so CFD should not rewrite them; CFD should package the versions supplied by CWE.

## Spanish Translation Flag

Wes may invoke the Spanish translation mode by saying `Spanish flag`, `Spanish version`, `bilingual version`, `Spanish contract`, or similar when starting or rerunning CFD.

The Spanish flag can be supplied by Wes's chat instruction. A spreadsheet field is not required for the flag to apply. If a future `Docs` worksheet field is added for Spanish/bilingual output, an explicit chat instruction from Wes controls for that run.

The Spanish flag is additive. It does not replace the normal English package and does not alter the English signing copies. First generate or confirm the current English clean package, then create separate Spanish/bilingual deliverables.

For the first implementation, the Spanish flag applies to the Contract for Deed Agreement only unless Wes explicitly expands the scope. When Wes expands the scope to other package documents, create separate Spanish draft deliverables for those document types and place them in the same Spanish Package workflow. The default Contract for Deed Agreement output name is:

`<Property> - Contract for Deed Agreement - BILINGUAL SPANISH DRAFT.docx`

For Spanish-only drafts of other package documents, use this output name pattern unless Wes gives a document-specific name:

`<Property> - <Document Name> - SPANISH DRAFT.docx`

Save the bilingual output in the project-room output folder and copy the current unversioned Spanish/bilingual package copy to the matching Teams buyer folder under:

`Contract Package\Spanish Package\`

Archive prior Teams Spanish/bilingual package copies under:

`Contract Package\Archive\Spanish Package\`

### Term Sheet Spanish Add-On

When Wes expands the Spanish scope to include the Term Sheet:

- Treat the Term Sheet Spanish draft as separate from the Contract for Deed bilingual Spanish draft.
- Do not change the Contract for Deed Spanish generator or its translation-memory rules when fixing or updating the Term Sheet Spanish draft.
- Generate the Term Sheet Spanish draft from the current English Term Sheet after the Full English Package has been regenerated.
- The Term Sheet Spanish draft must reflect the current spreadsheet-fed English Term Sheet values from the `Docs` worksheet.
- Do not reuse old Term Sheet Spanish text when the current English Term Sheet text or values have changed.
- Translate the Term Sheet headings, explanatory paragraphs, table labels, section labels, and standard instruction text fresh for the current draft.
- Preserve inserted transaction values exactly as shown in the English Term Sheet unless Wes explicitly asks to translate or restate them.
- Preserve the three adverse-condition entries exactly as spreadsheet-sourced values unless Wes explicitly asks to translate them: `Adverse Conditions1`, `Adverse Conditions2`, and `Adverse Conditions3`.
- Use the standard Spanish output name pattern: `<Property> - Term Sheet - SPANISH DRAFT.docx`.
- Copy the current unversioned Spanish Term Sheet to the Teams `Contract Package\Spanish Package\` folder.
- Before writing a new active Teams Spanish Term Sheet, archive the prior active Spanish Term Sheet under `Contract Package\Archive\Spanish Package\`.
- The Spanish Term Sheet belongs to the Spanish Add-On workflow, not Full English Package mode and not Email Package mode unless Wes asks for Spanish documents to be included in the email package.

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

The reusable CFD workflow must not depend on project-specific script names or hardcoded project facts. Existing Rose-named scripts are transitional 320 Rose implementation details. When refactoring or creating new CFD generators, prefer generic script names and pass the confirmed project spreadsheet, transaction folder, and Teams package root as inputs.

When changing this skill:

1. Make the change in the wiki copy first.
2. If project-room scripts or instructions change, update the project room at the same time.
3. Commit the Admin wiki changes locally when the durable rule update is complete.
4. Do not sync the installed local skill merely because canonical source changed. Sync only when Wes explicitly asks to sync, install, or make the updated skill active.
5. Do not push unless Wes explicitly asks to push or says the update is finished and ready to publish.
