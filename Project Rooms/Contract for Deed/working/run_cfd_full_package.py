from __future__ import annotations

import argparse
from contextlib import redirect_stdout
import io
import json
import shutil
import statistics
import time
import zipfile
from datetime import datetime
from pathlib import Path

from package_delivery import PackageItem, deliver_package_items, verify_existing
from package_doc_footer import next_package_version, stamp_docx_files
import run_cfd_generation
from update_closing_document_header import update_doc


ROOT = Path(r"C:\Codex\Wiki Files\Project Rooms\Contract for Deed")
WORKING = ROOT / "working"
OUTPUT = ROOT / "output"
METRICS_ROOT = WORKING / "run-metrics"

DEFAULT_LIVE_WORKBOOK = Path(
    r"C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28_Project Management - 320 Rose Pl.xlsm"
)
DEFAULT_STAGED_WORKBOOK = (
    ROOT
    / "source"
    / "320 Rose project spreadsheet"
    / "28_Project Management - 320 Rose Pl.xlsm"
)
DEFAULT_TRANSACTION_FOLDER = ROOT / "transactions" / "320 Rose Pl - Ever Cardoza"
DEFAULT_TEAMS_ROOT = Path(
    r"C:\Users\wesbr\Buy Your Home\Buy Your Home - Property\28-SYH-320 Rose Pl"
    r"\Selling\Ever Cordoza\Contract Package"
)


def default_package_items(
    transaction_folder: Path,
    teams_root: Path,
    street_prefix: str,
    buyer_label: str,
    preserve_newer_cover_page: bool,
) -> list[PackageItem]:
    cover_source = (
        transaction_folder
        / "output"
        / "closing-checklist"
        / f"{street_prefix} - {buyer_label} - Closing Package Cover Page.docx"
    )
    return [
        PackageItem(
            "Contract for Deed Agreement",
            OUTPUT / "320 Rose - Contract for Deed Agreement - DRAFT.docx",
            teams_root / f"{street_prefix} - Contract for Deed Agreement - DRAFT.docx",
            teams_root / "Archive" / "Contract",
        ),
        PackageItem(
            "Memorandum of Contract for Deed",
            OUTPUT / "320 Rose - Memorandum of Contract for Deed - DRAFT.docx",
            teams_root / f"{street_prefix} - Memorandum of Contract for Deed - DRAFT.docx",
            teams_root / "Archive" / "Contract",
        ),
        PackageItem(
            "Promissory Note for Contract for Deed",
            OUTPUT / "320 Rose - Promissory Note for Contract for Deed - DRAFT.docx",
            teams_root / f"{street_prefix} - Promissory Note for Contract for Deed - DRAFT.docx",
            teams_root / "Archive" / "Contract",
        ),
        PackageItem(
            "Term Sheet",
            OUTPUT / "320 Rose - Term Sheet - DRAFT.docx",
            teams_root / f"{street_prefix} - Term Sheet - DRAFT.docx",
            teams_root / "Archive" / "Contract",
        ),
        PackageItem(
            "Buyer Acknowledgment Addendum",
            OUTPUT / "320 Rose - Buyer Acknowledgment Addendum - DRAFT.docx",
            teams_root / f"{street_prefix} - Buyer Acknowledgment Addendum - DRAFT.docx",
            teams_root / "Archive" / "Contract",
        ),
        PackageItem(
            "Contract for Deed Agreement - Attorney Review",
            OUTPUT / "320 Rose - Contract for Deed Agreement - ATTORNEY REVIEW PACKAGE.docx",
            teams_root / f"{street_prefix} - Contract for Deed Agreement - ATTORNEY REVIEW PACKAGE.docx",
            teams_root / "Archive" / "Contract",
        ),
        PackageItem(
            "Memorandum of Contract for Deed - Attorney Review",
            OUTPUT / "320 Rose - Memorandum of Contract for Deed - ATTORNEY REVIEW PACKAGE.docx",
            teams_root / f"{street_prefix} - Memorandum of Contract for Deed - ATTORNEY REVIEW PACKAGE.docx",
            teams_root / "Archive" / "Contract",
        ),
        PackageItem(
            "Promissory Note for Contract for Deed - Attorney Review",
            OUTPUT / "320 Rose - Promissory Note for Contract for Deed - ATTORNEY REVIEW PACKAGE.docx",
            teams_root / f"{street_prefix} - Promissory Note for Contract for Deed - ATTORNEY REVIEW PACKAGE.docx",
            teams_root / "Archive" / "Contract",
        ),
        PackageItem(
            "Attorney Review Package ZIP",
            OUTPUT / "320 Rose - Attorney Review Package.zip",
            teams_root / f"{street_prefix} - Attorney Review Package.zip",
            teams_root / "Archive" / "Attorney Review Package",
        ),
        PackageItem(
            "Closing Package Cover Page",
            cover_source,
            teams_root / f"{street_prefix} - {buyer_label} - Closing Package Cover Page.docx",
            teams_root / "Archive" / "Cover Letter",
            preserve_newer_target=preserve_newer_cover_page,
        ),
    ]


