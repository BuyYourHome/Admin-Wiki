import type { GuideReply } from './pondster-guide';
import { lightingDocuments } from './lighting-controls';
import { lightingDiagram } from './lighting-diagram';
import { LIGHTING_SEED_SNAPSHOT } from './lighting-source-fallback';
import type { LightingGroup, LightingSnapshot } from './lighting-source-model';

function normalize(value:string){return value.toLowerCase().replace(/[^a-z0-9]+/g,' ').trim().replace(/\blivingroom\b/g,'living room').replace(/\bprimary\b/g,'master').replace(/\bwc\b/g,'toilet room').replace(/\bbedroom one\b/g,'bedroom 1').replace(/\bbedroom two\b/g,'bedroom 2');}
function count(value:number|null){return value===null?'unresolved':value===0?'zero':value===1?'one':String(value);}
function namedGroup(groups:LightingGroup[],words:string){
  const scores=groups.map(group=>{
    const tokens=[...new Set(normalize(group.room).split(' ').filter(token=>!['the','and','room','area','main','of','with'].includes(token)))];
    const matches=tokens.filter(token=>` ${words} `.includes(` ${token} `)).length;
    const extra=normalize(group.loadType).split(' ').filter(token=>token.length>3&&` ${words} `.includes(` ${token} `)).length;
    return {group,score:matches?matches*10+extra:0};
  }).sort((a,b)=>b.score-a.score);
  return scores[0]?.score&&scores[0].score!==scores[1]?.score?scores[0].group:undefined;
}
function proposal(group:LightingGroup){
  const load=group.kind==='fixture'?'fixture positions':group.kind==='strip'?'strip loads':'loads';
  const primary=group.smartDeviceQty===null?'an unresolved smart-device quantity':`${count(group.smartDeviceQty)} total smart device${group.smartDeviceQty===1?'':'s'}`;
  const relays=group.additionalRelayQty===null?'an unresolved additional-relay quantity':`${count(group.additionalRelayQty)} additional relay${group.additionalRelayQty===1?'':'s'}`;
  return `${group.id} is my ${group.room}: ${count(group.quantity)} proposed ${load}, ${primary}${group.smartDeviceModel?` (${group.smartDeviceModel})`:''} and ${relays}${group.additionalRelayModel?` (${group.additionalRelayModel})`:''}. Control locations: ${count(group.manualSwitches)}, including the primary local control. Proposed roles: ${count(group.loadControllerQty)} load controllers${group.loadControllerModel?` (${group.loadControllerModel})`:''}, ${count(group.inputModuleQty)} input modules${group.inputModuleModel?` (${group.inputModuleModel})`:''} and ${count(group.manualRemoteQty)} ordinary manual remotes. Input modules are smart devices, not additional load relays. A load controller’s integral relay is part of that device, not another item to buy.`;
}
function stripLoad(group:LightingGroup){
  if(group.stripWatts===null||group.voltage===null)return ' My strip wattage or DC voltage is unresolved, so I cannot calculate its current.';
  const watts=Number(group.stripWatts.toFixed(4)),current=(group.stripWatts/group.voltage).toFixed(2),idealInput=(group.stripWatts/120).toFixed(2);
  return ` My strip allowance is ${watts} watts at ${group.voltage} volts DC, about ${current} amps on the low-voltage side. For comparison, an ideal 120-volt input is about ${idealInput} amps before supply losses; the strip-side current is not the current on the house AC supply.`;
}
function summary(snapshot:LightingSnapshot){
  const t=snapshot.totals;
  return `My current known planning subtotals are ${t.ordinaryGroups} ordinary lighting groups with ${t.ordinarySmartDevices} total smart devices and ${t.ordinaryAdditionalRelays} additional relays, plus ${t.stripZones} strip zones with ${t.proposedStripRelays} proposed additional relay modules. Across all listed loads, ${t.unresolvedSmartDeviceGroups} smart-device quantities and ${t.unresolvedAdditionalRelayGroups} additional-relay quantities remain unresolved. Unknown quantities are not zero, and owned stock remains separate.`;
}

