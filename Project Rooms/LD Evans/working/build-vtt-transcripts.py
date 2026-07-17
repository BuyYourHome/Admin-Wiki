from __future__ import annotations

import html
import re
from pathlib import Path


ROOM = Path(r"C:\Codex\Wiki Files\Project Rooms\LD Evans")
CAPTION_DIR = ROOM / "sources" / "video" / "leaving-home" / "video"
OUTPUT_DIR = ROOM / "working" / "transcripts"

TIMESTAMP_RE = re.compile(
    r"^(?P<start>\d{2}:\d{2}:\d{2}\.\d{3}) --> (?P<end>\d{2}:\d{2}:\d{2}\.\d{3})"
)
TAG_RE = re.compile(r"<[^>]+>")
SPACE_RE = re.compile(r"\s+")


def seconds(value: str) -> float:
    hours, minutes, remainder = value.split(":")
    return int(hours) * 3600 + int(minutes) * 60 + float(remainder)


def clean_caption(lines: list[str]) -> str:
    text = " ".join(lines)
    text = TAG_RE.sub("", text)
    text = html.unescape(text)
    return SPACE_RE.sub(" ", text).strip()


def parse_cues(path: Path) -> list[tuple[float, str]]:
    lines = path.read_text(encoding="utf-8-sig").splitlines()
    cues: list[tuple[float, str]] = []
    index = 0
    while index < len(lines):
        match = TIMESTAMP_RE.match(lines[index])
        if not match:
            index += 1
            continue
        start = seconds(match.group("start"))
        index += 1
        cue_lines: list[str] = []
        while index < len(lines) and lines[index].strip():
            cue_lines.append(lines[index])
            index += 1
        text = clean_caption(cue_lines)
        if text:
            cues.append((start, text))
    return cues


def merge_cues(cues: list[tuple[float, str]]) -> list[tuple[float, str]]:
    merged: list[tuple[float, str]] = []
    for start, phrase in cues:
        words = phrase.split()
        existing_words = [word for _, word in merged]
        max_overlap = min(len(existing_words), len(words))
        overlap = 0
        for size in range(max_overlap, 0, -1):
            left = [word.casefold() for word in existing_words[-size:]]
            right = [word.casefold() for word in words[:size]]
            if left == right:
                overlap = size
                break
        for word in words[overlap:]:
            merged.append((start, word))
    return merged


def clock(total_seconds: int) -> str:
    minutes, secs = divmod(total_seconds, 60)
    return f"{minutes:02d}:{secs:02d}"


def render(path: Path, words: list[tuple[float, str]]) -> str:
    video_id = re.search(r"\[([^\]]+)\]", path.stem)
    title = re.sub(r"\s*\[[^\]]+\]\.en-orig$", "", path.stem)
    output = [
        f"# Working Transcript - {title}",
        "",
        f"Source caption: `{path.name}`",
        f"YouTube id: `{video_id.group(1) if video_id else 'unknown'}`",
        "",
        "> Machine-generated working transcript reconstructed from YouTube's rolling captions. "
        "Verify names, dates, quotations, and unclear wording against the recording before publication.",
        "",
    ]

    buckets: dict[int, list[str]] = {}
    for timestamp, word in words:
        bucket = int(timestamp // 60)
        buckets.setdefault(bucket, []).append(word)

    for bucket, bucket_words in sorted(buckets.items()):
        start = bucket * 60
        end = start + 60
        output.extend(
            [
                f"## {clock(start)}-{clock(end)}",
                "",
                " ".join(bucket_words),
                "",
            ]
        )
    return "\n".join(output).rstrip() + "\n"


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    caption_paths = sorted(CAPTION_DIR.glob("*.en-orig.vtt"))
    if len(caption_paths) != 4:
        raise RuntimeError(f"Expected four caption files, found {len(caption_paths)}")
    for caption_path in caption_paths:
        words = merge_cues(parse_cues(caption_path))
        output_name = re.sub(r"[^A-Za-z0-9]+", "-", caption_path.stem).strip("-").lower()
        output_path = OUTPUT_DIR / f"{output_name}.md"
        output_path.write_text(render(caption_path, words), encoding="utf-8")
        print(f"{output_path}: {len(words)} words")


if __name__ == "__main__":
    main()
