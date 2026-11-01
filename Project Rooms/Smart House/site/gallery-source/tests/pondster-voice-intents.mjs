import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { stripTypeScriptTypes } from 'node:module';
import { isPondsterFarewell, PONDSTER_FAREWELL_ACK } from '../lib/pondster-voice-intents.ts';
import { createPondsterVoice } from '../lib/pondster-voice.js';

for (const phrase of [
  'goodbye', 'Goodbye for now', 'Thank you, goodbye', 'Thankyou, goodbye', 'Okay, bye',
  'Goodbye and thank you', 'Thanks, that’s all', 'Thank you, Pondster, goodbye', 'Goodbye and thank you, Pondster',
  'Good-bye!', 'Bye.', 'bye bye', 'Bye for now!', 'See you later', 'See you soon',
  "We're done", 'We’re done for now.', "That's all", 'That’s all for now!', 'That is all',
  'end conversation', 'End the conversation.', 'End our conversation', 'End this conversation',
  'stop listening', 'Stop voice', 'Stop your voice', 'turn off voice', 'turn your voice off',
  'Pondster, goodbye!', 'Hey Pondster, bye for now.', 'Pond star, stop listening, please.',
  'Goodbye, Pondster.', 'Please turn off your voice',
]) assert.equal(isPondsterFarewell(phrase), true, phrase);
for (const phrase of [
  '', 'thanks', 'Thank you!', 'Okay', 'Thanks for that, show me the kitchen',
  'Okay, do not say goodbye', 'Thank you, what does goodbye mean?', 'Goodbye and thank you?', 'stop', 'stop speaking', 'goodbye?',
  "Don't say goodbye", 'do not stop listening', "We're not done", "That's not all",
  'What does goodbye mean?', 'Can you say goodbye?', 'Is that all?',
  '"goodbye"', "'goodbye'", '“goodbye”', 'Pondster, “goodbye”',
  'Pondster, what does goodbye mean?', 'Show a goodbye sign',
  'Goodbye, show me the kitchen', 'Start a tour and then stop voice',
  'Tell me why people say see you later', 'I said goodbye', 'Turn off voice in the kitchen',
]) assert.equal(isPondsterFarewell(phrase), false, phrase);

// Execute the actual UI ask/stop functions without React, devices or network.
const guideSource = await readFile(new URL('../app/pondster-guide.tsx', import.meta.url), 'utf8');
const askSource = guideSource.match(/  function ask\(text:string,reveal=true\) \{[\s\S]*?\n  \}/)?.[0];
const stopSource = guideSource.match(/  function stopVoice\(\)\{[^\n]+\}/)?.[0];
assert.ok(askSource && stopSource);
const createAsk = new Function('isPondsterFarewell','PONDSTER_FAREWELL_ACK','setMessages','live',
  'liveController','answerPondster','onOpenChange','onAction','spoken','controller','setSpeakReplies',
  stripTypeScriptTypes(askSource+'\n'+stopSource)+'\nreturn ask;');
function guideHarness(active) {
  const messages=[],forwarded=[],speech=[],stops=[],answers=[],open=[],actions=[],speechModes=[];
  const ask=createAsk(isPondsterFarewell,PONDSTER_FAREWELL_ACK,update=>messages.splice(0,messages.length,...update(messages)),{active},
    {current:{stop(){stops.push('natural');},sendText(text){forwarded.push(text);}}},
    text=>{answers.push(text);return{text:'Synthetic public answer'};},value=>open.push(value),value=>actions.push(value),
    {current:true},{current:{stop(){stops.push('browser');},speak(text){speech.push(text);}}},value=>speechModes.push(value));
  return {ask,messages,forwarded,speech,stops,answers,open,actions,speechModes};
}
for(const active of [true,false]) {
  const h=guideHarness(active);h.ask('Pondster, goodbye!',false);
  assert.deepEqual(h.stops,['browser','natural']);assert.deepEqual(h.speechModes,[false]);
  assert.deepEqual(h.messages,[{who:'you',text:'Pondster, goodbye!'},{who:'Pondster',text:PONDSTER_FAREWELL_ACK}]);
  assert.deepEqual(h.forwarded,[]);assert.deepEqual(h.answers,[]);assert.deepEqual(h.speech,[]);
  assert.deepEqual(h.open,[]);assert.deepEqual(h.actions,[],'Farewell never navigates or reopens a conversation.');
}
const ordinary=guideHarness(true);ordinary.ask('Thanks');
assert.deepEqual(ordinary.forwarded,['Thanks']);assert.deepEqual(ordinary.stops,[]);
assert.match(guideSource,/isWakeRequest:\(text:string\)=>isPondsterWakeRequest\(text\)\|\|isPondsterFarewell\(text\)/,
  'A complete farewell can stop browser wake mode without saying Pondster.');

// A final browser recognition result can stop wake mode without scheduling a restart.
let recognition, browserState;
const timers=new Map();let timerId=0;
const browser=createPondsterVoice({
  recognitionFactory:()=>recognition={start(){},abort(){}},
  onState:state=>{browserState=state;},
  onQuestion:text=>{if(isPondsterFarewell(text))browser.stop();},
  isWakeRequest:isPondsterFarewell,
  setTimer:(fn,ms)=>{const id=++timerId;timers.set(id,{fn,ms});return id;},
  clearTimer:id=>timers.delete(id),
});
browser.listen('wake');recognition.onstart();
const result=Object.assign([{transcript:'Goodbye!'}],{isFinal:true});
recognition.onresult({resultIndex:0,results:[result]});
assert.equal(browserState.session,false);assert.equal(browserState.listening,false);
assert.equal(timers.size,0,'Farewell stop cancels recognition restart and quiet timers.');
browser.destroy();
console.log('PASS: explicit complete farewells, punctuation/addressing, quoted/negated/question/thanks boundaries, actual Guide local stop/ack, and browser wake shutdown; no devices/network.');
