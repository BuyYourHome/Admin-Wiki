import argparse
import json
from collections import defaultdict
from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP
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


def validated_task_history(data, lines):
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
        if line.get("relationship") != "direct":
            raise ValueError("Task totals require a direct historical task match; retain related or combined uncertain work outside the totals")
        earlier[key] += time_minutes(line)
    return history, groups, current, earlier


def running_hourly_average(data, lines):
    basis = required(data, "running_hourly_average")
    if basis.get("basis_type") != "recorded_invoice_compensation":
        raise ValueError("Running average requires a disclosed recorded-invoice compensation basis")
    cutoff = datetime.strptime(required(data["task_history"], "period_end"), "%Y-%m-%d").date()
    seen = set()
    periods = []
    compensation = Decimal("0")
    minutes = 0
    current_found = False
    for row in required(basis, "periods"):
        invoice_id = required(row, "invoice_id")
        if invoice_id in seen:
            raise ValueError("Duplicate invoice in running average")
        seen.add(invoice_id)
        if required(row, "issuer").casefold() != data["issuer"].casefold():
            raise ValueError("Running average contains another worker")
        required(row, "source_reference")
        start = datetime.strptime(required(row, "period_start"), "%Y-%m-%d").date()
        end = datetime.strptime(required(row, "period_end"), "%Y-%m-%d").date()
        if start > end or end > cutoff:
            raise ValueError("Running average period is invalid or after the invoice cutoff")
        amount = Decimal(str(required(row, "compensation")))
        count = Decimal(str(required(row, "minutes")))
        if not amount.is_finite() or amount <= 0 or amount != amount.quantize(Decimal("0.01")):
            raise ValueError("Running compensation must be a positive cent amount")
        if not count.is_finite() or count <= 0 or count != count.to_integral_value():
            raise ValueError("Running average requires positive whole recorded minutes")
        if invoice_id == data["invoice_no"]:
            if amount != Decimal(str(data["invoice_total"])) or int(count) != sum(time_minutes(line) for line in lines) or start.isoformat() != data["task_history"]["period_start"] or end != cutoff:
                raise ValueError("Running average current period disagrees with invoice")
            current_found = True
        periods.append((start, end))
        compensation += amount
        minutes += int(count)
    periods.sort()
    if any(periods[index][0] <= periods[index-1][1] for index in range(1, len(periods))):
        raise ValueError("Overlapping periods in running average")
    if not current_found:
        raise ValueError("Running average must include the exact current invoice once")
    rate = compensation * 60 / Decimal(minutes)
    return rate, compensation, minutes, periods[0][0], cutoff


def task_summary(data, lines, body, deep, pale, line_color):
    history, groups, current, earlier = validated_task_history(data, lines)
    rate, compensation, basis_minutes, basis_start, cutoff = running_hourly_average(data, lines)
    story = [PageBreak(), Paragraph("<b>Task Hours Statement</b>", ParagraphStyle("TaskSummaryTitle", parent=body, fontSize=19, leading=23)), Spacer(1, 7)]
    story.append(Paragraph(f"<b>{escape(data['issuer'])}</b> | Invoice {escape(data['invoice_no'])}<br/>Tasks included in {escape(data['period'])}; recorded hours through {escape(history['period_end'])}", body))
    story.extend([Spacer(1, 8), Paragraph(f"<b>Running average: ${rate:,.4f}/hr</b> = ${compensation:,.2f} recorded invoice compensation / {hours_minutes(basis_minutes)} reported work, {basis_start:%m/%d/%Y}-{cutoff:%m/%d/%Y}. Includes all projects and office time; includes unapproved draft compensation where applicable. This is not verified cash paid.", body), Spacer(1, 7), Paragraph("Estimated task compensation = total recorded task hours to date x the unrounded running average, rounded to cents. Earlier hours and these estimates add no hours or charges to this invoice.", body), Spacer(1, 8)])
    rows = [["Project / task", "Earlier", "This\nperiod", "Total hours\nto date", "Est. task\ncompensation"]]
    projects = list(dict.fromkeys(row['project'] for row in lines))
    for project in projects:
        for key in current:
            group = groups[key]
            if group['project'] != project:
                continue
            total_minutes = current[key]+earlier[key]
            estimate = (Decimal(total_minutes) * rate / 60).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
            rows.append([Paragraph(escape(f"{project} - {group['name']}"), body), hours_minutes(earlier[key]) if earlier[key] else "--", hours_minutes(current[key]), hours_minutes(total_minutes), f"${estimate:,.2f}"])
    table = Table(rows, colWidths=[3.0*inch, 0.75*inch, 0.9*inch, 1.05*inch, 1.2*inch], repeatRows=1)
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), deep), ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"), ("FONTSIZE", (0, 0), (-1, -1), 8.5),
        ("ALIGN", (1, 1), (-1, -1), "RIGHT"), ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("GRID", (0, 0), (-1, -1), 0.35, line_color), ("TOPPADDING", (0, 0), (-1, -1), 6),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
    ]))
    story.extend([table, Spacer(1, 9), Paragraph(escape(required(history, 'coverage')), body)])
    for note in history.get('summary_notes', []):
        story.extend([Spacer(1, 6), Paragraph(escape(str(note)), body)])
    notes = data.get('display_review_notes', data.get('review_notes', []))
    if notes:
        story.extend([Spacer(1, 10), Paragraph('<b>Accuracy review notes</b>', body)])
        for index, note in enumerate(notes, 1):
            story.extend([Spacer(1, 4), Paragraph(f'<b>{index}.</b> {escape(str(note))}', body)])
    return story


