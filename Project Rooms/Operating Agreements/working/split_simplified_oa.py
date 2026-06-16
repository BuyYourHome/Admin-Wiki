import copy
import hashlib
import json
import shutil
import zipfile
from pathlib import Path

from lxml import etree


W_NS = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W_NS}
SECTPR = f"{{{W_NS}}}sectPr"


BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "sources" / "Jeff Watson" / "Simplified OA - 25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx"
SOURCE_TEAMS_NAME = "25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx"
OUT_DIR = BASE / "sources" / "Jeff Watson" / "Simplified OA Subfiles"
REASSEMBLED = OUT_DIR / "Reassembled OA Check - 00 - Reassembled Verification - Simplified OA with Jeff Watson tracked edits.docx"
REPORT = OUT_DIR / "reassembly-verification.md"


SEGMENTS = [
    ("01 - Opening Paragraphs.docx", "Opening Paragraphs", 0, 15),
    ("02 - Summary of Operating Agreement Articles.docx", "Summary of Operating Agreement Articles", 15, 120),
    ("03 - Article 1 - Offices and Records.docx", "Article 1 - Offices and Records", 120, 129),
    ("04 - Article 2 - Membership Units.docx", "Article 2 - Membership Units", 129, 152),
    ("05 - Article 3 - Buy-Sell Rights and Transfer Restrictions.docx", "Article 3 - Buy-Sell Rights and Transfer Restrictions", 152, 193),
    ("06 - Article 4 - Meetings of Members.docx", "Article 4 - Meetings of Members", 193, 252),
    ("07 - Article 5 - Managers.docx", "Article 5 - Managers", 252, 294),
    ("08 - Article 6 - Indemnification.docx", "Article 6 - Indemnification", 294, 339),
    ("09 - Article 7 - Fiscal Matters.docx", "Article 7 - Fiscal Matters", 339, 361),
    ("10 - Article 8 - Dissolution.docx", "Article 8 - Dissolution", 361, 382),
    ("11 - Article 9 - Special Provisions.docx", "Article 9 - Special Provisions", 382, 392),
    ("12 - Article 10 - Miscellaneous.docx", "Article 10 - Miscellaneous", 392, 404),
    ("13 - Certification and Exhibit A.docx", "Certification and Exhibit A", 404, 411),
]


def load_document_xml(docx_path):
    with zipfile.ZipFile(docx_path) as zf:
        return etree.fromstring(zf.read("word/document.xml"))


def body_parts(root):
    body = root.find("w:body", NS)
    blocks = [child for child in body if child.tag != SECTPR]
    sect_pr = body.find("w:sectPr", NS)
    return body, blocks, sect_pr


def block_text(block):
    return "".join(block.xpath(".//w:t/text()", namespaces=NS)).strip()


def replace_body(docx_path, out_path, selected_blocks, sect_pr):
    tmp_path = out_path.with_suffix(out_path.suffix + ".tmp")
    with zipfile.ZipFile(docx_path, "r") as source_zip, zipfile.ZipFile(tmp_path, "w", compression=zipfile.ZIP_DEFLATED) as out_zip:
        root = etree.fromstring(source_zip.read("word/document.xml"))
        body = root.find("w:body", NS)
        for child in list(body):
            body.remove(child)
        for block in selected_blocks:
            body.append(copy.deepcopy(block))
        if sect_pr is not None:
            body.append(copy.deepcopy(sect_pr))
        xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
        for item in source_zip.infolist():
            if item.filename == "word/document.xml":
                out_zip.writestr(item, xml)
            else:
                out_zip.writestr(item, source_zip.read(item.filename))
    tmp_path.replace(out_path)


def canonical_blocks(blocks):
    return b"".join(etree.tostring(block, method="c14n") for block in blocks)


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    source_root = load_document_xml(SOURCE)
    _, source_blocks, source_sect_pr = body_parts(source_root)

    if len(source_blocks) != SEGMENTS[-1][3]:
        raise RuntimeError(f"Expected {SEGMENTS[-1][3]} source blocks, found {len(source_blocks)}")

    manifest = []
    for filename, title, start, end in SEGMENTS:
        out_path = OUT_DIR / filename
        selected = source_blocks[start:end]
        replace_body(SOURCE, out_path, selected, source_sect_pr)
        first_text = next((block_text(block) for block in selected if block_text(block)), "")
        manifest.append(
            {
                "file": filename,
                "title": title,
                "start_block": start,
                "end_block_exclusive": end,
                "block_count": end - start,
                "first_text": first_text,
            }
        )

    rebuilt_blocks = []
    for filename, _, _, _ in SEGMENTS:
        segment_root = load_document_xml(OUT_DIR / filename)
        _, segment_blocks, _ = body_parts(segment_root)
        rebuilt_blocks.extend(copy.deepcopy(block) for block in segment_blocks)

    replace_body(SOURCE, REASSEMBLED, rebuilt_blocks, source_sect_pr)

    original_hash = sha256(canonical_blocks(source_blocks))
    reassembled_root = load_document_xml(REASSEMBLED)
    _, reassembled_blocks, _ = body_parts(reassembled_root)
    reassembled_hash = sha256(canonical_blocks(reassembled_blocks))

    ok = original_hash == reassembled_hash and len(source_blocks) == len(rebuilt_blocks) == len(reassembled_blocks)

    rows = [
        "# Simplified OA Subfile Reassembly Verification",
        "",
        f"Source project-room file: `{SOURCE.name}`",
        f"Source Teams file name: `{SOURCE_TEAMS_NAME}`",
        f"Reassembled file: `{REASSEMBLED.name}`",
        "",
        "## Result",
        "",
        f"- Source block count: {len(source_blocks)}",
        f"- Reassembled block count: {len(reassembled_blocks)}",
        f"- Source block hash: `{original_hash}`",
        f"- Reassembled block hash: `{reassembled_hash}`",
        f"- Verification result: {'PASS' if ok else 'FAIL'}",
        "",
        "The verification hash is calculated from the canonical OOXML for the ordered document body blocks, excluding the final section-properties block. The reassembled file is built by reading the generated subfile DOCXs from disk and concatenating their body blocks in manifest order. A PASS confirms the split and reassembly preserve the original body text and formatting XML.",
        "",
        "## Segment Manifest",
        "",
        "| File | Segment | Blocks | First Text |",
        "| --- | --- | ---: | --- |",
    ]

    for item in manifest:
        first = item["first_text"].replace("|", "\\|")
        rows.append(
            f"| `{item['file']}` | {item['title']} | {item['block_count']} | {first[:120]} |"
        )

    REPORT.write_text("\n".join(rows) + "\n", encoding="utf-8")
    print(json.dumps({"ok": ok, "segments": len(SEGMENTS), "report": str(REPORT), "reassembled": str(REASSEMBLED)}, indent=2))


if __name__ == "__main__":
    main()