def summarize(iterations: list[dict]) -> dict:
    seconds = [iteration["seconds"] for iteration in iterations]
    steps: dict[str, list[float]] = {}
    for iteration in iterations:
        for step in iteration["steps"]:
            if step["status"] == "ok":
                steps.setdefault(step["step"], []).append(step["seconds"])
    summary = {
        "iteration_count_completed": len(iterations),
        "successful_iterations": sum(1 for item in iterations if not item["blockers"]),
        "failed_iterations": sum(1 for item in iterations if item["blockers"]),
        "total_seconds": round(sum(seconds), 3),
        "average_iteration_seconds": round(statistics.mean(seconds), 3) if seconds else None,
        "median_iteration_seconds": round(statistics.median(seconds), 3) if seconds else None,
        "min_iteration_seconds": round(min(seconds), 3) if seconds else None,
        "max_iteration_seconds": round(max(seconds), 3) if seconds else None,
        "per_step_seconds": {},
        "blockers": [blocker for item in iterations for blocker in item["blockers"]],
        "warnings": [warning for item in iterations for warning in item["warnings"]],
    }
    for step, values in steps.items():
        summary["per_step_seconds"][step] = {
            "total": round(sum(values), 3),
            "average": round(statistics.mean(values), 3),
            "median": round(statistics.median(values), 3),
            "min": round(min(values), 3),
            "max": round(max(values), 3),
        }
    return summary


def write_manifest(metrics_dir: Path, run: dict) -> tuple[Path, Path]:
    metrics_dir.mkdir(parents=True, exist_ok=True)
    json_path = metrics_dir / "manifest.json"
    md_path = metrics_dir / "summary.md"
    json_path.write_text(json.dumps(run, indent=2), encoding="utf-8")

    summary = run["summary"]
    lines = [
        f"# CFD Full Package Run - {run['run_id']}\n\n",
        "## Scope\n",
        f"{run['scope']}\n\n",
        "## Summary\n",
    ]
    for key in [
        "iteration_count_completed",
        "successful_iterations",
        "failed_iterations",
        "total_seconds",
        "average_iteration_seconds",
        "median_iteration_seconds",
        "min_iteration_seconds",
        "max_iteration_seconds",
    ]:
        lines.append(f"- {key}: {summary[key]}\n")
    lines.append("\n## Per Step Timing\n")
    for step, stats in summary["per_step_seconds"].items():
        lines.append(
            f"- {step}: avg {stats['average']}s, median {stats['median']}s, "
            f"min {stats['min']}s, max {stats['max']}s, total {stats['total']}s\n"
        )
    if summary["warnings"]:
        lines.append("\n## Warnings\n")
        for warning in summary["warnings"]:
            lines.append(f"- {warning}\n")
    if summary["blockers"]:
        lines.append("\n## Blockers\n")
        for blocker in summary["blockers"]:
            lines.append(f"- {blocker}\n")
    md_path.write_text("".join(lines), encoding="utf-8")
    return json_path, md_path


def timed_step(iteration: dict, name: str, function):
    started = time.perf_counter()
    try:
        data = function()
        status = "ok"
        error = None
    except Exception as exc:  # noqa: BLE001 - manifest should capture any workflow failure.
        data = None
        status = "error"
        error = repr(exc)
        iteration["blockers"].append({"type": "step_failure", "step": name, "error": error})
    iteration["steps"].append(
        {
            "step": name,
            "status": status,
            "seconds": round(time.perf_counter() - started, 3),
            "error": error,
            "data": data,
        }
    )
    if status != "ok":
        raise RuntimeError(error)
    return data


