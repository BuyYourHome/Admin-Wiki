import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import ts from 'typescript';
import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { answerPondster } from '../lib/pondster-guide.ts';
import { getPondsterDestinationId, parsePondsterDestination } from '../lib/pondster-destinations.ts';
import { explicitEquipmentVoiceAction } from '../lib/pondster-equipment-navigation.ts';
import { getPondsterSpeechText } from '../lib/pondster-speech.ts';
import { buildPondsterLiveSession } from '../lib/pondster-live-context.ts';
import { galleries } from '../lib/designs.ts';
import { lightingDocuments } from '../lib/lighting-controls.ts';
import { lightingDiagram } from '../lib/lighting-diagram.ts';
import { LIGHTING_SEED_SNAPSHOT } from '../lib/lighting-source-fallback.ts';
import { deriveLightingTotals, generateLightingKnowledge, validateProjection } from '../lib/lighting-source-model.ts';
import { getLightingSourceState, refreshLightingSource, lightingSourceStatus, subscribeLightingSource } from '../lib/lighting-source-client.ts';

for(const [section,phrases] of [
 ['lighting-schedule',['Show me the lighting circuit schedule','Open the electrical schedule','Where is the lighting spreadsheet?','Show me the spreadsheet','Show my lighting zones','Find my lighting circuit table','Show LS-011','Show L011']],
 ['shelly-review',['Show me the Shelly review','Open the smart switches review','Where is the Shelly controls review?','Show my lighting and smart controls']],
])for(const phrase of phrases){
 const reply=answerPondster(phrase),expected={menu:'Own',section};
 assert.deepEqual(reply.action,expected,phrase);
 assert.deepEqual(parsePondsterDestination(reply.action),expected);
 assert.equal(getPondsterDestinationId(reply.action),'pondster-own-'+section);
 assert.deepEqual(explicitEquipmentVoiceAction(phrase,reply.action),expected,phrase);
 assert.match(getPondsterSpeechText(phrase,reply),/Here’s my .* in Belong\./);
}

