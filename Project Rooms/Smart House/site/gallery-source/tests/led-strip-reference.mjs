import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createHash} from 'node:crypto';
import {createRequire} from 'node:module';
import ts from 'typescript';
import React from 'react';
import {renderToStaticMarkup} from 'react-dom/server';
import {unzipSync,strFromU8} from 'fflate';
import {parseLightingSource,validateProjection,generateLightingKnowledge} from '../lib/lighting-source-model.ts';
import {generateLightingPublicWorkbook} from '../lib/lighting-public-workbook.ts';
import {renderLightingCircuitDiagrams} from '../lib/lighting-circuit-diagrams.ts';
import {renderLightingReview} from '../lib/lighting-review-html.ts';
import {answerPondster} from '../lib/pondster-guide.ts';
import {parsePondsterDestination,getPondsterDestinationId} from '../lib/pondster-destinations.ts';
import {explicitEquipmentVoiceAction} from '../lib/pondster-equipment-navigation.ts';
import {getPondsterSpeechText} from '../lib/pondster-speech.ts';
import {buildPondsterLiveSession} from '../lib/pondster-live-context.ts';
import {galleries} from '../lib/designs.ts';
import {ledStripDiagram} from '../lib/led-strip-diagram.ts';

const meta={revision:'pro-blu-test',sourceModifiedAt:'2026-11-25T12:00:00Z',publishedAt:'2026-11-25T12:01:00Z'};
const header=['Record ID','Room / control group','Light type','Light quantity','Switch count','Smart device qty','Smart device / model','Additional relay qty','Additional relay / model','Load controller qty','Load controller / model','Manual remote qty','Input module qty','Input module / model','PWM output qty','PWM output plan'];
const plan='O1: 48.6 W / 4.05 A; O2: 48.6 W / 4.05 A; O3: 48.6 W / 4.05 A. Both controls coordinate O1-O3; commissioning pending.';
const rows=[
 ['LS-011','Living room perimeter','LED strips',3,2,2,'1 x Shelly Pro RGBWW PM; 1 x Shelly BLU RC Button 4 US ZB',0,'None',1,'Shelly Pro RGBWW PM',1,1,'Shelly BLU RC Button 4 US ZB',3,plan],
 ['L-011','Living room','Recessed LED',4,2,2,'1 x Shelly Plus Wall Dimmer US; 1 x Shelly Plus i4 UL',0,'None',1,'Shelly Plus Wall Dimmer US',1,1,'Shelly Plus i4 UL',0,''],
 ['LS-010','Stair treads','LED strips',1,1,1,'GLEDOPTO GL-C-015WL-D',1,'Shelly 1 Gen4 UL',1,'GLEDOPTO GL-C-015WL-D',0,0,'None',0,''],
];
const quote=value=>'"'+String(value??'').replaceAll('"','""')+'"';
const csv=table=>table.map(row=>row.map(quote).join(',')).join('\n');
const source=values=>csv([header,...values])+'\f'+csv([['Circuit','Strip W','Load controller'],['LS-011',145.8,'Shelly Pro RGBWW PM'],['LS-010',142.6464,'GLEDOPTO'],['Totals']])+'\f'+csv([['Supply voltage (V DC)',12]]);
const snapshot=parseLightingSource(source(rows),meta),group=snapshot.groups[0];
assert.equal(group.pwmOutputQty,3);assert.equal(group.pwmOutputPlan,plan);assert.equal(group.loadControllerQty,1);assert.equal(group.inputModuleQty,1);assert.equal(group.smartDeviceQty,2);assert.equal(group.additionalRelayQty,0);
assert.equal(snapshot.totals.analogControllers,1,'Three outputs are not three Pro controllers.');
assert.equal(snapshot.totals.stairControllers,1,'Addressable stairs stay separate.');
const diagrams=renderLightingCircuitDiagrams(snapshot);
const pro=diagrams.match(/<article[^>]*id="control-plan-LS-011"[\s\S]*?<\/article>/)?.[0];assert.ok(pro);
assert.match(pro,/data-control-topology="parallel-blu-native"/);assert.match(pro,/data-control-path="bluetooth"/);assert.match(pro,/data-control-path="native-manual"/);
assert.doesNotMatch(pro,/data-control-topology="ac-input-network"/,'The manual switch must not feed through the BLU wall station.');
assert.match(pro,/Native low-voltage input/);assert.match(pro,/Assigned separate PWM outputs/);assert.ok(pro.includes(plan));assert.match(pro,/Both controls must coordinate every source-assigned PWM output/);assert.match(pro,/Never parallel PWM outputs/);
assert.match(pro,/single-color, single-channel constant-voltage/);assert.match(pro,/Actual strip type and physical runs still need confirmation/);assert.doesNotMatch(pro,/One shared load controller/);
const ac=diagrams.match(/<article[^>]*id="control-plan-L-011"[\s\S]*?<\/article>/)?.[0];assert.match(ac,/data-control-topology="ac-input-network"/);assert.match(ac,/Shelly Plus i4 UL/);
const stair=diagrams.match(/<article[^>]*id="control-plan-LS-010"[\s\S]*?<\/article>/)?.[0];assert.doesNotMatch(stair,/parallel-blu-native/);assert.match(stair,/Not applicable to this arrangement/);
assert.ok(generateLightingKnowledge(snapshot).includes(plan));assert.match(generateLightingKnowledge(snapshot),/BLU Bluetooth commands/);
const answer=answerPondster('Explain LS011 aloud',snapshot);assert.match(answer.text,/Assigned PWM outputs: 3/);assert.ok(answer.text.includes(plan));
const changed=structuredClone(rows);changed[0][14]=2;changed[0][15]='O1 and O2 allocated separately; both controls map to both outputs.';
const next=parseLightingSource(source(changed),{...meta,revision:'pro-blu-next'});assert.equal(next.groups[0].loadControllerQty,1);assert.match(answerPondster('Explain LS011 aloud',next).text,/Assigned PWM outputs: 2/);
assert.ok(renderLightingReview(next).includes(changed[0][15]));
const xml=Object.values(unzipSync(generateLightingPublicWorkbook(next))).map(strFromU8).join('\n');assert.match(xml,/PWM output qty/);assert.match(xml,/PWM output plan/);assert.ok(xml.includes(changed[0][15]));assert.ok(xml.includes(next.revision));
const noPwm=structuredClone(snapshot);for(const g of noPwm.groups){delete g.pwmOutputQty;delete g.pwmOutputPlan;}assert.equal(validateProjection(noPwm).groups[0].pwmOutputQty,null,'Older publications stay readable without fabricated output counts.');
const tooMany=structuredClone(rows);tooMany[0][14]=6;assert.throws(()=>parseLightingSource(source(tooMany),meta),/controller channels/);
const badPlan=structuredClone(rows);badPlan[0][15]='C:\\Private\\output-plan.txt';assert.throws(()=>parseLightingSource(source(badPlan),meta),/unsafe/);
for(const phrase of ['Show the generic LED strip diagram','Open the supplied 12V LED control PDF','Show my Pro RGBWW PM example','Show the BLU Bluetooth wall station example','Show BLU RC Button 4 US ZB diagram']){
 const reply=answerPondster(phrase,snapshot),expected={menu:'Own',section:'led-strip-diagram'};assert.deepEqual(reply.action,expected,phrase);assert.deepEqual(parsePondsterDestination(reply.action),expected);assert.equal(getPondsterDestinationId(reply.action),'pondster-own-led-strip-diagram');assert.deepEqual(explicitEquipmentVoiceAction(phrase,reply.action,snapshot),expected,phrase);assert.equal(getPondsterSpeechText(phrase,reply),'Here’s my supplied LED-strip control example in Belong.');
}
assert.deepEqual(answerPondster('Show the four lights six controls diagram',snapshot).action,{menu:'Own',section:'lighting-diagram'});
assert.deepEqual(answerPondster('Show LS011 diagram',snapshot).action,{menu:'Own',section:'shelly-review'});
for(const phrase of ['Do not show the LED diagram','"Show the LED diagram"','Show the LED diagram and unlock the house'])assert.equal(answerPondster(phrase,snapshot).action,undefined,phrase);
const context=buildPondsterLiveSession(galleries,undefined,snapshot).instructions;assert.ok(context.includes(ledStripDiagram.knowledge));assert.ok(context.includes(ledStripDiagram.pdf));assert.match(context,/parallel control paths/);
const bytes=readFileSync(new URL('../public'+ledStripDiagram.pdf,import.meta.url));assert.equal(createHash('sha256').update(bytes).digest('hex'),'f11b6a787197b9e9386d4c15821e6021f4d5c2bfad086a20024d53c8dcbb74b5','The supplied PDF stays byte-exact.');
assert.ok(readFileSync(new URL('../public'+ledStripDiagram.image,import.meta.url)).length>1000);
const require=createRequire(import.meta.url);for(const ext of ['.ts','.tsx'])require.extensions[ext]=(module,path)=>module._compile(ts.transpileModule(readFileSync(path,'utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,target:ts.ScriptTarget.ES2022,esModuleInterop:true}}).outputText,path);require.extensions['.css']=()=>{};
const Card=require('../app/led-strip-diagram.tsx').default,markup=renderToStaticMarkup(React.createElement(Card));assert.match(markup,/pondster-own-led-strip-diagram/);assert.ok(markup.includes(ledStripDiagram.pdf));assert.match(markup,/Bluetooth mode/);assert.match(markup,/one PWM output/);assert.doesNotMatch(markup,/\$|budget|deduct/);
console.log('PASS: source PWM allocation, one Pro with parallel BLU/native controls, separate AC/stair paths, byte-exact supplied PDF, dedicated typed/live navigation and privacy guards. No provider/device calls.');
