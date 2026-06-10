from pathlib import Path
import shutil

from docx import Document
from docx.enum.style import WD_STYLE_TYPE
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.text.paragraph import Paragraph
from docx.shared import Inches, Pt, RGBColor


PROJECT = Path(r"C:\Codex\Wiki Files\Project Rooms\Contract for Deed")
ENGLISH_CONTRACT = PROJECT / "output" / "320 Rose - Contract for Deed Agreement - DRAFT.docx"
BILINGUAL_CONTRACT = PROJECT / "output" / "v01 - 320 Rose - Contract for Deed Agreement - BILINGUAL SPANISH DRAFT.docx"
LEGACY_BILINGUAL_CONTRACT = PROJECT / "output" / "320 Rose - Contract for Deed Agreement - BILINGUAL SPANISH DRAFT.docx"
TEAMS_SPANISH = Path(
    r"C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28-SYH-320 Rose Pl"
    r"\Selling\Ever Cordoza\Contract Package\Spanish Package"
)

SPANISH_STYLE = "Spanish Translation Draft"
SPANISH_BLUE = RGBColor(0x00, 0x66, 0xCC)
VISUAL_RIGHT_SHIFT = Inches(0.18)
SPANISH_CONTROL_NOTICE = (
    "Prevalece la version en ingles: El texto en espanol de este borrador bilingue "
    "se proporciona solo como una traduccion preliminar de conveniencia. Si existe "
    "algun conflicto entre el texto en ingles y el texto en espanol, prevalece el "
    "texto en ingles. El texto en espanol no es una traduccion legal certificada "
    "salvo que sea aprobado por separado por Wes, un abogado o un traductor calificado."
)
CONTROL_NOTICE_PREFIXES = (
    "English Version Controls:",
    "Prevalece la version en ingles:",
)
PARAGRAPH_4_START = "ADDITIONAL CHARGES AND FEES:"
PARAGRAPH_4_END = "INTEREST RATE:"


def is_spanish_translation(paragraph):
    if paragraph.style and paragraph.style.name == SPANISH_STYLE:
        return True
    for run in paragraph.runs:
        color = run.font.color
        if color is not None and color.rgb == SPANISH_BLUE:
            return True
    return False


def paragraph_text(paragraph):
    return " ".join(paragraph.text.split())


def is_control_notice_text(text):
    normalized = text.strip()
    return any(normalized.startswith(prefix) for prefix in CONTROL_NOTICE_PREFIXES)


def build_translation_memory(path):
    doc = Document(str(path))
    memory = {}
    last_english = None
    for paragraph in doc.paragraphs:
        text = paragraph_text(paragraph)
        if not text:
            continue
        if is_control_notice_text(text):
            continue
        if is_spanish_translation(paragraph):
            if last_english:
                memory.setdefault(last_english, []).append(paragraph.text)
        else:
            last_english = text
    return memory


def ensure_spanish_style(doc):
    styles = doc.styles
    if SPANISH_STYLE in [style.name for style in styles]:
        style = styles[SPANISH_STYLE]
    else:
        style = styles.add_style(SPANISH_STYLE, WD_STYLE_TYPE.PARAGRAPH)
    style.font.name = "Arial"
    style.font.size = Pt(9)
    style.font.color.rgb = SPANISH_BLUE
    style.paragraph_format.left_indent = None
    style.paragraph_format.right_indent = None
    return style


def style_chain(paragraph):
    style = paragraph.style
    while style is not None:
        yield style
        style = style.base_style


def effective_alignment(paragraph):
    if paragraph.alignment is not None:
        return paragraph.alignment
    for style in style_chain(paragraph):
        alignment = style.paragraph_format.alignment
        if alignment is not None:
            return alignment
    return None


def effective_left_indent(paragraph):
    if paragraph.paragraph_format.left_indent is not None:
        return paragraph.paragraph_format.left_indent
    for style in style_chain(paragraph):
        left_indent = style.paragraph_format.left_indent
        if left_indent is not None:
            return left_indent
    return None


def insert_paragraph_after(insert_after, text, style, format_source):
    new_p = OxmlElement("w:p")
    insert_after._p.addnext(new_p)
    new_paragraph = Paragraph(new_p, insert_after._parent)
    new_paragraph.style = style
    new_paragraph.paragraph_format.first_line_indent = None
    new_paragraph.paragraph_format.right_indent = None
    if effective_alignment(format_source) == WD_ALIGN_PARAGRAPH.CENTER:
        new_paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
        new_paragraph.paragraph_format.left_indent = None
    else:
        base_left_indent = effective_left_indent(format_source) or 0
        new_paragraph.paragraph_format.left_indent = base_left_indent + VISUAL_RIGHT_SHIFT
    run = new_paragraph.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(9)
    run.font.color.rgb = SPANISH_BLUE
    return new_paragraph


