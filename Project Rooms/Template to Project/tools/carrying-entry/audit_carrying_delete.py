"""Read-only preservation audit for a toolbar-only Carrying Delete installation."""
import ast
import json
import pathlib
import sys

tree = ast.parse(pathlib.Path(__file__).with_name('audit_full_carrying.py').read_text())
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
for sheet, cells in ac.items():
    for addr in cells.keys() | bc[sheet].keys():
        old = cells.get(addr, (None, None, None, 0))
        new = bc[sheet].get(addr, (None, None, None, 0))
        if old[0] != new[0]:
            issues.append(['formula', sheet, addr])
        if old[0] is None and old[1] != new[1] and not (old[1] in (None, '') and new[1] in (None, '')):
            issues.append(['value', sheet, addr, old[1], new[1]])
        if style(a, old[3]) != style(b, new[3]):
            issues.append(['style', sheet, addr])
    for attr in ('page_setup', 'page_margins', 'print_options', 'freeze_panes', 'print_area', 'merged_cells', 'data_validations'):
        if getattr(a[sheet], attr) != getattr(b[sheet], attr):
            issues.append(['sheet setting', sheet, attr])
    for kind in ('row_dimensions', 'column_dimensions'):
        old = getattr(a[sheet], kind); new = getattr(b[sheet], kind)
        for key in old.keys() | new.keys():
            fields = ('height', 'width', 'hidden', 'outlineLevel', 'collapsed', 'bestFit', 'min', 'max')
            if key in old and key in new and any(getattr(old[key], x, None) != getattr(new[key], x, None) for x in fields):
                issues.append(['dimensions', sheet, kind, key])
    if set(a[sheet].tables) != set(b[sheet].tables):
        issues.append(['table names', sheet])
    for name in a[sheet].tables:
        if table_definition(a, a[sheet].tables[name]) != table_definition(b, b[sheet].tables[name]):
            issues.append(['table definition', sheet, name])
if a.sheetnames != b.sheetnames or a.defined_names != b.defined_names:
    issues.append(['sheets or defined names'])
for name, code in before['codes'].items():
    new = after['codes'].get(name, '')
    if name == 'BYHCarryingEdit':
        marker = "' Delete Record toolbar action."
        if marker not in new or code.strip() != new.split(marker)[0].strip():
            issues.append(['original editor changed'])
        if 'vbDefaultButton2' not in new or 'DeleteTestOnly' in new:
            issues.append(['unsafe confirmation'])
    elif code != new:
        issues.append(['VBA source', name])
if set(before['codes']) != set(after['codes']):
    issues.append(['VBA modules'])
for sheet, shapes in before['controls'].items():
    old = {s['name']: dict(s) for s in shapes}
    new = {s['name']: dict(s) for s in after['controls'][sheet]}
    for name, shape in old.items():
        actual = new.get(name, {})
        if sheet == 'Carrying' and name in ('ceRecurringButton', 'ceInsertButton', 'ceEditButton', 'ceSaveButton', 'ceCancelButton'):
            shape.pop('left'); actual.pop('left', None)
        if shape != actual:
            issues.append(['control changed', sheet, name])
    if new.keys() - old.keys() != ({'ceDeleteButton'} if sheet == 'Carrying' else set()):
        issues.append(['unexpected new controls', sheet])
if before['modes'] != after['modes'] or before['rentGrid'] != after['rentGrid']:
    issues.append(['financial results changed'])
errors = lambda x: {(s, r['cell'], r['text']) for s, rows in x['errors'].items() for r in rows if r['text'].startswith('#')}
if errors(before) != errors(after):
    issues.append(['native errors changed'])
if b.calculation.calcMode not in ('auto', None):
    issues.append(['not automatic calculation'])
for path in az.namelist():
    if path.startswith(('xl/media/', 'xl/externalLinks/')) and (path not in bz.namelist() or az.read(path) != bz.read(path)):
        issues.append(['media/link changed', path])
if before.get('records') != after.get('records'):
    issues.append(['record count'])
result = dict(issues=issues, issueCount=len(issues), recordsPreserved=after.get('records'), nativeErrors=len(errors(after)), modes=after['modes'])
evidence.write_text(json.dumps(result, indent=2), encoding='utf-8')
print(json.dumps(result, indent=2))
sys.exit(bool(issues))
