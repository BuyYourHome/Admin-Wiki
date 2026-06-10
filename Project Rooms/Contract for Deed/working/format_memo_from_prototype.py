from pathlib import Path

from docx import Document
from docx.oxml.ns import qn
from docx.shared import RGBColor

from build_rose_drafts import get_docs_values, normalize_values, short_date


ROOT = Path(r"C:\Codex\Wiki Files\Project Rooms\Contract for Deed")
PROTOTYPE = ROOT / "reference" / "Rose memorandum prototype" / "320 Rose - Memorandum of Contract for Deed - PROTOTYPE.docx"
OUTPUT = ROOT / "output" / "320 Rose - Memorandum of Contract for Deed - DRAFT.docx"


def set_paragraph(paragraph, text, blue=False):
    if not paragraph.runs:
        paragraph.add_run("")
    for run in paragraph.runs:
        run.text = ""
    run = paragraph.runs[0]
    run.text = str(text)
    if blue:
        run.font.color.rgb = RGBColor(0, 0, 255)


def set_paragraph_bold(paragraph, text):
    set_paragraph(paragraph, text)
    for run in paragraph.runs:
        if run.text:
            run.bold = True


def set_mixed_runs(paragraph, segments):
    if not paragraph.runs:
        paragraph.add_run("")
    for run in paragraph.runs:
        run.text = ""
    first = paragraph.runs[0]
    for idx, (text, bold) in enumerate(segments):
        run = first if idx == 0 else paragraph.add_run()
        run.text = str(text)
        run.bold = bold


def set_section_paragraph(paragraph, title, body=""):
    if not paragraph.runs:
        paragraph.add_run("")
    for run in paragraph.runs:
        run.text = ""
    title_run = paragraph.runs[0]
    title_run.text = title
    title_run.bold = True
    if body:
        body_run = paragraph.add_run(body)
        body_run.bold = True


def set_label_value(paragraph, label, value):
    if not paragraph.runs:
        paragraph.add_run("")
    for run in paragraph.runs:
        run.text = ""
    label_run = paragraph.runs[0]
    label_run.text = label
    value_run = paragraph.add_run(str(value))
    value_run.bold = True


def split_address(address):
    parts = [part.strip() for part in str(address).split(",") if part.strip()]
    if len(parts) >= 3:
        return parts[0], f"{parts[1]}, {parts[2]}"
    if len(parts) == 2:
        return parts[0], parts[1]
    return str(address), ""


def replace_legacy_buyer_name_variants(doc, x):
    buyer2 = (x.get("buyer2") or "").strip()
    if not buyer2:
        return
    legacy_buyer2_names = [
        "Maria Sarmjento",
        "Maria Sarmiento",
        "Maria Geraldine Sarmiento",
        "Maria Geraldina Sarmiento",
    ]
    replacements = {}
    for old in legacy_buyer2_names:
        if old != buyer2:
            replacements[old] = buyer2
            replacements[old.upper()] = buyer2.upper()

    def update_paragraph(paragraph):
        text = paragraph.text
        new_text = text
        for old, new in replacements.items():
            new_text = new_text.replace(old, new)
        if new_text != text:
            set_paragraph(paragraph, new_text)

    for paragraph in doc.paragraphs:
        update_paragraph(paragraph)
    for table in doc.tables:
        for row in table.rows:
            for cell in row.cells:
                for paragraph in cell.paragraphs:
                    update_paragraph(paragraph)


def replace_or_update(doc, startswith, text):
    for paragraph in doc.paragraphs:
        if paragraph.text.strip().startswith(startswith):
            set_paragraph(paragraph, text)
            return True
    return False


def replace_or_update_bold(doc, startswith, text):
    for paragraph in doc.paragraphs:
        if paragraph.text.strip().startswith(startswith):
            set_paragraph_bold(paragraph, text)
            return True
    return False


def replace_section_or_update(doc, startswith, title, body=""):
    for paragraph in doc.paragraphs:
        if paragraph.text.strip().startswith(startswith):
            set_section_paragraph(paragraph, title, body)
            return True
    return False


def replace_label_or_update(doc, startswith, label, value):
    for paragraph in doc.paragraphs:
        if paragraph.text.strip().startswith(startswith):
            set_label_value(paragraph, label, value)
            return True
    return False


def remove_page_breaks_from_section(doc, startswith):
    for paragraph in doc.paragraphs:
        if not paragraph.text.strip().startswith(startswith):
            continue
        for br in list(paragraph._p.xpath(".//w:br")):
            if br.get(qn("w:type")) == "page":
                br.getparent().remove(br)
        return


def fill_county_and_date(doc, x):
    county = x["county"]
    date_value = x["loan_start"]
    month = date_value.strftime("%B")
    year = str(date_value.year)

    for paragraph in doc.paragraphs:
        text = paragraph.text.strip()
        if text.startswith("STATE OF NORTH CAROLINA") and "COUNTY OF" in text:
            set_mixed_runs(
                paragraph,
                [
                    ("STATE OF ", False),
                    ("NORTH CAROLINA", True),
                    ("    COUNTY OF ", False),
                    (county, True),
                ],
            )
            break

    for paragraph in doc.paragraphs:
        text = paragraph.text.strip()
        if text.startswith("this ____ day of"):
            set_mixed_runs(
                paragraph,
                [
                    ("this ____ day of ", False),
                    (month, True),
                    (", ", False),
                    (year, True),
                    (", to memorialize the Contract for Deed of even date hereto.", False),
                ],
            )
            return


