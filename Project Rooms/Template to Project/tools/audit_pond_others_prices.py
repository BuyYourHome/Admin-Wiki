"""Read-only preservation and pricing audit for the indexed Others repair."""
import ast
import json
import pathlib
import sys

helper = pathlib.Path(__file__).parent / 'carrying-entry' / 'audit_full_carrying.py'
nodes = []
for node in ast.parse(helper.read_text()).body:
    if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Tuple):
        break
    nodes.append(node)
exec(compile(ast.Module(body=nodes, type_ignores=[]), '<read-only helpers>', 'exec'))

source, output, mapping, evidence = map(pathlib.Path, sys.argv[1:])
a, az, ac = load(source)
b, bz, bc = load(output)
mapped = json.loads(mapping.read_text())
issues, changes = [], []
query_ranges = {}
for sheet in a:
    for table in sheet.tables.values():
        if table.name in ('qryContractsToGnatt', 'qryGnattToDraws', 'tblUpdateContractOthers'):
            query_ranges.setdefault(sheet.title, []).append(range_boundaries(table.ref))


def query_cell(sheet, r, c):
    return any(left <= c <= right and top < r <= bottom
               for left, top, right, bottom in query_ranges.get(sheet, []))


for sheet, cells in ac.items():
    for addr in cells.keys() | bc[sheet].keys():
        r, c = coordinate_to_tuple(addr)
        old = cells.get(addr, (None, None, None, 0))
        new = bc[sheet].get(addr, (None, None, None, 0))
        added = sheet == 'Others' and 27 <= c <= 30 and r <= 57
        price = sheet == 'Others' and c == 8 and 5 <= r <= 57
        query = query_cell(sheet, r, c)
        # Native Excel opens both forms as the same implicit current-row formula.
        implicit_hvac = (sheet == 'HVAC' and c == 8 and 11 <= r <= 19
                         and old[0] == 'tblHVACInvoices[Qty]*tblHVACInvoices[Cost/Unit]'
                         and new[0] == 'tblHVACInvoices[[#This Row],[Qty]]*tblHVACInvoices[[#This Row],[Cost/Unit]]')
        if old[:2] != new[:2]:
            changes.append([sheet, addr, old[:2], new[:2]])
        if not added and not price:
            if old[0] != new[0] and not implicit_hvac:
                issues.append(['formula', sheet, addr, old[0], new[0]])
            if old[0] is None and old[1] != new[1] and not query:
                if not (old[1] in (None, '') and new[1] in (None, '')):
                    issues.append(['constant', sheet, addr, old[1], new[1]])
        if not added and not price and style(a, old[3]) != style(b, new[3]):
            issues.append(['style', sheet, addr])
        if new[2] == 'e' and old[2] != 'e':
            issues.append(['new error', sheet, addr, new[1]])
    for attr in ('page_setup', 'page_margins', 'print_options', 'freeze_panes', 'print_area', 'data_validations'):
        if getattr(a[sheet], attr) != getattr(b[sheet], attr):
            issues.append(['setting', sheet, attr])
    expected_merges = set(str(r) for r in a[sheet].merged_cells.ranges)
    if sheet == 'Others':
        expected_merges |= {'AA1:AD1', 'AA2:AD3'}
    if expected_merges != set(str(r) for r in b[sheet].merged_cells.ranges):
        issues.append(['merges', sheet])
    expected_tables = set(a[sheet].tables)
    if sheet == 'Others':
        expected_tables.add('tblOthersPriceOverrides')
    if expected_tables != set(b[sheet].tables):
        issues.append(['table list', sheet])
    for key in a[sheet].row_dimensions.keys() | b[sheet].row_dimensions.keys():
        ra, rb = a[sheet].row_dimensions[key], b[sheet].row_dimensions[key]
        if (ra.height, ra.hidden, ra.outlineLevel) != (rb.height, rb.hidden, rb.outlineLevel):
            issues.append(['row dimension', sheet, key])
    for name in a[sheet].tables:
        ta, tb = a[sheet].tables[name], b[sheet].tables[name]
        if ta.ref != tb.ref or [c.name for c in ta.tableColumns] != [c.name for c in tb.tableColumns]:
            issues.append(['table shape', sheet, name, ta.ref, tb.ref])
if a.sheetnames != b.sheetnames:
    issues.append(['sheet list'])
v = openpyxl.load_workbook(output, read_only=True, data_only=True)
source_values = openpyxl.load_workbook(source, read_only=True, data_only=True)
for m in mapped:
    value = v['Others'].cell(m['row'], 8).value
    if not isinstance(value, (int, float)) or abs(value - m['expected']) > 1e-7:
        issues.append(['mapped price', m['index'], value, m['expected']])
grid = {r[9]: r for r in v['Gnatt Chart'].iter_rows(min_row=25, max_col=10, values_only=True)
        if isinstance(r[9], (int, float))}
old_grid = {r[9]: r for r in source_values['Gnatt Chart'].iter_rows(min_row=25, max_col=10, values_only=True)
            if isinstance(r[9], (int, float))}
if old_grid.keys() != grid.keys():
    issues.append(['Gnatt item indexes changed'])
others_ids = {m['index'] for m in mapped}
for index in old_grid.keys() & grid.keys():
    for col, (old, new) in enumerate(zip(old_grid[index], grid[index])):
        if old != new and not (index in others_ids and col in (5, 6, 8)):
            issues.append(['unrelated Gnatt change', index, col, old, new])
for m in mapped:
    row = grid.get(m['index'])
    if row is not None and (abs(row[5] - m['expected']) > 1e-7 or abs(row[6] - row[4]*m['expected']) > 1e-5):
        issues.append(['Gnatt price', m['index'], row])
for name in az.namelist():
    if name.startswith(('xl/media/', 'xl/externalLinks/')) and (name not in bz.namelist() or az.read(name) != bz.read(name)):
        issues.append(['media or external link', name])
result = dict(passed=not issues, issues=issues, changes=changes,
              item45=grid.get(45), pricesChanged=sum(m['price'] != m['expected'] for m in mapped),
              summaries={s: {cell: [source_values[s][cell].value, v[s][cell].value] for cell in cells}
                         for s, cells in {'Gnatt Chart': ['I2','I3','I4','I5','I6','L3','L5'],
                                          'Profit': ['B66','K47','I58']}.items()})
evidence.write_text(json.dumps(result, indent=2), encoding='utf-8')
print(json.dumps({k: val for k, val in result.items() if k != 'changes'}, indent=2))
sys.exit(bool(issues))
