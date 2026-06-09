---
name: credit-worthiness-evaluator
description: Use for Buy Your Home tenant-buyer creditworthiness and ability-to-repay reviews, especially buyer-specific Contract for Deed or seller-financed evaluations using the Credit Worthiness Evaluator project room. Trigger when Wes asks to refresh buyer documents, rerun the evaluator, evaluate a buyer, update a buyer credit report, produce an Investment Services, LLC buyer creditworthiness report, or create a Credit Worthiness handoff for Contract for Deed closing documents.
---

# Credit Worthiness Evaluator

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Credit Worthiness Evaluator`
- Canonical wiki source: `C:\Codex\Wiki Files`
- Buyer source folders may be Teams-synced property folders, such as `...\Selling\<Buyer Name>\`.

Use the project room for source inventory, conflict logs, missing-context notes, and outputs. Preserve raw buyer/source documents.

## Invocation Consistency Rule

- Run the Credit Worthiness Evaluator the same way whether it is called directly by Wes/user or kicked off by the Contract for Deed workflow.
- The trigger source must not change the evaluation standard, source requirements, buyer segregation, report format, DOCX creation, Teams copy rule, handoff creation, versioning, or Git/no-push rules.
- A CFD kickoff may supply routing context, such as the target CFD handoff folder, but it does not reduce the required CWE outputs.
- A direct user request for an evaluation must still create/update the CFD handoff when the buyer may proceed to Contract for Deed documents, so CFD receives the same closing-package document request list it would receive from a CFD-initiated run.
- If a caller provides transaction facts in a prompt, verify them from the project spreadsheet and durable project-room/source files before using them as source facts. If the files do not support a fact, mark it missing or unresolved.
- For CFD-initiated work, prefer the file-based kickoff in the Contract for Deed transaction folder over prompt-provided facts. Do not use buyer, seller, payment, affidavit, or transaction facts from the kickoff prompt as source facts.

## Buyer Segregation Rule

- Treat the evaluator as a generic buyer-specific process. The named buyer is an input, not a hard-coded workflow.
- Keep each buyer's materials segregated inside the project room.
- Use buyer-specific folders under `sources\`, `working\`, and `outputs\` whenever a run involves buyer documents, buyer-specific notes, reports, affidavit handoffs, or generated artifacts.
- Do not blend source inventories, missing-context notes, conflict logs, reports, affidavit requirements, or assumptions across buyers.
- If a shared project-room file summarizes multiple buyers, each buyer must have a clearly labeled section and must link back to that buyer's segregated folder.

## Standard Workflow

1. Read `Project Room Workflow.md`, the project room README, and the current buyer-specific inventory/output files.
2. Locate and inspect the property project spreadsheet from the Teams property folder. Use it as the first source for property, buyer, co-buyer, seller/entity, trustee, manager/signature authority, payment terms, and document-package fields.
3. Identify the live buyer source folder named by Wes, recorded in the project spreadsheet, or already recorded in the room.
4. Refresh the project room source copy from that buyer folder into the buyer's segregated `sources\` subfolder.
5. Extract readable text from PDFs, DOCX files, and email attachments as working artifacts.
6. Update:
   - buyer source inventory,
   - duplicate/conflict log,
   - missing-context list,
   - preliminary file review,
   - affidavit requirements handoff,
   - formal DOCX report for every evaluation or rerun.
7. Use authoritative sources only. Mark unsupported items instead of smoothing them over.
8. Render and visually check formal DOCX reports before delivery when the Documents skill/runtime is available.
9. Add page numbers to formal reports before delivery.
10. If a formal report is rerun, preserve a versioned copy instead of silently replacing the prior report.
11. Copy every formal DOCX evaluation report into the buyer's Teams `Credit Worthiness` folder, including conditional, draft, evidence-mode, and assumption-mode reruns. Never overwrite an existing Teams document.
12. Commit durable wiki/project-room changes locally. Do not push unless Wes says the work is finished or explicitly asks for a push.

## Project Spreadsheet Rule

- A new evaluation can start from the project spreadsheet in the Teams property folder.
- Inspect the spreadsheet before declaring core transaction facts missing.
- Use the project spreadsheet first for buyer/co-buyer/secondary buyer, spouse, occupant, seller, trustee, manager/signature authority, payment terms, and Contract for Deed document fields.
- If a person appears in a spreadsheet buyer field, such as `Selling-Buyer1`, `Selling-Buyer2`, or similar document-package buyer fields, treat that person according to the spreadsheet role unless a later authoritative source conflicts.
- If the spreadsheet conflicts with other file materials, log the conflict and use the spreadsheet as the working document-package source until Wes or counsel resolves it.
- For the 320 Rose example, the project spreadsheet identifies `Ever Amarildo Cardoza Bolanos` as `Selling-Buyer1` and `Maria Geraldine Sarmiento` as `Selling-Buyer2`; Maria's status should therefore not be listed as unknown unless another source creates a conflict.

## Evaluation Rules

- Treat applicant-stated income as unverified unless supported by third-party or business records.
- For self-employed buyers, distinguish gross business deposits from verified borrower-level net income.
- Do not treat business revenue as personal income without tax returns, profit-and-loss records, ownership/compensation verification, payroll records, or owner-draw analysis.
- Consider current debt obligations, current rent/payment history, cash to close, reserves, repair capacity, and final proposed housing payment.
- State whether the result is approval, decline, or conditional reconsideration. If the file is not approval-ready, say that directly.
- A conditional approval or conditional reconsideration still requires a full formal report. Do not substitute a short summary, memo, or handoff-only output because the result is conditional.
- The full report for a conditional result must include the same core sections expected for approval or decline: source basis, transaction snapshot, buyer identity/roles, evidence reviewed, income analysis, debt/payment-ratio analysis, cash-to-close/reserve analysis, compensating factors, conditions to approval, missing documents, legal/compliance review items, and next actions.
- Include attorney/compliance review needs for seller-financing, Regulation Z/Dodd-Frank, state law, and adverse-action notice questions.

## Contract For Deed Handoff Rule

- Accept kickoff requests from CFD when the project spreadsheet identifies a current buyer but no handoff exists yet.
- For a CFD kickoff, look for `CWE Kickoff.md` in the matching Contract for Deed transaction folder. Use that kickoff file to find the live project spreadsheet and required CFD handoff destination.
- A CFD kickoff is enough to begin the evaluator even if buyer files still need to be uploaded. Refresh whatever buyer documents are available, then report missing files and assumptions in the CWE report and handoff.
- Treat the project spreadsheet buyer fields as the current buyer source unless the request names a different buyer or the file evidence shows an active conflict.
- When the evaluator is used for a buyer who may proceed to Contract for Deed documents, create or update a buyer-specific `Credit Worthiness Handoff.md`.
- The handoff's main purpose is to tell CFD what credit-worthiness-related documents CFD must create, finalize, and include in the closing package.
- Keep the handoff in the buyer's segregated CWE `outputs\` folder and copy the current handoff into the matching CFD buyer transaction folder.
- CFD handoff destination:

  `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\transactions\<Property> - <Buyer>\handoffs\credit-worthiness\Credit Worthiness Handoff.md`

- The handoff must identify the live project spreadsheet used. Include buyer/property, project spreadsheet path, evaluation result, report path, source cutoff date, buyer legal names and roles, funds-to-close status, and a closing-package document request list for CFD.
- For each requested CFD closing-package document, state the document name, why it is needed, condition or gap addressed, required/recommended/optional status, signer, signer capacity, authority source, facts to include, notarization need, current evidence/status, and exact CFD action needed.
- The CFD transaction folder is allowed to have one current `Credit Worthiness Handoff.md` that is overwritten when the evaluator produces a newer current handoff. Preserve versioned handoffs in the CWE project-room outputs when history matters.
- The CWE handoff is a closing-package document request and source input to CFD. CFD owns final Contract for Deed package drafting, formatting, signature-block placement, closing-package affidavit generation, inclusion/exclusion decisions, and attorney-review package assembly.

## Affidavit Requirements

When an affidavit or other credit-worthiness support document is needed for the closing package, list it in the handoff as a CFD document request instead of assuming the evaluator should produce the final document.

For each affidavit, state:

- affidavit name,
- purpose,
- condition or gap addressed,
- required/recommended/optional status,
- signer and signer capacity,
- facts to be sworn or acknowledged,
- source of the facts,
- whether notarization is needed,
- whether it is underwriting-only or closing-package material,
- requested CFD closing-package action.

CWE may draft underwriting-only affidavits when they support the approval file, such as rent-history, reserve-observation, receipt-review, or business-judgment approval affidavits. CFD should generate the final signature-ready version and decide whether to include it when the affidavit belongs in the closing or Contract for Deed package.

## Related-Company Rent History Rule

- For the 320 Rose / Ever Cardoza file, recognize that the buyer's current rent history is with related company `Buy Your Home, LLC`.
- Treat `Buy Your Home, LLC` rent verification as related-company, seller-adjacent payment history, not as an unrelated third-party landlord record.
- The related-company rent history can still be a strong compensating factor because Sell Your Home or its related company can directly verify payment timing and tenant performance.
- When using this factor, say the current landlord is `Buy Your Home, LLC`, a related company, and distinguish it from the transaction/seller entity used in the formal report voice.
- Do not overstate the rent history as independent third-party verification. Document it as direct related-company verification.
- If a report uses a tenant-buyer payment-history exception, include the related-company relationship in the exception rationale.

## Formal Report Naming And Voice

- Use the buyer's full legal-style name from the most authoritative available source, such as the screening report or application, in the report body and filename.
- Use the actual transaction/business entity name instead of Wes's personal name in formal reports.
- Do not write formal reports as personal requests from Wes. Use neutral entity language, such as `Sell Your Home requested...`, `for Sell Your Home review`, or `seller/business entity`.
- If the entity is not confirmed, mark it as `[ENTITY TO CONFIRM]` instead of using Wes's personal name.
- Keep report filenames date-prefixed in `yy-mm-dd` format and include the buyer full name, such as:

  `26-06-05 320 Rose Ever Amarildo Cardoza - Creditworthiness Evaluation Report.docx`

## Optional Approval-Assumption Mode

Default mode is evidence mode. In evidence mode, do not assume missing facts that would make a buyer approvable.

Use approval-assumption mode only when Wes explicitly calls the evaluator with a conditional flag or equivalent instruction, such as:

- `approval_assumption_mode=true`
- `assume good answers`
- `run as if sufficient answers were provided`
- `show what assumptions would allow approval`

When approval-assumption mode is active:

1. Label the output as a hypothetical or conditional approval scenario.
2. State the exact assumptions that must be true before the result can be relied on.
3. Keep assumed facts separate from verified facts in the source basis and report body.
4. Do not convert missing documents into verified evidence. Say that the approval result depends on later receipt and review of the assumed documents.
5. Use the assumed facts only to test whether approval could be supportable, not to erase risk flags.
6. If the scenario supports approval, call the result `conditional approval supportable under stated assumptions`, not unconditional approval, unless all required evidence is actually present and reviewed.
7. Preserve a fallback result that says what the evaluator would conclude if the assumptions are not proven.
8. Version any formal report produced in this mode, and include the mode label in the report subtitle, revision note, or scenario basis.

## Mandatory DOCX And Teams Copy Rule

Every evaluator run must produce a full formal DOCX report. Markdown summaries, handoffs, inventories, and missing-context notes may support the run, but they do not replace the DOCX report. Conditional approval, conditional reconsideration, and not-approval-ready results must receive a full report, not a shortened summary.

When an evaluator run produces or updates the formal report:

1. Save the report in the buyer's segregated project-room `outputs\` folder.
2. Copy the same report into the buyer's Teams `Credit Worthiness` folder, even when the result is conditional, draft, evidence-mode, assumption-mode, or not approval-ready.
3. Teams destination must be derived from the live buyer source folder:

   `[Project]\Selling\[Buyer]\Credit Worthiness\`

4. If the live buyer folder is `[Project]\Selling\[Buyer]`, create or use `[Project]\Selling\[Buyer]\Credit Worthiness\` for the Teams report copy.
5. For the project-room `outputs\` copy, keep using date-prefixed filenames for chronological project-room tracking.
6. For the Teams `Credit Worthiness` copy, precede the filename with the report version, not the date, such as:

   `v9 320 Rose Ever Amarildo Cardoza Bolanos - Creditworthiness Evaluation Report - Approval Scenario.docx`

7. In the final response, report both the project-room DOCX path and the Teams DOCX path.

Never overwrite an existing Teams/buyer-folder document. If a same-named file already exists, create a new versioned filename or ask Wes before replacing anything.

Do not copy generated text extracts, render images, scratch logs, source-inventory working files, or non-final drafts back to the buyer folder unless Wes explicitly asks.

## Report Versioning And Page Numbers

- Formal DOCX reports must include page numbers in the footer.
- Formal report filenames must start with the report date in `yy-mm-dd` format.
- Use the unversioned filename for the current report when there is no prior delivered report.
- When rerunning or materially updating a previously delivered report, save the new file with a version suffix, such as:

  `26-06-05 320 Rose Ever Cardoza - Creditworthiness Evaluation Report v2.docx`

- Keep prior delivered report versions in both the project room `outputs\` folder and the live buyer source folder unless Wes explicitly asks to replace or remove them.
- In Teams, preserve all intentionally copied CWE versions in `[Project]\Selling\[Buyer]\Credit Worthiness\` and use version-prefixed filenames rather than date-prefixed filenames.
- If the report body includes a report date, revision date, version label, or source cutoff date, update it to match the rerun.
- In the final response, identify the current version and both saved locations.

## Optional Spanish Append Mode

Default mode is English-only.

Use Spanish append mode only when Wes explicitly calls the evaluator with a conditional flag or equivalent instruction, such as:

- `spanish_append=true`
- `Spanish switch`
- `append Spanish`
- `include Spanish copy`

When Spanish append mode is active:

1. Build the English report first as the controlling report.
2. Append a complete Spanish translation copy after the English report in the same DOCX file.
3. Start the Spanish portion on a new page with a clear heading, such as `COPIA EN ESPANOL`.
4. Add a short translation note at the start of the Spanish portion stating that the Spanish copy is provided for convenience and the English report controls if there is any conflict, unless Wes instructs otherwise.
5. Preserve the same structure, section order, numbers, dates, entity names, buyer names, conditions, and decision language in Spanish.
6. Do not summarize or shorten the Spanish copy unless Wes explicitly asks for a summary instead of a full appended copy.
7. Keep page numbers active across the combined English and Spanish report.
8. Include the Spanish append mode in the filename or version note when it helps distinguish the deliverable, such as:

   `26-06-05 320 Rose Ever Amarildo Cardoza - Creditworthiness Evaluation Report - English-Spanish v4.docx`

## Final Response

Summarize:

- evaluation result,
- most important supporting numbers,
- remaining blockers,
- project-room report path,
- buyer-folder report path,
- commit id if committed,
- push status,
- total request time.
