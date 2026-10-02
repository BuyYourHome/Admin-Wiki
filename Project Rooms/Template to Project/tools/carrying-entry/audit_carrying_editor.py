"""Read-only whole-workbook preservation audit for the Carrying editor addition."""
import collections
import json
import posixpath
import sys
import zipfile
from xml.etree import ElementTree as ET

import openpyxl
from openpyxl.formula.translate import Translator

NS={'s':'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
RID='{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id'

def load(path):
    w=openpyxl.load_workbook(path,keep_vba=True)
    z=zipfile.ZipFile(path)
    assert z.testzip() is None
    wb=ET.fromstring(z.read('xl/workbook.xml'))
    rels={r.get('Id'):posixpath.normpath('xl/'+r.get('Target')) for r in ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))}
    ss=[''.join(s.itertext()) for s in ET.fromstring(z.read('xl/sharedStrings.xml'))]
    cells={}
    for s in wb.find('s:sheets',NS):
        root=ET.fromstring(z.read(rels[s.get(RID)]));data={};anchors={}
        for c in root.findall('s:sheetData/s:row/s:c',NS):
            f=c.find('s:f',NS);v=c.find('s:v',NS);value=v.text if v is not None else None
            if c.get('t')=='s' and value is not None:value=ss[int(value)]
            if c.get('t')=='inlineStr':value=''.join(c.find('s:is',NS).itertext())
            data[c.get('r')]=(f.text if f is not None else None,value,c.get('t'),int(c.get('s','0')))
            if f is not None and f.get('t')=='shared' and f.text:anchors[f.get('si')]=(c.get('r'),f.text)
        for c in root.findall('s:sheetData/s:row/s:c',NS):
            f=c.find('s:f',NS)
            if f is not None and f.get('t')=='shared' and not f.text:
                origin,text=anchors[f.get('si')]
                data[c.get('r')]=(Translator('='+text,origin=origin).translate_formula(c.get('r'))[1:],*data[c.get('r')][1:])
        cells[s.get('name')]=data
    return w,z,cells

def style(w,i):
    s=w._cell_styles[i]
    fmt=w._number_formats[s.numFmtId-164] if s.numFmtId>=164 else s.numFmtId
    return (w._fonts[s.fontId],w._fills[s.fillId],w._borders[s.borderId],w._alignments[s.alignmentId],w._protections[s.protectionId],fmt)

layout_only='--layout-only' in sys.argv
context_box='--context-box' in sys.argv
orange_grid='--orange-grid' in sys.argv
a,az,ac=load(sys.argv[1]);b,bz,bc=load(sys.argv[2]);issues=[]
assert a.sheetnames==b.sheetnames
for name,cells in ac.items():
    for addr,v in cells.items():
        n=bc[name].get(addr,(None,None,None,0))
        row,col=openpyxl.utils.cell.coordinate_to_tuple(addr)
        if context_box and name=='Carrying' and row<=2 and 23<=col<=36:continue
        if (v[0] if v[0] is not None else v[1])!=(n[0] if n[0] is not None else n[1]):issues.append(['content',name,addr])
        sa,sb=style(a,v[3]),style(b,n[3])
        if orange_grid and name=='Carrying' and 7<=row<=31 and col<=36:
            sa=sa[:1]+sa[2:];sb=sb[:1]+sb[2:]
            if style(b,n[3])[1]!=style(a,ac['Carrying']['H11'][3])[1]:issues.append(['orange fill',name,addr])
        if sa!=sb:issues.append(['style',name,addr])
    for addr,v in bc[name].items():
        if context_box and name=='Carrying' and addr=='W1':continue
        if addr not in cells and (v[0] is not None or v[1] is not None):issues.append(['new cell',name,addr])
    for attr in ('merged_cells','page_setup','page_margins','print_options','data_validations','freeze_panes','print_area'):
        if context_box and name=='Carrying' and attr=='merged_cells':
            if set(map(str,b[name].merged_cells.ranges))-set(map(str,a[name].merged_cells.ranges))!={'W1:AJ2'}:issues.append(['context merge'])
            if set(map(str,a[name].merged_cells.ranges))-set(map(str,b[name].merged_cells.ranges)):issues.append(['removed merge'])
            continue
        if getattr(a[name],attr)!=getattr(b[name],attr):issues.append(['layout',name,attr])
    if set(a[name].tables)!=set(b[name].tables):issues.append(['tables',name])
    for tn in a[name].tables:
        t=a[name].tables[tn]
        other=b[name].tables[tn]
        if t.ref!=other.ref or [c.name for c in t.tableColumns]!=[c.name for c in other.tableColumns]:issues.append(['table schema',tn])
    for col,d in a[name].column_dimensions.items():
        if layout_only and name=='Carrying' and d.min<=36:continue
        other=b[name].column_dimensions.get(col)
        if other is None or (d.width,d.hidden,d.outlineLevel)!=(other.width,other.hidden,other.outlineLevel):issues.append(['column',name,col])
    for row,d in a[name].row_dimensions.items():
        other=b[name].row_dimensions[row]
        if (d.height,d.hidden,d.outlineLevel)!=(other.height,other.hidden,other.outlineLevel):issues.append(['row',name,row])
    for key,n in a[name].defined_names.items():
        if key not in b[name].defined_names or n.attr_text!=b[name].defined_names[key].attr_text:issues.append(['sheet name',name,key])
for key,n in a.defined_names.items():
    if key not in b.defined_names or n.attr_text!=b.defined_names[key].attr_text:issues.append(['name',key])
assert set(b.defined_names)-set(a.defined_names)==({'ceButtonContext'} if context_box else set() if layout_only else {'ceEditActive','ceEditGrid','ceEditHeaders','ceEditVersion'})
if not layout_only:assert b.defined_names['ceEditActive'].attr_text=='FALSE'
for addr in ('B29','E29','H29','K29','N29','Q29','T29','W29','Z29','AC29','AF29','AI29'):
    if ac['Carrying'].get(addr,(None,None))[1]!=bc['Carrying'].get(addr,(None,None))[1]:issues.append(['total',addr])
if abs(float(ac['Profit']['B43'][1])-float(bc['Profit']['B43'][1]))>.000001:issues.append(['Profit total'])
old_errors={(s,c,v[1]) for s,cells in ac.items() for c,v in cells.items() if v[2]=='e'}
new_errors={(s,c,v[1]) for s,cells in bc.items() for c,v in cells.items() if v[2]=='e'}
if new_errors-old_errors:issues.append(['new errors',sorted(new_errors-old_errors)])
if any(n.startswith('xl/externalLinks/') for n in bz.namelist()):issues.append(['external links'])

def controls(z):
    result=collections.Counter()
    for path in z.namelist():
        if path.startswith('xl/ctrlProps/') and path.endswith('.xml'):
            root=ET.fromstring(z.read(path))
            # Only the two original Carrying button actions are intentionally redirected.
            macro=root.get('macro','')
            for new,old in [('CarryingEdit_InsertGuard','CarryingEntry_Insert'),('CarryingEdit_RecurringGuard','CarryingEntry_Recurring')]:
                macro=macro.replace(new,old)
            if 'macro' in root.attrib:root.set('macro',macro)
            result[ET.tostring(root)]+=1
    return result
if controls(az)-controls(bz):issues.append(['original controls changed'])
print(json.dumps({'issues':issues[:30],'issueCount':len(issues),'records':56,'originalErrors':len(old_errors),'remainingErrors':len(new_errors),'profitTotal':bc['Profit']['B43'][1]},indent=2))
sys.exit(bool(issues))
