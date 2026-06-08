import copy
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}
XML_SPACE = "{http://www.w3.org/XML/1998/namespace}space"

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "sources" / "Jeff Watson" / "Simplified OA - 25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx"
OUT_DIR = BASE / "working" / "BYH"
OUT = OUT_DIR / "V13 - BYH OA Draft Clean Certification and Exhibit A - from Simplified OA.docx"
NOTES = OUT_DIR / "V13 - BYH OA Draft Clean Certification and Exhibit A Notes.md"
COMPARE = OUT_DIR / "V13 - BYH OA vs V12 Comparison.md"
V12 = OUT_DIR / "BYH OA Draft V12 Format Preserving Article 5 - from Simplified OA.docx"
BYH_COLOR = "008000"


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
    color.set(qn("val"), BYH_COLOR)
    t = etree.SubElement(r, qn("t"))
    t.set(XML_SPACE, "preserve")
    t.text = text
    return r


def make_red_para(text, after_p=None, page_break_before=False, spacing_after=None, spacing_before=None):
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
    if spacing_after is not None or spacing_before is not None:
        set_para_spacing(p, after=spacing_after, before=spacing_before)
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


def run_rpr(run):
    rpr = run.find("w:rPr", NS)
    return copy.deepcopy(rpr) if rpr is not None else etree.Element(qn("rPr"))


def set_rpr_color(rpr, color_value):
    for color in rpr.findall("w:color", NS):
        rpr.remove(color)
    color = etree.SubElement(rpr, qn("color"))
    color.set(qn("val"), color_value)


def set_para_spacing(p, *, after=None, before=None, line=None):
    ppr = p.find("w:pPr", NS)
    if ppr is None:
        ppr = etree.Element(qn("pPr"))
        p.insert(0, ppr)
    spacing = ppr.find("w:spacing", NS)
    if spacing is None:
        spacing = etree.SubElement(ppr, qn("spacing"))
    if after is not None:
        spacing.set(qn("after"), str(after))
    if before is not None:
        spacing.set(qn("before"), str(before))
    if line is not None:
        spacing.set(qn("line"), str(line))
        spacing.set(qn("lineRule"), "auto")


def ensure_rpr_strike(rpr):
    if rpr.find("w:strike", NS) is None:
        strike = etree.SubElement(rpr, qn("strike"))
        strike.set(qn("val"), "true")


def make_formatted_run(text, prototype_run, *, red=False, strike=False):
    r = etree.Element(qn("r"))
    rpr = run_rpr(prototype_run) if prototype_run is not None else etree.Element(qn("rPr"))
    if red:
        set_rpr_color(rpr, BYH_COLOR)
    if strike:
        ensure_rpr_strike(rpr)
    if len(rpr):
        r.append(rpr)
    t = etree.SubElement(r, qn("t"))
    t.set(XML_SPACE, "preserve")
    t.text = text
    return r


def remove_numbering_style(p):
    ppr = p.find("w:pPr", NS)
    if ppr is None:
        return
    for tag in ("pStyle", "numPr"):
        el = ppr.find(f"w:{tag}", NS)
        if el is not None:
            ppr.remove(el)


def strike_paragraph(p):
    for run in p.findall(".//w:r", NS):
        strike_run(run)


def insert_after(parent, existing, new_el):
    parent.insert(parent.index(existing) + 1, new_el)


def insert_lines_after(body, anchor, lines, template=None, page_break_first=False, spacing_after=None, spacing_before=None):
    cur = anchor
    for idx, line in enumerate(lines):
        p = make_red_para(
            line,
            template if template is not None else anchor,
            page_break_before=(idx == 0 and page_break_first),
            spacing_after=spacing_after,
            spacing_before=spacing_before,
        )
        insert_after(body, cur, p)
        cur = p
    return cur


def remove_paragraphs_between(body, start_p, end_p):
    seen = False
    for child in list(body):
        if child is start_p:
            seen = True
            continue
        if child is end_p:
            break
        if seen and child.tag != qn("sectPr"):
            body.remove(child)


def remove_paragraphs_after(body, start_p):
    seen = False
    for child in list(body):
        if child is start_p:
            seen = True
            continue
        if seen and child.tag != qn("sectPr"):
            body.remove(child)


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
                color.set(qn("val"), BYH_COLOR)
            else:
                strike = etree.SubElement(rpr, qn("strike"))
                strike.set(qn("val"), "true")
        t = etree.SubElement(r, qn("t"))
        t.set(XML_SPACE, "preserve")
        t.text = text
        p.append(r)


