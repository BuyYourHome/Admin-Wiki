'use client';
import { useEffect, useRef, useState, type FormEvent } from 'react';
import { answerPondster, isPondsterWakeRequest, type GuideAction } from '../lib/pondster-guide';
import { createPondsterVoice } from '../lib/pondster-voice.js';
import { createPondsterLiveVoice } from '../lib/pondster-live-voice';

type Recognition = { start:()=>void; abort:()=>void };
type SpeechWindow = Window & { SpeechRecognition?:new()=>Recognition; webkitSpeechRecognition?:new()=>Recognition };
type VoiceState = { available:boolean; speechAvailable:boolean; session:boolean; listening:boolean; speaking:boolean; outputActive:boolean; status:string; heard:string };
type Message = { who:'you'|'Pondster'; text:string };
const greeting = "Hello, I’m Pondster, the voice and identity of this house. My location is confidential for now—think witness protection, with better curb appeal. Ask me about my design choices, visiting, and future owner experience.";

export default function PondsterGuide({open,onOpenChange,onAction}:{open:boolean;onOpenChange:(open:boolean)=>void;onAction:(action:GuideAction)=>void}) {
  const [messages,setMessages]=useState<Message[]>([{who:'Pondster',text:greeting}]);
  const [voice,setVoice]=useState<VoiceState>({available:false,speechAvailable:false,session:false,listening:false,speaking:false,outputActive:false,status:'I’m not listening. You can type me a question.',heard:''});
  const [speakReplies,setSpeakReplies]=useState(false);
  const [keepListening,setKeepListening]=useState(false);
  const [naturalReady,setNaturalReady]=useState(false);
  const [voiceMode,setVoiceMode]=useState<'natural'|'browser'>('natural');
  const [live,setLive]=useState({available:false,connecting:false,active:false,status:'I’m not listening. Start a conversation when you’re ready.',heard:'',audioBlocked:false});
  const input=useRef<HTMLInputElement>(null);
  const launch=useRef<HTMLButtonElement>(null);
  const log=useRef<HTMLDivElement>(null);
  const controller=useRef<ReturnType<typeof createPondsterVoice>|null>(null);
  const liveController=useRef<ReturnType<typeof createPondsterLiveVoice>|null>(null);
  const audio=useRef<HTMLAudioElement>(null);
  const actionRef=useRef(onAction);
  actionRef.current=onAction;
  const spoken=useRef(false);
  const askRef=useRef<(text:string)=>void>(()=>{});
  function ask(text:string) {
    const question=text.trim().slice(0,500);if(!question)return;
    if(live.active){liveController.current?.sendText(question);return;}
    const reply=answerPondster(question);
    setMessages(previous=>[...previous,{who:'you' as const,text:question},{who:'Pondster' as const,text:reply.text}].slice(-12));
    onOpenChange(true);
    if(reply.action)onAction(reply.action);
    if(spoken.current)controller.current?.speak(reply.text);
  }
  askRef.current=ask;
  function stopVoice(){controller.current?.stop();liveController.current?.stop();}
  useEffect(()=>{
    const Voice=(window as SpeechWindow).SpeechRecognition||(window as SpeechWindow).webkitSpeechRecognition;
    const current=createPondsterVoice({
      recognitionFactory:Voice?()=>new Voice():undefined,
      synthesis:'speechSynthesis' in window?window.speechSynthesis:undefined,
      createUtterance:typeof window.SpeechSynthesisUtterance==='function'?(text:string)=>new SpeechSynthesisUtterance(text):undefined,
      onState:(state:VoiceState)=>setVoice(state),
      onQuestion:(text:string)=>askRef.current(text),
      isWakeRequest:isPondsterWakeRequest,
      isHidden:()=>document.hidden
    });
    controller.current=current;
    const natural=createPondsterLiveVoice({
      audioElement:audio.current!,
      onState:setLive,
      onTranscript:(message:Message)=>setMessages(previous=>[...previous,message].slice(-12)),
      onAction:(action:GuideAction)=>actionRef.current(action),
    });
    liveController.current=natural;
    const hidden=()=>{if(document.hidden){current.hide();natural.stop();}};
    document.addEventListener('visibilitychange',hidden);
    return()=>{document.removeEventListener('visibilitychange',hidden);current.destroy();natural.dispose();controller.current=null;liveController.current=null;};
  },[]);
  useEffect(()=>{
    if(!open){stopVoice();return;}
    const cancellation=new AbortController();
    fetch('/api/voice/status',{cache:'no-store',signal:cancellation.signal}).then(response=>response.ok?response.json() as Promise<{available?:unknown}>:null).then(data=>{if(cancellation.signal.aborted)return;const ready=data?.available===true;setNaturalReady(ready);if(!ready)setVoiceMode('browser');}).catch(()=>{if(!cancellation.signal.aborted){setNaturalReady(false);setVoiceMode('browser');}});
    return()=>cancellation.abort();
  },[open]);
  useEffect(()=>{if(open)input.current?.focus();},[open]);
  useEffect(()=>{if(open&&log.current)log.current.scrollTop=log.current.scrollHeight;},[messages,open]);
  function listen() {
    if(voiceMode==='natural'&&naturalReady){
      if(live.active||live.connecting)liveController.current?.stop();
      else{controller.current?.stop();spoken.current=false;setSpeakReplies(false);void liveController.current?.start().catch(()=>{});}
      return;
    }
    if(voice.session||voice.outputActive){controller.current?.stop();return;}
    spoken.current=true;setSpeakReplies(true);
    controller.current?.listen(keepListening?'wake':'question');
  }
  function close(){stopVoice();onOpenChange(false);launch.current?.focus();}
  function submit(event:FormEvent<HTMLFormElement>){event.preventDefault();const data=new FormData(event.currentTarget);const text=String(data.get('question')||'');ask(text);event.currentTarget.reset();}
  const lastReply=[...messages].reverse().find(message=>message.who==='Pondster')?.text||greeting;
  const useNatural=voiceMode==='natural'&&naturalReady;
  const voiceActive=useNatural?(live.active||live.connecting):(voice.session||voice.outputActive);
  return <div className="pondster-guide">
    <audio ref={audio} className="pondster-live-audio" controls={live.audioBlocked} hidden={!live.audioBlocked} aria-label="Pondster’s natural voice audio"/>
    {open&&<section id="pondster-panel" className="pondster-panel" role="region" aria-labelledby="pondster-heading" onKeyDown={event=>{if(event.key==='Escape')close();}}>
      <header className="pondster-panel-heading"><span className="pondster-avatar" aria-hidden="true">P</span><div><h2 id="pondster-heading">Pondster</h2><p>I’M YOUR HOUSE, WITH A VOICE</p></div><button className="pondster-close" onClick={close} aria-label="Close Pondster and stop voice">×</button></header>
      <div className="pondster-voice"><p>{useNatural?'Let’s have a conversation.':'Ask me a question, out loud.'}</p>
        {naturalReady&&<label className="pondster-voice-choice">My voice<select value={voiceMode} onChange={event=>{stopVoice();const next=event.target.value as 'natural'|'browser';if(next==='natural'){spoken.current=false;setSpeakReplies(false);}setVoiceMode(next);}}><option value="natural">Natural conversation</option><option value="browser">Browser voice</option></select></label>}
        <div className="pondster-voice-controls"><button onClick={listen} disabled={useNatural?!live.available:!voice.available&&!voice.outputActive&&!voice.session} aria-pressed={voiceActive}>{useNatural?(voiceActive?'■ End conversation':'◉ Talk naturally'):(voiceActive?'■ Stop voice':keepListening?'◉ Listen for Pondster':'◉ Ask by voice')}</button>{!useNatural&&voice.speechAvailable&&<label><input type="checkbox" checked={speakReplies} onChange={event=>{spoken.current=event.target.checked;setSpeakReplies(event.target.checked);if(!event.target.checked)controller.current?.cancelSpeech();}}/>Speak replies</label>}</div>
        {!useNatural&&<label className="pondster-wake"><input type="checkbox" checked={keepListening} disabled={!voice.available} onChange={event=>{controller.current?.stop();setKeepListening(event.target.checked);}}/>Keep listening for “Pondster”</label>}
        <p className={`pondster-status ${voiceActive?'active':''}`} role="status">{useNatural?live.status:voice.status}</p>
        {(useNatural?live.heard:voice.heard)&&<p className="pondster-heard">I heard: “{useNatural?live.heard:voice.heard}”</p>}
        {useNatural&&live.audioBlocked&&<button className="pondster-resume-audio" onClick={()=>void liveController.current?.resumeAudio().catch(()=>{})}>Play my voice ▶</button>}
        {(useNatural?!live.available:!voice.available)&&<p className="pondster-unavailable">{useNatural?'I can’t use my natural voice right now. You can choose Browser voice or type me a question.':'I can’t listen in this browser. Open pondstr.com in Chrome or Edge to try my voice, or type me a question here.'}</p>}
        <small>{useNatural?'My natural voice is AI-generated. Starting sends your voice to OpenAI for this conversation. I keep no audio or transcript in my website’s database. I end after three minutes, when you stop or close me, or when you leave this tab.':`${keepListening?'Say “Pondster” with each question.':'Tap Ask by voice, then ask one question. You don’t need to say my name.'} Your browser may send audio to its speech service. I stop when you close me, stop voice, or leave this tab.`}</small>
      </div>
      <div className="pondster-conversation" ref={log} role="log" aria-label="Conversation with Pondster" aria-live="polite" aria-relevant="additions">{messages.map((message,index)=><div className={`pondster-message ${message.who==='you'?'from-you':''}`} key={`${index}-${message.text.slice(0,20)}`}><span>{message.who==='you'?'YOU':'PONDSTER'}</span><p>{message.text}</p></div>)}</div>
      <div className="pondster-prompts"><button onClick={()=>ask('Pondster, who are you?')}>Meet me</button><button onClick={()=>ask('Pondster, show the design galleries')}>Explore my designs ↗</button><button onClick={()=>ask('Pondster, how can I visit?')}>Plan a visit ↗</button></div>
      <form className="pondster-input" onSubmit={submit}><label className="visually-hidden" htmlFor="pondster-question">Ask Pondster a question</label><input id="pondster-question" name="question" ref={input} placeholder="Pondster, tell me about…" required maxLength={500} autoComplete="off"/><button type="submit" aria-label="Send question to Pondster">↑</button></form>
      <div className="pondster-panel-footer"><span>I answer public questions · My SI designer: Jean Wright</span>{!useNatural&&voice.speechAvailable&&<button onClick={()=>controller.current?.speak(lastReply)} aria-label="Read Pondster’s latest reply aloud">Read aloud</button>}</div>
    </section>}
    <button ref={launch} className={`pondster-launch ${voiceActive?'is-listening':''}`} onClick={()=>open?close():onOpenChange(true)} aria-expanded={open} aria-controls="pondster-panel"><span className="pondster-launch-icon" aria-hidden="true">P</span><span>{open?'Close Pondster':'Talk to Pondster'}<small>{voiceActive?'VOICE SESSION ACTIVE':'MY LOCATION IS CONFIDENTIAL'}</small></span><span aria-hidden="true">{open?'×':'↗'}</span></button>
  </div>;
}
