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

activation = '--activation' in sys.argv
source, output, evidence = map(pathlib.Path, [v for v in sys.argv[1:] if v != '--activation'])
a, az, ac = load(source)
b, bz, bc = load(output)
issues = []
cache_changes = []
assert a.sheetnames == b.sheetnames
edit_bounds = range_boundaries(a['Gnatt Chart'].tables['Contract_Edits'].ref)
query_bounds = range_boundaries(a['Gnatt Chart'].tables['qryContractsToGnatt'].ref)


def cell(book, cells, addr):
    f, value, kind, fmt = cells.get(addr, (None, None, None, 0))
    record_style = style(book, fmt)
    # Native Sort leaves grid borders at their coordinates; all other styles follow records.
    record_style = record_style[:2] + record_style[3:]
    return f, value if f is None else None, str(record_style)


def edit_records(book, cells):
    result = collections.Counter()
    left, top, right, bottom = edit_bounds
    for row in range(top + 1, bottom + 1):
        record = tuple(cell(book, cells, get_column_letter(col) + str(row)) for col in range(left, right + 1))
        result[record] += 1
    return result


if edit_records(a, ac["Gnatt Chart"]) != edit_records(b, bc["Gnatt Chart"]):
    issues.append(["editable records, formulas or styles changed"])

for sheet, cells in ac.items():
    for addr in cells.keys() | bc[sheet].keys():
        row, col = coordinate_to_tuple(addr)
        if sheet == "Gnatt Chart" and edit_bounds[1] < row <= edit_bounds[3] and edit_bounds[0] <= col <= edit_bounds[2]:
            old_fmt = cells.get(addr, (None, None, None, 0))[3]
            new_fmt = bc[sheet].get(addr, (None, None, None, 0))[3]
            if style(a, old_fmt)[2] != style(b, new_fmt)[2]:
                issues.append(["grid border changed", addr])
            continue
        old = cells.get(addr, (None, None, None, 0))
        new = bc[sheet].get(addr, (None, None, None, 0))
        if sheet == "Gnatt Chart" and query_bounds[1] < row <= query_bounds[3] and query_bounds[0] <= col <= query_bounds[2]:
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
                                     for col in range(1, 11)] for row in range(query_bounds[1] + 1, query_bounds[3] + 1)}


query_before, query_after = query_records(ac["Gnatt Chart"]), query_records(bc["Gnatt Chart"])
query_changes = []
if query_before.keys() != query_after.keys():
    issues.append(["query Index set changed"])
for key in query_before.keys() & query_after.keys():
    if query_before[key] != query_after[key]:
        query_changes.append([key, query_before[key], query_after[key]])
for row in range(query_bounds[1] + 1, query_bounds[3] + 1):
    if bc["Gnatt Chart"]["J" + str(row)][1] != bc["Gnatt Chart"]["L" + str(row)][1]:
        issues.append(["alignment", row])
for name in az.namelist():
    if name.startswith(("xl/media/", "xl/externalLinks/")) and (name not in bz.namelist() or az.read(name) != bz.read(name)):
        issues.append(["media/link", name])


def conditional_rules(book, sheet, exclude_mismatch):
    rules = []
    mismatch = []
    for cf in book[sheet].conditional_formatting:
        in_k = sheet == 'Gnatt Chart' and any(r.min_col <= 11 <= r.max_col and r.max_row >= 24 for r in cf.sqref.ranges)
        for rule in book[sheet].conditional_formatting[cf]:
            if exclude_mismatch and in_k:
                mismatch.append((str(cf.sqref), rule))
                continue
            r = copy.deepcopy(rule)
            r.priority = 0
            r.dxfId = None
            rules.append((rule.priority, str(cf.sqref), ET.tostring(r.to_tree()), str(rule.dxf)))
    return [(ref, raw, fmt) for _, ref, raw, fmt in sorted(rules)], mismatch


for sheet in a.sheetnames:
    old_rules, _ = conditional_rules(a, sheet, activation)
    new_rules, mismatch = conditional_rules(b, sheet, activation)
    if old_rules != new_rules:
        issues.append(['unrelated conditional formatting', sheet])
    if activation and sheet == 'Gnatt Chart':
        if len(mismatch) != 1 or mismatch[0][0] != 'K25:K1048576' or mismatch[0][1].formula != ['AND($J25<>"",$J25<>$L25)']:
            issues.append(['column K mismatch rule'])
result = dict(passed=not issues, issues=issues, query_changes=query_changes, cache_changes=cache_changes,
              displayed_records=query_bounds[3]-query_bounds[1], editable_records=edit_bounds[3]-edit_bounds[1])
evidence.write_text(json.dumps(result, indent=2), encoding="utf-8")
print(json.dumps({**result, "cache_changes": cache_changes[:12], "query_changes": query_changes[:3]}, indent=2))
sys.exit(bool(issues))
