import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import ts from 'typescript';
import { buildTourScenes } from '../lib/virtual-tour.ts';
import { galleries } from '../lib/designs.ts';

const require = createRequire(import.meta.url);
for (const extension of ['.ts', '.tsx']) require.extensions[extension] = (module, path) => module._compile(ts.transpileModule(readFileSync(path, 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS, jsx: ts.JsxEmit.ReactJSX, target: ts.ScriptTarget.ES2022 } }).outputText, path);
const { buildPondsterLiveSession } = require('../lib/pondster-live-context.ts');

const populated = galleries.filter(gallery => gallery.designs.length);
const emptyVotes = Object.fromEntries(populated.map(gallery => [gallery.id, { scores: {}, total: 0 }]));
const originalCatalog = JSON.stringify(galleries);

assert.deepEqual(buildTourScenes([], {}), []);
const pending = buildTourScenes(galleries, {});
assert.ok(pending.every(scene => scene.status === 'unavailable' && scene.votes === 0 && scene.tieCount === 0));
for (const scene of pending) assert.match(scene.description, /without claiming a leader/);

const zero = buildTourScenes(galleries, emptyVotes);
assert.deepEqual(zero.map(scene => scene.id), [
  'front-elevation-design', 'media-center-motion', 'master-bath-design',
  'garage-barn-door-motion', 'hall-bath-design', 'spiral-staircase-motion', 'back-deck-design'
]);
assert.ok(zero.every(scene => scene.status === 'no-votes' && scene.votes === 0 && scene.totalVotes === 0 && scene.tieCount === 0));
assert.equal(new Set(zero.map(scene => scene.id)).size, zero.length);
assert.equal(new Set(zero.map(scene => scene.roomId)).size, populated.length, 'Each populated gallery contributes exactly one scene.');
assert.ok(zero.filter(scene => scene.roomId !== 'back-deck').every(scene => scene.image.startsWith('/concepts/')));
assert.equal(zero.length, 7);
assert.equal(zero.filter(scene => scene.kind === 'motion').length, 3);
assert.ok(!zero.some(scene => ['kitchen', 'adu'].includes(scene.roomId)));
const deck = galleries.find(gallery => gallery.id === 'back-deck');
assert.equal(deck.designs.length, 1);
assert.equal(deck.designs[0].views.length, 2);
const deckPreview = zero.find(scene => scene.roomId === 'back-deck');
assert.equal(deckPreview.designId, 'oak-courtyard');
assert.equal(deckPreview.image, '/images/deck/barn-door-stain-wide.png');
assert.equal(deckPreview.kind, 'design');
assert.equal(deckPreview.video, undefined);
assert.equal(zero.filter(scene => scene.roomId === 'back-deck').length, 1, 'Two deck views produce one primary tour scene.');

