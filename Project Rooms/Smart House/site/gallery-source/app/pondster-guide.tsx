'use client';
import { forwardRef, useEffect, useImperativeHandle, useRef, useState, type FormEvent } from 'react';
import { answerPondster, isPondsterWakeRequest, type GuideAction } from '../lib/pondster-guide';
import { createPondsterVoice } from '../lib/pondster-voice.js';
import { createPondsterLiveVoice, type PondsterLiveState } from '../lib/pondster-live-voice';
import { isPondsterFarewell, PONDSTER_FAREWELL_ACK } from '../lib/pondster-voice-intents';

type Recognition = { start:()=>void; abort:()=>void };
type SpeechWindow = Window & { SpeechRecognition?:new()=>Recognition; webkitSpeechRecognition?:new()=>Recognition };
type VoiceState = { available:boolean; speechAvailable:boolean; session:boolean; listening:boolean; speaking:boolean; outputActive:boolean; status:string; heard:string };
type Message = { who:'you'|'Pondster'; text:string };
const greeting = "Hello, I’m Pondster, the voice and persona of this house. My location is confidential for now—think witness protection, with better curb appeal. Ask me about my design choices, visiting, and future owner experience.";
const voiceGreeting = 'Hello, I’m Pondster. What would you like to know about me?';
function compactInactiveStatus(status:string) {
  const text=status.trim().replace(/\s+/g,' ');
  if(text.length<=160)return text;
  const reason=text.match(/^.*?[.!?](?=\s|$)/)?.[0]||text;
  return reason.length<=160?reason:`${reason.slice(0,157).trimEnd()}…`;
}

export type PondsterGuideHandle = { activateVoice:()=>void; startVoice:()=>void; stopVoice:()=>void; focusText:()=>void };
export type PondsterVoiceSummary = { active:boolean; connecting?:boolean; status:string };
type GuideProps = { open:boolean; onOpenChange:(open:boolean)=>void; onAction:(action:GuideAction)=>void; onReturnFocus:()=>void; onVoiceState:(state:PondsterVoiceSummary)=>void };