def project_time_detail(data, lines, body, deep, pale, line_color):
    grouped = defaultdict(list)
    for line in lines:
        grouped[required(line, 'project')].append(line)
    allocations = {row['project']: row for row in data['allocation_summary']}
    if set(grouped) != set(allocations):
        raise ValueError('Project detail and allocation projects disagree')
    compact = ParagraphStyle('ProjectDetail', parent=body, fontSize=7.6, leading=9.2)
    rows = [['Date', 'Task / work performed', 'Hours', 'Amount']]
    project_rows, subtotal_rows = [], []
    for project, entries in grouped.items():
        project_rows.append(len(rows))
        rows.append([project, '', '', ''])
        minutes = 0
        for line in sorted(entries, key=statement_day):
            minutes += time_minutes(line)
            rows.append([str(line['date']), Paragraph(escape(required(line, 'description')), compact), hours_minutes(time_minutes(line)), money(line['allocated_cost'])])
        allocation = allocations[project]
        if Decimal(str(required(allocation,'hours')))*60 != minutes:
            raise ValueError(f'Invoice detail hours disagree with allocation for {project}')
        subtotal_rows.append(len(rows))
        rows.append([f'{project} subtotal', '', hours_minutes(minutes), money(allocation['allocated_cost'])])
    rows.append(['CURRENT PERIOD TOTAL', '', hours_minutes(sum(time_minutes(line) for line in lines)), money(data['invoice_total'])])
    subtotal_rows.append(len(rows)-1)
    table = Table(rows, colWidths=[0.8*inch, 4.3*inch, 0.85*inch, 0.95*inch], repeatRows=1)
    commands = [
        ('BACKGROUND',(0,0),(-1,0),deep),('TEXTCOLOR',(0,0),(-1,0),colors.white),
        ('FONTNAME',(0,0),(-1,0),'Helvetica-Bold'),('FONTSIZE',(0,0),(-1,-1),8),
        ('ALIGN',(2,1),(-1,-1),'RIGHT'),('VALIGN',(0,0),(-1,-1),'TOP'),
        ('GRID',(0,0),(-1,-1),0.35,line_color),('TOPPADDING',(0,0),(-1,-1),4),
        ('BOTTOMPADDING',(0,0),(-1,-1),4),
    ]
    for row in project_rows:
        commands.extend([('SPAN',(0,row),(-1,row)),('BACKGROUND',(0,row),(-1,row),pale),('FONTNAME',(0,row),(-1,row),'Helvetica-Bold')])
    for row in subtotal_rows:
        commands.extend([('SPAN',(0,row),(1,row)),('BACKGROUND',(0,row),(-1,row),pale),('FONTNAME',(0,row),(-1,row),'Helvetica-Bold')])
    table.setStyle(TableStyle(commands))
    return [Paragraph('<b>Current-period time by project</b>', body), Spacer(1,4), table, Spacer(1,6), Paragraph('An asterisk marks an unresolved date/time interpretation. See the review notes on page 2. Combined work blocks remain unsplit.',body), Spacer(1,8)]


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
    if not josh_statement:
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
        story.extend(project_time_detail(data, lines, body, deep, pale, line_color))
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
        story.extend(task_summary(data, lines, body, deep, pale, line_color))
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
