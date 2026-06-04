from copy import deepcopy
from pathlib import Path

from docx import Document
from docx.shared import RGBColor

from build_rose_drafts import get_docs_values, normalize_values, money, short_date


ROOT = Path(r"C:\Codex\Wiki Files\Project Rooms\Contract for Deed")
PROTOTYPE = ROOT / "reference" / "Rose contract prototype" / "320 Rose - Contract for Deed Agreement - PROTOTYPE.docx"
REFERENCE = ROOT / "reference" / "Cool Springs selling docs" / "25-02-21 Seller Docs.docx"
OUTPUT = ROOT / "output" / "320 Rose - Contract for Deed Agreement - DRAFT.docx"


def split_address(address):
    parts = [part.strip() for part in str(address).split(",") if part.strip()]
    if len(parts) >= 3:
        return parts[0], f"{parts[1]}, {parts[2]}"
    if len(parts) == 2:
        return parts[0], parts[1]
    return str(address), ""


def set_paragraph(paragraph, text, red=False):
    if not paragraph.runs:
        paragraph.add_run("")
    for run in paragraph.runs:
        run.text = ""
    run = paragraph.runs[0]
    run.text = str(text)
    if red:
        run.font.color.rgb = RGBColor(192, 0, 0)


def set_paragraph_runs(paragraph, parts):
    if not paragraph.runs:
        paragraph.add_run("")
    for run in paragraph.runs:
        run.text = ""
    first = True
    for part in parts:
        text = str(part.get("text", ""))
        run = paragraph.runs[0] if first else paragraph.add_run()
        first = False
        run.text = text
        if "bold" in part:
            run.bold = part["bold"]
        if "underline" in part:
            run.underline = part["underline"]
        if part.get("red"):
            run.font.color.rgb = RGBColor(192, 0, 0)


def set_notary_acknowledgment(paragraph, signer_text, red_signer=False):
    set_paragraph_runs(
        paragraph,
        [
            {"text": "I, "},
            {"text": "\t\t\t\t\t", "underline": True},
            {"text": ", a Notary Public of the County and State aforesaid, do hereby certify that "},
            {"text": signer_text, "red": red_signer},
            {
                "text": " personally appeared before me this day and acknowledged the execution of the foregoing instrument.  Witness my hand and notarial seal,"
            },
        ],
    )


def set_notary_certification_prefix(paragraph):
    set_paragraph_runs(
        paragraph,
        [
            {"text": "I, "},
            {"text": "\t\t\t\t\t", "underline": True},
            {"text": ", a Notary Public of the County and State aforesaid, do hereby certify that\xa0"},
        ],
    )


def set_notary_signer_continuation(paragraph, signer_text, red_signer=False):
    set_paragraph_runs(
        paragraph,
        [
            {"text": signer_text, "red": red_signer},
            {
                "text": " personally appeared before me this day and acknowledged the execution of the foregoing instrument.  Witness my hand and notarial seal,"
            },
        ],
    )


def insert_underlined_signature_line_before(paragraph):
    prev = paragraph._p.getprevious()
    if prev is not None:
        prev_text = "".join(node.text or "" for node in prev.iter() if node.tag.endswith("}t")).strip()
        if prev_text and set(prev_text) <= {"_"}:
            return
    signature_line = paragraph.insert_paragraph_before()
    set_paragraph_runs(signature_line, [{"text": "____________________________________________", "underline": False}])


def ensure_notary_signature_lines(doc):
    for paragraph in list(doc.paragraphs):
        if paragraph.text.strip().startswith("Notary Public") and "My Commission expires" in paragraph.text:
            insert_underlined_signature_line_before(paragraph)


def remove_after_contract(doc):
    body = doc._body._element
    children = list(body)
    start_remove = None
    for idx, child in enumerate(children):
        text = "".join(node.text or "" for node in child.iter() if node.tag.endswith("}t"))
        if text.strip().startswith("Prepared By:"):
            start_remove = idx
            break
    if start_remove is not None:
        for child in children[start_remove:]:
            body.remove(child)


def replace_text_in_paragraphs(doc, replacements):
    for paragraph in doc.paragraphs:
        for old, new in replacements.items():
            if old in paragraph.text:
                # Preserve paragraph formatting; direct replacement is safe when the phrase is isolated.
                text = paragraph.text.replace(old, new)
                set_paragraph(paragraph, text)


