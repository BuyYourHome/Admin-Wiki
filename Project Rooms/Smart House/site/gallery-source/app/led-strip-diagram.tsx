import { ledStripDiagram } from '../lib/led-strip-diagram';
import './lighting-controls.css';

export default function LedStripDiagram() {
  return <article id="pondster-own-led-strip-diagram" className="lighting-diagram" aria-labelledby="led-strip-diagram-heading">
    <span className="pending-tag">SUPPLIED PLANNING EXAMPLE</span>
    <h2 id="led-strip-diagram-heading">{ledStripDiagram.title}</h2>
    <p>{ledStripDiagram.summary}</p>
    <figure><a href={ledStripDiagram.pdf} target="_blank" rel="noopener noreferrer" aria-label="View the supplied generic 12-volt LED-strip example PDF"><img src={ledStripDiagram.image} width={1320} height={1020} loading="lazy" alt="Supplied LED example: a BLU Bluetooth wall station and a separate wired manual switch both control one Pro RGBWW PM, which dims 12-volt strips."/></a><figcaption>{ledStripDiagram.caption}</figcaption></figure>
    <p>{ledStripDiagram.limits}</p>
    <p>The Pro’s stated limits are 6 amps per output and 16 amps combined. My source output plan keeps channel quantities separate from controller quantities; supply sizing, cable routes, protection and exact equipment acceptance still need review.</p>
    <div className="lighting-diagram-links"><a className="solid-link" href={ledStripDiagram.pdf} target="_blank" rel="noopener noreferrer">View my LED-strip example (PDF)</a><a href={ledStripDiagram.pdf} download="generic-led-strip-control.pdf">Download the supplied PDF</a></div>
  </article>;
}
