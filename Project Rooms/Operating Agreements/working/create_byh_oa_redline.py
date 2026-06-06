import copy
import re
import shutil
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}

BASE = Path(__file__).resolve().parents[1]
SOURCE = BASE / "sources" / "Jeff Watson" / "Simplified OA - 25-06-25 SELL_YOUR_HOME_LLC Simplified with Summary with Jeff Watson tracked edits.docx"
OUT_DIR = BASE / "sources" / "Jeff Watson" / "BYH"
OUT = OUT_DIR / "BYH OA Draft - redline from Simplified OA.docx"
NOTES = OUT_DIR / "BYH OA Draft Notes.md"


def qn(tag):
    return f"{{{W}}}{tag}"


def text_of(el):
    return "".join(el.xpath(".//w:t/text()", namespaces=NS))


def has_text(el, needle):
    return needle.lower() in text_of(el).lower()


def get_ppr(p):
    ppr = p.find("w:pPr", NS)
    if ppr is None:
        ppr = etree.Element(qn("pPr"))
        p.insert(0, ppr)
    return ppr


def strike_run(r):
    rpr = r.find("w:rPr", NS)
    if rpr is None:
        rpr = etree.Element(qn("rPr"))
        r.insert(0, rpr)
    if rpr.find("w:strike", NS) is None:
        strike = etree.Element(qn("strike"))
        strike.set(qn("val"), "true")
        rpr.append(strike)


def strike_paragraph(p):
    for r in p.findall(".//w:r", NS):
        strike_run(r)


