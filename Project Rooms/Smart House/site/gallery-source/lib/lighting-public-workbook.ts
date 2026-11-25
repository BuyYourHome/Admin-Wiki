import { strToU8, zipSync } from 'fflate';
import { validateProjection, type LightingSnapshot } from './lighting-source-model';

const MAIN = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';
const REL = 'http://schemas.openxmlformats.org/officeDocument/2006/relationships';
const PKG_REL = 'http://schemas.openxmlformats.org/package/2006/relationships';
const XML = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';
type Value = string | number | null;

function xml(value: string): string {
  return value.replace(/[&<>"']/g, c => ({ '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&apos;' }[c]!));
}

function letter(index: number): string {
  let out = '';
  for (let n = index + 1; n; n = Math.floor((n - 1) / 26)) out = String.fromCharCode(65 + (n - 1) % 26) + out;
  return out;
}

function cell(ref: string, value: Value, style: number): string {
  if (value === null) return `<c r="${ref}" s="${style}"/>`;
  if (typeof value === 'number') return `<c r="${ref}" s="${style}" t="n"><v>${value}</v></c>`;
  // All labels are typed strings, including text beginning with '='; no formula execution.
  return `<c r="${ref}" s="${style}" t="inlineStr"><is><t xml:space="preserve">${xml(value)}</t></is></c>`;
}

interface Sheet {
  name: string;
  title: string;
  headers: string[];
  widths: number[];
  rows: Value[][];
  decimalColumns: number[];
  summary: string;
}

function worksheet(sheet: Sheet, snapshot: LightingSnapshot): string {
  const last = sheet.rows.length + 6, end = letter(sheet.headers.length - 1);
  const rows = [
    `<row r="2" ht="25" customHeight="1">${cell('A2', sheet.title, 1)}</row>`,
    `<row r="3" ht="20" customHeight="1">${cell('A3', 'Read-only extract. Edit the Teams source workbook to update Pondster.', 5)}</row>`,
    `<row r="4" ht="20" customHeight="1">${cell('A4', `Source updated: ${snapshot.sourceModifiedAt ?? 'date unavailable'}. Published: ${snapshot.publishedAt}.`, 5)}</row>`,
    `<row r="5" ht="20" customHeight="1">${cell('A5', `Publication revision: ${snapshot.revision}`, 5)}</row>`,
    `<row r="6" ht="36" customHeight="1">${sheet.headers.map((v, i) => cell(`${letter(i)}6`, v, 2)).join('')}</row>`,
  ];
  const planColumn = sheet.headers.indexOf('PWM output plan');
  sheet.rows.forEach((values, i) => rows.push(`<row r="${i + 7}" ht="${planColumn >= 0 && values[planColumn] ? 108 : 48}" customHeight="1">${values.map((value, j) => cell(`${letter(j)}${i + 7}`, value, typeof value === 'number' ? (!Number.isInteger(value) && sheet.decimalColumns.includes(j) ? (j === 4 ? 6 : 4) : 3) : 0)).join('')}</row>`));
  rows.push(`<row r="${last + 2}" ht="24" customHeight="1">${cell(`A${last + 2}`, sheet.summary, 5)}</row>`);
  rows.push(`<row r="${last + 3}" ht="24" customHeight="1">${cell(`A${last + 3}`, 'Blank quantities are unresolved. Explicit zero means no additional device. These are planning counts, not verified installed equipment.', 5)}</row>`);
  return `${XML}<worksheet xmlns="${MAIN}" xmlns:r="${REL}">`+
    `<dimension ref="A1:${end}${last + 3}"/><sheetViews><sheetView workbookViewId="0" showGridLines="0"><pane xSplit="2" ySplit="6" topLeftCell="C7" activePane="bottomRight" state="frozen"/><selection pane="bottomRight" activeCell="C7" sqref="C7"/></sheetView></sheetViews>`+
    `<sheetFormatPr defaultRowHeight="18"/><cols>${sheet.widths.map((width, i) => `<col min="${i+1}" max="${i+1}" width="${width}" customWidth="1"/>`).join('')}</cols><sheetData>${rows.join('')}</sheetData>`+
    `<mergeCells count="6"><mergeCell ref="A2:${end}2"/><mergeCell ref="A3:${end}3"/><mergeCell ref="A4:${end}4"/><mergeCell ref="A5:${end}5"/><mergeCell ref="A${last+2}:${end}${last+2}"/><mergeCell ref="A${last+3}:${end}${last+3}"/></mergeCells>`+
    '<pageMargins left="0.3" right="0.3" top="0.5" bottom="0.5" header="0.2" footer="0.2"/><pageSetup orientation="landscape" paperSize="3" scale="100"/>'+
    '<tableParts count="1"><tablePart r:id="rId1"/></tableParts></worksheet>';
}

function table(sheet: Sheet, id: number): string {
  const ref = `A6:${letter(sheet.headers.length - 1)}${sheet.rows.length + 6}`;
  return `${XML}<table xmlns="${MAIN}" id="${id}" name="LightingPublic${id}" displayName="LightingPublic${id}" ref="${ref}" totalsRowShown="0">`+
    `<autoFilter ref="${ref}"/><tableColumns count="${sheet.headers.length}">${sheet.headers.map((name, i) => `<tableColumn id="${i+1}" name="${xml(name)}"/>`).join('')}</tableColumns>`+
    '<tableStyleInfo name="TableStyleMedium2" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>';
}

const styles = `${XML}<styleSheet xmlns="${MAIN}">`+
  '<numFmts count="1"><numFmt numFmtId="164" formatCode="0.####"/></numFmts>'+
  '<fonts count="4"><font><sz val="11"/><name val="Arial"/></font><font><b/><sz val="15"/><name val="Arial"/></font><font><b/><sz val="12.75"/><color rgb="FFFFFFFF"/><name val="Arial"/></font><font><sz val="11"/><color rgb="FF52645C"/><name val="Arial"/></font></fonts>'+
  '<fills count="3"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill><fill><patternFill patternType="solid"><fgColor rgb="FF156082"/><bgColor indexed="64"/></patternFill></fill></fills>'+
  '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>'+
  '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'+
  '<cellXfs count="7">'+
  '<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf>'+
  '<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1"/>'+
  '<xf numFmtId="0" fontId="2" fillId="2" borderId="0" xfId="0" applyFont="1" applyFill="1" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf>'+
  '<xf numFmtId="1" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1" applyAlignment="1"><alignment horizontal="right" vertical="center"/></xf>'+
  '<xf numFmtId="164" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1" applyAlignment="1"><alignment horizontal="right" vertical="center"/></xf>'+
  '<xf numFmtId="0" fontId="3" fillId="0" borderId="0" xfId="0" applyFont="1" applyAlignment="1"><alignment vertical="center" wrapText="1"/></xf>'+
  '<xf numFmtId="2" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1" applyAlignment="1"><alignment horizontal="right" vertical="center"/></xf></cellXfs>'+
  '<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles><dxfs count="0"/><tableStyles count="0" defaultTableStyle="TableStyleMedium2" defaultPivotStyle="PivotStyleLight16"/></styleSheet>';

/** Worker-safe OOXML export from the validated public model, not the private workbook. */
export function generateLightingPublicWorkbook(input: LightingSnapshot): Uint8Array {
  const snapshot = validateProjection(input), t = snapshot.totals;
  const sheets: Sheet[] = [
    { name:'Circuit schedule', title:'Pondster lighting circuit schedule',
      headers:['Record ID','Room / control group','Light type','Light quantity','Manual switches','Smart device qty','Smart device / model','Additional relay qty','Additional relay / model','Load controller qty','Load controller / model','Manual remote qty','Input devices / wall stations qty','Input devices / wall stations model','PWM output qty','PWM output plan','Planning status'],
      widths:[12,31,28,15,17,18,45,20,38,20,38,20,20,38,18,72,18], decimalColumns:[],
      rows:snapshot.groups.map(g => [g.id,g.room,g.loadType,g.quantity,g.manualSwitches,g.smartDeviceQty,g.smartDeviceModel,g.additionalRelayQty,g.additionalRelayModel,g.loadControllerQty,g.loadControllerModel,g.manualRemoteQty,g.inputModuleQty,g.inputModuleModel,g.pwmOutputQty,g.pwmOutputPlan,g.controlStatus]),
      summary:`Known subtotals: ${t.primarySmartDevicesKnown} smart devices (${t.loadControllersKnown} explicit load controllers; ${t.inputModulesKnown} explicit input modules), ${t.additionalRelaysKnown} additional LOAD relays. Partial known roles are included even when the row total is unresolved.`,
    },
    { name:'Control specifications', title:'Pondster strip control specifications',
      headers:['Record ID','Room / control group','Strip allowance W','DC supply V','Estimated strip current A','Smart device qty','Smart device / model','Additional relay qty','Additional relay / model','Load controller qty','Load controller / model','Manual remote qty','Input devices / wall stations qty','Input devices / wall stations model','PWM output qty','PWM output plan','Planning status'],
      widths:[12,31,20,17,25,18,45,20,38,20,38,20,20,38,18,72,18], decimalColumns:[2,3,4],
      rows:snapshot.groups.filter(g=>g.kind==='strip').map(g => [g.id,g.room,g.stripWatts,g.voltage,g.stripWatts!==null&&g.voltage!==null?g.stripWatts/g.voltage:null,g.smartDeviceQty,g.smartDeviceModel,g.additionalRelayQty,g.additionalRelayModel,g.loadControllerQty,g.loadControllerModel,g.manualRemoteQty,g.inputModuleQty,g.inputModuleModel,g.pwmOutputQty,g.pwmOutputPlan,g.controlStatus]),
      summary:'Allocation assumes single-color, single-channel constant-voltage analog strips; confirm actual type and physical runs. PWM quantity counts separate outputs, not extra controllers. Never parallel PWM outputs; both controls must coordinate every assigned output.',
    },
  ];
  // A valid empty table still needs a data row when no strip zones are assigned.
  for (const sheet of sheets) if (!sheet.rows.length) sheet.rows.push(sheet.headers.map(()=>null));
  const parts: Record<string, Uint8Array> = {};
  const add = (name: string, text: string) => { parts[name] = strToU8(text); };
  add('[Content_Types].xml', `${XML}<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/>`+
    '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/><Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/><Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/><Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>'+
    sheets.map((_,i)=>`<Override PartName="/xl/worksheets/sheet${i+1}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/><Override PartName="/xl/tables/table${i+1}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.table+xml"/>`).join('')+'</Types>');
  add('_rels/.rels', `${XML}<Relationships xmlns="${PKG_REL}"><Relationship Id="rId1" Type="${REL}/officeDocument" Target="xl/workbook.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/><Relationship Id="rId3" Type="${REL}/extended-properties" Target="docProps/app.xml"/></Relationships>`);
  add('docProps/core.xml', `${XML}<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><dc:creator>Pondster</dc:creator><cp:lastModifiedBy>Pondster</cp:lastModifiedBy><dcterms:modified xsi:type="dcterms:W3CDTF">${xml(snapshot.publishedAt)}</dcterms:modified></cp:coreProperties>`);
  add('docProps/app.xml', `${XML}<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"><Application>Pondster</Application></Properties>`);
  add('xl/workbook.xml', `${XML}<workbook xmlns="${MAIN}" xmlns:r="${REL}"><bookViews><workbookView activeTab="0"/></bookViews><sheets>${sheets.map((s,i)=>`<sheet name="${xml(s.name)}" sheetId="${i+1}" r:id="rId${i+1}"/>`).join('')}</sheets><definedNames>${sheets.map((s,i)=>`<definedName name="_xlnm.Print_Titles" localSheetId="${i}">'${xml(s.name)}'!$6:$6,'${xml(s.name)}'!$A:$B</definedName>`).join('')}</definedNames><calcPr calcId="0" calcMode="auto"/></workbook>`);
  add('xl/_rels/workbook.xml.rels', `${XML}<Relationships xmlns="${PKG_REL}">${sheets.map((_,i)=>`<Relationship Id="rId${i+1}" Type="${REL}/worksheet" Target="worksheets/sheet${i+1}.xml"/>`).join('')}<Relationship Id="rId3" Type="${REL}/styles" Target="styles.xml"/></Relationships>`);
  add('xl/styles.xml', styles);
  sheets.forEach((sheet,i)=>{
    add(`xl/worksheets/sheet${i+1}.xml`, worksheet(sheet,snapshot));
    add(`xl/tables/table${i+1}.xml`, table(sheet,i+1));
    add(`xl/worksheets/_rels/sheet${i+1}.xml.rels`, `${XML}<Relationships xmlns="${PKG_REL}"><Relationship Id="rId1" Type="${REL}/table" Target="../tables/table${i+1}.xml"/></Relationships>`);
  });
  return zipSync(parts, { level: 6 });
}
