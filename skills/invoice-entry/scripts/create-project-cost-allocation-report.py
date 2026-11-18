import argparse
import json
from collections import defaultdict
from datetime import datetime
from decimal import Decimal
from pathlib import Path
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import PageBreak, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


def money(value):
    return f"${float(value):,.2f}"


def required(data, key):
    value = data.get(key)
    if value in (None, "", []):
        raise ValueError(f"Missing required field: {key}")
    return value


def time_minutes(line):
    value = Decimal(str(line["minutes"])) if "minutes" in line else Decimal(str(required(line, "hours"))) * 60
    if not value.is_finite() or value <= 0 or value != value.to_integral_value():
        raise ValueError("Supporting statement requires positive source time in whole minutes")
    if abs(Decimal(str(required(line, "hours"))) * 60 - value) > Decimal("0.001"):
        raise ValueError("Supporting statement minutes disagree with invoice hours")
    return int(value)


def hours_minutes(minutes):
    return f"{minutes // 60}h{minutes % 60:02d}m"


def statement_day(line):
    value = str(line.get("worked_date_interpretation") or required(line, "date")).rstrip("*")
    for fmt in ("%Y-%m-%d", "%m/%d/%y", "%m/%d/%Y"):
        try:
            return datetime.strptime(value, fmt).date()
        except ValueError:
            pass
    raise ValueError(f"Supporting statement requires an unambiguous work date: {value}")


