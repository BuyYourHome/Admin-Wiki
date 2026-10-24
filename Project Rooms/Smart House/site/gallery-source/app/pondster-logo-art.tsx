import type { CSSProperties } from 'react';

export default function PondsterLogoArt() {
  return <svg className="pondster-logo-art" viewBox="0 0 320 106" aria-hidden="true" focusable="false" pointerEvents="none" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path className="logo-vine-stem" pathLength={1} d="M31 101C15 99 7 90 6 76C4 59 4 40 12 25C19 11 35 7 47 14C61 22 64 40 61 57C58 73 55 84 70 91C85 98 105 94 126 93C151 91 169 90 191 93C219 97 243 95 267 92C281 90 293 87 300 90C309 94 303 102 296 98" stroke="#6f8551" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" vectorEffect="non-scaling-stroke"/>

    <g className="logo-vine-leaf" style={{ '--leaf-order': 0 } as CSSProperties}>
      <path d="M6 73C0 70 0 62 3 57C10 60 13 68 6 73Z" fill="#718750"/>
      <path className="logo-vine-vein" d="M6 72L4 62" stroke="#506b41" strokeWidth=".8" strokeLinecap="round"/>
    </g>
    <g className="logo-vine-leaf" style={{ '--leaf-order': 1 } as CSSProperties}>
      <path d="M16 20C8 21 6 13 8 7C17 7 23 13 16 20Z" fill="#81915c"/>
      <path className="logo-vine-vein" d="M16 19L11 11" stroke="#536f43" strokeWidth=".8" strokeLinecap="round"/>
    </g>
    <g className="logo-vine-leaf" style={{ '--leaf-order': 2 } as CSSProperties}>
      <path d="M39 12C41 4 48 1 55 4C54 12 47 17 39 12Z" fill="#6b824e"/>
      <path className="logo-vine-vein" d="M40 12L50 7" stroke="#4c663e" strokeWidth=".8" strokeLinecap="round"/>
    </g>
    <g className="logo-vine-leaf" style={{ '--leaf-order': 3 } as CSSProperties}>
      <path d="M59 76C63 68 72 68 78 72C75 81 67 84 59 76Z" fill="#89945e"/>
      <path className="logo-vine-vein" d="M60 76L72 74" stroke="#5c7447" strokeWidth=".8" strokeLinecap="round"/>
    </g>
    <g className="logo-vine-leaf" style={{ '--leaf-order': 4 } as CSSProperties}>
      <path d="M108 94C117 92 123 97 123 104C114 106 108 101 108 94Z" fill="#738953"/>
      <path className="logo-vine-vein" d="M109 95L119 101" stroke="#506b41" strokeWidth=".8" strokeLinecap="round"/>
    </g>
    <g className="logo-vine-leaf" style={{ '--leaf-order': 5 } as CSSProperties}>
      <path d="M167 92C175 93 181 98 178 105C169 105 164 100 167 92Z" fill="#89945e"/>
      <path className="logo-vine-vein" d="M168 93L175 102" stroke="#5c7447" strokeWidth=".8" strokeLinecap="round"/>
    </g>
    <g className="logo-vine-leaf" style={{ '--leaf-order': 6 } as CSSProperties}>
      <path d="M236 95C245 92 252 96 254 103C245 107 238 103 236 95Z" fill="#6b824e"/>
      <path className="logo-vine-vein" d="M237 96L249 101" stroke="#4c663e" strokeWidth=".8" strokeLinecap="round"/>
    </g>

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