def run_iteration(number: int, args) -> dict:
    iteration = {
        "iteration": number,
        "started_at": datetime.now().isoformat(timespec="seconds"),
        "steps": [],
        "blockers": [],
        "warnings": [],
    }
    started = time.perf_counter()
    package_items = default_package_items(
        args.transaction_folder,
        args.teams_root,
        args.street_prefix,
        args.buyer_label,
        args.preserve_newer_cover_page,
    )
    package_version = {"value": None}
    amortization_pdf = args.teams_root / f"{args.street_prefix} - 12 Month Amortization Chart.pdf"
    verify_only = [args.teams_root / "Affidavits", amortization_pdf]

    try:
        def preflight():
            lock_files = [str(path) for path in sorted(OUTPUT.glob("~$*.docx"))]
            if args.teams_root.exists():
                lock_files.extend(str(path) for path in sorted(args.teams_root.rglob("~$*.docx")))
            missing = [
                str(path)
                for path in [args.live_workbook, args.staged_workbook.parent, args.teams_root]
                if not path.exists()
            ]
            if lock_files or missing:
                raise RuntimeError(json.dumps({"lock_files": lock_files, "missing": missing}))
            return {"lock_files": lock_files, "missing": missing}

        timed_step(iteration, "preflight_locks_and_paths", preflight)

        def determine_package_version():
            existing_targets = [
                item.target for item in package_items if item.target.suffix.lower() == ".docx"
            ]
            package_version["value"] = next_package_version(existing_targets)
            iteration["package_version"] = package_version["value"]
            return {"package_version": package_version["value"]}

        timed_step(iteration, "determine_package_footer_version", determine_package_version)

        def refresh_spreadsheet():
            shutil.copy2(args.live_workbook, args.staged_workbook)
            return {
                "source": str(args.live_workbook),
                "target": str(args.staged_workbook),
                "bytes": args.staged_workbook.stat().st_size,
            }

        timed_step(iteration, "refresh_staged_spreadsheet", refresh_spreadsheet)

        def generate_core_docs():
            captured = io.StringIO()
            with redirect_stdout(captured):
                result = run_cfd_generation.run_iteration(number)
            if result["blockers"]:
                raise RuntimeError(json.dumps(result["blockers"]))
            result["stdout_tail"] = [
                line for line in captured.getvalue().splitlines() if line.strip()
            ][-10:]
            return result

        if not args.skip_generation:
            timed_step(iteration, "generate_core_docs", generate_core_docs)

        def prepare_cover_page():
            cover_paths = [
                item.source for item in package_items if item.label == "Closing Package Cover Page"
            ]
            results = []
            clean_cover = (
                args.transaction_folder
                / "output"
                / "clean"
                / f"{args.street_prefix} - {args.buyer_label} - Closing Package Cover Page.docx"
            )
            cover_paths.append(clean_cover)
            for path in cover_paths:
                if not path.exists():
                    results.append({"path": str(path), "status": "missing"})
                    continue
                changed = update_doc(path)
                results.append({"path": str(path), "status": "updated" if changed else "already_current"})
            return results

        timed_step(iteration, "prepare_closing_cover_page", prepare_cover_page)

        def amortization_handoff():
            return {
                "teams_pdf": str(amortization_pdf),
                "exists": amortization_pdf.exists(),
                "note": "CFD verifies the Teams Amortization PDF written by the Amortization workflow. Amortization owns its PDF archive/versioning; CFD does not copy or overwrite it.",
            }

        timed_step(iteration, "verify_amortization_pdf_handoff", amortization_handoff)

        def stamp_package_footers():
            docx_sources = [
                item.source for item in package_items if item.source.suffix.lower() == ".docx"
            ]
            records = stamp_docx_files(docx_sources, package_version["value"])
            missing = [record for record in records if record["status"] == "missing"]
            if missing:
                raise RuntimeError(json.dumps(missing, indent=2))
            return records

        timed_step(iteration, "stamp_docx_package_footers", stamp_package_footers)

        def refresh_attorney_review_zip():
            zip_items = [item for item in package_items if item.label == "Attorney Review Package ZIP"]
            if not zip_items:
                return {"status": "not_configured"}
            target_zip = zip_items[0].source
            review_docs = [
                item.source
                for item in package_items
                if item.source.suffix.lower() == ".docx" and "Attorney Review" in item.label
            ]
            missing = [str(path) for path in review_docs if not path.exists()]
            if missing:
                raise RuntimeError(json.dumps({"missing_review_docs": missing}, indent=2))
            target_zip.parent.mkdir(parents=True, exist_ok=True)
            with zipfile.ZipFile(target_zip, "w", compression=zipfile.ZIP_DEFLATED) as archive:
                for path in review_docs:
                    archive.write(path, arcname=path.name)
            return {
                "path": str(target_zip),
                "bytes": target_zip.stat().st_size,
                "members": [path.name for path in review_docs],
            }

        timed_step(iteration, "refresh_attorney_review_zip", refresh_attorney_review_zip)

        def deliver_to_teams():
            records = deliver_package_items(package_items, args.teams_root)
            bad = [record for record in records if record["status"] in {"missing_source", "hash_mismatch"}]
            preserved = [record for record in records if record["status"] == "preserved_newer_target"]
            for record in preserved:
                iteration["warnings"].append(
                    f"{record['label']}: {record['note']} Source={record['source']} Target={record['target']}"
                )
            if bad:
                raise RuntimeError(json.dumps(bad, indent=2))
            return records

        timed_step(iteration, "archive_and_copy_teams_package_files", deliver_to_teams)

        def verify_package():
            targets = [item.target for item in package_items]
            records = verify_existing(targets + verify_only)
            missing = [record for record in records if not record["exists"]]
            if missing:
                raise RuntimeError(json.dumps(missing, indent=2))
            return records

        timed_step(iteration, "verify_teams_package_files", verify_package)
    except Exception:
        pass

    iteration["seconds"] = round(time.perf_counter() - started, 3)
    iteration["finished_at"] = datetime.now().isoformat(timespec="seconds")
    return iteration


