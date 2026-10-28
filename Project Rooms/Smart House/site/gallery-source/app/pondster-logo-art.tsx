/** The static parent anchors the launch point; only its local sparks expand. */
export default function PondsterLogoArt(){
 return <svg className="pondster-logo-art" data-firework-origin="exclamation" viewBox="0 0 90 110" aria-hidden="true" focusable="false" pointerEvents="none" fill="none" xmlns="http://www.w3.org/2000/svg">
  <g className="logo-firework-source" transform="translate(45 90)">
   {[0,.85].map((delay,burst)=><g key={burst} className="logo-firework-burst" transform="scale(.08)" opacity="0" stroke={burst?'#b18b4d':'#a75936'} strokeWidth="1.4" strokeLinecap="round">
    <animateTransform attributeName="transform" attributeType="XML" type="scale" values=".08;.08;.15;1.35;1.35" keyTimes="0;.08;.12;.38;1" dur="4.8s" begin={delay+'s'} repeatCount="indefinite"/>
    <animate attributeName="opacity" values="0;0;.9;0;0" keyTimes="0;.08;.12;.38;1" dur="4.8s" begin={delay+'s'} repeatCount="indefinite"/>
    {Array.from({length:9},(_,index)=>{const angle=(-170+index*20)*Math.PI/180,near=7,far=26+(index%3)*6;return <line key={index} className="logo-firework-ray" x1={Math.cos(angle)*near} y1={Math.sin(angle)*near} x2={Math.cos(angle)*far} y2={Math.sin(angle)*far}/>;})}
    <circle className="logo-firework-dot" cx="0" cy="0" r="1.5" fill="#a75936" stroke="none"/>
   </g>)}
  </g>
 </svg>;
}