def history_statement(data, lines, body, deep, pale, line_color):
    history = required(data, "task_history")
    start = datetime.strptime(required(history, "period_start"), "%Y-%m-%d").date()
    end = datetime.strptime(required(history, "period_end"), "%Y-%m-%d").date()
    if start > end:
        raise ValueError("Task history period start is after its end")
    if end != statement_day({"date": data["invoice_date"]}):
        raise ValueError("Task history cutoff must match the semimonthly invoice date")
    groups = {row["id"]: row for row in required(history, "task_groups")}
    if len(groups) != len(history["task_groups"]):
        raise ValueError("Duplicate task group")
    current = defaultdict(int)
    earlier = defaultdict(int)
    for line in lines:
        key = required(line, "task_group")
        if key not in groups or groups[key]["project"] != line["project"]:
            raise ValueError("Current task group/project mismatch")
        if not start <= statement_day(line) <= end:
            raise ValueError("Invoice work date outside task history period")
        current[key] += time_minutes(line)
    seen = set()
    intervals = set()
    previous = history.get("earlier_lines", [])
    for line in previous:
        key = required(line, "task_group")
        if key not in current or groups[key]["project"] != line["project"]:
            raise ValueError("Earlier task group/project is not on this invoice")
        if statement_day(line) >= start:
            raise ValueError("Earlier history overlaps or follows this invoice period")
        source_key = required(line, "source_line_id")
        required(line, "source_reference")
        if source_key in seen:
            raise ValueError("Duplicate historical source interval")
        seen.add(source_key)
        interval = (line["source_reference"], statement_day(line), line["project"], required(line, "description"), time_minutes(line))
        if interval in intervals:
            raise ValueError("Duplicate historical source interval with a different line ID")
        intervals.add(interval)
        if line.get("relationship") not in ("direct", "related", "combined"):
            raise ValueError("Historical task relationship must be disclosed")
        earlier[key] += time_minutes(line)
    story = [PageBreak(), Paragraph("<b>Earlier Recorded Task Summary</b>", ParagraphStyle("HistoryTitle", parent=body, fontSize=18, leading=22)), Spacer(1, 8)]
    story.append(Paragraph(f"Invoice {escape(data['invoice_no'])} | Through {end:%B %d, %Y}", body))
    story.extend([Spacer(1, 8), Paragraph(escape(required(history, "coverage")), body), Spacer(1, 8), Paragraph("Earlier time is informational only and adds no hours or charges to this invoice. Totals count each reported interval once within the displayed task group. Related or combined intervals retain their full reported description; their hours cannot be assigned to one task alone. A dash means no matched earlier interval was located, not proof of zero lifetime time.", body), Spacer(1, 8)])
    rows = [["Project / task group", "Earlier", "This invoice", "Recorded total"]]
    for key, minutes in current.items():
        group = groups[key]
        rows.append([Paragraph(escape(f"{group['project']} - {group['name']}"), body), hours_minutes(earlier[key]) if earlier[key] else "--", hours_minutes(minutes), hours_minutes(earlier[key] + minutes)])
    table = Table(rows, colWidths=[3.75 * inch, 1.05 * inch, 1.05 * inch, 1.05 * inch], repeatRows=1)
    table.setStyle(TableStyle([("BACKGROUND", (0, 0), (-1, 0), deep), ("TEXTCOLOR", (0, 0), (-1, 0), colors.white), ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"), ("FONTSIZE", (0, 0), (-1, -1), 8.5), ("ALIGN", (1, 1), (-1, -1), "RIGHT"), ("VALIGN", (0, 0), (-1, -1), "TOP"), ("GRID", (0, 0), (-1, -1), 0.35, line_color), ("TOPPADDING", (0, 0), (-1, -1), 5), ("BOTTOMPADDING", (0, 0), (-1, -1), 5)]))
    story.append(table)
    for note in history.get("notes", []):
        story.extend([Spacer(1, 8), Paragraph(escape(str(note)), body)])
    if previous:
        story.extend([PageBreak(), Paragraph("<b>Earlier Recorded Intervals</b>", ParagraphStyle("HistoryDetailTitle", parent=body, fontSize=18, leading=22)), Spacer(1, 8), Paragraph("Earlier dates only; not billed again. Related = associated work, not an identical-task claim. Combined = an unsplit block covering several activities. Source references and duplicate decisions are retained with this statement's structured data.", body), Spacer(1, 8)])
        rows = [["Date / source", "Project / task group", "Reported work / relationship", "Hours"]]
        for line in sorted(previous, key=lambda row: (statement_day(row), row["project"], row["source_line_id"])):
            group = groups[line["task_group"]]
            rows.append([Paragraph(escape(f"{statement_day(line):%m/%d/%Y} / {line.get('source_label', 'source')}"), body), Paragraph(escape(f"{line['project']} - {group['name']}"), body), Paragraph(escape(f"{line['description']} [{line['relationship']}]"), body), hours_minutes(time_minutes(line))])
        table = Table(rows, colWidths=[1.0 * inch, 1.5 * inch, 3.5 * inch, 0.9 * inch], repeatRows=1)
        table.setStyle(TableStyle([("BACKGROUND", (0, 0), (-1, 0), deep), ("TEXTCOLOR", (0, 0), (-1, 0), colors.white), ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"), ("FONTSIZE", (0, 0), (-1, -1), 8.0), ("ALIGN", (-1, 1), (-1, -1), "RIGHT"), ("VALIGN", (0, 0), (-1, -1), "TOP"), ("GRID", (0, 0), (-1, -1), 0.35, line_color), ("TOPPADDING", (0, 0), (-1, -1), 4), ("BOTTOMPADDING", (0, 0), (-1, -1), 4)]))
        story.append(table)
    return story


def supporting_statement(data, lines, body, deep, pale, line_color):
    grouped = defaultdict(list)
    for line in lines:
        grouped[statement_day(line)].append(line)
    total_minutes = sum(time_minutes(line) for line in lines)
    project_minutes = defaultdict(int)
    for line in lines:
        project_minutes[line["project"]] += time_minutes(line)
    for allocation in data["allocation_summary"]:
        summary_minutes = Decimal(str(required(allocation, "hours"))) * 60
        if summary_minutes != project_minutes[allocation["project"]]:
            raise ValueError(f"Supporting statement hours disagree with allocation for {allocation['project']}")

    story = [PageBreak(), Paragraph("<b>Supporting Time Statement</b>", ParagraphStyle("StatementTitle", parent=body, fontSize=18, leading=22)), Spacer(1, 8)]
    story.append(Paragraph(f"<b>{escape(data['issuer'])}</b><br/>Invoice {escape(data['invoice_no'])} | {escape(data['period'])}", body))
    story.extend([Spacer(1, 8), Paragraph("Day-by-day task hours supporting the preceding invoice. This statement is part of that invoice and is not an additional charge.", body), Spacer(1, 8)])
    rows = [["Work Date", "Project / Destination", "Task / Work Performed", "Hours"]]
    subtotals = []
    for day in sorted(grouped):
        daily_minutes = 0
        for line in grouped[day]:
            minutes = time_minutes(line)
            daily_minutes += minutes
            rows.append([str(line["date"]), Paragraph(escape(str(line["project"])), body), Paragraph(escape(str(required(line, "description"))), body), hours_minutes(minutes)])
        subtotals.append(len(rows))
        rows.append([f"Daily total - {day:%m/%d/%Y}", "", "", hours_minutes(daily_minutes)])
    total_row = len(rows)
    rows.append(["STATEMENT TOTAL", "", "", hours_minutes(total_minutes)])
    table = Table(rows, colWidths=[0.8 * inch, 1.4 * inch, 3.7 * inch, 1.0 * inch], repeatRows=1)
    commands = [
        ("BACKGROUND", (0, 0), (-1, 0), deep), ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"), ("FONTSIZE", (0, 0), (-1, -1), 8.5),
        ("ALIGN", (-1, 1), (-1, -1), "RIGHT"), ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("GRID", (0, 0), (-1, -1), 0.35, line_color),
        ("LEFTPADDING", (0, 0), (-1, -1), 5), ("RIGHTPADDING", (0, 0), (-1, -1), 5),
        ("TOPPADDING", (0, 0), (-1, -1), 3), ("BOTTOMPADDING", (0, 0), (-1, -1), 3),
    ]
    for index in subtotals + [total_row]:
        commands.extend([("SPAN", (0, index), (2, index)), ("BACKGROUND", (0, index), (-1, index), pale), ("FONTNAME", (0, index), (-1, index), "Helvetica-Bold")])
    table.setStyle(TableStyle(commands))
    story.extend([table, Spacer(1, 8), Paragraph("When one reported interval covers multiple tasks, its hours apply to the combined work. Separate task hours are not invented. An asterisk retains a disclosed date or time interpretation; review notes follow when applicable.", body)])
    story.extend(history_statement(data, lines, body, deep, pale, line_color))
    if data.get("review_notes"):
        story.extend([PageBreak(), Paragraph("<b>Accuracy Review Notes</b>", ParagraphStyle("StatementNotesTitle", parent=body, fontSize=18, leading=22)), Spacer(1, 8), Paragraph(f"Invoice {escape(data['invoice_no'])} | {escape(data['period'])}", body)])
        for index, note in enumerate(data["review_notes"], 1):
            story.extend([Spacer(1, 10), Paragraph(f"<b>{index}.</b> {escape(str(note))}", body)])
    return story


def build_invoice(data, output_path):
    issuer = required(data, "issuer")
    contact_email = required(data, "contact_email")
    customer = data.get("customer", "Buy Your Home")
    invoice_no = required(data, "invoice_no")
    invoice_date = required(data, "invoice_date")
    period = required(data, "period")
    status_text = data.get("status", "Draft - Awaiting Wes Approval")
    lines = required(data, "lines")
    josh_statement = " ".join(str(issuer).casefold().split()) == "josh kennedy llc"
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
        topMargin=0.38 * inch,
        bottomMargin=0.35 * inch,
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
    if len(lines) >= 15:
        detail_font_size = 7.0
        detail_leading = 8.0
        detail_padding = 1.0
    elif len(lines) >= 12:
        detail_font_size = 7.4
        detail_leading = 8.6
        detail_padding = 1.5
    else:
        detail_font_size = 8.2
        detail_leading = 11
        detail_padding = 3
    detail_body = ParagraphStyle(
        "DetailBody",
        parent=body,
        fontSize=detail_font_size,
        leading=detail_leading,
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
        Spacer(1, 0.06 * inch),
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
    story.extend([header, Spacer(1, 0.11 * inch)])

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
    story.extend([details, Spacer(1, 0.12 * inch)])

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
        ("TOPPADDING", (0, 0), (-1, -1), 4),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
    ]))
    story.extend([Paragraph("<b>Project Allocation Summary</b>", body), Spacer(1, 0.04 * inch), summary, Spacer(1, 0.12 * inch)])

    rows = [["Work Date", "Project / Destination", "Description", "Hours", "Allocated Cost"]]
    for line in lines:
        rows.append([
            required(line, "date"),
            Paragraph(required(line, "project"), detail_body),
            Paragraph(required(line, "description"), detail_body),
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
        ("FONTSIZE", (0, 0), (-1, -1), detail_font_size),
        ("ALIGN", (3, 1), (-1, -1), "RIGHT"),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("GRID", (0, 0), (-1, -1), 0.35, line_color),
        ("LEFTPADDING", (0, 0), (-1, -1), 4),
        ("RIGHTPADDING", (0, 0), (-1, -1), 4),
        ("TOPPADDING", (0, 0), (-1, -1), detail_padding),
        ("BOTTOMPADDING", (0, 0), (-1, -1), detail_padding),
    ]))
    if josh_statement:
        story.extend([Paragraph("The following supporting statement lists each work day, task, and hours included in this invoice, with daily subtotals.", body), Spacer(1, 0.12 * inch)])
    else:
        story.extend([Paragraph("<b>Time and Allocation Detail</b>", body), Spacer(1, 0.04 * inch), items, Spacer(1, 0.08 * inch)])

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
    if josh_statement:
        story.extend(supporting_statement(data, lines, body, deep, pale, line_color))
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
