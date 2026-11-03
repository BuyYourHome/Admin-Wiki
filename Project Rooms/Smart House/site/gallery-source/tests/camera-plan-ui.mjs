import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';
import ts from 'typescript';
import React from 'react';
import { floorPlanRooms, PLAN_WIDTH, PLAN_HEIGHT } from '../lib/floor-plan.ts';
import { floorPlanCameras } from '../lib/floor-plan-cameras.ts';
import { galleries } from '../lib/designs.ts';

const require = createRequire(import.meta.url);
const compilerOptions = { module: ts.ModuleKind.CommonJS, jsx: ts.JsxEmit.ReactJSX, target: ts.ScriptTarget.ES2022 };
for (const extension of ['.ts', '.tsx']) require.extensions[extension] = (module, path) => module._compile(ts.transpileModule(readFileSync(path, 'utf8'), { compilerOptions }).outputText, path);

// Exercise the actual component functions and their effects without browser,
// network, microphone, database, playback or production mutations.
class EventTargetFake {
  listeners = new Map();
  addEventListener(type, callback, options = false) {
    const capture = options === true || options?.capture === true;
    const list = this.listeners.get(type) ?? [];
    if (!list.some(item => item.callback === callback && item.capture === capture)) list.push({ callback, capture });
    this.listeners.set(type, list);
  }
  removeEventListener(type, callback, options = false) {
    const capture = options === true || options?.capture === true;
    this.listeners.set(type, (this.listeners.get(type) ?? []).filter(item => item.callback !== callback || item.capture !== capture));
  }
  emit(type, fields = {}) {
    const event = { type, cancelable: true, defaultPrevented: false, preventDefault() { this.defaultPrevented = true; }, stopPropagation() {}, stopImmediatePropagation() {}, ...fields };
    for (const item of [...(this.listeners.get(type) ?? [])]) item.callback(event);
    return event;
  }
  count(type) { return (this.listeners.get(type) ?? []).length; }
}
class DocumentFake extends EventTargetFake {
  activeElement = null;
  defaultView = { visualViewport: Object.assign(new EventTargetFake(), { scale: 1 }) };
}
class ElementFake extends EventTargetFake {
  constructor(document, tag, props, parent) {
    super(); this.ownerDocument = document; this.tagName = tag.toUpperCase(); this.props = props; this.parentElement = parent;
    this.open = false; this.isConnected = true; this.pauseCalls = 0; this.closeCalls = 0; this.scrollCalls = 0; this.captures = new Set();
  }
  getAttribute(name) { return Object.hasOwn(this.props, name) ? String(this.props[name]) : null; }
  hasAttribute(name) { return Object.hasOwn(this.props, name) && this.props[name] !== false; }
  matches(selector) {
    return selector.split(',').some(part => {
      const exclusions = [...part.matchAll(/:not\(([^)]+)\)/g)].map(match => match[1]);
      if (exclusions.some(exclusion => this.matches(exclusion))) return false;
      const positive = part.replace(/:not\([^)]+\)/g, '').trim();
      const tag = positive.match(/^[a-z][\w-]*/i)?.[0];
      if (tag && tag.toUpperCase() !== this.tagName) return false;
      return [...positive.matchAll(/\[([\w-]+)(?:=["']?([^\]"']*)["']?)?\]/g)].every(([, name, value]) => this.hasAttribute(name) && (value === undefined || this.getAttribute(name) === value));
    });
  }
  closest(selector) { for (let node = this; node; node = node.parentElement) if (node.matches(selector)) return node; return null; }
  focus() { this.ownerDocument.activeElement = this; }
  scrollIntoView() { this.scrollCalls++; }
  showModal() { this.open = true; }
  close() { if (!this.open) return; this.open = false; this.closeCalls++; this.props.onClose?.(); }
  pause() { this.pauseCalls++; }
  getBoundingClientRect() { return { left: 0, top: 0, width: 400, height: 300, right: 400, bottom: 300 }; }
  setPointerCapture(id) { this.captures.add(id); }
  releasePointerCapture(id) { this.captures.delete(id); }
}
const savedGlobals = Object.fromEntries(['document', 'HTMLElement', 'requestAnimationFrame'].map(key => [key, Object.getOwnPropertyDescriptor(globalThis, key)]));
let frames = [];
globalThis.HTMLElement = ElementFake;
globalThis.requestAnimationFrame = callback => { frames.push(callback); return frames.length; };

