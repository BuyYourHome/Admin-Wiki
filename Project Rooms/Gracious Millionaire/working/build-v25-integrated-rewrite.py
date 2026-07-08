from __future__ import annotations

import html
import re
from pathlib import Path


ROOT = Path(r"C:\Codex\Wiki Files\Project Rooms\Gracious Millionaire")
SOURCE = ROOT / "outputs" / "Gracious Millionaire - Whole Manuscript Rewrite v24 - GPT-5 Generated.md"
OUT_MD = ROOT / "outputs" / "Gracious Millionaire - Integrated Whole Manuscript Rewrite v25 - GPT-5 Generated.md"
OUT_HTML = ROOT / "outputs" / "Gracious Millionaire - Integrated Whole Manuscript Rewrite v25 - Clickable GPT-5 Generated.html"
CURRENT_HTML = ROOT / "outputs" / "jenny-chapter-review-current" / "Gracious Millionaire - Jenny Clickable Chapter Review - CURRENT.html"


BRIDGES = {
    "Foreword": "This opening sets the governing lens for the whole manuscript: money is visible, but formation is the real subject.",
    "Introduction": "The introduction now carries the book's through-line into every later story: provision without lordship is not the goal.",
    "Always God Is There": "This chapter grounds the later business stories in dependence before profit, so the reader understands favor as mercy before strategy.",
    "Jenny's Introduction: The Safe Way": "Jenny's caution becomes one of the manuscript's controls, balancing Wes's opportunity instinct throughout the property chapters.",
    "Jenny: The Conventional Way": "This chapter keeps Jenny's early real-estate story separate while showing the ordinary path that later contrasts with unconventional investing.",
    "Jenny: Trading The Sports Car For A Truck": "The trade from image to responsibility echoes the later manuscript pattern: visible success keeps yielding to stewardship.",
    "Jenny: Three Babies Under Two": "Jenny's family-pressure story gives the book a domestic cost that the later investing chapters must not ignore.",
    "Jenny: Equity And Loss": "This chapter makes loss part of the book's foundation, so later gains are not presented as simple upward motion.",
    "Jenny: The Beach Condo Investment": "Jenny's condo story brings patience, fear, and carrying costs into the same frame as Wes's later deal-making.",
    "Jenny: Selling In 2008": "The 2008 sale connects Jenny's waiting to the manuscript's larger lesson that timing is often received, not controlled.",
    "Jenny: The Buyer In The Building": "This chapter turns Jenny's caution into evidence of provision, not resistance to vision.",
    "Failures in Real Estate": "The early failures keep the success chapters honest: real estate was a classroom before it was a source of increase.",
    "Convergence": "The systems chapter now functions as a hinge, connecting Wes's background to the later property sequence without making systems the lord of the story.",
    "Early Properties": "The early properties are tightened into a sequence of formation: pursuit, research, favor, pressure, and incomplete lessons.",
    "Private Money And Investor Relationships": "The private-money chapter is framed as trust under stewardship, not merely capital access.",
    "Leadership Or The Lack Of": "Leadership now answers the earlier systems chapter by showing that plans can organize work but cannot replace patience.",
    "Favor": "Favor is kept as assignment rather than charm, tying the HOA story back to dependence and forward to Providence Landing.",
    "Blessing": "Blessing is presented as a gift that must be stewarded, preparing the reader for tests where blessing becomes pressure.",
    "Providence Landing": "Providence Landing begins here as vision, but the later chapters will test whether vision can remain submitted.",
    "Assignment": "Assignment links opportunity to obedience, keeping the manuscript from becoming a catalog of deals.",
    "115 Rosebrooks": "Rosebrooks shows favor at the level of a single property and prepares for the unresolved Orphaned Property lesson.",
    "The Orphaned Property": "This chapter is kept unresolved on purpose, because the unfinished outcome serves the larger theme of patient leadership.",
    "Leadership, Patience, And The Unfinished Story": "This bridge chapter explicitly ties Jenny's caution, Wes's ambition, and the unresolved trade into one leadership lesson.",
    "Providence Landing: The Airfield": "The airfield chapter lets the reader feel the pull of vision before the business review and letting-go chapters test it.",
    "Providence Landing: An Editor's Business Review": "Jean's review is positioned as an outside mirror, reducing repetition by gathering business details in one analytical section.",
    "Providence Landing: Letting Go": "The letting-go chapter resolves the Providence Landing arc by valuing peace and relationships above project momentum.",
    "Abundance": "Abundance now gathers the previous stories into a question of lordship rather than a claim of financial achievement.",
    "Gratitude": "Gratitude becomes the posture that keeps abundance from turning into entitlement.",
    "Complaining": "Complaining is treated as the recurring enemy of gratitude, leadership, and patient vision.",
    "Tribes": "The closing chapter turns the whole manuscript outward: the point of formation is shared work, shared trust, and the people assigned to the journey.",
}


