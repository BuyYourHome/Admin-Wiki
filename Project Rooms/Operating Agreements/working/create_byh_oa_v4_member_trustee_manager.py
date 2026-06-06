import copy
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}
XML_SPACE = "{http://www.w3.org/XML/1998/namespace}space"

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "sources" / "Jeff Watson" / "BYH" / "BYH OA Draft V3 Trustee Voting Members - from V2 Targeted Redline.docx"
OUT_DIR = BASE / "sources" / "Jeff Watson" / "BYH"
OUT = OUT_DIR / "BYH OA Draft V4 Sole Trust Member Co-Trustee Voting Multiple Managers - from V3.docx"
NOTES = OUT_DIR / "BYH OA Draft V4 Sole Trust Member Co-Trustee Voting Multiple Managers Notes.md"


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


def red_paragraph(text, after_p=None):
    p = etree.Element(qn("p"))
    if after_p is not None:
        old_ppr = after_p.find("w:pPr", NS)
        if old_ppr is not None:
            p.append(copy.deepcopy(old_ppr))
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


def update_text_nodes(root):
    replacements = {
        "Wes Browning": "Wesley Dale Browning",
        "Jenny Hollinger": "Jeanette Wilson Hollinger",
        "Browning Family Revocable Trust is named as the beneficiary/beneficial ownership reference": "Browning Family Revocable Trust is the only Member",
        "trust/beneficiary ownership reference": "sole Member",
        "beneficiary/beneficial ownership reference": "sole Member",
        "beneficially tied to Browning Family Revocable Trust": "held by Browning Family Revocable Trust",
        "Wesley Dale Browning is Manager": "Wesley Dale Browning may serve as a Manager",
        "Wesley Dale Browning is named as Manager": "Wesley Dale Browning may serve as a Manager",
        "Wesley Dale Browning as initial Manager": "one or more Managers, including Wesley Dale Browning as an initial Manager if so appointed",
        "single-manager": "multi-manager",
        "Browning Family Revocable Trust as sole Member and, if confirmed, the sole Member holding 100%": "Browning Family Revocable Trust as the sole Member holding 100%",
        "Confirm whether Browning Family Revocable Trust is the legal sole Member, beneficiary/beneficial owner, or both.": "Confirm the Company records and Exhibit A list Browning Family Revocable Trust as the sole Member.",
    }
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

    update_text_nodes(root)
    body = root.find("w:body", NS)
    paragraphs = body.findall("w:p", NS)

    insert_after(
        body,
        paragraphs[2],
        red_paragraph(
            "V4 MEMBER / VOTING / MANAGER UPDATE: Browning Family Revocable Trust is the only Member of the LLC. Voting authority for the LLC is exercised by the co-trustees of the Trust, currently Wesley Dale Browning and Jeanette Wilson Hollinger. The operating agreement should allow one or more Managers.",
            paragraphs[2],
        ),
    )

    for p in body.findall("w:p", NS):
        txt = text_of(p)
        if txt.startswith("Note:") and "Account Holder" in txt and "IRA, HSA" in txt and "Coverdell ESA" in txt:
            strike_paragraph(p)
            insert_after(
                body,
                p,
                red_paragraph(
                    "BYH V4 NOTE: This Account Holder definition under Section 3.7 does not apply to the BYH trust-owned structure and is struck through.",
                    p,
                ),
            )
            break

    notes = []
    for p in body.findall("w:p", NS):
        txt = " ".join(text_of(p).split())
        if txt.startswith("Voting Rights. Each Membership Unit gives the holder one vote."):
            notes.append((p, "BYH V4 VOTING REPLACEMENT: Browning Family Revocable Trust is the sole Member. The voting authorization for that Member is exercised by its co-trustees, currently Wesley Dale Browning and Jeanette Wilson Hollinger."))
        elif txt.startswith("Members Entitled to Vote; Voting Rights of Fiduciaries"):
            notes.append((p, "BYH V4 TRUSTEE AUTHORIZATION: References to voting Members should be read for BYH as the voting authority of the Browning Family Revocable Trust acting through its co-trustees."))
        elif txt.startswith("Manager(s)") or txt.startswith("Manager ") or txt.startswith("Manager(s) Manager"):
            notes.append((p, "BYH V4 MANAGER NOTE: The agreement should allow one or more Managers. Wesley Dale Browning may serve as a Manager, but the draft should not assume he is the only possible Manager."))
        elif txt.startswith("BYH V2 NOTE: Exhibit A should identify"):
            notes.append((p, "BYH V4 EXHIBIT A REPLACEMENT: Exhibit A should identify Browning Family Revocable Trust as the sole Member holding 100% of the membership interest, with voting authority exercised by co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger."))

    for p, note in reversed(notes):
        insert_after(body, p, red_paragraph(note, p))

    sect = body.find("w:sectPr", NS)
    idx = body.index(sect) if sect is not None else len(body)
    for add in [
        red_paragraph("6. Confirm the final manager structure: one Manager, multiple named Managers, or authority to appoint multiple Managers later."),
        red_paragraph("7. Confirm Exhibit A lists Browning Family Revocable Trust as the sole Member and the co-trustees as voting-authority signers, not as separate Members."),
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
        "# BYH OA Draft V4 Sole Trust Member Co-Trustee Voting Multiple Managers Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Purpose:\n\n"
        "- Carry forward the V3 trustee-voting draft.\n"
        "- Clarify that Browning Family Revocable Trust is the only LLC Member.\n"
        "- Clarify that voting authority is exercised by the co-trustees, not by separate LLC members.\n"
        "- Name the current co-trustees as Wesley Dale Browning and Jeanette Wilson Hollinger.\n"
        "- Preserve the possibility of multiple Managers.\n"
        "- Strike the Section 3.7 Account Holder note that defines IRA/HSA/Coverdell ESA account holders.\n\n"
        "Open item before final use:\n\n"
        "- Confirm the exact final manager structure and trust-authority language against the Trust document.\n",
        encoding="utf-8",
    )
    print(str(OUT))


if __name__ == "__main__":
    main()
