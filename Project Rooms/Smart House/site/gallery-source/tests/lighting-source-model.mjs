import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import ts from 'typescript';
import { unzipSync, strFromU8 } from 'fflate';
import { parseLightingSource, validateProjection, deriveLightingTotals, generateLightingKnowledge } from '../lib/lighting-source-model.ts';
import { renderLightingReview } from '../lib/lighting-review-html.ts';

const meta={revision:'test-revision',sourceModifiedAt:'2026-11-25T08:57:58Z',publishedAt:'2026-11-25T10:00:00Z'};
const headers=['Record ID','Room / control group','Light type','Light quantity','Switch count¹','Switch reading','Breaker / panel circuit','Drawing evidence / items to confirm','Smart device qty','Smart device / model','Additional relay qty','Additional relay / model','Control note'];
const escape=v=>`"${String(v??'').replaceAll('"','""')}"`;
const csv=rows=>rows.map((row,i)=>[i,...row].map(escape).join(',')).join('\r\n');
function source(mainRows,detailRows=[['LS-011','Living room',145.8,'LV-A','','Shelly Plus RGBW PM',2,2,'private note']],voltage=12,mainHeaders=headers){
  return csv([['Pondster schedule','Unnamed: 1'],mainHeaders,...mainRows,[],['Total light fixtures','','',4]])+'\f'+
    csv([['Control specifications'],['Circuit','Area','Strip W','Typical','Wall control','Load controller','Controllers','Relays','Branch notes'],...detailRows,['Totals','','',null]])+'\f'+
    csv([['Strip load estimate'],['Supply voltage (V DC)','','','','','',voltage]]);
}
const main=[
  ['L-011','Living room, north','Recessed LED\n(R)',4,2,'','', 'notes stay private',1,'Shelly 1 Gen4 UL (US candidate)',0,'Included in smart module','This private\nnote is not published'],
  ['LS-011','Living room','LED Light Strips',3,1,'','','',2,'Shelly Plus RGBW PM',2,'Shelly 1 Gen4 UL (US candidate)','private notes'],
  ['L-018','Bedroom 1','Ceiling fan (light not specified)',1,1,'','','','TBD','Not selected','TBD','Not selected',''],
];
const result=parseLightingSource(source(main),meta);
assert.equal(result.groups.length,3);
assert.equal(result.groups[0].room,'Living room, north');
assert.equal(result.groups[0].loadType,'Recessed LED (R)');
assert.equal(result.groups[0].additionalRelayQty,0,'An integral relay is not an extra purchased relay.');
assert.equal(result.groups[0].additionalRelayModel,null);
assert.equal(result.groups[2].smartDeviceQty,null,'TBD is unresolved, not zero.');
assert.equal(result.groups[2].additionalRelayQty,null);
assert.equal(result.groups[2].kind,'other','A fan without a confirmed light does not inflate fixture counts.');
assert.equal(result.groups[1].stripWatts,145.8);
assert.equal(result.groups[1].voltage,12);
assert.equal(result.totals.fixtures,4);
assert.equal(result.totals.primarySmartDevicesKnown,3);
assert.equal(result.totals.additionalRelaysKnown,2);
assert.doesNotMatch(JSON.stringify(result),/private note|Unnamed|Switch reading|Breaker|Drawing evidence/);
assert.equal(validateProjection(result).groups[0].quantity,4);
assert.match(generateLightingKnowledge(result),/12\.15 amps/);
assert.match(generateLightingKnowledge(result),/not the current on the house AC supply/);
assert.match(generateLightingKnowledge(result),/additional relays 0/);
assert.doesNotMatch(generateLightingKnowledge(result),/private note/);
assert.equal(result.groups[0].loadControllerQty,null,'Older sources leave explicit roles unresolved, not zero.');
assert.equal(result.groups[0].inputModuleQty,null);

