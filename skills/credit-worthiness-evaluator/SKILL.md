---
name: credit-worthiness-evaluator
description: Use for Buy Your Home tenant-buyer creditworthiness and ability-to-repay reviews, especially Contract for Deed or seller-financed buyer evaluations using the Credit Worthiness Evaluator project room. Trigger when Wes asks to refresh buyer documents, rerun the evaluator, evaluate a buyer, update a buyer credit report, or produce an Investment Services, LLC buyer creditworthiness report.
---

# Credit Worthiness Evaluator

## Source Of Truth

- Project room: `C:\Codex\Wiki Files\Project Rooms\Credit Worthiness Evaluator`
- Canonical wiki source: `C:\Codex\Wiki Files`
- Buyer source folders may be Teams-synced property folders, such as `...\Selling\<Buyer Name>\`.

Use the project room for source inventory, conflict logs, missing-context notes, and outputs. Preserve raw buyer/source documents.

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
   - formal report if one exists or is requested.
7. Use authoritative sources only. Mark unsupported items instead of smoothing them over.
8. Render and visually check formal DOCX reports before delivery when the Documents skill/runtime is available.
9. Add page numbers to formal reports before delivery.
10. If a formal report is rerun, preserve a versioned copy instead of silently replacing the prior report.
11. Copy only final deliverables, or deliverables Wes explicitly asks to place there, into the buyer's Teams `Credit Worthiness` folder.
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
- Include attorney/compliance review needs for seller-financing, Regulation Z/Dodd-Frank, state law, and adverse-action notice questions.

## Contract For Deed Handoff Rule

- When the evaluator identifies affidavit needs for a buyer, create an `Affidavit Requirements Handoff` in the buyer's segregated CWE `outputs\` folder.
- The handoff should include buyer/property, project spreadsheet used, evaluation result, required affidavits, facts each affidavit supports, signer, signer capacity, authority source, status, open assumptions, and CFD action needed.
- Copy a versioned copy of the handoff into the Contract for Deed project room for CFD to consume.
- CFD handoff destination:

  `C:\Codex\Wiki Files\Project Rooms\Contract for Deed\source\credit-worthiness-handoffs\`

- Use a version-prefixed or otherwise unique handoff filename and never overwrite an existing CFD handoff file.
- The CWE handoff is an input to CFD. CFD owns final Contract for Deed package drafting, formatting, signature-block placement, and attorney-review package assembly.

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

## Report Copy-Back Rule

When an evaluator run produces or updates a formal report:

1. Save the report in the project room `outputs\` folder.
2. Copy the same report into Teams only when the report is final, Wes explicitly asks for a Teams/buyer-folder copy, or the run is clearly a final deliverable.
3. Teams destination must be:

   `[Project]\Selling\[Buyer]\Credit Worthiness\`

4. Save all Teams copies of Credit Worthiness Evaluator reports in that `Credit Worthiness` folder, including every version that is intentionally copied to Teams.
5. For the project-room `outputs\` copy, keep using date-prefixed filenames for chronological project-room tracking.
6. For the Teams `Credit Worthiness` copy, precede the filename with the report version, not the date, such as:

   `v9 320 Rose Ever Amarildo Cardoza Bolanos - Creditworthiness Evaluation Report - Approval Scenario.docx`

7. In the final response, report both locations when a Teams copy is made.

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