export default forwardRef<PondsterGuideHandle,GuideProps>(function PondsterGuide({open,onOpenChange,onAction,onReturnFocus,onVoiceState},ref) {
  const [messages,setMessages]=useState<Message[]>([{who:'Pondster',text:greeting}]);
  const [voice,setVoice]=useState<VoiceState>({available:false,speechAvailable:false,session:false,listening:false,speaking:false,outputActive:false,status:'I’m not listening. You can type me a question.',heard:''});
  const [speakReplies,setSpeakReplies]=useState(false);
  const [keepListening,setKeepListening]=useState(false);
  const [naturalReady,setNaturalReady]=useState<boolean|null>(null);
  const [naturalSupported,setNaturalSupported]=useState(false);
  const [naturalMessage,setNaturalMessage]=useState('');
  const [voiceMode,setVoiceMode]=useState<'natural'|'browser'>('natural');
  const [live,setLive]=useState<PondsterLiveState>({available:false,connecting:false,active:false,status:'I’m not listening. Start a conversation when you’re ready.',heard:'',audioBlocked:false,silenceAvailable:null,quietReason:'checking',quietSecondsRemaining:null});
  const voiceState=useRef(voice);
  const liveState=useRef(live);
  const input=useRef<HTMLInputElement>(null);
  const log=useRef<HTMLDivElement>(null);
  const controller=useRef<ReturnType<typeof createPondsterVoice>|null>(null);
  const liveController=useRef<ReturnType<typeof createPondsterLiveVoice>|null>(null);
  const audio=useRef<HTMLAudioElement>(null);
  const actionRef=useRef(onAction);
  actionRef.current=onAction;
  const spoken=useRef(false);
  const voiceRequested=useRef({natural:false,browser:false});
  const askRef=useRef<(text:string)=>void>(()=>{});
  function ask(text:string,reveal=true) {
    const question=text.trim().slice(0,500);if(!question)return;
    if(isPondsterFarewell(question)){
      stopVoice();
      setMessages(previous=>[...previous,{who:'you' as const,text:question},{who:'Pondster' as const,text:PONDSTER_FAREWELL_ACK}].slice(-12));
      return;
    }
    if(live.active){liveController.current?.sendText(question);return;}
    const reply=answerPondster(question);
    setMessages(previous=>[...previous,{who:'you' as const,text:question},{who:'Pondster' as const,text:reply.text}].slice(-12));
    if(reveal)onOpenChange(true);
    if(reply.action)onAction(reply.action);
    if(spoken.current)controller.current?.speak(reply.text);
  }
  askRef.current=text=>ask(text,false);
  function stopVoice(){spoken.current=false;setSpeakReplies(false);controller.current?.stop();liveController.current?.stop();}
  useEffect(()=>{
    const Voice=(window as SpeechWindow).SpeechRecognition||(window as SpeechWindow).webkitSpeechRecognition;
    const current=createPondsterVoice({
      recognitionFactory:Voice?()=>new Voice():undefined,
      synthesis:'speechSynthesis' in window?window.speechSynthesis:undefined,
      createUtterance:typeof window.SpeechSynthesisUtterance==='function'?(text:string)=>new SpeechSynthesisUtterance(text):undefined,
      onState:(state:VoiceState)=>{if(state.session||state.outputActive)voiceRequested.current.browser=true;voiceState.current=state;setVoice(state);},
      onQuestion:(text:string)=>askRef.current(text),
      isWakeRequest:(text:string)=>isPondsterWakeRequest(text)||isPondsterFarewell(text),
      isHidden:()=>document.hidden
    });
    controller.current=current;
    let initialNaturalState=true;
    const natural=createPondsterLiveVoice({
      audioElement:audio.current!,
      onState:state=>{if(initialNaturalState){setNaturalSupported(state.available);initialNaturalState=false;}liveState.current=state;setLive(state);if(state.active){setNaturalReady(true);setNaturalMessage('');}},
      onTranscript:(message:Message)=>setMessages(previous=>[...previous,message].slice(-12)),
      onAction:(action:GuideAction)=>actionRef.current(action),
    });
    liveController.current=natural;
    const hidden=()=>{if(document.hidden){spoken.current=false;setSpeakReplies(false);current.hide();natural.stop();}};
    document.addEventListener('visibilitychange',hidden);
    return()=>{document.removeEventListener('visibilitychange',hidden);current.destroy();natural.dispose();controller.current=null;liveController.current=null;};
  },[]);
  useEffect(()=>{
    if(!open)return;
    const cancellation=new AbortController();
    setNaturalReady(null);setNaturalMessage('');
    fetch('/api/voice/status',{cache:'no-store',signal:cancellation.signal}).then(response=>response.ok?response.json() as Promise<{available?:unknown;message?:unknown}>:null).then(data=>{if(!cancellation.signal.aborted&&!liveState.current.active&&!liveState.current.connecting){setNaturalReady(data?.available===true);setNaturalMessage(data?.available===false&&typeof data.message==='string'?data.message.slice(0,400):'');}}).catch(()=>{if(!cancellation.signal.aborted&&!liveState.current.active&&!liveState.current.connecting)setNaturalReady(false);});
    return()=>cancellation.abort();
  },[open]);
  useEffect(()=>{if(open&&log.current)log.current.scrollTop=log.current.scrollHeight;},[messages,open]);
  function startSelectedVoice() {
    voiceRequested.current[voiceMode]=true;
    if(voiceMode==='natural'){
      controller.current?.stop();spoken.current=false;setSpeakReplies(false);
      // start() checks availability itself and cancels pending setup when stop() wins.
      void liveController.current?.start().catch(()=>{});
      return;
    }
    liveController.current?.stop();
    spoken.current=true;setSpeakReplies(true);
    controller.current?.listen(keepListening?'wake':'question');
    // speak() pauses this explicit listening session and resumes it after playback.
    if(voiceState.current.session)controller.current?.speak(voiceGreeting);
  }
  function isVoiceActive(){return liveState.current.active||liveState.current.connecting||voiceState.current.session||voiceState.current.outputActive;}
  useImperativeHandle(ref,()=>({activateVoice(){if(isVoiceActive())stopVoice();else startSelectedVoice();},startVoice(){if(!isVoiceActive())startSelectedVoice();},stopVoice,focusText(){input.current?.focus();}}));
  function listen(){if(isVoiceActive())stopVoice();else startSelectedVoice();}
  function close(){stopVoice();onOpenChange(false);onReturnFocus();}
  const voiceActive=live.active||live.connecting||voice.session||voice.outputActive;
  useEffect(()=>{
    if(!open&&!voiceActive)return;
    const escape=(event:KeyboardEvent)=>{if(event.key==='Escape'){event.preventDefault();if(open)close();else stopVoice();}};
    document.addEventListener('keydown',escape);
    return()=>document.removeEventListener('keydown',escape);
  },[open,voiceActive,onOpenChange,onReturnFocus]);
  function submit(event:FormEvent<HTMLFormElement>){event.preventDefault();const data=new FormData(event.currentTarget);const text=String(data.get('question')||'');ask(text);event.currentTarget.reset();}
  const lastReply=[...messages].reverse().find(message=>message.who==='Pondster')?.text||greeting;
  const useNatural=voiceMode==='natural';
  const inactiveStatus=voiceRequested.current[voiceMode]?compactInactiveStatus(useNatural?live.status:voice.status):'Voice off. Hover over or click my logo to talk.';
  const quietStatus=live.silenceAvailable===false?' · quiet timer unavailable':live.silenceAvailable===null?' · checking quiet timer'
    :live.quietSecondsRemaining!==null?` · quiet: ${live.quietSecondsRemaining}s left`
    :live.quietReason==='output'?' · speaking':live.quietReason==='input'?' · hearing sound'
    :live.quietReason==='work'||live.quietReason==='response'?' · thinking':'';
  const headerStatus=live.connecting?'Connecting my voice…':live.active
    ?`Voice on${quietStatus}${live.audioBlocked?' · audio paused':''}`
    :voice.outputActive?'I’m speaking. Click my logo to stop.':voice.session?'Voice on. Click my logo to stop.':inactiveStatus;
  useEffect(()=>{onVoiceState({active:voiceActive,connecting:live.connecting,status:headerStatus});},[voiceActive,live.connecting,headerStatus,onVoiceState]);
  return <div className="pondster-guide">
    <audio ref={audio} className="pondster-live-audio" hidden aria-label="Pondster’s natural voice audio"/>
    {open&&<section id="pondster-panel" className="pondster-panel" role="region" aria-labelledby="pondster-heading">
      <header className="pondster-panel-heading"><span className="pondster-avatar" aria-hidden="true">P</span><div><h2 id="pondster-heading">Talk with me.</h2><p>I’M PONDSTER, YOUR HOUSE WITH A VOICE</p></div><button className="pondster-close" onClick={close} aria-label="Close conversation and stop voice">×</button></header>
      <div className="pondster-voice"><p>{useNatural?'Let’s have a conversation.':'Ask me a question, out loud.'}</p>
        <label className="pondster-voice-choice">My voice<select value={voiceMode} onChange={event=>{stopVoice();setVoiceMode(event.target.value as 'natural'|'browser');}}><option value="natural">Natural conversation</option><option value="browser">Browser voice</option></select></label>
        <div className="pondster-voice-controls"><button onClick={listen} disabled={useNatural?!voiceActive&&!naturalSupported:!voice.available&&!voice.outputActive&&!voice.session} aria-pressed={voiceActive}>{useNatural?(voiceActive?'■ Stop voice':'◉ Talk naturally'):(voiceActive?'■ Stop voice':keepListening?'◉ Listen for Pondster':'◉ Ask by voice')}</button>{!useNatural&&voice.speechAvailable&&<label><input type="checkbox" checked={speakReplies} onChange={event=>{spoken.current=event.target.checked;setSpeakReplies(event.target.checked);if(!event.target.checked)controller.current?.cancelSpeech();}}/>Speak replies</label>}</div>
        {!useNatural&&<label className="pondster-wake"><input type="checkbox" checked={keepListening} disabled={!voice.available} onChange={event=>{controller.current?.stop();setKeepListening(event.target.checked);}}/>Keep listening for “Pondster”</label>}
        <p className={`pondster-status ${voiceActive?'active':''}`} role="status">{useNatural?live.status:voice.status}</p>
        {(useNatural?live.heard:voice.heard)&&<p className="pondster-heard">I heard: “{useNatural?live.heard:voice.heard}”</p>}
        {useNatural&&live.audioBlocked&&<button className="pondster-resume-audio" onClick={()=>void liveController.current?.resumeAudio().catch(()=>{})}>Play my voice ▶</button>}
        {(useNatural?!live.available||naturalReady===false&&!voiceActive:!voice.available)&&<p className="pondster-unavailable">{useNatural?naturalMessage||'I can’t use my natural voice right now. You can choose Browser voice or type me a question.':'I can’t listen in this browser. Open pondstr.com in Chrome or Edge to try my voice, or type me a question here.'}</p>}
        <p className="pondster-quiet-note">{useNatural?(live.silenceAvailable===false?'I can’t monitor quiet in this connection. I stop my microphone and voice if that check doesn’t recover.':live.active&&live.silenceAvailable===null?'I’m checking quiet detection. You can stop with my logo at any time.':'I end our conversation after 30 seconds of quiet. I stay with you while we keep talking, with no three-minute cutoff.'):'I turn off after 30 seconds without speech. My timer pauses while I speak, then gives you time to reply.'}</p>
        <small>{useNatural?'My natural voice is AI-generated. Starting sends your voice to OpenAI for this conversation. I keep no audio or transcript in my website’s database. I stop when you stop voice, close this conversation, press Escape, or leave this tab.':`${keepListening?'Say “Pondster” with each question.':'Tap Ask by voice, then ask one question. You don’t need to say my name.'} Your browser may send audio to its speech service. I stop when you close this conversation, stop voice, press Escape, or leave this tab.`} You can browse my other pages while we talk.</small>
      </div>
      <div className="pondster-conversation" ref={log} role="log" aria-label="Conversation with Pondster" aria-live="polite" aria-relevant="additions">{messages.map((message,index)=><div className={`pondster-message ${message.who==='you'?'from-you':''}`} key={`${index}-${message.text.slice(0,20)}`}><span>{message.who==='you'?'YOU':'PONDSTER'}</span><p>{message.text}</p></div>)}</div>
      <div className="pondster-prompts"><button onClick={()=>ask('Pondster, who are you?')}>Meet me</button><button onClick={()=>ask('Pondster, show the design galleries')}>Explore my designs ↗</button><button onClick={()=>ask('Pondster, how can I visit?')}>Plan a visit ↗</button></div>
      <form className="pondster-input" onSubmit={submit}><label className="visually-hidden" htmlFor="pondster-question">Ask Pondster a question</label><input id="pondster-question" name="question" ref={input} placeholder="Pondster, tell me about…" required maxLength={500} autoComplete="off" onChange={()=>liveController.current?.noteInteraction()}/><button type="submit" aria-label="Send question to Pondster">↑</button></form>
      <div className="pondster-panel-footer"><span>I answer public questions · My SI designer: Jean Wright</span>{!useNatural&&voice.speechAvailable&&<button onClick={()=>controller.current?.speak(lastReply)} aria-label="Read Pondster’s latest reply aloud">Read aloud</button>}</div>
    </section>}
  </div>;
});
