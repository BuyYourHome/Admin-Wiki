import type { Gallery } from './designs';

export type TourVoteStatus = 'leader' | 'tied' | 'no-votes' | 'unavailable';
export type TourRoomResults = Record<string, { scores: Record<string, number>; total: number } | null | undefined>;
export type TourScene = {
  id: string;
  roomId: string;
  roomName: string;
  designId: string;
  designTitle: string;
  title: string;
  image: string;
  kind: 'design' | 'motion';
  durationSeconds: number;
  votes: number;
  totalVotes: number;
  status: TourVoteStatus;
  tieCount: number;
  description: string;
  video?: string;
  poster?: string;
  sourceCredit?: string;
  sourceUrl?: string;
  sourceNotice?: string;
  sourceNoticeUrl?: string;
};

const roomOrder = ['front-elevation', 'media-center', 'master-bath', 'garage-barn-door'];
const publicImage = (image: string) => image.startsWith('/') ? image : `/concepts/${image}`;

/** Build a tour from the supplied catalog and vote snapshot without changing either. */
export function buildTourScenes(galleries: readonly Gallery[], roomResults: TourRoomResults): TourScene[] {
  const orderedRooms = galleries.map((gallery, index) => ({ gallery, index }))
    .filter(({ gallery }) => gallery.designs.length > 0)
    .sort((a, b) => {
      const aPriority = roomOrder.indexOf(a.gallery.id), bPriority = roomOrder.indexOf(b.gallery.id);
      return (aPriority < 0 ? roomOrder.length : aPriority) - (bPriority < 0 ? roomOrder.length : bPriority) || a.index - b.index;
    });
  const scenes: TourScene[] = [];
  for (const { gallery } of orderedRooms) {
    const result = roomResults?.[gallery.id];
    const available = !!result && !!result.scores && typeof result.scores === 'object' && !Array.isArray(result.scores);
    const scores = available ? result.scores : {};
    const validScores = gallery.designs.map(design => {
      const value = Object.prototype.hasOwnProperty.call(scores, design.id) ? scores[design.id] : 0;
      return typeof value === 'number' && Number.isFinite(value) && value >= 0 ? value : 0;
    });
    const highest = Math.max(0, ...validScores);
    const winnerIndex = highest > 0 ? validScores.indexOf(highest) : 0;
    const winner = gallery.designs[winnerIndex];
    const tieCount = highest > 0 ? validScores.filter(score => score === highest).length : 0;
    const status: TourVoteStatus = !available ? 'unavailable' : highest === 0 ? 'no-votes' : tieCount > 1 ? 'tied' : 'leader';
    const voteNote = status === 'unavailable' ? 'I couldn’t load this gallery’s votes, so I’m showing my first concept without claiming a leader.'
      : status === 'no-votes' ? 'I don’t have votes for this gallery yet, so I’m starting with my first design concept.'
      : status === 'tied' ? `I’m showing the first of ${tieCount} designs tied for the lead, using my gallery order to keep the tour consistent.`
      : 'I’m showing the design with the most votes in this gallery.';
    const shared = {
      roomId: gallery.id, roomName: gallery.name, designId: winner.id, designTitle: winner.title,
      image: publicImage(winner.image), votes: highest, totalVotes: validScores.reduce((sum, score) => sum + score, 0), status, tieCount
    };
    const still: TourScene = { ...shared, id: `${gallery.id}-design`, title: winner.title, kind: 'design', durationSeconds: 8, description: `${voteNote} ${winner.detail}` };
    const fallbackNote = status === 'unavailable' ? 'If my film cannot play, I use my first concept as a fallback because I couldn’t load votes, without claiming a leader.'
      : status === 'no-votes' ? 'If my film cannot play, I use my first concept as a fallback because this gallery has no votes yet.'
      : status === 'tied' ? `If my film cannot play, I use the first of ${tieCount} designs tied for the lead as my fallback, using my gallery order.`
      : `If my film cannot play, I use ${winner.title} as my fallback, the design with the most votes in this gallery.`;

    // A gallery contributes one scene: its known film takes priority over its
    // still. The winning design fields remain the film's fallback/context only.
    let motion: TourScene | undefined;
    if (gallery.id === 'media-center') motion = {
      ...shared, id: `${gallery.id}-motion`, kind: 'motion', title: 'My Media Center in motion', durationSeconds: 10,
      video: '/media/media-center-kitchen-view.mp4', poster: '/media/media-center-art-poster.png',
      description: `I’m showing a separate illustrative motion film, not a film of the selected voting design. My decorative frame stays fixed while my TV turns toward my kitchen and artwork becomes moving football. My mount mechanics haven’t been validated. ${fallbackNote}`,
      sourceCredit: 'Football footage: U.S. Marine Corps / Sgt. James Stanfield, via DVIDS.',
      sourceUrl: 'https://www.dvidshub.net/video/947000/125th-army-navy-football-game-b-roll',
      sourceNotice: 'The appearance of U.S. Department of War (DoW) visual information does not imply or constitute DoW endorsement.',
      sourceNoticeUrl: 'https://www.dvidshub.net/about/copyright'
    };
    else if (gallery.id === 'spiral-staircase') motion = {
      ...shared, id: `${gallery.id}-motion`, kind: 'motion', title: 'My theater and stair lights in motion', durationSeconds: 12,
      video: '/media/theater-football-sequential-stair-lights.mp4', poster: '/media/theater-stair-lights-poster.jpg',
      description: `I’m showing a separate illustrative motion film, not a film of the selected voting design. Moving football fills my theater screen while my amber stair lights illuminate in sequence. My staircase, lighting, dimensions, and clearances still need validation. ${fallbackNote}`,
      sourceCredit: 'Football credit shown in my film: U.S. Marine Corps / Sgt. James Stanfield, via DVIDS.',
      sourceUrl: 'https://www.dvidshub.net/video/947000/125th-army-navy-football-game-b-roll',
      sourceNotice: 'The appearance of U.S. Department of War (DoW) visual information does not imply or constitute DoW endorsement.',
      sourceNoticeUrl: 'https://www.dvidshub.net/about/copyright'
    };
    else if (gallery.id === 'garage-barn-door') motion = {
      ...shared, id: `${gallery.id}-motion`, kind: 'motion', title: 'My Garage Barn Door in motion', durationSeconds: 25,
      video: '/media/garage-barn-door-tesla-drive-out.mp4', poster: '/media/garage-barn-door-drive-out-poster.jpg',
      description: `I’m showing a separate illustrative motion film, not a film of the selected voting design. My center entry section swings inward and closes before my full door slides left. A white Tesla drives out to reveal my white-marble garage floor. My hardware, clearances, and the car’s turning path haven’t been validated. ${fallbackNote}`
    };
    scenes.push(motion ?? still);
  }
  return scenes;
}
