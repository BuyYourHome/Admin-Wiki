# Contract for Deed

Created: 2026-05-31 10:30:27 -04:00

## Purpose

Create contract-for-deed sale document packages, currently focused on selling 320 Rose in the same manner that Cool Springs was sold.

## Source Material

- Rose project spreadsheet copied from: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28_Project Management - 320 Rose Pl.xlsm`
- Rose project spreadsheet staged at: `source\320 Rose project spreadsheet\28_Project Management - 320 Rose Pl.xlsm`
- Cool Springs selling docs copied from: `C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\22-HM-2325 Cool Springs Rd\Selling`
- Cool Springs selling docs staged at: `reference\Cool Springs selling docs`

## Working Rule

Use Cool Springs as the transaction/document reference and 320 Rose as the property/project source. Do not alter originals in the Property folders from this room; work from staged copies and write drafts to `working` or `output`.

Do not sync the installed `contract-for-deed` Codex skill merely because scripts, drafts, or prototypes in this project room changed. Keep project-room work here until the new prototypes/workflow are completed. Sync the installed skill only after the prototypes are ready or when Wes explicitly asks to update the installed skill.

## Spreadsheet Refresh Rule

When Wes says the Teams/Property workbook has been updated and asks for doc values, copy a fresh staged copy from:

`C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28_Project Management - 320 Rose Pl.xlsm`

to:

`source\320 Rose project spreadsheet\28_Project Management - 320 Rose Pl.xlsm`

Then use the `Docs` worksheet as the source of truth for document values.

All fields needed by the document generators should be exposed on the `Docs` worksheet. Do not have the document generators pull contract values directly from other workbook tabs such as `Amortization`, `Contract`, `Base`, or buying/acquisition tabs. If a needed value is calculated elsewhere, add or correct a named field on `Docs` and have the generator read that `Docs` field.

For Rose sale documents, use only `LoanStart1` and `LoanEnd1` for loan/payment date fields. Ignore `LoanStart2` and `LoanEnd2`.

When regenerating Rose draft documents, overwrite the standard `DRAFT` files in `output` each time instead of creating revision-numbered copies, unless Wes explicitly asks to preserve a separate version.

When Wes edits a generated document in `output`, treat that edited document as the replacement template for that document type when he asks to retemplate or continue from his edits. Assume Wes's edits are intentional changes to the template, except for generated attorney-review blocks. If attorney-review blocks are present, ignore them when updating the clean document template; they are generated review-mode content and should not become part of the underlying clean template unless Wes explicitly says otherwise.

Before regenerating any document after Wes may have edited output files, inspect the `output` folder timestamps and Word lock files (`~$*.docx`). If an output document is newer than its prototype or appears to be open in Word, stop and capture the saved edited document as the replacement template first. Do not regenerate over a potentially edited output file unless Wes explicitly says to discard those edits.

For the Contract for Deed draft, use Wes's edited prototype at `reference\Rose contract prototype\320 Rose - Contract for Deed Agreement - PROTOTYPE.docx` as the formatting source going forward. Preserve the edited Word formatting, indents, price table, boldness throughout the document, and signature spacing while refreshing values from the latest spreadsheet. If the prototype is missing, fall back to `reference\Cool Springs selling docs\25-02-21 Seller Docs.docx`, remove the memorandum portion, and replace Cool Springs values with Rose values. The helper script is `working\format_contract_from_reference.py`.

For the Memorandum of Contract for Deed draft, use Wes's edited prototype at `reference\Rose memorandum prototype\320 Rose - Memorandum of Contract for Deed - PROTOTYPE.docx` as the formatting source going forward. Preserve Wes's formatting changes while refreshing controlled values from the latest spreadsheet. The memo must include county and parcel ID from the `Docs` worksheet, and the purchaser signature block must include separate signature lines for both buyers. The helper script is `working\format_memo_from_prototype.py`.

## Credit Worthiness Handoff Intake

- Credit Worthiness Evaluator affidavit handoffs are copied into:

  `source\credit-worthiness-handoffs\`

- Treat these handoffs as source inputs for affidavit packet needs, signer/capacity requirements, supported facts, open assumptions, and attorney-review notes.
- Do not overwrite existing handoff files. Use versioned handoff filenames.
- Contract for Deed owns final document package drafting, formatting, signature-block placement, and attorney-review package assembly after consuming the handoff.

## Current Contract for Deed Workflow

This project room is the working version of a process that may later become a Codex skill. Until then, use this room's scripts and notes as the operating procedure.

1. If Wes has edited `output\320 Rose - Contract for Deed Agreement - DRAFT.docx` and says it looks good, copy that file to:

   `reference\Rose contract prototype\320 Rose - Contract for Deed Agreement - PROTOTYPE.docx`

   This prototype is the formatting and wording template for later contract refreshes.

2. When Wes updates the 320 Rose spreadsheet, refresh the staged workbook from the Teams/Property source path into `source\320 Rose project spreadsheet`.

3. Read document values from the `Docs` worksheet only. Current important fields include:
   - `Selling-Buyer1`
   - `Selling-Buyer2`
   - `Selling-Buyer Add1`
   - `Selling-Buyer Add2` or duplicate `Selling-Buyer Add1`
   - `Selling -Seller`
   - `Selling Purchase Price:`
   - `Selling Down Payment:`
   - `Selling Earnest Money:` for earnest money paid at contract signing
   - `Loan Amount:`
   - `Monthly Payment1`
   - `Loan Start1`
   - `Loan End1`
   - `Adverse Conditions`, with each listed lien/adverse condition in the same `Docs` row
   - property fields under the Property/Deed/Trust sections
   - `Manger` for the trustee manager name

4. Rebuild the Contract for Deed with:

   `working\format_contract_from_reference.py`

   The script should overwrite:

   `output\320 Rose - Contract for Deed Agreement - DRAFT.docx`

   Build the Term Sheet with:

   `working\format_term_sheet.py`

   The script should overwrite:

   `output\320 Rose - Term Sheet - DRAFT.docx`

   Build the Buyer Acknowledgment Addendum with:

   `working\format_buyer_acknowledgment_addendum.py`

   The script should overwrite:

   `output\320 Rose - Buyer Acknowledgment Addendum - DRAFT.docx`

5. The Contract for Deed refresh must preserve the prototype formatting and update only the controlled variable fields. Avoid paragraph-number assumptions where possible; locate sections by their visible text because Wes may adjust spacing or wording in the prototype.

6. Current contract-specific rules:
   - Seller stays anonymous as the trust. The trust is seller, and the trustee signs for the trust.
   - The Term Sheet is a formal summary document. It must read values from the `Docs` worksheet, not from prior email text. It may use prior email wording only as structural guidance. Include a clear statement that the Term Sheet is for review and discussion, is not the final contract, does not transfer title, is subject to final documents and attorney review, and is controlled by the final signed documents if there is a conflict.
   - The Buyer Acknowledgment Addendum is a formal buyer-understanding document. It should provide two buyer-initial columns for each acknowledgment, signature lines for both buyers, and the standard buyer notary acknowledgment block.
   - Seller signature line should read in substance: `Investment Services LLC, Trustee - Wes Browning, Manager`.
   - Do not add a second standalone `Wes Browning, Manager` line under the seller signature line.
   - Seller/trustee mailing addresses must include the full city, state, and ZIP from the `Docs` worksheet. Do not truncate comma-separated address fields.
   - Earnest money paid at contract signing comes from `Selling Earnest Money:` on the `Docs` worksheet. Do not use the buying-side `BinderDeposit` / `Binder Deposit:` fields for seller documents.
   - `Selling Down Payment:` is the total down payment. The remaining down payment due at closing is `Selling Down Payment:` minus earnest money.
   - Preserve Wes's table formatting, including row height and justification, when refreshing earnest-money and down-payment table values.
   - Preserve Wes's centered formatting for the inserted `Adverse Conditions`/lien lines in section 9.
   - In section 9, include the seller-responsibility paragraph before the listed adverse conditions: Seller remains responsible for the listed matters, they may remain during the contract term, and Seller must release, satisfy, or otherwise resolve matters needed to convey marketable title before or at the closing of Purchaser's future sale unless resolved earlier or otherwise agreed in writing.
   - Preserve Wes's boldness changes throughout the contract, including section headings, section text, labels, tables, signature areas, and notary areas, when refreshing spreadsheet-derived values.
   - Preserve Wes's section 7 installment-payment formatting, including justification, boldness, indentation, spacing, page breaks, and edited table layout. Keep the labels in the left column and update the spreadsheet-derived installment values in the values table in the right column rather than recreating the section.
   - Include an Additional Terms paragraph stating the contract is signed subject to changes Seller's attorney may make or require, that the parties will sign the contract again at closing or execute a required amendment, that Seller may elect to proceed under the previously signed contract if material attorney-required changes cause Purchaser not to proceed, and that Purchaser's due diligence funds will be returned if Seller does not so elect.
   - Include an Additional Terms paragraph stating that Seller is not providing legal advice and Purchaser may consult an attorney of Purchaser's choice, at Purchaser's expense, before signing and before closing.
   - Prefer section-title references over paragraph-number references when referring to conditions in `Additional Terms, Conditions or Addenda`, so references do not drift when numbered sections are inserted or reordered.
   - Standardize notary acknowledgment blocks in the Contract, Memorandum, and Note using the North Carolina acknowledgment structure from G.S. 10B-41. Use the following layout with the document-specific signer inserted:
     - `STATE OF: NORTH CAROLINA`
     - `COUNTY OF: [COUNTY]`
     - `I certify that the following person(s) personally appeared before me this day, each acknowledging to me that he/she/they signed the foregoing document: [SIGNER NAME(S) AND CAPACITY].`
     - `Date: ____________________`
     - `Official Signature of Notary: ________________________________________`
     - `Notary's printed or typed name: ______________________________, Notary Public`
     - `My commission expires: ______________________`
   - For seller/trust blocks, identify the signer in representative/fiduciary capacity, such as `Wes Browning, Manager of Investment Services LLC, Trustee of 320 Rose Pl Real Estate Trust dated March, 5 2025`.
   - For buyer blocks, include all buyer names in the same acknowledgment unless attorney review requires separate notary blocks.
   - Use only `LoanStart1` and `LoanEnd1`; ignore `LoanStart2` and `LoanEnd2`.
   - The section 9 adverse-condition placeholder should explicitly say `NOTE FOR ATTORNEY REVIEW` and should appear only once.
   - Trim any trailing blank/text content after the final purchaser notary block.
   - Because this is a contract for deed package, a deed is not required at this time and should not be included in the package.

