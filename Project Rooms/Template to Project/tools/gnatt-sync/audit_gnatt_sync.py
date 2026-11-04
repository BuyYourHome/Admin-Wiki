"""Read-only, independent preservation audit of the narrow Gnatt repair."""
import ast
import collections
import copy
import json
import pathlib
import sys

helper = pathlib.Path(__file__).parent.parent / "carrying-entry" / "audit_full_carrying.py"
nodes = []
for node in ast.parse(helper.read_text()).body:
    if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Tuple):
        break
    nodes.append(node)
exec(compile(ast.Module(body=nodes, type_ignores=[]), "<read-only helpers>", "exec"))

source, output, evidence = map(pathlib.Path, sys.argv[1:])
a, az, ac = load(source)
b, bz, bc = load(output)
issues = []
cache_changes = []
assert a.sheetnames == b.sheetnames


def cell(book, cells, addr):
    f, value, kind, fmt = cells.get(addr, (None, None, None, 0))
    record_style = style(book, fmt)
    # Native Sort leaves grid borders at their coordinates; all other styles follow records.
    record_style = record_style[:2] + record_style[3:]
    return f, value if f is None else None, str(record_style)


def edit_records(book, cells):
    result = collections.Counter()
    for row in range(25, 295):
        record = tuple(cell(book, cells, get_column_letter(col) + str(row)) for col in range(12, 41))
        result[record] += 1
    return result


if edit_records(a, ac["Gnatt Chart"]) != edit_records(b, bc["Gnatt Chart"]):
    issues.append(["editable records, formulas or styles changed"])

for sheet, cells in ac.items():
    for addr in cells.keys() | bc[sheet].keys():
        row, col = coordinate_to_tuple(addr)
        if sheet == "Gnatt Chart" and 25 <= row <= 294 and 12 <= col <= 40:
            old_fmt = cells.get(addr, (None, None, None, 0))[3]
            new_fmt = bc[sheet].get(addr, (None, None, None, 0))[3]
            if style(a, old_fmt)[2] != style(b, new_fmt)[2]:
                issues.append(["grid border changed", addr])
            continue
        old = cells.get(addr, (None, None, None, 0))
        new = bc[sheet].get(addr, (None, None, None, 0))
        if sheet == "Gnatt Chart" and 25 <= row <= 226 and 1 <= col <= 10:
            # Query output is compared independently by Index below.
            continue
        if old[0] != new[0]:
            issues.append(["formula", sheet, addr, old[0], new[0]])
        if old[0] is None and old[1] != new[1] and not (old[1] in (None, "") and new[1] in (None, "")):
            issues.append(["constant", sheet, addr, old[1], new[1]])
        if style(a, old[3]) != style(b, new[3]):
            issues.append(["style", sheet, addr])
        if new[2] == "e" and old[2] != "e":
            issues.append(["new error", sheet, addr, new[1]])
        if old[0] and old[1] != new[1]:
            cache_changes.append([sheet, addr, old[1], new[1]])
    for attr in ("page_setup", "page_margins", "print_options", "freeze_panes", "print_area", "data_validations", "merged_cells"):
        if getattr(a[sheet], attr) != getattr(b[sheet], attr):
            issues.append(["setting", sheet, attr])
    for row in a[sheet].row_dimensions.keys() | b[sheet].row_dimensions.keys():
        x, y = a[sheet].row_dimensions[row], b[sheet].row_dimensions[row]
        xh = a[sheet].sheet_format.defaultRowHeight if x.height is None else x.height
        yh = b[sheet].sheet_format.defaultRowHeight if y.height is None else y.height
        if (xh, x.hidden, x.outlineLevel) != (yh, y.hidden, y.outlineLevel):
            issues.append(["row dimension", sheet, row])
    for col in a[sheet].column_dimensions.keys() | b[sheet].column_dimensions.keys():
        x, y = a[sheet].column_dimensions[col], b[sheet].column_dimensions[col]
        if (x.width, x.hidden, x.outlineLevel) != (y.width, y.hidden, y.outlineLevel):
            issues.append(["column dimension", sheet, col])
    if set(a[sheet].tables) != set(b[sheet].tables):
        issues.append(["table names", sheet])
    for name in a[sheet].tables:
        x, y = copy.deepcopy(a[sheet].tables[name]), copy.deepcopy(b[sheet].tables[name])
        if name in ("Contract_Edits", "qryContractsToGnatt"):
            x.sortState = y.sortState = None
        if table_definition(a, x) != table_definition(b, y):
            issues.append(["table schema", sheet, name])


def query_records(cells):
    return {cells["J" + str(row)][1]: [cells.get(get_column_letter(col) + str(row), (None, None, None, 0))[:3]
                                     for col in range(1, 11)] for row in range(25, 227)}


query_before, query_after = query_records(ac["Gnatt Chart"]), query_records(bc["Gnatt Chart"])
query_changes = []
if query_before.keys() != query_after.keys():
    issues.append(["query Index set changed"])
for key in query_before.keys() & query_after.keys():
    if query_before[key] != query_after[key]:
        query_changes.append([key, query_before[key], query_after[key]])
for row in range(25, 227):
    if bc["Gnatt Chart"]["J" + str(row)][1] != bc["Gnatt Chart"]["L" + str(row)][1]:
        issues.append(["alignment", row])
for name in az.namelist():
    if name.startswith(("xl/media/", "xl/externalLinks/")) and (name not in bz.namelist() or az.read(name) != bz.read(name)):
        issues.append(["media/link", name])
result = dict(passed=not issues, issues=issues, query_changes=query_changes, cache_changes=cache_changes,
              displayed_records=202, editable_records=270)
evidence.write_text(json.dumps(result, indent=2), encoding="utf-8")
print(json.dumps({**result, "cache_changes": cache_changes[:12], "query_changes": query_changes[:3]}, indent=2))
sys.exit(bool(issues))
