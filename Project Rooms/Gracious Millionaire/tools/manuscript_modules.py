#!/usr/bin/env python
"""Build Gracious Millionaire clickable packets from modular chapter files.

This tool keeps manuscript editing efficient:

- split: create a manifest plus one Markdown file per chapter from a full
  manuscript baseline.
- build: compile the manifest and chapter files into one clickable HTML packet.

The chapter files are manuscript-state files for a mode. They are not factual
source material; original project-room sources remain the factual authority.
"""

from __future__ import annotations

import argparse
import base64
import html
import json
import mimetypes
import re
import shutil
from dataclasses import dataclass
from datetime import date
from pathlib import Path


WORD_RE = re.compile(r"\b[\w']+\b")
HEADING_RE = re.compile(r"^(#{1,6})\s+(.+?)\s*$")
IMAGE_RE = re.compile(r"^!\[(.*?)\]\((.*?)\)\s*$")


@dataclass
class Chapter:
    order: int
    title: str
    file: str
    status: str = "active"


def slugify(value: str) -> str:
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    value = value.strip("-")
    return value or "section"


def strip_markdown(value: str) -> str:
    value = re.sub(r"!\[[^\]]*\]\([^)]+\)", " ", value)
    value = re.sub(r"\[[^\]]+\]\([^)]+\)", " ", value)
    value = re.sub(r"[#*_`>~-]", " ", value)
    return value


def word_count(value: str) -> int:
    return len(WORD_RE.findall(strip_markdown(value)))


def parse_full_manuscript(path: Path) -> tuple[str, str | None, str, list[tuple[str, str]]]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    title = path.stem
    first_title_index = None
    for index, line in enumerate(lines):
        match = HEADING_RE.match(line)
        if match and len(match.group(1)) == 1:
            title = match.group(2).strip()
            first_title_index = index
            break

    section_starts: list[tuple[int, str]] = []
    for index, line in enumerate(lines):
        match = HEADING_RE.match(line)
        if not match:
            continue
        level = len(match.group(1))
        heading = match.group(2).strip()
        if index == first_title_index:
            continue
        if level == 1 or level == 2:
            section_starts.append((index, heading))

    if not section_starts:
        raise ValueError(f"No chapter headings found in {path}")

    preamble = "\n".join(lines[: section_starts[0][0]]).strip()
    cover = None
    for line in lines[: section_starts[0][0]]:
        image = IMAGE_RE.match(line.strip())
        if image:
            cover = image.group(2).strip()
            break

    chapters: list[tuple[str, str]] = []
    for idx, (start, heading) in enumerate(section_starts):
        end = section_starts[idx + 1][0] if idx + 1 < len(section_starts) else len(lines)
        body_lines = lines[start + 1 : end]
        body = f"# {heading}\n\n" + "\n".join(body_lines).strip() + "\n"
        chapters.append((heading, body.rstrip() + "\n"))

    return title, cover, preamble, chapters


def write_manifest(
    manifest_path: Path,
    *,
    title: str,
    mode: str,
    version: str,
    cover: str | None,
    baseline: str,
    chapters: list[Chapter],
) -> None:
    lines = [
        f"# {title} Manifest",
        "",
        f"- Title: {title}",
        f"- Mode: {mode}",
        f"- Version: {version}",
        "- HTML Output: ../Gracious Millionaire - Quick Mode.html",
        "- Markdown Export: optional",
        "- Source Authority: Original project-room source files, source inventory, factual notes, correction notes, style guide, and current Wes/Jenny direction.",
        f"- Baseline Note: {baseline}",
    ]
    if cover:
        lines.append(f"- Cover: {cover}")
    lines.extend(
        [
            "",
            "| Order | Title | File | Status |",
            "| --- | --- | --- | --- |",
        ]
    )
    for chapter in chapters:
        lines.append(f"| {chapter.order:02d} | {chapter.title} | {chapter.file} | {chapter.status} |")
    lines.append("")
    manifest_path.write_text("\n".join(lines), encoding="utf-8")


