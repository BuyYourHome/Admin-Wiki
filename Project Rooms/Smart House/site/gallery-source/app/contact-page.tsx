import type { ReactNode } from 'react';

export default function ContactPage({ active, comments, children }: { active:boolean; comments?:ReactNode; children:ReactNode }) {
  return <section className="secondary-page contact-page" hidden={!active} aria-labelledby="contact-heading">
    <div className="contact-intro"><div><h1 id="contact-heading">Let’s <em>talk.</em></h1></div><p className="lead">Ask me about my designs, my story, or a visit. I’ve also brought my realtor and the company behind me together here.</p></div>
    <div className="contact-layout">
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
    <section className="contact-trades" aria-labelledby="contact-trades-heading">
      <h2 id="contact-trades-heading">My trade contacts.</h2>
      <p>Let me introduce the people who help build and care for me.</p>
      <div className="contact-trade-grid">
        {[
          ['general-contractor', 'General contractor', 'Glasgow Design Build', 'Glasgow Design Build is my general contractor.', 'https://glasgowdb.com/'],
          ['plumber', 'Plumber', 'Executive Plumbing Company', 'Executive Plumbing Company is my plumbing contact.', 'https://www.executiveplumbingcompany.com/'],
          ['hvac', 'HVAC', 'True Service', 'True Service is my heating and cooling contact.', 'https://www.trueserviceinc.com/'],
        ].map(([id, role, company, description, website]) => <article className="contact-card contact-trade-card" key={id} aria-labelledby={`contact-trade-${id}`}>
          <p className="eyebrow">{role}</p>
          <h3 id={`contact-trade-${id}`}>{company}</h3>
          <p>{description}</p>
          <a className="contact-website" href={website} target="_blank" rel="noopener noreferrer">{company}’s official website ↗</a>
        </article>)}
      </div>
    </section>
    {comments}
    <div className="contact-conversation">{children}</div>
  </section>;
}
