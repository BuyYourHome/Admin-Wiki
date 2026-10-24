export type Design = { id: string; title: string; image: string; detail: string };
export type Gallery = { id: string; name: string; summary: string; designs: Design[] };
export const galleries: Gallery[] = [
  { id: 'kitchen', name: 'Kitchen', summary: 'Cabinetry, surfaces, lighting, and the details of everyday living.', designs: [] },
  { id: 'media-center', name: 'Media Center', summary: 'Six cabinet and backdrop color studies. Concept colors, not manufacturer paint specifications.', designs: [
    { id: 'media-01', title: 'Warm Ivory Cream', image: 'media-01-warm-ivory.png', detail: 'Cabinets and TV frame: warm ivory cream. Central TV backdrop: muted warm mushroom taupe. Surrounding walls stay warm off-white; honey-toned wood floor stays unchanged.' },
    { id: 'media-02', title: 'Soft Dusty Sage Green', image: 'media-02-soft-sage.png', detail: 'Cabinets and TV frame: soft dusty sage green. Central TV backdrop: warm pale cream. Surrounding walls stay warm off-white; honey-toned wood floor stays unchanged.' },
    { id: 'media-03', title: 'Deep Muted Navy Blue', image: 'media-03-deep-navy.png', detail: 'Cabinets and TV frame: deep muted navy blue. Central TV backdrop: light warm greige. Surrounding walls stay warm off-white; honey-toned wood floor stays unchanged.' },
    { id: 'media-04', title: 'Medium Mushroom Taupe', image: 'media-04-mushroom-taupe.png', detail: 'Cabinets and TV frame: medium mushroom taupe. Central TV backdrop: soft warm ivory. Surrounding walls stay warm off-white; honey-toned wood floor stays unchanged.' },
    { id: 'media-05', title: 'Deep Muted Olive Green', image: 'media-05-deep-olive.png', detail: 'Cabinets and TV frame: deep muted olive green. Central TV backdrop: light warm sand. Surrounding walls stay warm off-white; honey-toned wood floor stays unchanged.' },
    { id: 'media-06', title: 'Rich Charcoal Gray', image: 'media-06-charcoal-clay.png', detail: 'Cabinets and TV frame: rich charcoal gray. Central TV backdrop: muted terracotta clay. Surrounding walls stay warm off-white; honey-toned wood floor stays unchanged.' }
  ] },
  { id: 'front-elevation', name: 'Front Elevation', summary: 'The first impression. Compare two exterior concepts for Pond Street.', designs: [
    { id: 'front-23', title: 'Warm welcome', image: '23-front-final-with-garage.png', detail: 'An exterior study combining warm lighting, wood shutters, and a coordinated garage.' },
    { id: 'front-black-shutters', title: 'Black shutters', image: 'front-black-shutters.png', detail: 'Black louvered shutters, contrasting dark and light siding, and warm exterior lighting at sunset.' }
  ] },
  { id: 'garage-barn-door', name: 'Garage Barn Door', summary: 'Three finish studies around the character of the wood doors.', designs: [
    { id: 'garage-06', title: 'Warm white board & batten', image: '06-wall-warm-white-board-batten.png', detail: 'A light exterior finish that lets the warmth of the wood stand out.' },
    { id: 'garage-07', title: 'Charcoal green board & batten', image: '07-wall-charcoal-green-board-batten.png', detail: 'A deeper exterior palette paired with natural wood.' },
    { id: 'garage-08', title: 'Limewashed brick', image: '08-wall-limewashed-brick.png', detail: 'A pale masonry finish with a softer, textured appearance.' }
  ] },
  { id: 'adu', name: 'ADU', summary: 'Design ideas for the accessory dwelling unit.', designs: [] },
  { id: 'master-bath', name: 'Master Bath', summary: 'Materials, fixtures, and a daily moment of calm.', designs: [] }
];
export const allDesigns = galleries.flatMap(gallery => gallery.designs.map(design => ({...design, room: gallery.name})));
