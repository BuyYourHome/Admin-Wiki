"""Create a one-page cash-collection receipt from a validated JSON packet."""

from __future__ import annotations

import argparse
import json
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from pathlib import Path
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.enums import TA_RIGHT
from reportlab.lib.pagesizes import LETTER
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    KeepTogether,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)

GREEN = colors.HexColor("#174C43")
MINT = colors.HexColor("#E9F3F0")
INK = colors.HexColor("#17242A")
MUTED = colors.HexColor("#5D6A70")
LINE = colors.HexColor("#C9D7D3")


def money(value: object, field: str) -> Decimal:
    try:
        result = Decimal(str(value)).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
    except (InvalidOperation, TypeError) as exc:
        raise ValueError(f"{field} must be a valid monetary amount") from exc
    if result <= 0:
        raise ValueError(f"{field} must be greater than zero")
    return result


def required(data: dict, field: str) -> str:
    value = str(data.get(field, "")).strip()
    if not value:
        raise ValueError(f"Missing required field: {field}")
    return value


def safe(value: object) -> str:
    return escape(str(value or "").strip())


def label_value(label: str, value: object, styles: dict) -> Paragraph:
    return Paragraph(
        f"<font color='#5D6A70' size='7'>{escape(label.upper())}</font><br/>"
        f"<font color='#17242A' size='10'>{safe(value)}</font>",
        styles["BodyText"],
    )


