import type {CSSProperties} from 'react';

/** Decorative bursts share the exclamation mark's origin. */
export default function PondsterLogoArt(){
 return <svg className="pondster-logo-art" data-firework-origin="exclamation" viewBox="-45 -90 90 110" aria-hidden="true" focusable="false" pointerEvents="none" fill="none" xmlns="http://www.w3.org/2000/svg">
  {[0,.85].map((delay,burst)=><g key={burst} className="logo-firework" style={{'--burst-delay':delay+'s'} as CSSProperties} stroke={burst?'#b18b4d':'#a75936'} strokeWidth="1.4" strokeLinecap="round">
   {Array.from({length:9},(_,index)=>{const angle=(-170+index*20)*Math.PI/180,near=7,far=26+(index%3)*6;return <line key={index} className="logo-firework-ray" x1={Math.cos(angle)*near} y1={Math.sin(angle)*near} x2={Math.cos(angle)*far} y2={Math.sin(angle)*far}/>;})}
   <circle className="logo-firework-dot" cx="0" cy="0" r="1.5" fill="#a75936" stroke="none"/>
  </g>)}
 </svg>;
}
