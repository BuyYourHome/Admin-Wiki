import copy
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}
XML_SPACE = "{http://www.w3.org/XML/1998/namespace}space"

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "working" / "BYH" / "BYH OA Draft V7 Signature Block - from V6 Fresh Clean Redline.docx"
OUT_DIR = BASE / "working" / "BYH"
OUT = OUT_DIR / "BYH OA Draft V8 Operative Language - from V7 Signature Block.docx"
NOTES = OUT_DIR / "BYH OA Draft V8 Operative Language Notes.md"


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
    for p in list(body.findall("w:p", NS)):
        txt = text_of(p).strip()

        if txt.startswith("BYH V6 NOTE: Retirement-account member and signature language"):
            strike_paragraph(p)
            insertions.append(
                (
                    p,
                    [
                        "Browning Family Revocable Trust is the sole Member of the Company.",
                        "The sole Member acts through its co-trustees, Wesley Dale Browning and Jeanette Wilson Hollinger, or any successor trustee authorized under the Browning Family Revocable Trust documents.",
                    ],
                )
            )

        elif txt.startswith("BYH V6 MEMBER NOTE:"):
            strike_paragraph(p)
            insertions.append(
                (
                    p,
                    [
                        "Browning Family Revocable Trust is the sole Member of the Company and holds 100% of the Membership Units.",
                        "The co-trustees of Browning Family Revocable Trust, currently Wesley Dale Browning and Jeanette Wilson Hollinger, exercise the voting authority of the sole Member and are not separate Members solely by reason of serving as co-trustees.",
                    ],
                )
            )

        elif txt.startswith("BYH V6 VOTING NOTE:"):
            strike_paragraph(p)
            insertions.append(
                (
                    p,
                    [
                        "The voting rights associated with all Membership Units owned by Browning Family Revocable Trust are exercised by the Trust's co-trustees, currently Wesley Dale Browning and Jeanette Wilson Hollinger.",
                    ],
                )
            )

        elif txt.startswith("BYH V6 EXHIBIT A NOTE:"):
            strike_paragraph(p)
            insertions.append(
                (
                    p,
                    [
                        "Browning Family Revocable Trust is the sole Member and owns 100% of the Membership Units.",
                        "Voting and signing authority for the sole Member is exercised by co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger, or any successor trustee authorized under the Browning Family Revocable Trust documents and reflected in the Company records.",
                    ],
                )
            )

        elif txt.startswith("BYH V6 OPEN ITEMS:"):
            strike_paragraph(p)
            insertions.append(
                (
                    p,
                    [
                        "Final review items: confirm the S corporation election language, the correct title/signing authority for Investment Services LLC, and whether any buy-sell provisions should be retained for a sole-member trust-owned LLC.",
                    ],
                )
            )

        elif txt.startswith("Manager(s) – Number and Tenure."):
            strike_paragraph(p)
            insertions.append(
                (
                    p,
                    [
                        "Manager(s) – Number and Tenure. The Company will have one or more Manager(s). The initial Manager(s) are Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC. Each Manager will serve until replaced, resigns, or is removed. The number of Manager(s) may be increased or decreased by the sole Member, Browning Family Revocable Trust, acting through its co-trustees or other authorized trustee authority. A Manager does not have to be a Member or own any Units.",
                    ],
                )
            )

        elif (
            "Manager shall not be the Account Holder" in txt
            or "will have no signature authority, operational responsibility" in txt
            or "if a Manager is also an Account Holder" in txt
            or "Manager(s) need not be Members and cannot be disqualified persons" in txt
        ):
            strike_paragraph(p)

    for p, lines in reversed(insertions):
        anchor = p
        for line in lines:
            new_p = red_paragraph(line, p)
            insert_after(body, anchor, new_p)
            anchor = new_p

    xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    replace_docx_body_xml(SOURCE, OUT, xml)

    with zipfile.ZipFile(OUT, "r") as z:
        bad = z.testzip()
        if bad:
            raise RuntimeError(f"Corrupt DOCX entry: {bad}")

    NOTES.write_text(
        "# BYH OA Draft V8 Operative Language Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Purpose:\n\n"
        "- Replace remaining BYH drafting notes with proposed operative language where practical.\n"
        "- Replace Article 2 member/voting notes with actual sole-member/co-trustee language.\n"
        "- Replace the Exhibit A note with actual proposed Exhibit A language.\n"
        "- Name the initial Manager(s): Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC.\n"
        "- Strike retirement-account-only Manager/account-holder restrictions.\n\n"
        "Still open:\n\n"
        "- Confirm the correct signer/title for Investment Services LLC.\n"
        "- Confirm S corporation and buy-sell language with CPA/attorney review.\n",
        encoding="utf-8",
    )
    print(str(OUT))


if __name__ == "__main__":
    main()
