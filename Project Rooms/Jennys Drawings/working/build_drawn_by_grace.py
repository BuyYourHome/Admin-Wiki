"""Shared manuscript content and formatting helpers.

Jenny's original drawings live only in Teams. This module intentionally
contains metadata and organization-only view links, not local image paths or
an embedded-image manuscript builder.
"""

from __future__ import annotations

import re
from pathlib import Path

from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.shared import Pt, RGBColor


ROOT = Path(r"C:\Codex\Wiki Files\Project Rooms\Jennys Drawings")
SOURCE = ROOT / "outputs" / "Drawn by Grace - Review Manuscript.md"

NAVY = "203748"
BLUE = "2E74B5"
DARK_BLUE = "1F4D78"
GOLD = "B08D3B"
MUTED = "666666"


# filename, title, caption metadata, organization-only Teams view link
PLATES = {
    "JD-001": ("JD-001-you-are-my-shield.jpg", "You are my Shield", "Genesis 15:1 | Drawing dated September 13, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQC44C7qzYYdQL53sII9XwwrAY7zGxm-g903v4vg6xTbwBw"),
    "JD-002": ("JD-002-you-are-the-god-who-sees.jpg", "You are the God who sees", "Genesis 16:13 | Drawing dated October 13, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQA2Wxn4h1OJR6OpMUZDptG5AXv4On6D7xjPn8h6QjKxW70"),
    "JD-003": ("JD-003-your-faith-needs-a-fight.jpg", "Your faith needs a fight", "Genesis 17:15-21 | Drawing dated February 13, 2018", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQCPjruTHp1cQLpt1V9OXt6KAQNgDXUSJQS7PW0VuyrOSZQ"),
    "JD-004": ("JD-004-grant-me-success-today.jpg", "O Lord, grant me success today", "Genesis 24:12 | Drawing date to be confirmed", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQBIDtcq3XlURYZmoV5dK6-7AVkMcWUOhSTTGa0lNVEUGu0"),
    "JD-005": ("JD-005-to-break-out-look-in.jpg", "To break out, you've got to look in", "Genesis 27:30-40 | Drawing dated March 15, 2018", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQApTt26nMEHSb_MTFleDjzpAcw1WVdql2Dpl6FM3ywcZsk"),
    "JD-006": ("JD-006-admit-you-are-broken.jpg", "You'll never be fixed until you admit you're broken", "Genesis 32:24-32 | Drawing dated June 14, 2018", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQDkaJebfv0SSIy2KfaXZOgRAS1cjB4Vy52o68ipu7D88vg"),
    "JD-007": ("JD-007-maker-has-naming-rights.jpg", "Only the Maker has naming rights; rename your sorrow", "Genesis 35:17-18 | Drawing dated March 9, 2018", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQCsvbhY-yNBR6XPGY6dekXKAXB5Pf8SovxS4fi9ggRngSg"),
    "JD-008": ("JD-008-prison-to-palace.jpg", "God's plan: prison to palace", "Genesis 41 | Drawing dated September 21, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQCrICMKHHADTKLOL9cDbP5GAfs8PwFOqfoDcOhI0e7bTOI"),
    "JD-009": ("JD-009-discover-the-source-in-the-stretch.jpg", "In the stretch, discover the source", "Exodus 4 | Drawing dated January 15, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQBlnbc0Sz9oRJotsX2vYo63ASY7kfl6gV2y3rdtsdYJ9Ow"),
    "JD-010": ("JD-010-past-is-a-guidepost.jpg", "The past is a guidepost to tomorrow", "Exodus 1-2 | Drawing dated September 19, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQBWcXOa-6WSSZ9gv19PCadjAVtY7nelo7O2aZeGNvoQ_3A"),
    "JD-011": ("JD-011-rescued.jpg", "Rescued", "Exodus 3:8 | Drawing dated October 5, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQBtuUqhjhCxS55N1GumuDzJAd2ujULd2xOgpVBHiMzYRpA"),
    "JD-012": ("JD-012-what-is-in-your-hands.jpg", "What has God put in your hands?", "Exodus 4:17 | Drawing dated November 1, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQB_hjJzXEPRS5nddBgXflcLAQke_nGijCDhSO1awHcz2xs"),
    "JD-013": ("JD-013-take-the-first-step.jpg", "God positions you; take the first step", "Exodus 23:20 | Drawing dated January 4, 2018", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQBnDuOf9LsNSrJL7jOyWZ7LARIrqzaYlzVhn5gqiWmCb-0"),
    "JD-014": ("JD-014-what-has-god-prepared.jpg", "Are you missing what God has prepared?", "Exodus 23:20-21 | Drawing dated January 3, 2018", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQAzSJLVT3ptQbi0uvCC2f4TARTTZgYD0XAdpizvfcnDDGk"),
    "JD-015": ("JD-015-talking-with-god.jpg", "Talking with God...or to Him?", "Exodus 25:22 | Drawing dated October 26, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQBQlGJ8fhhKTZwhDOa4oK0VAWdwopjeYpTyamSiAZEZW7I"),
    "JD-016": ("JD-016-what-limits-you.jpg", "What is limiting you?", "Numbers 13:33 | Drawing dated March 21, 2018", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQAobfsyrMqYTYCXLLJJ-TspAcaTrpQSwa8xmNcIxSrAmqE"),
    "JD-017": ("JD-017-guide-me.jpg", "Guide me", "Deuteronomy 1:21-30 | Drawing dated September 8, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQA4p2bF_WNrQKPw76hZACFtATNgsmms-uvVxOL1q3Dvz5Y"),
    "JD-018": ("JD-018-ingredients-not-cake.jpg", "Ingredients, not cake", "Deuteronomy 30:15 | Drawing dated November 30, 2017", "https://lifeisanadventure.sharepoint.com/:i:/s/SellYourHome/IQAJuQ7GbVdCS6wQUMrQ3gxCAYpj1XD7oC-7ovmlcO94GWY"),
}


def set_run_font(run, name="Calibri", size=None, color=None, bold=None, italic=None):
    run.font.name = name
    run._element.get_or_add_rPr().rFonts.set(qn("w:ascii"), name)
    run._element.get_or_add_rPr().rFonts.set(qn("w:hAnsi"), name)
    if size is not None:
        run.font.size = Pt(size)
    if color is not None:
        run.font.color.rgb = RGBColor.from_string(color)
    if bold is not None:
        run.bold = bold
    if italic is not None:
        run.italic = italic


def parse_markdown(path):
    text = path.read_text(encoding="utf-8")
    sections = []
    current = None
    for line in text.splitlines():
        if line.startswith("## "):
            if current:
                sections.append(current)
            current = {"heading": line[3:].strip(), "paragraphs": [], "plate": None}
        elif current is not None:
            plate = re.fullmatch(r"\[\[PLATE:(JD-\d{3})\]\]", line.strip())
            if plate:
                current["plate"] = plate.group(1)
            elif line.strip():
                current["paragraphs"].append(line.strip())
    if current:
        sections.append(current)
    return sections


def add_body_paragraph(doc, markdown_text):
    paragraph = doc.add_paragraph(style="Normal")
    paragraph.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    parts = re.split(r'(\*[^*]+\*|"[^"]+")', markdown_text)
    for part in parts:
        if not part:
            continue
        if part.startswith("*") and part.endswith("*"):
            paragraph.add_run(part[1:-1]).italic = True
        else:
            paragraph.add_run(part)
    return paragraph