def fill_notary_counties(doc, x):
    for paragraph in doc.paragraphs:
        text = paragraph.text.strip()
        if text.startswith("COUNTY OF") and "STATE OF NORTH CAROLINA" not in text:
            set_mixed_runs(paragraph, [("COUNTY OF: ", False), ("\t", False), (x["county"], True)])
        elif text.startswith("STATE OF:"):
            set_mixed_runs(paragraph, [("STATE OF", False), (":", False), (" ", False), ("\t", False), ("NORTH CAROLINA", True)])


def update_notary_acknowledgments(doc, x):
    buyer = x["buyer"]
    buyer2 = x.get("buyer2") or ""
    legacy_buyer_names = ["Ever Cardoza", "Maria Sarmjento", "Maria Sarmiento", "Maria Geraldine Sarmiento"]
    seller_segments = [
        ("I certify that the following person(s) personally appeared before me this day, each acknowledging to me that he/she/they signed the foregoing document: ", False),
        (x["manager"], True),
        (", Manager of ", False),
        (x["trustee"], True),
        (", Trustee of ", False),
        (x["trust"], True),
        (".", False),
    ]
    buyer_segments = [
        ("I certify that the following person(s) personally appeared before me this day, each acknowledging to me that he/she/they signed the foregoing document: ", False),
        (buyer, True),
        (".", False),
    ]
    for paragraph in doc.paragraphs:
        text = paragraph.text
        if "personally appeared before me this day" not in text:
            continue
        if x["manager"] in text or x["trustee"] in text or x["trust"] in text:
            set_mixed_runs(paragraph, seller_segments)
        elif any(name and name in text for name in [buyer, buyer2, *legacy_buyer_names]):
            set_mixed_runs(paragraph, buyer_segments)


def notary_block_lines(county, signer_text):
    return [
        "STATE OF: NORTH CAROLINA",
        f"COUNTY OF: {str(county).upper()}",
        (
            "I certify that the following person(s) personally appeared before me this day, "
            "each acknowledging to me that he/she/they signed the foregoing document: "
            f"{signer_text}."
        ),
        "Date: ____________________",
        "Official Signature of Notary: ________________________________________",
        "Notary's printed or typed name: ______________________________, Notary Public",
        "My commission expires: ______________________",
    ]


def replace_paragraph_range_with_lines(doc, start_idx, end_idx, lines):
    anchor = doc.paragraphs[start_idx]
    inserted = []
    for text in lines:
        inserted.append(anchor.insert_paragraph_before(text))
    body = doc._body._element
    for paragraph in doc.paragraphs[start_idx + len(inserted) : end_idx + 1 + len(inserted)]:
        body.remove(paragraph._element)


def standardize_notary_blocks(doc, x):
    signer_order = [
        f"{x['manager']}, Manager of {x['trustee']}, Trustee of {x['trust']}",
        x["buyer"],
    ]
    starts = []
    for idx, paragraph in enumerate(doc.paragraphs):
        text = paragraph.text.strip().upper()
        if not text.startswith("STATE OF"):
            continue
        window = "\n".join(p.text for p in doc.paragraphs[idx : min(len(doc.paragraphs), idx + 10)])
        if "personally appeared before me this day" in window:
            starts.append(idx)
    for block_number, start_idx in reversed(list(enumerate(starts[:2]))):
        end_idx = None
        for idx in range(start_idx, min(len(doc.paragraphs), start_idx + 12)):
            if doc.paragraphs[idx].text.strip().lower().startswith("my commission expires"):
                end_idx = idx
                break
        if end_idx is None:
            continue
        replace_paragraph_range_with_lines(
            doc,
            start_idx,
            end_idx,
            notary_block_lines(x["county"], signer_order[block_number]),
        )


def update_seller_signature_fields(doc, x):
    in_seller_block = False
    for paragraph in doc.paragraphs:
        text = paragraph.text.strip()
        if text.startswith("SELLER:"):
            in_seller_block = True
            continue
        if in_seller_block and text.startswith("STATE OF"):
            break
        if not in_seller_block:
            continue
        if x["trust"] in text:
            set_paragraph_bold(paragraph, x["trust"])
        elif text.startswith("By:") and x["trustee"] in text:
            set_mixed_runs(paragraph, [("By: ", False), (x["trustee"], True), (", Trustee", True)])
        elif text.startswith("Printed Name:"):
            set_mixed_runs(paragraph, [("Printed Name: ", False), (f"{x['manager']}, Manager", True)])
        elif text.startswith("Title:") and x["trustee"] in text:
            set_mixed_runs(paragraph, [("Title: Manager of ", False), (x["trustee"], True), (", Trustee", True)])