function descendants(node) {
  const result = [];
  function walk(value) { if (!React.isValidElement(value)) return; result.push(value); React.Children.forEach(value.props.children, walk); }
  walk(node); return result;
}
function text(node) {
  if (typeof node === 'string' || typeof node === 'number') return String(node);
  if (!node || !React.isValidElement(node)) return '';
  return React.Children.toArray(node.props.children).map(text).join('');
}
function classHas(node, name) { return String(node.props.className ?? '').split(/\s+/).includes(name); }

function harness(path, initialProps, { map = false } = {}) {
  const document = new DocumentFake(), slots = [], modules = new Map();
  let cursor = 0, dirty = false, mounted = true, props = initialProps, tree, nodes = new Map(), elements = new WeakMap(), refs = [], effects = [];
  const hooks = {
    useState(initial) {
      const index = cursor++;
      if (!slots[index]) slots[index] = { state: typeof initial === 'function' ? initial() : initial };
      return [slots[index].state, value => { if (!mounted) return; const next = typeof value === 'function' ? value(slots[index].state) : value; if (!Object.is(next, slots[index].state)) { slots[index].state = next; dirty = true; } }];
    },
    useRef(initial) { const index = cursor++; if (!slots[index]) slots[index] = { ref: { current: initial } }; return slots[index].ref; },
    useId() { const index = cursor++; return `test-${index}`; },
    useEffect(effect, deps) {
      const index = cursor++, previous = slots[index];
      if (!previous || !deps || !previous.deps || deps.some((item, i) => !Object.is(item, previous.deps[i]))) effects.push({ index, effect, deps });
      if (!previous) slots[index] = {};
    }
  };
  function RoomPrimaryImage() { return null; }
  function CameraPlanVideo() { return null; }
  function load(file) {
    const absolute = fileURLToPath(new URL(file, import.meta.url));
    if (modules.has(absolute)) return modules.get(absolute);
    const module = { exports: {} }, localRequire = createRequire(absolute);
    const ownRequire = specifier => {
      if (specifier === 'react') return hooks;
      if (specifier === './use-horizontal-swipe') return load('../app/use-horizontal-swipe.ts');
      if (map && specifier === './room-primary-image') return { default: RoomPrimaryImage };
      if (map && specifier === './camera-plan-video') return { default: CameraPlanVideo };
      return localRequire(specifier);
    };
    new Function('require', 'module', 'exports', ts.transpileModule(readFileSync(absolute, 'utf8'), { compilerOptions }).outputText)(ownRequire, module, module.exports);
    modules.set(absolute, module.exports); return module.exports;
  }
  const Component = load(path).default;
  function commit() {
    const previous = nodes, next = new Map(), nextRefs = [];
    elements = new WeakMap();
    for (const [ref] of refs) typeof ref === 'function' ? ref(null) : ref.current = null;
    function walk(value, key = '0', parent = null) {
      if (!React.isValidElement(value)) return;
      let owner = parent;
      const identity = `${key}:${typeof value.type === 'string' ? value.type : 'component'}:${value.key ?? ''}`;
      if (typeof value.type === 'string') {
        const old = previous.get(identity);
        owner = old?.isConnected ? old : new ElementFake(document, value.type, value.props, parent);
        owner.props = value.props; owner.parentElement = parent; owner.isConnected = true;
        next.set(identity, owner); elements.set(value, owner);
        const ref = value.props.ref;
        if (ref) { typeof ref === 'function' ? ref(owner) : ref.current = owner; nextRefs.push([ref, owner]); }
      }
      React.Children.forEach(value.props.children, (child, i) => walk(child, `${identity}/${i}`, owner));
    }
    walk(tree);
    for (const [key, old] of previous) if (!next.has(key)) old.isConnected = false;
    nodes = next; refs = nextRefs;
  }
  function render() {
    globalThis.document = document;
    let attempts = 0;
    do {
      assert.ok(++attempts < 15, 'Effects settle without a render loop.');
      dirty = false; cursor = 0; effects = []; tree = Component(props); commit();
      for (const { index, effect, deps } of effects) { slots[index].cleanup?.(); slots[index] = { deps, cleanup: effect() }; }
    } while (dirty);
    return tree;
  }
  function flush() { if (dirty) render(); while (frames.length) { const next = frames; frames = []; next.forEach(callback => callback()); if (dirty) render(); } }
  render();
  return {
    document, get tree() { return tree; },
    all: predicate => descendants(tree).filter(predicate),
    one(predicate) { const found = descendants(tree).filter(predicate); assert.equal(found.length, 1, `Expected one node, found ${found.length}.`); return found[0]; },
    dom: element => elements.get(element),
    invoke(element, name, event = {}) { globalThis.document = document; element.props[name](event); flush(); },
    setProps(value) { props = value; render(); flush(); },
    flush,
    unmount() { mounted = false; for (const slot of slots) slot?.cleanup?.(); for (const [ref] of refs) typeof ref === 'function' ? ref(null) : ref.current = null; for (const node of nodes.values()) node.isConnected = false; flush(); }
  };
}