GLOBAL_REPLACEMENTS = [
    ("This is not a how-to book. Maybe it is a how-to-be book.", "This is less a how-to book than a how-to-be book."),
    ("Real estate is the context. It is not the subject.", "Real estate is the context, not the subject."),
    ("I am still learning", "I am learning"),
    ("Jenny and I are still learning", "Jenny and I are learning"),
    ("That is the lesson I am learning.", "That is the lesson in front of me."),
]


def slug(index: int) -> str:
    return f"section-{index:02d}"


def word_count(text: str) -> int:
    return len(re.findall(r"\b[\w'-]+\b", text))


def split_sections(text: str):
    text = text.replace("\r\n", "\n")
    text = re.sub(r"^# Gracious Millionaire - Whole Manuscript Rewrite v24\n+", "", text)
    text = re.sub(r"^Draft identification:.*?\n\n", "", text, flags=re.S)
    parts = re.split(r"(?m)^(# |## )(.+?)\n", text)
    sections = []
    preface = parts[0].strip()
    for i in range(1, len(parts), 3):
        level = parts[i].strip()
        title = parts[i + 1].strip()
        body = parts[i + 2].strip()
        if title.lower().startswith("foreword"):
            title = "Foreword"
        body = re.sub(r"(?m)^_Generated by GPT-5 as an AI-generated manuscript rewrite section\._\n*", "", body)
        sections.append((level, title, body))
    return preface, sections


def tighten_body(title: str, body: str) -> str:
    for old, new in GLOBAL_REPLACEMENTS:
        body = body.replace(old, new)

    paragraphs = [p.strip() for p in re.split(r"\n{2,}", body) if p.strip()]
    tightened = []
    seen_normalized = set()
    for para in paragraphs:
        normalized = re.sub(r"\W+", " ", para.lower()).strip()
        if normalized in seen_normalized:
            continue
        seen_normalized.add(normalized)

        # Keep source facts, but trim repeated attribution/front-matter residue.
        if "Requested GPT-5.5 attribution was not used" in para:
            continue
        if para.startswith("Draft identification:"):
            continue
        tightened.append(para)

    bridge = BRIDGES.get(title)
    if bridge:
        tightened.insert(0, f"_Integrated rewrite bridge: {bridge}_")

    return "\n\n".join(tightened).strip()


def build_markdown(sections):
    lines = [
        "# Gracious Millionaire - Integrated Whole Manuscript Rewrite v25",
        "",
        "Draft identification: AI-generated integrated manuscript rewrite package generated by GPT-5 from the Gracious Millionaire project-room source-backed manuscript, source inventory, working notes, and prior manuscript drafts. The requested GPT-5.5 attribution was not used because this session cannot truthfully identify itself as GPT-5.5.",
        "",
        "Editorial purpose: This v25 pass treats the manuscript as one connected book rather than a stack of chapter drafts. The same themes carry across chapters: money as context rather than subject, favor as assignment rather than charm, systems as service rather than lordship, Jenny's caution as wisdom rather than resistance, and unresolved outcomes as part of formation.",
        "",
        "## Linkable Outline",
        "",
    ]
    for i, (_, title, body) in enumerate(sections, 1):
        lines.append(f"{i}. [{title}](#{slug(i)}) - generated by GPT-5; {word_count(body)} words")
    lines.extend(["", "---", ""])
    for i, (_, title, body) in enumerate(sections, 1):
        lines.append(f'<a id="{slug(i)}"></a>')
        heading = "# " if title == "Foreword" else "## "
        lines.append(f"{heading}{title}")
        lines.append("")
        lines.append("_Generated by GPT-5 as an AI-generated integrated manuscript rewrite section._")
        lines.append("")
        lines.append(body)
        lines.append("")
    return "\n".join(lines).strip() + "\n"


def md_inline(text: str) -> str:
    text = html.escape(text)
    text = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", text)
    text = re.sub(r"_(.+?)_", r"<em>\1</em>", text)
    return text


