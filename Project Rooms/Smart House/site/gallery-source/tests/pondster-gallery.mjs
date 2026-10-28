import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {stripTypeScriptTypes} from 'node:module';
import {galleryVoiceCommand,galleryVoiceSelection,explicitGalleryVoiceAction} from '../lib/pondster-gallery.ts';
import {galleries} from '../lib/designs.ts';
import {galleryPictures} from '../lib/design-views.ts';
import {parsePondsterDestination,getPondsterDestinationId} from '../lib/pondster-destinations.ts';
import {answerPondster} from '../lib/pondster-guide.ts';
import {getPondsterSpeechText} from '../lib/pondster-speech.ts';
for(const [text,command] of [['next','next'],['next one','next'],['show me another picture','next'],['next picture','next'],['show me the next image','next'],['previous choice','previous'],['go back','previous'],['go back one picture','previous'],['first picture','first'],['show me the first one','first'],['close','close'],['close the picture','close'],['back to the gallery','close']]){
 assert.equal(galleryVoiceCommand(text),command,text);const answer=answerPondster(text);
 assert.deepEqual(answer.action,{menu:'Design',image:command},text);
 assert.deepEqual(parsePondsterDestination(answer.action),answer.action);
 assert.ok(getPondsterSpeechText(text,answer).length<30);
}
for(const text of ['vote for the next picture','show private records','next contractor','next week','no need to close the picture','do not show next picture'])assert.equal(galleryVoiceCommand(text),null,text);
for(const action of [{menu:'Contact',image:'next'},{menu:'Design',section:'overview',image:'next'},{menu:'Design',image:'javascript:alert(1)'},{menu:'Design',image:'vote'},{menu:'Design',image:'next',room:'private'}])assert.equal(parsePondsterDestination(action),null);
for(const gallery of galleries){
 const request='Show me the '+gallery.name+' gallery';assert.equal(explicitGalleryVoiceAction(request,answerPondster(request).action)?.room,gallery.id,'All galleries use the same explicit speech-navigation rule.');
 const pictures=galleryPictures(gallery.designs),first=galleryVoiceSelection(null,gallery.id,'first');
 if(!pictures.length){assert.equal(first,null);continue;}
 assert.equal(first.id,pictures[0].design.id);
 let current=first;
 for(let i=1;i<pictures.length;i++){current=galleryVoiceSelection(current,gallery.id,'next');assert.equal(current.id,pictures[i].design.id);assert.equal(current.image,pictures[i].image);}
 assert.deepEqual(galleryVoiceSelection(current,gallery.id,'next'),first,'Next wraps in the same gallery.');
 const last=galleryVoiceSelection(first,gallery.id,'previous');assert.equal(last.image,pictures.at(-1).image);
 assert.deepEqual(galleryVoiceSelection(null,gallery.id,'previous'),last,'Previous from a film opens the last still design.');
 assert.equal(galleryVoiceSelection(current,gallery.id,'close'),null);
 assert.deepEqual(galleryVoiceSelection(current,gallery.id,'first'),first);
}
for(const request of ['Show me the back deck','Show me the backdeck','Could you open the rear deck gallery','Can I see the back deck','Let me see the back deck'])assert.deepEqual(explicitGalleryVoiceAction(request,answerPondster(request).action),{menu:'Design',room:'back-deck'},request);
for(const request of ['Do not show me the back deck','Show me your private records','Show me a secret room','Show me the deck and the kitchen'])assert.equal(explicitGalleryVoiceAction(request,answerPondster(request).action),null,request);
const deck=galleries.find(item=>item.id==='back-deck');const wide=galleryVoiceSelection(null,deck.id,'first'),close=galleryVoiceSelection(wide,deck.id,'next');
assert.equal(wide.id,close.id,'Two deck pictures remain one voting choice.');assert.notEqual(wide.image,close.image);
const reminder=getPondsterSpeechText('Show my living room gallery',answerPondster('Show my living room gallery'));
assert.match(reminder,/vote for your favorite and change your vote/);
assert.doesNotMatch(getPondsterSpeechText('Show my kitchen gallery',answerPondster('Show my kitchen gallery')),/can vote/,'No voting promise for an empty gallery.');

// Execute the actual page action handler. There is no vote callback in its scope.
const source=readFileSync(new URL('../app/page.tsx',import.meta.url),'utf8');
const start=source.indexOf('  function guideAction('),end=source.indexOf('\n  return <>',start);
assert.ok(start>0&&end>start);const body=stripTypeScriptTypes(source.slice(start,end));
let zoom=null,room='media-center',menu='Contact',revealed=null;
const action=new Function('parsePondsterDestination','navigate','galleries','saving','setRoom','setScene','getPondsterDestinationId','nextSectionReveal','pendingSectionReveal','setSectionReveal','setTourRequest','nextTourRequest','galleryVoiceSelection','setZoom','zoom','room',body+';return guideAction;');
function apply(destination){return action(parsePondsterDestination,value=>{menu=value;},galleries,false,value=>{room=value;},()=>{},getPondsterDestinationId,{current:0},{current:null},value=>{revealed=value;},()=>{},{current:0},galleryVoiceSelection,value=>{zoom=value;},zoom,room)(destination);}
apply({menu:'Design',room:'master-bath'});assert.equal(menu,'Design');assert.equal(room,'master-bath');assert.equal(zoom.id,galleries.find(item=>item.id===room).designs[0].id);assert.equal(revealed.destination.room,'master-bath');
const firstBath=zoom;apply({menu:'Design',image:'next'});assert.notEqual(zoom.id,firstBath.id);assert.equal(room,'master-bath');
apply({menu:'Design',image:'previous'});assert.equal(zoom.id,firstBath.id);
apply({menu:'Design',image:'close'});assert.equal(zoom,null);
apply({menu:'Design',room:'kitchen'});assert.equal(zoom,null);
apply({menu:'Design',room:'back-deck'});assert.ok(zoom);apply({menu:'Contact',section:'hvac'});assert.equal(zoom,null,'Navigation to contact details closes the picture viewer.');assert.equal(menu,'Contact');
console.log('PASS: spoken first/next/previous/close, real page first-picture reveal, same-gallery wrap, alternate-view voting IDs, voting reminder, empty galleries and destination validation; no network, microphone or vote writes.');
