"""Read-only whole-workbook audit of Contract_Edits[0] -> [Paid]."""
import ast
import json
import pathlib
import sys

helpers = pathlib.Path(__file__).parent / 'carrying-entry' / 'audit_full_carrying.py'
tree = ast.parse(helpers.read_text())
nodes = []
for node in tree.body:
    if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Tuple):
        break
    nodes.append(node)
exec(compile(ast.Module(body=nodes, type_ignores=[]), '<read-only helpers>', 'exec'))

source, output, native_path, verify_path, evidence = map(pathlib.Path, sys.argv[1:])
a, az, ac = load(source)
b, bz, bc = load(output)
native = json.loads(native_path.read_text(encoding='utf-8-sig'))
verified = json.loads(verify_path.read_text(encoding='utf-8-sig'))
issues = []
changed = {}

def rename(value):
    return value.replace('Contract_Edits[0]', 'Contract_Edits[Paid]') if isinstance(value, str) else value

for sheet, cells in ac.items():
    for addr in cells.keys() | bc[sheet].keys():
        old = cells.get(addr, (None, None, None, 0))
        new = bc[sheet].get(addr, (None, None, None, 0))
        if rename(old[0]) != new[0]:
            issues.append(['formula', sheet, addr])
        if old[0] and old[0] != new[0]:
            changed.setdefault(sheet, []).append(addr)
        if old[0] is None:
            expected = 'Paid' if sheet == 'Gnatt Chart' and addr == 'Q24' else old[1]
            if expected != new[1] and not (expected in (None, '') and new[1] in (None, '')):
                issues.append(['constant', sheet, addr, expected, new[1]])
        if style(a, old[3]) != style(b, new[3]):
            issues.append(['style', sheet, addr])
    for attr in ('page_setup', 'page_margins', 'print_options', 'freeze_panes', 'print_area', 'merged_cells', 'data_validations'):
        if getattr(a[sheet], attr) != getattr(b[sheet], attr):
            issues.append(['sheet setting', sheet, attr])
    for kind in ('row_dimensions', 'column_dimensions'):
        old, new = getattr(a[sheet], kind), getattr(b[sheet], kind)
        for key in old.keys() | new.keys():
            fields = ('height', 'width', 'hidden', 'outlineLevel', 'collapsed', 'bestFit', 'min', 'max')
            if key in old and key in new and any(getattr(old[key], x, None) != getattr(new[key], x, None) for x in fields):
                issues.append(['dimension', sheet, kind, key])
    if set(a[sheet].tables) != set(b[sheet].tables):
        issues.append(['tables', sheet])
    for name in a[sheet].tables:
        old = table_definition(a, a[sheet].tables[name]).decode()
        expected = rename(old)
        if name == 'Contract_Edits':
            expected = expected.replace('name="0"', 'name="Paid"')
        if expected != table_definition(b, b[sheet].tables[name]).decode():
            issues.append(['table schema', sheet, name])
if a.sheetnames != b.sheetnames:
    issues.append(['sheet list'])
for field in ('codes', 'queries', 'paidValues', 'summaries'):
    if native['before'][field] != native['after'][field] or native['after'][field] != verified[field]:
        issues.append(['native result', field])
for sheet, old in native['before']['sheets'].items():
    new = verified['sheets'][sheet]
    for field in ('valueHash', 'errors', 'controls', 'range'):
        if old[field] != new[field]:
            issues.append(['native sheet', sheet, field])
if native['before']['names'] != verified['names']:
    expected = {k: rename(v) for k, v in native['before']['names'].items()}
    if expected != verified['names']:
        issues.append(['defined names'])
if verified['paidHeader'] != 'Paid' or verified['calcMode'] != -4105:
    issues.append(['header or automatic calculation'])
stale = []
for path in bz.namelist():
    if path.endswith('.xml'):
        txt = ET.tostring(ET.fromstring(bz.read(path)), encoding='unicode')
        if 'Contract_Edits[0]' in txt:
            stale.append(path)
    if path.startswith(('xl/media/', 'xl/externalLinks/')) and (path not in az.namelist() or az.read(path) != bz.read(path)):
        issues.append(['media or link', path])
if stale:
    issues.append(['stale reference', stale])
result = dict(passed=not issues, issues=issues, formulasUpdated=sum(map(len, changed.values())),
              changedCells=changed, paidRecords=len(verified['paidValues']),
              nativeSummaries=verified['summaries'], queriesUnchanged=True,
              errorsPreserved=sum(len(s['errors']) for s in verified['sheets'].values()))
evidence.write_text(json.dumps(result, indent=2), encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k != 'changedCells'}, indent=2))
sys.exit(bool(issues))
