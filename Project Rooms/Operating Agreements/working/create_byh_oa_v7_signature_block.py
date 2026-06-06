import copy
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}
XML_SPACE = "{http://www.w3.org/XML/1998/namespace}space"

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "sources" / "Jeff Watson" / "BYH" / "BYH OA Draft V6 Fresh Clean Redline - from Simplified OA.docx"
OUT_DIR = BASE / "sources" / "Jeff Watson" / "BYH"
OUT = OUT_DIR / "BYH OA Draft V7 Signature Block - from V6 Fresh Clean Redline.docx"
NOTES = OUT_DIR / "BYH OA Draft V7 Signature Block Notes.md"


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
    paragraphs = body.findall("w:p", NS)

    cert_idx = next(i for i, p in enumerate(paragraphs) if text_of(p).strip() == "CERTIFICATION")
    exhibit_idx = next(i for i, p in enumerate(paragraphs) if text_of(p).strip() == "EXHIBIT A")

    # Strike old BYH signature note and legacy retirement-account certification/signature material.
    for p in paragraphs[cert_idx + 1 : exhibit_idx]:
        txt = text_of(p).strip()
        if txt:
            strike_paragraph(p)

    intro = red_paragraph(
        "THE UNDERSIGNED, being the sole Member and all Manager(s) of the Company, hereby evidence their adoption and ratification of this Amended and Restated Operating Agreement for and on behalf of themselves and the Company, effective June ____, 2025.",
        paragraphs[cert_idx],
    )
    signature_lines = [
        "",
        "SOLE MEMBER:",
        "Browning Family Revocable Trust",
        "",
        "By: ____________________________________",
        "Wesley Dale Browning, Co-Trustee",
        "",
        "By: ____________________________________",
        "Jeanette Wilson Hollinger, Co-Trustee",
        "",
        "MANAGER(S):",
        "",
        "____________________________________",
        "Wesley Dale Browning, Manager",
        "",
        "____________________________________",
        "Jeanette Wilson Hollinger, Manager",
        "",
        "Investment Services LLC, Manager",
        "",
        "By: ____________________________________",
        "Name: Wesley Dale Browning",
        "Title: Authorized Representative",
    ]

    insert_after(body, paragraphs[cert_idx], intro)
    anchor = intro
    for line in signature_lines:
        p = red_paragraph(line, paragraphs[cert_idx])
        insert_after(body, anchor, p)
        anchor = p

    xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    replace_docx_body_xml(SOURCE, OUT, xml)

    with zipfile.ZipFile(OUT, "r") as z:
        bad = z.testzip()
        if bad:
            raise RuntimeError(f"Corrupt DOCX entry: {bad}")

    NOTES.write_text(
        "# BYH OA Draft V7 Signature Block Notes\n\n"
        f"Source used: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Purpose:\n\n"
        "- Replace the V6 signature drafting note with actual proposed signature-block language.\n"
        "- Strike through the legacy retirement-account certification/signature blocks.\n"
        "- Show Browning Family Revocable Trust as sole Member, acting through co-trustees Wesley Dale Browning and Jeanette Wilson Hollinger.\n"
        "- Show Manager(s) signature lines for Wesley Dale Browning, Jeanette Wilson Hollinger, and Investment Services LLC.\n\n"
        "Best-guess item:\n\n"
        "- Investment Services LLC is shown signing by Wesley Dale Browning as Authorized Representative. Confirm the correct signer/title before final execution.\n",
        encoding="utf-8",
    )
    print(str(OUT))


if __name__ == "__main__":
    main()
