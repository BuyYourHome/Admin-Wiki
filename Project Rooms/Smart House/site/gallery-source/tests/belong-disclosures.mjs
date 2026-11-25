import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createRequire} from 'node:module';
import ts from 'typescript';
import React from 'react';
import {renderToStaticMarkup} from 'react-dom/server';
import {openTargetDisclosures} from '../lib/pondster-disclosures.ts';
import {LIGHTING_SEED_SNAPSHOT} from '../lib/lighting-source-fallback.ts';
import {permitReferences} from '../lib/permits.ts';
import {equipmentManuals} from '../lib/equipment.ts';

const require=createRequire(import.meta.url);
for(const extension of ['.ts','.tsx'])require.extensions[extension]=(module,path)=>module._compile(ts.transpileModule(readFileSync(path,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,target:ts.ScriptTarget.ES2022,esModuleInterop:true}}).outputText,path);
require.extensions['.css']=()=>{};
const render=element=>renderToStaticMarkup(element);
const Card=require('../app/belong-card.tsx').default;
const native=render(React.createElement(Card,{id:'test-card',title:'My records',headingId:'test-heading'},React.createElement('p',null,'Record body')));
assert.match(native,/<details id="test-card"/);assert.match(native,/<summary><h2 id="test-heading">My records<\/h2><\/summary>/);
assert.doesNotMatch(native,/<details[^>]*\b(?:open|name)=/,'Cards start closed and are not an exclusive group.');
assert.doesNotMatch(native,/role="button"|tabindex=|aria-expanded=|onkeydown=/i,'Native summary owns semantics and keyboard behavior.');
for(const [module,expected] of [
 ['permits',['pondster-own-permits',...permitReferences.map(item=>'pondster-own-'+item.section)]],
 ['equipment-manuals',['pondster-own-maintenance',...equipmentManuals.map(item=>'pondster-own-'+item.id)]],
 ['led-strip-diagram',['pondster-own-led-strip-diagram']],
 ['lighting-diagram',['pondster-own-lighting-diagram']],
]){
 const View=require('../app/'+module+'.tsx').default,html=render(React.createElement(View));
 assert.match(html,/^<details/);assert.doesNotMatch(html,/<details[^>]*\bopen(?:=|>)/);
 for(const id of expected)assert.equal((html.match(new RegExp('id="'+id+'"','g'))??[]).length,1,id+' stays unique.');
 const headings=[...html.matchAll(/<h[23] id="([^"]+)"/g)].map(match=>match[1]);assert.equal(new Set(headings).size,headings.length,'No duplicate wrapper/content headings.');
}
const {LightingControlsView}=require('../app/lighting-controls.tsx');
const source={snapshot:LIGHTING_SEED_SNAPSHOT,sync:{status:'awaiting-sync',lastCheckedAt:null,lastSuccessAt:null},checking:false,failed:false};
const lighting=render(React.createElement(LightingControlsView,{source}));
assert.match(lighting,/^<details/);assert.doesNotMatch(lighting,/<details[^>]*\bclass="belong-card[^>]*\bopen(?:=|>)/);
assert.equal((lighting.match(/<details class="lighting-zone-details" data-pondster-open-with-target="true" open=""/g)??[]).length,2,'Source tables retain their prior expanded defaults and explicitly opt into a future destination reveal.');
for(const id of ['lighting-controls-heading','pondster-own-lighting-schedule','pondster-own-shelly-review'])assert.equal((lighting.match(new RegExp('id="'+id+'"','g'))??[]).length,1);
for(const group of LIGHTING_SEED_SNAPSHOT.groups)assert.ok(lighting.includes(group.id),'Source rows remain available behind the disclosure.');
assert.match(lighting,/My ordinary lighting groups/);assert.match(lighting,/My LED-strip zones/);
const opened=[];
function disclosure(label,parentElement,initial=false){let open=initial;return {tagName:'DETAILS',parentElement,querySelectorAll(){return[];},get open(){return open;},set open(value){open=value;opened.push(label+':'+value);}};}
const outer=disclosure('lighting',null),schedule=disclosure('schedule',outer),zone=disclosure('strip-zones',schedule),unrelated=disclosure('permits',null,true);
const target={tagName:'TR',parentElement:zone,querySelectorAll(){return[];}};
assert.equal(openTargetDisclosures(target),true);
assert.deepEqual(opened,['lighting:true','schedule:true','strip-zones:true'],'All ancestors open from outermost to innermost without measuring or clicking.');
assert.equal(unrelated.open,true,'Other open cards are not collapsed.');
assert.equal(openTargetDisclosures(target),false,'Repeated navigation is idempotent.');
const card=disclosure('camera',outer);assert.equal(openTargetDisclosures(card),true);assert.equal(card.open,true,'A details target opens itself too.');
const ordinary=disclosure('ordinary',schedule),closedOther=disclosure('other',schedule);
zone.open=false;schedule.querySelectorAll=selector=>{assert.equal(selector,'details[data-pondster-open-with-target]');return[ordinary,zone];};
assert.equal(openTargetDisclosures(schedule),true,'An explicit schedule reveal reopens source tables the visitor closed manually.');
assert.equal(ordinary.open,true);assert.equal(zone.open,true);assert.equal(closedOther.open,false,'An unmarked child stays closed.');
const css=readFileSync(new URL('../app/belong-card.css',import.meta.url),'utf8');assert.match(css,/:focus-visible/);assert.match(css,/\[open\]>summary/);
const page=readFileSync(new URL('../app/page.tsx',import.meta.url),'utf8');assert.match(page,/<BelongCard id="pondster-own-drawing"/);assert.match(page,/<BelongCard id=\{`pondster-own-\$\{section\}`\}/);
console.log('PASS: independently collapsed native Belong cards, preserved IDs/content/source rows, unique headings, focus styling and complete nested disclosure expansion before reveal.');
