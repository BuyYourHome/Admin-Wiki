from __future__ import annotations

import html
import re
from pathlib import Path


ROOM = Path(r"C:\Codex\Wiki Files\Project Rooms\LD Evans")
SOURCE = ROOM / "outputs" / "LD Evans Manuscript - Working Draft.md"
OUTPUT = ROOM / "outputs" / "LD Evans Manuscript - Working Draft.html"


def inline_markup(text: str) -> str:
    escaped = html.escape(text, quote=False)
    return re.sub(r"`([^`]+)`", r"<code>\1</code>", escaped)


def slug(text: str, used: set[str]) -> str:
    value = re.sub(r"[^a-z0-9]+", "-", text.casefold()).strip("-") or "section"
    candidate = value
    counter = 2
    while candidate in used:
        candidate = f"{value}-{counter}"
        counter += 1
    used.add(candidate)
    return candidate


def markdown_body(source: str) -> str:
    lines = source.splitlines()
    output: list[str] = []
    paragraph: list[str] = []
    list_items: list[str] = []
    used_ids: set[str] = set()

    def flush_paragraph() -> None:
        if paragraph:
            output.append(f"<p>{inline_markup(' '.join(paragraph))}</p>")
            paragraph.clear()

    def flush_list() -> None:
        if list_items:
            output.append("<ul>")
            output.extend(f"<li>{inline_markup(item)}</li>" for item in list_items)
            output.append("</ul>")
            list_items.clear()

    for line in lines:
        stripped = line.strip()
        if not stripped:
            flush_paragraph()
            flush_list()
            continue
        if stripped == "---":
            flush_paragraph()
            flush_list()
            output.append('<hr class="chapter-break">')
            continue
        heading = re.match(r"^(#{1,6})\s+(.+)$", stripped)
        if heading:
            flush_paragraph()
            flush_list()
            level = len(heading.group(1))
            label = heading.group(2)
            output.append(
                f'<h{level} id="{slug(label, used_ids)}">{inline_markup(label)}</h{level}>'
            )
            continue
        if stripped.startswith("> "):
            flush_paragraph()
            flush_list()
            output.append(f"<blockquote>{inline_markup(stripped[2:])}</blockquote>")
            continue
        if stripped.startswith("- "):
            flush_paragraph()
            list_items.append(stripped[2:])
            continue
        flush_list()
        paragraph.append(stripped)

    flush_paragraph()
    flush_list()
    return "\n".join(output)


def build_document(body: str) -> str:
    return f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Leaving Home — The Story of L.D. Evans</title>
  <style>
    :root {{ color-scheme: light; }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      background: #f2efe8;
      color: #211f1b;
      font-family: Georgia, "Times New Roman", serif;
      font-size: 18px;
      line-height: 1.72;
    }}
    main {{
      width: min(820px, calc(100% - 32px));
      margin: 40px auto;
      padding: 64px 72px;
      background: #fffdf8;
      border: 1px solid #d9d1c2;
      box-shadow: 0 12px 35px rgba(45, 37, 25, 0.12);
    }}
    h1, h2 {{ text-align: center; color: #3f301f; }}
    h1 {{ margin: 0 0 0.35em; font-size: 2.35rem; letter-spacing: 0.02em; }}
    h2 {{ margin: 0 0 2.2em; font-size: 1.35rem; font-weight: normal; font-style: italic; }}
    h1:not(:first-child) {{ margin-top: 1.8em; page-break-before: always; }}
    p {{ margin: 0 0 1.15em; }}
    blockquote {{
      margin: 2em 0;
      padding: 1em 1.25em;
      border-left: 4px solid #9a774d;
      background: #f7f1e8;
      color: #51483d;
      font-size: 0.94em;
    }}
    ul {{ margin: 1em 0 1.5em 1.25em; padding: 0; }}
    li {{ margin-bottom: 0.6em; }}
    code {{ font-family: Consolas, monospace; font-size: 0.88em; }}
    .chapter-break {{ border: 0; border-top: 1px solid #c9b99f; margin: 3em auto; width: 42%; }}
    @media (max-width: 680px) {{
      body {{ font-size: 17px; }}
      main {{ margin: 0; width: 100%; padding: 32px 24px; border: 0; box-shadow: none; }}
    }}
    @media print {{
      body {{ background: white; font-size: 12pt; }}
      main {{ width: auto; margin: 0; padding: 0; border: 0; box-shadow: none; }}
      blockquote {{ break-inside: avoid; }}
    }}
  </style>
</head>
<body>
  <main>
{body}
  </main>
</body>
</html>
"""


def main() -> None:
    source = SOURCE.read_text(encoding="utf-8")
    document = build_document(markdown_body(source))
    OUTPUT.write_text(document, encoding="utf-8")
    print(f"Created {OUTPUT} ({OUTPUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
