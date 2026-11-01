import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { stripTypeScriptTypes } from 'node:module';
import { answerPondster } from '../lib/pondster-guide.ts';
import {actionResultSpeech} from '../lib/pondster-gallery-result.ts';
import { getPondsterSpeechText, isPondsterSpokenExplanationRequest } from '../lib/pondster-speech.ts';
import { PONDSTER_CITY, PONDSTER_LOCATION_TEXT } from '../lib/pondster-identity.ts';

for(const [question,expected] of [
 ['Who is your general contractor?','Here’s my general contractor.'],
 ['Show me information about the HVAC','Here’s my HVAC contact.'],
 ['Tell me about your kitchen','Here are my Kitchen details.'],
 ['Show me the Living Room gallery','Here’s my Living Room gallery. You can vote for your favorite and change your vote anytime.'],
 ['Where is the pantry?','Here are my Pantry plan details.'],
 ['where is the structural design for the back deck','My preliminary deck structural drawing is in Belong.'],
 ['show me deck structural plans','My preliminary deck structural drawing is in Belong.'],
 ['where can I find the deck engineering drawing','My preliminary deck structural drawing is in Belong.'],
 ['Show camera owner manuals','Here are my camera manuals in Belong.'],
 ['Show Sony AN1000 manual','Here are my Sony receiver manuals in Belong.'],
 ['Show equipment manuals','Here’s my equipment manual library in Belong.'],
]) {
 const reply=answerPondster(question);
 assert.equal(getPondsterSpeechText(question,reply),expected,question);
 assert.ok(expected.length<125);
 assert.doesNotMatch(expected,/https?:|@|919|installed/);
}
const written=answerPondster('Who is your general contractor?');
assert.match(written.text,/Glasgow Design Build.*https:/,'Written guidance keeps the full public answer.');
for(const question of ['Read the HVAC information aloud','Please read the general contractor card','Explain my HVAC contact out loud','Give me a spoken explanation']) {
 assert.equal(isPondsterSpokenExplanationRequest(question),true,question);
 assert.equal(getPondsterSpeechText(question,written),written.text,question);
}
for(const question of ['Who is your general contractor?','Tell me about HVAC','Where can I read this?','Do not read this aloud','No need to read the HVAC card to me','Stop narrating and show me the page']) {
 assert.equal(isPondsterSpokenExplanationRequest(question),false,question);
 assert.equal(getPondsterSpeechText(question,written),'Here’s my general contractor.',question);
}
const unknown=answerPondster('What is your asking price?');
assert.equal(getPondsterSpeechText('What is your asking price?',unknown),unknown.text,'No invented navigation for unknown facts.');
for(const question of ['Read the camera manual information aloud','Read the Sony receiver guide aloud','Read the deck engineering drawing description aloud']){
 const reply=answerPondster(question);assert.equal(getPondsterSpeechText(question,reply),reply.text,question);
}
assert.equal(PONDSTER_CITY,'Cary, North Carolina');
for(const question of ['Where are you?','What city are you in?','Which state are you in?','Are you in Cary?','Is this property in Cary, North Carolina?','What part of Cary are you in?','What is your exact street address?','Give me your coordinates']) {
 const reply=answerPondster(question);
 assert.match(reply.text,/Cary, North Carolina.*exact street address.*private/,question);
 assert.deepEqual(reply.action,{menu:'Design',section:'overview'},question);
 assert.equal(getPondsterSpeechText(question,reply),PONDSTER_LOCATION_TEXT,question);
 assert.doesNotMatch(reply.text,/908|Pond Street|witness protection|latitude.*\d/i,question);
}
assert.deepEqual(answerPondster('Where are you and what is your Wi-Fi password?').action,{menu:'Own'});

// Execute the actual Browser voice question handler: navigate before short speech.
const source=await readFile(new URL('../app/pondster-guide.tsx',import.meta.url),'utf8');
const start=source.indexOf('  async function showReply(');
const end=source.indexOf('  function ask(',start);
assert.ok(start>=0&&end>start);
const handler=stripTypeScriptTypes(source.slice(start,end));
const order=[],spoken=[],messages=[];
const show=new Function('setMessages','onOpenChange','onAction','spoken','controller','getPondsterSpeechText',handler+';return showReply;')(
 update=>messages.splice(0,messages.length,...update(messages)),()=>{},
 action=>order.push(['action',action]),{current:true},{current:{speak:text=>{order.push(['speech',text]);spoken.push(text);}}},getPondsterSpeechText);
await show('Who is your general contractor?',answerPondster('Who is your general contractor?'));
assert.deepEqual(order.map(item=>item[0]),['action','speech']);
assert.deepEqual(order[0][1],{menu:'Contact',section:'gc'});
assert.deepEqual(spoken,['Here’s my general contractor.']);
assert.match(messages.at(-1).text,/Glasgow Design Build.*https:/);
// Browser/typed voice must wait for the real vote response as natural voice does.
let releaseVote;const voteResult=new Promise(resolve=>{releaseVote=resolve;}),voteSpeech=[];
const voteShow=new Function('setMessages','onOpenChange','onAction','spoken','controller','getPondsterSpeechText','actionResultSpeech',handler+';return showReply;')(
 ()=>{},()=>{},()=>voteResult,{current:true},{current:{speak:text=>voteSpeech.push(text)}},getPondsterSpeechText,actionResultSpeech);
const pendingVote=voteShow('vote for this one',answerPondster('vote for this one'),false);assert.equal(voteSpeech.length,0);
releaseVote({status:'failed'});await pendingVote;assert.match(voteSpeech[0],/couldn’t confirm/);assert.doesNotMatch(voteSpeech[0],/saved your vote/);
for(const file of ['app/page.tsx','app/layout.tsx','app/contact-page.tsx','app/built-by-page.tsx','app/pondster-guide.tsx','lib/pondster-live-context.ts']) {
 const copy=await readFile(new URL('../'+file,import.meta.url),'utf8');
 assert.doesNotMatch(copy,/witness protection|MY LOCATION IS CONFIDENTIAL|My location (?:is|remains) confidential/i,file);
 assert.match(copy,/pondster-identity/,file);
}
console.log('PASS: navigation before brief speech, full written guidance, explicit spoken-reading exception, public Cary/state with private exact address, and consistent public copy; no audio/network.');
