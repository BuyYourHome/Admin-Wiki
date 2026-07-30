from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


BASE = Path(__file__).resolve().parent
OUTPUT = BASE / "DRAFT - Outside Vendor Internal Invoice Template - Josh Kennedy Reference.pdf"


def money(value):
    return f"${value:,.2f}"


def build():
    doc = SimpleDocTemplate(
        str(OUTPUT),
        pagesize=letter,
        rightMargin=0.62 * inch,
        leftMargin=0.62 * inch,
        topMargin=0.52 * inch,
        bottomMargin=0.52 * inch,
        title="Outside Vendor Internal Invoice Template Draft",
        author="Buy Your Home",
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
    line = colors.HexColor("#D1D5DB")

    story = []
    header = Table(
        [
            [
                Paragraph(
                    "Josh Kennedy<br/><font size='10'>IRAManager@SellYourHomeRaleigh.com</font>",
                    styles["Issuer"],
                ),
                Paragraph(
                    "<b>INVOICE DRAFT</b><br/>Internal vendor invoice format<br/>Template approval only",
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
                Paragraph("<b>Status:</b> Template Draft - Not Approved for Use", styles["Body"]),
                Paragraph("<b>Invoice Date:</b> July 24, 2026", styles["Body"]),
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
                Paragraph("<b>Invoice From</b><br/>Josh Kennedy<br/>Outside service provider", styles["Body"]),
                Paragraph("<b>Customer</b><br/>Buy Your Home<br/>Office Admin", styles["Body"]),
                Paragraph("<b>Project / Bucket</b><br/>BackOffice<br/>Onboarding and procedures", styles["Body"]),
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
    story.append(Spacer(1, 0.26 * inch))

    invoice_meta = Table(
        [["Invoice #", "TC-JK-20260724-BACKOFFICE-001"]],
        colWidths=[1.35 * inch, 5.55 * inch],
    )
    invoice_meta.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), deep),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 9.2),
                ("GRID", (0, 0), (-1, -1), 0.35, line),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    story.append(invoice_meta)
    story.append(Spacer(1, 0.12 * inch))

    item_rows = [
        ["Work Date", "Description", "Hours", "Rate", "Amount"],
        [
            "2026-07-20",
            Paragraph("Back-office onboarding, account setup, and rules/procedures review.", styles["Body"]),
            "4.00",
            money(31.25),
            money(125.00),
        ],
        [
            "2026-07-21",
            Paragraph("BackOffice work from 1:00 P.M. to 4:45 P.M.", styles["Body"]),
            "3.75",
            money(31.25),
            money(117.19),
        ],
    ]
    items = Table(item_rows, colWidths=[0.85 * inch, 3.3 * inch, 0.72 * inch, 0.88 * inch, 1.15 * inch])
    items.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), deep),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 9.2),
                ("ALIGN", (2, 1), (-1, -1), "RIGHT"),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("GRID", (0, 0), (-1, -1), 0.35, line),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 6),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
            ]
        )
    )
    story.append(items)
    story.append(Spacer(1, 0.18 * inch))

    totals = Table(
        [["Subtotal", money(242.19)], ["Tax", money(0.00)], ["Invoice Total", money(242.19)]],
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
                    "Template sample only. This document demonstrates an invoice issued by Josh Kennedy to "
                    "Buy Your Home. It is not an active invoice and is not approved for payment.",
                    styles["Body"],
                )
            ],
            [
                Paragraph(
                    "Layout reference: invoice TC-JK-20260724-BACKOFFICE-001. "
                    "Proposed use: invoices Invoice Entry creates internally for outside people or vendors.",
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
    print(OUTPUT)


if __name__ == "__main__":
    build()
