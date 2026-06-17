from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from datetime import date
from html import escape
from pathlib import Path

from teams_link_from_local_path import teams_link_for_path


TEAMS_PACKAGE_ROOT = Path(
    r"C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28-SYH-320 Rose Pl\Selling\Ever Cardoza\Contract Package"
)
PACKAGE_ROOT = TEAMS_PACKAGE_ROOT
PACKAGE_AFFIDAVITS = PACKAGE_ROOT / "Affidavits"
SPANISH_PACKAGE = PACKAGE_ROOT / "Spanish Package"
EMAIL_PACKAGE = TEAMS_PACKAGE_ROOT / "Email Package"
SHAREPOINT_LINK_MANIFEST = EMAIL_PACKAGE / "current-sharepoint-view-links.json"

PROPERTY_LABEL = "320 Rose Pl"
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
        "320 Rose Ever Amarildo Cardoza Bolanos - Creditworthiness Evaluation Report - Document Preparation Ready.docx",
    ),
    LinkedFile(
        "Closing Package Cover Page",
        "320 Rose Pl - Ever Cardoza - Closing Package Cover Page.docx",
    ),
    LinkedFile("Term Sheet", "320 Rose Pl - Term Sheet - DRAFT.docx"),
    LinkedFile(
        "Buyer Acknowledgment Addendum",
        "320 Rose Pl - Buyer Acknowledgment Addendum - DRAFT.docx",
    ),
    LinkedFile(
        "Contract for Deed Agreement",
        "320 Rose Pl - Contract for Deed Agreement - DRAFT.docx",
    ),
    LinkedFile(
        "Memorandum of Contract for Deed",
        "320 Rose Pl - Memorandum of Contract for Deed - DRAFT.docx",
    ),
    LinkedFile(
        "Promissory Note for Contract for Deed",
        "320 Rose Pl - Promissory Note for Contract for Deed - DRAFT.docx",
    ),
    LinkedFile(
        "12 Month Amortization Chart",
        "320 Rose Pl - 12 Month Amortization Chart.pdf",
    ),
    LinkedFile(
        "Attorney-review package",
        "320 Rose Pl - Attorney Review Package.zip",
    ),
]

SPANISH_LABELS = {
    "320 Rose Pl - Contract for Deed Agreement - BILINGUAL SPANISH DRAFT.docx": "Contract for Deed Agreement - Bilingual Spanish Draft",
    "320 Rose Pl - Term Sheet - SPANISH DRAFT.docx": "Term Sheet - Spanish Draft",
    "320 Rose Pl - Buyer Acknowledgment Addendum - SPANISH DRAFT.docx": "Buyer Acknowledgment Addendum - Spanish Draft",
}

SPANISH_ORDER = {name: index for index, name in enumerate(SPANISH_LABELS)}


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
        "Closing Stop Issue",
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


REQUIRE_SHAREPOINT_LINKS = False


def load_sharepoint_view_links() -> dict[str, str]:
    if not SHAREPOINT_LINK_MANIFEST.exists():
        return {}
    data = json.loads(SHAREPOINT_LINK_MANIFEST.read_text(encoding="utf-8-sig"))
    links = data.get("links", data)
    if not isinstance(links, dict):
        raise ValueError(f"Invalid SharePoint link manifest: {SHAREPOINT_LINK_MANIFEST}")
    return {str(key): str(value) for key, value in links.items()}


SHAREPOINT_VIEW_LINKS = load_sharepoint_view_links()


def spanish_documents() -> list[LinkedFile]:
    if not SPANISH_PACKAGE.exists():
        return []
    paths = [
        path
        for path in SPANISH_PACKAGE.glob("*.docx")
        if not path.name.startswith("~$") and path.is_file()
    ]
    paths.sort(key=lambda path: (SPANISH_ORDER.get(path.name, 999), path.name.lower()))
    return [LinkedFile(SPANISH_LABELS.get(path.name, path.stem), path.name) for path in paths]


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
    url = SHAREPOINT_VIEW_LINKS.get(path.name)
    if not url and REQUIRE_SHAREPOINT_LINKS:
        raise KeyError(
            f"Missing current SharePoint sharing link for {path.name}; "
            f"refresh {SHAREPOINT_LINK_MANIFEST} before building the email body."
        )
    if not url:
        url = teams_link_for_path(path)["url"]
    return f'<a href="{escape(url, quote=True)}" style="color:#0b57d0;text-decoration:none;">{escape(label)}</a>'