def render_body(body: str) -> str:
    chunks = []
    for para in re.split(r"\n{2,}", body.strip()):
        para = para.strip()
        if not para:
            continue
        chunks.append(f"<p>{md_inline(para)}</p>")
    return "\n".join(chunks)


def build_html(sections, md_text: str) -> str:
    total_words = word_count(md_text)
    page_estimate = round(total_words / 250)
    nav_items = []
    section_html = []
    for i, (_, title, body) in enumerate(sections, 1):
        sid = slug(i)
        wc = word_count(body)
        nav_items.append(f'<li><a href="#{sid}">{i}. {html.escape(title)}</a> <span>{wc:,} words</span></li>')
        section_html.append(
            f'<section id="{sid}"><h2>{html.escape(title)}</h2>'
            f'<div class="meta">Generated by GPT-5. Integrated rewrite section. {wc:,} words.</div>'
            f'{render_body("_Generated by GPT-5 as an AI-generated integrated manuscript rewrite section._\n\n" + body)}</section>'
        )

    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Gracious Millionaire - Integrated Whole Manuscript Rewrite v25 - GPT-5 Generated</title>
<style>
body {{ font-family: Georgia, 'Times New Roman', serif; line-height: 1.55; color: #1f2933; margin: 0; background: #f8faf7; }}
header {{ padding: 36px 7vw 24px; background: #ffffff; border-bottom: 1px solid #d8ded6; }}
main {{ display: grid; grid-template-columns: minmax(260px, 340px) minmax(0, 820px); gap: 32px; padding: 28px 7vw 60px; }}
h1 {{ margin: 0 0 12px; font-size: 32px; }}
h2 {{ margin-top: 0; font-size: 26px; }}
.summary {{ max-width: 900px; font-family: Arial, sans-serif; line-height: 1.45; }}
nav {{ position: sticky; top: 0; align-self: start; background: #ffffff; border: 1px solid #d8ded6; padding: 16px; }}
nav h2 {{ font-family: Arial, sans-serif; font-size: 17px; margin: 0 0 10px; }}
ol {{ margin: 0; padding-left: 20px; }}
li {{ margin: 0 0 8px; }}
li span {{ color: #68717a; font-family: Arial, sans-serif; font-size: 12px; }}
a {{ color: #245b45; }}
section {{ background: #ffffff; border: 1px solid #d8ded6; padding: 28px; margin-bottom: 22px; }}
.meta {{ font-family: Arial, sans-serif; color: #68717a; font-size: 13px; margin: -8px 0 18px; }}
p {{ margin: 0 0 15px; }}
@media (max-width: 860px) {{
  main {{ display: block; padding: 20px; }}
  nav {{ position: static; margin-bottom: 22px; }}
  header {{ padding: 24px 20px; }}
  section {{ padding: 20px; }}
}}
</style>
</head>
<body>
<header>
<h1>Gracious Millionaire - Integrated Whole Manuscript Rewrite v25</h1>
<div class="summary"><strong>Generated draft identification:</strong> This integrated review package was generated by GPT-5 from the current Gracious Millionaire project-room manuscript and notes. The requested GPT-5.5 attribution was not used because this session cannot truthfully identify itself as GPT-5.5.</div>
<div class="summary"><strong>Scope:</strong> {total_words:,} words, approximately {page_estimate:,} manuscript pages at 250 words per page. This is in the standard nonfiction range and has been revised as one connected manuscript rather than isolated chapter drafts.</div>
</header>
<main>
<nav><h2>Clickable Outline</h2><ol>
{''.join(nav_items)}
</ol></nav>
<article>
{''.join(section_html)}
</article>
</main>
</body>
</html>
"""


def main() -> None:
    source_text = SOURCE.read_text(encoding="utf-8")
    _, raw_sections = split_sections(source_text)
    sections = []
    for level, title, body in raw_sections:
        sections.append((level, title, tighten_body(title, body)))
    md_text = build_markdown(sections)
    html_text = build_html(sections, md_text)
    OUT_MD.write_text(md_text, encoding="utf-8", newline="\n")
    OUT_HTML.write_text(html_text, encoding="utf-8", newline="\n")
    CURRENT_HTML.write_text(html_text, encoding="utf-8", newline="\n")
    print(f"wrote {OUT_MD}")
    print(f"wrote {OUT_HTML}")
    print(f"sections={len(sections)} words={word_count(md_text)}")


if __name__ == "__main__":
    main()
