import copy
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}
XML_SPACE = "{http://www.w3.org/XML/1998/namespace}space"

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "sources" / "Jeff Watson" / "BYH" / "BYH OA Draft V2 Targeted Redline - from Simplified OA.docx"
OUT_DIR = BASE / "sources" / "Jeff Watson" / "BYH"
OUT = OUT_DIR / "BYH OA Draft V3 Trustee Voting Members - from V2 Targeted Redline.docx"
NOTES = OUT_DIR / "BYH OA Draft V3 Trustee Voting Members Notes.md"


def qn(tag):
    return f"{{{W}}}{tag}"


def text_of(el):
    return "".join(el.xpath(".//w:t/text()", namespaces=NS))


def correct_trust_name(root):
    for t in root.xpath(".//w:t", namespaces=NS):
        if t.text:
            t.text = t.text.replace("Browning Family Trust", "Browning Family Revocable Trust")


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


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(SOURCE, "r") as z:
        root = etree.fromstring(z.read("word/document.xml"))

    body = root.find("w:body", NS)
    insertions = []

    opening_note = (
        "V3 TRUSTEE VOTING UPDATE: For this BYH draft, voting authority for Browning Family Revocable Trust is exercised by the Trustees of the Trust. "
        "The current Trustees are Wes Browning and Jenny Hollinger. Successor or replacement trustees should vote only to the extent authorized by the Browning Family Revocable Trust documents."
    )
    insert_after(body, body.findall("w:p", NS)[1], red_paragraph(opening_note, body.findall("w:p", NS)[1]))

    summary_voting_note = (
        "BYH V3 TRUSTEE VOTING: Because Browning Family Revocable Trust is the trust/beneficiary ownership reference, voting power should be exercised by its Trustees. "
        "Current voting Trustees: Wes Browning and Jenny Hollinger."
    )
    detailed_voting_note = (
        "BYH V3 TRUSTEE VOTING REPLACEMENT: For Units owned by, held for, or beneficially tied to Browning Family Revocable Trust, the voting persons are the Trustees of Browning Family Revocable Trust. "
        "As of this draft, the Trustees are Wes Browning and Jenny Hollinger. Either trustee may act only as permitted by the trust documents, and any change in trustee authority should be reflected in the Company records before the vote is recognized."
    )
    member_list_note = (
        "BYH V3 MEMBER LIST NOTE: For BYH, the Member list and voting records should identify Browning Family Revocable Trust and the Trustees authorized to vote for it, currently Wes Browning and Jenny Hollinger."
    )

    for p in body.findall("w:p", NS):
        txt = " ".join(text_of(p).split())
        if txt == "Voting: One vote per Unit; no cumulative voting.":
            insertions.append((p, summary_voting_note))
        elif txt.startswith("Voting Rights. Each Membership Unit gives the holder one vote."):
            insertions.append((p, detailed_voting_note))
        elif txt.startswith("Units held by an entity (like a business or trust) must be voted"):
            insertions.append((p, detailed_voting_note))
        elif txt.startswith("Members Entitled to Vote; Voting Rights of Fiduciaries"):
            insertions.append((p, detailed_voting_note))
        elif txt.startswith("Member List and Membership Unit Record."):
            insertions.append((p, member_list_note))

    seen = set()
    for p, note in reversed(insertions):
        key = (body.index(p), note)
        if key in seen:
            continue
        seen.add(key)
        insert_after(body, p, red_paragraph(note, p))

    # Update final open item list with the new confirmed instruction.
    sect = body.find("w:sectPr", NS)
    idx = body.index(sect) if sect is not None else len(body)
    body.insert(
        idx,
        red_paragraph(
            "5. Confirm the Browning Family Revocable Trust documents authorize Wes Browning and Jenny Hollinger, as current Trustees, to exercise voting authority for the Trust in this LLC.",
        ),
    )

    correct_trust_name(root)

    xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    replace_docx_body_xml(SOURCE, OUT, xml)

    with zipfile.ZipFile(OUT, "r") as z:
        bad = z.testzip()
        if bad:
            raise RuntimeError(f"Corrupt DOCX entry: {bad}")

    NOTES.write_text(
        "# BYH OA Draft V3 Trustee Voting Members Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Purpose:\n\n"
        "- Carry forward the V2 targeted redline approach.\n"
        "- Add trustee-voting language for Browning Family Revocable Trust.\n"
        "- Name Wes Browning and Jenny Hollinger as the current Trustees who exercise voting authority for the Trust.\n\n"
        "Drafting point added:\n\n"
        "- Voting authority for Units owned by, held for, or beneficially tied to Browning Family Revocable Trust is exercised by the Trustees of the Trust.\n"
        "- Current Trustees: Wes Browning and Jenny Hollinger.\n"
        "- Successor or replacement trustees should be recognized through the Browning Family Trust documents and Company records.\n\n"
        "Open item before final use:\n\n"
        "- Confirm exact trust-authority language against the Browning Family Revocable Trust document.\n",
        encoding="utf-8",
    )
    print(str(OUT))


if __name__ == "__main__":
    main()
