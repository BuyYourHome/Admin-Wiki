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
OUT = OUT_DIR / "BYH OA Draft V2 Targeted Redline - from Simplified OA.docx"
NOTES = OUT_DIR / "BYH OA Draft V2 Targeted Redline Notes.md"


def qn(tag):
    return f"{{{W}}}{tag}"


def text_of(el):
    return "".join(el.xpath(".//w:t/text()", namespaces=NS))


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


def red_run(text):
    r = etree.Element(qn("r"))
    rpr = etree.SubElement(r, qn("rPr"))
    color = etree.SubElement(rpr, qn("color"))
    color.set(qn("val"), "C00000")
    t = etree.SubElement(r, qn("t"))
    t.set(XML_SPACE, "preserve")
    t.text = text
    return r


def red_paragraph(text, after_p=None):
    p = etree.Element(qn("p"))
    if after_p is not None:
        old_ppr = after_p.find("w:pPr", NS)
        if old_ppr is not None:
            p.append(copy.deepcopy(old_ppr))
    p.append(red_run(text))
    return p


def red_heading(text):
    p = etree.Element(qn("p"))
    ppr = etree.SubElement(p, qn("pPr"))
    pstyle = etree.SubElement(ppr, qn("pStyle"))
    pstyle.set(qn("val"), "Heading1")
    p.append(red_run(text))
    return p


def insert_after(parent, existing, new_el):
    parent.insert(parent.index(existing) + 1, new_el)


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


def targeted_replacements(root):
    replacements = [
        ("SELL YOUR HOME, LLC", "BUY YOUR HOME, LLC"),
        ("Sell Your Home, LLC", "Buy Your Home, LLC"),
        ("SELL YOUR HOME", "BUY YOUR HOME"),
        ("Sell Your Home", "Buy Your Home"),
        ("Jessica Santacruz", "Wesley Dale Browning"),
        ("Jessica Santcruz", "Wesley Dale Browning"),
        ("Manager(s)", "Manager"),
        ("one or more Manager(s)", "Wesley Dale Browning as initial Manager"),
        ("elected annually by Members", "serving until replaced by the Member"),
        ("IRAs (§408 or §408A), ESAs (§530), or HSAs (§223)", "Browning Family Trust"),
        ("IRA/ESA/HSA Members", "the Browning Family Trust ownership structure"),
        ("IRA Member’s Account Holder", "Browning Family Trust"),
        ("Account Holder", "trust beneficiary or authorized trust representative"),
        ("Account Holders", "trust beneficiaries or authorized trust representatives"),
        ("disregarded entity (if it has one Member) or a partnership (if it has multiple Members)", "an S corporation after a valid S election"),
        ("The Manager must not take any action to change this classification.", "The Manager must not take any action inconsistent with maintaining the Company's intended S corporation tax status."),
        ("The Manager(s) must not take any action to change this classification.", "The Manager must not take any action inconsistent with maintaining the Company's intended S corporation tax status."),
    ]
    for run in list(root.xpath(".//w:r[w:t]", namespaces=NS)):
        if run.xpath("ancestor::w:p[.//w:strike]", namespaces=NS):
            continue
        replace_in_run(run, replacements)


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


