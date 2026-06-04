from pathlib import Path
import argparse
from pypdf import PdfReader, PdfWriter


def unique_path(path: Path) -> Path:
    if not path.exists():
        return path
    stem = path.stem
    suffix = path.suffix
    counter = 2
    while True:
        candidate = path.with_name(f"{stem} ({counter}){suffix}")
        if not candidate.exists():
            return candidate
        counter += 1


def parse_pages(spec: str) -> list[int]:
    pages: list[int] = []
    for part in spec.split(","):
        part = part.strip()
        if not part:
            continue
        if "-" in part:
            start_s, end_s = part.split("-", 1)
            start = int(start_s)
            end = int(end_s)
            pages.extend(range(start, end + 1))
        else:
            pages.append(int(part))
    if not pages:
        raise ValueError("empty page specification")
    return pages


def main() -> int:
    parser = argparse.ArgumentParser(description="Split selected 1-based PDF pages into a new PDF.")
    parser.add_argument("source")
    parser.add_argument("--pages", required=True, help="1-based pages, e.g. 1 or 2-3 or 1,3,5")
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    source = Path(args.source)
    out = unique_path(Path(args.out))
    out.parent.mkdir(parents=True, exist_ok=True)

    reader = PdfReader(str(source))
    writer = PdfWriter()
    for page_num in parse_pages(args.pages):
        if page_num < 1 or page_num > len(reader.pages):
            raise ValueError(f"page {page_num} outside PDF page range")
        writer.add_page(reader.pages[page_num - 1])

    with out.open("wb") as handle:
        writer.write(handle)
    print(out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
