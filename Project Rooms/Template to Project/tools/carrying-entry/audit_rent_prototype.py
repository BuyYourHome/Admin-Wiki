"""Read-only whole-workbook preservation audit for the Tensity rent prototype."""
import ast
import json
import pathlib
import sys

# Reuse the established raw/shared-formula reader without running its CLI.
source_code = pathlib.Path(__file__).with_name('audit_full_carrying.py').read_text()
tree = ast.parse(source_code)
nodes = []
for node in tree.body:
    if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Tuple):
        break
    nodes.append(node)
exec(compile(ast.Module(body=nodes, type_ignores=[]), '<audit helpers>', 'exec'))

source, output, before_path, after_path, evidence = map(pathlib.Path, sys.argv[1:])
a, az, ac = load(source)
b, bz, bc = load(output)
before = json.loads(before_path.read_text(encoding='utf-8-sig'))
after = json.loads(after_path.read_text(encoding='utf-8-sig'))
issues = []

def allowed(sheet, addr):
    row, col = coordinate_to_tuple(addr)
    if sheet == 'Profit':
        return addr in ('A9', 'E9', 'K57') or (18 <= row <= 25 and 17 <= col <= 23)
    return sheet == 'Carrying' and ((addr in ('AK9', 'AL9')) or (61 <= row <= 72 and 41 <= col <= 51))

for sheet, cells in ac.items():
    for addr in cells.keys() | bc[sheet].keys():
        old = cells.get(addr, (None, None, None, 0))
        new = bc[sheet].get(addr, (None, None, None, 0))
        if not allowed(sheet, addr):
            if old[0] != new[0]:
                issues.append(['formula', sheet, addr, old[0], new[0]])
            vendor_spill = sheet == 'Carrying' and addr.startswith('BA') and 5 <= coordinate_to_tuple(addr)[0] <= 15
            if old[0] is None and not vendor_spill and old[1] != new[1] and not (old[1] in (None, '') and new[1] in (None, '')):
                issues.append(['value', sheet, addr, old[1], new[1]])
            rent_date = sheet == 'Carrying' and addr.startswith('AK') and 10 <= coordinate_to_tuple(addr)[0] <= 30
            if not rent_date and style(a, old[3]) != style(b, new[3]):
                issues.append(['style', sheet, addr])
    for attr in ('page_setup', 'page_margins', 'print_options', 'freeze_panes', 'print_area'):
        if getattr(a[sheet], attr) != getattr(b[sheet], attr):
            issues.append(['sheet setting', sheet, attr])
    if sheet != 'Profit' and a[sheet].merged_cells != b[sheet].merged_cells:
        issues.append(['merges', sheet])
    for kind in ('row_dimensions', 'column_dimensions'):
        old = getattr(a[sheet], kind); new = getattr(b[sheet], kind)
        for key in old.keys() | new.keys():
            fields = ('height', 'width', 'hidden', 'outlineLevel', 'collapsed', 'bestFit', 'min', 'max')
            if key in old and key in new and any(getattr(old[key], x, None) != getattr(new[key], x, None) for x in fields):
                issues.append(['dimensions', sheet, kind, key])
    if set(a[sheet].tables) != set(b[sheet].tables):
        issues.append(['table names', sheet])
    for name in a[sheet].tables:
        if name != 'tblCarryingExpenses' and table_definition(a, a[sheet].tables[name]) != table_definition(b, b[sheet].tables[name]):
            issues.append(['table definition', sheet, name])
    if sheet != 'Carrying' and a[sheet].data_validations != b[sheet].data_validations:
        issues.append(['validation', sheet])
if a.sheetnames != b.sheetnames:
    issues.append(['sheet names'])
for name, definition in a.defined_names.items():
    if name not in b.defined_names or definition.attr_text != b.defined_names[name].attr_text:
        issues.append(['defined name', name])
if before['codes'] != after['codes']:
    issues.append(['VBA source changed'])
for sheet, shapes in before['controls'].items():
    old = {s['name']: s for s in shapes}
    new = {s['name']: s for s in after['controls'][sheet]}
    for name, shape in old.items():
        if shape != new.get(name):
            issues.append(['control changed', sheet, name])
    for name in new.keys() - old.keys():
        if new[name]['type'] != 4:
            issues.append(['unexpected new shape', sheet, name])
old_errors = {(s, r['cell'], r['text']) for s, rows in before['errors'].items() for r in rows if r['text'].startswith('#')}
new_errors = {(s, r['cell'], r['text']) for s, rows in after['errors'].items() for r in rows if r['text'].startswith('#')}
if new_errors - old_errors:
    issues.append(['new native errors', sorted(new_errors - old_errors)])
if any(p.startswith('xl/externalLinks/') for p in bz.namelist()):
    issues.append(['external links'])
if b.calculation.calcMode not in ('auto', None):
    issues.append(['calculation not automatic'])
for path in az.namelist():
    if path.startswith('xl/media/') and (path not in bz.namelist() or az.read(path) != bz.read(path)):
        issues.append(['media changed', path])
assert b['Carrying'].tables['tblCarryingExpenses'].ref == 'AO4:AY72'
assert len(b['Carrying'].tables['tblCarryingExpenses'].tableColumns) == 11
expected_vendors = sorted({bc['Carrying']['AR'+str(r)][1] for r in range(5, 73) if bc['Carrying'].get('AR'+str(r), (None, None))[1]})
actual_vendors = [bc['Carrying']['BA'+str(r)][1] for r in range(4, 4+len(expected_vendors))]
assert expected_vendors == actual_vendors, 'Vendor dropdown did not include the tenant correctly'
result = dict(issues=issues, issueCount=len(issues), sourceRecords=56, outputRecords=68,
              preservedNativeErrors=len(old_errors), outputNativeErrors=len(new_errors),
              modes=after['modes'], macrosUnchanged=before['codes'] == after['codes'])
evidence.write_text(json.dumps(result, indent=2), encoding='utf-8')
print(json.dumps({**result, 'issues': issues[:40]}, indent=2))
sys.exit(bool(issues))