## Current Package Scope

Current package documents:

- Term Sheet
- Buyer Acknowledgment Addendum
- Contract for Deed Agreement
- Memorandum of Contract for Deed
- Promissory Note for Contract for Deed

Excluded for now:

- Deed of Trust / deed documents. Do not regenerate or include these unless Wes later changes the scope.

## Future Skill Notes

When converting this room to a skill, include:

- A trigger for contract-for-deed sale document generation from a project spreadsheet.
- A required staged spreadsheet refresh step.
- A `Docs` worksheet value map with duplicate-label handling.
- A prototype-based DOCX refresh workflow that preserves user-edited formatting.
- A rule to update the prototype when Wes approves an edited draft.
- A mandatory pre-regeneration edit-preservation gate. Before any clean or attorney-review regeneration, inspect the output folder for newer files and Word lock files. If any output file is newer than its prototype, or if a matching `~$*.docx` lock file indicates the document is open in Word, do not overwrite it. First capture the saved non-review-block edits as the replacement clean template, or ask Wes whether to discard the edits. This applies even when Wes says only "regenerate" or "recreate."
- Guardrails for locked Word files: if a draft or prototype is open and cannot be overwritten, report the lock and wait rather than creating unrequested revision copies.
- An attorney-review mode. When enabled, overwrite the standard attorney-review package files each time rather than keeping separate review-note revisions. The attorney-review package files should contain blue `ATTORNEY REVIEW NOTE:` blocks inside the documents. Use this mode for attorney review packages only, not as seller/buyer signing copies. Place each review block in the proper context within the body of the document, immediately near the section it asks counsel to review, instead of grouping all review blocks at the beginning. The attorney review blocks should prompt counsel to review legal issues such as North Carolina contract-for-deed compliance, trust/trustee authority, title/liens/adverse matters, recording requirements, signature/notary blocks, and legal sufficiency. Do not ask the attorney to compare document values against the spreadsheet because the spreadsheet is not included in the attorney review package; the document generator should check internal consistency among the contract, memorandum, note, and spreadsheet values. If Wes needs to review or decide a business/value issue, insert a blue `MANAGEMENT REVIEW NOTE:` in context instead of an attorney review note. Review blocks are generated content; if Wes edits a review-mode document, preserve his non-review-block edits as template changes and ignore any edits to the review blocks unless Wes explicitly directs otherwise.

## Cool Springs Reference Files

- `_All Buyer Docs - Contract-DoT-Note.doc`
- `_Contract for Deed Agreement.doc`
- `_Deed of Trust - Contract for Deed.docx`
- `_Promissory Note for Contract for Deed.docx`
- `25-02-21 Amortization Comparison.pdf`
- `25-02-21 Seller Docs.docx`
- `25-02-21 Seller Docs.pdf`
- `25-03-04 Contract for Deed.pdf`
- `25-03-04 Memorandum of a Contract for Deed.pdf`
- `Template - Contract for Deed.docx`
- `Template - Memorandum of CFD.docx`
