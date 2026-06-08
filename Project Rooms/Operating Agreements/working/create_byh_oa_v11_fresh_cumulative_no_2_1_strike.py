import copy
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}
XML_SPACE = "{http://www.w3.org/XML/1998/namespace}space"

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "sources" / "Jeff Watson" / "Simplified OA - 25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx"
OUT_DIR = BASE / "sources" / "Jeff Watson" / "BYH"
OUT = OUT_DIR / "BYH OA Draft V11 Fresh Cumulative No 2.1 Strike - from Simplified OA.docx"
NOTES = OUT_DIR / "BYH OA Draft V11 Fresh Cumulative No 2.1 Strike Notes.md"
COMPARE = OUT_DIR / "BYH OA V11 Fresh Build vs V10 Comparison.md"
V10 = OUT_DIR / "BYH OA Draft V10 Fresh Cumulative Build - from Simplified OA.docx"


def qn(tag):
    return f"{{{W}}}{tag}"


def text_of(el):
    return "".join(el.xpath(".//w:t/text()", namespaces=NS))


def para_texts_from_docx(path):
    with zipfile.ZipFile(path, "r") as z:
        root = etree.fromstring(z.read("word/document.xml"))
    return ["".join(p.xpath(".//w:t/text()", namespaces=NS)).strip() for p in root.xpath(".//w:p", namespaces=NS)]


def red_run(text):
    r = etree.Element(qn("r"))
    rpr = etree.SubElement(r, qn("rPr"))
    color = etree.SubElement(rpr, qn("color"))
    color.set(qn("val"), "C00000")
    t = etree.SubElement(r, qn("t"))
    t.set(XML_SPACE, "preserve")
    t.text = text
    return r


def make_red_para(text, after_p=None, page_break_before=False):
    p = etree.Element(qn("p"))
    if after_p is not None:
        ppr = after_p.find("w:pPr", NS)
        if ppr is not None:
            p.append(copy.deepcopy(ppr))
    if page_break_before:
        ppr = p.find("w:pPr", NS)
        if ppr is None:
            ppr = etree.Element(qn("pPr"))
            p.insert(0, ppr)
        etree.SubElement(ppr, qn("pageBreakBefore"))
    p.append(red_run(text))
    return p


def make_blank_para(after_p=None, page_break_before=False):
    return make_red_para("", after_p, page_break_before=page_break_before)


def strike_run(run):
    rpr = run.find("w:rPr", NS)
    if rpr is None:
        rpr = etree.Element(qn("rPr"))
        run.insert(0, rpr)
    if rpr.find("w:strike", NS) is None:
        strike = etree.SubElement(rpr, qn("strike"))
        strike.set(qn("val"), "true")


def strike_paragraph(p):
    for run in p.findall(".//w:r", NS):
        strike_run(run)


def insert_after(parent, existing, new_el):
    parent.insert(parent.index(existing) + 1, new_el)


def insert_lines_after(body, anchor, lines, template=None, page_break_first=False):
    cur = anchor
    for idx, line in enumerate(lines):
        p = make_red_para(line, template or anchor, page_break_before=(idx == 0 and page_break_first))
        insert_after(body, cur, p)
        cur = p
    return cur


def replace_paragraph_runs(p, segments):
    ppr = p.find("w:pPr", NS)
    preserved_ppr = copy.deepcopy(ppr) if ppr is not None else None
    for child in list(p):
        p.remove(child)
    if preserved_ppr is not None:
        p.append(preserved_ppr)
    for mode, text in segments:
        if not text:
            continue
        r = etree.Element(qn("r"))
        if mode in {"red", "strike"}:
            rpr = etree.SubElement(r, qn("rPr"))
            if mode == "red":
                color = etree.SubElement(rpr, qn("color"))
                color.set(qn("val"), "C00000")
            else:
                strike = etree.SubElement(rpr, qn("strike"))
                strike.set(qn("val"), "true")
        t = etree.SubElement(r, qn("t"))
        t.set(XML_SPACE, "preserve")
        t.text = text
        p.append(r)


