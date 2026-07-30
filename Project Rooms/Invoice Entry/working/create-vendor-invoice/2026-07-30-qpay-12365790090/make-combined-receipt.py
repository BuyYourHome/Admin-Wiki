from pathlib import Path

from pypdf import PdfReader, PdfWriter
from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parent
ESTIMATE = Path(
    r"C:\Users\wesbr\Buy Your Home\Buy Your Home - Office Admin\Scanned Files"
    r"\Invoice Entry Working Archive\Source Documents\2026-07-30 QPay 10651 Estimate"
    r"\Estimate_10651.pdf"
)
COVER = ROOT / "receipt-cover.pdf"
OUTPUT = ROOT / "26-07-30 - USA Flooring NC - 10651 - Receipt.pdf"


def money(value):
    return f"${value:,.2f}"


def build_cover():
    styles = getSampleStyleSheet()
    styles.add(
        ParagraphStyle(
            name="ReceiptTitle",
            parent=styles["Title"],
            fontName="Helvetica-Bold",
            fontSize=22,
            leading=25,
            textColor=colors.HexColor("#1F2937"),
            spaceAfter=4,
        )
    )
    styles.add(
        ParagraphStyle(
            name="ReceiptBody",
            parent=styles["Normal"],
            fontSize=10,
            leading=14,
            textColor=colors.HexColor("#111827"),
        )
    )
    styles.add(
        ParagraphStyle(
            name="ReceiptMuted",
            parent=styles["Normal"],
            fontSize=8.5,
            leading=11,
            textColor=colors.HexColor("#6B7280"),
        )
    )

    doc = SimpleDocTemplate(
        str(COVER),
        pagesize=letter,
        leftMargin=0.65 * inch,
        rightMargin=0.65 * inch,
        topMargin=0.58 * inch,
        bottomMargin=0.58 * inch,
        title="USA Flooring NC Order 10651 Receipt",
        author="Buy Your Home",
    )
    body = styles["ReceiptBody"]
    muted = styles["ReceiptMuted"]
    teal = colors.HexColor("#155E63")
    line = colors.HexColor("#CBD5E1")

    story = [
        Paragraph("USA Flooring NC", styles["ReceiptTitle"]),
        Paragraph("PAYMENT RECEIPT", ParagraphStyle(
            "ReceiptHeading",
            parent=body,
            fontName="Helvetica-Bold",
            fontSize=13,
            textColor=teal,
            alignment=2,
        )),
        Spacer(1, 0.18 * inch),
    ]

    summary = Table(
        [
            [Paragraph("<b>Receipt Status</b><br/>Paid", body),
             Paragraph("<b>Payment Date</b><br/>July 30, 2026", body)],
            [Paragraph("<b>Project</b><br/>00-2156 Haig Point Way", body),
             Paragraph("<b>Category</b><br/>Flooring", body)],
            [Paragraph("<b>Estimate / Order</b><br/>10651", body),
             Paragraph("<b>QPay Transaction</b><br/>12365790090", body)],
        ],
        colWidths=[3.35 * inch, 3.35 * inch],
    )
    summary.setStyle(TableStyle([
        ("BOX", (0, 0), (-1, -1), 0.5, line),
        ("INNERGRID", (0, 0), (-1, -1), 0.4, line),
        ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#F8FAFC")),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
    ]))
    story.extend([summary, Spacer(1, 0.25 * inch)])

    payment = Table(
        [
            [Paragraph("<b>Payment Detail</b>", body), ""],
            [Paragraph("USA Flooring estimate total", body), Paragraph(money(365.51), body)],
            [Paragraph("QPay card surcharge (3%)", body), Paragraph(money(10.97), body)],
            [Paragraph("<b>Total paid</b>", body), Paragraph(f"<b>{money(376.48)}</b>", body)],
        ],
        colWidths=[5.25 * inch, 1.45 * inch],
    )
    payment.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), teal),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
        ("SPAN", (0, 0), (-1, 0)),
        ("BOX", (0, 0), (-1, -1), 0.5, line),
        ("INNERGRID", (0, 1), (-1, -1), 0.4, line),
        ("ALIGN", (1, 1), (1, -1), "RIGHT"),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
    ]))
    story.extend([payment, Spacer(1, 0.25 * inch)])

    details = [
        ["Payment method", "MasterCard ending 6426"],
        ["Transaction time", "July 30, 2026 at 11:14 AM EDT"],
        ["Estimate sale date", "July 28, 2026"],
        ["Material", "156 sq ft Gateway / Darce Lane flooring"],
        ["Material amount", "$241.80"],
        ["Freight", "$99.00"],
        ["Sales tax", "$24.71"],
    ]
    detail_table = Table(
        [[Paragraph(f"<b>{label}</b>", body), Paragraph(value, body)] for label, value in details],
        colWidths=[2.1 * inch, 4.6 * inch],
    )
    detail_table.setStyle(TableStyle([
        ("BOX", (0, 0), (-1, -1), 0.5, line),
        ("INNERGRID", (0, 0), (-1, -1), 0.4, line),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 7),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
    ]))
    story.extend([
        detail_table,
        Spacer(1, 0.28 * inch),
        Paragraph(
            "This receipt combines QPay payment confirmation with USA Flooring NC estimate 10651. "
            "The original four-page estimate follows this cover page.",
            body,
        ),
        Spacer(1, 0.14 * inch),
        Paragraph(
            "Source traceability: OfficeAssist Outlook message ending ACgMftuQAAAA==; "
            "follow-up estimate handoff message ending ACgMftugAAAA==; "
            "estimate SHA-256 97F1ABAE749162BBE60B016572A502E1657FE469A5F0F0A0F27CEC582E8898ED.",
            muted,
        ),
    ])
    doc.build(story)


def merge():
    writer = PdfWriter()
    for path in (COVER, ESTIMATE):
        reader = PdfReader(str(path))
        for page in reader.pages:
            writer.add_page(page)
    writer.add_metadata({
        "/Title": "USA Flooring NC Order 10651 Receipt",
        "/Author": "Buy Your Home",
        "/Subject": "QPay transaction 12365790090 and USA Flooring NC estimate 10651",
    })
    with OUTPUT.open("wb") as stream:
        writer.write(stream)


if __name__ == "__main__":
    build_cover()
    merge()
    print(OUTPUT)
