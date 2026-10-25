import assert from 'node:assert/strict';
import { buildTourScenes } from '../lib/virtual-tour.ts';
import { galleries } from '../lib/designs.ts';

const populated = galleries.filter(gallery => gallery.designs.length);
const emptyVotes = Object.fromEntries(populated.map(gallery => [gallery.id, { scores: {}, total: 0 }]));
const originalCatalog = JSON.stringify(galleries);

assert.deepEqual(buildTourScenes([], {}), []);
const pending = buildTourScenes(galleries, {});
assert.ok(pending.every(scene => scene.status === 'unavailable' && scene.votes === 0 && scene.tieCount === 0));
for (const scene of pending.filter(scene => scene.kind === 'design')) assert.match(scene.description, /without claiming a leader/);

const zero = buildTourScenes(galleries, emptyVotes);
assert.deepEqual(zero.map(scene => scene.id), [
  'front-elevation-design', 'media-center-design', 'media-center-motion',
  'master-bath-design', 'garage-barn-door-design', 'garage-barn-door-motion'
]);
assert.ok(zero.every(scene => scene.status === 'no-votes' && scene.votes === 0 && scene.totalVotes === 0 && scene.tieCount === 0));
assert.equal(new Set(zero.map(scene => scene.id)).size, zero.length);
assert.ok(zero.every(scene => scene.image.startsWith('/concepts/')));
assert.ok(!zero.some(scene => ['kitchen', 'adu', 'spiral-staircase', 'back-deck'].includes(scene.roomId)));

const media = galleries.find(gallery => gallery.id === 'media-center');
const garage = galleries.find(gallery => gallery.id === 'garage-barn-door');
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
const mediaScene = tour.find(scene => scene.id === 'media-center-design');
assert.equal(mediaScene.designId, media.designs[0].id, 'A positive tie follows stable catalog order.');
assert.equal(mediaScene.status, 'tied'); assert.equal(mediaScene.tieCount, 2); assert.equal(mediaScene.totalVotes, 8);
assert.match(mediaScene.description, /2 designs tied/);
const bathScene = tour.find(scene => scene.id === 'master-bath-design');
assert.equal(bathScene.designId, bath.designs[4].id);
assert.equal(bathScene.designTitle, bath.designs[4].title);
assert.equal(bathScene.image, `/concepts/${bath.designs[4].image}`);
assert.equal(tour.find(scene => scene.id === 'garage-barn-door-design').status, 'unavailable');
assert.deepEqual(votes, snapshot); assert.equal(JSON.stringify(galleries), originalCatalog);
assert.deepEqual(buildTourScenes(galleries, votes), tour, 'Identical inputs produce identical scene order and selections.');

for (const room of [media, garage]) {
  const still = tour.find(scene => scene.roomId === room.id && scene.kind === 'design');
  const motion = tour.find(scene => scene.roomId === room.id && scene.kind === 'motion');
  assert.equal(tour.indexOf(motion), tour.indexOf(still) + 1);
  assert.equal(still.durationSeconds, 8);
  assert.equal(motion.durationSeconds, room.id === 'media-center' ? 10 : 25);
  assert.equal(motion.image, still.image, 'The selected still is the fallback when motion cannot play.');
  assert.equal(motion.designId, still.designId);
  assert.equal(motion.designTitle, still.designTitle);
  assert.notEqual(motion.title, still.title, 'An illustrative film has its own title, not the selected finish title.');
  assert.match(motion.description, /separate illustrative motion film, not a film of the selected voting design/);
  assert.ok(motion.video.startsWith('/media/') && motion.poster.startsWith('/media/'));
}
const mediaMotion = tour.find(scene => scene.id === 'media-center-motion');
assert.equal(mediaMotion.video, '/media/media-center-kitchen-view.mp4');
assert.match(mediaMotion.sourceCredit, /Marine Corps.*James Stanfield.*DVIDS/);
assert.match(mediaMotion.sourceNotice, /does not imply or constitute DoW endorsement/);
assert.ok(mediaMotion.sourceUrl.startsWith('https://www.dvidshub.net/'));
assert.ok(mediaMotion.sourceNoticeUrl.startsWith('https://www.dvidshub.net/'));
assert.equal(tour.find(scene => scene.id === 'garage-barn-door-motion').video, '/media/garage-barn-door-tesla-drive-out.mp4');

const badScores = { 'front-elevation': { scores: { [front.designs[0].id]: -1, [front.designs[1].id]: NaN, invented: 100 }, total: 100 } };
assert.equal(buildTourScenes(galleries, badScores)[0].status, 'no-votes');
assert.equal(buildTourScenes(galleries, badScores)[0].totalVotes, 0);
const extra = { id: 'future-room', name: 'Future Room', summary: '', designs: [{ id: 'future-01', title: 'Future idea', image: '/images/future.jpg', detail: 'I’m exploring a future idea.' }] };
const withExtra = buildTourScenes([extra, ...galleries], {});
assert.equal(withExtra.at(-1).roomId, 'future-room', 'Other populated spaces follow the prioritized rooms.');
assert.equal(withExtra.at(-1).image, '/images/future.jpg');
console.log('PASS: vote-based tour selection, room ordering, empty/failed/no-vote states, stable positive ties, invalid-score filtering, separate credited motion scenes, selected-still fallbacks, and immutable deterministic output.');
