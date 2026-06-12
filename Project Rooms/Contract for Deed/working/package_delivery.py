from __future__ import annotations

import re
import shutil
from dataclasses import dataclass
from datetime import datetime
from hashlib import sha256
from pathlib import Path


@dataclass(frozen=True)
class PackageItem:
    label: str
    source: Path
    target: Path
    archive_dir: Path
    archive_existing: bool = True
    preserve_newer_target: bool = False


def ensure_inside(child: Path, parent: Path) -> None:
    child_resolved = child.resolve()
    parent_resolved = parent.resolve()
    if child_resolved != parent_resolved and parent_resolved not in child_resolved.parents:
        raise RuntimeError(
            f"Unsafe path outside expected tree: {child_resolved} not under {parent_resolved}"
        )


def file_hash(path: Path) -> str:
    digest = sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def next_archive_path(target: Path, archive_dir: Path) -> Path:
    archive_dir.mkdir(parents=True, exist_ok=True)
    max_seen = 0
    pattern = re.compile(r"^v(\d+) - " + re.escape(target.name) + r"$")
    for existing in archive_dir.glob(f"v* - {target.name}"):
        match = pattern.match(existing.name)
        if match:
            max_seen = max(max_seen, int(match.group(1)))
    version = max_seen + 1
    while True:
        candidate = archive_dir / f"v{version:02d} - {target.name}"
        if not candidate.exists():
            return candidate
        version += 1


def describe_path(path: Path) -> dict:
    if not path.exists():
        return {"path": str(path), "exists": False}
    return {
        "path": str(path),
        "exists": True,
        "bytes": path.stat().st_size,
        "modified": datetime.fromtimestamp(path.stat().st_mtime).isoformat(timespec="seconds"),
    }


def deliver_package_item(item: PackageItem, allowed_root: Path) -> dict:
    record = {
        "label": item.label,
        "source": str(item.source),
        "target": str(item.target),
        "archive_dir": str(item.archive_dir),
        "archived_to": None,
        "status": None,
        "note": None,
    }
    if not item.source.exists():
        record["status"] = "missing_source"
        return record

    ensure_inside(item.target, allowed_root)
    ensure_inside(item.archive_dir, allowed_root)
    item.target.parent.mkdir(parents=True, exist_ok=True)

    if (
        item.preserve_newer_target
        and item.target.exists()
        and item.target.stat().st_mtime > item.source.stat().st_mtime
    ):
        record["status"] = "preserved_newer_target"
        record["note"] = "Target is newer than source; left active Teams copy untouched."
        return record

    if item.archive_existing and item.target.exists():
        archive_path = next_archive_path(item.target, item.archive_dir)
        ensure_inside(archive_path, allowed_root)
        shutil.move(str(item.target), str(archive_path))
        record["archived_to"] = str(archive_path)

    shutil.copy2(item.source, item.target)
    record["bytes"] = item.target.stat().st_size
    record["status"] = (
        "ok" if file_hash(item.source) == file_hash(item.target) else "hash_mismatch"
    )
    return record


def deliver_package_items(items: list[PackageItem], allowed_root: Path) -> list[dict]:
    return [deliver_package_item(item, allowed_root) for item in items]


def verify_existing(paths: list[Path]) -> list[dict]:
    return [describe_path(path) for path in paths]