def build_receipt(data: dict, output_path: Path) -> None:
    required_fields = (
        "receipt_number",
        "receipt_date",
        "receiving_entity",
        "project",
        "property_address",
        "received_from",
        "collected_by",
        "payment_method",
        "collection_status",
        "deposit_status",
        "application",
        "source_reference",
    )
    for field in required_fields:
        required(data, field)

    items = data.get("items")
    if not isinstance(items, list) or not items:
        raise ValueError("items must contain at least one sold item")

    normalized = []
    line_total = Decimal("0.00")
    for index, item in enumerate(items, start=1):
        if not isinstance(item, dict):
            raise ValueError(f"items[{index}] must be an object")
        description = required(item, "description")
        quantity = item.get("quantity", 1)
        try:
            quantity_value = Decimal(str(quantity))
        except InvalidOperation as exc:
            raise ValueError(f"items[{index}].quantity must be numeric") from exc
        if quantity_value <= 0:
            raise ValueError(f"items[{index}].quantity must be greater than zero")
        amount = money(item.get("amount"), f"items[{index}].amount")
        line_total += amount
        normalized.append((description, quantity_value, amount, item.get("marketplace_item_id", "")))

    stated_total = money(data.get("total_collected"), "total_collected")
    if stated_total != line_total:
        raise ValueError(f"total_collected {stated_total} does not equal item total {line_total}")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name="ReceiptTitle", parent=styles["Title"], fontName="Helvetica-Bold", fontSize=25, leading=28, textColor=GREEN, alignment=TA_RIGHT, spaceAfter=0))
    styles.add(ParagraphStyle(name="Entity", parent=styles["Heading2"], fontName="Helvetica-Bold", fontSize=13, leading=16, textColor=INK, spaceAfter=3))
    styles.add(ParagraphStyle(name="Small", parent=styles["BodyText"], fontName="Helvetica", fontSize=7.5, leading=10, textColor=MUTED))
    styles.add(ParagraphStyle(name="BodyCompact", parent=styles["BodyText"], fontName="Helvetica", fontSize=9, leading=12, textColor=INK))

    doc = SimpleDocTemplate(
        str(output_path),
        pagesize=LETTER,
        rightMargin=0.55 * inch,
        leftMargin=0.55 * inch,
        topMargin=0.48 * inch,
        bottomMargin=0.5 * inch,
        title=required(data, "receipt_number"),
        author=required(data, "receiving_entity"),
    )

    story = []
    heading = Table(
        [[Paragraph(safe(data["receiving_entity"]), styles["Entity"]), Paragraph("RECEIPT", styles["ReceiptTitle"])]],
        colWidths=[4.25 * inch, 3.15 * inch],
    )
    heading.setStyle(TableStyle([("VALIGN", (0, 0), (-1, -1), "TOP"), ("LINEBELOW", (0, 0), (-1, -1), 2, GREEN), ("BOTTOMPADDING", (0, 0), (-1, -1), 10)]))
    story.extend([heading, Spacer(1, 12)])

    meta = Table(
        [
            [label_value("Receipt Number", data["receipt_number"], styles), label_value("Receipt Date", data["receipt_date"], styles), label_value("Status", data["collection_status"], styles)],
            [label_value("Received From", data["received_from"], styles), label_value("Collected By", data["collected_by"], styles), label_value("Payment Method", data["payment_method"], styles)],
        ],
        colWidths=[2.7 * inch, 2.35 * inch, 2.35 * inch],
        rowHeights=[0.64 * inch, 0.64 * inch],
    )
    meta.setStyle(TableStyle([("BACKGROUND", (0, 0), (-1, -1), MINT), ("BOX", (0, 0), (-1, -1), 0.7, LINE), ("INNERGRID", (0, 0), (-1, -1), 0.5, LINE), ("VALIGN", (0, 0), (-1, -1), "MIDDLE"), ("LEFTPADDING", (0, 0), (-1, -1), 9), ("RIGHTPADDING", (0, 0), (-1, -1), 9)]))
    story.extend([meta, Spacer(1, 12)])

    assignment = Table(
        [[label_value("Assigned Project", data["project"], styles), label_value("Property", data["property_address"], styles)], [label_value("Application", data["application"], styles), label_value("Deposit Status", data["deposit_status"], styles)]],
        colWidths=[3.7 * inch, 3.7 * inch],
    )
    assignment.setStyle(TableStyle([("BOX", (0, 0), (-1, -1), 0.7, LINE), ("INNERGRID", (0, 0), (-1, -1), 0.5, LINE), ("VALIGN", (0, 0), (-1, -1), "MIDDLE"), ("TOPPADDING", (0, 0), (-1, -1), 8), ("BOTTOMPADDING", (0, 0), (-1, -1), 8), ("LEFTPADDING", (0, 0), (-1, -1), 9)]))
    story.extend([assignment, Spacer(1, 16)])

    rows = [[Paragraph("ITEM", styles["Small"]), Paragraph("MARKETPLACE REF", styles["Small"]), Paragraph("QTY", styles["Small"]), Paragraph("AMOUNT", styles["Small"])]]
    for description, quantity, amount, marketplace_id in normalized:
        qty_text = format(quantity.normalize(), "f")
        rows.append([Paragraph(safe(description), styles["BodyCompact"]), Paragraph(safe(marketplace_id) or "Not supplied", styles["BodyCompact"]), Paragraph(qty_text, styles["BodyCompact"]), Paragraph(f"${amount:,.2f}", styles["BodyCompact"])])
    items_table = Table(rows, colWidths=[3.95 * inch, 1.65 * inch, 0.6 * inch, 1.2 * inch], repeatRows=1)
    items_table.setStyle(TableStyle([("BACKGROUND", (0, 0), (-1, 0), GREEN), ("TEXTCOLOR", (0, 0), (-1, 0), colors.white), ("BOX", (0, 0), (-1, -1), 0.7, LINE), ("INNERGRID", (0, 0), (-1, -1), 0.4, LINE), ("VALIGN", (0, 0), (-1, -1), "TOP"), ("ALIGN", (2, 1), (-1, -1), "RIGHT"), ("TOPPADDING", (0, 0), (-1, -1), 7), ("BOTTOMPADDING", (0, 0), (-1, -1), 7), ("LEFTPADDING", (0, 0), (-1, -1), 7), ("RIGHTPADDING", (0, 0), (-1, -1), 7)]))
    story.extend([items_table, Spacer(1, 10)])

    total = Table([[Paragraph("TOTAL COLLECTED", styles["Entity"]), Paragraph(f"${stated_total:,.2f}", styles["ReceiptTitle"]) ]], colWidths=[5.7 * inch, 1.7 * inch])
    total.setStyle(TableStyle([("BACKGROUND", (0, 0), (-1, -1), MINT), ("BOX", (0, 0), (-1, -1), 1, GREEN), ("VALIGN", (0, 0), (-1, -1), "MIDDLE"), ("ALIGN", (1, 0), (1, 0), "RIGHT"), ("TOPPADDING", (0, 0), (-1, -1), 9), ("BOTTOMPADDING", (0, 0), (-1, -1), 9), ("LEFTPADDING", (0, 0), (-1, -1), 9), ("RIGHTPADDING", (0, 0), (-1, -1), 9)]))
    story.extend([total, Spacer(1, 14)])

    evidence_rows = [[label_value("Marketplace Reference", data.get("marketplace_reference") or "Not used", styles)], [label_value("Collection Evidence", data["source_reference"], styles)]]
    if str(data.get("notes", "")).strip():
        evidence_rows.append([label_value("Notes", data["notes"], styles)])
    evidence = Table(evidence_rows, colWidths=[7.4 * inch])
    evidence.setStyle(TableStyle([("BOX", (0, 0), (-1, -1), 0.7, LINE), ("INNERGRID", (0, 0), (-1, -1), 0.4, LINE), ("TOPPADDING", (0, 0), (-1, -1), 7), ("BOTTOMPADDING", (0, 0), (-1, -1), 7), ("LEFTPADDING", (0, 0), (-1, -1), 9)]))
    story.extend([KeepTogether(evidence), Spacer(1, 12), Paragraph("This receipt documents money collected. It does not by itself establish bank deposit, project-workbook posting, or payment of an unrelated invoice.", styles["Small"])])
    doc.build(story)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", required=True, type=Path, help="Validated receipt JSON packet")
    parser.add_argument("--output", required=True, type=Path, help="Output PDF path")
    args = parser.parse_args()
    with args.input.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    build_receipt(data, args.output)


if __name__ == "__main__":
    main()
