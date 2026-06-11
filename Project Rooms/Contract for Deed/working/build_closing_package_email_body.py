from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from datetime import date
from html import escape
from pathlib import Path

from teams_link_from_local_path import teams_link_for_path


TEAMS_PACKAGE_ROOT = Path(
    r"C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28-SYH-320 Rose Pl\Selling\Ever Cordoza\Contract Package"
)
CLEAN_PACKAGE = TEAMS_PACKAGE_ROOT / "Clean Package"
EMAIL_PACKAGE = TEAMS_PACKAGE_ROOT / "Email Package"

PROPERTY_LABEL = "320 Rose"
BUYER_LABEL = "Ever Cardoza"


@dataclass(frozen=True)
class LinkedFile:
    label: str
    file_name: str


@dataclass(frozen=True)
class AffidavitFile:
    title: str
    file_name: str
    purpose: str
    status: str


DOCUMENTS = [
    LinkedFile(
        "Credit Worthiness Report",
        "v19 320 Rose Ever Amarildo Cardoza Bolanos - Creditworthiness Evaluation Report - Affidavit Package Handoff.docx",
    ),
    LinkedFile("Term Sheet", "{version} - 320 Rose - Term Sheet - DRAFT.docx"),
    LinkedFile(
        "Buyer Acknowledgment Addendum",
        "{version} - 320 Rose - Buyer Acknowledgment Addendum - DRAFT.docx",
    ),
    LinkedFile(
        "Contract for Deed Agreement",
        "{version} - 320 Rose - Contract for Deed Agreement - DRAFT.docx",
    ),
    LinkedFile(
        "Memorandum of Contract for Deed",
        "{version} - 320 Rose - Memorandum of Contract for Deed - DRAFT.docx",
    ),
    LinkedFile(
        "Promissory Note for Contract for Deed",
        "{version} - 320 Rose - Promissory Note for Contract for Deed - DRAFT.docx",
    ),
    LinkedFile(
        "12 Month Amortization Chart",
        "{version} - 320 Rose Pl - 12 Month Amortization Chart.pdf",
    ),
    LinkedFile(
        "Attorney-review package",
        "{version} - 320 Rose - Attorney Review Package.zip",
    ),
]


AFFIDAVITS = [
    AffidavitFile(
        "Related-Company Rent Payment History",
        "26-06-08 320 Rose Ever Amarildo Cardoza Bolanos - Affidavit of Related-Company Rent Payment History.docx",
        "support tenant-buyer payment-history exception and related-company rent verification.",
        "draft signature-ready affidavit; final execution subject to attorney/compliance review and notarized signature.",
    ),
    AffidavitFile(
        "Cash Reserves and Receivables Observation",
        "26-06-08 320 Rose Ever Amarildo Cardoza Bolanos - Affidavit of Cash Reserves and Receivables Observation.docx",
        "support funds-to-close and reserve condition through observed cash, receivables, and stated foreign-fund access.",
        "draft signature-ready affidavit; final execution subject to attorney/compliance review and notarized signature.",
    ),
    AffidavitFile(
        "Receipt Package Review and Acceptance",
        "26-06-08 320 Rose Ever Amarildo Cardoza Bolanos - Affidavit of Receipt Package Review and Acceptance.docx",
        "document seller/business acceptance of receipts as gross receipt support.",
        "draft signature-ready affidavit; final execution subject to attorney/compliance review and notarized signature.",
    ),
    AffidavitFile(
        "Business Judgment Approval Direction",
        "26-06-08 320 Rose Ever Amarildo Cardoza Bolanos - Affidavit of Business Judgment Approval Direction.docx",
        "document the business decision to proceed despite nonstandard income proof, high debt ratio, and related-company rent verification.",
        "draft signature-ready affidavit; final execution subject to attorney/compliance review and notarized signature.",
    ),
]