const roleHeaders=[...headers,'Load controller qty','Load controller / model','Manual remote qty','Input module qty','Input module / model'];
const roleRows=[
 ['L-011','Living room','Recessed LED',4,6,'','','',3,'1 x Shelly Plus Wall Dimmer; 2 x Shelly Plus i4',0,'Included in smart module','',1,'Shelly Plus Wall Dimmer',5,2,'Shelly Plus i4'],
 ['LS-011','Living room perimeter','LED strips',3,1,'','','',3,'2 x Shelly Plus RGBW PM; 1 x Shelly Plus i4',0,'None','',2,'Shelly Plus RGBW PM',1,1,'Shelly Plus i4'],
 ['L-018','Bedroom fan','Ceiling fan (light not specified)',1,1,'','','',1,'Shelly 1 Gen4 UL',0,'None','',1,'Shelly 1 Gen4 UL',0,0,'None'],
 ['LS-005','Bath strips','LED strips',1,'','','','','TBD','2 x Shelly Plus RGBW PM; input count TBD',0,'None','',2,'Shelly Plus RGBW PM','TBD','TBD','Shelly Plus i4'],
];
const roleResult=parseLightingSource(source(roleRows,undefined,12,roleHeaders),meta);
assert.equal(roleResult.groups[0].loadControllerQty,1);assert.equal(roleResult.groups[0].inputModuleQty,2);assert.equal(roleResult.groups[0].manualRemoteQty,5);
assert.equal(roleResult.groups[0].smartDeviceQty,3,'Load controller plus input modules is the total smart-device count.');
assert.equal(roleResult.groups[1].additionalRelayQty,0,'An input module is not another LOAD relay.');
assert.equal(roleResult.totals.analogControllers,4,'Typed controllers use explicit load quantities, including a partial-known row.');
assert.equal(roleResult.totals.loadControllersKnown,6);assert.equal(roleResult.totals.inputModulesKnown,3);assert.equal(roleResult.totals.primarySmartDevicesKnown,9,'Known roles survive a blank aggregate I cell.');
assert.equal(roleResult.totals.unresolvedInputModuleGroups,1);assert.equal(roleResult.groups[3].smartDeviceQty,null);assert.equal(roleResult.groups[3].controlStatus,'unresolved');
const roleKnowledge=generateLightingKnowledge(roleResult);assert.match(roleKnowledge,/input modules 2/);assert.match(roleKnowledge,/i4 input module does not switch/);
const roleHtml=renderLightingReview(roleResult);for(const group of roleResult.groups)assert.ok(roleHtml.includes(`id="control-plan-${group.id}"`),'Every group has a same-projection role diagram.');
assert.match(roleHtml,/Ordinary remote controls/);assert.match(roleHtml,/Assignments incomplete/);assert.match(roleHtml,/Additional LOAD relays/);
assert.ok(roleHtml.includes(meta.revision));
const wrongTotal=structuredClone(roleRows);wrongTotal[0][8]=2;assert.throws(()=>parseLightingSource(source(wrongTotal,undefined,12,roleHeaders),meta),/smart-device total/);
const wrongPartial=structuredClone(roleRows);wrongPartial[3][8]=1;assert.throws(()=>parseLightingSource(source(wrongPartial,undefined,12,roleHeaders),meta),/role quantity exceeds/);
const remoteExcess=structuredClone(roleRows);remoteExcess[0][15]=7;assert.throws(()=>parseLightingSource(source(remoteExcess,undefined,12,roleHeaders),meta),/manual remotes/);
const duplicateRoleHeaders=[...roleHeaders,'Load controller qty'];assert.throws(()=>parseLightingSource(source(roleRows,undefined,12,duplicateRoleHeaders),meta),/duplicate role column/);
const noLoadModel=structuredClone(roleRows);noLoadModel[0][14]='TBD';assert.equal(parseLightingSource(source(noLoadModel,undefined,12,roleHeaders),meta).groups[0].loadControllerModel,null,'Unknown model is not a fabricated zero device.');
const qualifiedLoad=structuredClone(roleRows);qualifiedLoad[1][14]='Shelly Plus RGBW PM (always powered; load review)';assert.equal(parseLightingSource(source(qualifiedLoad,undefined,12,roleHeaders),meta).totals.analogControllers,4,'Explicit load-model qualification notes do not invalidate its N quantity.');
const legacyMixed=structuredClone(main);legacyMixed[1][8]=3;legacyMixed[1][9]='2 x Shelly Plus RGBW PM; 1 x Shelly Plus i4';assert.equal(parseLightingSource(source(legacyMixed),meta).totals.analogControllers,0,'A legacy mixed bundle cannot be counted as three RGBW controllers.');

// Source quantities and new group IDs are allowed to change without hardcoded totals.
const changed=structuredClone(main);
changed[0][3]=7;changed[0][8]=2;changed[1][8]=3;changed[1][10]=0;
changed.push(['L-120','Deck lights','LED fixtures',5,3,'','','',1,'A suitable relay module',0,'None','']);
const next=parseLightingSource(source(changed,undefined,24),meta);
assert.equal(next.totals.fixtures,12);
assert.equal(next.totals.primarySmartDevicesKnown,6);
assert.equal(next.totals.additionalRelaysKnown,0);
assert.equal(next.groups.find(g=>g.id==='LS-011').voltage,24,'Use the explicit voltage cell, not a stale sheet title.');
assert.notDeepEqual(next.totals,result.totals);
const otherFan=structuredClone(main);otherFan[2][2]='Exhaust fan with light';
assert.equal(parseLightingSource(source(otherFan),meta).groups[2].kind,'fixture');

