import argparse
import json
from collections import defaultdict
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


def money(value):
    return f"${float(value):,.2f}"


def required(data, key):
    value = data.get(key)
    if value in (None, "", []):
        raise ValueError(f"Missing required field: {key}")
    return value


def build_invoice(data, output_path):
    issuer = required(data, "issuer")
    contact_email = required(data, "contact_email")
    customer = data.get("customer", "Buy Your Home")
    invoice_no = required(data, "invoice_no")
    invoice_date = required(data, "invoice_date")
    period = required(data, "period")
    status_text = data.get("status", "Draft - Awaiting Wes Approval")
    lines = required(data, "lines")
    expected_total = round(float(required(data, "invoice_total")), 2)
    line_total = round(sum(float(line["allocated_cost"]) for line in lines), 2)
    if line_total != expected_total:
        raise ValueError(
            f"Line total {line_total:.2f} does not match invoice total {expected_total:.2f}"
        )

    calculated_allocations = defaultdict(float)
    calculated_hours = defaultdict(float)
    for line in lines:
        project = required(line, "project")
        calculated_allocations[project] += float(required(line, "allocated_cost"))
        calculated_hours[project] += float(required(line, "hours"))

    allocation_summary = required(data, "allocation_summary")
    summary_total = round(sum(float(row["allocated_cost"]) for row in allocation_summary), 2)
    if summary_total != expected_total:
        raise ValueError(
            f"Allocation summary {summary_total:.2f} does not match invoice total {expected_total:.2f}"
        )
    for row in allocation_summary:
        project = required(row, "project")
        if round(calculated_allocations[project], 2) != round(float(row["allocated_cost"]), 2):
            raise ValueError(f"Allocation mismatch for {project}")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    doc = SimpleDocTemplate(
        str(output_path),
        pagesize=letter,
        rightMargin=0.55 * inch,
        leftMargin=0.55 * inch,
        topMargin=0.48 * inch,
        bottomMargin=0.48 * inch,
        title=f"{issuer} Time Card Invoice {invoice_no}",
        author=issuer,
    )
    styles = getSampleStyleSheet()
    body = ParagraphStyle(
        "Body",
        parent=styles["Normal"],
        fontName="Helvetica",
        fontSize=8.8,
        leading=11,
        textColor=colors.HexColor("#111827"),
    )
    vendor = ParagraphStyle(
        "Vendor",
        parent=body,
        fontSize=10,
        leading=13,
        textColor=colors.HexColor("#124E57"),
    )
    title = ParagraphStyle(
        "InvoiceTitle",
        parent=styles["Title"],
        alignment=0,
        fontName="Helvetica-Bold",
        fontSize=25,
        leading=28,
        textColor=colors.HexColor("#1F2937"),
    )
    deep = colors.HexColor("#124E57")
    accent = colors.HexColor("#1F6F78")
    pale = colors.HexColor("#E9F5F6")
    line_color = colors.HexColor("#D1D5DB")

    story = []
    story.extend([
        Paragraph(f"<b>{issuer}</b><br/>{contact_email}", vendor),
        Spacer(1, 0.09 * inch),
    ])
    header = Table(
        [[
            Paragraph("INVOICE", title),
            Paragraph(
                f"<b>{status_text}</b>",
                ParagraphStyle("Right", parent=body, alignment=2, leading=13, textColor=deep),
            ),
        ]],
        colWidths=[4.45 * inch, 2.45 * inch],
    )
    header.setStyle(TableStyle([
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LINEBELOW", (0, 0), (-1, -1), 1.2, accent),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
    ]))
    story.extend([header, Spacer(1, 0.14 * inch)])

    details = Table(
        [[
            Paragraph(f"<b>Invoice #</b><br/>{invoice_no}", body),
            Paragraph(f"<b>Invoice Date</b><br/>{invoice_date}", body),
            Paragraph(f"<b>Service Period</b><br/>{period}", body),
            Paragraph(f"<b>Customer</b><br/>{customer}", body),
        ]],
        colWidths=[1.85 * inch, 1.35 * inch, 1.95 * inch, 1.75 * inch],
    )
    details.setStyle(TableStyle([
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("BACKGROUND", (0, 0), (-1, -1), pale),
        ("BOX", (0, 0), (-1, -1), 0.5, colors.HexColor("#B7DDE1")),
        ("INNERGRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#B7DDE1")),
        ("LEFTPADDING", (0, 0), (-1, -1), 8),
        ("RIGHTPADDING", (0, 0), (-1, -1), 8),
        ("TOPPADDING", (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
    ]))
    story.extend([details, Spacer(1, 0.17 * inch)])

    summary_rows = [["Project / Destination", "Hours", "Allocated Cost"]]
    for row in allocation_summary:
        summary_rows.append([
            required(row, "project"),
            row.get("hours_display", f"{float(required(row, 'hours')):.2f}"),
            money(required(row, "allocated_cost")),
        ])
    summary_rows.append(["TOTAL", data.get("total_hours_display", f"{sum(calculated_hours.values()):.2f}"), money(expected_total)])
    summary = Table(summary_rows, colWidths=[4.85 * inch, 0.95 * inch, 1.1 * inch])
    summary.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), deep),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 8.8),
        ("ALIGN", (1, 1), (-1, -1), "RIGHT"),
        ("GRID", (0, 0), (-1, -1), 0.35, line_color),
        ("LEFTPADDING", (0, 0), (-1, -1), 6),
        ("RIGHTPADDING", (0, 0), (-1, -1), 6),
        ("TOPPADDING", (0, 0), (-1, -1), 5),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
    ]))
    story.extend([Paragraph("<b>Project Allocation Summary</b>", body), Spacer(1, 0.05 * inch), summary, Spacer(1, 0.17 * inch)])

    rows = [["Work Date", "Project / Destination", "Description", "Hours", "Allocated Cost"]]
    for line in lines:
        rows.append([
            required(line, "date"),
            Paragraph(required(line, "project"), body),
            Paragraph(required(line, "description"), body),
            line.get("hours_display", f"{float(required(line, 'hours')):.2f}"),
            money(required(line, "allocated_cost")),
        ])
    items = Table(
        rows,
        colWidths=[0.72 * inch, 1.25 * inch, 3.08 * inch, 0.85 * inch, 1.0 * inch],
        repeatRows=1,
    )
    items.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), deep),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 8.2),
        ("ALIGN", (3, 1), (-1, -1), "RIGHT"),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("GRID", (0, 0), (-1, -1), 0.35, line_color),
        ("LEFTPADDING", (0, 0), (-1, -1), 4),
        ("RIGHTPADDING", (0, 0), (-1, -1), 4),
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]))
    story.extend([Paragraph("<b>Time and Allocation Detail</b>", body), Spacer(1, 0.05 * inch), items, Spacer(1, 0.14 * inch)])

    total = Table(
        [["Amount Due", money(expected_total)]],
        colWidths=[1.8 * inch, 1.2 * inch],
        hAlign="RIGHT",
    )
    total.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 11),
        ("ALIGN", (1, 0), (1, 0), "RIGHT"),
        ("TEXTCOLOR", (0, 0), (-1, -1), deep),
        ("LINEABOVE", (0, 0), (-1, 0), 1, accent),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
    ]))
    story.append(total)
    doc.build(story)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--status")
    args = parser.parse_args()
    data = json.loads(args.input.read_text(encoding="utf-8"))
    if args.status:
        data["status"] = args.status
    build_invoice(data, args.output)
    print(args.output.resolve())


if __name__ == "__main__":
    main()
