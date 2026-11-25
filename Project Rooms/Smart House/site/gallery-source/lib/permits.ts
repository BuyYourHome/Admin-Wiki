import type { GuideReply } from './pondster-guide';

/** Fixed public references only; these saved copies are not a live permit feed. */
export const permitPortal = {
  section: 'permit-portal',
  title: 'Cary permit search',
  url: 'https://cary-egov.aspgov.com/Click2GovBP/selectpermit.html?initialSearchView=true',
} as const;

export const permitReferences = [
  { section: 'building-permit', title: 'Building permit', pdf: '/documents/building-permit.pdf', fileDate: 'February 4, 2026' },
  { section: 'hvac-permit', title: 'HVAC permit', pdf: '/documents/hvac-permit.pdf', fileDate: 'August 14, 2026' },
  { section: 'hvac-inspections', title: 'HVAC required inspections', pdf: '/documents/hvac-required-inspections.pdf', fileDate: 'August 14, 2026' },
  { section: 'erosion-inspection', title: 'Erosion inspection status', pdf: '/documents/erosion-inspection-status.pdf', fileDate: 'September 22, 2026' },
  { section: 'under-slab-plumbing', title: 'Under-slab plumbing inspection status', pdf: '/documents/under-slab-plumbing-inspection-status.pdf', fileDate: 'September 15, 2026' },
] as const;

export const PERMIT_STATUS_NOTE = 'Cary’s portal has my latest permit and inspection information. These PDFs are saved record copies.';
export const PERMIT_KNOWLEDGE = `My Permits card is on Belong, section permits. ${PERMIT_STATUS_NOTE} My Cary permit-search portal is ${permitPortal.url}, section ${permitPortal.section}. My saved public PDF references are ${permitReferences.map(item => `${item.title}: ${item.pdf}, file date ${item.fileDate}, section ${item.section}`).join('; ')}. File dates identify the saved copies, not issuance dates or approval dates. A saved copy does not establish current approval, inspection completion or construction readiness. Reveal the precise public card item for a requested permit or inspection record. These links do not submit applications, schedule inspections or alter a government record. These five saved permit PDFs are approved public record references, including their identifying record details. Link to the matching record without reciting identifying details by default; ordinary page and conversation location copy stays at Cary, North Carolina. This exception grants no access to private owner records or live house systems.`;

export function isPermitSection(value:string|undefined) {
  return value==='permits'||value===permitPortal.section||permitReferences.some(item=>item.section===value);
}

/** Choose an authored reference, never a government action or arbitrary document URL. */
export function answerPermitReference(input:string,words:string):GuideReply|null {
  if(!/\b(permits?|inspections?|click2gov)\b/.test(words)&&!/\bcary (?:permit )?portal\b/.test(words))return null;
  const quoted=/["“”«»]|(?:^|[\s([:])['‘]|['’](?:$|[\s)\],:])/.test(input);
  const declined=/\b(don t|do not|dont|never|stop|cancel|not now)\b/.test(words);
  const compound=/\b(?:and|then|also|but)\b.*\b(?:show|open|go|play|send|email|buy|unlock|turn|switch|activate|enable|disable)\b/.test(words)
    || /\b(and|plus|with)\b.*\b(cameras?|audio|tour|gallery|lighting|shelly)\b/.test(words);
  if(quoted||declined||compound)return {text:'My saved permit and inspection references are on Belong. Ask directly for the reference you want to see.'};
  if(/\b(apply|submit|schedule|book|cancel|edit|change|pay|payment)\b/.test(words))return {text:'I can show my saved permit references and Cary’s search portal. I cannot submit applications, schedule inspections, change records or make payments.'};
  const section=/\b(portal|search|click2gov)\b/.test(words)?permitPortal.section
    : /\b(under slab|underslab|below slab|slab plumbing)\b/.test(words)?'under-slab-plumbing'
    : /\b(erosion|sediment)\b/.test(words)?'erosion-inspection'
    : /\b(hvac|heating|cooling|mechanical)\b/.test(words)?/\binspections?\b/.test(words)?'hvac-inspections':'hvac-permit'
    : /\bbuilding permit\b/.test(words)?'building-permit':'permits';
  const item=permitReferences.find(reference=>reference.section===section);
  return {text:item?`My saved ${item.title.toLowerCase()} PDF is in Belong: ${item.pdf}. ${PERMIT_STATUS_NOTE}`
    :section===permitPortal.section?`My Cary permit-search portal is linked in Belong: ${permitPortal.url}. ${PERMIT_STATUS_NOTE}`
    :`My Belong Permits card includes my building permit, HVAC permit and required inspections, erosion inspection status, and under-slab plumbing inspection status. ${PERMIT_STATUS_NOTE}`,
    action:{menu:'Own',section}};
}