READINESS_ROWS = [
    ("Credit Worthiness", "Ready for document preparation."),
    (
        "Closing Execution",
        "Not ready until required affidavits, funds proof, signer ID confirmation, and attorney/compliance review are complete.",
    ),
    (
        "CFD Stop Issue",
        "None identified if listed deliverables and review items are carried into the closing checklist.",
    ),
]

FUNDS_AND_IDENTITY_ITEMS = [
    "Verify receipt or closing handling of the $6,000 earnest money.",
    "Verify remaining down payment due at closing: $14,790.",
    "Verify final funds to close, including any closing costs not quantified in the handoff.",
    "Confirm signer identity against ID at execution.",
    "Treat Ever Amarildo Cardoza Bolanos and Maria Geraldina Sarmiento as signing buyers unless counsel directs otherwise.",
]

ATTORNEY_REVIEW_ITEMS = [
    "Review North Carolina Contract for Deed requirements.",
    "Review federal seller-financing / Regulation Z / Dodd-Frank issues.",
    "Review title, lien, and adverse-condition treatment.",
    "Review whether conditional or adverse-action notice language is needed if terms change materially.",
    "Confirm seller, trust, trustee, manager, and signature authority before final execution.",
]


EXTERNAL_VIEW_LINKS = {
    "v19 320 Rose Ever Amarildo Cardoza Bolanos - Creditworthiness Evaluation Report - Affidavit Package Handoff.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQCcQW8eUynITYVURk2CkwsbAQ6NrJTBkIwq19XQ9ZGXQuk",
    "v05 - 320 Rose - Term Sheet - DRAFT.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQCeKn8UOy52R4QnLiwLd1KhARk9x-OLq0GfmJAKfIhyAWg",
    "v05 - 320 Rose - Buyer Acknowledgment Addendum - DRAFT.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQB7UwYjKQ-JRqmZeN6uZGMtAWdcTZX5evJyCdoP0ertfWA",
    "v05 - 320 Rose - Contract for Deed Agreement - DRAFT.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQDMB-skQOsmQqhjBuppAYzFATIf9TmCTeNngKGzvA2_KmE",
    "v05 - 320 Rose - Memorandum of Contract for Deed - DRAFT.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQAXq3NGLaZZQoMEdEPxrTUnAWSavTbKEtpm9_BUaRWEoU0",
    "v05 - 320 Rose - Promissory Note for Contract for Deed - DRAFT.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQAdJsO4JFF8SYwzKYucFr3CAeeBANczX8PylIaojRzQ8DI",
    "v05 - 320 Rose Pl - 12 Month Amortization Chart.pdf": "https://lifeisanadventure.sharepoint.com/:b:/s/SellYourHome/IQCDpg4R5OnXS5jN2ReMLkScAYRUCTmsi7iKNJHP9QQvxWk",
    "v05 - 320 Rose - Attorney Review Package.zip": "https://lifeisanadventure.sharepoint.com/:u:/s/SellYourHome/IQBPpmr6T6_TRIWAVdKw9TueAZXo-U9zS-0ga4vi40VX3aU",
    "26-06-08 320 Rose Ever Amarildo Cardoza Bolanos - Affidavit of Related-Company Rent Payment History.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQC-g2ZWDpHaQIeBMpn-EYBjAYt3z5K0ubQwgoi8pFi5zYA",
    "26-06-08 320 Rose Ever Amarildo Cardoza Bolanos - Affidavit of Cash Reserves and Receivables Observation.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQD2HG7HoFwuTahWl4eBGuh5AVYNFcQ0lE9TRZV2Gdh6Ei0",
    "26-06-08 320 Rose Ever Amarildo Cardoza Bolanos - Affidavit of Receipt Package Review and Acceptance.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQD51dTsBh8xSZ-THSqA8_HjAbbOnwtAo7CQfeMF3ZhYa3E",
    "26-06-08 320 Rose Ever Amarildo Cardoza Bolanos - Affidavit of Business Judgment Approval Direction.docx": "https://lifeisanadventure.sharepoint.com/:w:/s/SellYourHome/IQBP5R0fGxoITIeUGuyqecbKAZSKk75YpiWSqDAzzyIVUtE",
}