def split_command(args: argparse.Namespace) -> None:
    source = Path(args.source).resolve()
    mode_dir = Path(args.mode_dir).resolve()
    chapters_dir = mode_dir / "chapters"

    if chapters_dir.exists():
        if not args.force:
            raise SystemExit(f"{chapters_dir} already exists. Use --force to replace the chapter folder.")
        shutil.rmtree(chapters_dir)
    chapters_dir.mkdir(parents=True, exist_ok=True)

    title, cover, _preamble, parsed = parse_full_manuscript(source)
    manifest_chapters: list[Chapter] = []
    used_names: set[str] = set()

    for order, (chapter_title, body) in enumerate(parsed, start=1):
        slug = slugify(chapter_title)
        file_name = f"{order:02d}-{slug}.md"
        while file_name in used_names:
            file_name = f"{order:02d}-{slug}-{len(used_names) + 1}.md"
        used_names.add(file_name)
        (chapters_dir / file_name).write_text(body, encoding="utf-8")
        manifest_chapters.append(Chapter(order=order, title=chapter_title, file=f"chapters/{file_name}"))

    cover_value = args.cover if args.cover else cover
    write_manifest(
        mode_dir / "manifest.md",
        title=args.title or title,
        mode=args.mode,
        version=args.version,
        cover=cover_value,
        baseline=args.baseline,
        chapters=manifest_chapters,
    )
    print(f"Created {len(manifest_chapters)} chapter files and manifest: {mode_dir / 'manifest.md'}")


def parse_manifest(path: Path) -> tuple[dict[str, str], list[Chapter]]:
    metadata: dict[str, str] = {}
    chapters: list[Chapter] = []
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if line.startswith("- ") and ":" in line:
            key, value = line[2:].split(":", 1)
            metadata[key.strip().lower()] = value.strip()
            continue
        if not line.startswith("|"):
            continue
        cells = [cell.strip() for cell in line.strip("|").split("|")]
        if len(cells) != 4:
            continue
        if cells[0].lower() in {"order", "---"} or set(cells[0]) <= {"-"}:
            continue
        try:
            order = int(cells[0])
        except ValueError:
            continue
        chapters.append(Chapter(order=order, title=cells[1], file=cells[2], status=cells[3]))
    return metadata, chapters


def inline_markdown(value: str) -> str:
    escaped = html.escape(value)
    escaped = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", escaped)
    escaped = re.sub(r"\*(.+?)\*", r"<em>\1</em>", escaped)
    return escaped


def markdown_body_to_html(markdown: str, chapter_title: str) -> str:
    lines = markdown.splitlines()
    if lines and HEADING_RE.match(lines[0]):
        heading = HEADING_RE.match(lines[0])
        if heading and heading.group(2).strip() == chapter_title:
            lines = lines[1:]

    html_lines: list[str] = []
    paragraph: list[str] = []

    def flush_paragraph() -> None:
        if paragraph:
            html_lines.append(f"<p>{inline_markdown(' '.join(paragraph).strip())}</p>")
            paragraph.clear()

    for raw_line in lines:
        line = raw_line.rstrip()
        if not line.strip():
            flush_paragraph()
            continue

        image = IMAGE_RE.match(line.strip())
        if image:
            flush_paragraph()
            html_lines.append(
                f'<p><img src="{html.escape(image.group(2), quote=True)}" alt="{html.escape(image.group(1), quote=True)}"></p>'
            )
            continue

        heading = HEADING_RE.match(line)
        if heading:
            flush_paragraph()
            level = min(len(heading.group(1)) + 2, 6)
            html_lines.append(f"<h{level}>{inline_markdown(heading.group(2).strip())}</h{level}>")
            continue

        paragraph.append(line.strip())

    flush_paragraph()
    return "\n".join(html_lines)


def resolve_relative(base: Path, value: str) -> Path:
    candidate = Path(value)
    if candidate.is_absolute():
        return candidate
    return (base / candidate).resolve()


def image_data_uri(path: Path) -> str | None:
    if not path.exists() or not path.is_file():
        return None
    mime, _encoding = mimetypes.guess_type(str(path))
    if not mime:
        mime = "application/octet-stream"
    data = base64.b64encode(path.read_bytes()).decode("ascii")
    return f"data:{mime};base64,{data}"


def build_markdown(manifest_path: Path, metadata: dict[str, str], chapters: list[Chapter]) -> str:
    base = manifest_path.parent
    title = metadata.get("title", manifest_path.stem)
    cover = metadata.get("cover")
    parts = [f"# {title}", ""]
    if cover:
        parts.extend([f"![Gracious Millionaire book cover]({cover})", ""])
    if metadata.get("baseline note"):
        parts.extend([metadata["baseline note"], ""])
    for chapter in chapters:
        if chapter.status.lower() != "active":
            continue
        chapter_path = resolve_relative(base, chapter.file)
        parts.append(chapter_path.read_text(encoding="utf-8").strip())
        parts.append("")
    return "\n".join(parts).rstrip() + "\n"


