from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


BASE = Path(__file__).resolve().parent


def money(value):
    return f"${value:,.2f}"


def build_invoice(data):
    pdf_path = BASE / data["file_name"]
    doc = SimpleDocTemplate(
        str(pdf_path),
        pagesize=letter,
        rightMargin=0.62 * inch,
        leftMargin=0.62 * inch,
        topMargin=0.58 * inch,
        bottomMargin=0.55 * inch,
        title=data["title"],
        author="Buy Your Home",
    )

    styles = getSampleStyleSheet()
    styles.add(
        ParagraphStyle(
            name="TitleLeft",
            parent=styles["Title"],
            alignment=0,
            fontName="Helvetica-Bold",
            fontSize=24,
            textColor=colors.HexColor("#1F2937"),
            leading=28,
            spaceAfter=4,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Body",
            parent=styles["Normal"],
            fontSize=10,
            textColor=colors.HexColor("#111827"),
            leading=14,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Muted",
            parent=styles["Normal"],
            fontSize=8.8,
            textColor=colors.HexColor("#6B7280"),
            leading=11,
        )
    )

    accent = colors.HexColor("#1F6F78")
    deep = colors.HexColor("#124E57")
    pale = colors.HexColor("#E9F5F6")
    line = colors.HexColor("#D1D5DB")

    story = []
    header = Table(
        [
            [
                Paragraph("Buy Your Home", styles["TitleLeft"]),
                Paragraph(
                    "<b>INVOICE DRAFT</b><br/>For Time Card processing<br/>Not approved for payment",
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

    status = Table(
        [
            [
                Paragraph("<b>Status:</b> Draft generated from routed timesheet", styles["Body"]),
                Paragraph("<b>Draft Date:</b> July 20, 2026", styles["Body"]),
            ]
        ],
        colWidths=[4.3 * inch, 2.65 * inch],
    )
    status.setStyle(
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
    story.append(status)
    story.append(Spacer(1, 0.22 * inch))

    details = Table(
        [
            [
                Paragraph("<b>Vendor</b><br/>Josh Kennedy<br/>IRAManager@<br/>SellYourHomeRaleigh.com", styles["Body"]),
                Paragraph(f"<b>Project / Bucket</b><br/>{data['project']}<br/>{data['subtitle']}", styles["Body"]),
                Paragraph("<b>Bill To</b><br/>Buy Your Home<br/>Office Admin", styles["Body"]),
            ]
        ],
        colWidths=[2.28 * inch, 2.28 * inch, 2.28 * inch],
    )
    details.setStyle(
        TableStyle(
            [
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("BOX", (0, 0), (-1, -1), 0.4, line),
                ("INNERGRID", (0, 0), (-1, -1), 0.4, line),
                ("LEFTPADDING", (0, 0), (-1, -1), 10),
                ("RIGHTPADDING", (0, 0), (-1, -1), 10),
                ("TOPPADDING", (0, 0), (-1, -1), 10),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 10),
            ]
        )
    )
    story.append(details)
    story.append(Spacer(1, 0.28 * inch))

    item_rows = [
        ["Field", "Value"],
        ["Invoice #", data["invoice_no"]],
        ["Work Date", "2026-07-20"],
        ["Description", Paragraph(data["description"], styles["Body"])],
        ["Hours", f"{data['hours']:.2f}"],
        ["Rate", money(31.25)],
        ["Amount", money(data["amount"])],
    ]
    items = Table(item_rows, colWidths=[1.35 * inch, 5.55 * inch])
    items.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), deep),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTNAME", (0, 1), (0, -1), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 9.2),
                ("ALIGN", (1, 4), (1, -1), "RIGHT"),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("GRID", (0, 0), (-1, -1), 0.35, line),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    story.append(items)
    story.append(Spacer(1, 0.18 * inch))

    totals = Table(
        [["Subtotal", money(data["amount"])], ["Tax", money(0.00)], ["Draft Total", money(data["amount"])]],
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
            [
                Paragraph(
                    "This draft was generated from a routed timesheet email. It is not approved for payment, "
                    "not vendor-verified, and not posted to any project spreadsheet.",
                    styles["Body"],
                )
            ],
            [
                Paragraph(
                    "Source: C:\\Codex\\Wiki Files\\Project Rooms\\Invoice Entry\\sources\\email\\2026-07-20-204307-josh-kennedy-timesheet.md",
                    styles["Muted"],
                )
            ],
        ],
        colWidths=[6.95 * inch],
    )
    note.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#F9FAFB")),
                ("BOX", (0, 0), (-1, -1), 0.4, line),
                ("LEFTPADDING", (0, 0), (-1, -1), 10),
                ("RIGHTPADDING", (0, 0), (-1, -1), 10),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    story.append(note)

    doc.build(story)
    return pdf_path


invoices = [
    {
        "file_name": "26-07-24 - Josh Kennedy - Time Card - BackOffice - Week Ending 2026-07-24.pdf",
        "title": "Josh Kennedy BackOffice Time Card Invoice Draft",
        "invoice_no": "TC-JK-20260724-BACKOFFICE-001",
        "project": "BackOffice",
        "subtitle": "Onboarding and procedures",
        "description": "Back-office onboarding, account setup, and rules/procedures review.",
        "hours": 4.0,
        "amount": 125.00,
    },
    {
        "file_name": "26-07-24 - Josh Kennedy - Time Card - 4121 Tensity Dr - Week Ending 2026-07-24.pdf",
        "title": "Josh Kennedy Tensity Time Card Invoice Draft",
        "invoice_no": "TC-JK-20260724-TENSITY-001",
        "project": "24-HM - 4121 Tensity Dr",
        "subtitle": "Property walkthrough",
        "description": "4121 Tensity Dr property walkthrough and review of planned changes/responsibilities.",
        "hours": 2.75,
        "amount": 85.94,
    },
]


if __name__ == "__main__":
    for invoice in invoices:
        print(build_invoice(invoice))
