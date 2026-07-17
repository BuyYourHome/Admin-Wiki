from __future__ import annotations

import base64
import html
import re
from pathlib import Path

import build_drawn_by_grace as base


ROOT = Path(r"C:\Codex\Wiki Files\Project Rooms\Jennys Drawings")
OUTPUT = ROOT / "outputs" / "Drawn by Grace - Illustrated Manuscript.html"
COVER = (
    ROOT
    / "outputs"
    / "gracious-millionaire-cover-drawing"
    / "drawn-by-grace-cover-jenny-style-v2-email.jpg"
)
TEAMS_FOLDER_URL = (
    "https://lifeisanadventure.sharepoint.com/sites/SellYourHome/Shared%20Documents/"
    "Marketing/Gracious%20Millionaire%20-%20Drawn%20by%20Grace"
)


def inline_markup(value: str) -> str:
    """Escape source text and preserve the manuscript's simple emphasis markup."""
    escaped = html.escape(value, quote=True)
    return re.sub(r"\*([^*]+)\*", r"<em>\1</em>", escaped)


def section_slug(index: int) -> str:
    return f"section-{index:02d}"


def cover_data_uri() -> str:
    encoded = base64.b64encode(COVER.read_bytes()).decode("ascii")
    return f"data:image/jpeg;base64,{encoded}"


def build() -> None:
    parsed = base.parse_markdown(base.SOURCE)
    sections = parsed[1:]

    outline = []
    manuscript = []
    for index, section in enumerate(sections, start=1):
        anchor = section_slug(index)
        heading = inline_markup(section["heading"])
        outline.append(f'<li><a href="#{anchor}">{heading}</a></li>')

        paragraphs = "\n".join(
            f"<p>{inline_markup(paragraph)}</p>" for paragraph in section["paragraphs"]
        )
        manuscript.append(
            f'''<section class="chapter" id="{anchor}">
  <h2>{heading}</h2>
  {paragraphs}
  <p class="return"><a href="#outline">Back to clickable outline</a></p>
</section>'''
        )

        plate_id = section["plate"]
        if plate_id:
            filename, title, meta = base.PLATES[plate_id]
            image_url = f"{TEAMS_FOLDER_URL}/{filename}"
            manuscript.append(
                f'''<figure class="plate-page" id="plate-{plate_id.lower()}">
  <div class="frame">
    <img src="{html.escape(image_url, quote=True)}" alt="{html.escape(title, quote=True)} — original drawing by Jenny Browning" loading="eager">
  </div>
  <figcaption><strong>{html.escape(title)}</strong><span>{html.escape(meta)}</span></figcaption>
</figure>'''
            )

    document = f'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Drawn by Grace — Illustrated Manuscript</title>
<style>
  :root {{
    --ink: #24364b;
    --blue: #315d83;
    --paper: #fffdf8;
    --gold: #bd8a3a;
    --muted: #68717b;
  }}
  * {{ box-sizing: border-box; }}
  html {{ scroll-behavior: smooth; }}
  body {{
    margin: 0;
    color: var(--ink);
    background: #e9edf1;
    font: 18px/1.65 Georgia, "Times New Roman", serif;
  }}
  main {{
    width: min(8.5in, 100%);
    margin: 0 auto;
    background: var(--paper);
    box-shadow: 0 0 32px rgba(26, 39, 54, .16);
  }}
  .cover, .outline, .chapter {{ padding: .8in 1in; }}
  .cover {{
    min-height: 100vh;
    display: grid;
    place-items: center;
    background: #f4f0e8;
  }}
  .cover img {{
    display: block;
    width: min(5.7in, 100%);
    height: auto;
    box-shadow: 0 12px 35px rgba(26, 39, 54, .22);
  }}
  h1, h2 {{
    color: var(--blue);
    font-family: Calibri, Arial, sans-serif;
    line-height: 1.18;
  }}
  h1 {{ margin: 0 0 .25in; font-size: 2rem; }}
  h2 {{ margin: 0 0 .25in; font-size: 1.55rem; }}
  p {{ margin: 0 0 1.05em; }}
  a {{ color: #1f5f91; text-underline-offset: .15em; }}
  .outline {{ min-height: 100vh; }}
  .outline p {{ color: var(--muted); }}
  .outline ol {{ columns: 2; column-gap: .45in; padding-left: 1.4em; }}
  .outline li {{ break-inside: avoid; margin: 0 0 .45em; }}
  .chapter {{ min-height: 100vh; }}
  .return {{ margin-top: .35in; font: .86rem/1.4 Calibri, Arial, sans-serif; }}
  .plate-page {{
    min-height: 100vh;
    margin: 0;
    padding: .45in .5in .35in;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: .18in;
    background: #f8f3e9;
  }}
  .frame {{
    width: 100%;
    flex: 1 1 auto;
    min-height: 0;
    padding: .13in;
    display: flex;
    align-items: center;
    justify-content: center;
    background: white;
    border: 3px solid var(--gold);
    outline: 1px solid #6f5731;
    outline-offset: 5px;
    box-shadow: 0 10px 24px rgba(40, 37, 31, .18);
  }}
  .frame img {{
    display: block;
    max-width: 100%;
    max-height: calc(100vh - 1.6in);
    width: auto;
    height: auto;
    object-fit: contain;
  }}
  figcaption {{
    text-align: center;
    font: .88rem/1.35 Calibri, Arial, sans-serif;
    color: var(--ink);
  }}
  figcaption strong, figcaption span {{ display: block; }}
  figcaption span {{ color: var(--muted); font-size: .78rem; margin-top: .03in; }}
  @media (max-width: 650px) {{
    body {{ font-size: 16px; }}
    .cover, .outline, .chapter {{ padding: .45in .32in; }}
    .outline ol {{ columns: 1; }}
    .plate-page {{ padding: .3in .25in; }}
  }}
  @page {{ size: Letter; margin: .5in; }}
  @media print {{
    body, main {{ background: white; box-shadow: none; }}
    main {{ width: auto; }}
    .cover, .outline, .chapter {{
      min-height: 0;
      padding: 0;
      break-before: page;
    }}
    .cover {{
      height: 10in;
      break-before: auto;
      break-after: page;
      background: white;
    }}
    .outline {{ break-after: page; }}
    .chapter {{ break-after: page; }}
    .plate-page {{
      height: 10in;
      min-height: 10in;
      padding: .05in;
      gap: .12in;
      break-before: page;
      break-after: page;
      background: white;
    }}
    .frame {{ box-shadow: none; }}
    .frame img {{ max-height: 8.9in; }}
    .return {{ display: none; }}
    a {{ color: inherit; text-decoration: none; }}
  }}
</style>
</head>
<body>
<main>
  <section class="cover" aria-label="Cover">
    <img src="{cover_data_uri()}" alt="Drawn by Grace: A Visual Companion to The Gracious Millionaire — cover illustration">
  </section>
  <nav class="outline" id="outline" aria-labelledby="outline-title">
    <h1 id="outline-title">Clickable Outline</h1>
    <p>Select a heading to move directly to that part of the manuscript. Each drawing is displayed in full immediately after its matching section.</p>
    <ol>{''.join(outline)}</ol>
  </nav>
  {''.join(manuscript)}
</main>
</body>
</html>
'''
    OUTPUT.write_text(document, encoding="utf-8", newline="\n")
    print(OUTPUT)


if __name__ == "__main__":
    build()
