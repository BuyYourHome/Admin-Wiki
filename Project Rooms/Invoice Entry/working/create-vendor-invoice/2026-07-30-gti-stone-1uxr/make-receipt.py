from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "26-07-30 - GTI Stone Design LLC - 1UXR - Receipt.pdf"


def build_receipt():
    styles = getSampleStyleSheet()
    styles.add(
        ParagraphStyle(
            name="ReceiptTitle",
            parent=styles["Title"],
            fontName="Helvetica-Bold",
            fontSize=22,
            leading=25,
            textColor=colors.HexColor("#1F2937"),
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

    body = styles["ReceiptBody"]
    muted = styles["ReceiptMuted"]
    teal = colors.HexColor("#155E63")
    line = colors.HexColor("#CBD5E1")
    doc = SimpleDocTemplate(
        str(OUTPUT),
        pagesize=letter,
        leftMargin=0.65 * inch,
        rightMargin=0.65 * inch,
        topMargin=0.58 * inch,
        bottomMargin=0.58 * inch,
        title="GTI Stone Design LLC Square Receipt 1UXR",
        author="GTI Stone Design, LLC",
    )

    story = [
        Paragraph("GTI Stone Design, LLC", styles["ReceiptTitle"]),
        Paragraph(
            "PAYMENT RECEIPT",
            ParagraphStyle(
                "ReceiptHeading",
                parent=body,
                fontName="Helvetica-Bold",
                fontSize=13,
                textColor=teal,
                alignment=2,
            ),
        ),
        Spacer(1, 0.18 * inch),
    ]

    summary = Table(
        [
            [Paragraph("<b>Receipt Status</b><br/>Paid", body),
             Paragraph("<b>Payment Date</b><br/>July 30, 2026", body)],
            [Paragraph("<b>Project</b><br/>24-HM - 4121 Tensity Dr", body),
             Paragraph("<b>Category</b><br/>Needs Review", body)],
            [Paragraph("<b>Square Receipt</b><br/>#1UXR", body),
             Paragraph("<b>Authorization Code</b><br/>258926", body)],
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
            [Paragraph("Custom amount", body), Paragraph("$3,405.15", body)],
            [Paragraph("<b>Total paid</b>", body), Paragraph("<b>$3,405.15</b>", body)],
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

    details = Table(
        [
            [Paragraph("<b>Payment method</b>", body), Paragraph("AMEX ending 1009 (keyed)", body)],
            [Paragraph("<b>Transaction time</b>", body), Paragraph("July 30, 2026 at 12:28 PM", body)],
            [Paragraph("<b>Merchant phone</b>", body), Paragraph("(919) 279-8433", body)],
            [Paragraph("<b>Square receipt link</b>", body),
             Paragraph("https://squareup.com/receipts/pt/1UXRQNXoaStxEJBfFIH5NGwoE5FZY", muted)],
        ],
        colWidths=[2.1 * inch, 4.6 * inch],
    )
    details.setStyle(TableStyle([
        ("BOX", (0, 0), (-1, -1), 0.5, line),
        ("INNERGRID", (0, 0), (-1, -1), 0.4, line),
        ("LEFTPADDING", (0, 0), (-1, -1), 10),
        ("RIGHTPADDING", (0, 0), (-1, -1), 10),
        ("TOPPADDING", (0, 0), (-1, -1), 8),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 8),
    ]))
    story.extend([
        details,
        Spacer(1, 0.28 * inch),
        Paragraph(
            "Wes identified this receipt as work performed at 4121 Tensity Dr. "
            "The Square receipt does not describe the work or establish a destination worksheet, "
            "so category and spreadsheet placement remain subject to review.",
            body,
        ),
        Spacer(1, 0.14 * inch),
        Paragraph(
            "Source traceability: OfficeAssist Outlook message ending ACgMftuwAAAA== "
            "(duplicate transport evidence) and message ending ACgMftvAAAAA== "
            "(authoritative project instruction).",
            muted,
        ),
    ])
    doc.build(story)


if __name__ == "__main__":
    build_receipt()
    print(OUTPUT)