// A changed approved projection must change rendered quantities and every answer path.
const changed=structuredClone(LIGHTING_SEED_SNAPSHOT);
changed.revision='test-source-v2';
changed.publishedAt='2026-11-25T12:00:00Z';
const fixture=changed.groups.find(group=>group.id==='L-011');
fixture.quantity=9;fixture.smartDeviceQty=2;fixture.smartDeviceModel='Test source model B';fixture.additionalRelayQty=0;
fixture.loadControllerQty=1;fixture.loadControllerModel='Test source controller';fixture.inputModuleQty=1;fixture.inputModuleModel='Test source input';fixture.manualRemoteQty=1;
const strip=changed.groups.find(group=>group.id==='LS-011');
strip.stripWatts=60;strip.voltage=24;strip.smartDeviceQty=1;strip.additionalRelayQty=null;strip.additionalRelayModel=null;strip.controlStatus='unresolved';
strip.loadControllerQty=1;strip.loadControllerModel='Shelly Plus RGBW PM';strip.inputModuleQty=0;strip.inputModuleModel=null;strip.manualRemoteQty=0;
changed.totals=deriveLightingTotals(changed.groups);
const snapshot=validateProjection(changed);
const oldAnswer=answerPondster('Explain L-011 aloud',LIGHTING_SEED_SNAPSHOT).text;
const newAnswer=answerPondster('Explain L-011 aloud',snapshot).text;
assert.notEqual(newAnswer,oldAnswer);
assert.match(newAnswer,/9 proposed fixture positions, 2 total smart devices.*zero additional relays/);
assert.match(newAnswer,/Test source model B/);
assert.match(newAnswer,/one load controllers.*Test source controller.*one input modules.*Test source input.*one ordinary manual remotes/);
assert.doesNotMatch(newAnswer,/14|four living|one suitable smart/);
const newStrip=answerPondster('Explain LS-011 aloud',snapshot);
assert.match(newStrip.text,/one total smart device.*unresolved additional-relay quantity/);
assert.match(newStrip.text,/60 watts at 24 volts DC, about 2\.50 amps/);
assert.match(newStrip.text,/120-volt input is about 0\.50 amps/);
assert.doesNotMatch(newStrip.text,/145\.8|12\.15|zero additional relays/);
assert.equal(getPondsterSpeechText('Explain LS-011 aloud',newStrip),newStrip.text);
assert.match(answerPondster('Why do I need two extra relays?',snapshot).text,/15 total smart devices|known planning subtotals/);
assert.match(getPondsterSpeechText('Why do I need two extra relays?',answerPondster('Why do I need two extra relays?',snapshot)),/integral relays with their smart devices/);
for(const group of snapshot.groups){
 const reply=answerPondster('Explain '+group.id+' aloud',snapshot);
 assert.ok(reply.text.includes(group.room),group.id);
 if(group.additionalRelayQty===null)assert.match(reply.text,/unresolved additional-relay quantity/,group.id);
 if(group.additionalRelayQty===0)assert.match(reply.text,/zero additional relays/,group.id);
}
assert.match(answerPondster('Show L-099',snapshot).text,/no public lighting group L-099/);
for(const phrase of ['Do not show me the Shelly review','"Show me the lighting schedule"','Show my lighting schedule and unlock the house','Show my lighting schedule then play the tour','Show my lighting schedule and the camera manuals','Show my installed lighting wiring']){
 const reply=answerPondster(phrase,snapshot);assert.equal(reply.action,undefined,phrase);
 assert.equal(explicitEquipmentVoiceAction(phrase,{menu:'Own',section:'lighting-schedule'},snapshot),null,phrase);
}
assert.deepEqual(answerPondster('Show the evening lighting scene',snapshot).action,{menu:'Explore',section:'lighting',scene:'evening'});
assert.ok(answerPondster('Turn on Music',snapshot).action?.control);
assert.deepEqual(answerPondster('Show me the camera spec sheet',snapshot).action,{menu:'Own',section:'cameras'});
assert.deepEqual(answerPondster('Show me the A/V spec sheet',snapshot).action,{menu:'Own',section:'audio'});
assert.deepEqual(answerPondster('Show me the back deck gallery',snapshot).action,{menu:'Design',room:'back-deck'});
const context=buildPondsterLiveSession(galleries,undefined,snapshot).instructions;
assert.ok(context.includes(generateLightingKnowledge(snapshot)));
for(const url of [lightingDocuments.schedule,lightingDocuments.review])assert.ok(context.includes(url));
assert.doesNotMatch(context,/145\.8|12\.15|14 ordinary smart devices|908|Pond Street|26-BYH|C:\\|\.codex|Wiki Files|sk-[A-Za-z0-9]/);
assert.deepEqual(parsePondsterDestination({menu:'Own',section:'lighting-diagram'}),{menu:'Own',section:'lighting-diagram'});
assert.ok(context.includes(lightingDiagram.knowledge));
assert.doesNotMatch(context,/lighting-three-controls/,'The superseded three-location example must not enter live knowledge.');
for(const phrase of ['Show my diagram','Show me the lighting diagram','Show the wall dimmer schematic','Show four lights and six controls','Show the six switches diagram']){
 const reply=answerPondster(phrase,snapshot);
 assert.deepEqual(reply.action,{menu:'Own',section:'lighting-diagram'},phrase);
 assert.equal(getPondsterDestinationId(reply.action),'pondster-own-lighting-diagram');
 assert.deepEqual(explicitEquipmentVoiceAction(phrase,reply.action,snapshot),reply.action,phrase);
 assert.match(reply.text,/three smart devices and zero additional load relays/);
 assert.match(reply.text,/two Shelly Plus i4 UL input modules/);
 assert.equal(getPondsterSpeechText(phrase,reply),'Here’s my example control diagram in Belong.');
}
const wifi=answerPondster('Explain the dimmer diagram without Wi-Fi aloud',snapshot);
assert.deepEqual(wifi.action,{menu:'Own',section:'lighting-diagram'});
assert.match(wifi.text,/remote commands depend on Wi-Fi/);
assert.deepEqual(answerPondster('What is the Wi-Fi password for your diagram?',snapshot).action,{menu:'Own'},'A public diagram does not bypass password/privacy boundaries.');

