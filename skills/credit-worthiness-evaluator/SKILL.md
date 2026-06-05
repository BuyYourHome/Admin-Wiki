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

## Standard Workflow

1. Read `Project Room Workflow.md`, the project room README, and the current buyer-specific inventory/output files.
2. Identify the live buyer source folder named by Wes or already recorded in the room.
3. Refresh the project room source copy from that buyer folder.
4. Extract readable text from PDFs, DOCX files, and email attachments as working artifacts.
5. Update:
   - buyer source inventory,
   - duplicate/conflict log,
   - missing-context list,
   - preliminary file review,
   - formal report if one exists or is requested.
6. Use authoritative sources only. Mark unsupported items instead of smoothing them over.
7. Render and visually check formal DOCX reports before delivery when the Documents skill/runtime is available.
8. Copy the final or updated formal report back into the live buyer source folder where the source files were retrieved.
9. Commit durable wiki/project-room changes locally. Do not push unless Wes says the work is finished or explicitly asks for a push.

## Evaluation Rules

- Treat applicant-stated income as unverified unless supported by third-party or business records.
- For self-employed buyers, distinguish gross business deposits from verified borrower-level net income.
- Do not treat business revenue as personal income without tax returns, profit-and-loss records, ownership/compensation verification, payroll records, or owner-draw analysis.
- Consider current debt obligations, current rent/payment history, cash to close, reserves, repair capacity, and final proposed housing payment.
- State whether the result is approval, decline, or conditional reconsideration. If the file is not approval-ready, say that directly.
- Include attorney/compliance review needs for seller-financing, Regulation Z/Dodd-Frank, state law, and adverse-action notice questions.

## Report Copy-Back Rule

When an evaluator run produces or updates a formal report:

1. Save the report in the project room `outputs\` folder.
2. Copy the same report into the live buyer source folder where the buyer documents were retrieved.
3. Use a clear filename that preserves the buyer/property identity, such as:

   `320 Rose Ever Cardoza - Creditworthiness Evaluation Report.docx`

4. In the final response, report both locations.

Do not copy generated text extracts, render images, scratch logs, or source-inventory working files back to the buyer folder unless Wes explicitly asks.

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
