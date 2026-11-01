import { equipmentManuals } from '../lib/equipment';

export default function EquipmentManuals() {
  return <section id="pondster-own-maintenance" className="equipment-guides" aria-labelledby="pondster-equipment-guides-heading">
    <h2 id="pondster-equipment-guides-heading">My equipment guides</h2>
    <p className="manage-notice">I’m sharing manufacturer guides for my selected equipment. I still need to confirm installation, connections and setup; these links do not give visitors access to my cameras or control of my receiver.</p>
    <div className="knowledge-grid">
      {equipmentManuals.map(equipment => <article
        key={equipment.id}
        id={`pondster-own-${equipment.id}`}
        aria-labelledby={`pondster-own-${equipment.id}-heading`}
      >
        <h3 id={`pondster-own-${equipment.id}-heading`}>{equipment.title}</h3>
        <p><strong>{equipment.model}</strong></p>
        <p>{equipment.summary}</p>
        <p>{equipment.status}</p>
        <ul>{equipment.facts.map(fact => <li key={fact}>{fact}</li>)}</ul>
        <ul className="equipment-guide-links">
          {equipment.guides.map(guide => <li key={guide.url}>
            <a
              className="solid-link"
              href={guide.url}
              target="_blank"
              rel="noopener noreferrer"
              aria-label={`${guide.label} (${guide.format}; opens in a new tab)`}
            >{guide.label} ({guide.format}) <span aria-hidden="true">↗</span></a>
          </li>)}
        </ul>
        <a
          className="solid-link"
          href={equipment.productUrl}
          target="_blank"
          rel="noopener noreferrer"
          aria-label={`${equipment.model} manufacturer product page (opens in a new tab)`}
        >Manufacturer product page <span aria-hidden="true">↗</span></a>
      </article>)}
    </div>
  </section>;
}