def replace_paragraph_runs_preserving_format(p, segments):
    original_runs = [r for r in p.findall("w:r", NS) if text_of(r)]
    default_run = original_runs[0] if original_runs else None
    ppr = p.find("w:pPr", NS)
    preserved_ppr = copy.deepcopy(ppr) if ppr is not None else None
    for child in list(p):
        p.remove(child)
    if preserved_ppr is not None:
        p.append(preserved_ppr)
    for mode, text in segments:
        if not text:
            continue
        if isinstance(mode, tuple):
            base_mode, run_index = mode
            prototype = original_runs[run_index] if run_index < len(original_runs) else default_run
            mode = base_mode
        else:
            prototype = default_run
        p.append(make_formatted_run(text, prototype, red=(mode == "red"), strike=(mode == "strike")))


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
                    color.set(qn("val"), BYH_COLOR)
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
                        "    This sole Member acts through its co-trustees,",
                        "    Wesley Dale Browning and",
                        "    Jeanette Wilson Hollinger, or",
                        "    any successor trustee authorized under the Browning Family Revocable Trust documents.",
                    ],
                    template=p,
                )
                member_intro_inserted = True

    # Opening agreement sentence entity-name replacement with explicit spacing.
    for p in body.findall("w:p", NS):
        txt = text_of(p)
        if txt == "NOW THEREFORE, in consideration of the premises and of the covenants and agreements hereinafter set forth and for other good and valuable consideration, the receipt and adequacy of which are hereby acknowledged, the parties hereto agree to this Amended and Restated Operating Agreement of Sell Your Home, LLC.":
            replace_paragraph_runs_preserving_format(
                p,
                [
                    ("normal", "NOW THEREFORE, in consideration of the premises and of the covenants and agreements hereinafter set forth and for other good and valuable consideration, the receipt and adequacy of which are hereby acknowledged, the parties hereto agree to this Amended and Restated Operating Agreement of "),
                    ("strike", "Sell Your Home, LLC"),
                    ("red", " Buy Your Home, LLC"),
                    ("normal", "."),
                ],
            )
            break

    # Article 2 cumulative structure. Preserve source numbering and avoid article-title lead-ins.
    voting_rights = None
    for p in body.findall("w:p", NS):
        txt = text_of(p).strip()
        if txt.startswith("Voting Rights. Each Membership Unit gives the holder one vote."):
            voting_rights = p
    if voting_rights is not None:
        inserted = insert_lines_after(
            body,
            voting_rights,
            [
                "Sole Member and Voting Authority. Browning Family Revocable Trust is the sole Member of the Company and holds 100% of the Membership Units. The co-trustees of Browning Family Revocable Trust, currently Wesley Dale Browning and Jeanette Wilson Hollinger, exercise the voting authority of the sole Member and are not separate Members solely by reason of serving as co-trustees.",
            ],
            template=voting_rights,
        )
        remove_numbering_style(inserted)

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
            replace_paragraph_runs_preserving_format(
                p,
                [
                    ("normal", "Units held by "),
                    ("strike", "an entity (like a business or trust)"),
                    ("red", " Browning Family Revocable Trust"),
                    ("normal", " must be voted by "),
                    ("strike", "the person the entity designates in writing"),
                    ("red", " its co-trustees, currently Wesley Dale Browning and Jeanette Wilson Hollinger, unless the Trust documents or Company records designate a different authorized trustee or representative"),
                    ("normal", "."),
                ],
            )

    # Article 5 manager structure and retirement-account-only restrictions.
    for p in body.findall("w:p", NS):
        txt = text_of(p).strip()
        if txt.startswith("Manager(s) – Number and Tenure."):
            replace_paragraph_runs_preserving_format(
                p,
                [
                    (("normal", 0), "Manager(s) – Number and Tenure."),
                    (("normal", 1), " "),
                    (("strike", 2), "The Company will start with one Manager, Jessica Santacruz, as named in the Articles of Organization. She will serve until the first annual meeting or until she resigns or is removed. At each annual meeting, Members will elect a Manager for the next term. The number of Managers can only be changed with approval from Members holding at least 75% of the voting Units (as required for “Major Decisions” in Section 5.2(b)). A Manager doesn’t have to be a Member or own any Units.)"),
                    (("red", 2), " The Company will have one or more Manager(s). The current Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC. Each Manager will serve until replaced, resigns, or is removed. The number of Manager(s) may be increased or decreased by the sole Member, Browning Family Revocable Trust, acting through its co-trustees or other authorized trustee authority. A Manager does not have to be a Member or own any Units."),
                ],
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

    # Signature/certification block. Clean-edit exception: remove old signature text.
    paras = body.findall("w:p", NS)
    cert_idx = next(i for i, p in enumerate(paras) if text_of(p).strip() == "CERTIFICATION")
    exhibit_idx = next(i for i, p in enumerate(paras) if text_of(p).strip() == "EXHIBIT A")
    cert = body.findall("w:p", NS)[cert_idx]
    exhibit = body.findall("w:p", NS)[exhibit_idx]
    remove_paragraphs_between(body, cert, exhibit)
    after = insert_lines_after(
        body,
        cert,
        [
            "THE UNDERSIGNED, being the sole Member and all Manager(s) of the Company, hereby evidence their adoption and ratification of this Amended and Restated Operating Agreement for and on behalf of themselves and the Company, effective ____________, 2026.",
            "",
            "SOLE MEMBER:",
            "Browning Family Revocable Trust",
            "By: ____________________________________",
            "Wesley Dale Browning, Co-Trustee",
            "",
            "By: ____________________________________",
            "Jeanette Wilson Hollinger, Co-Trustee",
        ],
        template=cert,
        spacing_after=0,
    )
    insert_lines_after(
        body,
        after,
        [
            "MANAGER(S):",
            "",
            "Wesley Dale Browning, Manager",
            "By: ____________________________________",
            "Wesley Dale Browning",
            "",
            "",
            "Jeanette Wilson Hollinger, Manager",
            "By: ____________________________________",
            "Jeanette Wilson Hollinger",
            "",
            "",
            "Investment Services LLC, Manager",
            "By: ____________________________________",
            "Name: Wesley Dale Browning",
            "Title: Authorized Representative",
        ],
        template=cert,
        page_break_first=True,
        spacing_after=0,
    )

    # Exhibit A. Clean BYH exhibit: remove old exhibit text.
    all_paras = root.xpath(".//w:p", namespaces=NS)
    exhibit_para = next(p for p in all_paras if text_of(p).strip() == "EXHIBIT A")
    remove_paragraphs_after(body, exhibit_para)
    insert_lines_after(
        body,
        exhibit_para,
        [
            "Member",
            "Browning Family Revocable Trust",
            "c/o Wesley Dale Browning and Jeanette Wilson Hollinger, Co-Trustees",
            "2156 Haig Point Way",
            "Raleigh, NC 27604",
            "",
            "Membership Units / Percentage Interest",
            "100 Membership Units / 100%",
            "",
            "Voting Authority",
            "Wesley Dale Browning and Jeanette Wilson Hollinger, as co-trustees of Browning Family Revocable Trust, exercise the voting authority of the sole Member unless the Trust documents or Company records designate a different authorized trustee or representative.",
            "",
            "Current Manager(s)",
            "Wesley Dale Browning",
            "Jeanette Wilson Hollinger",
            "Investment Services LLC",
            "",
            "Tax Classification",
            "The Company is intended to operate as an S corporation after a valid S election. Confirm final tax language with CPA or attorney review before final use.",
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
    v13 = para_texts_from_docx(OUT)
    v12 = para_texts_from_docx(V12) if V12.exists() else []
    v13_full = "\n".join(v13)
    v12_full = "\n".join(v12)
    v13_exhibit = "\n".join(v13[v13.index("EXHIBIT A") :]) if "EXHIBIT A" in v13 else ""
    v12_exhibit = "\n".join(v12[v12.index("EXHIBIT A") :]) if "EXHIBIT A" in v12 else ""

    checks = [
        ("Original Membership Units Authorized paragraph present", "Membership Units Authorized." in v13_full, "Membership Units Authorized." in v12_full),
        ("No duplicate 2.2 Membership Units Authorized", "2.2 Membership Units Authorized." not in v13_full, "2.2 Membership Units Authorized." not in v12_full),
        ("Sole-member/trustee-voting language added", "Sole Member and Voting Authority." in v13_full, "Sole Member and Voting Authority." in v12_full),
        ("Opening ownership block line breaks", "This sole Member acts through its co-trustees," in v13_full and "Wesley Dale Browning and\nJeanette Wilson Hollinger, or" in v13_full, "This sole Member acts through its co-trustees," in v12_full),
        ("Opening agreement spacing clean", "ofSell Your Home, LLCBuy Your Home, LLC" not in v13_full and "Operating Agreement of Sell Your Home, LLC Buy Your Home, LLC" in v13_full, "ofSell Your Home, LLCBuy Your Home, LLC" not in v12_full),
        ("Current Manager(s)", "The current Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC" in v13_full, "The current Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC" in v12_full),
        ("5.1(b)(xi) retained", "Any increase or decrease in the number of Manager(s)." in v13_full, "Any increase or decrease in the number of Manager(s)." in v12_full),
        ("Certification date no longer stale", "effective June ____, 2025" not in v13_full and "effective ____________, 2026" in v13_full, "effective June ____, 2025" not in v12_full),
        ("Defined manager signature groups", "Wesley Dale Browning, Manager" in v13_full and "Jeanette Wilson Hollinger, Manager" in v13_full and "Investment Services LLC, Manager" in v13_full, "Wesley Dale Browning, Manager" in v12_full and "Investment Services LLC, Manager" in v12_full),
        ("Clean Exhibit A current member only", "Browning Family Revocable Trust\nc/o Wesley Dale Browning" in v13_exhibit and "Quest Trust Company" not in v13_exhibit and "Heritage IRA" not in v13_exhibit, "Browning Family Revocable Trust\nc/o Wesley Dale Browning" in v12_exhibit and "Quest Trust Company" not in v12_exhibit and "Heritage IRA" not in v12_exhibit),
    ]

    NOTES.write_text(
        "# V13 - BYH OA Draft Clean Certification and Exhibit A Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Build method:\n\n"
        "- Generated fresh from the Simplified OA source using cumulative BYH instructions.\n"
        "- Did not use V12 as the input document.\n"
        "- V12 was used only for comparison after generation.\n"
        "- Source refresh from Teams/SharePoint was not available in this local tool session; the local refreshed Simplified OA source was used.\n\n"
        "Cumulative instructions applied:\n\n"
        "- Buy Your Home, LLC entity naming.\n"
        "- Browning Family Revocable Trust as sole Member.\n"
        "- Co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger as voting authority for the Trust.\n"
        "- Current Manager(s): Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC.\n"
        "- Preserve one-or-more Manager(s) structure.\n"
        "- Use green font for new BYH additions and replacement text, while preserving Jeff red source edits.\n"
        "- Indent opening ownership authority lines by 4 characters after the first line.\n"
        "- Preserve spacing around the opening agreement entity-name replacement.\n"
        "- Strike retirement-account-only member/signature/account-holder/disqualified-person/RMD/UBTI/UDFI provisions.\n"
        "- Strike only `on a non recourse basis` in 5.1(b)(iv).\n"
        "- Preserve 5.1(b)(xi).\n"
        "- Preserve the original 2.1 Membership Units Authorized paragraph without strikethrough.\n"
        "- Do not insert a duplicate 2.2 Membership Units Authorized paragraph.\n"
        "- Place the sole-member/trustee-voting language between 2.3(a) and 2.3(b), not as an Article 2 lead-in.\n"
        "- Preserve source run formatting for unchanged and struck source text, including the 4.10 voting sentence.\n"
        "- Preserve the Article 5 lead-in title formatting for `Manager(s) – Number and Tenure.` and redline only the body language that changes.\n"
        "- Conform the tax classification heading.\n"
        "- Use a clean certification/signature page without historical inapplicable signature text.\n"
        "- Use more defined signer groups with tighter spacing inside groups and more space between groups.\n"
        "- Replace stale `effective June ____, 2025` language with an open 2026 effective-date blank pending confirmation.\n"
        "- Rebuild Exhibit A as a clean BYH exhibit with only current BYH member information.\n",
        encoding="utf-8",
    )

    rows = ["| Check | V13 | V12 |", "| --- | --- | --- |"]
    for label, v13_ok, v12_ok in checks:
        rows.append(f"| {label} | {'yes' if v13_ok else 'no'} | {'yes' if v12_ok else 'no'} |")
    COMPARE.write_text(
        "# V13 - BYH OA vs V12 Comparison\n\n"
        "V13 was generated fresh from the Simplified OA source using the cumulative instruction set. V12 was used only as a comparison point.\n\n"
        + "\n".join(rows)
        + "\n\n## Practical Difference\n\n"
        "- V13 uses green BYH additions/replacements so Jeff red source edits remain distinguishable.\n"
        "- V13 applies the requested opening ownership block line breaks and 4-character indentation.\n"
        "- V13 uses a clean certification/signature page instead of carrying historical inapplicable signature text.\n"
        "- V13 rebuilds Exhibit A as a clean BYH exhibit with only current BYH member information.\n",
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