def find_paragraph(doc, startswith):
    for idx, paragraph in enumerate(doc.paragraphs):
        if paragraph.text.strip().startswith(startswith):
            return idx
    return None


def set_first_paragraph_starting(doc, startswith, text):
    idx = find_paragraph(doc, startswith)
    if idx is not None:
        set_paragraph(doc.paragraphs[idx], text)
    return idx


def set_adverse_condition(doc, text):
    pending_idx = find_paragraph(doc, "PENDING ORDERS OR ADVERSE CONDITIONS:")
    cure_idx = find_paragraph(doc, "RIGHT TO CURE DEFAULT")
    if pending_idx is None:
        return
    text = str(text or "").strip()
    if not text:
        text = "NOTE FOR ATTORNEY REVIEW: Confirm whether any pending orders, liens, adverse conditions, title matters, or required disclosures should be listed here before signing."
    inserted = False
    for idx in range(pending_idx + 1, cure_idx or len(doc.paragraphs)):
        if doc.paragraphs[idx].text.strip():
            if not inserted:
                set_paragraph(doc.paragraphs[idx], text)
                inserted = True
            else:
                set_paragraph(doc.paragraphs[idx], "")
    if inserted:
        return
    if pending_idx + 1 < len(doc.paragraphs):
        set_paragraph(doc.paragraphs[pending_idx + 1], text)


def set_seller_signature_manager(doc, x):
    signature_text = f"{x['trustee']}, Trustee - {x['manager']}, Manager"
    for idx, paragraph in enumerate(doc.paragraphs):
        text = paragraph.text
        if "[MANAGER NAME]" in text or (x["trustee"] in text and "Trustee" in text and "Manager" in text):
            set_paragraph(paragraph, signature_text, red=True)
            if idx + 1 < len(doc.paragraphs) and doc.paragraphs[idx + 1].text.strip() == f"{x['manager']}, Manager":
                set_paragraph(doc.paragraphs[idx + 1], "")
            return


def set_seller_notary_manager(doc, x):
    purchaser_sig_idx = find_paragraph(doc, "Purchaser’s Signature")
    if purchaser_sig_idx is None:
        purchaser_sig_idx = find_paragraph(doc, "Purchaser's Signature")
    for idx, paragraph in enumerate(doc.paragraphs):
        if purchaser_sig_idx is not None and idx >= purchaser_sig_idx:
            return
        text = paragraph.text
        if "personally appeared before me this day and acknowledged the execution" in text and (
            "[MANAGER NAME]" in text or x["manager"] not in text
        ):
            set_notary_acknowledgment(paragraph, x["manager"], red_signer=True)
            return


def trim_after_last_notary(doc):
    body = doc._body._element
    paragraphs = list(body.findall(".//{http://schemas.openxmlformats.org/wordprocessingml/2006/main}p"))
    last_notary = None
    for paragraph in paragraphs:
        text = "".join(node.text or "" for node in paragraph.iter() if node.tag.endswith("}t"))
        if "Notary Public" in text and "My Commission expires" in text:
            last_notary = paragraph
    if last_notary is None:
        return
    children = list(body)
    try:
        last_idx = children.index(last_notary)
    except ValueError:
        return
    for child in children[last_idx + 1 :]:
        if child.tag.endswith("}sectPr"):
            continue
        body.remove(child)


def set_receipt_acknowledgment(doc, x):
    text = f"[ ] Agent   [X] Seller, by the signature below, acknowledge receipt of {money(x['down_payment'])} [  ] Cash   [   ] Check, as binder deposit, which is the amount mentioned in paragraph 1A of this Agreement."
    set_first_paragraph_starting(doc, "[ ] Agent", text)


def set_purchaser_notary(doc, x):
    seen_seller_notary = False
    for paragraph in doc.paragraphs:
        text = paragraph.text
        if x["manager"] in text and "personally appeared before me" in text:
            seen_seller_notary = True
            continue
        if seen_seller_notary and text.strip().startswith("COUNTY:"):
            set_paragraph(paragraph, f"COUNTY:  {x['county'].title()}")
            continue
        if seen_seller_notary and "personally appeared before me this day and acknowledged the execution" in text:
            set_notary_acknowledgment(paragraph, x["buyer"])
            return


