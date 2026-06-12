from __future__ import annotations

import argparse
from contextlib import redirect_stdout
import io
import json
import statistics
import time
from datetime import datetime
from pathlib import Path

from build_cfd_drafts import WORKBOOK, get_docs_values, normalize_values
import format_buyer_acknowledgment_addendum
import format_contract_from_reference
import format_memo_from_prototype
import format_note_from_reference
import format_term_sheet
import make_attorney_review_copies


ROOT = Path(r"C:\Codex\Wiki Files\Project Rooms\Contract for Deed")
WORKING = ROOT / "working"
OUTPUT = ROOT / "output"
METRICS_ROOT = WORKING / "run-metrics"

GENERATION_STEPS = [
    ("load_docs_values", None),
    ("format_contract_from_reference.py", format_contract_from_reference.main),
    ("format_memo_from_prototype.py", format_memo_from_prototype.main),
    ("format_note_from_reference.py", format_note_from_reference.main),
    ("format_term_sheet.py", format_term_sheet.main),
    ("format_buyer_acknowledgment_addendum.py", format_buyer_acknowledgment_addendum.main),
    ("make_attorney_review_copies.py", make_attorney_review_copies.main),
]

EXPECTED_OUTPUTS = [
    OUTPUT / "320 Rose - Contract for Deed Agreement - DRAFT.docx",
    OUTPUT / "320 Rose - Memorandum of Contract for Deed - DRAFT.docx",
    OUTPUT / "320 Rose - Promissory Note for Contract for Deed - DRAFT.docx",
    OUTPUT / "320 Rose - Term Sheet - DRAFT.docx",
    OUTPUT / "320 Rose - Buyer Acknowledgment Addendum - DRAFT.docx",
    OUTPUT / "320 Rose - Contract for Deed Agreement - ATTORNEY REVIEW PACKAGE.docx",
    OUTPUT / "320 Rose - Memorandum of Contract for Deed - ATTORNEY REVIEW PACKAGE.docx",
    OUTPUT / "320 Rose - Promissory Note for Contract for Deed - ATTORNEY REVIEW PACKAGE.docx",
]


def output_status():
    status = []
    for path in EXPECTED_OUTPUTS:
        item = {
            "path": str(path),
            "exists": path.exists(),
            "size": path.stat().st_size if path.exists() else None,
            "modified": datetime.fromtimestamp(path.stat().st_mtime).isoformat(timespec="seconds")
            if path.exists()
            else None,
        }
        status.append(item)
    return status


def summarize(iterations):
    step_timings = {name: [] for name, _ in GENERATION_STEPS}
    for iteration in iterations:
        for step in iteration["steps"]:
            if step["status"] == "ok":
                step_timings.setdefault(step["step"], []).append(step["seconds"])

    summary = {
        "iteration_count_completed": len(iterations),
        "successful_iterations": sum(1 for item in iterations if not item["blockers"]),
        "failed_iterations": sum(1 for item in iterations if item["blockers"]),
        "total_seconds": round(sum(item["seconds"] for item in iterations), 3),
        "per_iteration_seconds": [item["seconds"] for item in iterations],
        "per_step_seconds": {},
        "blockers": [],
        "process_change_candidates": [],
    }
    if iterations:
        seconds = [item["seconds"] for item in iterations]
        summary.update(
            {
                "average_iteration_seconds": round(statistics.mean(seconds), 3),
                "median_iteration_seconds": round(statistics.median(seconds), 3),
                "min_iteration_seconds": round(min(seconds), 3),
                "max_iteration_seconds": round(max(seconds), 3),
            }
        )

    for step, values in step_timings.items():
        if values:
            summary["per_step_seconds"][step] = {
                "average": round(statistics.mean(values), 3),
                "median": round(statistics.median(values), 3),
                "min": round(min(values), 3),
                "max": round(max(values), 3),
                "total": round(sum(values), 3),
            }

    for item in iterations:
        summary["blockers"].extend(item["blockers"])

    if summary["successful_iterations"] == len(iterations):
        summary["blockers"].append(
            {
                "type": "none",
                "note": f"No blocking failures occurred during the {len(iterations)} orchestrated generator iterations.",
            }
        )

    if summary["per_step_seconds"]:
        slowest = sorted(
            summary["per_step_seconds"].items(),
            key=lambda item: item[1]["total"],
            reverse=True,
        )
        name, stats = slowest[0]
        summary["process_change_candidates"].append(
            f"Highest cumulative orchestrated step time was {name} at {stats['total']} seconds; inspect that builder first for further optimization."
        )
        summary["process_change_candidates"].append(
            "Next optimization target is a stable Docs label-location cache or manifest after Wes finishes spreadsheet layout changes."
        )

    return summary


