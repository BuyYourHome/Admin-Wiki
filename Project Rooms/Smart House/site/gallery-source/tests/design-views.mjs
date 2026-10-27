import assert from 'node:assert/strict';
import { galleries, allDesigns } from '../lib/designs.ts';
import { designImageSource, designPictures, galleryPictures, pictureIndex, movePicture, pictureSelection } from '../lib/design-views.ts';
import { buildTourScenes } from '../lib/virtual-tour.ts';

const before = JSON.stringify(galleries);
const deck = galleries.find(gallery => gallery.id === 'back-deck');
assert.equal(deck.designs.length, 1, 'Two deck pictures remain one voting choice');
assert.equal(deck.designs[0].id, 'oak-courtyard');
assert.equal(allDesigns.length, 31);
assert.equal(new Set(allDesigns.map(design => design.id)).size, 31);
const overview = '/images/deck/oak-courtyard-overview.png';
const closeup = '/images/deck/oak-courtyard-closeup.png';
assert.equal(deck.designs[0].image, overview, 'Explore and tour retain the primary overview');
const pictures = galleryPictures(deck.designs);
assert.deepEqual(pictures.map(picture => picture.image), [overview, closeup]);
assert.deepEqual(pictures.map(picture => picture.label), ['Courtyard overview', 'Closer view']);
assert.ok(pictures.every(picture => picture.design.id === 'oak-courtyard'));
const selectedCloseup = pictureSelection(pictures[1]);
assert.equal(selectedCloseup.id, 'oak-courtyard', 'A viewer change never creates another voting ID');
assert.equal(selectedCloseup.image, closeup);
assert.equal(selectedCloseup.title, deck.designs[0].title);
assert.equal(pictureIndex(pictures, selectedCloseup), 1);
assert.equal(movePicture(1, 1, pictures.length), 0, 'Next wraps to the overview');
assert.equal(movePicture(0, -1, pictures.length), 1, 'Previous wraps to the closer view');
assert.equal(pictureSelection(pictures[0]), deck.designs[0]);
assert.equal(pictureIndex(pictures, { ...selectedCloseup, image: '/missing-view.png' }), 0, 'Unknown view selection safely uses its owner choice');

for (const gallery of galleries.filter(gallery => gallery !== deck)) {
  const originalPictures = galleryPictures(gallery.designs);
  assert.equal(originalPictures.length, gallery.designs.length, 'Existing galleries keep exactly one picture per choice');
  for (const [index, picture] of originalPictures.entries()) {
    assert.equal(pictureSelection(picture), gallery.designs[index]);
    assert.equal(pictureIndex(originalPictures, gallery.designs[index]), index);
  }
}
const sharedFilename = [
  { id: 'owner-a', title: 'A', image: 'shared.png', detail: '' },
  { id: 'owner-b', title: 'B', image: 'shared.png', detail: '' }
];
assert.equal(pictureIndex(galleryPictures(sharedFilename), sharedFilename[1]), 1, 'IDs disambiguate shared image filenames');
assert.deepEqual(designPictures(sharedFilename[0]).map(picture => picture.image), ['shared.png']);
assert.deepEqual(galleryPictures([]), []);
assert.equal(movePicture(0, 1, 0), 0);
assert.equal(designImageSource('original.png'), '/concepts/original.png');
assert.equal(designImageSource(overview), overview);

const scenes = buildTourScenes(galleries, {});
assert.equal(scenes.length, 7, 'The newly populated deck adds one tour scene');
assert.equal(scenes.filter(scene => scene.kind === 'motion').length, 3);
assert.equal(scenes.filter(scene => scene.roomId === 'back-deck').length, 1, 'A second view does not add another scene');
assert.equal(scenes.find(scene => scene.roomId === 'back-deck').image, overview);
assert.equal(scenes.find(scene => scene.roomId === 'back-deck').designId, 'oak-courtyard');
assert.equal(JSON.stringify(galleries), before, 'Browsing and tour construction never mutate catalog or vote identity');
console.log('PASS: one deck choice/two views; immutable vote identity; card/lightbox wrap and selection; existing galleries; absolute assets; seven tour scenes with one primary deck image and three films.');
