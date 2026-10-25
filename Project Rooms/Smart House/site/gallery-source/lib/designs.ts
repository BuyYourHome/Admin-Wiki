import { basementColorSchemes, masterBathDesigns, hallBathDesigns } from './features.js';

export type Design = { id: string; title: string; image: string; detail: string; fullImage?: boolean };
export type Gallery = { id: string; name: string; summary: string; designs: Design[] };
export const galleries: Gallery[] = [
  { id: 'kitchen', name: 'Kitchen', summary: 'I’m exploring cabinetry, surfaces, lighting, and my everyday details.', designs: [] },
  { id: 'media-center', name: 'Media Center', summary: 'I’m comparing six cabinet color studies, my original amber-lit theater, and six full-scene basement palettes. My images are AI concepts, not manufacturer paint specifications or proof of installed finishes.', designs: [
    { id: 'media-01', title: 'Warm Ivory Cream', image: 'media-01-warm-ivory.png', detail: 'I’m trying warm ivory cream on my cabinets and TV frame, with muted warm mushroom taupe behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-02', title: 'Soft Dusty Sage Green', image: 'media-02-soft-sage.png', detail: 'I’m trying soft dusty sage green on my cabinets and TV frame, with warm pale cream behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-03', title: 'Deep Muted Navy Blue', image: 'media-03-deep-navy.png', detail: 'I’m trying deep muted navy blue on my cabinets and TV frame, with light warm greige behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-04', title: 'Medium Mushroom Taupe', image: 'media-04-mushroom-taupe.png', detail: 'I’m trying medium mushroom taupe on my cabinets and TV frame, with soft warm ivory behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-05', title: 'Deep Muted Olive Green', image: 'media-05-deep-olive.png', detail: 'I’m trying deep muted olive green on my cabinets and TV frame, with light warm sand behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-06', title: 'Rich Charcoal Gray', image: 'media-06-charcoal-clay.png', detail: 'I’m trying rich charcoal gray on my cabinets and TV frame, with muted terracotta clay behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-07', title: 'Amber-lit home theater', image: 'home-theater-spiral-staircase-amber.png', fullImage: true, detail: 'I’m exploring an amber-lit home theater with a black spiral staircase, glowing treads, and cove lighting. My AI concept does not confirm installed finishes, stair dimensions, or clearances.' },
    ...basementColorSchemes.map(scheme => ({ id: `media-basement-${scheme.slug}`, title: `Basement · ${scheme.title}`, image: scheme.image, detail: scheme.detail, fullImage: true }))
  ] },
  { id: 'front-elevation', name: 'Front Elevation', summary: 'Compare two ideas for my first impression.', designs: [
    { id: 'front-23', title: 'Warm welcome', image: '23-front-final-with-garage.png', detail: 'I’m exploring warm lighting, wood shutters, and a coordinated garage in this exterior concept.' },
    { id: 'front-black-shutters', title: 'Black shutters', image: 'front-black-shutters.png', detail: 'I’m trying black louvered shutters, contrasting dark and light siding, and warm exterior lighting at sunset in this exterior concept.' }
  ] },
  { id: 'garage-barn-door', name: 'Garage Barn Door', summary: 'I’m comparing three exterior finishes around my wood doors.', designs: [
    { id: 'garage-06', title: 'Warm white board & batten', image: '06-wall-warm-white-board-batten.png', detail: 'I’m trying a light exterior finish to bring out the warmth of my wood doors in this concept.' },
    { id: 'garage-07', title: 'Charcoal green board & batten', image: '07-wall-charcoal-green-board-batten.png', detail: 'I’m exploring a deeper exterior palette paired with natural wood in this concept.' },
    { id: 'garage-08', title: 'Limewashed brick', image: '08-wall-limewashed-brick.png', detail: 'I’m considering pale masonry with a softer, textured appearance in this concept.' }
  ] },
  { id: 'adu', name: 'ADU', summary: 'I’m collecting ideas for an accessory dwelling unit.', designs: [] },
  { id: 'master-bath', name: 'Master Bath', summary: 'I’m comparing six cabinet color studies in my refined Master Bath vanity layout. These are visual concepts, not manufacturer paint specifications or installed finishes.', designs: masterBathDesigns },
  { id: 'hall-bath', name: 'Hall Bath', summary: 'I’m comparing six tub-and-shower color studies with my floating vanity in my Hall Bath. I keep the arrangement and fixed finishes from my supplied image; my AI studies do not confirm paint codes, dimensions, or installed finishes.', designs: hallBathDesigns },
  { id: 'spiral-staircase', name: 'Spiral Staircase', summary: 'I’m comparing my original black spiral staircase concept with six color settings around my stairs and theater. I keep my black stairs and amber lights throughout. My AI studies leave dimensions, clearances, and construction details unconfirmed.', designs: [
    { id: 'spiral-01', title: 'Black spiral staircase', image: 'home-theater-spiral-staircase-amber.png', fullImage: true, detail: 'I’m exploring black spiral stairs with amber tread and cove lighting beside my home theater. My AI concept does not confirm dimensions, clearances, or construction details.' },
    ...basementColorSchemes.map(scheme => ({ id: `spiral-basement-${scheme.slug}`, title: `Stair setting · ${scheme.title}`, image: scheme.image, detail: scheme.detail, fullImage: true }))
  ] },
  { id: 'back-deck', name: 'Back Deck', summary: 'I’m collecting ideas for my back deck, from layout and finishes to outdoor living.', designs: [] }
];
export const allDesigns = galleries.flatMap(gallery => gallery.designs.map(design => ({...design, room: gallery.name})));
