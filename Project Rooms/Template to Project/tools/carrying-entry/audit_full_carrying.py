"""Read-only independent preservation audit of a mapped Carrying update."""
import collections
import json
import pathlib
import posixpath
import re
import sys
import warnings
import zipfile
from xml.etree import ElementTree as ET

import openpyxl
from openpyxl.formula import Tokenizer
from openpyxl.formula.translate import Translator
from openpyxl.utils import get_column_letter, column_index_from_string
from openpyxl.utils.cell import coordinate_to_tuple, range_boundaries

warnings.filterwarnings('ignore', category=UserWarning, module='openpyxl')
NS={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
RID='{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id'

def load(path):
    w=openpyxl.load_workbook(path,keep_vba=True)
    z=zipfile.ZipFile(path)
    assert z.testzip() is None
    root=ET.fromstring(z.read('xl/workbook.xml'))
    rel={r.get('Id'):posixpath.normpath('xl/'+r.get('Target')) for r in ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))}
    ss=[''.join(s.itertext()) for s in ET.fromstring(z.read('xl/sharedStrings.xml'))]
    result={}
    for sheet in root.find('s:sheets',NS):
        xml=ET.fromstring(z.read(rel[sheet.get(RID)])); cells={};shared={}
        for c in xml.findall('s:sheetData/s:row/s:c',NS):
            f=c.find('s:f',NS);v=c.find('s:v',NS);value=v.text if v is not None else None
            if c.get('t')=='s' and value is not None:value=ss[int(value)]
            if c.get('t')=='inlineStr':value=''.join(c.find('s:is',NS).itertext())
            cells[c.get('r')]=(f.text if f is not None else None,value,c.get('t'),int(c.get('s','0')))
            if f is not None and f.get('t')=='shared' and f.text:shared[f.get('si')]=(c.get('r'),f.text)
        for c in xml.findall('s:sheetData/s:row/s:c',NS):
            f=c.find('s:f',NS)
            if f is not None and f.get('t')=='shared' and not f.text:
                origin,txt=shared[f.get('si')]
                cells[c.get('r')]=(Translator('='+txt,origin=origin).translate_formula(c.get('r'))[1:],*cells[c.get('r')][1:])
        result[sheet.get('name')]=cells
    return w,z,result

def style(w,i):
    x=w._cell_styles[i]
    fmt=w._number_formats[x.numFmtId-164] if x.numFmtId>=164 else x.numFmtId
    return (w._fonts[x.fontId],w._fills[x.fillId],w._borders[x.borderId],w._alignments[x.alignmentId],w._protections[x.protectionId],fmt)

def table_definition(w,t):
    root=t.to_tree()
    for node in root.iter():
        for key,value in list(node.attrib.items()):
            if key.lower().endswith('dxfid'):
                node.set(key,ET.tostring(w._differential_styles.styles[int(value)].to_tree(),encoding='unicode'))
    return ET.tostring(root)

source,output,inventory,evidence=map(pathlib.Path,sys.argv[1:5])
m=json.loads(inventory.read_text(encoding='utf-8'))[source.name]
shift=2 if m['header']==5 else 0

def moved_ref(ref):
    parts=[]
    for part in ref.split(':'):
        a=re.fullmatch(r'(\$?)([A-Z]{1,3})(\$?)(\d+)',part)
        if not a:return ref
        c=column_index_from_string(a[2]);r=int(a[4])
        rr=r+shift
        if shift and 38<=c<=48 and r>2:
            if r in m['zeros']:return None
            rr-=sum(z<r for z in m['zeros'])
        parts.append(a[1]+get_column_letter(c+3 if shift and c>=37 else c)+a[3]+str(rr))
    return ':'.join(parts)

def moved_formula(f,sheet):
    if not f:return f
    tok=Tokenizer('='+f).items
    for t in tok:
        if t.type=='OPERAND' and t.subtype=='RANGE':
            p=t.value.rsplit('!',1);target=p[0].strip("'") if len(p)==2 else sheet
            if target=='Carrying':t.value=('!'.join(p[:-1])+'!' if len(p)==2 else '')+(moved_ref(p[-1]) or '#REF!')
    return ''.join(t.value for t in tok)

def equivalent(a,b):
    if a==b:return True
    if a is None or b is None:return False
    try:return [(t.type,t.subtype,t.value) for t in Tokenizer('='+a).items if t.type!='WHITE-SPACE']==[(t.type,t.subtype,t.value) for t in Tokenizer('='+b).items if t.type!='WHITE-SPACE']
    except Exception:return False