const media = galleries.find(gallery => gallery.id === 'media-center');
const garage = galleries.find(gallery => gallery.id === 'garage-barn-door');
assert.equal(galleries.length, 9);
assert.equal(galleries.reduce((total, gallery) => total + gallery.designs.length, 0), 31, 'Garage replacements retain the catalog and existing voting choices.');
assert.deepEqual(garage.designs.map(({id,image,fullImage})=>({id,image,fullImage})),[
  {id:'garage-06',image:'garage-v18-warm-white.webp',fullImage:true},
  {id:'garage-07',image:'garage-v18-charcoal-green.webp',fullImage:true},
  {id:'garage-08',image:'garage-v18-limewashed-brick.webp',fullImage:true},
],'The three garage images replace the existing IDs in the same order with full-image presentation.');
const staircase = galleries.find(gallery => gallery.id === 'spiral-staircase');
const bath = galleries.find(gallery => gallery.id === 'master-bath');
const front = galleries.find(gallery => gallery.id === 'front-elevation');
const votes = {
  'front-elevation': { scores: { [front.designs[1].id]: 7, invented: 90000 }, total: 90007 },
  'media-center': { scores: { [media.designs[0].id]: 4, [media.designs[2].id]: 4, [media.designs[1].id]: NaN, [media.designs[3].id]: -8, [media.designs[4].id]: Infinity, invented: 1000 }, total: Infinity },
  'master-bath': { scores: { [bath.designs[4].id]: 6, [bath.designs[0].id]: 1 }, total: 7 },
  'garage-barn-door': null
};
const snapshot = structuredClone(votes);
const tour = buildTourScenes(galleries, votes);
const frontScene = tour.find(scene => scene.id === 'front-elevation-design');
assert.equal(frontScene.designId, front.designs[1].id);
assert.equal(frontScene.status, 'leader');
assert.equal(frontScene.votes, 7); assert.equal(frontScene.totalVotes, 7); assert.equal(frontScene.tieCount, 1);
const mediaScene = tour.find(scene => scene.id === 'media-center-motion');
assert.equal(mediaScene.kind, 'motion', 'An available film is primary even when designs have votes.');
assert.equal(mediaScene.designId, media.designs[0].id, 'A positive tie follows stable catalog order.');
assert.equal(mediaScene.status, 'tied'); assert.equal(mediaScene.tieCount, 2); assert.equal(mediaScene.totalVotes, 8);
assert.match(mediaScene.description, /2 designs tied/);
const bathScene = tour.find(scene => scene.id === 'master-bath-design');
assert.equal(bathScene.designId, bath.designs[4].id);
assert.equal(bathScene.designTitle, bath.designs[4].title);
assert.equal(bathScene.image, `/concepts/${bath.designs[4].image}`);
assert.equal(tour.find(scene => scene.id === 'garage-barn-door-motion').status, 'unavailable');
assert.deepEqual(votes, snapshot); assert.equal(JSON.stringify(galleries), originalCatalog);
assert.deepEqual(buildTourScenes(galleries, votes), tour, 'Identical inputs produce identical scene order and selections.');

for (const room of [media, garage, staircase]) {
  assert.equal(tour.filter(scene => scene.roomId === room.id).length, 1);
  assert.equal(tour.find(scene => scene.roomId === room.id && scene.kind === 'design'), undefined, 'A film gallery has no extra still scene.');
  const motion = tour.find(scene => scene.roomId === room.id && scene.kind === 'motion');
  const fallback = room.designs[0];
  assert.equal(motion.durationSeconds, room.id === 'media-center' ? 30 : room.id === 'spiral-staircase' ? 12 : 25);
  assert.equal(motion.image, `/concepts/${fallback.image}`, 'The vote-selected still is retained only as the playback fallback.');
  assert.equal(motion.designId, fallback.id);
  assert.equal(motion.designTitle, fallback.title);
  assert.notEqual(motion.title, fallback.title, 'An illustrative film has its own title, not the selected finish title.');
  assert.match(motion.description, /separate illustrative film/);
  assert.match(motion.description, /does not show the selected voting design|keeps its original design rather than the selected voting design|keeps its warm-white finish rather than changing with the selected voting design/);
  assert.ok(motion.video.startsWith('/media/') && motion.poster.startsWith('/media/'));
}
const mediaMotion = tour.find(scene => scene.id === 'media-center-motion');
assert.equal(mediaMotion.video, '/media/living-room-art-sports-cameras-v2.mp4');
assert.equal(mediaMotion.poster, '/media/living-room-art-sports-cameras-v2-poster.jpg');
assert.equal(mediaMotion.durationSeconds, 30);
assert.match(mediaMotion.description, /manual MM-MAX1.*positioned by hand/);
assert.match(mediaMotion.description, /TV fixed facing my Living Room.*viewpoint moves toward my TV/);
assert.match(mediaMotion.description, /2 seconds of still-life artwork, 4 seconds of football, then 24 seconds of four-camera simulations/);
assert.equal([...mediaMotion.description.matchAll(/(\d+) seconds of/g)].reduce((seconds, match) => seconds + Number(match[1]), 0), mediaMotion.durationSeconds, 'The stated art, sports and camera sections fill the new tour scene duration.');
assert.match(mediaMotion.description, /camera views are concepts, not live feeds/);
assert.match(mediaMotion.description, /selected mount’s fit and clearances still need validation/);
assert.doesNotMatch(mediaMotion.description, /turns toward my kitchen|automatic motion|automatic turning/);
assert.match(mediaMotion.sourceCredit, /Marine Corps.*James Stanfield.*DVIDS/);
assert.match(mediaMotion.sourceNotice, /does not imply or constitute DoW endorsement/);
assert.ok(mediaMotion.sourceUrl.startsWith('https://www.dvidshub.net/'));
assert.ok(mediaMotion.sourceNoticeUrl.startsWith('https://www.dvidshub.net/'));
const liveInstructions = buildPondsterLiveSession(galleries).instructions;
const liveFilmFact = liveInstructions.split('\n').find(line => line.startsWith('I will feature a framed TV'));
assert.ok(liveFilmFact, 'The actual live session retains the authored Living Room film fact.');
assert.match(liveFilmFact, /30-second Living Room film.*TV fixed facing my Living Room.*viewpoint moves toward my TV/);
assert.match(liveFilmFact, /2 seconds of still-life artwork, 4 seconds of football, then 24 seconds of four-camera simulations/);
assert.match(liveFilmFact, /concepts, not live feeds.*fit and clearances still need validation/);
assert.doesNotMatch(liveFilmFact, /automatic turning|turns toward my kitchen/);
assert.ok(liveInstructions.includes('My selected MM-MAX1 TV mount is manual; do not promise automatic turning.'), 'Keep the manual-mount safety instruction unchanged while updating the film description.');
const garageMotion = tour.find(scene => scene.id === 'garage-barn-door-motion');
assert.equal(garageMotion.video, '/media/garage-v18-warm-white.mp4');
assert.equal(garageMotion.poster, '/media/garage-v18-poster.jpg');
assert.equal(garageMotion.durationSeconds, 25);
assert.match(garageMotion.description, /swings outward.*slides left.*garage interior/);
assert.doesNotMatch(garageMotion.description, /swings inward|white.marble/);
assert.match(garageMotion.description, /keeps its warm-white finish rather than changing with the selected voting design/);
assert.match(garageMotion.sourceCredit, /2024 Tesla Model 3 Highland.*RBLXSupercars.*brandonleong28.*adapted and animated/);
assert.equal(garageMotion.sourceUrl, 'https://sketchfab.com/3d-models/tesla-model-3-2024-36c52f3f89f6439c90310f14e8ff33f2');
assert.match(garageMotion.sourceNotice, /CC BY 4\.0.*not endorsed by Tesla/);
assert.equal(garageMotion.sourceNoticeUrl, 'https://creativecommons.org/licenses/by/4.0/');
assert.equal(tour.find(scene => scene.id === 'spiral-staircase-motion').video, '/media/theater-football-sequential-stair-lights.mp4');
assert.match(tour.find(scene => scene.id === 'spiral-staircase-motion').sourceCredit, /credit shown.*Marine Corps.*James Stanfield.*DVIDS/);

