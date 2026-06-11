from __future__ import annotations

import argparse
import json
import os
import shlex
from pathlib import Path
from urllib.parse import quote, urlsplit, urlunsplit


def decode_settings(path: Path) -> str:
    raw = path.read_bytes()
    if b"\x00" in raw[:200]:
        return raw.decode("utf-16le", errors="ignore")
    return raw.decode("utf-8", errors="ignore")


def split_value(line: str) -> list[str]:
    _, value = line.split("=", 1)
    return shlex.split(value.strip(), posix=True)


def normalize_guid(value: str) -> str:
    return value.strip("{}").replace("-", "").lower()


def encode_url_path(url: str) -> str:
    parts = urlsplit(url)
    return urlunsplit((parts.scheme, parts.netloc, quote(parts.path, safe="/%"), parts.query, parts.fragment))


def load_policy_namespaces(settings_dir: Path) -> dict[str, str]:
    namespaces: dict[str, str] = {}
    for policy in settings_dir.glob("ClientPolicy_*.ini"):
        parts = policy.stem.split("_")
        if len(parts) < 2:
            continue
        list_id = normalize_guid(parts[1])
        text = decode_settings(policy)
        for line in text.splitlines():
            if line.strip().lower().startswith("davurlnamespace"):
                _, value = line.split("=", 1)
                namespaces[list_id] = value.strip()
                break
    return namespaces


def load_sync_roots() -> list[dict[str, str]]:
    settings_root = Path(os.environ["LOCALAPPDATA"]) / "Microsoft" / "OneDrive" / "settings"
    roots: list[dict[str, str]] = []
    for business_dir in settings_root.glob("Business*"):
        policies = load_policy_namespaces(business_dir)
        scopes: dict[str, dict[str, str]] = {}
        folders: list[dict[str, str]] = []
        for ini in business_dir.glob("*.ini"):
            if ini.name.startswith("ClientPolicy"):
                continue
            text = decode_settings(ini)
            for line in text.splitlines():
                clean = line.strip()
                if clean.startswith("libraryScope"):
                    parts = split_value(clean)
                    if len(parts) >= 11:
                        scopes[parts[0]] = {
                            "scope_id": parts[1],
                            "site_title": parts[3],
                            "library_title": parts[4],
                            "site_url": parts[6],
                            "list_id": normalize_guid(parts[10]),
                            "dav_namespace": policies.get(normalize_guid(parts[10]), ""),
                        }
                elif clean.startswith("libraryFolder"):
                    parts = split_value(clean)
                    if len(parts) >= 7:
                        folders.append(
                            {
                                "scope_index": parts[1],
                                "scope_id": parts[2],
                                "local_root": parts[4],
                                "remote_folder": parts[6],
                            }
                        )
        for folder in folders:
            scope = scopes.get(folder["scope_index"])
            if not scope:
                continue
            dav_namespace = scope.get("dav_namespace") or f"{scope['site_url'].rstrip('/')}/Shared Documents/"
            roots.append({**scope, **folder, "dav_namespace": dav_namespace.rstrip("/") + "/"})
    roots.sort(key=lambda r: len(r["local_root"]), reverse=True)
    return roots


def teams_link_for_path(path: Path) -> dict[str, str]:
    resolved = path.resolve()
    for root in load_sync_roots():
        local_root = Path(root["local_root"]).resolve()
        try:
            relative = resolved.relative_to(local_root)
        except ValueError:
            continue
        remote_parts = [root["remote_folder"], *relative.parts]
        remote_path = "/".join(part for part in remote_parts if part)
        url = encode_url_path(root["dav_namespace"] + quote(remote_path.replace("\\", "/"), safe="/"))
        return {
            "local_path": str(resolved),
            "url": url,
            "site_title": root["site_title"],
            "library_title": root["library_title"],
            "sync_root": str(local_root),
            "remote_path": remote_path,
        }
    raise SystemExit(f"No OneDrive/Teams sync mapping found for: {resolved}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Convert local Teams-synced paths to SharePoint web links.")
    parser.add_argument("paths", nargs="+", help="Local Teams-synced file or folder paths.")
    parser.add_argument("--markdown", action="store_true", help="Print Markdown links.")
    parser.add_argument("--json", action="store_true", help="Print JSON records.")
    args = parser.parse_args()

    records = [teams_link_for_path(Path(p)) for p in args.paths]
    if args.json:
        print(json.dumps(records, indent=2))
    elif args.markdown:
        for record in records:
            label = Path(record["local_path"]).name
            print(f"- [{label}]({record['url']})")
    else:
        for record in records:
            print(f"{record['local_path']} -> {record['url']}")


if __name__ == "__main__":
    main()