def apply_notary_block_revisions(doc, x):
    for idx, paragraph in enumerate(doc.paragraphs):
        text = paragraph.text
        if x["buyer"] in text and "personally appeared before me this day and acknowledged the execution" in text:
            has_state = False
            has_county = False
            for prev_idx in range(idx - 1, max(-1, idx - 6), -1):
                prev_text = doc.paragraphs[prev_idx].text.strip()
                if prev_text.startswith("COUNTY"):
                    set_paragraph(doc.paragraphs[prev_idx], f"COUNTY:  {x['county'].title()}")
                    has_county = True
                if prev_text.startswith("STATE"):
                    has_state = True
            if not has_county:
                if not has_state:
                    paragraph.insert_paragraph_before("STATE:   North Carolina")
                    has_state = True
                paragraph.insert_paragraph_before(f"COUNTY:  {x['county'].title()}")
            if not has_state:
                paragraph.insert_paragraph_before("STATE:   North Carolina")
            set_notary_acknowledgment(paragraph, x["buyer"])

        if x["manager"] in text and "personally appeared before me this day and acknowledged the execution" in text:
            for prev_idx in range(idx - 1, max(-1, idx - 8), -1):
                if doc.paragraphs[prev_idx].text.strip().startswith("COUNTY:"):
                    set_paragraph(doc.paragraphs[prev_idx], f"COUNTY:  {x['county'].title()}")
                    break
            signer_text = f"{x['manager']}, Manager of {x['trustee']}, Trustee of {x['trust']},"
            prefix_idx = None
            for prev_idx in range(idx - 1, max(-1, idx - 5), -1):
                prev_text = doc.paragraphs[prev_idx].text
                if prev_text.startswith("I,") and "do hereby certify that" in prev_text:
                    prefix_idx = prev_idx
                    break
            if prefix_idx is not None:
                set_notary_certification_prefix(doc.paragraphs[prefix_idx])
                set_notary_signer_continuation(paragraph, signer_text, red_signer=True)
            else:
                set_notary_acknowledgment(paragraph, signer_text, red_signer=True)


def insert_paragraph_after(paragraph, text):
    new_paragraph = paragraph.insert_paragraph_before(text)
    paragraph._p.addnext(new_paragraph._p)
    return new_paragraph


def ensure_ach_terms(doc):
    ach_paragraph = (
        "ACH DRAFT PAYMENTS: Purchaser shall make each monthly payment by automatic ACH draft. "
        "Seller shall set up the ACH draft using the bank account and routing information provided by Purchaser on the signature page."
    )
    ach_fields = [
        "ACH Draft Authorization:",
        "Bank Account Number: ________________________________________________",
        "Routing Number: _____________________________________________________",
    ]

    # If the prototype already contains these blocks, leave them in place so user-set
    # numbering/lettering, spacing, and section placement remain intact.
    ach_blocks = [p for p in doc.paragraphs if p.text.strip().startswith("ACH DRAFT PAYMENTS:")]
    if not ach_blocks:
        insert_after_idx = find_paragraph(doc, "Total Number of Installment Payments:")
        if insert_after_idx is not None:
            p = insert_paragraph_after(doc.paragraphs[insert_after_idx], ach_paragraph)
            for run in p.runs:
                run.bold = False
    for paragraph in ach_blocks[1:]:
        paragraph._element.getparent().remove(paragraph._element)

    for field in ach_fields:
        matches = [p for p in doc.paragraphs if p.text.strip().startswith(field.split(":")[0] + ":")]
        for paragraph in matches[1:]:
            paragraph._element.getparent().remove(paragraph._element)

    if not any(p.text.strip().startswith("ACH Draft Authorization:") for p in doc.paragraphs):
        state_idx = None
        for idx, paragraph in enumerate(doc.paragraphs):
            if idx > 100 and paragraph.text.strip().startswith("STATE:"):
                state_idx = idx
                break
        if state_idx is not None:
            anchor = doc.paragraphs[state_idx]
            for text in ach_fields + [""]:
                p = anchor.insert_paragraph_before(text)
                if text == "ACH Draft Authorization:":
                    for run in p.runs:
                        run.bold = True


