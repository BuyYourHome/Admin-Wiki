"""Recover Pond's independent Others prices using stable item indexes."""
import argparse
import json
import warnings
from pathlib import Path

import openpyxl

warnings.simplefilter("ignore", UserWarning)


def records(path):
    book = openpyxl.load_workbook(path, read_only=True, data_only=True)
    result = {}
    for number, row in enumerate(book["Others"].iter_rows(min_row=5, max_col=16, values_only=True), 5):
        if isinstance(row[0], (int, float)):
            if row[0] in result:
                raise ValueError(f"Duplicate Index {row[0]}")
            result[row[0]] = dict(row=number, index=row[0], title=row[2], qty=row[4],
                                 contract=row[5], price=row[7])
    book.close()
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("source")
    parser.add_argument("history")
    parser.add_argument("before_today")
    parser.add_argument("output")
    args = parser.parse_args()
    current, history, before = map(records, (args.source, args.history, args.before_today))
    mapped = []
    for index, row in current.items():
        if index not in before:
            raise ValueError(f"Unreviewed new item {index}")
        if row["price"] != before[index]["price"]:
            override = row["price"]
            basis = "Latest owner value retained"
        elif index in history:
            override = history[index]["price"]
            basis = "Recovered by Index from Oct 11 backup"
        else:
            override = None
            basis = "Contract price; no historical override for this Index"
        expected = override if override is not None else row["contract"] or 0
        mapped.append(dict(**row, override=override, expected=expected, basis=basis))
    assert len(mapped) == 53
    assert next(r for r in mapped if r["index"] == 45)["expected"] == 26.1
    Path(args.output).write_text(json.dumps(mapped, indent=2), encoding="utf-8")
    changes = [r for r in mapped if r["price"] != r["expected"]]
    print(json.dumps({"records": len(mapped), "changes": changes}, indent=2))


if __name__ == "__main__":
    main()