def run_level_replacements(root):
    replacements = [
        ("SELL YOUR HOME, LLC", "BUY YOUR HOME, LLC"),
        ("Sell Your Home, LLC", "Buy Your Home, LLC"),
        ("SELL YOUR HOME", "BUY YOUR HOME"),
        ("Sell Your Home", "Buy Your Home"),
        ("Jessica Santacruz", "Wesley Dale Browning"),
        ("Jessica Santcruz", "Wesley Dale Browning"),
    ]
    for run in list(root.xpath(".//w:r[w:t]", namespaces=NS)):
        texts = run.findall("w:t", NS)
        if len(texts) != 1:
            continue
        original = texts[0].text or ""
        if not any(old in original for old, _new in replacements):
            continue
        parent = run.getparent()
        index = parent.index(run)
        parent.remove(run)
        pos = 0
        out = []
        while pos < len(original):
            best = None
            for old, new in replacements:
                hit = original.find(old, pos)
                if hit != -1 and (best is None or hit < best[0] or (hit == best[0] and len(old) > len(best[1]))):
                    best = (hit, old, new)
            if best is None:
                out.append(("normal", original[pos:]))
                break
            hit, old, new = best
            if hit > pos:
                out.append(("normal", original[pos:hit]))
            out.append(("strike", old))
            out.append(("red", " " + new))
            pos = hit + len(old)
        for offset, (mode, value) in enumerate([(m, v) for m, v in out if v]):
            new_run = copy.deepcopy(run)
            for t in new_run.findall(".//w:t", NS):
                t.text = value
            if mode in {"red", "strike"}:
                rpr = new_run.find("w:rPr", NS)
                if rpr is None:
                    rpr = etree.Element(qn("rPr"))
                    new_run.insert(0, rpr)
                if mode == "red":
                    for color in rpr.findall("w:color", NS):
                        rpr.remove(color)
                    color = etree.SubElement(rpr, qn("color"))
                    color.set(qn("val"), "C00000")
                else:
                    if rpr.find("w:strike", NS) is None:
                        etree.SubElement(rpr, qn("strike")).set(qn("val"), "true")
            parent.insert(index + offset, new_run)


