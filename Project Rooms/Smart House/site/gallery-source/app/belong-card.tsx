import type { ReactNode } from 'react';
import './belong-card.css';

/** Native disclosures remain independently expandable and work without custom key handlers. */
export default function BelongCard({id,title,headingId,level=2,className='',children}:{id?:string;title:string;headingId:string;level?:2|3;className?:string;children:ReactNode}) {
  const Heading=level===3?'h3':'h2';
  return <details id={id} className={`belong-card ${className}`.trim()} aria-labelledby={headingId}>
    <summary><Heading id={headingId}>{title}</Heading></summary>
    <div className="belong-card-body">{children}</div>
  </details>;
}
