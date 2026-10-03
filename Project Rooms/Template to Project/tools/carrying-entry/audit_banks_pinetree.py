"""Read-only full-workbook audit for the separately approved Banks/Pinetree installs."""
import ast
import json
import pathlib
import re
import sys

# Reuse the established raw-XML/style readers without executing its rollout CLI.
helper = pathlib.Path(__file__).with_name('audit_full_carrying.py')
tree = ast.parse(helper.read_text(encoding='utf-8-sig'))
definitions = []
for node in tree.body:
    if isinstance(node, ast.Assign) and any(isinstance(t, ast.Tuple) for t in node.targets):
        break
    definitions.append(node)
exec(compile(ast.Module(body=definitions, type_ignores=[]), str(helper), 'exec'))

source, output, evidence, project = sys.argv[1:5]
a, az, ac = load(source)
b, bz, bc = load(output)
banks = project == 'Banks'
issues = []

def address(addr, sheet):
    if banks and sheet == 'Profit':
        col, row = re.fullmatch(r'([A-Z]+)(\d+)', addr).groups()
        return col + str(int(row) + (int(row) >= 41))
    return addr

def formula(f, sheet):
    if not f or not banks:
        return f
    tokens = Tokenizer('=' + f).items
    for t in tokens:
        if t.type != 'OPERAND' or t.subtype != 'RANGE':
            continue
        parts = t.value.rsplit('!', 1)
        target = parts[0].strip("'") if len(parts) == 2 else sheet
        prefix = parts[0] + '!' if len(parts) == 2 else ''
        if target == 'Carrying' and prefix:
            prefix = "'Carrying - Old'!"
        ref = parts[-1]
        if target == 'Profit':
            ref = re.sub(r'(\$?[A-Z]{1,3}\$?)(\d+)', lambda m: m[1] + str(int(m[2]) + (int(m[2]) >= 41)), ref)
        t.value = prefix + ref
    return ''.join(t.value for t in tokens)

def normal(f):
    if f is None:
        return None
    return [(t.type,t.subtype,t.value) for t in Tokenizer('='+f).items if t.type!='WHITE-SPACE']

expected_sheets = a.sheetnames.copy()
if banks:
    pos = expected_sheets.index('Carrying')
    expected_sheets[pos:pos+1] = ['Carrying - Old','Carrying']
else:
    expected_sheets.insert(expected_sheets.index('Review')+1, 'Carrying')
if b.sheetnames != expected_sheets:
    issues.append(['sheet order'])
for sheet, cells in ac.items():
    dest = 'Carrying - Old' if banks and sheet=='Carrying' else sheet
    seen = set()
    for addr, old in cells.items():
        newaddr = address(addr, sheet); seen.add(newaddr)
        new = bc[dest].get(newaddr, (None,None,None,0))
        mapped = banks and sheet=='Profit' and (newaddr in ['B'+str(r) for r in range(31,43)] or newaddr=='B43')
        if not mapped:
            if old[0] is not None:
                if normal(formula(old[0],sheet)) != normal(new[0]): issues.append(['formula',sheet,addr,newaddr,old[0],new[0]])
            elif old[1] != new[1]: issues.append(['value',sheet,addr,newaddr,old[1],new[1]])
        if style(a,old[3]) != style(b,new[3]): issues.append(['style',sheet,addr,newaddr])
    for addr, value in bc[dest].items():
        if banks and sheet=='Profit' and coordinate_to_tuple(addr)[0]==41: continue
        if addr not in seen and (value[0] is not None or value[1] is not None): issues.append(['new cell',dest,addr])
    for attr in ('page_setup','page_margins','print_options','freeze_panes','print_area'):
        if banks and sheet=='Profit' and attr=='print_area': continue
        if getattr(a[sheet],attr) != getattr(b[dest],attr): issues.append(['setting',dest,attr])
    if set(a[sheet].tables) != set(b[dest].tables): issues.append(['table names',sheet])
    for name in a[sheet].tables:
        if table_definition(a,a[sheet].tables[name]) != table_definition(b,b[dest].tables[name]): issues.append(['table definition',sheet,name])
    if not (banks and sheet=='Profit') and a[sheet].merged_cells != b[dest].merged_cells: issues.append(['merges',sheet])
    for key, dim in a[sheet].column_dimensions.items():
        newer=b[dest].column_dimensions.get(key)
        if newer is None or any(getattr(dim,k)!=getattr(newer,k) for k in ('width','hidden','min','max','outlineLevel')): issues.append(['column dimensions',sheet,key])
    for key, dim in a[sheet].row_dimensions.items():
        newer=b[dest].row_dimensions.get(key+(1 if banks and sheet=='Profit' and key>=41 else 0))
        if newer is None or any(getattr(dim,k)!=getattr(newer,k) for k in ('height','hidden','outlineLevel')): issues.append(['row dimensions',sheet,key])
    if not (banks and sheet=='Profit'):
        before=[d.to_tree() for d in a[sheet].data_validations.dataValidation]
        after=[d.to_tree() for d in b[dest].data_validations.dataValidation]
        if sheet=='Review':
            for d in before:
                if d.get('sqref')=='B5:B217':
                    f=d.find('formula1')
                    if f is not None and 'Carrying' not in f.text: f.text=f.text[:-1]+',Carrying"'
        if [ET.tostring(d) for d in before]!=[ET.tostring(d) for d in after]: issues.append(['validation',sheet])