def latest_version(clean_package: Path) -> str:
    pattern = re.compile(r"^(v\d{2}) - 320 Rose - Ever Cardoza - Closing Package Cover Page\.docx$", re.I)
    versions = []
    for path in clean_package.glob("v* - 320 Rose - Ever Cardoza - Closing Package Cover Page.docx"):
        match = pattern.match(path.name)
        if match:
            versions.append(match.group(1).lower())
    if not versions:
        raise FileNotFoundError(f"No versioned closing package cover page found in {clean_package}")
    return sorted(versions)[-1]


def linked_anchor(path: Path, label: str) -> str:
    if not path.exists():
        raise FileNotFoundError(path)
    url = EXTERNAL_VIEW_LINKS.get(path.name) or teams_link_for_path(path)["url"]
    return f'<a href="{escape(url, quote=True)}" style="color:#0b57d0;text-decoration:none;">{escape(label)}</a>'


def format_date(today: date) -> str:
    return today.strftime("%B ") + str(today.day) + today.strftime(", %Y")


def render_html(version: str, prepared: date) -> str:
    doc_items = []
    for item in DOCUMENTS:
        file_name = item.file_name.format(version=version)
        base_folder = TEAMS_PACKAGE_ROOT / "Credit Worthiness" if item.label == "Credit Worthiness Report" else CLEAN_PACKAGE
        doc_items.append(f"<li>{linked_anchor(base_folder / file_name, item.label)}</li>")

    affidavit_blocks = []
    for item in AFFIDAVITS:
        title = linked_anchor(CLEAN_PACKAGE / item.file_name, item.title)
        affidavit_blocks.append(
            "<p>"
            f"<strong>{title}</strong><br>"
            f"Purpose: {escape(item.purpose)}<br>"
            f"Status: {escape(item.status)}"
            "</p>"
        )

    rows = []
    for index, (label, value) in enumerate(READINESS_ROWS):
        bottom = "" if index == len(READINESS_ROWS) - 1 else "border-bottom:1px solid #edf0f3;"
        rows.append(
            "<tr>"
            f'<td style="width:190px;padding:7px 8px;{bottom}font-weight:bold;color:#334e68;">{escape(label)}</td>'
            f'<td style="padding:7px 8px;{bottom}">{escape(value)}</td>'
            "</tr>"
        )

    funds = "\n".join(f"<li>{escape(item)}</li>" for item in FUNDS_AND_IDENTITY_ITEMS)
    review = "\n".join(f"<li>{escape(item)}</li>" for item in ATTORNEY_REVIEW_ITEMS)
    return f"""<!doctype html>
<html>
<head><meta charset="utf-8"></head>
<body style="margin:0;padding:0;background:#f4f6f8;font-family:Arial, Helvetica, sans-serif;color:#1f2933;">
  <div style="max-width:760px;margin:0 auto;padding:24px;">
    <div style="background:#ffffff;border:1px solid #d8dee6;border-radius:6px;padding:28px;">
      <p style="font-size:15px;line-height:1.5;margin:0 0 18px 0;">Below is the current closing package cover page for review. The package ZIP is attached, and the document names below link to the package files.</p>

      <div style="border-bottom:3px solid #254f7a;padding-bottom:14px;margin-bottom:20px;">
        <div style="font-size:13px;letter-spacing:.08em;text-transform:uppercase;color:#5c6b7a;font-weight:bold;">Contract for Deed Closing Package</div>
        <h1 style="margin:6px 0 0 0;font-size:24px;line-height:1.25;color:#17324d;">{escape(PROPERTY_LABEL)} / {escape(BUYER_LABEL)}</h1>
        <div style="margin-top:8px;font-size:14px;color:#5c6b7a;">Prepared: {escape(format_date(prepared))}</div>
      </div>

      <h2 style="font-size:16px;color:#17324d;margin:22px 0 10px 0;border-bottom:1px solid #d8dee6;padding-bottom:5px;">Current Readiness</h2>
      <table style="width:100%;border-collapse:collapse;font-size:14px;line-height:1.4;">
        {''.join(rows)}
      </table>

      <h2 style="font-size:16px;color:#17324d;margin:24px 0 10px 0;border-bottom:1px solid #d8dee6;padding-bottom:5px;">Current Document Package</h2>
      <ul style="margin:0 0 0 20px;padding:0;font-size:14px;line-height:1.55;">
        {''.join(doc_items)}
      </ul>

      <h2 style="font-size:16px;color:#17324d;margin:24px 0 10px 0;border-bottom:1px solid #d8dee6;padding-bottom:5px;">Required Closing Deliverables</h2>
      <div style="font-size:14px;line-height:1.45;">
        {''.join(affidavit_blocks)}
      </div>

      <h2 style="font-size:16px;color:#17324d;margin:24px 0 10px 0;border-bottom:1px solid #d8dee6;padding-bottom:5px;">Funds And Identity Items</h2>
      <ul style="margin:0 0 0 20px;padding:0;font-size:14px;line-height:1.55;">
        {funds}
      </ul>

      <h2 style="font-size:16px;color:#17324d;margin:24px 0 10px 0;border-bottom:1px solid #d8dee6;padding-bottom:5px;">Attorney / Compliance Review Items</h2>
      <ul style="margin:0 0 0 20px;padding:0;font-size:14px;line-height:1.55;">
        {review}
      </ul>

      <p style="margin:26px 0 0 0;font-size:14px;color:#334e68;">Wes</p>
    </div>
  </div>
</body>
</html>
"""