/** Numeric answers always come from the supplied public projection, with generated seed only as fallback. */
export function answerLightingReference(input:string,normalizedWords:string,provided?:LightingSnapshot):GuideReply|null {
  const snapshot=provided??LIGHTING_SEED_SNAPSHOT,words=normalize(normalizedWords);
  const id=words.match(/\b(ls|l)\s*0*(\d{1,5})\b/),zoneId=id?`${id[1].toUpperCase()}-${id[2].padStart(3,'0')}`:undefined;
  const stripTopic=/\b(strips?|perimeter|niche|treads?|cabinets?|island|rgbw)\b/.test(words);
  const named=namedGroup(snapshot.groups.filter(group=>stripTopic?group.kind==='strip':group.kind==='fixture'),words);
  const group=snapshot.groups.find(group=>group.id===zoneId)??named;
  const schedule=/\b(?:(?:lighting|light|electrical|electric|circuit) (?:circuit )?(?:schedules?|spreadsheets?|tables?|charts?|lists?)|spreadsheet|lighting circuits?|lighting zones?|lighting groups?)\b/.test(words);
  const review=/\b(shelly|relays?|smart switches?|smart lighting (?:controls?|devices?)|lighting (?:and )?(?:smart )?(?:controls?|review))\b/.test(words);
  const loadQuestion=/\b(watts?|wattage|amps?|amperage|current|volts?|voltage|controllers?|smart devices?|how many)\b/.test(words);
  const lightingTopic=/\b(lights?|lighting|recessed|strips?|perimeter|treads?|rgbw)\b/.test(words);
  const diagram=(/\b(diagram|schematic)\b/.test(words)&&!/\b(deck|cameras?|floor plan|house plan)\b/.test(words))
    || (/\b(six|6) (?:wall )?(?:switches|controls|control locations)\b/.test(words)&&/\b(four|4) lights?\b/.test(words));
  if(!diagram&&!schedule&&!review&&!(loadQuestion&&lightingTopic&&group)&&!zoneId)return null;
  const reference='My lighting schedule, Shelly review and example diagram are public planning references on Belong.';
  const quoted=/["“”«»]|(?:^|\s)['‘]|['’](?:$|\s)/.test(input);
  const declined=/\b(don t|do not|dont|never|stop|cancel|not now)\b/.test(words);
  const compound=/\b(?:and|then|also|but)\b.*\b(?:show|open|go|play|send|email|buy|unlock|turn|switch|activate|enable|disable)\b/.test(words)
    || (/\b(and|plus|with)\b/.test(words)&&/\b(cameras?|sony|receiver|audio|tour|gallery|galleries)\b/.test(words));
  if(quoted||declined||compound)return {text:reference+' Ask directly for the reference you want to see.'};
  if(/\b(installed|as built|approved|actual wiring|serial number)\b/.test(words))return {text:reference+' My equipment installation, wiring and final approvals are not confirmed here.'};
  if(diagram&&group&&!/\bexample\b/.test(words))return {text:proposal(group)+' My current Shelly review includes source-based group sketches. The separate four-light, six-location example does not change this group’s quantities or prove its wiring.',action:{menu:'Own',section:'shelly-review'}};
  if(diagram)return {text:`${lightingDiagram.summary} ${lightingDiagram.limits} The example does not assign a particular lighting group; my current source schedule controls those assignments. The public PDF is ${lightingDiagram.pdf}.`,action:{menu:'Own',section:'lighting-diagram'}};
  const action={menu:'Own' as const,section:schedule||group||zoneId?'lighting-schedule' as const:'shelly-review' as const};
  if(group)return {text:proposal(group)+(group.kind==='strip'?stripLoad(group)+' Additional load relays depend on the proposed controller and input arrangement; a switch count alone does not require another load relay. Controller/channel capacity and whole-zone behavior still need validation.':'')+' This is a planning group, not a breaker number or confirmed installation.',action};
  if(zoneId)return {text:`I have no public lighting group ${zoneId} in the current source projection. My lighting-group IDs are not breaker numbers; the Belong schedule lists my known planning groups.`,action};
  if(/\b(why|need|necessary|required)\b/.test(words)&&/\b(additional|extra|relays?|two|2)\b/.test(words)){
    const example=snapshot.groups.find(group=>group.id==='LS-011')??snapshot.groups.find(group=>group.kind==='strip');
    return {text:'A suitable primary smart load controller already contains its load-switching function; that internal relay is not another item to buy. '+summary(snapshot)+(example?' For example, '+proposal(example)+stripLoad(example):'')+' Additional strip relays describe a proposed architecture, not a mandatory minimum.',action:{menu:'Own',section:'shelly-review'}};
  }
  return {text:summary(snapshot)+` My public ${schedule?'Circuit schedule and Control specifications extract':'Shelly controls review'} is on Belong: ${schedule?lightingDocuments.schedule:lightingDocuments.review}. These are source planning subtotals, not installed equipment or final purchases.`,action};
}
