'use client';
import { useEffect, useRef, useState, type FormEvent } from 'react';
import { answerPondster, isPondsterWakeRequest, type GuideAction } from '../lib/pondster-guide';

type SpeechResult = { isFinal:boolean; 0:{transcript:string} };
type Recognition = {
  continuous:boolean; interimResults:boolean; lang:string;
  onstart:(()=>void)|null; onend:(()=>void)|null;
  onerror:((event:{error:string})=>void)|null;
  onresult:((event:{resultIndex:number;results:{length:number;[index:number]:SpeechResult}})=>void)|null;
  start:()=>void; abort:()=>void;
};
type SpeechWindow = Window & { SpeechRecognition?:new()=>Recognition; webkitSpeechRecognition?:new()=>Recognition };
type Message = { who:'you'|'Pondster'; text:string };
const greeting = "Hello, I’m Pondster, the voice and identity of this house. My location is confidential for now—think witness protection, with better curb appeal. Ask me about my design choices, visiting, and future owner experience.";

export default function PondsterGuide({open,onOpenChange,onAction}:{open:boolean;onOpenChange:(open:boolean)=>void;onAction:(action:GuideAction)=>void}) {
  const [messages,setMessages]=useState<Message[]>([{who:'Pondster',text:greeting}]);
  const [voiceAvailable,setVoiceAvailable]=useState(false);
  const [speechAvailable,setSpeechAvailable]=useState(false);
  const [listening,setListening]=useState(false);
  const [speaking,setSpeaking]=useState(false);
  const [status,setStatus]=useState('Microphone off. You can type a question.');
  const [speakReplies,setSpeakReplies]=useState(false);
  const input=useRef<HTMLInputElement>(null);
  const launch=useRef<HTMLButtonElement>(null);
  const log=useRef<HTMLDivElement>(null);
  const recognition=useRef<Recognition|null>(null);
  const desiredListening=useRef(false);
  const active=useRef(false);
  const starting=useRef(false);
  const voiceBusy=useRef(false);
  const restart=useRef<ReturnType<typeof setTimeout>|null>(null);
  const spoken=useRef(false);
  const utteranceVersion=useRef(0);
  const askRef=useRef<(text:string)=>void>(()=>{});
  const startRef=useRef<()=>void>(()=>{});

  function stopVoice(message='Microphone off. You can type a question.') {
    desiredListening.current=false;
    utteranceVersion.current++;
    if(restart.current)clearTimeout(restart.current);
    recognition.current?.abort();
    if('speechSynthesis' in window)window.speechSynthesis.cancel();
    voiceBusy.current=false;setSpeaking(false);setListening(false);setStatus(message);
  }
  function startRecognition() {
    if(!recognition.current||active.current||starting.current||voiceBusy.current||!desiredListening.current||document.hidden)return;
    try{starting.current=true;recognition.current.start();}
    catch{starting.current=false;desiredListening.current=false;setListening(false);setStatus('Voice could not start. Try Listen again, or type your question.');}
  }
  startRef.current=startRecognition;
  function speak(text:string) {
    if(!('speechSynthesis' in window)){setStatus('Spoken replies are unavailable here. You can read the reply below.');return;}
    voiceBusy.current=true;setSpeaking(true);
    const version=++utteranceVersion.current;
    recognition.current?.abort();
    window.speechSynthesis.cancel();
    const utterance=new SpeechSynthesisUtterance(text);
    utterance.lang='en-US';utterance.rate=.98;
    const finish=()=>{if(version!==utteranceVersion.current)return;voiceBusy.current=false;setSpeaking(false);if(desiredListening.current)startRef.current();};
    utterance.onend=finish;
    utterance.onerror=()=>{finish();setStatus('Audio playback ended. The reply is available as text.');};
    window.speechSynthesis.speak(utterance);
  }
  function ask(text:string) {
    const question=text.trim().slice(0,500);if(!question)return;
    const reply=answerPondster(question);
    setMessages(previous=>[...previous,{who:'you' as const,text:question},{who:'Pondster' as const,text:reply.text}].slice(-12));
    onOpenChange(true);
    if(reply.action)onAction(reply.action);
    if(spoken.current)speak(reply.text);
  }
  askRef.current=ask;
  useEffect(()=>{
    const Voice=(window as SpeechWindow).SpeechRecognition||(window as SpeechWindow).webkitSpeechRecognition;
    setVoiceAvailable(!!Voice);setSpeechAvailable('speechSynthesis' in window);
    if(Voice){
      const engine=new Voice();recognition.current=engine;
      engine.continuous=true;engine.interimResults=false;engine.lang='en-US';
      engine.onstart=()=>{starting.current=false;if(!desiredListening.current){engine.abort();return;}active.current=true;setListening(true);setStatus('Listening — say “Pondster” with your question.');};
      engine.onresult=event=>{
        if(!desiredListening.current||voiceBusy.current)return;
        for(let index=event.resultIndex;index<event.results.length;index++){
          const result=event.results[index];
          if(result.isFinal&&isPondsterWakeRequest(result[0].transcript)){askRef.current(result[0].transcript);break;}
        }
      };
      engine.onerror=event=>{
        starting.current=false;
        if(event.error==='aborted'||event.error==='no-speech')return;
        desiredListening.current=false;setListening(false);
        const message=event.error==='not-allowed'||event.error==='service-not-allowed'?'Microphone access was not allowed. You can keep typing, or allow it in your browser and try again.':event.error==='audio-capture'?'No microphone is available. You can type your question.':'The browser’s speech service is unavailable. Try Listen again, or type your question.';
        setStatus(message);
      };
      engine.onend=()=>{
        starting.current=false;active.current=false;setListening(false);
        if(desiredListening.current&&!voiceBusy.current&&!document.hidden){restart.current=setTimeout(()=>startRef.current(),350);}
      };
    }
    const hidden=()=>{if(document.hidden)stopVoice('Listening stopped while this tab was away. Tap Listen to start again.');};
    document.addEventListener('visibilitychange',hidden);
    return()=>{
      desiredListening.current=false;if(restart.current)clearTimeout(restart.current);
      document.removeEventListener('visibilitychange',hidden);
      if(recognition.current){recognition.current.onend=null;recognition.current.onresult=null;recognition.current.onstart=null;recognition.current.onerror=null;recognition.current.abort();recognition.current=null;}
      if('speechSynthesis' in window)window.speechSynthesis.cancel();
    };
  },[]);
  useEffect(()=>{if(open)input.current?.focus();},[open]);
  useEffect(()=>{if(open&&log.current)log.current.scrollTop=log.current.scrollHeight;},[messages,open]);
  function listen() {
    if(desiredListening.current||listening){stopVoice();return;}
    desiredListening.current=true;spoken.current=true;setSpeakReplies(true);
    setStatus('Starting voice. Allow microphone access if your browser asks.');
    startRecognition();
  }
  function close(){stopVoice();onOpenChange(false);launch.current?.focus();}
  function submit(event:FormEvent<HTMLFormElement>){event.preventDefault();const data=new FormData(event.currentTarget);const text=String(data.get('question')||'');ask(text);event.currentTarget.reset();}
  const lastReply=[...messages].reverse().find(message=>message.who==='Pondster')?.text||greeting;
  const voiceSession=desiredListening.current;
  return <div className="pondster-guide">
    {open&&<section id="pondster-panel" className="pondster-panel" role="region" aria-labelledby="pondster-heading" onKeyDown={event=>{if(event.key==='Escape')close();}}>
      <header className="pondster-panel-heading"><span className="pondster-avatar" aria-hidden="true">P</span><div><h2 id="pondster-heading">Pondster</h2><p>YOUR HOUSE, WITH A VOICE</p></div><button className="pondster-close" onClick={close} aria-label="Close Pondster and stop voice">×</button></header>
      <div className="pondster-voice"><p>Say my name. Ask about my home.</p><div className="pondster-voice-controls"><button onClick={listen} disabled={!voiceAvailable} aria-pressed={voiceSession}>{voiceSession?'■ Stop voice':'◉ Listen for Pondster'}</button>{speechAvailable&&<label><input type="checkbox" checked={speakReplies} onChange={event=>{spoken.current=event.target.checked;setSpeakReplies(event.target.checked);if(!event.target.checked){utteranceVersion.current++;window.speechSynthesis.cancel();voiceBusy.current=false;setSpeaking(false);if(desiredListening.current)startRef.current();}}}/>Speak replies</label>}</div><p className={`pondster-status ${listening?'active':''}`} role="status">{speaking?'Pondster is speaking.':status}</p>{!voiceAvailable&&<p className="pondster-unavailable">Voice input is unavailable in this browser. Typed questions work here.</p>}<small>Voice starts only when you choose Listen. Your browser may send audio to its speech service. Close or Stop to end listening.</small></div>
      <div className="pondster-conversation" ref={log} role="log" aria-label="Conversation with Pondster" aria-live="polite" aria-relevant="additions">{messages.map((message,index)=><div className={`pondster-message ${message.who==='you'?'from-you':''}`} key={`${index}-${message.text.slice(0,20)}`}><span>{message.who==='you'?'YOU':'PONDSTER'}</span><p>{message.text}</p></div>)}</div>
      <div className="pondster-prompts"><button onClick={()=>ask('Pondster, who are you?')}>Meet Pondster</button><button onClick={()=>ask('Pondster, show the design galleries')}>Explore designs ↗</button><button onClick={()=>ask('Pondster, how can I visit?')}>Plan a visit ↗</button></div>
      <form className="pondster-input" onSubmit={submit}><label className="visually-hidden" htmlFor="pondster-question">Ask Pondster a question</label><input id="pondster-question" name="question" ref={input} placeholder="Pondster, tell me about…" required maxLength={500} autoComplete="off"/><button type="submit" aria-label="Send question to Pondster">↑</button></form>
      <div className="pondster-panel-footer"><span>Public website guide · SI designer: Jean Wright</span>{speechAvailable&&<button onClick={()=>speak(lastReply)} aria-label="Read Pondster’s latest reply aloud">Read aloud</button>}</div>
    </section>}
    <button ref={launch} className={`pondster-launch ${voiceSession?'is-listening':''}`} onClick={()=>open?close():onOpenChange(true)} aria-expanded={open} aria-controls="pondster-panel"><span className="pondster-launch-icon" aria-hidden="true">P</span><span>{open?'Close Pondster':'Talk to Pondster'}<small>{voiceSession?'VOICE SESSION ACTIVE':'LOCATION CONFIDENTIAL'}</small></span><span aria-hidden="true">{open?'×':'↗'}</span></button>
  </div>;
}
