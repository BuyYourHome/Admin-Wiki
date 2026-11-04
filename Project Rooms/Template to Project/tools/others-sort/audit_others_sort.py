"""Independent read-only audit of the adjacent Others table synchronization."""
import ast
import json
import pathlib
import sys

helper = pathlib.Path(__file__).parent.parent / 'carrying-entry' / 'audit_full_carrying.py'
nodes = []
for node in ast.parse(helper.read_text()).body:
    if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Tuple):
        break
    nodes.append(node)
exec(compile(ast.Module(body=nodes, type_ignores=[]), '<read-only helpers>', 'exec'))

source, output, evidence = map(pathlib.Path, sys.argv[1:])
a, az, ac = load(source)
b, bz, bc = load(output)
issues = []
assert a.sheetnames == b.sheetnames
for sheet, cells in ac.items():
    for addr in cells.keys() | bc[sheet].keys():
        r, c = coordinate_to_tuple(addr)
        old = cells.get(addr, (None, None, None, 0))
        new = bc[sheet].get(addr, (None, None, None, 0))
        override = sheet == 'Others' and 20 <= c <= 24 and 4 <= r <= 57
        banner = sheet == 'Others' and addr == 'T2'
        if not override and not banner:
            if old[0] != new[0]:
                issues.append(['formula', sheet, addr, old[0], new[0]])
            if old[0] is None and old[1] != new[1] and not (old[1] in (None, '') and new[1] in (None, '')):
                issues.append(['constant', sheet, addr, old[1], new[1]])
            if style(a, old[3]) != style(b, new[3]):
                issues.append(['style', sheet, addr])
        if new[2] == 'e' and old[2] != 'e':
            issues.append(['new error', sheet, addr, new[1]])
    for attr in ('page_setup', 'page_margins', 'print_options', 'freeze_panes', 'print_area', 'data_validations', 'merged_cells'):
        if getattr(a[sheet], attr) != getattr(b[sheet], attr):
            issues.append(['setting', sheet, attr])
    for k in a[sheet].row_dimensions.keys() | b[sheet].row_dimensions.keys():
        x, y = a[sheet].row_dimensions[k], b[sheet].row_dimensions[k]
        x_height = a[sheet].sheet_format.defaultRowHeight if x.height is None else x.height
        y_height = b[sheet].sheet_format.defaultRowHeight if y.height is None else y.height
        if (x_height,x.hidden,x.outlineLevel) != (y_height,y.hidden,y.outlineLevel):
            issues.append(['row dimension', sheet, k])
    for k, x in a[sheet].column_dimensions.items():
        y = b[sheet].column_dimensions[k]
        if x.width != y.width or x.outlineLevel != y.outlineLevel:
            issues.append(['column width', sheet, k])
        if x.hidden != y.hidden and not (sheet == 'Others' and k in ('H','X')):
            issues.append(['column hidden', sheet, k])
    if set(a[sheet].tables) != set(b[sheet].tables):
        issues.append(['table list',sheet])
    for name in a[sheet].tables:
        x,y = a[sheet].tables[name],b[sheet].tables[name]
        if name == 'tblOthersPriceOverrides':
            if y.ref != 'T4:X57' or [c.name for c in y.tableColumns] != [c.name for c in x.tableColumns]+['_Display Order']:
                issues.append(['override table schema'])
        elif table_definition(a,x) != table_definition(b,y):
            issues.append(['table schema',sheet,name])

def override_records(book):
    return {book['Others'].cell(r,20).value: tuple(book['Others'].cell(r,c).value for c in range(21,24))
            for r in range(5,58)}

if override_records(a) != override_records(b):
    issues.append(['override record changed'])
for r in range(5,58):
    if b['Others'].cell(r,1).value != b['Others'].cell(r,20).value:
        issues.append(['alignment',r])
if not b['Others'].column_dimensions['H'].hidden or not b['Others'].column_dimensions['X'].hidden:
    issues.append(['hidden calculated columns'])
for name in az.namelist():
    if name.startswith(('xl/media/','xl/externalLinks/')) and (name not in bz.namelist() or az.read(name) != bz.read(name)):
        issues.append(['media/link',name])
result = dict(passed=not issues, issues=issues, rows=53, pricesUnchanged=True)
evidence.write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result,indent=2))
sys.exit(bool(issues))