def format_date(today: date) -> str:
    return today.strftime("%B ") + str(today.day) + today.strftime(", %Y")


def render_html(version: str, prepared: date) -> str:
    doc_items = []
    for item in DOCUMENTS:
        file_name = item.file_name.format(version=version)
        doc_items.append(f"<li>{linked_anchor(PACKAGE_ROOT / file_name, item.label)}</li>")

    spanish_items = []
    for item in spanish_documents():
        spanish_items.append(f"<li>{linked_anchor(SPANISH_PACKAGE / item.file_name, item.label)}</li>")
    spanish_section = ""
    if spanish_items:
        spanish_section = f"""
      <h2 style="font-size:16px;color:#17324d;margin:24px 0 10px 0;border-bottom:1px solid #d8dee6;padding-bottom:5px;">Spanish / Bilingual Drafts</h2>
      <p style="margin:0 0 8px 0;font-size:14px;line-height:1.45;color:#334e68;">Draft convenience translations; English documents control unless separately approved.</p>
      <ul style="margin:0 0 0 20px;padding:0;font-size:14px;line-height:1.55;">
        {''.join(spanish_items)}
      </ul>
"""

    affidavit_blocks = []
    for item in AFFIDAVITS:
        title = linked_anchor(PACKAGE_AFFIDAVITS / item.file_name, item.title)
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
        <table role="presentation" style="width:100%;border-collapse:collapse;margin-top:10px;font-size:14px;color:#5c6b7a;">
          <tr>
            <td style="padding:0;text-align:left;vertical-align:middle;">Prepared: {escape(format_date(prepared))}</td>
            <td style="padding:0;text-align:right;vertical-align:middle;">
              <span style="font-weight:bold;color:#1f2933;">Closing Date:</span>
              <span style="display:inline-block;min-width:190px;border-bottom:2px solid #1f2933;background:#fff200;color:#1f2933;">&nbsp;</span>
            </td>
          </tr>
        </table>
      </div>

      <h2 style="font-size:16px;color:#17324d;margin:22px 0 10px 0;border-bottom:1px solid #d8dee6;padding-bottom:5px;">Current Readiness</h2>
      <table style="width:100%;border-collapse:collapse;font-size:14px;line-height:1.4;">
        {''.join(rows)}
      </table>

      <h2 style="font-size:16px;color:#17324d;margin:24px 0 10px 0;border-bottom:1px solid #d8dee6;padding-bottom:5px;">Current Document Package</h2>
      <ul style="margin:0 0 0 20px;padding:0;font-size:14px;line-height:1.55;">
        {''.join(doc_items)}
      </ul>
{spanish_section}

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
        "Closing Date: ________________________",
        "",
        "Current Readiness",
    ]
    for label, value in READINESS_ROWS:
        lines.append(f"{label}: {value}")
    lines.extend(["", "Current Document Package"])
    for item in DOCUMENTS:
        lines.append(f"* {item.label}")
    spanish_items = spanish_documents()
    if spanish_items:
        lines.extend(
            [
                "",
                "Spanish / Bilingual Drafts",
                "Draft convenience translations; English documents control unless separately approved.",
            ]
        )
        for item in spanish_items:
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
    parser.add_argument("--version", help="Version prefix such as v05. Defaults to the latest package version.")
    parser.add_argument("--date", help="Prepared date in YYYY-MM-DD format. Defaults to today.")
    parser.add_argument(
        "--require-sharepoint-links",
        action="store_true",
        help="Fail unless every displayed file link is supplied by the current SharePoint link manifest.",
    )
    args = parser.parse_args()

    global REQUIRE_SHAREPOINT_LINKS
    REQUIRE_SHAREPOINT_LINKS = args.require_sharepoint_links

    version = args.version.lower() if args.version else "current"
    prepared = date.fromisoformat(args.date) if args.date else date.today()
    EMAIL_PACKAGE.mkdir(parents=True, exist_ok=True)

    name_prefix = f"{version} - " if args.version else ""
    html_path = EMAIL_PACKAGE / f"{name_prefix}320 Rose Pl - Ever Cardoza - Closing Package Email Body.html"
    text_path = EMAIL_PACKAGE / f"{name_prefix}320 Rose Pl - Ever Cardoza - Closing Package Email Body.txt"

    html_path.write_text(render_html(version, prepared), encoding="utf-8")
    text_path.write_text(render_text(version, prepared), encoding="utf-8")

    print(html_path)
    print(text_path)


if __name__ == "__main__":
    main()