def red_run(text):
    r = etree.Element(qn("r"))
    rpr = etree.SubElement(r, qn("rPr"))
    color = etree.SubElement(rpr, qn("color"))
    color.set(qn("val"), "C00000")
    t = etree.SubElement(r, qn("t"))
    t.set("{http://www.w3.org/XML/1998/namespace}space", "preserve")
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

    # Drafting assumptions at the top.
    first_para = paragraphs[0]
    insert_after(
        body,
        first_para,
        red_paragraph(
            "DRAFTING ASSUMPTIONS FOR BUY YOUR HOME, LLC: This redline draft assumes Buy Your Home, LLC is a North Carolina single-member LLC, with Browning Family Trust named as the beneficiary/beneficial ownership reference, Wesley Dale Browning serving as Manager, and the Company having elected or intending to elect S corporation tax status. Retirement-account ownership provisions from the source agreement are marked for removal because they do not apply.",
            first_para,
        ),
    )

    # Strike retirement-account-specific paragraphs and insert replacement where useful.
    strike_terms = [
        "Quest Trust Company FBO",
        "Heritage IRA FBO",
        "IRA",
        "HSA",
        "ESA",
        "Coverdell",
        "Account Holder",
        "account holder",
        "disqualified person",
        "Internal Revenue Code §4975",
        "IRC §4975",
        "IRC §§511",
        "Unrelated Business Taxable Income",
        "Unrelated Debt",
        "UBTI",
        "UDFI",
        "Required Minimum Distributions",
        "RMD",
        "prohibited transaction",
        "custodial",
        "administrator requirements",
        "990-T",
    ]
    replacement_after = []
    for p in list(body.findall("w:p", NS)):
        txt = text_of(p)
        if any(term.lower() in txt.lower() for term in strike_terms):
            strike_paragraph(p)
            if "Quest Trust Company FBO" in txt or "Heritage IRA FBO" in txt:
                replacement_after.append((p, "BYH REPLACEMENT: Browning Family Trust is named as the beneficiary/beneficial ownership reference for this BYH draft. Confirm whether the trust should also be listed as the legal sole Member, and insert the trust's full legal name, date, trustee authority, and signature authority before final use."))
            elif "Account Holder" in txt or "account holder" in txt:
                replacement_after.append((p, "BYH REPLACEMENT: References to Account Holders should be replaced with trustee, trust beneficiary, or other trust-authority language that matches the Browning Family Trust documents."))
            elif "disqualified person" in txt or "4975" in txt or "prohibited transaction" in txt:
                replacement_after.append((p, "BYH REPLACEMENT: Retirement-account prohibited-transaction restrictions do not apply on the stated facts. Replace with standard conflict-of-interest and authority limits appropriate for a trust-owned single-member LLC."))
            elif "UBTI" in txt or "UDFI" in txt or "990-T" in txt or "Unrelated" in txt:
                replacement_after.append((p, "BYH REPLACEMENT: Remove retirement-account UBTI/UDFI reporting mechanics. Use tax-reporting language appropriate for a single-member LLC with an S corporation tax election."))
            elif "Required Minimum Distributions" in txt or "RMD" in txt:
                replacement_after.append((p, "BYH REPLACEMENT: Remove RMD language. It does not apply to the stated trust-owned BYH structure."))

    for p, msg in reversed(replacement_after):
        insert_after(body, p, red_paragraph(msg, p))

    # Entity-name redline additions after title/recitals; keep original source text struck rather than removed.
    for p in body.findall("w:p", NS):
        txt = text_of(p)
        if "SELL YOUR HOME" in txt or "Sell Your Home" in txt:
            strike_paragraph(p)
            insert_after(body, p, red_paragraph(txt.replace("SELL YOUR HOME", "BUY YOUR HOME").replace("Sell Your Home", "Buy Your Home"), p))

    # Add BYH-specific replacement sections near relevant headings.
    insertions = []
    for p in body.findall("w:p", NS):
        txt = " ".join(text_of(p).split())
        if txt == "Membership Units":
            insertions.append((p, "BYH SINGLE-MEMBER REPLACEMENT: Browning Family Trust is named as the beneficiary/beneficial ownership reference for the Company. Confirm whether Browning Family Trust should also be identified as the legal sole Member holding 100% of the membership interest. Because the Company is intended to be a single-member LLC, voting provisions should be simplified to sole-Member written consent or action by the trustee or other authorized trust representative."))
        elif txt == "Manager(s)":
            insertions.append((p, "BYH MANAGER REPLACEMENT: Wesley Dale Browning is the initial Manager. The Manager has authority to manage the Company and bind the Company, subject to any limits in this Agreement and any limits imposed by the Member or by the Browning Family Trust ownership/beneficiary structure."))
        elif txt == "Company as Pass-Through Entity." or txt.startswith("Company as Pass-Through Entity"):
            insertions.append((p, "BYH TAX REPLACEMENT: The Company is a limited liability company under state law and is intended to be treated as an S corporation for federal and state income tax purposes after a valid S election. The Manager must not take action inconsistent with maintaining the Company's intended S corporation tax status."))
        elif txt == "CERTIFICATION":
            insertions.append((p, "BYH SIGNATURE REPLACEMENT: Replace the retirement-account signature blocks with signature blocks for Browning Family Trust, as sole Member, and Wesley Dale Browning, as Manager. Confirm the trustee or authorized signer for Browning Family Trust before finalizing."))
        elif txt == "EXHIBIT A":
            insertions.append((p, "BYH EXHIBIT A REPLACEMENT: Exhibit A should list Browning Family Trust as the beneficiary/beneficial ownership reference and, if confirmed, as the sole Member holding 100% of the membership interest. Include the trust's full legal name, trustee or authorized representative, address, and any required tax or administrative information."))

    for p, msg in reversed(insertions):
        insert_after(body, p, red_paragraph(msg, p))

    # Add a red drafting checklist at the end, before sectPr.
    sect = body.find("w:sectPr", NS)
    idx = body.index(sect) if sect is not None else len(body)
    additions = [
        red_heading("BYH Drafting Checklist"),
        red_paragraph("1. Confirm the full legal name of Browning Family Trust and who signs for it."),
        red_paragraph("2. Confirm whether Browning Family Trust is the legal Member, the beneficial owner, or both."),
        red_paragraph("3. Confirm the correct S corporation election status and effective date with CPA/tax counsel."),
        red_paragraph("4. Replace all retirement-account ownership, custodian, account-holder, prohibited-transaction, UBTI/UDFI, RMD, and retirement-account valuation provisions."),
        red_paragraph("5. Replace Exhibit A and all signature blocks before execution."),
    ]
    for add in additions:
        body.insert(idx, add)
        idx += 1

    xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    replace_docx_body_xml(SOURCE, OUT, xml)

    with zipfile.ZipFile(OUT, "r") as z:
        bad = z.testzip()
        if bad:
            raise RuntimeError(f"Corrupt DOCX entry: {bad}")

    NOTES.write_text(
        "# BYH OA Draft Notes\n\n"
        f"Source refreshed from Teams before drafting: `{SOURCE.name}`.\n\n"
        f"Output DOCX: `{OUT.name}`.\n\n"
        "Draft assumptions:\n\n"
        "- Buy Your Home, LLC is a single-member LLC.\n"
        "- Browning Family Trust is named as the beneficiary/beneficial ownership reference.\n"
        "- Wesley Dale Browning is named as Manager.\n"
        "- The LLC is intended to operate as an S corporation for tax purposes.\n"
        "- Retirement-account attributes do not apply and are struck through rather than deleted.\n\n"
        "Open items before final use:\n\n"
        "- Confirm the full legal trust name and signer/trustee authority.\n"
        "- Confirm the exact S corporation tax language with CPA/tax counsel.\n"
        "- Attorney review is needed before execution.\n",
        encoding="utf-8",
    )
    print(str(OUT))


if __name__ == "__main__":
    main()