def replace_docx_body_xml(source_zip_path, out_path, new_xml):
    tmp = out_path.with_suffix(out_path.suffix + ".tmp")
    with zipfile.ZipFile(source_zip_path, "r") as src, zipfile.ZipFile(tmp, "w", compression=zipfile.ZIP_DEFLATED) as dst:
        for item in src.infolist():
            if item.filename == "word/document.xml":
                dst.writestr(item, new_xml)
            else:
                dst.writestr(item, src.read(item.filename))
    tmp.replace(out_path)


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
            "DRAFTING ASSUMPTIONS FOR BUY YOUR HOME, LLC V2 TARGETED REDLINE: This version favors word-level replacements over paragraph-level replacement. It assumes Buy Your Home, LLC is a North Carolina single-member LLC, Browning Family Trust is the beneficiary/beneficial ownership reference, Wesley Dale Browning is Manager, and the Company has elected or intends to elect S corporation tax status.",
            paragraphs[0],
        ),
    )

    # These clauses are retirement-account mechanics rather than ordinary wording edits.
    whole_clause_terms = [
        "Quest Trust Company FBO",
        "Heritage IRA FBO",
        "Heritage IRA, FBO",
        "Accountholder",
        "Some Members are ",
        "prohibited transaction",
        "disqualified person",
        "Required Minimum Distributions",
        "RMD",
        "UBTI",
        "UDFI",
        "990-T",
        "guarantee any Company debt",
    ]
    notes_to_insert = []
    for p in list(body.findall("w:p", NS)):
        txt = text_of(p)
        if any(term in txt for term in whole_clause_terms):
            strike_paragraph(p)
            if "Some Members are" in txt or "prohibited transaction" in txt:
                notes_to_insert.append((p, "BYH V2 NOTE: This retirement-account prohibited-transaction clause appears inapplicable to the stated BYH facts and should be replaced with ordinary conflict-of-interest and authority language."))
            elif "Required Minimum Distributions" in txt or "RMD" in txt:
                notes_to_insert.append((p, "BYH V2 NOTE: This RMD clause appears inapplicable to the stated BYH facts."))
            elif "UBTI" in txt or "UDFI" in txt or "990-T" in txt:
                notes_to_insert.append((p, "BYH V2 NOTE: This retirement-account tax-reporting language appears inapplicable; confirm S corporation tax language with CPA/tax counsel."))
            elif "Quest Trust Company FBO" in txt or "Heritage IRA FBO" in txt:
                notes_to_insert.append((p, "BYH V2 NOTE: This retirement-account member substitution is inapplicable. Use Browning Family Trust/member-beneficiary language after confirming the exact trust role."))
            elif "Heritage IRA, FBO" in txt or "Accountholder" in txt:
                notes_to_insert.append((p, "BYH V2 NOTE: This retirement-account signature/member label is inapplicable. Use Browning Family Trust and Wesley Dale Browning Manager signature language after confirming authority."))

    for p, note in reversed(notes_to_insert):
        insert_after(body, p, red_paragraph(note, p))

    targeted_replacements(root)

    section_notes = []
    for p in body.findall("w:p", NS):
        txt = " ".join(text_of(p).split())
        if txt == "Membership Units":
            section_notes.append((p, "BYH V2 NOTE: Keep the article structure, but conform plural Member/voting mechanics to a single-member structure after confirming whether Browning Family Trust is the legal Member, beneficiary, or both."))
        elif txt == "Manager":
            section_notes.append((p, "BYH V2 NOTE: Wesley Dale Browning is named as Manager. Review remaining plural-manager mechanics for single-manager fit."))
        elif txt == "CERTIFICATION":
            section_notes.append((p, "BYH V2 NOTE: Replace retirement-account signature blocks with Browning Family Trust and Wesley Dale Browning Manager signature blocks after confirming signer authority."))
        elif txt == "EXHIBIT A":
            section_notes.append((p, "BYH V2 NOTE: Exhibit A should identify Browning Family Trust as beneficiary/beneficial ownership reference and, if confirmed, the sole Member holding 100%."))

    for p, note in reversed(section_notes):
        insert_after(body, p, red_paragraph(note, p))

    sect = body.find("w:sectPr", NS)
    idx = body.index(sect) if sect is not None else len(body)
    for add in [
        red_heading("BYH V2 Open Confirmation Items"),
        red_paragraph("1. Confirm whether Browning Family Trust is the legal sole Member, beneficiary/beneficial owner, or both."),
        red_paragraph("2. Confirm the full legal trust name and signing authority."),
        red_paragraph("3. Confirm the S corporation election language and effective date with CPA/tax counsel."),
        red_paragraph("4. Review remaining plural-Member and buy-sell provisions for fit with a single-member LLC."),
    ]:
        body.insert(idx, add)
        idx += 1

    xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    replace_docx_body_xml(SOURCE, OUT, xml)

    with zipfile.ZipFile(OUT, "r") as z:
        bad = z.testzip()
        if bad:
            raise RuntimeError(f"Corrupt DOCX entry: {bad}")

    NOTES.write_text(
        "# BYH OA Draft V2 Targeted Redline Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Purpose:\n\n"
        "- Create a second BYH draft using targeted word-level redlines where a small replacement is enough.\n"
        "- Keep full paragraph strikethrough mainly for provisions that are retirement-account mechanics rather than ordinary wording changes.\n"
        "- Keep the V2 designation in the file name so it remains distinct from the first BYH redline attempt.\n\n"
        "Draft assumptions:\n\n"
        "- Buy Your Home, LLC is a single-member LLC.\n"
        "- Browning Family Trust is named as the beneficiary/beneficial ownership reference.\n"
        "- Wesley Dale Browning is named as Manager.\n"
        "- The LLC is intended to operate as an S corporation for tax purposes.\n\n"
        "Refresh note:\n\n"
        "- A fresh browser-based Teams refresh could not be performed in this turn because the Chrome/Teams connector was not available. The source used was the project-room Simplified OA copy refreshed from Teams earlier on 2026-06-06.\n\n"
        "Open items before final use:\n\n"
        "- Confirm the full legal trust name and signer/trustee authority.\n"
        "- Confirm whether Browning Family Trust is the legal Member, beneficiary/beneficial owner, or both.\n"
        "- Confirm the exact S corporation tax language with CPA/tax counsel.\n"
        "- Attorney review is needed before execution.\n",
        encoding="utf-8",
    )
    print(str(OUT))


if __name__ == "__main__":
    main()