const newColorWinners = {
  'media-center': { scores: { 'media-basement-midnight-navy': 9, 'media-07': 99, 'media-03': 4, 'media-01': 1 }, total: 113 },
  'spiral-staircase': { scores: { 'spiral-basement-coastal-blue': 8, 'spiral-01': 1 }, total: 9 },
  'garage-barn-door': { scores: { 'garage-08': 99, 'garage-06': 1 }, total: 100 }
};
const colorTour = buildTourScenes(galleries, newColorWinners);
assert.equal(colorTour.length, 7, 'Changing vote leaders never creates extra gallery scenes.');
assert.equal(colorTour.filter(scene => scene.kind === 'motion').length, 3);
assert.equal(colorTour.find(scene => scene.roomId === 'media-center').totalVotes, 5, 'Retired Living Room staircase IDs are ignored without migrating their historical votes.');
for (const [roomId, designId, image] of [
  ['media-center', 'media-03', '/concepts/media-03-deep-navy.png'],
  ['spiral-staircase', 'spiral-basement-coastal-blue', '/concepts/basement-coastal-blue.jpg'],
  ['garage-barn-door', 'garage-08', '/concepts/garage-v18-limewashed-brick.webp']
]) {
  const motion = colorTour.find(scene => scene.id === `${roomId}-motion`);
  assert.equal(colorTour.find(scene => scene.id === `${roomId}-design`), undefined);
  assert.equal(motion.kind, 'motion', 'An available film always takes priority over a newly leading image.');
  assert.equal(motion.status, 'leader');
  assert.equal(motion.designId, designId);
  assert.equal(motion.image, image, 'A new winning palette becomes the motion fallback still.');
  assert.equal(motion.designTitle, galleries.find(room => room.id === roomId).designs.find(design => design.id === designId).title);
  assert.match(motion.description, /separate illustrative film/);
  assert.match(motion.description, /does not show the selected voting design|keeps its original design rather than the selected voting design|keeps its warm-white finish rather than changing with the selected voting design/);
  assert.match(motion.description, /If my film cannot play.*fallback.*most votes/);
  assert.notEqual(motion.title, motion.designTitle);
  assert.equal(motion.video, tour.find(scene => scene.id === motion.id).video, 'The original film stays separate from the new color winner.');
}

