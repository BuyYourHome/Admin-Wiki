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
OUT = OUT_DIR / "BYH OA Draft V6 Fresh Clean Redline - from Simplified OA.docx"
NOTES = OUT_DIR / "BYH OA Draft V6 Fresh Clean Redline Notes.md"


def qn(tag):
    return f"{{{W}}}{tag}"


def text_of(el):
    return "".join(el.xpath(".//w:t/text()", namespaces=NS))


def red_run(text):
    r = etree.Element(qn("r"))
    rpr = etree.SubElement(r, qn("rPr"))
    color = etree.SubElement(rpr, qn("color"))
    color.set(qn("val"), "C00000")
    t = etree.SubElement(r, qn("t"))
    t.set(XML_SPACE, "preserve")
    t.text = text
    return r


def clone_run_with_text(run, text, *, red=False, strike=False):
    new_run = etree.Element(qn("r"))
    old_rpr = run.find("w:rPr", NS)
    if old_rpr is not None:
        new_run.append(copy.deepcopy(old_rpr))
    rpr = new_run.find("w:rPr", NS)
    if rpr is None and (red or strike):
        rpr = etree.SubElement(new_run, qn("rPr"))
    if red:
        for color in rpr.findall("w:color", NS):
            rpr.remove(color)
        color = etree.SubElement(rpr, qn("color"))
        color.set(qn("val"), "C00000")
    if strike and rpr.find("w:strike", NS) is None:
        strike_el = etree.SubElement(rpr, qn("strike"))
        strike_el.set(qn("val"), "true")
    t = etree.SubElement(new_run, qn("t"))
    t.set(XML_SPACE, "preserve")
    t.text = text
    return new_run


def red_paragraph(text, after_p=None):
    p = etree.Element(qn("p"))
    if after_p is not None:
        old_ppr = after_p.find("w:pPr", NS)
        if old_ppr is not None:
            p.append(copy.deepcopy(old_ppr))
    p.append(red_run(text))
    return p


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


def replace_docx_body_xml(source_zip_path, out_path, new_xml):
    tmp = out_path.with_suffix(out_path.suffix + ".tmp")
    with zipfile.ZipFile(source_zip_path, "r") as src, zipfile.ZipFile(tmp, "w", compression=zipfile.ZIP_DEFLATED) as dst:
        for item in src.infolist():
            if item.filename == "word/document.xml":
                dst.writestr(item, new_xml)
            else:
                dst.writestr(item, src.read(item.filename))
    tmp.replace(out_path)


def segment_replacements(text, replacements):
    pos = 0
    segments = []
    while pos < len(text):
        best = None
        for old, new in replacements:
            idx = text.find(old, pos)
            if idx == -1:
                continue
            if best is None or idx < best[0] or (idx == best[0] and len(old) > len(best[1])):
                best = (idx, old, new)
        if best is None:
            segments.append(("normal", text[pos:]))
            break
        idx, old, new = best
        if idx > pos:
            segments.append(("normal", text[pos:idx]))
        segments.append(("strike", old))
        if new:
            red_text = new if new.startswith((" ", ",", ".", ";", ")", "]")) else f" {new}"
            segments.append(("red", red_text))
        pos = idx + len(old)
    return [(mode, value) for mode, value in segments if value]


def replace_in_run(run, replacements):
    texts = run.findall("w:t", NS)
    if len(texts) != 1:
        return False
    original = texts[0].text or ""
    if not any(old in original for old, _new in replacements):
        return False
    parent = run.getparent()
    index = parent.index(run)
    parent.remove(run)
    for offset, (mode, value) in enumerate(segment_replacements(original, replacements)):
        parent.insert(
            index + offset,
            clone_run_with_text(
                run,
                value,
                red=(mode == "red"),
                strike=(mode == "strike"),
            ),
        )
    return True


def targeted_word_redlines(root):
    replacements = [
        ("SELL YOUR HOME, LLC", "BUY YOUR HOME, LLC"),
        ("Sell Your Home, LLC", "Buy Your Home, LLC"),
        ("SELL YOUR HOME", "BUY YOUR HOME"),
        ("Sell Your Home", "Buy Your Home"),
        ("Jessica Santacruz", "Wesley Dale Browning"),
        ("Jessica Santcruz", "Wesley Dale Browning"),
        ("an entity (like a business or trust)", "Browning Family Revocable Trust"),
        ("the person the entity designates in writing", "its co-trustees, currently Wesley Dale Browning and Jeanette Wilson Hollinger, unless the Trust documents or Company records designate a different authorized trustee or representative"),
        ("on a non recourse basis ", None),
        ("disregarded entity (if it has one Member) or a partnership (if it has multiple Members)", "an S corporation after a valid S election"),
        ("The Manager(s) must not take any action to change this classification.", "The Manager(s) must not take any action inconsistent with maintaining the Company's intended S corporation tax status."),
    ]
    for run in list(root.xpath(".//w:r[w:t]", namespaces=NS)):
        replace_in_run(run, replacements)


