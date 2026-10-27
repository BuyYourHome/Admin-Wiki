import type { ReactNode } from 'react';

export default function ContactPage({ active, children }: { active:boolean; children:ReactNode }) {
  return <section className="secondary-page contact-page" hidden={!active} aria-labelledby="contact-heading">
    <div className="contact-intro"><div><h1 id="contact-heading">Let’s <em>talk.</em></h1></div><p className="lead">Ask me about my designs, my story, or a visit. I’ve also brought my realtor and the company behind me together here.</p></div>
    <div className="contact-layout">
      <div className="contact-conversation">{children}</div>
      <aside className="contact-people" aria-label="My public contacts">
        <article className="contact-card" aria-labelledby="contact-ashley">
          <div className="contact-person"><img src="/people/ashley-morello.jpg" alt="Ashley Morello, my realtor" width="80" height="80" decoding="async"/><div><p className="eyebrow">MY REALTOR</p><h2 id="contact-ashley">Ashley Morello</h2></div></div>
          <p>For buying or arranging a real visit, Ashley is my connection.</p><p className="contact-affiliation">Element Realty Group<br/>at Howard Hanna Allen Tate</p>
          <address><a href="mailto:ashley@elementrealtygroup.net"><span>Email Ashley</span>ashley@elementrealtygroup.net ↗</a><a href="tel:+19194170612"><span>Call Ashley</span>919.417.0612 ↗</a></address>
          <a className="contact-website" href="https://ashleymorello.howardhanna.com/" target="_blank" rel="noopener noreferrer">My realtor’s official website ↗</a>
        </article>
        <article className="contact-card" aria-labelledby="contact-builder">
          <p className="eyebrow">THE COMPANY BEHIND ME</p><h2 id="contact-builder">Buy Your Home, LLC</h2><p>Wes Browning is my company’s public contact.</p>
          <address><a href="tel:+19199177466"><span>Call my company</span>919.917.7466 ↗</a></address>
          <a className="contact-website" href="https://www.buyyourhomellc.com/" target="_blank" rel="noopener noreferrer">Meet the company behind me ↗</a>
        </article>
        <p className="contact-note">My location remains confidential. Ashley confirms real viewing arrangements.</p>
      </aside>
    </div>
  </section>;
}
