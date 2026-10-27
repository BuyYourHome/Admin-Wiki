"""Targeted controls for the read-only report snapshot collector."""

from datetime import datetime
import importlib.util
from pathlib import Path
import sqlite3
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import Mock, patch


MODULE_PATH = Path(__file__).with_name("Capture-QboReportSnapshot.py")
SPEC = importlib.util.spec_from_file_location("qbo_report_snapshot", MODULE_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class CoverageTests(unittest.TestCase):
    def test_actual_legacy_shape_never_invents_classes_or_debits(self):
        rows = [
            ("Example company",), ("General Ledger",), ("January-December, 2025",), (),
            (None, "Transaction date", "Transaction type", "Num", "Name", "Description", "Split", "Amount", "Balance"),
            ("Checking",),
            (None, datetime(2025, 1, 2), "Expense", "1", "Supplier", None, "Expense", -10, 90),
            ("Expense",),
            (None, datetime(2025, 1, 2), "Expense", "1", "Supplier", None, "Checking", 10, 10),
        ]
        result = MODULE.inspect_rows(rows)
        self.assertEqual(result["dated_row_count"], 2)
        self.assertEqual(result["account_section_count"], 2)
        self.assertFalse(result["has_class_column"])
        self.assertIsNone(result["debit_credit_difference"])
        self.assertIn("missing_transaction_level_class", result["coverage_findings"])
        self.assertFalse(result["entity_reporting_ready"])

    def test_explicit_balanced_rows_still_need_independent_ownership_controls(self):
        rows = [
            ("Cash Basis",),
            ("Date", "Transaction type", "Account", "Class", "Debit", "Credit", "Transaction ID"),
            ("2025-01-02", "Journal Entry", "Expense", "A", "10.10", None, "42"),
            ("2025-01-02", "Journal Entry", "Checking", "A", None, "10.10", "42"),
        ]
        result = MODULE.inspect_rows(rows)
        self.assertEqual(result["debit_credit_difference"], "0.00")
        self.assertEqual(result["transaction_ids_on_dated_rows"], 2)
        self.assertEqual(result["accounting_basis"], "cash")
        self.assertFalse(result["entity_reporting_ready"])

    def test_numerically_zero_differences_accept_all_decimal_scales(self):
        for amount in ("10.000", "0.00000001", "1E-8", "-0.000"):
            with self.subTest(amount=amount):
                result = MODULE.inspect_rows([
                    ("Date", "Transaction type", "Debit", "Credit"),
                    ("2025-01-01", "Journal", amount, amount),
                ])
                self.assertIsNotNone(result["debit_credit_difference"])
                self.assertNotIn("dated_debits_and_credits_differ", result["coverage_findings"])

    def test_blank_required_values_are_not_hidden_by_existing_headers(self):
        result = MODULE.inspect_rows([
            ("Date", "Transaction type", "Account", "Class", "Debit", "Credit"),
            ("2025-01-01", "Journal", None, " ", 0, 0),
        ])
        self.assertTrue(result["has_explicit_account_column"])
        self.assertTrue(result["has_class_column"])
        self.assertEqual(result["unaccounted_dated_rows"], 1)
        self.assertEqual(result["unclassed_dated_rows"], 1)
        self.assertIn("missing_account_values", result["coverage_findings"])
        self.assertIn("missing_class_values", result["coverage_findings"])

    def test_missing_amount_values_are_unknown_instead_of_balanced(self):
        result = MODULE.inspect_rows([
            ("Date", "Transaction type", "Debit", "Credit"),
            ("2025-01-01", "Journal", None, ""),
        ])
        self.assertEqual(result["missing_posting_amount_rows"], [2])
        self.assertIn("missing_posting_amounts", result["coverage_findings"])
        self.assertIsNone(result["debit_credit_difference"])

    def test_uncached_formula_results_are_not_zero_postings(self):
        result = MODULE.inspect_rows([
            ("Date", "Transaction type", "Debit", "Credit"),
            ("2025-01-01", "Journal", None, 0),
        ], uncached_formula_cells=[(2, 3)])
        self.assertEqual(result["uncached_formula_cells"], [{"row": 2, "column": 3}])
        self.assertIn("uncached_formula_results", result["coverage_findings"])
        self.assertIsNone(result["debit_credit_difference"])

    def test_xlsx_audit_detects_uncached_formulas_without_authoring_a_workbook(self):
        rows = [
            ("Date", "Transaction type", "Debit", "Credit"),
            ("2025-01-01", "Journal", None, 0),
        ]
        formula_rows = [
            tuple(SimpleNamespace(data_type="s", value=value) for value in rows[0]),
            (SimpleNamespace(data_type="s", value="2025-01-01"),
             SimpleNamespace(data_type="s", value="Journal"),
             SimpleNamespace(data_type="f", value="=1+1"),
             SimpleNamespace(data_type="n", value=0)),
        ]
        cached = SimpleNamespace(worksheets=[SimpleNamespace(
            title="Example", iter_rows=lambda values_only=False: iter(rows),
        )], close=Mock())
        formulas = SimpleNamespace(worksheets=[SimpleNamespace(
            title="Example", iter_rows=lambda: iter(formula_rows),
        )], close=Mock())
        with patch("openpyxl.load_workbook", side_effect=[cached, formulas]) as load:
            result = MODULE.inspect_xlsx(b"mocked workbook read")
        self.assertEqual([call.kwargs["data_only"] for call in load.call_args_list], [True, False])
        audit = result["sheets"][0]
        self.assertEqual(audit["uncached_formula_cells"], [{"row": 2, "column": 3}])
        self.assertIsNone(audit["debit_credit_difference"])
        self.assertFalse(result["entity_reporting_ready"])
        cached.close.assert_called_once_with()
        formulas.close.assert_called_once_with()

    def test_transaction_memos_do_not_establish_or_override_report_basis(self):
        rows = [
            ("Date", "Transaction type", "Memo", "Debit", "Credit"),
            ("2025-01-01", "Journal", "Accrual Basis", 10, 10),
            ("A question about cash basis",),
        ]
        unknown = MODULE.inspect_rows(rows)
        self.assertIsNone(unknown["accounting_basis"])
        self.assertIn("accounting_basis_not_established", unknown["coverage_findings"])
        recognized = MODULE.inspect_rows([("Cash Basis",)] + rows)
        self.assertEqual(recognized["accounting_basis"], "cash")

    def test_recognized_report_footer_basis_is_supported(self):
        rows = [
            ("Date", "Transaction type", "Debit", "Credit"),
            ("2025-01-01", "Journal", 10, 10),
            ("Accrual Basis Tuesday, January 7, 2025 10:00 AM",),
        ]
        self.assertEqual(MODULE.inspect_rows(rows)["accounting_basis"], "accrual")

    def test_report_totals_are_not_counted_as_postings(self):
        rows = [("Date", "Transaction type", "Debit", "Credit"),
                ("2025-01-01", "Journal", 8, 8), ("Total", None, 16, 0)]
        self.assertEqual(MODULE.inspect_rows(rows)["debit_credit_difference"], "0")

    def test_amount_errors_and_imbalances_are_visible(self):
        rows = [("Date", "Transaction type", "Debit", "Credit"),
                ("2025-01-01", "Journal", 10, 9)]
        self.assertIn("dated_debits_and_credits_differ", MODULE.inspect_rows(rows)["coverage_findings"])
        rows[1] = ("2025-01-01", "Journal", "bad", 9)
        result = MODULE.inspect_rows(rows)
        self.assertIn("invalid_posting_amounts", result["coverage_findings"])
        self.assertIsNone(result["debit_credit_difference"])

    def test_duplicate_headers_are_not_silently_selected(self):
        result = MODULE.inspect_rows([("Date", "Transaction type", "Class", "Class")])
        self.assertEqual(result["coverage_findings"], ["ambiguous_duplicate_header"])

    def test_missing_date_never_becomes_a_posting(self):
        result = MODULE.inspect_rows([("Date", "Transaction type", "Amount"), (None, "Expense", 40)])
        self.assertEqual(result["dated_row_count"], 0)
        self.assertIn("no_dated_postings_detected", result["coverage_findings"])


class ArchiveTests(unittest.TestCase):
    def test_output_cannot_be_inside_repo_or_overwrite_source(self):
        with self.assertRaises(ValueError):
            MODULE.validate_output(MODULE.REPOSITORY / "financial.sqlite3", [])
        with tempfile.TemporaryDirectory() as folder:
            source = Path(folder) / "source.xlsx"
            with self.assertRaises(ValueError):
                MODULE.validate_output(source, [source])
        with self.assertRaises(ValueError):
            MODULE.validate_output(Path("relative.sqlite3"), [])

    def test_same_company_and_bytes_are_idempotent_and_copies_remain_exact(self):
        # This is a byte fixture; no workbook is authored and no financial source is used.
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            source = root / "source.xlsx"
            source.write_bytes(b"source snapshot fixture")
            connection = MODULE.open_archive(root / "archive.sqlite3")
            try:
                with patch.object(MODULE, "inspect_xlsx", return_value={"entity_reporting_ready": False}):
                    with connection:
                        first = MODULE.capture(connection, "Example", source)
                        second = MODULE.capture(connection, "Example", source)
                        third = MODULE.capture(connection, "Other", source)
                self.assertTrue(first["new_snapshot"])
                self.assertFalse(second["new_snapshot"])
                self.assertEqual(first["snapshot_id"], second["snapshot_id"])
                self.assertNotEqual(first["snapshot_id"], third["snapshot_id"])
                self.assertEqual(connection.execute("SELECT count(*) FROM source_snapshots").fetchone()[0], 2)
                self.assertEqual(connection.execute("SELECT content FROM source_snapshots LIMIT 1").fetchone()[0], source.read_bytes())
            finally:
                connection.close()

    def test_existing_unrelated_database_is_not_repurposed(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "unrelated.sqlite3"
            connection = sqlite3.connect(path)
            try:
                connection.execute("CREATE TABLE other (id INTEGER)")
                connection.commit()
            finally:
                connection.close()
            with self.assertRaises(ValueError):
                MODULE.open_archive(path)

    def test_version_one_without_archive_identity_is_not_repurposed(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "unrelated.sqlite3"
            connection = sqlite3.connect(path)
            try:
                connection.execute("CREATE TABLE other (id INTEGER)")
                connection.execute("PRAGMA user_version=1")
                connection.commit()
            finally:
                connection.close()
            with self.assertRaisesRegex(ValueError, "identity"):
                MODULE.open_archive(path)
            connection = sqlite3.connect(path)
            try:
                tables = {row[0] for row in connection.execute(
                    "SELECT name FROM sqlite_master WHERE type='table'",
                )}
                self.assertEqual(tables, {"other"})
            finally:
                connection.close()

    def test_recognized_archive_can_be_reopened(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "archive.sqlite3"
            MODULE.open_archive(path).close()
            connection = MODULE.open_archive(path)
            try:
                self.assertEqual(connection.execute("PRAGMA application_id").fetchone()[0],
                                 MODULE.ARCHIVE_APPLICATION_ID)
                self.assertEqual(connection.execute("SELECT count(*) FROM source_snapshots").fetchone()[0], 0)
            finally:
                connection.close()

    def test_duplicate_capture_rejects_corrupted_existing_blob(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            source = root / "source.xlsx"
            source.write_bytes(b"fixture")
            connection = MODULE.open_archive(root / "archive.sqlite3")
            try:
                with patch.object(MODULE, "inspect_xlsx", return_value={}):
                    with connection:
                        captured = MODULE.capture(connection, "Example", source)
                        connection.execute("UPDATE source_snapshots SET content=? WHERE snapshot_id=?",
                                           (b"corrupt", captured["snapshot_id"]))
                    with self.assertRaisesRegex(ValueError, "integrity"):
                        MODULE.capture(connection, "Example", source)
                self.assertEqual(connection.execute("SELECT content FROM source_snapshots").fetchone()[0],
                                 b"corrupt")
                self.assertEqual(source.read_bytes(), b"fixture")
            finally:
                connection.close()

    def test_whole_snapshot_preserves_identical_legitimate_posting_rows(self):
        rows = [
            ("Date", "Transaction type", "Account", "Class", "Debit", "Credit", "Transaction ID"),
            ("2025-01-01", "Journal", "Expense", "Example", 10, None, "42"),
            ("2025-01-01", "Journal", "Expense", "Example", 10, None, "42"),
            ("2025-01-01", "Journal", "Checking", "Example", None, 10, "42"),
            ("2025-01-01", "Journal", "Checking", "Example", None, 10, "42"),
        ]
        audit = MODULE.inspect_rows(rows)
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            source = root / "source.xlsx"
            content = b"opaque report byte fixture retaining every repeated row"
            source.write_bytes(content)
            connection = MODULE.open_archive(root / "archive.sqlite3")
            try:
                with patch.object(MODULE, "inspect_xlsx", return_value=audit):
                    with connection:
                        result = MODULE.capture(connection, "Example", source)
                self.assertEqual(result["audit"]["dated_row_count"], 4)
                self.assertEqual(result["audit"]["transaction_ids_on_dated_rows"], 4)
                self.assertEqual(result["audit"]["debit_credit_difference"], "0")
                self.assertEqual(connection.execute("SELECT count(*) FROM source_snapshots").fetchone()[0], 1)
                self.assertEqual(connection.execute("SELECT content FROM source_snapshots").fetchone()[0], content)
            finally:
                connection.close()

    def test_failed_source_batch_rolls_back_snapshots(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            source = root / "source.xlsx"
            source.write_bytes(b"fixture")
            connection = MODULE.open_archive(root / "archive.sqlite3")
            try:
                with patch.object(MODULE, "inspect_xlsx", return_value={}):
                    with self.assertRaises(FileNotFoundError):
                        with connection:
                            MODULE.capture(connection, "Example", source)
                            MODULE.capture(connection, "Example", root / "missing.xlsx")
                self.assertEqual(connection.execute("SELECT count(*) FROM source_snapshots").fetchone()[0], 0)
            finally:
                connection.close()


if __name__ == "__main__":
    unittest.main()