try {
  const galleryCalls = [], onGallery = id => galleryCalls.push(id);
  const voiceCalls = { toggle: 0, controls: 0 };
  const mapVoice = { active: true, status: 'Voice on', onToggle: () => voiceCalls.toggle++, onControls: () => voiceCalls.controls++ };
  const mapProps = { onGallery, voice: mapVoice };
  const explore = harness('../app/explore-page.tsx', { scene: 'day', onScene() {}, onGallery, voice: mapVoice });
  assert.equal(explore.one(node => node.type?.name === 'InteractiveFloorPlan').props.voice, mapVoice, 'Explore forwards its existing voice controls into the floor plan.');
  explore.unmount();
  const plan = harness('../app/interactive-floor-plan.tsx', mapProps, { map: true });
  const svg = plan.one(node => node.type === 'svg');
  assert.equal(svg.props.viewBox, `0 0 ${PLAN_WIDTH} ${PLAN_HEIGHT}`);
  assert.equal(plan.one(node => node.type === 'image').props.href, '/plans/first-floor-camera-plan-v15.png');
  const layers = React.Children.toArray(svg.props.children);
  assert.deepEqual(layers.map(node => node.type), ['image', ...Array(4).fill('path'), ...Array(19).fill('polygon'), ...Array(4).fill('g')], 'Camera fields precede room hit areas; camera markers stay above both.');
  assert.equal(plan.all(node => node.type === 'path' && node.props.role === 'button').length, 4);
  assert.equal(plan.all(node => node.type === 'polygon' && node.props.role === 'button').length, 19);

  const chooser = () => plan.one(node => node.type === 'select');
  const heading = () => plan.one(node => node.type === 'h3');
  const details = () => plan.one(node => classHas(node, 'floor-plan-details'));
  const cameraPath = camera => plan.one(node => node.type === 'path' && node.props.d === camera.sectorPath);
  const cameraMarker = camera => plan.one(node => node.type === 'g' && classHas(node, 'floor-plan-camera-marker') && descendants(node).some(child => child.type === 'polygon' && child.props.points === camera.markerPoints));
  const choose = id => plan.invoke(chooser(), 'onChange', { target: { value: id } });
  for (const camera of floorPlanCameras) {
    for (const method of ['path click', 'path Enter', 'path Space', 'marker click', 'chooser']) {
      choose('living-room');
      if (method === 'path click') plan.invoke(cameraPath(camera), 'onClick');
      else if (method.startsWith('path ')) {
        const event = { key: method === 'path Enter' ? 'Enter' : ' ', prevented: false, preventDefault() { this.prevented = true; } };
        plan.invoke(cameraPath(camera), 'onKeyDown', event); assert.equal(event.prevented, true);
      } else if (method === 'marker click') plan.invoke(cameraMarker(camera), 'onClick');
      else choose(camera.id);
      assert.equal(chooser().props.value, camera.id, `${method} selects ${camera.id}.`);
      assert.equal(text(heading()), `My Camera ${camera.number}: ${camera.name}`);
      assert.equal(details().props['data-pondster-room'], camera.id);
      assert.equal(details().props['data-pondster-gallery'], undefined);
      assert.equal(plan.all(node => node.type === 'polygon' && node.props.role === 'button' && node.props['aria-pressed']).length, 0, 'Camera selection does not highlight a fallback room.');
      assert.deepEqual(plan.one(node => node.type?.name === 'CameraPlanVideo').props.camera, camera);
      assert.equal(plan.one(node => node.type?.name === 'CameraPlanVideo').props.voice, mapVoice, 'Camera details keep the page’s exact voice controls and callbacks.');
      assert.equal(plan.document.activeElement, plan.dom(heading()), 'Pointer and keyboard selection focus the updated detail heading.');
    }
    plan.invoke(plan.one(node => classHas(node, 'floor-plan-back')), 'onClick');
    assert.equal(plan.document.activeElement, plan.dom(cameraPath(camera)), 'Return-to-plan restores the selected accessible camera path.');
  }
  for (const room of floorPlanRooms) {
    plan.invoke(plan.one(node => node.type === 'polygon' && node.props.role === 'button' && node.props.points === room.polygon), 'onClick');
    assert.equal(chooser().props.value, room.id);
    assert.equal(text(heading()), `My ${room.name}`);
    assert.equal(details().props['data-pondster-room'], room.id);
    assert.equal(details().props['data-pondster-gallery'], room.galleryId);
    const image = plan.one(node => node.type?.name === 'RoomPrimaryImage');
    assert.equal(image.props.galleryId, room.galleryId); assert.equal(image.props.roomName, room.name); assert.equal(image.props.onGallery, onGallery);
    assert.equal(plan.all(node => node.type?.name === 'CameraPlanVideo').length, 0);
  }
  for (const camera of floorPlanCameras) {
    plan.setProps({ ...mapProps, roomRequest: { id: camera.number, room: camera.id, section: 'floor-plan' } });
    assert.equal(chooser().props.value, camera.id, 'A voice camera request selects its own camera target.');
  }
  for (const [index, gallery] of galleries.entries()) {
    plan.setProps({ ...mapProps, roomRequest: { id: 100 + index, room: gallery.id, section: 'room' } });
    assert.equal(plan.one(node => node.type?.name === 'RoomPrimaryImage').props.galleryId, gallery.id, 'Existing room and additional-space voice requests preserve gallery ownership.');
  }
  const prior = chooser().props.value;
  plan.setProps({ ...mapProps, roomRequest: { id: 999, room: 'camera-999', section: 'floor-plan' } });
  assert.equal(chooser().props.value, prior, 'Unknown voice camera IDs do not replace the current target.');
  plan.unmount();

  let current = floorPlanCameras[0], videoHarness;
  const changed = [];
  let videoVoice = mapVoice;
  const onCamera = id => { changed.push(id); current = floorPlanCameras.find(camera => camera.id === id); videoHarness.setProps({ camera: current, onCamera, voice: videoVoice }); };
  videoHarness = harness('../app/camera-plan-video.tsx', { camera: current, onCamera, voice: videoVoice });
  const video = () => videoHarness.one(node => node.type === 'video');
  const stage = () => videoHarness.one(node => classHas(node, 'camera-video-stage'));
  const dialog = () => videoHarness.one(node => node.type === 'dialog');
  const button = label => videoHarness.one(node => node.type === 'button' && node.props['aria-label'] === label);
  function checkMovie() {
    assert.equal(videoHarness.one(node => node.type === 'source').props.src, current.video);
    assert.equal(video().props.poster, current.poster);
    for (const flag of ['controls', 'autoPlay', 'muted', 'playsInline', 'loop']) assert.equal(video().props[flag], true);
    assert.equal(stage().props.style.touchAction, 'pan-y pinch-zoom');
    assert.equal(typeof stage().props.onPointerDownCapture, 'function');
    const captionId = video().props['aria-describedby'];
    assert.equal(videoHarness.all(node => node.props.id === captionId).length, 1, 'The active media has one real disclosure caption.');
  }
  checkMovie();
  const voiceButton = label => videoHarness.one(node => node.type === 'button' && text(node) === label);
  assert.equal(videoHarness.one(node => classHas(node, 'camera-view-voice')).props.children.some(node => node?.props?.role === 'status' && text(node) === 'Voice on'), true);
  assert.equal(voiceButton('Stop voice').props['aria-pressed'], true);
  videoHarness.invoke(voiceButton('Stop voice'), 'onClick'); assert.equal(voiceCalls.toggle, 1, 'The inline Stop voice button invokes the existing toggle callback only.');
  videoVoice = { ...mapVoice, active: false, status: 'Voice off' };
  videoHarness.setProps({ camera: current, onCamera, voice: videoVoice });
  assert.equal(voiceButton('Start voice').props['aria-pressed'], false);
  videoHarness.invoke(voiceButton('Start voice'), 'onClick'); assert.equal(voiceCalls.toggle, 2);
  videoVoice = mapVoice;
  videoHarness.setProps({ camera: current, onCamera, voice: videoVoice });
  videoHarness.invoke(button('Previous camera view'), 'onClick'); assert.equal(current.id, 'camera-4');
  videoHarness.invoke(button('Next camera view'), 'onClick'); assert.equal(current.id, 'camera-1');
  for (let index = 0; index < 4; index++) {
    const outgoing = videoHarness.dom(video());
    videoHarness.invoke(button('Next camera view'), 'onClick'); checkMovie();
    assert.ok(outgoing.pauseCalls > 0, 'Changing camera pauses the outgoing media element.');
  }
  videoHarness.invoke(video(), 'onError');
  assert.equal(videoHarness.all(node => classHas(node, 'camera-video-error')).length, 1);
  videoHarness.invoke(button('Next camera view'), 'onClick');
  assert.equal(videoHarness.all(node => classHas(node, 'camera-video-error')).length, 0, 'A new camera clears the old media error.');

  function swipe(direction, bottom = false) {
    const surface = videoHarness.dom(stage()), target = videoHarness.dom(video()), before = changed.length;
    const fields = { pointerType: 'touch', pointerId: 1, isPrimary: true, button: 0, target, clientX: direction === 'left' ? 300 : 80, clientY: bottom ? 290 : 120 };
    const down = videoHarness.document.emit('pointerdown', fields);
    videoHarness.invoke(stage(), 'onPointerDownCapture', { nativeEvent: down, currentTarget: surface });
    videoHarness.document.emit('pointermove', { ...fields, clientX: direction === 'left' ? 80 : 300, clientY: bottom ? 290 : 125 });
    videoHarness.document.emit('pointerup', { ...fields, clientX: direction === 'left' ? 80 : 300, clientY: bottom ? 290 : 125 });
    videoHarness.flush();
    videoHarness.document.emit('pointerdown', { pointerType: 'mouse' }); // Clear only the prior gesture's bounded compatibility-click guard.
    assert.equal(changed.length - before, bottom ? 0 : 1, 'The actual swipe hook navigates once, except in protected native video controls.');
  }
  const initialIndex = floorPlanCameras.indexOf(current);
  swipe('left'); assert.equal(current, floorPlanCameras[(initialIndex + 1) % 4]);
  swipe('right'); assert.equal(current, floorPlanCameras[initialIndex]);
  swipe('left', true);

  const enlarge = () => videoHarness.one(node => classHas(node, 'camera-view-enlarge'));
  const inlineVideo = videoHarness.dom(video());
  videoHarness.dom(enlarge()).focus(); videoHarness.invoke(enlarge(), 'onClick');
  assert.equal(videoHarness.dom(dialog()).open, true);
  assert.equal(videoHarness.document.activeElement, videoHarness.dom(button('Close camera view')));
  assert.ok(inlineVideo.pauseCalls > 0, 'Enlarging pauses the removed inline video.');
  assert.equal(videoHarness.all(node => node.type === 'video').length, 1, 'Only one video exists while the modal is open.');
  assert.ok(descendants(dialog()).includes(voiceButton('Stop voice')), 'Stop voice remains inside the modal’s accessible subtree.');
  assert.ok(descendants(dialog()).includes(voiceButton('Voice controls ↗')), 'Voice controls remain reachable inside the native modal.');
  videoHarness.invoke(voiceButton('Stop voice'), 'onClick'); assert.equal(voiceCalls.toggle, 3);
  const modalVideo = videoHarness.dom(video());
  const keyboard = { key: 'ArrowRight', target: videoHarness.dom(button('Close camera view')), prevented: false, preventDefault() { this.prevented = true; }, stopPropagation() {} };
  const beforeArrow = changed.length;
  videoHarness.invoke(dialog(), 'onKeyDown', keyboard); assert.equal(keyboard.prevented, true); assert.equal(changed.length, beforeArrow + 1);
  assert.ok(modalVideo.pauseCalls > 0, 'Changing the modal camera pauses its old video.');
  const beforeNative = changed.length;
  videoHarness.invoke(dialog(), 'onKeyDown', { ...keyboard, target: videoHarness.dom(video()) });
  videoHarness.invoke(dialog(), 'onKeyDown', { ...keyboard, ctrlKey: true });
  assert.equal(changed.length, beforeNative, 'Native video keyboard controls and modified shortcuts are preserved.');
  const activeDialog = videoHarness.dom(dialog()), closingVideo = videoHarness.dom(video());
  const cancel = { prevented: false, preventDefault() { this.prevented = true; } };
  videoHarness.invoke(dialog(), 'onCancel', cancel);
  assert.equal(cancel.prevented, true, 'Escape uses the component’s focus-restoring close path.');
  assert.equal(activeDialog.open, false); assert.ok(closingVideo.pauseCalls > 0);
  assert.equal(videoHarness.document.activeElement, videoHarness.dom(enlarge()), 'Closing returns focus to the newly mounted Enlarge button.');
  videoHarness.invoke(enlarge(), 'onClick');
  const voiceDialog = videoHarness.dom(dialog()), voiceVideo = videoHarness.dom(video());
  videoHarness.invoke(voiceButton('Voice controls ↗'), 'onClick');
  assert.equal(voiceCalls.controls, 1, 'The modal Voice controls button invokes the existing parent controls callback once.');
  assert.equal(voiceDialog.open, false, 'The settled controls action closes the native modal before the page controls need interaction.');
  assert.ok(voiceVideo.pauseCalls > 0, 'Opening page voice controls also pauses the enlarged video.');
  assert.equal(videoHarness.all(node => classHas(node, 'camera-view-voice')).length, 1, 'The modal copy does not leave duplicate voice controls behind.');
  videoHarness.setProps({ camera: current, onCamera });
  assert.equal(videoHarness.all(node => classHas(node, 'camera-view-voice')).length, 0, 'Optional voice controls stay absent when no voice provider is passed.');
  videoHarness.setProps({ camera: current, onCamera, voice: videoVoice });
  videoHarness.invoke(enlarge(), 'onClick');
  const lastDialog = videoHarness.dom(dialog()), lastVideo = videoHarness.dom(video());
  videoHarness.unmount();
  assert.equal(lastDialog.open, false, 'Leaving the camera detail closes the native modal.');
  assert.ok(lastVideo.pauseCalls > 0, 'Leaving the camera detail pauses playback.');
  for (const type of ['pointermove', 'pointerup', 'pointercancel', 'lostpointercapture', 'gesturestart']) assert.equal(videoHarness.document.count(type), 0, `Unmount removes ${type} swipe listeners.`);
  assert.equal(videoHarness.document.defaultView.visualViewport.count('resize'), 0);
  console.log('PASS: real map path/marker/chooser selection for four cameras; preserved 19 rooms and gallery/voice requests; Explore-to-camera voice forwarding and inline/modal callback reachability; actual video media, buttons, protected swipes, error reset, modal keyboard/Escape/focus and unmount pause/close cleanup. No microphone or provider calls.');
} finally {
  for (const [key, descriptor] of Object.entries(savedGlobals)) descriptor ? Object.defineProperty(globalThis, key, descriptor) : delete globalThis[key];
}
