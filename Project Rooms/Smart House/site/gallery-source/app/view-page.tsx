import { useEffect, useRef } from 'react';
import ViewingDemo from './viewing-demo';
import VirtualTour from './virtual-tour';
import DesignCardImages from './design-card-images';
import { allDesigns, type Design } from '../lib/designs';

const viewingEmail = 'mailto:ashley@elementrealtygroup.net?subject=Pondster%20viewing%20request&body=Hello%20Ashley%2C%0A%0AI%20would%20like%20to%20arrange%20a%20viewing%20of%20Pondster.%0A%0AMy%20preferred%20dates%20and%20times%3A%20%0AMy%20name%3A%20%0AMy%20phone%20number%3A%20%0A%0APlease%20confirm%20availability%20and%20viewing%20arrangements.%20Thank%20you.';

export default function ViewPage({ onImage, onDesign, onTourStart, tourRequest = null, onTourRequestHandled }: { onImage: (design: Design) => void; onDesign: () => void; onTourStart: () => void; tourRequest?: number|null; onTourRequestHandled?: () => void }) {
  const page = useRef<HTMLElement>(null);
  const consumedTourRequest = useRef<number|null>(null);
  useEffect(() => {
    if(tourRequest===null || consumedTourRequest.current===tourRequest)return;
    consumedTourRequest.current=tourRequest;
    onTourRequestHandled?.();
    // Reuse my real Start control, including voice cleanup and browser fallbacks.
    page.current?.querySelector<HTMLButtonElement>('.virtual-tour-invitation button.tour-start')?.click();
  },[tourRequest,onTourRequestHandled]);
  return <section ref={page} className="secondary-page viewing-page">
    <div className="viewing-intro"><div><h1>Come meet <em>me.</em></h1></div><p className="lead">Meet Ashley, my realtor, and find out about visiting me as I take shape.</p></div>
    <VirtualTour onStart={onTourStart}/>
    <p className="buyer-design-note">Buy me early, while I’m still taking shape, and you can have a say in my final design. Help choose from the finishes and details that are still open, so I can feel like your home from the start. Talk with Ashley, my realtor, about which choices are available and when they need to be made.</p>
    <div className="viewing-layout">
      <article className="realtor-card" aria-labelledby="realtor-name">
        <div className="realtor-photo has-portrait"><img src="/people/ashley-morello.jpg" alt="Ashley Morello, my realtor" width="628" height="628" decoding="async"/><span>MY REALTOR</span></div>
        <div className="realtor-content"><p className="eyebrow">MY REALTOR. A PERSONAL CONNECTION.</p><h2 id="realtor-name">Ashley Morello</h2><p className="realtor-role">REALTOR® · Team Founder</p><p className="realtor-brokerage">Element Realty Group<br/>at Howard Hanna Allen Tate</p><p className="realtor-bio">My realtor, Ashley, helps buyers and sellers across Cary, Apex, Raleigh, and the surrounding Triangle communities. I’d like you to know her approach: local market knowledge, thoughtful home preparation, and guidance through each step of a move.</p><div className="realtor-contacts"><a href="mailto:ashley@elementrealtygroup.net"><span>EMAIL ASHLEY</span>ashley@elementrealtygroup.net ↗</a><a href="tel:+19194170612"><span>CALL ASHLEY</span>919.417.0612 ↗</a></div><a className="realtor-website" href="https://ashleymorello.howardhanna.com/" target="_blank" rel="noopener noreferrer">Visit my realtor’s official website ↗</a><a className="realtor-team" href="https://elementrealtygroup.net/" target="_blank" rel="noopener noreferrer">Meet my realtor’s team ↗</a></div>
      </article>
      <section className="self-viewing" aria-labelledby="self-viewing-title"><div className="tour-symbol" aria-hidden="true">↗</div><span className="pending-tag">MY SELF-GUIDED VIEWING PREVIEW</span><h2 id="self-viewing-title">Preview a visit<br/><em>with me.</em></h2><p>I can show you a self-guided visit preview with a date, time, and simulated entry code. I’m demonstrating the idea while real appointments and lock access are being prepared.</p><ViewingDemo/><div className="real-viewing"><p className="eyebrow">READY TO MEET ME?</p><a href={viewingEmail}>Arrange a real visit with my realtor ↗</a><p>For a real visit with me, email Ashley and wait for her to confirm the arrangements.</p></div></section>
    </div>
    <details className="view-notebook"><summary><span><span className="eyebrow">BEFORE YOU MEET ME</span><span className="notebook-title">Explore my visual notebook.</span></span><span className="notebook-toggle" aria-hidden="true">+</span></summary><p className="lead">I will bring my interior and exterior features to life in the selected designs. My images are AI design studies, not photographs of completed work.</p><div className="visual-grid">{allDesigns.map(design=><article key={design.id}><DesignCardImages design={design} onOpen={onImage}/><p className="eyebrow">{design.room}</p><h3>{design.title}</h3></article>)}</div><a className="solid-link" href="#design" onClick={onDesign}>Compare my designs and vote ↗</a></details>
  </section>;
}