def main():
    x = normalize_values(get_docs_values())
    buyer_line1, buyer_line2 = split_address(x["buyer_address"])
    trustee_line1, trustee_line2 = split_address(x["trustee_address"])

    source = PROTOTYPE if PROTOTYPE.exists() else REFERENCE
    doc = Document(str(source))
    remove_after_contract(doc)

    # Direct paragraph substitutions at the same paragraph positions as the Cool Springs contract.
    set_paragraph(doc.paragraphs[3], f"{x['trust']}, by and through {x['trustee']}, Trustee, (Seller)", red=True)
    set_paragraph(doc.paragraphs[5], trustee_line1)
    set_paragraph(doc.paragraphs[6], trustee_line2)
    set_paragraph(doc.paragraphs[8], f"{x['buyer']}, (Purchaser)")
    set_paragraph(doc.paragraphs[10], buyer_line1)
    set_paragraph(doc.paragraphs[11], buyer_line2)
    set_paragraph(doc.paragraphs[17], x["property_address"])
    set_paragraph(doc.paragraphs[18], x["property_city_state"])
    set_paragraph(doc.paragraphs[21], x["brief_legal"] or x["legal"])
    set_paragraph(doc.paragraphs[23], f"County of: {x['county']}")

    set_first_paragraph_starting(
        doc,
        "INTEREST RATE:",
        f"INTEREST RATE: Unpaid principal shall accrue interest at a rate of {x['interest']}(APR), with interest to be amortized over the term of this Contract for Deed. The Amount of Each Installment Payment above includes any interest payable, property Insurance, and escrowed Property Tax. Late payments shall accrue interest at a rate of four percent (4%) on any delinquent monies owed.",
    )
    set_first_paragraph_starting(doc, "For the first", f"For the first {x['term_months']} instalments:")
    set_first_paragraph_starting(doc, "Due Date of the First Installment Payment:", f"Due Date of the First Installment Payment:\t{short_date(x['loan_start'])}")
    set_first_paragraph_starting(doc, "Due Date of the Last Installment Payment:", f"Due Date of the Last Installment Payment:\t{short_date(x['loan_end'])}")
    set_first_paragraph_starting(doc, "Principal and Interest:", f"Principal and Interest:\t{money(x['monthly_pi']).replace('$', '')}")
    set_first_paragraph_starting(doc, "Property Insurance:", f"Property Insurance:\t\t {money(x['insurance']).replace('$', '')}")
    set_first_paragraph_starting(doc, "Property Tax:", f"Property Tax:\t\t {money(x['tax']).replace('$', '')}")
    set_first_paragraph_starting(doc, "Total Monthly Payment:", f"Total Monthly Payment:\t{money(x['total_payment']).replace('$', '')}")
    set_first_paragraph_starting(doc, "Total Number of Installment Payments:", f"Total Number of Installment Payments:\t{x['term_months']}")
    set_adverse_condition(doc, x["adverse"])

    set_seller_signature_manager(doc, x)
    set_receipt_acknowledgment(doc, x)
    set_seller_notary_manager(doc, x)
    set_purchaser_notary(doc, x)
    apply_notary_block_revisions(doc, x)
    ensure_notary_signature_lines(doc)
    ensure_ach_terms(doc)

    # Table 0 is the price table in the contract. Keep the table formatting and replace only values.
    table = doc.tables[0]
    table.cell(0, 1).text = money(x["down_payment"]).replace("$", "")
    loan_row = 6 if len(table.rows) > 6 else len(table.rows) - 2
    total_row = 8 if len(table.rows) == 9 else 9
    if len(table.rows) > 2:
        table.cell(2, 1).text = ""
    table.cell(loan_row, 1).text = money(x["loan_amount"]).replace("$", "")
    table.cell(total_row, 1).text = money(x["sale_price"]).replace("$", "")

    replace_text_in_paragraphs(
        doc,
        {
            "02/    /2025.": "06/    /2026.",
            "2025.": "2026.",
            "Lee": x["county"].title(),
        },
    )

    trim_after_last_notary(doc)
    doc.save(OUTPUT)
    print(OUTPUT)


if __name__ == "__main__":
    main()
