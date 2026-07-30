import argparse
import json
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


def build_report(data, output_path):
    worker = required(data, "worker")
    project = required(data, "project")
    report_no = required(data, "report_no")
    report_date = required(data, "report_date")
    period = required(data, "period")
    lines = required(data, "lines")
    expected_total = round(float(required(data, "allocated_total")), 2)
    line_total = round(sum(float(line["allocated_cost"]) for line in lines), 2)
    if line_total != expected_total:
        raise ValueError(f"Line total {line_total:.2f} does not match allocated total {expected_total:.2f}")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    doc = SimpleDocTemplate(
        str(output_path),
        pagesize=letter,
        rightMargin=0.62 * inch,
        leftMargin=0.62 * inch,
        topMargin=0.52 * inch,
        bottomMargin=0.52 * inch,
        title=f"{worker} Project Cost Allocation Report",
        author="Buy Your Home",
    )
    styles = getSampleStyleSheet()
    body = ParagraphStyle(
        "Body",
        parent=styles["Normal"],
        fontName="Helvetica",
        fontSize=9.6,
        leading=12.5,
        textColor=colors.HexColor("#111827"),
    )
    muted = ParagraphStyle(
        "Muted",
        parent=body,
        fontSize=8.5,
        leading=10.5,
        textColor=colors.HexColor("#6B7280"),
    )
    title = ParagraphStyle(
        "ReportTitle",
        parent=styles["Title"],
        alignment=0,
        fontName="Helvetica-Bold",
        fontSize=20,
        leading=23,
        textColor=colors.HexColor("#1F2937"),
    )
    deep = colors.HexColor("#124E57")
    accent = colors.HexColor("#1F6F78")
    pale = colors.HexColor("#E9F5F6")
    warning = colors.HexColor("#FFF4E5")
    line_color = colors.HexColor("#D1D5DB")

    story = []
    header = Table(
        [[
            Paragraph(f"PROJECT COST<br/>ALLOCATION REPORT<br/><font size='9'>Buy Your Home</font>", title),
            Paragraph(
                "<b>INTERNAL ALLOCATION ONLY</b><br/>NOT AN INVOICE<br/>NOT PAYABLE",
                ParagraphStyle("Right", parent=body, alignment=2, leading=14, textColor=deep),
            ),
        ]],
        colWidths=[4.7 * inch, 2.25 * inch],
    )
    header.setStyle(TableStyle([
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LINEBELOW", (0, 0), (-1, -1), 1.2, accent),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 12),
    ]))
    story.extend([header, Spacer(1, 0.18 * inch)])

    status = Table(
        [[
            Paragraph("<b>Status:</b> Internal cost allocation - not payable", body),
            Paragraph(f"<b>Report Date:</b> {report_date}", body),
        ]],
        colWidths=[4.3 * inch, 2.65 * inch],
    )
    status.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), pale),
        ("BOX", (0, 0), (-1, -1), 0.6, colors.HexColor("#B7DDE1")),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
    ]))
    story.extend([status, Spacer(1, 0.22 * inch)])

    details = Table(
        [[
            Paragraph(f"<b>Worker</b><br/>{worker}", body),
            Paragraph(f"<b>Allocation Destination</b><br/>{project}", body),
            Paragraph(f"<b>Time Period</b><br/>{period}", body),
        ]],
        colWidths=[2.28 * inch, 2.28 * inch, 2.28 * inch],
    )
    details.setStyle(TableStyle([
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("BOX", (0, 0), (-1, -1), 0.4, line_color),
        ("INNERGRID", (0, 0), (-1, -1), 0.4, line_color),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 10),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
    ]))
    story.extend([details, Spacer(1, 0.24 * inch)])

    meta = Table([["Report #", report_no]], colWidths=[1.35 * inch, 5.55 * inch])
    meta.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, -1), deep),
        ("TEXTCOLOR", (0, 0), (-1, -1), colors.white),
        ("FONTNAME", (0, 0), (-1, -1), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 9.2),
        ("LEFTPADDING", (0, 0), (-1, -1), 7),
        ("RIGHTPADDING", (0, 0), (-1, -1), 7),
        ("TOPPADDING", (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
    ]))
    story.extend([meta, Spacer(1, 0.12 * inch)])

    rows = [["Work Date", "Description", "Hours", "Allocated Cost"]]
    for line in lines:
        rows.append([
            required(line, "date"),
            Paragraph(required(line, "description"), body),
            f"{float(required(line, 'hours')):.2f}",
            money(required(line, "allocated_cost")),
        ])
    items = Table(rows, colWidths=[0.95 * inch, 4.15 * inch, 0.8 * inch, 1.0 * inch])
    items.setStyle(TableStyle([
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
    ]))
    story.extend([items, Spacer(1, 0.18 * inch)])

    total = Table(
        [["Allocated Project Cost", money(expected_total)]],
        colWidths=[1.8 * inch, 1.2 * inch],
        hAlign="RIGHT",
    )
    total.setStyle(TableStyle([
        ("FONTNAME", (0, 0), (-1, -1), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 10),
        ("ALIGN", (1, 0), (1, 0), "RIGHT"),
        ("TEXTCOLOR", (0, 0), (-1, -1), deep),
        ("LINEABOVE", (0, 0), (-1, 0), 1, accent),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
    ]))
    story.extend([total, Spacer(1, 0.25 * inch)])

    note = Table(
        [[Paragraph(
            "<b>NON-PAYABLE RECORD:</b> This report allocates a portion of Josh Kennedy's fixed weekly service cost to the destination shown above. It does not authorize or request a separate payment.",
            body,
        )], [Paragraph(required(data, "method_note"), body)], [Paragraph(required(data, "traceability"), muted)]],
        colWidths=[6.95 * inch],
    )
    note.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), warning),
        ("BACKGROUND", (0, 1), (-1, -1), colors.HexColor("#F9FAFB")),
        ("BOX", (0, 0), (-1, -1), 0.5, line_color),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
    ]))
    story.append(note)
    doc.build(story)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    build_report(json.loads(args.input.read_text(encoding="utf-8")), args.output)
    print(args.output.resolve())


if __name__ == "__main__":
    main()
