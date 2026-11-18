import copy
import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

from pypdf import PdfReader

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location(
    "invoice_generator", Path(__file__).with_name("create-project-cost-allocation-report.py")
)
generator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generator)


class DailyStatementTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="ie-statement-test-")
        self.addCleanup(self.tmp.cleanup)
        self.data = {
            "issuer": "Josh Kennedy LLC", "contact_email": "invoice@example.test",
            "invoice_no": "FIXTURE-001", "invoice_date": "2026-01-15",
            "period": "2026-01-01 to 2026-01-15", "status": "APPROVED BY WES",
            "invoice_total": 100,
            "lines": [
                {"date": "01/02/26", "project": "Alpha", "description": "Install fixture", "hours": 1, "minutes": 60, "allocated_cost": 20},
                {"date": "01/01/26", "project": "Alpha", "description": "Prepare surfaces", "hours": 3.5, "minutes": 210, "allocated_cost": 50},
                {"date": "01/01/26", "project": "Beta", "description": "Inspect work", "hours": 2, "minutes": 120, "allocated_cost": 30},
            ],
            "allocation_summary": [
                {"project": "Alpha", "hours": 4.5, "allocated_cost": 70},
                {"project": "Beta", "hours": 2, "allocated_cost": 30},
            ],
            "task_history": {
                "period_start": "2026-01-01", "period_end": "2026-01-15",
                "coverage": "Verified fixture history through period end.",
                "task_groups": [
                    {"id": "alpha", "project": "Alpha", "name": "Fixture work"},
                    {"id": "beta", "project": "Beta", "name": "Inspection"},
                ],
                "earlier_lines": [],
            },
        }
        for line in self.data["lines"]:
            line["task_group"] = line["project"].lower()

    def render(self, data=None):
        path = Path(self.tmp.name) / "invoice.pdf"
        generator.build_invoice(data or self.data, path)
        return [page.extract_text() for page in PdfReader(path).pages]

    def test_statement_follows_invoice_and_reconciles_daily_tasks(self):
        pages = self.render()
        self.assertEqual(3, len(pages))
        self.assertIn("APPROVED BY WES", pages[0])
        self.assertIn("$100.00", pages[0])
        self.assertNotIn("Supporting Time Statement", pages[0])
        self.assertIn("Supporting Time Statement", pages[1])
        self.assertIn("Daily total - 01/01/2026", pages[1])
        self.assertIn("5h30m", pages[1])
        self.assertIn("6h30m", pages[1])
        self.assertLess(pages[1].index("Prepare surfaces"), pages[1].index("Install fixture"))
        for task in ("Install fixture", "Prepare surfaces", "Inspect work"):
            self.assertEqual(1, pages[1].count(task))

    def test_statement_rejects_time_disagreement(self):
        data = copy.deepcopy(self.data)
        data["lines"][0]["minutes"] = 30
        with self.assertRaisesRegex(ValueError, "minutes disagree"):
            self.render(data)

    def test_statement_rejects_allocation_hour_disagreement(self):
        data = copy.deepcopy(self.data)
        data["allocation_summary"][0]["hours"] = 9
        with self.assertRaisesRegex(ValueError, "hours disagree"):
            self.render(data)

    def test_review_notes_follow_statement(self):
        data = copy.deepcopy(self.data)
        data["review_notes"] = ["Retain the uncertain end time for review."]
        pages = self.render(data)
        self.assertEqual(4, len(pages))
        self.assertIn("Supporting Time Statement", pages[1])
        self.assertIn("uncertain end time", pages[3])

    def historical_line(self):
        return {"date": "2025-12-20", "project": "Alpha", "description": "Earlier combined fixture work", "task_group": "alpha", "hours": 2, "minutes": 120, "source_line_id": "fixture-prior-1", "source_reference": "verified-fixture", "relationship": "combined"}

    def test_earlier_time_is_separate_and_does_not_change_invoice(self):
        data = copy.deepcopy(self.data)
        data["task_history"]["earlier_lines"] = [self.historical_line()]
        pages = self.render(data)
        self.assertIn("$100.00", pages[0])
        self.assertIn("6h30m", pages[1])
        self.assertIn("Earlier Recorded Task Summary", pages[2])
        self.assertIn("2h00m", pages[2])
        self.assertIn("adds no hours or charges", pages[2])
        self.assertIn("Earlier combined fixture work", pages[3])

    def test_overlap_or_later_time_is_rejected(self):
        for date in ("2026-01-01", "2026-01-16"):
            data = copy.deepcopy(self.data)
            line = self.historical_line()
            line["date"] = date
            data["task_history"]["earlier_lines"] = [line]
            with self.assertRaisesRegex(ValueError, "overlaps or follows"):
                self.render(data)

    def test_duplicate_historical_interval_is_rejected(self):
        data = copy.deepcopy(self.data)
        data["task_history"]["earlier_lines"] = [self.historical_line(), self.historical_line()]
        with self.assertRaisesRegex(ValueError, "Duplicate historical"):
            self.render(data)
        data["task_history"]["earlier_lines"][1] = copy.deepcopy(self.historical_line())
        data["task_history"]["earlier_lines"][1]["source_line_id"] = "another-copy"
        with self.assertRaisesRegex(ValueError, "different line ID"):
            self.render(data)

    def test_cutoff_cannot_drift_from_invoice_date(self):
        data = copy.deepcopy(self.data)
        data["task_history"]["period_end"] = "2026-02-15"
        with self.assertRaisesRegex(ValueError, "cutoff must match"):
            self.render(data)

    def test_history_cannot_include_other_project_or_missing_traceability(self):
        for field, value in (("project", "Elsewhere"), ("source_reference", "")):
            data = copy.deepcopy(self.data)
            line = self.historical_line()
            line[field] = value
            data["task_history"]["earlier_lines"] = [line]
            with self.assertRaises(ValueError):
                self.render(data)

    def test_josh_history_coverage_is_required(self):
        data = copy.deepcopy(self.data)
        del data["task_history"]
        with self.assertRaisesRegex(ValueError, "task_history"):
            self.render(data)

    def test_other_worker_keeps_existing_layout(self):
        data = copy.deepcopy(self.data)
        data["issuer"] = "Other Worker"
        pages = self.render(data)
        self.assertEqual(1, len(pages))
        self.assertIn("Time and Allocation Detail", pages[0])
        self.assertNotIn("Supporting Time Statement", pages[0])


if __name__ == "__main__":
    unittest.main()
