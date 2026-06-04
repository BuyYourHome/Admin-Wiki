import sys
from pathlib import Path

from docx import Document


REVIEW_MARKERS = ("ATTORNEY REVIEW NOTE:", "MANAGEMENT REVIEW NOTE:")


def strip_review_blocks(doc):
    for paragraph in list(doc.paragraphs):
        if any(marker in paragraph.text for marker in REVIEW_MARKERS):
            paragraph._element.getparent().remove(paragraph._element)


def main():
    if len(sys.argv) != 3:
        raise SystemExit("Usage: save_clean_template_from_review_doc.py SOURCE_DOCX TARGET_DOCX")
    source = Path(sys.argv[1])
    target = Path(sys.argv[2])
    doc = Document(str(source))
    strip_review_blocks(doc)
    target.parent.mkdir(parents=True, exist_ok=True)
    doc.save(target)
    print(target)


if __name__ == "__main__":
    main()