def build_docx():
    with zipfile.ZipFile(SOURCE, "r") as z:
        root = etree.fromstring(z.read("word/document.xml"))
    body = root.find("w:body", NS)
    run_level_replacements(root)

    paragraphs = body.findall("w:p", NS)

    # Opening retirement-account member substitution block.
    member_intro_inserted = False
    for p in list(body.findall("w:p", NS)):
        txt = text_of(p)
        if "Quest Trust Company FBO" in txt or "Heritage IRA FBO" in txt:
            strike_paragraph(p)
            if not member_intro_inserted:
                insert_lines_after(
                    body,
                    p,
                    [
                        "Browning Family Revocable Trust is the sole Member of the Company.",
                        "The sole Member acts through its co-trustees, Wesley Dale Browning and Jeanette Wilson Hollinger, or any successor trustee authorized under the Browning Family Revocable Trust documents.",
                    ],
                    template=p,
                )
                member_intro_inserted = True

    # Article 2 cumulative structure. Preserve the source 2.1 and avoid duplicating it as 2.2.
    article2 = None
    for p in body.findall("w:p", NS):
        txt = text_of(p).strip()
        if txt == "Membership Units":
            article2 = p
    if article2 is not None:
        insert_lines_after(
            body,
            article2,
            [
                "Sole Member and Voting Authority. Browning Family Revocable Trust is the sole Member of the Company and holds 100% of the Membership Units. The co-trustees of Browning Family Revocable Trust, currently Wesley Dale Browning and Jeanette Wilson Hollinger, exercise the voting authority of the sole Member and are not separate Members solely by reason of serving as co-trustees.",
            ],
            template=article2,
        )

    # Section 3.7 Account Holder note and retirement-only account-holder references.
    for p in body.findall("w:p", NS):
        txt = text_of(p)
        if txt.startswith("Note:") and "Account Holder" in txt and "IRA, HSA" in txt and "Coverdell ESA" in txt:
            strike_paragraph(p)
        if "If the sale is due to death or permanent disability of a Member or an Account Holder" in txt:
            replace_paragraph_runs(
                p,
                [
                    ("normal", txt.replace(" or an Account Holder", "")),
                ],
            )
        if "Buy-Sell Rights After Death or Disability of Member or Account Holder" in txt:
            replace_paragraph_runs(
                p,
                [
                    ("strike", "Buy-Sell Rights After Death or Disability of Member or Account Holder."),
                    ("red", "Buy-Sell Rights After Death or Disability of Member."),
                    ("normal", txt.split(".", 1)[1].replace("—or the Account Holder of a Member that is not an individual—", "")),
                ],
            )

    # 4.10 inline trust voting.
    for p in body.findall("w:p", NS):
        txt = text_of(p)
        if txt == "Units held by an entity (like a business or trust) must be voted by the person the entity designates in writing.":
            replace_paragraph_runs(
                p,
                [
                    ("normal", "Units held by "),
                    ("strike", "an entity (like a business or trust)"),
                    ("red", "Browning Family Revocable Trust"),
                    ("normal", " must be voted by "),
                    ("strike", "the person the entity designates in writing"),
                    ("red", "its co-trustees, currently Wesley Dale Browning and Jeanette Wilson Hollinger, unless the Trust documents or Company records designate a different authorized trustee or representative"),
                    ("normal", "."),
                ],
            )

    # Article 5 manager structure and retirement-account-only restrictions.
    for p in body.findall("w:p", NS):
        txt = text_of(p).strip()
        if txt.startswith("Manager(s) – Number and Tenure."):
            strike_paragraph(p)
            insert_after(
                body,
                p,
                make_red_para(
                    "Manager(s) – Number and Tenure. The Company will have one or more Manager(s). The current Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC. Each Manager will serve until replaced, resigns, or is removed. The number of Manager(s) may be increased or decreased by the sole Member, Browning Family Revocable Trust, acting through its co-trustees or other authorized trustee authority. A Manager does not have to be a Member or own any Units.",
                    p,
                ),
            )
        elif (
            "Manager(s) need not be Members and cannot be disqualified persons" in txt
            or "Manager shall not be the Account Holder" in txt
            or "will have no signature authority, operational responsibility" in txt
            or "if a Manager is also an Account Holder" in txt
        ):
            strike_paragraph(p)
        elif txt.startswith("Borrowing on a non recourse basis over $10,000"):
            replace_paragraph_runs(
                p,
                [
                    ("normal", "Borrowing "),
                    ("strike", "on a non recourse basis "),
                    ("normal", "over $10,000 in one year for a capital asset or improvement."),
                ],
            )

    # Tax classification heading and S corporation classification.
    for p in body.findall("w:p", NS):
        txt = text_of(p)
        if txt.startswith("Company as Pass-Through Entity."):
            replace_paragraph_runs(
                p,
                [
                    ("strike", "Company as Pass-Through Entity."),
                    ("red", " Company Tax Classification."),
                    ("normal", " The Company will be treated as "),
                    ("strike", "a pass-through entity for federal tax purposes—either as a disregarded entity (if it has one Member) or a partnership (if it has multiple Members)"),
                    ("red", "an S corporation after a valid S election"),
                    ("normal", ". "),
                    ("strike", "The Manager(s) must not take any action to change this classification."),
                    ("red", "The Manager(s) must not take any action inconsistent with maintaining the Company's intended S corporation tax status."),
                ],
            )
            break

    # Strike retirement-account-specific special provisions, except 5.1(b)(xi), which lives earlier and is untouched.
    for p in body.findall("w:p", NS):
        txt = text_of(p)
        if (
            "Some Members are IRAs" in txt
            or "Unrelated Business Taxable Income" in txt
            or "Annual Valuations." in txt
            or "Required Minimum Distributions" in txt
            or "Members described in Section 9.1 or any “disqualified person”" in txt
        ):
            strike_paragraph(p)

    # Signature/certification block.
    paras = body.findall("w:p", NS)
    cert_idx = next(i for i, p in enumerate(paras) if text_of(p).strip() == "CERTIFICATION")
    exhibit_idx = next(i for i, p in enumerate(paras) if text_of(p).strip() == "EXHIBIT A")
    cert_paras = body.findall("w:p", NS)[cert_idx + 1 : exhibit_idx]
    for p in cert_paras:
        if text_of(p).strip():
            strike_paragraph(p)
    cert = body.findall("w:p", NS)[cert_idx]
    after = insert_lines_after(
        body,
        cert,
        [
            "THE UNDERSIGNED, being the sole Member and all Manager(s) of the Company, hereby evidence their adoption and ratification of this Amended and Restated Operating Agreement for and on behalf of themselves and the Company, effective June ____, 2025.",
            "",
            "SOLE MEMBER:",
            "Browning Family Revocable Trust",
            "",
            "By: ____________________________________",
            "Wesley Dale Browning, Co-Trustee",
            "",
            "By: ____________________________________",
            "Jeanette Wilson Hollinger, Co-Trustee",
        ],
        template=cert,
    )
    insert_lines_after(
        body,
        after,
        [
            "MANAGER(S):",
            "",
            "Wesley Dale Browning, Manager",
            "",
            "By: ____________________________________",
            "Wesley Dale Browning",
            "",
            "Jeanette Wilson Hollinger, Manager",
            "",
            "By: ____________________________________",
            "Jeanette Wilson Hollinger",
            "",
            "Investment Services LLC, Manager",
            "",
            "By: ____________________________________",
            "Name: Wesley Dale Browning",
            "Title: Authorized Representative",
        ],
        template=cert,
        page_break_first=True,
    )

    # Exhibit A.
    all_paras = root.xpath(".//w:p", namespaces=NS)
    exhibit_para = next(p for p in all_paras if text_of(p).strip() == "EXHIBIT A")
    seen_exhibit = False
    for p in all_paras:
        if p is exhibit_para:
            seen_exhibit = True
            continue
        if not seen_exhibit:
            continue
        if text_of(p).strip():
            strike_paragraph(p)
    insert_lines_after(
        body,
        exhibit_para,
        [
            "Member Name, Address",
            "Browning Family Revocable Trust",
            "c/o Wesley Dale Browning and Jeanette Wilson Hollinger, Co-Trustees",
            "2156 Haig Point Way",
            "Raleigh, NC 27604",
            "",
            "Membership Units",
            "100 Membership Units",
            "",
            "Percentage Interest",
            "100%",
            "",
            "Voting / Signing Authority",
            "Wesley Dale Browning and Jeanette Wilson Hollinger, Co-Trustees",
        ],
        template=exhibit_para,
    )

    xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    replace_docx_body_xml(SOURCE, OUT, xml)