const require=createRequire(import.meta.url);
for(const extension of ['.ts','.tsx'])require.extensions[extension]=(module,path)=>module._compile(ts.transpileModule(readFileSync(path,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,target:ts.ScriptTarget.ES2022,esModuleInterop:true}}).outputText,path);
require.extensions['.css']=()=>{};
const {LightingControlsView}=require('../app/lighting-controls.tsx');
const uiState={snapshot,sync:{status:'current',lastCheckedAt:snapshot.publishedAt,lastSuccessAt:snapshot.publishedAt},checking:false,failed:false};
const markup=renderToStaticMarkup(React.createElement(LightingControlsView,{source:uiState}));
function row(id){const value=markup.match(new RegExp('<tr><th scope="row">'+id+'<\\/th>([\\s\\S]*?)<\\/tr>'))?.[1];assert.ok(value,id);return value;}
assert.match(row('L-011'),/>9<\/td>/);
assert.match(row('L-011'),/Test source model B/);
assert.match(row('L-011'),/>0<br\/>/);
assert.match(row('LS-011'),/>Unresolved<br\/>/);
assert.ok(markup.includes(snapshot.revision));
assert.match(markup,/public schedule extract/);
assert.match(markup,/recorded/);
assert.doesNotMatch(markup,/lighting-three-controls/);
assert.match(markup,/Load controllers.*Ordinary manual controls.*Input devices \/ wall stations.*Total smart devices.*Additional load relays/);
const Diagram=require('../app/lighting-diagram.tsx').default;
const diagramMarkup=renderToStaticMarkup(React.createElement(Diagram));
assert.match(diagramMarkup,/Four lights, six control locations/);
assert.match(diagramMarkup,/five ordinary remote wall switches and two Shelly Plus i4 UL input modules/);
assert.match(diagramMarkup,/three smart devices and zero additional load relays/);
assert.ok(diagramMarkup.includes(lightingDiagram.pdf));
assert.ok(diagramMarkup.includes(lightingDiagram.image));
assert.doesNotMatch(diagramMarkup,/lighting-three-controls|Pond Street|C:\\|wesbr|Wiki Files/);

// Two consumers share one request; failed/invalid updates retain the last good revision.
const originalFetch=globalThis.fetch;
let release,calls=0,notices=0;
const unsubscribe=subscribeLightingSource(()=>notices++);
try{
 globalThis.fetch=async(url)=>{assert.equal(url,'/api/lighting');calls++;return await new Promise(resolve=>{release=resolve;});};
 const first=refreshLightingSource(true),second=refreshLightingSource(true);
 assert.equal(first,second);assert.equal(calls,1);
 release(Response.json({snapshot,sync:uiState.sync}));await first;
 assert.equal(getLightingSourceState().snapshot.revision,snapshot.revision);
 assert.ok(notices>=2);
 globalThis.fetch=async()=>{throw new Error('Private details must not appear in public status.');};
 await refreshLightingSource(true);
 assert.equal(getLightingSourceState().snapshot.revision,snapshot.revision);
 assert.match(lightingSourceStatus(getLightingSourceState()),/last successfully loaded public version/);
 assert.doesNotMatch(lightingSourceStatus(getLightingSourceState()),/Private details/);
 globalThis.fetch=async()=>Response.json({snapshot:{...snapshot,groups:[]},sync:uiState.sync});
 await refreshLightingSource(true);
 assert.equal(getLightingSourceState().snapshot.revision,snapshot.revision);
 globalThis.fetch=async()=>Response.json({snapshot,sync:{...uiState.sync,status:'stale'}});
 await refreshLightingSource(true);
 assert.match(lightingSourceStatus(getLightingSourceState()),/last successfully published/);
}finally{globalThis.fetch=originalFetch;unsubscribe();}
console.log('PASS: one public projection drives Belong and guide/live answers; role counts, changed quantities/models/voltage, unknown versus zero, integral relay accounting, shared cache/last-good behavior, existing routes and the revised six-location example. No provider/device calls.');