def render_text(version: str, prepared: date) -> str:
    lines = [
        "Below is the current closing package cover page for review. The package ZIP is attached, and the document names below link to the package files.",
        "",
        "Contract for Deed Closing Package",
        "",
        f"{PROPERTY_LABEL} / {BUYER_LABEL}",
        "",
        f"Prepared: {format_date(prepared)}",
        "",
        "Current Readiness",
    ]
    for label, value in READINESS_ROWS:
        lines.append(f"{label}: {value}")
    lines.extend(["", "Current Document Package"])
    for item in DOCUMENTS:
        lines.append(f"* {item.label}")
    lines.extend(["", "Required Closing Deliverables"])
    for item in AFFIDAVITS:
        lines.extend(
            [
                item.title,
                f"Purpose: {item.purpose}",
                f"Status: {item.status}",
                "",
            ]
        )
    lines.append("Funds And Identity Items")
    for item in FUNDS_AND_IDENTITY_ITEMS:
        lines.append(f"* {item}")
    lines.extend(["", "Attorney / Compliance Review Items"])
    for item in ATTORNEY_REVIEW_ITEMS:
        lines.append(f"* {item}")
    lines.extend(["", "Wes"])
    return "\n".join(lines) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description="Build the CFD closing package email body.")
    parser.add_argument("--version", help="Version prefix such as v05. Defaults to the latest Clean Package version.")
    parser.add_argument("--date", help="Prepared date in YYYY-MM-DD format. Defaults to today.")
    args = parser.parse_args()

    version = args.version.lower() if args.version else latest_version(CLEAN_PACKAGE)
    prepared = date.fromisoformat(args.date) if args.date else date.today()
    EMAIL_PACKAGE.mkdir(parents=True, exist_ok=True)

    html_path = EMAIL_PACKAGE / f"{version} - 320 Rose - Ever Cardoza - Closing Package Email Body.html"
    text_path = EMAIL_PACKAGE / f"{version} - 320 Rose - Ever Cardoza - Closing Package Email Body.txt"

    html_path.write_text(render_html(version, prepared), encoding="utf-8")
    text_path.write_text(render_text(version, prepared), encoding="utf-8")

    print(html_path)
    print(text_path)


if __name__ == "__main__":
    main()
