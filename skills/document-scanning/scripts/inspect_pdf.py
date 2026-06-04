from pathlib import Path
import sys
from pypdf import PdfReader


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: inspect_pdf.py <pdf_path>", file=sys.stderr)
        return 2

    path = Path(sys.argv[1])
    reader = PdfReader(str(path))
    print(f"path={path}")
    print(f"pages={len(reader.pages)}")
    for index, page in enumerate(reader.pages, start=1):
        text = page.extract_text() or ""
        images = len(getattr(page, "images", []))
        print(f"page={index}|text_chars={len(text)}|images={images}")
        if text.strip():
            print(text[:500].replace("\n", " | "))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