def ensure_two_buyer_signature_lines(doc, x):
    buyers = [name.strip() for name in (x.get("buyer1"), x.get("buyer2")) if name and name.strip()]
    if not buyers:
        buyers = [name.strip() for name in str(x["buyer"]).split(" and ") if name.strip()]
    if len(buyers) == 1:
        buyers.append("______________________________________")

    replacement = [
        buyers[0],
        "By: ______________________________________ (SEAL)",
        f"Printed Name: {buyers[0]}",
        "Date: ______________________",
        buyers[1],
        "By: ______________________________________ (SEAL)",
        f"Printed Name: {buyers[1]}",
        "Date: ______________________",
    ]

    paragraphs = list(doc.paragraphs)
    for idx, paragraph in enumerate(paragraphs):
        if not paragraph.text.strip().startswith("PURCHASER:"):
            continue

        insert_after = paragraph._p
        remove = []
        for following in paragraphs[idx + 1 :]:
            text = following.text.strip()
            if text.startswith("STATE OF ") or text.startswith("COUNTY OF "):
                break
            remove.append(following)

        for old in remove:
            old._element.getparent().remove(old._element)

        for text in reversed(replacement):
            new_p = paragraph.insert_paragraph_before(text)
            if text in buyers:
                for run in new_p.runs:
                    run.bold = True
            elif text.startswith("Printed Name:"):
                name = text.replace("Printed Name:", "").strip()
                set_mixed_runs(new_p, [("Printed Name:", False), (" ", False), (name, True)])
            insert_after.addnext(new_p._p)
        return

    doc.add_paragraph("")
    doc.add_paragraph("PURCHASER:")
    for text in replacement:
        p = doc.add_paragraph(text)
        if text in buyers:
            for run in p.runs:
                run.bold = True
        elif text.startswith("Printed Name:"):
            name = text.replace("Printed Name:", "").strip()
            set_mixed_runs(p, [("Printed Name:", False), (" ", False), (name, True)])


def update_buyer_signature_fields(doc, x):
    buyers = [name.strip() for name in str(x["buyer"]).split(" and ") if name.strip()]
    if not buyers:
        return
    in_purchaser_block = False
    buyer_index = 0
    for paragraph in doc.paragraphs:
        text = paragraph.text.strip()
        if text.startswith("PURCHASER:"):
            in_purchaser_block = True
            continue
        if in_purchaser_block and text.startswith("STATE OF"):
            break
        if not in_purchaser_block:
            continue
        if text.startswith("Printed Name:") and buyer_index < len(buyers):
            set_mixed_runs(paragraph, [("Printed Name:", False), (" ", False), (buyers[buyer_index], True)])
            buyer_index += 1
            continue
        if text in buyers or text in ("Ever Cardoza", "Maria Sarmjento", "Maria Sarmiento", "Maria Geraldine Sarmiento"):
            match_index = min(buyer_index, len(buyers) - 1)
            set_paragraph_bold(paragraph, buyers[match_index])


def main():
    x = normalize_values(get_docs_values())
    doc = Document(str(PROTOTYPE))
    buyer_line1, buyer_line2 = split_address(x["buyer_address"])

    fill_county_and_date(doc, x)

    replace_section_or_update(
        doc,
        "1. PARTIES.",
        "1. PARTIES.",
        "",
    )
    replace_label_or_update(doc, "Seller address:", "Seller address: ", x["trustee_address"])
    replace_label_or_update(doc, "Purchaser address:", "Purchaser address: ", f"{buyer_line1}, {buyer_line2}".strip(", "))
    replace_section_or_update(doc, "2. REAL PROPERTY.", "2. REAL PROPERTY.", f" {x['property_address']}, {x['property_city_state']}")
    replace_label_or_update(doc, "Legal Description:", "Legal Description: ", x["legal"])
    replace_label_or_update(doc, "County / Parcel ID:", "County / Parcel ID: ", f"{x['county']} / {x['parcel']}")
    replace_label_or_update(doc, "County:", "County: ", x["county"])
    replace_label_or_update(doc, "Parcel ID:", "Parcel ID: ", x["parcel"])
    replace_label_or_update(doc, "Due Date of the First Installment Payment:", "Due Date of the First Installment Payment: ", short_date(x["loan_start"]))
    replace_label_or_update(doc, "Due Date of the Last Installment Payment:", "Due Date of the Last Installment Payment: ", short_date(x["loan_end"]))
    replace_label_or_update(doc, "Total Number of Installment Payments:", "Total Number of Installment Payments: ", x["term_months"])
    fill_notary_counties(doc, x)
    update_seller_signature_fields(doc, x)
    update_notary_acknowledgments(doc, x)
    standardize_notary_blocks(doc, x)
    remove_page_breaks_from_section(doc, "5. RIGHT TO CANCEL.")

    update_buyer_signature_fields(doc, x)
    replace_legacy_buyer_name_variants(doc, x)
    doc.save(OUTPUT)
    print(OUTPUT)


if __name__ == "__main__":
    main()