for(const [label,mutate]of[
  ['duplicate ID',rows=>rows.push([...rows[0]])],
  ['fractional device quantity',rows=>rows[0][8]=1.5],
  ['negative count',rows=>rows[0][10]=-1],
  ['private path in approved room',rows=>rows[0][1]='C:\\Private\\owner.xlsx'],
  ['address in approved room',rows=>rows[0][1]='123 Example Street'],
  ['email in approved model',rows=>rows[0][9]='owner@example.invalid'],
  ['phone in approved model',rows=>rows[0][9]='919-555-0100'],
  ['HTML in approved model',rows=>rows[0][9]='<img src=x onerror=run()>'],
]){const rows=structuredClone(main);mutate(rows);assert.throws(()=>parseLightingSource(source(rows),meta),/Lighting source:/,label);}
assert.throws(()=>parseLightingSource(source([...main,main[0]]),meta),/duplicate/);
assert.throws(()=>parseLightingSource(source(main)+'\f'+source(main),meta),/Lighting source:/);
assert.throws(()=>parseLightingSource('"unterminated',meta),/unterminated/);
assert.throws(()=>parseLightingSource(source(main),{...meta,revision:'https://private.invalid'}),/revision/);
const badTotals=structuredClone(result);badTotals.totals.primarySmartDevicesKnown=999;
assert.throws(()=>validateProjection(badTotals),/inconsistent derived totals/);
const excess=structuredClone(result);excess.sourcePath='private-path';assert.throws(()=>validateProjection(excess),/unexpected projection/);
const unsafeModel=structuredClone(result);unsafeModel.groups[0].smartDeviceModel='file:///private/owner.xlsx';
assert.throws(()=>validateProjection(unsafeModel),/unsafe/);

// Production exporter is transpiled only for this Node test; the app bundler resolves TS.
const modelUrl=new URL('../lib/lighting-source-model.ts',import.meta.url).href;
const exporterSource=(await fs.readFile(new URL('../lib/lighting-public-workbook.ts',import.meta.url),'utf8'))
  .replace("'./lighting-source-model'",JSON.stringify(modelUrl))
  .replace("'fflate'",JSON.stringify(import.meta.resolve('fflate')));
const exporterJs=ts.transpileModule(exporterSource,{compilerOptions:{target:ts.ScriptTarget.ES2022,module:ts.ModuleKind.ESNext}}).outputText;
const {generateLightingPublicWorkbook}=await import('data:text/javascript;base64,'+Buffer.from(exporterJs).toString('base64'));
const bytes=generateLightingPublicWorkbook(result),parts=unzipSync(bytes);
const roleWorkbookXml=Object.values(unzipSync(generateLightingPublicWorkbook(roleResult))).map(bytes=>strFromU8(bytes)).join('\n');
assert.match(roleWorkbookXml,/Load controller qty/);assert.match(roleWorkbookXml,/Input module qty/);assert.match(roleWorkbookXml,/Manual remote qty/);assert.match(roleWorkbookXml,/Shelly Plus Wall Dimmer/);assert.ok(roleWorkbookXml.includes(meta.revision));
assert.ok(bytes.length>1000);
assert.equal(Object.keys(parts).filter(p=>/^xl\/worksheets\/sheet\d+\.xml$/.test(p)).length,2);
const xml=Object.values(parts).map(bytes=>strFromU8(bytes)).join('\n');
assert.doesNotMatch(xml,/<f\b|private note|sourcePath|externalLink|customXml|printerSettings/);
assert.match(xml,/LightingPublic1/);
assert.ok(xml.includes(meta.revision),'The public workbook identifies the same snapshot revision as JSON and HTML.');
assert.match(strFromU8(parts['xl/worksheets/sheet1.xml']),/<c r="H7" s="3" t="n"><v>0<\/v><\/c>/);
assert.match(strFromU8(parts['xl/worksheets/sheet1.xml']),/<c r="F9" s="0"\/>/,'Unknown quantities remain blank in the public XLSX.');
const formulaLabel=structuredClone(result);formulaLabel.groups[0].smartDeviceModel='=2+2';
const formulaXml=Object.values(unzipSync(generateLightingPublicWorkbook(formulaLabel))).map(bytes=>strFromU8(bytes)).join('\n');
assert.match(formulaXml,/t="inlineStr"><is><t[^>]*>=2\+2/);
assert.doesNotMatch(formulaXml,/<f\b/,'A label cannot become an Excel formula.');
assert.deepEqual(deriveLightingTotals(result.groups),result.totals);

// Optional exact connector fixture lives outside Git. The generated model is public-only.
const fixtureIndex=process.argv.indexOf('--fixture');
if(fixtureIndex>=0){
 const actual=parseLightingSource(await fs.readFile(process.argv[fixtureIndex+1],'utf8'),meta);
 assert.equal(actual.groups.length,25);assert.equal(actual.totals.fixtures,46);
 assert.equal(actual.totals.primarySmartDevicesKnown,27);assert.equal(actual.totals.additionalRelaysKnown,13);
 assert.equal(actual.groups.find(g=>g.id==='L-011').additionalRelayQty,0);
 assert.equal(actual.groups.find(g=>g.id==='LS-011').voltage,12);
 const outputIndex=process.argv.indexOf('--workbook');
 if(outputIndex>=0)await fs.writeFile(process.argv[outputIndex+1],generateLightingPublicWorkbook(actual));
}
console.log('PASS: quoted multi-sheet CSV, current and changed quantities, unknown versus zero, field privacy and duplicate guards, derived knowledge and public two-tab XLSX. No connector or device calls.');