a,az,ac=load(source);b,bz,bc=load(output);issues=[]
if a.sheetnames!=b.sheetnames:issues.append(['sheet list'])
for name,cells in ac.items():
    if name=='Carrying':continue
    for addr,old in cells.items():
        new=bc[name].get(addr,(None,None,None,0))
        if old[0] is not None:
            if not equivalent(moved_formula(old[0],name),new[0]):issues.append(['formula',name,addr])
        elif old[1]!=new[1] and not (old[1] is None and new[1] is None):issues.append(['value',name,addr])
        if style(a,old[3])!=style(b,new[3]):issues.append(['style',name,addr])
    for addr,v in bc[name].items():
        if addr not in cells and (v[0] is not None or v[1] is not None):issues.append(['new cell',name,addr])
    for attr in ('merged_cells','page_setup','page_margins','print_options','data_validations','freeze_panes','print_area'):
        if getattr(a[name],attr)!=getattr(b[name],attr):issues.append(['sheet setting',name,attr])
    if set(a[name].tables)!=set(b[name].tables):issues.append(['tables',name])
    for table in a[name].tables:
        if table_definition(a,a[name].tables[table])!=table_definition(b,b[name].tables[table]):issues.append(['table definition',name,table])

# Every source record is checked independently, including excluded/blank/formula fields.
oldtable=a['Carrying'].tables['tblCarryingExpenses'];newtable=b['Carrying'].tables['tblCarryingExpenses']
left,top,right,end=range_boundaries(oldtable.ref);nl,nt,nr,ne=range_boundaries(newtable.ref)
if ne-nt != end-top-len(m['zeros']):issues.append(['record count'])
if [c.name for c in oldtable.tableColumns]!=[c.name for c in newtable.tableColumns]:issues.append(['table schema'])
index=0
for r in range(top+1,end+1):
    if r in m['zeros']:continue
    index+=1
    for c in range(left,right+1):
        addr=get_column_letter(c)+str(r);dest=get_column_letter(nl+c-left)+str(nt+index)
        old=ac['Carrying'].get(addr,(None,None,None,0));new=bc['Carrying'].get(dest,(None,None,None,0))
        expected=old[1]
        if c==left+1 and expected=='Casa Lending':expected='Refinance'
        if c==left+3 and not (expected or '').strip():expected=ac['Carrying'][get_column_letter(left+1)+str(r)][1]
        if old[0] is not None:
            if not equivalent(moved_formula(old[0],'Carrying'),new[0]):issues.append(['record formula',addr,dest])
        elif expected!=new[1] and not (expected in (None,'') and new[1] in (None,'')):issues.append(['record value',addr,dest,expected,new[1]])
        if style(a,old[3])!=style(b,new[3]):issues.append(['record style',addr,dest])

for k,n in a.defined_names.items():
    if k.startswith('ce'):continue
    if k not in b.defined_names or not equivalent(moved_formula(n.attr_text,''),b.defined_names[k].attr_text):issues.append(['name',k])
for field in ['Date','Category','Vendor','Description','Amount','Include','Invoice','Source','SourceFile','Status','Notes']:
    oldaddr=list(a.defined_names['ce'+field].destinations)[0][1].replace('$','')
    newaddr=list(b.defined_names['ce'+field].destinations)[0][1].replace('$','')
    old=ac['Carrying'].get(oldaddr,(None,None));new=bc['Carrying'].get(newaddr,(None,None))
    expected='Refinance' if field=='Category' and old[1]=='Casa Lending' else old[1]
    if old[0]!=new[0] or expected!=new[1]:issues.append(['pending form',field,old,new])
footer=m['footer']+shift
for g in m['grid']:
    addr=get_column_letter(g['col']+1)+str(footer)
    if abs(float(bc['Carrying'][addr][1])-float(g['total']))>0.000001:issues.append(['category total',g['category']])
    for addr,f in g['thirdColumn'].items():
        newaddr=moved_ref(addr);old=ac['Carrying'][addr];new=bc['Carrying'].get(newaddr,(None,None))
        if old[0] is not None:
            if not equivalent(moved_formula(old[0],'Carrying'),new[0]):issues.append(['escrow formula',addr])
        elif old[1]!=new[1]:issues.append(['escrow value',addr])
if abs(float(ac['Profit']['B43'][1])-float(bc['Profit']['B43'][1]))>0.000001:issues.append(['Profit total'])
old_errors={(s,moved_ref(c) if s=='Carrying' else c,v[1]) for s,cells in ac.items() for c,v in cells.items() if v[2]=='e'}
new_errors={(s,c,v[1]) for s,cells in bc.items() for c,v in cells.items() if v[2]=='e'}
if new_errors-old_errors:issues.append(['new errors',sorted(new_errors-old_errors)])
if any(p.startswith('xl/externalLinks/') for p in bz.namelist()):issues.append(['external links'])
if b.calculation.calcMode not in ('auto',None):issues.append(['calculation'])
for path in az.namelist():
    if path.startswith('xl/media/') and (path not in bz.namelist() or az.read(path)!=bz.read(path)):issues.append(['media',path])
result=dict(file=source.name,issueCount=len(issues),issues=issues[:80],records=ne-nt,originalErrors=len(old_errors),remainingErrors=len(new_errors),expenseTotal=bc['Profit']['B43'][1])
evidence.write_text(json.dumps(result,indent=2),encoding='utf-8');print(json.dumps(result,indent=2))
sys.exit(bool(issues))
