import { basementColorSchemes, masterBathDesigns, hallBathDesigns } from './features.js';

export type DesignView = { image: string; label: string };
// Optional views are one choice's ordered pictures; the first is its primary image.
export type Design = { id: string; title: string; image: string; detail: string; fullImage?: boolean; views?: DesignView[] };
export type Gallery = { id: string; name: string; summary: string; designs: Design[] };
export const galleries: Gallery[] = [
  { id: 'kitchen', name: 'Kitchen', summary: 'I will feature cabinetry, surfaces, lighting, and my everyday details.', designs: [] },
  { id: 'media-center', name: 'Living Room', summary: 'I will feature a framed TV with my selected manual MM-MAX1 mount. I have six cabinet-and-backdrop color options for my Living Room. My images are AI concepts, not manufacturer paint specifications or proof of installed finishes.', designs: [
    { id: 'media-01', title: 'Warm Ivory Cream', image: 'media-01-warm-ivory.png', detail: 'In this design, I will feature warm ivory cream on my cabinets and TV frame, with muted warm mushroom taupe behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-02', title: 'Soft Dusty Sage Green', image: 'media-02-soft-sage.png', detail: 'In this design, I will feature soft dusty sage green on my cabinets and TV frame, with warm pale cream behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-03', title: 'Deep Muted Navy Blue', image: 'media-03-deep-navy.png', detail: 'In this design, I will feature deep muted navy blue on my cabinets and TV frame, with light warm greige behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-04', title: 'Medium Mushroom Taupe', image: 'media-04-mushroom-taupe.png', detail: 'In this design, I will feature medium mushroom taupe on my cabinets and TV frame, with soft warm ivory behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-05', title: 'Deep Muted Olive Green', image: 'media-05-deep-olive.png', detail: 'In this design, I will feature deep muted olive green on my cabinets and TV frame, with light warm sand behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' },
    { id: 'media-06', title: 'Rich Charcoal Gray', image: 'media-06-charcoal-clay.png', detail: 'In this design, I will feature rich charcoal gray on my cabinets and TV frame, with muted terracotta clay behind my TV. In this concept, my walls stay warm off-white and my honey-toned floor stays unchanged.' }
  ] },
  { id: 'front-elevation', name: 'Front Elevation', summary: 'I will make a welcoming first impression. Compare my two exterior design options.', designs: [
    { id: 'front-23', title: 'Warm welcome', image: '23-front-final-with-garage.png', detail: 'In this design, I will feature warm lighting, wood shutters, and a coordinated garage in my exterior concept.' },
    { id: 'front-black-shutters', title: 'Black shutters', image: 'front-black-shutters.png', detail: 'In this design, I will feature black louvered shutters, contrasting dark and light siding, and warm exterior lighting at sunset in my exterior concept.' }
  ] },
  { id: 'garage-barn-door', name: 'Garage Barn Door', summary: 'I will feature wood doors with the selected finish from my three exterior design options.', designs: [
    { id: 'garage-06', title: 'Warm white board & batten', image: '06-wall-warm-white-board-batten.png', detail: 'In this design, I will feature a light exterior finish to bring out the warmth of my wood doors.' },
    { id: 'garage-07', title: 'Charcoal green board & batten', image: '07-wall-charcoal-green-board-batten.png', detail: 'In this design, I will feature a deeper exterior palette paired with natural wood.' },
    { id: 'garage-08', title: 'Limewashed brick', image: '08-wall-limewashed-brick.png', detail: 'In this design, I will feature pale masonry with a softer, textured appearance.' }
  ] },
  { id: 'adu', name: 'ADU', summary: 'I will include an accessory dwelling unit. My design images will follow.', designs: [] },
  { id: 'master-bath', name: 'Master Bath', summary: 'I will feature my refined Master Bath vanity layout in the selected cabinet color. I have six visual concepts for your vote, not manufacturer paint specifications or installed finishes.', designs: masterBathDesigns },
  { id: 'hall-bath', name: 'Hall Bath', summary: 'I will feature a floating vanity and tub-and-shower arrangement in my Hall Bath, with six color options for your vote. I keep the arrangement and fixed finishes from my supplied image; my AI studies do not confirm paint codes, dimensions, or installed finishes.', designs: hallBathDesigns },
  { id: 'spiral-staircase', name: 'Home Theatre', summary: 'I will feature my Home Theatre with a screen, black spiral staircase, and amber lighting. Compare my original design and six full-scene color options. My AI studies leave dimensions, clearances, and construction details unconfirmed.', designs: [
    { id: 'spiral-01', title: 'Black spiral staircase', image: 'home-theater-spiral-staircase-amber.png', fullImage: true, detail: 'In this design, I will feature black spiral stairs with amber tread and cove lighting beside my home theater. My AI concept does not confirm dimensions, clearances, or construction details.' },
    ...basementColorSchemes.map(scheme => ({ id: `spiral-basement-${scheme.slug}`, title: `Stair setting · ${scheme.title}`, image: scheme.image, detail: scheme.detail, fullImage: true }))
  ] },
  { id: 'back-deck', name: 'Back Deck', summary: 'I will feature a courtyard deck with a barn door stain. My wide and closer views show one design choice; my materials, dimensions, and construction details still need confirmation.', designs: [
    { id: 'oak-courtyard', title: 'Barn door stain', image: '/images/deck/barn-door-stain-wide.png', fullImage: true,
      views: [
        { image: '/images/deck/barn-door-stain-wide.png', label: 'Wide view' },
        { image: '/images/deck/barn-door-stain-closeup.png', label: 'Closer view' }
      ],
      detail: 'I will feature a barn door stain on my courtyard deck. My wide and closer views show the same design, with one shared vote. These are illustrative concepts; my exact materials, dimensions, structure, and construction details still need confirmation.' }
  ] }
];
export const allDesigns = galleries.flatMap(gallery => gallery.designs.map(design => ({...design, room: gallery.name})));
