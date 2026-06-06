import copy
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}
XML_SPACE = "{http://www.w3.org/XML/1998/namespace}space"

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "sources" / "Jeff Watson" / "BYH" / "BYH OA Draft V8 Operative Language - from V7 Signature Block.docx"
OUT_DIR = BASE / "sources" / "Jeff Watson" / "BYH"
OUT = OUT_DIR / "BYH OA Draft V9 Article 2 Managers Tax Title Certification - from V8.docx"
NOTES = OUT_DIR / "BYH OA Draft V9 Article 2 Managers Tax Title Certification Notes.md"


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
        if ppr.find("w:pageBreakBefore", NS) is None:
            etree.SubElement(ppr, qn("pageBreakBefore"))
    p.append(red_run(text))
    return p


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
            if mode == "strike":
                strike = etree.SubElement(rpr, qn("strike"))
                strike.set(qn("val"), "true")
        t = etree.SubElement(r, qn("t"))
        t.set(XML_SPACE, "preserve")
        t.text = text
        p.append(r)


def replace_text_everywhere(root, replacements):
    for t in root.xpath(".//w:t", namespaces=NS):
        if not t.text:
            continue
        for old, new in replacements.items():
            t.text = t.text.replace(old, new)


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

    replace_text_everywhere(
        root,
        {
            "The initial Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC": "The current Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC",
            "- Name the initial Manager(s): Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC.": "- Name the current Manager(s): Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC.",
        },
    )

    # Article 2: make the sole-member language the new 2.1 and preserve current 2.1 as 2.2.
    article2_anchor = None
    member_note = None
    membership_units_auth = None
    for p in body.findall("w:p", NS):
        txt = text_of(p).strip()
        if txt == "Membership Units":
            article2_anchor = p
        elif txt.startswith("BYH V6 MEMBER NOTE:"):
            member_note = p
        elif txt.startswith("Membership Units Authorized."):
            membership_units_auth = p

    if member_note is not None:
        strike_paragraph(member_note)
    if article2_anchor is not None:
        new_21 = make_red_para(
            "2.1 Sole Member and Voting Authority. Browning Family Revocable Trust is the sole Member of the Company and holds 100% of the Membership Units. The co-trustees of Browning Family Revocable Trust, currently Wesley Dale Browning and Jeanette Wilson Hollinger, exercise the voting authority of the sole Member and are not separate Members solely by reason of serving as co-trustees.",
            article2_anchor,
        )
        insert_after(body, article2_anchor, new_21)
    if membership_units_auth is not None:
        old = text_of(membership_units_auth)
        strike_paragraph(membership_units_auth)
        insert_after(body, membership_units_auth, make_red_para("2.2 " + old, membership_units_auth))

    # Remove duplicate V8 Article 2 operative inserts now consolidated into 2.1.
    for p in body.findall("w:p", NS):
        txt = text_of(p).strip()
        if txt in {
            "Browning Family Revocable Trust is the sole Member of the Company and holds 100% of the Membership Units.",
            "The co-trustees of Browning Family Revocable Trust, currently Wesley Dale Browning and Jeanette Wilson Hollinger, exercise the voting authority of the sole Member and are not separate Members solely by reason of serving as co-trustees.",
        }:
            strike_paragraph(p)

    # 7.11: title should match S corporation tax text.
    for p in body.findall("w:p", NS):
        txt = text_of(p)
        if txt.startswith("Company as Pass-Through Entity."):
            replace_paragraph_runs(
                p,
                [
                    ("strike", "Company as Pass-Through Entity."),
                    ("red", " Company Tax Classification. "),
                    ("normal", txt[len("Company as Pass-Through Entity.") :]),
                ],
            )
            break

    # Certification: put Manager(s) on the next page and separate three manager groups.
    paras = body.findall("w:p", NS)
    cert_idx = next(i for i, p in enumerate(paras) if text_of(p).strip() == "CERTIFICATION")
    exhibit_idx = next(i for i, p in enumerate(paras) if text_of(p).strip() == "EXHIBIT A")
    cert_paras = body.findall("w:p", NS)[cert_idx:exhibit_idx]
    in_old_manager_block = False
    for p in cert_paras:
        txt = text_of(p).strip()
        if txt == "MANAGER(S):":
            in_old_manager_block = True
        if txt.startswith("BYH V6 SIGNATURE NOTE:"):
            in_old_manager_block = False
        if in_old_manager_block and txt:
            strike_paragraph(p)

    anchor = None
    for p in body.findall("w:p", NS):
        if text_of(p).strip() == "Jeanette Wilson Hollinger, Co-Trustee":
            anchor = p
            break
    if anchor is not None:
        manager_lines = [
            ("MANAGER(S):", True),
            ("", False),
            ("Wesley Dale Browning, Manager", False),
            ("", False),
            ("By: ____________________________________", False),
            ("Wesley Dale Browning", False),
            ("", False),
            ("Jeanette Wilson Hollinger, Manager", False),
            ("", False),
            ("By: ____________________________________", False),
            ("Jeanette Wilson Hollinger", False),
            ("", False),
            ("Investment Services LLC, Manager", False),
            ("", False),
            ("By: ____________________________________", False),
            ("Name: Wesley Dale Browning", False),
            ("Title: Authorized Representative", False),
        ]
        cur = anchor
        for text, page_break in manager_lines:
            new_p = make_red_para(text, anchor, page_break_before=page_break)
            insert_after(body, cur, new_p)
            cur = new_p

    xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    replace_docx_body_xml(SOURCE, OUT, xml)

    with zipfile.ZipFile(OUT, "r") as z:
        bad = z.testzip()
        if bad:
            raise RuntimeError(f"Corrupt DOCX entry: {bad}")

    NOTES.write_text(
        "# BYH OA Draft V9 Article 2 Managers Tax Title Certification Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Purpose:\n\n"
        "- Add the sole-member/trustee-voting language as new Article 2.1.\n"
        "- Preserve the current Membership Units Authorized paragraph as new Article 2.2.\n"
        "- Change Manager(s) wording from initial Manager(s) to current Manager(s).\n"
        "- Keep 5.1(b)(xi) operative.\n"
        "- Conform the tax-classification heading formerly titled Company as Pass-Through Entity.\n"
        "- Start the Manager(s) certification block on the next page and keep three separate Manager groups.\n\n"
        "Best-guess item:\n\n"
        "- Investment Services LLC remains shown signing by Wesley Dale Browning as Authorized Representative. Confirm the correct signer/title before final execution.\n",
        encoding="utf-8",
    )
    print(str(OUT))


if __name__ == "__main__":
    main()