def insert_control_notice_before(paragraph, style):
    new_p = OxmlElement("w:p")
    paragraph._p.addprevious(new_p)
    new_paragraph = Paragraph(new_p, paragraph._parent)
    new_paragraph.style = style
    new_paragraph.paragraph_format.left_indent = None
    new_paragraph.paragraph_format.right_indent = None
    new_paragraph.paragraph_format.first_line_indent = None
    run = new_paragraph.add_run(SPANISH_CONTROL_NOTICE)
    run.bold = True
    run.font.name = "Arial"
    run.font.size = Pt(12)
    run.font.color.rgb = SPANISH_BLUE
    return new_paragraph


def insert_control_notice_above_paragraph_2(doc, style):
    for paragraph in doc.paragraphs:
        text = paragraph.text.strip()
        if text.startswith("Sales Price:") or text.startswith("Purchase Price:"):
            insert_control_notice_before(paragraph, style)
            return True
    return False


def is_paragraph_4_start(text):
    return text.strip().startswith(PARAGRAPH_4_START)


def is_paragraph_4_end(text):
    return text.strip().startswith(PARAGRAPH_4_END)


def first_signature_index(doc):
    signature_markers = (
        "Signatures:",
        "PURCHASER:",
        "SELLER:",
        "STATE OF:",
        "COUNTY OF:",
        "Notary",
    )
    for idx, paragraph in enumerate(doc.paragraphs):
        text = paragraph.text.strip()
        if any(marker in text for marker in signature_markers):
            return idx
    return len(doc.paragraphs)


def main():
    if not ENGLISH_CONTRACT.exists():
        raise FileNotFoundError(ENGLISH_CONTRACT)
    memory_source = BILINGUAL_CONTRACT if BILINGUAL_CONTRACT.exists() else LEGACY_BILINGUAL_CONTRACT
    if not memory_source.exists():
        raise FileNotFoundError(
            "Existing bilingual draft is required as translation source: "
            f"{BILINGUAL_CONTRACT} or {LEGACY_BILINGUAL_CONTRACT}"
        )

    memory = build_translation_memory(memory_source)
    work_path = BILINGUAL_CONTRACT.with_suffix(".tmp.docx")
    shutil.copy2(ENGLISH_CONTRACT, work_path)

    doc = Document(str(work_path))
    style = ensure_spanish_style(doc)
    cutoff = first_signature_index(doc)
    inserted = 0
    missing = []

    original_paragraphs = list(doc.paragraphs[:cutoff])
    in_paragraph_4_table_area = False
    for paragraph in original_paragraphs:
        key = paragraph_text(paragraph)
        if not key:
            continue
        if is_paragraph_4_start(key):
            in_paragraph_4_table_area = True
            continue
        if in_paragraph_4_table_area:
            if is_paragraph_4_end(key):
                in_paragraph_4_table_area = False
            else:
                continue
        if is_control_notice_text(key):
            continue
        translations = memory.get(key)
        if not translations:
            missing.append(key)
            continue
        insert_after = paragraph
        for translation in translations:
            insert_after = insert_paragraph_after(insert_after, translation, style, paragraph)
            inserted += 1

    if not insert_control_notice_above_paragraph_2(doc, style):
        raise RuntimeError("Could not find paragraph 2/Sales Price location for Spanish control notice.")

    doc.save(str(work_path))
    work_path.replace(BILINGUAL_CONTRACT)

    TEAMS_SPANISH.mkdir(parents=True, exist_ok=True)
    teams_copy = TEAMS_SPANISH / BILINGUAL_CONTRACT.name
    teams_status = "copied"
    try:
        shutil.copy2(BILINGUAL_CONTRACT, teams_copy)
    except PermissionError as exc:
        teams_status = f"blocked: {exc}"

    print(BILINGUAL_CONTRACT)
    print(teams_copy)
    print(f"Teams copy status: {teams_status}")
    print(f"Inserted Spanish/control paragraphs: {inserted}")
    if missing:
        print(f"English paragraphs without Spanish memory: {len(missing)}")
        for item in missing[:10]:
            print(f"- {item[:160]}")


if __name__ == "__main__":
    main()
