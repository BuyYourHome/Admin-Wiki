import argparse
import json
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


def money(value):
    return f"${value:,.2f}"


def required(data, key):
    value = data.get(key)
    if value in (None, "", []):
        raise ValueError(f"Missing required field: {key}")
    return value


def build_invoice(data, output_path):
    issuer_name = required(data, "issuer_name")
    issuer_email = required(data, "issuer_email")
    customer_name = required(data, "customer_name")
    project = required(data, "project")
    invoice_no = required(data, "invoice_no")
    invoice_date = required(data, "invoice_date")
    status = required(data, "status")
    lines = required(data, "lines")
    subtotal = round(sum(float(line["amount"]) for line in lines), 2)
    expected_total = round(float(required(data, "total")), 2)
    if subtotal != expected_total:
        raise ValueError(f"Line total {subtotal:.2f} does not match invoice total {expected_total:.2f}")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    doc = SimpleDocTemplate(
        str(output_path),
        pagesize=letter,
        rightMargin=0.62 * inch,
        leftMargin=0.62 * inch,
        topMargin=0.52 * inch,
        bottomMargin=0.52 * inch,
        title=data.get("title", f"{issuer_name} Invoice"),
        author=issuer_name,
    )

    styles = getSampleStyleSheet()
    styles.add(
        ParagraphStyle(
            name="Issuer",
            parent=styles["Title"],
            alignment=0,
            fontName="Helvetica-Bold",
            fontSize=23,
            textColor=colors.HexColor("#1F2937"),
            leading=26,
            spaceAfter=2,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Body",
            parent=styles["Normal"],
            fontSize=9.8,
            textColor=colors.HexColor("#111827"),
            leading=13,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Muted",
            parent=styles["Normal"],
            fontSize=8.7,
            textColor=colors.HexColor("#6B7280"),
            leading=11,
        )
    )

    accent = colors.HexColor("#1F6F78")
    deep = colors.HexColor("#124E57")
    pale = colors.HexColor("#E9F5F6")
    line_color = colors.HexColor("#D1D5DB")
    header_lines = data.get("header_lines", ["INVOICE", "Internal vendor invoice"])

    story = []
    header = Table(
        [
            [
                Paragraph(
                    f"{issuer_name}<br/><font size='10'>{issuer_email}</font>",
                    styles["Issuer"],
                ),
                Paragraph(
                    "<br/>".join(f"<b>{value}</b>" if index == 0 else value for index, value in enumerate(header_lines)),
                    ParagraphStyle(
                        "HeaderRight",
                        parent=styles["Normal"],
                        alignment=2,
                        fontSize=10,
                        leading=14,
                        textColor=deep,
                    ),
                ),
            ]
        ],
        colWidths=[4.7 * inch, 2.25 * inch],
    )
    header.setStyle(
        TableStyle(
            [
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LINEBELOW", (0, 0), (-1, -1), 1.2, accent),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 12),
            ]
        )
    )
    story.append(header)
    story.append(Spacer(1, 0.18 * inch))

    status_band = Table(
        [
            [
                Paragraph(f"<b>Status:</b> {status}", styles["Body"]),
                Paragraph(f"<b>Invoice Date:</b> {invoice_date}", styles["Body"]),
            ]
        ],
        colWidths=[4.3 * inch, 2.65 * inch],
    )
    status_band.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), pale),
                ("BOX", (0, 0), (-1, -1), 0.6, colors.HexColor("#B7DDE1")),
                ("LEFTPADDING", (0, 0), (-1, -1), 10),
                ("RIGHTPADDING", (0, 0), (-1, -1), 10),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    story.append(status_band)
    story.append(Spacer(1, 0.22 * inch))

    details = Table(
        [
            [
                Paragraph(
                    f"<b>Invoice From</b><br/>{issuer_name}<br/>{data.get('issuer_detail', 'Outside service provider')}",
                    styles["Body"],
                ),
                Paragraph(
                    f"<b>Customer</b><br/>{customer_name}<br/>{data.get('customer_detail', 'Office Admin')}",
                    styles["Body"],
                ),
                Paragraph(
                    f"<b>Project / Bucket</b><br/>{project}<br/>{data.get('project_detail', '')}",
                    styles["Body"],
                ),
            ]
        ],
        colWidths=[2.28 * inch, 2.28 * inch, 2.28 * inch],
    )
    details.setStyle(
        TableStyle(
            [
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("BOX", (0, 0), (-1, -1), 0.4, line_color),
                ("INNERGRID", (0, 0), (-1, -1), 0.4, line_color),
                ("LEFTPADDING", (0, 0), (-1, -1), 10),
                ("RIGHTPADDING", (0, 0), (-1, -1), 10),
                ("TOPPADDING", (0, 0), (-1, -1), 10),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
            ]
        )
    )
    story.append(details)
    story.append(Spacer(1, 0.26 * inch))

    invoice_meta = Table([["Invoice #", invoice_no]], colWidths=[1.35 * inch, 5.55 * inch])
    invoice_meta.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), deep),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 9.2),
                ("GRID", (0, 0), (-1, -1), 0.35, line_color),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    story.append(invoice_meta)
    story.append(Spacer(1, 0.12 * inch))

    item_rows = [["Work Date", "Description", "Hours / Qty", "Rate", "Amount"]]
    for line in lines:
        item_rows.append(
            [
                required(line, "date"),
                Paragraph(required(line, "description"), styles["Body"]),
                f"{float(required(line, 'quantity')):.2f}",
                money(float(required(line, "rate"))),
                money(float(required(line, "amount"))),
            ]
        )
    items = Table(item_rows, colWidths=[0.85 * inch, 3.15 * inch, 0.87 * inch, 0.88 * inch, 1.15 * inch])
    items.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), deep),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 9.2),
                ("ALIGN", (2, 1), (-1, -1), "RIGHT"),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("GRID", (0, 0), (-1, -1), 0.35, line_color),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 6),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
            ]
        )
    )
    story.append(items)
    story.append(Spacer(1, 0.18 * inch))

    total_label = data.get("total_label", "Invoice Total")
    totals = Table(
        [["Subtotal", money(subtotal)], ["Tax", money(float(data.get("tax", 0.0)))], [total_label, money(expected_total)]],
        colWidths=[1.45 * inch, 1.2 * inch],
        hAlign="RIGHT",
    )
    totals.setStyle(
        TableStyle(
            [
                ("FONTNAME", (0, 0), (-1, -1), "Helvetica"),
                ("FONTNAME", (0, 2), (-1, 2), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 10),
                ("ALIGN", (1, 0), (1, -1), "RIGHT"),
                ("TEXTCOLOR", (0, 2), (-1, 2), deep),
                ("LINEABOVE", (0, 2), (-1, 2), 1, accent),
                ("TOPPADDING", (0, 0), (-1, -1), 6),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
            ]
        )
    )
    story.append(totals)
    story.append(Spacer(1, 0.28 * inch))

    note = Table(
        [
            [Paragraph(required(data, "note"), styles["Body"])],
            [Paragraph(required(data, "traceability"), styles["Muted"])],
        ],
        colWidths=[6.95 * inch],
    )
    note.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#F9FAFB")),
                ("BOX", (0, 0), (-1, -1), 0.4, line_color),
                ("LEFTPADDING", (0, 0), (-1, -1), 10),
                ("RIGHTPADDING", (0, 0), (-1, -1), 10),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    story.append(note)
    doc.build(story)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    data = json.loads(args.input.read_text(encoding="utf-8"))
    build_invoice(data, args.output)
    print(args.output.resolve())


if __name__ == "__main__":
    main()
