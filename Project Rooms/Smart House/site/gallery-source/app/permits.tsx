import { permitPortal, permitReferences, PERMIT_STATUS_NOTE } from '../lib/permits';
import './permits.css';
import BelongCard from './belong-card';

export default function Permits() {
  return <BelongCard id="pondster-own-permits" className="permit-records" title="My permits and inspections" headingId="permits-heading">
    <p>{PERMIT_STATUS_NOTE}</p>
    <div id={`pondster-own-${permitPortal.section}`} className="permit-reference">
      <h3>My Cary permit portal</h3>
      <p>I link to Cary’s permit search for the latest available records.</p>
      <a className="solid-link" href={permitPortal.url} target="_blank" rel="noopener noreferrer">Open Cary permit search</a>
    </div>
    <ul className="permit-document-list">
      {permitReferences.map(reference=><li id={`pondster-own-${reference.section}`} className="permit-reference" key={reference.section}>
        <h3>{reference.title}</h3>
        <p>Saved copy: {reference.fileDate}</p>
        <a className="solid-link" href={reference.pdf} target="_blank" rel="noopener noreferrer" aria-label={`View my ${reference.title.toLowerCase()} PDF (opens in a new tab)`}>View my {reference.title.toLowerCase()} (PDF)</a>
      </li>)}
    </ul>
  </BelongCard>;
}
