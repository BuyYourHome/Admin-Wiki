import { lightingDiagram } from '../lib/lighting-diagram';
import './lighting-controls.css';

export default function LightingDiagram(){
  return <article id="pondster-own-lighting-diagram" className="lighting-diagram" aria-labelledby="lighting-diagram-heading">
    <span className="pending-tag">PLANNING EXAMPLE</span>
    <h2 id="lighting-diagram-heading">{lightingDiagram.title}</h2>
    <p>{lightingDiagram.summary}</p>
    <figure><a href={lightingDiagram.pdf} target="_blank" rel="noopener noreferrer" aria-label="View the four-light, six-control example PDF"><img src={lightingDiagram.image} width={1540} height={1190} loading="lazy" alt="Planning schematic: one Shelly wall dimmer feeds four lights; five ordinary remote switches connect to two i4 input modules that send commands over local Wi-Fi."/></a><figcaption>{lightingDiagram.limits}</figcaption></figure>
    <p>This example does not replace my current circuit schedule. Compatible dimmable LED/CFL fixtures must stay within the dimmer’s 150-watt combined limit. Exact equipment, wiring, box fill and grounding need electrician review.</p>
    <div className="lighting-diagram-links"><a className="solid-link" href={lightingDiagram.pdf} target="_blank" rel="noopener noreferrer">View my example diagram (PDF)</a><a href={lightingDiagram.pdf} download="lighting-four-lights-six-controls.pdf">Download the diagram</a></div>
  </article>;
}
