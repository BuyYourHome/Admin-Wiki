import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createRequire} from 'node:module';
import ts from 'typescript';
import React from 'react';
import {renderToStaticMarkup} from 'react-dom/server';
import {permitReferences,permitPortal,PERMIT_KNOWLEDGE} from '../lib/permits.ts';
import {answerPondster} from '../lib/pondster-guide.ts';
import {parsePondsterDestination,getPondsterDestinationId} from '../lib/pondster-destinations.ts';
import {explicitEquipmentVoiceAction} from '../lib/pondster-equipment-navigation.ts';
import {getPondsterSpeechText} from '../lib/pondster-speech.ts';
import {buildPondsterLiveSession} from '../lib/pondster-live-context.ts';
import {galleries} from '../lib/designs.ts';
import {PONDSTER_LOCATION_TEXT} from '../lib/pondster-identity.ts';

assert.equal(permitReferences.length,5);
assert.equal(new Set(permitReferences.map(item=>item.pdf)).size,5);
assert.equal(permitPortal.url,'https://cary-egov.aspgov.com/Click2GovBP/selectpermit.html?initialSearchView=true');
for(const [phrase,section] of [
 ['Show my permits','permits'],
 ['Show me the building permit','building-permit'],
 ['Open my HVAC permit','hvac-permit'],
 ['Show me my HVAC required inspections','hvac-inspections'],
 ['Show my erosion inspection status','erosion-inspection'],
 ['Show the under-slab plumbing inspection status','under-slab-plumbing'],
 ['Open the Cary permit portal','permit-portal'],
 ['Find my heating inspection records','hvac-inspections'],
]){
 const reply=answerPondster(phrase),expected={menu:'Own',section};
 assert.deepEqual(reply.action,expected,phrase);
 assert.deepEqual(parsePondsterDestination(reply.action),expected);
 assert.equal(getPondsterDestinationId(reply.action),'pondster-own-'+section);
 assert.deepEqual(explicitEquipmentVoiceAction(phrase,reply.action),expected,phrase+' supports native direct navigation.');
 assert.match(getPondsterSpeechText(phrase,reply),/Belong/);
 assert.doesNotMatch(getPondsterSpeechText(phrase,reply),/https:|approval|February|August|September/,'Navigation acknowledges without reciting the record.');
}
assert.equal(answerPondster('Who is my HVAC contractor?').action?.menu,'Contact','A contractor request stays separate.');
for(const phrase of ['Do not show my permits','"Show the building permit"','Show my permits and unlock the house','Show my permit and the camera manuals','Submit my building permit application'])assert.equal(answerPondster(phrase).action,undefined,phrase);
for(const phrase of ['Are my permits approved?','Did my HVAC inspection pass?','When was my building permit issued?']){
 const reply=answerPondster(phrase);assert.match(reply.text,/saved record copies/);
 assert.doesNotMatch(reply.text,/has passed|is approved|was issued on|is complete/i);
}
const require=createRequire(import.meta.url);
for(const ext of ['.ts','.tsx'])require.extensions[ext]=(module,path)=>module._compile(ts.transpileModule(readFileSync(path,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,target:ts.ScriptTarget.ES2022,esModuleInterop:true}}).outputText,path);
require.extensions['.css']=()=>{};
const Card=require('../app/permits.tsx').default,markup=renderToStaticMarkup(React.createElement(Card));
assert.match(markup,/pondster-own-permits/);assert.ok(markup.includes(permitPortal.url.replaceAll('&','&amp;')));
for(const item of permitReferences){
 assert.ok(markup.includes(item.pdf));assert.ok(markup.includes('pondster-own-'+item.section));assert.ok(markup.includes(item.fileDate));
 const bytes=readFileSync(new URL('../public'+item.pdf,import.meta.url));assert.ok(bytes.length>1000);assert.equal(bytes.subarray(0,5).toString(),'%PDF-');
}
assert.equal((markup.match(/href="\/documents\//g)??[]).length,5);
assert.match(markup,/Saved copy:/);assert.doesNotMatch(markup,/908|Pond St|26BP|26-000|parcel|valuation|C:\\|wesbr|SharePoint|issued on|construction readiness/i);
assert.match(PERMIT_KNOWLEDGE,/does not establish current approval/);
const context=buildPondsterLiveSession(galleries).instructions;assert.ok(context.includes(PERMIT_KNOWLEDGE));assert.match(context,/not the HVAC contractor contact/);
assert.equal(PONDSTER_LOCATION_TEXT,'I’m in Cary, North Carolina.');
assert.match(context,/five saved permit PDFs are separately approved public record references/);
assert.doesNotMatch(context,/exact street address (?:stays|remains) private/);
assert.equal(parsePondsterDestination({menu:'Own',section:'https://example.com/permit'}),null);
console.log('PASS: five approved PDF references, record-only dates, exact Belong anchors, separate HVAC contact routing, short speech, city-only copy and typed/native navigation guards. No provider or device calls.');