def parse_args():
    parser = argparse.ArgumentParser(description="Run the CFD full production package workflow.")
    parser.add_argument("--iterations", type=int, default=1)
    parser.add_argument("--run-id", default=None)
    parser.add_argument("--live-workbook", type=Path, default=DEFAULT_LIVE_WORKBOOK)
    parser.add_argument("--staged-workbook", type=Path, default=DEFAULT_STAGED_WORKBOOK)
    parser.add_argument("--transaction-folder", type=Path, default=DEFAULT_TRANSACTION_FOLDER)
    parser.add_argument("--teams-root", type=Path, default=DEFAULT_TEAMS_ROOT)
    parser.add_argument("--street-prefix", default="320 Rose Pl")
    parser.add_argument("--buyer-label", default="Ever Cardoza")
    parser.add_argument("--skip-generation", action="store_true")
    parser.add_argument(
        "--overwrite-newer-cover-page",
        dest="preserve_newer_cover_page",
        action="store_false",
        help="Allow the project-room cover page to overwrite a newer active Teams cover page.",
    )
    parser.set_defaults(preserve_newer_cover_page=True)
    return parser.parse_args()


def main():
    args = parse_args()
    run_id = args.run_id or datetime.now().strftime("cfd-full-package-%Y%m%d-%H%M%S")
    run = {
        "run_id": run_id,
        "scope": "full production package: spreadsheet refresh, core generators, cover-page prep, Amortization-owned Teams PDF verification, CFD-created Teams archive/copy, and package verification; excludes email and SharePoint sharing-link creation",
        "started_at": datetime.now().isoformat(timespec="seconds"),
        "project_room": str(ROOT),
        "live_workbook": str(args.live_workbook),
        "staged_workbook": str(args.staged_workbook),
        "transaction_folder": str(args.transaction_folder),
        "teams_root": str(args.teams_root),
        "iterations": [],
    }
    for number in range(1, args.iterations + 1):
        result = run_iteration(number, args)
        run["iterations"].append(result)
        if result["blockers"]:
            break
    run["summary"] = summarize(run["iterations"])
    run["finished_at"] = datetime.now().isoformat(timespec="seconds")
    metrics_dir = METRICS_ROOT / run_id
    json_path, md_path = write_manifest(metrics_dir, run)
    print(json_path)
    print(md_path)
    print(json.dumps(run["summary"], indent=2))


if __name__ == "__main__":
    main()