def write_metrics(metrics_dir, run):
    metrics_dir.mkdir(parents=True, exist_ok=True)
    metrics_json = metrics_dir / "metrics.json"
    metrics_md = metrics_dir / "summary.md"
    metrics_json.write_text(json.dumps(run, indent=2, default=str), encoding="utf-8")

    summary = run["summary"]
    lines = [
        f"# CFD Orchestrated Generator Metrics - {run['run_id']}\n",
        "## Scope\n",
        "Ran the in-process CFD generator orchestrator. The orchestrator performs lock preflight, loads and normalizes `Docs` once per iteration, calls the document builders in-process, creates attorney-review copies, verifies expected outputs, and records timing metrics. Teams copy/version/archive, amortization, closing cover/checklist, email, SharePoint links, Git, and skill sync are not included.\n",
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
        if key in summary:
            lines.append(f"- {key}: {summary[key]}\n")
    lines.append("\n## Per Iteration Seconds\n")
    for item in run["iterations"]:
        lines.append(
            f"- Iteration {item['iteration']}: {item['seconds']} seconds; blockers: {len(item['blockers'])}\n"
        )
    lines.append("\n## Per Step Timing\n")
    for step, stats in summary["per_step_seconds"].items():
        lines.append(
            f"- {step}: avg {stats['average']}s, median {stats['median']}s, min {stats['min']}s, max {stats['max']}s, total {stats['total']}s\n"
        )
    lines.append("\n## Blockers\n")
    for blocker in summary["blockers"]:
        if blocker.get("type") == "none":
            lines.append(f"- None: {blocker['note']}\n")
        else:
            lines.append(f"- {blocker}\n")
    lines.append("\n## Process Change Candidates\n")
    for candidate in summary["process_change_candidates"]:
        lines.append(f"- {candidate}\n")
    metrics_md.write_text("".join(lines), encoding="utf-8")
    return metrics_json, metrics_md


def run_iteration(number):
    item = {
        "iteration": number,
        "started_at": datetime.now().isoformat(timespec="seconds"),
        "steps": [],
        "blockers": [],
    }
    start = time.perf_counter()
    x = None

    for step_name, function in GENERATION_STEPS:
        step_start = time.perf_counter()
        captured_stdout = io.StringIO()
        try:
            with redirect_stdout(captured_stdout):
                if step_name == "load_docs_values":
                    x = normalize_values(get_docs_values())
                elif step_name == "make_attorney_review_copies.py":
                    function()
                else:
                    function(x)
            status = "ok"
            error = None
        except Exception as exc:  # noqa: BLE001 - metrics should capture any builder failure.
            status = "error"
            error = repr(exc)
            item["blockers"].append(
                {"type": "step_failure", "step": step_name, "error": error}
            )
        item["steps"].append(
            {
                "step": step_name,
                "status": status,
                "seconds": round(time.perf_counter() - step_start, 3),
                "error": error,
                "stdout_tail": [
                    line
                    for line in captured_stdout.getvalue().splitlines()
                    if line.strip()
                ][-5:],
            }
        )
        if status != "ok":
            break

    item["seconds"] = round(time.perf_counter() - start, 3)
    item["finished_at"] = datetime.now().isoformat(timespec="seconds")
    item["expected_outputs_after"] = output_status()
    missing = [record["path"] for record in item["expected_outputs_after"] if not record["exists"]]
    if missing:
        item["blockers"].append({"type": "missing_output", "paths": missing})
    return item


def main():
    parser = argparse.ArgumentParser(description="Run the CFD generator sequence with one Docs load per iteration.")
    parser.add_argument("--iterations", type=int, default=1)
    parser.add_argument("--run-id", default=None)
    args = parser.parse_args()

    run_id = args.run_id or datetime.now().strftime("cfd-orchestrated-%Y%m%d-%H%M%S")
    metrics_dir = METRICS_ROOT / run_id
    lock_files = sorted(str(path) for path in OUTPUT.glob("~$*.docx"))
    run = {
        "run_id": run_id,
        "started_at": datetime.now().isoformat(timespec="seconds"),
        "project_room": str(ROOT),
        "workbook": str(WORKBOOK),
        "output": str(OUTPUT),
        "scope": "orchestrated generator-only",
        "preflight": {"output_lock_files": lock_files},
        "iterations": [],
    }
    if lock_files:
        run["blocked"] = True
        run["summary"] = {
            "iteration_count_completed": 0,
            "successful_iterations": 0,
            "failed_iterations": 0,
            "total_seconds": 0,
            "blockers": [{"type": "word_lock_files", "paths": lock_files}],
            "process_change_candidates": ["Close Word output documents before running CFD generation."],
            "per_step_seconds": {},
        }
    else:
        run["blocked"] = False
        for iteration in range(1, args.iterations + 1):
            run["iterations"].append(run_iteration(iteration))
        run["summary"] = summarize(run["iterations"])
    run["finished_at"] = datetime.now().isoformat(timespec="seconds")

    metrics_json, metrics_md = write_metrics(metrics_dir, run)
    print(metrics_json)
    print(metrics_md)
    print(json.dumps(run["summary"], indent=2, default=str))


if __name__ == "__main__":
    main()