def paragraph_level_redlines(body):
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
        elif txt == "Borrowing on a non recourse basis over $10,000 in one year for a capital asset or improvement.":
            replace_paragraph_runs(
                p,
                [
                    ("normal", "Borrowing "),
                    ("strike", "on a non recourse basis "),
                    ("normal", "over $10,000 in one year for a capital asset or improvement."),
                ],
            )


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(SOURCE, "r") as z:
        root = etree.fromstring(z.read("word/document.xml"))

    body = root.find("w:body", NS)
    paragraphs = body.findall("w:p", NS)

    insert_after(
        body,
        paragraphs[0],
        red_paragraph(
            "V6 FRESH CLEAN REDLINE: This draft restarts from the original Simplified OA source. It preserves the plural Manager(s) framework, identifies Browning Family Revocable Trust as the sole Member, gives LLC voting authority to co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger, uses inline redlines where possible, and avoids repeated drafting notes.",
            paragraphs[0],
        ),
    )

    targeted_word_redlines(root)
    paragraph_level_redlines(body)

    first_member_block_note_added = False
    full_clause_notes = []
    for p in list(body.findall("w:p", NS)):
        txt = text_of(p)
        is_retirement_member_line = (
            "Quest Trust Company FBO" in txt
            or "Heritage IRA FBO" in txt
            or "Heritage IRA, FBO" in txt
            or "Accountholder" in txt
        )
        if is_retirement_member_line:
            strike_paragraph(p)
            if not first_member_block_note_added:
                full_clause_notes.append((p, "BYH V6 NOTE: Retirement-account member and signature language in this draft should be replaced with Browning Family Revocable Trust as sole Member, acting through co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger, plus any required Manager(s) signature block."))
                first_member_block_note_added = True
        elif txt.startswith("Note:") and "Account Holder" in txt and "IRA, HSA" in txt and "Coverdell ESA" in txt:
            strike_paragraph(p)
        elif "Some Members are IRAs" in txt or "prohibited transaction" in txt or "Required Minimum Distributions" in txt or "RMD" in txt:
            strike_paragraph(p)

    for p, note in reversed(full_clause_notes):
        insert_after(body, p, red_paragraph(note, p))

    section_notes = []
    for p in body.findall("w:p", NS):
        txt = " ".join(text_of(p).split())
        if txt == "Membership Units":
            section_notes.append((p, "BYH V6 MEMBER NOTE: Browning Family Revocable Trust is the sole Member holding 100% of the membership interest. The co-trustees are voting-authority holders for the Trust, not separate LLC Members."))
        elif txt.startswith("Voting Rights. Each Membership Unit gives the holder one vote."):
            section_notes.append((p, "BYH V6 VOTING NOTE: Voting authority for the sole Member, Browning Family Revocable Trust, is exercised by its co-trustees, currently Wesley Dale Browning and Jeanette Wilson Hollinger."))
        elif txt == "CERTIFICATION":
            section_notes.append((p, "BYH V6 SIGNATURE NOTE: Signature blocks should show Browning Family Revocable Trust as sole Member, acting through co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger, plus the Manager(s) signature block."))
        elif txt == "EXHIBIT A":
            section_notes.append((p, "BYH V6 EXHIBIT A NOTE: Exhibit A should list Browning Family Revocable Trust as the sole Member holding 100% of the membership interest. Co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger should be shown as voting/signing authority for the Trust, not as separate Members."))

    for p, note in reversed(section_notes):
        insert_after(body, p, red_paragraph(note, p))

    sect = body.find("w:sectPr", NS)
    idx = body.index(sect) if sect is not None else len(body)
    body.insert(
        idx,
        red_paragraph("BYH V6 OPEN ITEMS: Confirm final Trust signature block, Manager(s) appointment language, S corporation election language, and whether any buy-sell provisions should survive in a sole-member trust-owned LLC."),
    )

    xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    replace_docx_body_xml(SOURCE, OUT, xml)

    with zipfile.ZipFile(OUT, "r") as z:
        bad = z.testzip()
        if bad:
            raise RuntimeError(f"Corrupt DOCX entry: {bad}")

    NOTES.write_text(
        "# BYH OA Draft V6 Fresh Clean Redline Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Purpose:\n\n"
        "- Restart from the original Simplified OA source.\n"
        "- Keep the plural `Manager(s)` framework.\n"
        "- Reduce repeated drafting notes.\n"
        "- Make the 4.10 trust-voting change as inline sentence text rather than a standalone note.\n"
        "- Strike the Section 3.7 Account Holder note without adding a redundant note.\n"
        "- Strike only `on a non recourse basis` in Section 5.1(b)(iv).\n"
        "- Leave Section 5.1(b)(xi) intact.\n\n"
        "Known-correct BYH assumptions applied:\n\n"
        "- Browning Family Revocable Trust is the only LLC Member.\n"
        "- Voting authority for the Trust is exercised by co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger.\n"
        "- The agreement should allow one or more Manager(s).\n\n"
        "Open item before final use:\n\n"
        "- Confirm exact Manager(s), Trust signature, buy-sell, and S corporation tax language with attorney/CPA review.\n",
        encoding="utf-8",
    )
    print(str(OUT))


if __name__ == "__main__":
    main()
