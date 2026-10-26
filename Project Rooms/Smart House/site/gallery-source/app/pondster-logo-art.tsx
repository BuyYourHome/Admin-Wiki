import type { CSSProperties } from 'react';

export default function PondsterLogoArt() {
  return <svg className="pondster-logo-art" viewBox="0 0 320 106" aria-hidden="true" focusable="false" pointerEvents="none" fill="none" xmlns="http://www.w3.org/2000/svg">
    <g className="logo-firework" style={{ '--burst-delay': '0s' } as CSSProperties} stroke="#b18b4d" strokeWidth="1.3" strokeLinecap="round">
      <line className="logo-firework-ray" x1="80" y1="10" x2="80" y2="3"/>
      <line className="logo-firework-ray" x1="84.5" y1="11.5" x2="89.5" y2="6.5"/>
      <line className="logo-firework-ray" x1="86" y1="16" x2="93" y2="16"/>
      <line className="logo-firework-ray" x1="84.5" y1="20.5" x2="89.5" y2="25.5"/>
      <line className="logo-firework-ray" x1="80" y1="22" x2="80" y2="29"/>
      <line className="logo-firework-ray" x1="75.5" y1="20.5" x2="70.5" y2="25.5"/>
      <line className="logo-firework-ray" x1="74" y1="16" x2="67" y2="16"/>
      <line className="logo-firework-ray" x1="75.5" y1="11.5" x2="70.5" y2="6.5"/>
      <circle className="logo-firework-dot" cx="85" cy="1.8" r="1.2" fill="#a75936" stroke="none"/>
      <circle className="logo-firework-dot" cx="65" cy="21" r="1.1" fill="#6f8551" stroke="none"/>
      <circle className="logo-firework-dot" cx="94" cy="23" r="1" fill="#b18b4d" stroke="none"/>
    </g>
    <g className="logo-firework" style={{ '--burst-delay': '.8s' } as CSSProperties} stroke="#a75936" strokeWidth="1.4" strokeLinecap="round">
      <line className="logo-firework-ray" x1="270" y1="13" x2="270" y2="3"/>
      <line className="logo-firework-ray" x1="275" y1="15" x2="282" y2="8"/>
      <line className="logo-firework-ray" x1="277" y1="20" x2="287" y2="20"/>
      <line className="logo-firework-ray" x1="275" y1="25" x2="282" y2="32"/>
      <line className="logo-firework-ray" x1="270" y1="27" x2="270" y2="37"/>
      <line className="logo-firework-ray" x1="265" y1="25" x2="258" y2="32"/>
      <line className="logo-firework-ray" x1="263" y1="20" x2="253" y2="20"/>
      <line className="logo-firework-ray" x1="265" y1="15" x2="258" y2="8"/>
      <circle className="logo-firework-dot" cx="280" cy="3" r="1.3" fill="#b18b4d" stroke="none"/>
      <circle className="logo-firework-dot" cx="251" cy="29" r="1.2" fill="#6f8551" stroke="none"/>
      <circle className="logo-firework-dot" cx="288" cy="29" r="1.1" fill="#b18b4d" stroke="none"/>
    </g>
  </svg>;
}
