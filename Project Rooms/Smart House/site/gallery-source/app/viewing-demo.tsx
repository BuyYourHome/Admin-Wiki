'use client';
import { useEffect, useState, type FormEvent } from 'react';

const times = ['09:00','10:00','11:00','12:00','13:00','14:00','15:00','16:00','17:00'];
function propertyToday() {
  const parts = new Intl.DateTimeFormat('en-US',{timeZone:'America/New_York',year:'numeric',month:'2-digit',day:'2-digit'}).formatToParts(new Date());
  return ['year','month','day'].map(type=>parts.find(part=>part.type===type)!.value).join('-');
}
function timeLabel(time:string) { const hour=Number(time.split(':')[0]);return `${hour%12||12}:00 ${hour<12?'AM':'PM'}`; }

export default function ViewingDemo() {
  const [today,setToday]=useState('');
  const [preview,setPreview]=useState<{date:string;time:string;code:string}|null>(null);
  const [error,setError]=useState('');
  useEffect(()=>setToday(propertyToday()),[]);
  function submit(event:FormEvent<HTMLFormElement>) {
    event.preventDefault();setError('');
    const values=new FormData(event.currentTarget);
    const date=String(values.get('date')||'');
    const time=String(values.get('time')||'');
    if(!date||date<propertyToday()||!times.includes(time)){setError('I need today or a future date and a time to create this preview.');return;}
    const random=new Uint32Array(1);crypto.getRandomValues(random);
    setPreview({date,time,code:`DEMO-${String(random[0]%1000000).padStart(6,'0')}`});
  }
  function resetPreview(){setPreview(null);setError('');}
  const displayDate=preview ? new Intl.DateTimeFormat('en-US',{month:'long',day:'numeric',year:'numeric',timeZone:'UTC'}).format(new Date(`${preview.date}T12:00:00Z`)) : '';
  return <div className="viewing-calendar" id="viewing-calendar">
    <form onSubmit={submit}><div className="calendar-heading"><p className="eyebrow">TRY MY VIEWING CALENDAR</p><span>DEMO</span></div><p className="calendar-description">I can preview a visit with a date, time, and simulated entry code.</p><div className="calendar-fields"><label htmlFor="viewing-date">Preferred date<input id="viewing-date" name="date" type="date" required min={today||undefined} onInput={resetPreview}/></label><label htmlFor="viewing-time">Time · Eastern<select id="viewing-time" name="time" required defaultValue="10:00" onChange={resetPreview}>{times.map(value=><option value={value} key={value}>{timeLabel(value)}</option>)}</select></label></div><button className="solid-link demo-submit" type="submit">Preview a visit &amp; demo code <span aria-hidden="true">↗</span></button>{error&&<p className="calendar-error" role="alert">{error}</p>}</form>
    {preview&&<section className="viewing-confirmation" role="status" aria-live="polite" aria-label="Simulated viewing preview"><p className="eyebrow">MY VIEWING PREVIEW</p><h3>{displayDate}</h3><p>{timeLabel(preview.time)} Eastern · 1 hour</p><span className="code-label">SIMULATED ENTRY CODE</span><strong className="demo-code">{preview.code}</strong><p className="demo-disclaimer">I haven’t booked an appointment. This demo code won’t unlock me.</p></section>}
    <p className="viewing-note">I’m using example times, not confirmed availability. I keep this preview on this page; I don’t send your selection to Ashley. To visit me, arrange a real viewing separately.</p>
  </div>;
}