for name, old in a.defined_names.items():
    if name not in b.defined_names or normal(formula(old.attr_text,''))!=normal(b.defined_names[name].attr_text): issues.append(['name',name])

old_errors={(('Carrying - Old' if banks and s=='Carrying' else s),address(c,s),v[1]) for s,cells in ac.items() for c,v in cells.items() if v[2]=='e'}
new_errors={(s,c,v[1]) for s,cells in bc.items() for c,v in cells.items() if v[2]=='e'}
if new_errors-old_errors: issues.append(['new errors',sorted(new_errors-old_errors)])
if any(p.startswith('xl/externalLinks/') for p in bz.namelist()): issues.append(['external links'])
if b.calculation.calcMode not in ('auto',None): issues.append(['calculation'])
for path in az.namelist():
    if path.startswith('xl/media/') and (path not in bz.namelist() or az.read(path)!=bz.read(path)): issues.append(['media',path])

mapped = json.loads((pathlib.Path(evidence).parent/'record-map.json').read_text(encoding='utf-8-sig')) if banks else []
table = b['Carrying'].tables['tblCarryingExpenses']
left, top, right, bottom = range_boundaries(table.ref)
actual = []
for r in range(top+1,bottom+1):
    row=[bc['Carrying'].get(get_column_letter(c)+str(r),(None,None))[1] for c in range(left,right+1)]
    if any(x is not None for x in row): actual.append(row)
if len(actual)!=len(mapped): issues.append(['record count',len(actual),len(mapped)])
for i,(row, rec) in enumerate(zip(actual,mapped)):
    expected=['Yes',rec['category'],rec['date'],rec['vendor'],'Legacy '+rec['category']+' entry',rec['amount'],'Legacy Grid Snapshot',None,pathlib.Path(source).name,'Missing Data' if rec['date'] is None else 'Migrated Snapshot']
    for c,value in enumerate(expected):
        observed=row[c]
        if isinstance(value,(int,float)):
            equal=observed is not None and abs(float(observed)-value)<.000001
        else: equal=value==observed or (c==7 and value is None and observed=='')
        if not equal: issues.append(['record',i,c,value,observed])
    if rec['dateCell']+':'+rec['amountCell'] not in row[10]: issues.append(['source trace',i])

result=dict(project=project,issueCount=len(issues),issues=issues[:100],records=len(actual),originalErrors=len(old_errors),remainingErrors=len(new_errors),profit=bc['Profit']['B43' if banks else 'B42'][1])
pathlib.Path(evidence).write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result,indent=2))
sys.exit(bool(issues))