def replace_docx_body_xml(source_zip_path, out_path, new_xml):
    tmp = out_path.with_suffix(out_path.suffix + ".tmp")
    with zipfile.ZipFile(source_zip_path, "r") as src, zipfile.ZipFile(tmp, "w", compression=zipfile.ZIP_DEFLATED) as dst:
        for item in src.infolist():
            if item.filename == "word/document.xml":
                dst.writestr(item, new_xml)
            else:
                dst.writestr(item, src.read(item.filename))
    tmp.replace(out_path)


def write_notes_and_comparison():
    v11 = para_texts_from_docx(OUT)
    v10 = para_texts_from_docx(V10) if V10.exists() else []
    v11_full = "\n".join(v11)
    v10_full = "\n".join(v10)

    checks = [
        ("Original Membership Units Authorized paragraph present", "Membership Units Authorized." in v11_full, "Membership Units Authorized." in v10_full),
        ("No duplicate 2.2 Membership Units Authorized", "2.2 Membership Units Authorized." not in v11_full, "2.2 Membership Units Authorized." not in v10_full),
        ("Sole-member/trustee-voting language added", "Sole Member and Voting Authority." in v11_full, "Sole Member and Voting Authority." in v10_full),
        ("Current Manager(s)", "The current Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC" in v11_full, "The current Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC" in v10_full),
        ("5.1(b)(xi) retained", "Any increase or decrease in the number of Manager(s)." in v11_full, "Any increase or decrease in the number of Manager(s)." in v10_full),
        ("Tax heading conformed", "Company Tax Classification." in v11_full, "Company Tax Classification." in v10_full),
        ("Manager signature block", "MANAGER(S):" in v11_full and "Investment Services LLC, Manager" in v11_full, "MANAGER(S):" in v10_full and "Investment Services LLC, Manager" in v10_full),
        ("Exhibit A rebuilt as operative language", "Browning Family Revocable Trust\nc/o Wesley Dale Browning" in v11_full, "Browning Family Revocable Trust\nc/o Wesley Dale Browning" in v10_full),
    ]

    NOTES.write_text(
        "# BYH OA Draft V11 Fresh Cumulative No 2.1 Strike Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Build method:\n\n"
        "- Generated fresh from the Simplified OA source using cumulative BYH instructions.\n"
        "- Did not use V10 as the input document.\n"
        "- V10 was used only for comparison after generation.\n\n"
        "Cumulative instructions applied:\n\n"
        "- Buy Your Home, LLC entity naming.\n"
        "- Browning Family Revocable Trust as sole Member.\n"
        "- Co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger as voting authority for the Trust.\n"
        "- Current Manager(s): Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC.\n"
        "- Preserve one-or-more Manager(s) structure.\n"
        "- Strike retirement-account-only member/signature/account-holder/disqualified-person/RMD/UBTI/UDFI provisions.\n"
        "- Strike only `on a non recourse basis` in 5.1(b)(iv).\n"
        "- Preserve 5.1(b)(xi).\n"
        "- Preserve the original 2.1 Membership Units Authorized paragraph without strikethrough.\n"
        "- Do not insert a duplicate 2.2 Membership Units Authorized paragraph.\n"
        "- Add sole-member/trustee-voting language without creating a 2.1/2.2 numbering conflict.\n"
        "- Conform the tax classification heading.\n"
        "- Separate Manager(s) certification onto a new page with three Manager groups.\n"
        "- Rebuild Exhibit A as operative sole-member language.\n",
        encoding="utf-8",
    )

    rows = ["| Check | V11 Fresh Cumulative | V10 Fresh Cumulative |", "| --- | --- | --- |"]
    for label, v11_ok, v10_ok in checks:
        rows.append(f"| {label} | {'yes' if v11_ok else 'no'} | {'yes' if v10_ok else 'no'} |")
    COMPARE.write_text(
        "# BYH OA V11 Fresh Build vs V10 Comparison\n\n"
        "V11 was generated fresh from the Simplified OA source using the cumulative instruction set. V10 was also fresh, but struck the original 2.1 and inserted duplicate 2.2 language.\n\n"
        + "\n".join(rows)
        + "\n\n## Practical Difference\n\n"
        "- V11 keeps the original 2.1 paragraph in place and does not add the duplicate 2.2 paragraph.\n"
        "- V11 still applies the cumulative BYH facts from the Simplified OA source.\n"
        "- V11 should replace V10 as the better baseline for the next review pass.\n",
        encoding="utf-8",
    )


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    build_docx()
    with zipfile.ZipFile(OUT, "r") as z:
        bad = z.testzip()
        if bad:
            raise RuntimeError(f"Corrupt DOCX entry: {bad}")
    write_notes_and_comparison()
    print(str(OUT))


if __name__ == "__main__":
    main()
