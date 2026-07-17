from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
)


BASE = Path(__file__).resolve().parent
PDF_PATH = BASE / "tim-fleming-pond-hours-invoice-draft.pdf"
CONFIRMED_PDF_PATH = BASE / "tim-fleming-pond-hours-invoice-confirmed.pdf"


def money(value):
    return f"${value:,.2f}"


def build_invoice(
    pdf_path=PDF_PATH,
    title="Tim Fleming Pond Hours Invoice Draft",
    status_heading="INVOICE DRAFT",
    status_subheading="For vendor verification",
    status_line="Held pending Tim Fleming verification",
    verification_note=(
        "This invoice draft was generated from Tim Fleming's email reporting 22 total hours. "
        "It should be sent to Tim for confirmation before it is treated as a final invoice, filed to Teams, "
        "posted to a project spreadsheet, approved, or paid."
    ),
):
    doc = SimpleDocTemplate(
        str(pdf_path),
        pagesize=letter,
        rightMargin=0.62 * inch,
        leftMargin=0.62 * inch,
        topMargin=0.58 * inch,
        bottomMargin=0.55 * inch,
        title=title,
        author="Buy Your Home",
    )

    styles = getSampleStyleSheet()
    styles.add(
        ParagraphStyle(
            name="SmallCaps",
            parent=styles["Normal"],
            fontName="Helvetica-Bold",
            fontSize=8.5,
            textColor=colors.HexColor("#4B5563"),
            leading=11,
            spaceAfter=2,
        )
    )
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
            name="Muted",
            parent=styles["Normal"],
            fontSize=9,
            textColor=colors.HexColor("#6B7280"),
            leading=12,
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

    accent = colors.HexColor("#1F6F78")
    deep = colors.HexColor("#124E57")
    pale = colors.HexColor("#E9F5F6")
    line = colors.HexColor("#D1D5DB")
    dark = colors.HexColor("#111827")
    muted = colors.HexColor("#6B7280")

    story = []

    header = Table(
        [
            [
                Paragraph("Buy Your Home", styles["TitleLeft"]),
                Paragraph(
                    f"<b>{status_heading}</b><br/>{status_subheading}<br/>Not approved for payment",
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
                Paragraph(f"<b>Status:</b> {status_line}", styles["Body"]),
                Paragraph("<b>Draft Date:</b> July 17, 2026", styles["Body"]),
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
                Paragraph("<b>Vendor</b><br/>Tim Fleming<br/>tflem04@gmail.com", styles["Body"]),
                Paragraph(
                    "<b>Project</b><br/>26-BYH -908 Pond St<br/>Pond work hours",
                    styles["Body"],
                ),
                Paragraph(
                    "<b>Bill To</b><br/>Buy Your Home<br/>Office Admin",
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
        ["Service Period", "Description", "Hours", "Rate", "Amount"],
        ["July 6-10, 2026", "Pond work hours", "4.0", money(62.50), money(250.00)],
        ["July 13-17, 2026", "Pond work hours", "18.0", money(62.50), money(1125.00)],
    ]
    items = Table(item_rows, colWidths=[1.45 * inch, 2.35 * inch, 0.8 * inch, 1.05 * inch, 1.2 * inch])
    items.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), deep),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 9.5),
                ("ALIGN", (2, 1), (-1, -1), "RIGHT"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor("#F9FAFB")]),
                ("GRID", (0, 0), (-1, -1), 0.35, line),
                ("LEFTPADDING", (0, 0), (-1, -1), 8),
                ("RIGHTPADDING", (0, 0), (-1, -1), 8),
                ("TOPPADDING", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
            ]
        )
    )
    story.append(items)
    story.append(Spacer(1, 0.18 * inch))

    totals = Table(
        [
            ["Subtotal", money(1375.00)],
            ["Tax", money(0.00)],
            ["Draft Total", money(1375.00)],
        ],
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
    story.append(Spacer(1, 0.3 * inch))

    note = Table(
        [
            [
                Paragraph(
                    f"<b>Verification note</b><br/>{verification_note}",
                    styles["Body"],
                )
            ]
        ],
        colWidths=[6.85 * inch],
    )
    note.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#FFF7ED")),
                ("BOX", (0, 0), (-1, -1), 0.5, colors.HexColor("#FDBA74")),
                ("LEFTPADDING", (0, 0), (-1, -1), 10),
                ("RIGHTPADDING", (0, 0), (-1, -1), 10),
                ("TOPPADDING", (0, 0), (-1, -1), 9),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 9),
            ]
        )
    )
    story.append(note)
    story.append(Spacer(1, 0.18 * inch))

    source = Paragraph(
        "Source: Routed OfficeAssist email, received 2026-07-17 19:44:46Z, subject "
        "'FW: Pond hours week of 7/6-7/17'. Invoice number pending vendor confirmation.",
        styles["Muted"],
    )
    story.append(source)

    doc.build(story)


if __name__ == "__main__":
    build_invoice()
    build_invoice(
        pdf_path=CONFIRMED_PDF_PATH,
        title="Tim Fleming Pond Hours Invoice",
        status_heading="INVOICE",
        status_subheading="Vendor confirmed",
        status_line="Vendor confirmed by email on July 17, 2026",
        verification_note=(
            "Tim Fleming confirmed this invoice by email reply on July 17, 2026. "
            "This document is ready for internal filing and spreadsheet placement review, but it is not approved for payment."
        ),
    )
    print(PDF_PATH)
    print(CONFIRMED_PDF_PATH)
