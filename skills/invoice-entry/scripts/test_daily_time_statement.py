import copy
import importlib.util
import sys
import tempfile
import unittest
from decimal import Decimal
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
            "running_hourly_average": {
                "basis_type": "recorded_invoice_compensation",
                "periods": [
                    {"invoice_id": "FIXTURE-PRIOR", "issuer": "Josh Kennedy LLC", "period_start": "2025-12-16", "period_end": "2025-12-31", "compensation": 60, "minutes": 120, "source_reference": "verified-prior-fixture"},
                    {"invoice_id": "FIXTURE-001", "issuer": "Josh Kennedy LLC", "period_start": "2026-01-01", "period_end": "2026-01-15", "compensation": 100, "minutes": 390, "source_reference": "verified-current-fixture"},
                ],
            },
        }
        for line in self.data["lines"]:
            line["task_group"] = line["project"].lower()

    def render(self, data=None):
        path = Path(self.tmp.name) / "invoice.pdf"
        generator.build_invoice(data or self.data, path)
        return [page.extract_text() for page in PdfReader(path).pages]

    def test_invoice_itemizes_period_by_project_then_task_summary(self):
        pages = self.render()
        self.assertEqual(2, len(pages))
        self.assertIn("APPROVED BY WES", pages[0])
        self.assertIn("$100.00", pages[0])
        self.assertIn("Current-period time by project", pages[0])
        self.assertIn("Alpha subtotal", pages[0])
        self.assertIn("Beta subtotal", pages[0])
        self.assertIn("6h30m", pages[0])
        self.assertLess(pages[0].index("Prepare surfaces"), pages[0].index("Install fixture"))
        self.assertLess(pages[0].index("Install fixture"), pages[0].index("Inspect work"))
        self.assertIn("Task Hours Statement", pages[1])
        self.assertIn("Fixture work", pages[1])
        self.assertIn("Est. task", pages[1])
        for task in ("Install fixture", "Prepare surfaces", "Inspect work"):
            self.assertEqual(1, pages[0].count(task))

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
        self.assertEqual(2, len(pages))
        self.assertIn("Task Hours Statement", pages[1])
        self.assertIn("uncertain end time", pages[1])

    def historical_line(self):
        return {"date": "2025-12-20", "project": "Alpha", "description": "Earlier fixture work", "task_group": "alpha", "hours": 2, "minutes": 120, "source_line_id": "fixture-prior-1", "source_reference": "verified-fixture", "relationship": "direct"}

    def test_earlier_time_is_separate_and_does_not_change_invoice(self):
        data = copy.deepcopy(self.data)
        data["task_history"]["earlier_lines"] = [self.historical_line()]
        pages = self.render(data)
        self.assertIn("$100.00", pages[0])
        self.assertIn("6h30m", pages[0])
        self.assertIn("Task Hours Statement", pages[1])
        self.assertIn("2h00m", pages[1])
        self.assertIn("6h30m", pages[1])
        self.assertIn("add no hours or charges", pages[1])
        self.assertIn("$122.35", pages[1])
        self.assertEqual(2, len(pages))

    def test_related_or_uncertain_combined_history_cannot_inflate_task_totals(self):
        for relationship in ("related", "combined"):
            data = copy.deepcopy(self.data)
            line = self.historical_line()
            line["relationship"] = relationship
            data["task_history"]["earlier_lines"] = [line]
            with self.assertRaisesRegex(ValueError, "direct historical task match"):
                self.render(data)

    def test_fourteen_lines_and_material_notes_fit_two_pages(self):
        data = copy.deepcopy(self.data)
        data["lines"] = [
            {"date": f"01/{day:02d}/26", "project": "Alpha" if day % 2 else "Beta", "description": f"Supported work {day}", "hours": 1, "minutes": 60, "allocated_cost": 10, "task_group": "alpha" if day % 2 else "beta"}
            for day in range(1, 15)
        ]
        data["invoice_total"] = 140
        data["running_hourly_average"]["periods"][-1].update(compensation=140, minutes=840)
        for allocation in data["allocation_summary"]:
            allocation.update(hours=7, allocated_cost=70)
        data["review_notes"] = ["Preserve this material date/time interpretation and reconcile corrections without adding another invoice."] * 6
        pages = self.render(data)
        self.assertEqual(2, len(pages))
        for day in range(1, 15):
            self.assertIn(f"Supported work {day}", pages[0])
        self.assertIn("Accuracy review notes", pages[1])

    def test_running_rate_is_weighted_and_not_a_mean_of_period_rates(self):
        rate, amount, minutes, start, end = generator.running_hourly_average(self.data, self.data["lines"])
        self.assertEqual(Decimal(160)*60/510, rate)
        self.assertNotEqual((Decimal(60)/2 + Decimal(100)/Decimal('6.5'))/2, rate)
        self.assertEqual(Decimal(160), amount)
        self.assertEqual(510, minutes)
        pages = self.render()
        self.assertIn("$18.8235/hr", pages[1])
        self.assertIn("not verified cash paid", pages[1])
        self.assertIn("$100.00", pages[0])

    def test_running_basis_rejects_duplicates_overlap_future_and_wrong_worker(self):
        for change in ("duplicate", "overlap", "future", "worker", "source", "minutes", "amount", "current"):
            with self.subTest(change=change):
                data = copy.deepcopy(self.data)
                prior, current = data["running_hourly_average"]["periods"]
                if change == "duplicate": data["running_hourly_average"]["periods"].append(copy.deepcopy(prior))
                elif change == "overlap": prior["period_end"] = "2026-01-02"
                elif change == "future": prior["period_end"] = "2026-02-01"
                elif change == "worker": prior["issuer"] = "Another worker"
                elif change == "source": prior["source_reference"] = ""
                elif change == "minutes": prior["minutes"] = 0
                elif change == "amount": prior["compensation"] = -1
                elif change == "current": current["minutes"] = 300
                with self.assertRaises(ValueError): self.render(data)

    def test_running_basis_must_include_current_invoice(self):
        data = copy.deepcopy(self.data)
        data["running_hourly_average"]["periods"].pop()
        with self.assertRaisesRegex(ValueError, "exact current invoice once"):
            self.render(data)

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