def build_command(args: argparse.Namespace) -> None:
    manifest_path = Path(args.manifest).resolve()
    base = manifest_path.parent
    metadata, chapters = parse_manifest(manifest_path)
    active_chapters = [chapter for chapter in chapters if chapter.status.lower() == "active"]
    if not active_chapters:
        raise SystemExit(f"No active chapters found in {manifest_path}")

    title = metadata.get("title", manifest_path.stem)
    mode = metadata.get("mode", "")
    version = metadata.get("version", f"generated-{date.today().isoformat()}")
    cover = metadata.get("cover", "")
    baseline_note = metadata.get("baseline note", "")

    html_output = Path(args.html).resolve() if args.html else resolve_relative(base, metadata.get("html output", "../Gracious Millionaire - Quick Mode.html"))
    markdown_output = Path(args.markdown).resolve() if args.markdown else None

    sections: list[str] = []
    total_words = 0
    for chapter in active_chapters:
        chapter_path = resolve_relative(base, chapter.file)
        chapter_markdown = chapter_path.read_text(encoding="utf-8")
        total_words += word_count(chapter_markdown)
        section_id = f"section-{chapter.order:02d}"
        section_title = f"{chapter.order:02d}. {chapter.title}"
        body = markdown_body_to_html(chapter_markdown, chapter.title)
        sections.append(
            f'<section id="{section_id}">\n<h2>{html.escape(section_title)}</h2>\n{body}\n</section>'
        )

    approx_pages = max(1, round(total_words / 250))
    cover_html = ""
    if cover:
        cover_path = resolve_relative(base, cover)
        cover_src = image_data_uri(cover_path) or cover
        cover_html = f'<img class="cover" src="{html.escape(cover_src, quote=True)}" alt="Gracious Millionaire book cover">'

    outline = "\n".join(
        f'<li><a href="#section-{chapter.order:02d}">{html.escape(chapter.title)}</a></li>' for chapter in active_chapters
    )

    html_text = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{html.escape(title)} - {html.escape(version)}</title>
  <style>
    :root {{ color-scheme: light; }}
    body {{
      margin: 0;
      font-family: Georgia, "Times New Roman", serif;
      color: #1f2933;
      background: #f7f5ef;
      line-height: 1.62;
    }}
    .page {{
      max-width: 920px;
      margin: 0 auto;
      padding: 32px 22px 72px;
      background: #fffdf8;
      min-height: 100vh;
      box-shadow: 0 0 24px rgba(41, 34, 24, 0.08);
    }}
    .cover {{
      display: block;
      max-width: min(460px, 100%);
      height: auto;
      margin: 0 auto 26px;
    }}
    h1, h2, h3, h4 {{
      line-height: 1.2;
      font-family: Georgia, "Times New Roman", serif;
      color: #17202a;
    }}
    h1 {{ font-size: 2.2rem; margin: 0 0 8px; text-align: center; }}
    .meta {{ text-align: center; margin: 0 0 24px; color: #5f6c72; }}
    .note {{
      border-left: 4px solid #8a7355;
      padding: 10px 16px;
      margin: 20px 0 28px;
      background: #f4efe5;
      color: #3f382f;
    }}
    nav {{
      border-top: 1px solid #d8d1c2;
      border-bottom: 1px solid #d8d1c2;
      padding: 16px 0;
      margin: 24px 0 36px;
    }}
    nav h2 {{ margin-top: 0; }}
    nav ol {{ columns: 2; column-gap: 34px; padding-left: 24px; }}
    nav li {{ break-inside: avoid; margin: 0 0 7px; }}
    a {{ color: #735c34; }}
    section {{
      border-top: 1px solid #e4ddcf;
      padding-top: 28px;
      margin-top: 36px;
    }}
    section h2 {{ font-size: 1.55rem; }}
    p {{ margin: 0 0 1rem; }}
    img {{ max-width: 100%; height: auto; }}
    @media (max-width: 700px) {{
      .page {{ padding: 22px 16px 56px; }}
      h1 {{ font-size: 1.75rem; }}
      nav ol {{ columns: 1; }}
    }}
  </style>
</head>
<body>
  <main class="page">
    {cover_html}
    <h1>{html.escape(title)}</h1>
    <p class="meta">{html.escape(mode)} - {html.escape(version)} - {total_words:,} words, about {approx_pages:,} manuscript pages at 250 words per page.</p>
    <div class="note">{inline_markdown(baseline_note)}</div>
    <nav>
      <h2>Clickable Outline</h2>
      <ol>
        {outline}
      </ol>
    </nav>
    {''.join(sections)}
  </main>
</body>
</html>
"""
    html_output.write_text(html_text, encoding="utf-8")
    print(f"Wrote HTML packet: {html_output}")
    print(f"Active chapters: {len(active_chapters)}")
    print(f"Words: {total_words}")

    if markdown_output:
        markdown_output.write_text(build_markdown(manifest_path, metadata, active_chapters), encoding="utf-8")
        print(f"Wrote optional Markdown export: {markdown_output}")


def output_path_for_manifest(manifest_path: Path, metadata: dict[str, str], override: str | None = None) -> Path:
    if override:
        return Path(override).resolve()
    return resolve_relative(
        manifest_path.parent,
        metadata.get("html output", "../Gracious Millionaire - Quick Mode.html"),
    )


def validate_packet(manifest_path: Path, html_path: Path) -> dict[str, object]:
    metadata, chapters = parse_manifest(manifest_path)
    active = [chapter for chapter in chapters if chapter.status.lower() == "active"]
    packet = html_path.read_text(encoding="utf-8")

    missing_chapter_files = []
    missing_section_ids = []
    missing_outline_links = []
    for chapter in active:
        chapter_path = resolve_relative(manifest_path.parent, chapter.file)
        if not chapter_path.exists():
            missing_chapter_files.append(chapter.file)
        section_id = f"section-{chapter.order:02d}"
        if f'id="{section_id}"' not in packet:
            missing_section_ids.append(section_id)
        if f'href="#{section_id}"' not in packet:
            missing_outline_links.append(section_id)

    title = metadata.get("title", manifest_path.stem)
    version = metadata.get("version", "")
    problems = []
    if title not in packet:
        problems.append("manuscript title is missing from HTML")
    if version and version not in packet:
        problems.append("version identifier is missing from HTML")
    if '<img class="cover"' not in packet:
        problems.append("embedded cover is missing from HTML")
    if missing_chapter_files:
        problems.append(f"missing chapter files: {', '.join(missing_chapter_files)}")
    if missing_section_ids:
        problems.append(f"missing chapter sections: {', '.join(missing_section_ids)}")
    if missing_outline_links:
        problems.append(f"missing outline links: {', '.join(missing_outline_links)}")

    if problems:
        raise SystemExit("Packet validation failed: " + "; ".join(problems))

    return {
        "title": title,
        "mode": metadata.get("mode", ""),
        "version": version,
        "active_chapters": len(active),
        "html_output": str(html_path),
        "validated": True,
    }


def validate_command(args: argparse.Namespace) -> None:
    manifest_path = Path(args.manifest).resolve()
    metadata, _chapters = parse_manifest(manifest_path)
    html_path = output_path_for_manifest(manifest_path, metadata, args.html)
    print(json.dumps(validate_packet(manifest_path, html_path), indent=2))


def workflow_command(args: argparse.Namespace) -> None:
    manifest_path = Path(args.manifest).resolve()
    metadata, _chapters = parse_manifest(manifest_path)
    html_path = output_path_for_manifest(manifest_path, metadata, args.html)

    build_command(
        argparse.Namespace(
            manifest=str(manifest_path),
            html=str(html_path),
            markdown=args.markdown,
        )
    )
    summary = validate_packet(manifest_path, html_path)

    if args.current_packet:
        current_packet = Path(args.current_packet).resolve()
        current_packet.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(html_path, current_packet)
        summary["current_packet"] = str(current_packet)

    print(json.dumps(summary, indent=2))


def main() -> None:
    parser = argparse.ArgumentParser(description="Split and build modular Gracious Millionaire manuscripts.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    split = subparsers.add_parser("split", help="Split a full Markdown manuscript into chapter files and a manifest.")
    split.add_argument("--source", required=True)
    split.add_argument("--mode-dir", required=True)
    split.add_argument("--mode", required=True)
    split.add_argument("--title", required=True)
    split.add_argument("--version", required=True)
    split.add_argument("--baseline", required=True)
    split.add_argument("--cover")
    split.add_argument("--force", action="store_true")
    split.set_defaults(func=split_command)

    build = subparsers.add_parser("build", help="Build a clickable HTML packet from a manifest and chapter files.")
    build.add_argument("--manifest", required=True)
    build.add_argument("--html")
    build.add_argument("--markdown", help="Optional full Markdown export path.")
    build.set_defaults(func=build_command)

    validate = subparsers.add_parser("validate", help="Validate a compiled packet against its manifest.")
    validate.add_argument("--manifest", required=True)
    validate.add_argument("--html")
    validate.set_defaults(func=validate_command)

    workflow = subparsers.add_parser(
        "workflow",
        help="Build, validate, report statistics, and optionally refresh the stable current packet.",
    )
    workflow.add_argument("--manifest", required=True)
    workflow.add_argument("--html")
    workflow.add_argument("--markdown", help="Optional full Markdown export path.")
    workflow.add_argument("--current-packet")
    workflow.set_defaults(func=workflow_command)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