const tubTour = buildTourScenes(galleries, {
  'hall-bath': { scores: { 'bath-tub-deep-navy': 8, 'bath-deep-navy': 2 }, total: 10 },
  'master-bath': { scores: { 'bath-deep-navy': 2, 'bath-tub-deep-navy': 99 }, total: 101 }
});
const tubStill = tubTour.find(scene => scene.id === 'hall-bath-design');
assert.equal(tubStill.designId, 'bath-tub-deep-navy');
assert.equal(tubStill.designTitle, 'Tub & shower · Deep Navy');
assert.equal(tubStill.image, '/concepts/master-bath-tub-deep-navy.jpg');
assert.equal(tubStill.status, 'leader');
assert.equal(tubStill.kind, 'design');
assert.equal(tubStill.durationSeconds, 8);
assert.equal(tubStill.video, undefined);
assert.equal(tubStill.totalVotes, 8, 'A Master Bath ID is ignored in Hall Bath results.');
assert.equal(tubTour.find(scene => scene.id === 'master-bath-design').designId, 'bath-deep-navy', 'Master Bath keeps its own original winner and ignores Hall Bath IDs.');
assert.equal(tubTour.length, 7, 'The Hall Bath winner occupies its own still scene.');
assert.equal(tubTour.filter(scene => scene.kind === 'motion').length, 3);

const deckTour = buildTourScenes(galleries, {
  'back-deck': { scores: { 'oak-courtyard': 3, 'oak-courtyard-closeup': 99 }, total: 102 }
});
const deckWinner = deckTour.find(scene => scene.roomId === 'back-deck');
assert.equal(deckWinner.designId, 'oak-courtyard');
assert.equal(deckWinner.image, '/images/deck/barn-door-stain-wide.png', 'A deck vote selects the primary wide view rather than a separate closeup entry.');
assert.equal(deckWinner.status, 'leader');
assert.equal(deckWinner.totalVotes, 3, 'Only the one catalog voting ID contributes to deck scores.');
assert.equal(deckTour.filter(scene => scene.roomId === 'back-deck').length, 1);

const badScores = { 'front-elevation': { scores: { [front.designs[0].id]: -1, [front.designs[1].id]: NaN, invented: 100 }, total: 100 } };
assert.equal(buildTourScenes(galleries, badScores)[0].status, 'no-votes');
assert.equal(buildTourScenes(galleries, badScores)[0].totalVotes, 0);
const frontTie = buildTourScenes(galleries, { 'front-elevation': { scores: { 'front-23': 5, 'front-black-shutters': 5, invented: 1000 }, total: 1010 } })[0];
assert.equal(frontTie.kind, 'design'); assert.equal(frontTie.designId, 'front-23'); assert.equal(frontTie.tieCount, 2); assert.equal(frontTie.totalVotes, 10);
assert.match(frontTie.description, /first of 2 designs tied/);
const extra = { id: 'future-room', name: 'Future Room', summary: '', designs: [{ id: 'future-01', title: 'Future idea', image: '/images/future.jpg', detail: 'I will feature this future design.' }] };
const withExtra = buildTourScenes([extra, ...galleries], {});
const extraScene = withExtra.find(scene => scene.roomId === 'future-room');
assert.equal(withExtra.indexOf(extraScene), withExtra.findIndex(scene => scene.id === 'garage-barn-door-motion') + 1, 'Other populated spaces follow the prioritized rooms in catalog order.');
assert.equal(extraScene.image, '/images/future.jpg');
console.log('PASS: seven scenes/three films, updated 30-second fixed-TV art/football/camera film and live facts, manual-mount guard, one primary deck scene for two views, video priority, active-only Living Room winners, separate Home Theatre palettes, front/Master/Hall winners, stable ties, invalid scores, honest missing data, credits and immutable deterministic output.');
