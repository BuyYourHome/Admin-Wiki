import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import ts from 'typescript';
import { createHorizontalSwipeController } from '../lib/horizontal-swipe.ts';

class FakeEventTarget {
  listeners = new Map();
  addEventListener(type, callback, options = false) {
    const capture = options === true || options?.capture === true;
    const entries = this.listeners.get(type) ?? [];
    if (!entries.some(entry => entry.callback === callback && entry.capture === capture)) entries.push({ callback, capture, options });
    this.listeners.set(type, entries);
  }
  removeEventListener(type, callback, options = false) {
    const capture = options === true || options?.capture === true;
    this.listeners.set(type, (this.listeners.get(type) ?? []).filter(entry => entry.callback !== callback || entry.capture !== capture));
  }
  dispatchEvent(event) {
    for (const entry of [...(this.listeners.get(event.type) ?? [])].sort((a, b) => Number(b.capture) - Number(a.capture))) {
      if (event.immediateStopped) break;
      entry.callback.call(this, event);
    }
    return !event.defaultPrevented;
  }
  count(type) { return (this.listeners.get(type) ?? []).length; }
}
class FakeDocument extends FakeEventTarget {
  constructor() {
    super();
    this.defaultView = { visualViewport: Object.assign(new FakeEventTarget(), { scale: 1 }) };
  }
}
class FakeElement extends FakeEventTarget {
  constructor(document, tag = 'div', attrs = {}, parent = null) {
    super(); this.ownerDocument = document; this.tagName = tag.toUpperCase(); this.attrs = attrs; this.parentElement = parent;
    this.rect = { left: 0, top: 0, width: 400, height: 300, right: 400, bottom: 300 }; this.captures = new Set();
  }
  getAttribute(name) { return Object.hasOwn(this.attrs, name) ? String(this.attrs[name]) : null; }
  hasAttribute(name) { return Object.hasOwn(this.attrs, name); }
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
  getBoundingClientRect() { return this.rect; }
  setPointerCapture(id) { this.captures.add(id); }
  releasePointerCapture(id) { this.captures.delete(id); }
}
function clock() {
  let time = 1000, serial = 0;
  const timers = new Map();
  return {
    now: () => time,
    setTimer(fn, ms) { const id = ++serial; timers.set(id, { fn, at: time + ms }); return id; },
    clearTimer(id) { timers.delete(id); },
    advance(ms) {
      const end = time + ms;
      while (true) {
        const next = [...timers].filter(([, timer]) => timer.at <= end).sort((a, b) => a[1].at - b[1].at)[0];
        if (!next) break;
        time = next[1].at; timers.delete(next[0]); next[1].fn();
      }
      time = end;
    },
    count: () => timers.size,
  };
}
function event(type, properties = {}) {
  const value = new Event(type, { cancelable: true, bubbles: true });
  Object.defineProperties(value, Object.fromEntries(Object.entries({ pointerType: 'touch', pointerId: 1, isPrimary: true, button: 0, clientX: 300, clientY: 120, detail: 1, ...properties }).map(([key, item]) => [key, { value: item, configurable: true }])));
  value.immediateStopped = false;
  const stopImmediate = value.stopImmediatePropagation.bind(value);
  value.stopImmediatePropagation = () => { value.immediateStopped = true; stopImmediate(); };
  return value;
}
function setup(initial = {}, tag = 'div', attrs = {}) {
  const document = new FakeDocument(), surface = new FakeElement(document, tag, attrs), image = new FakeElement(document, 'img', {}, surface);
  const timer = clock(), calls = [], options = { onPrevious: () => calls.push('previous'), onNext: () => calls.push('next'), resetKey: 'first', ...initial };
  const controller = createHorizontalSwipeController(() => options, timer);
  const make = (type, properties = {}) => event(type, { target: image, timeStamp: timer.now(), ...properties });
  return {
    document, surface, image, timer, calls, options, controller, make,
    begin(properties = {}, targetSurface = surface) {
      const down = make('pointerdown', properties);
      document.dispatchEvent(down); // The document capture phase precedes the surface handler.
      controller.onPointerDown(down, targetSurface);
      return down;
    },
    emit(type, properties = {}) { const value = make(type, properties); document.dispatchEvent(value); return value; },
  };
}
function swipe(h, direction = 'left', properties = {}) {
  const start = direction === 'left' ? 300 : 80, end = direction === 'left' ? 80 : 300;
  const down = h.begin({ clientX: start, clientY: 120, ...properties });
  h.timer.advance(20);
  const move = h.emit('pointermove', { clientX: end, clientY: 125, ...properties });
  h.timer.advance(20);
  const up = h.emit('pointerup', { clientX: end, clientY: 125, ...properties });
  return { down, move, up };
}
function finish(h) {
  h.controller.destroy(); h.timer.advance(1000);
  for (const type of ['pointerdown', 'pointermove', 'pointerup', 'pointercancel', 'lostpointercapture', 'gesturestart', 'click']) assert.equal(h.document.count(type), 0, `Release the ${type} listener after completion and the bounded click guard.`);
  assert.equal(h.document.defaultView.visualViewport.count('resize'), 0);
  assert.equal(h.timer.count(), 0); assert.equal(h.surface.captures.size, 0);
}

{
  const h = setup();
  const left = swipe(h);
  assert.deepEqual(h.calls, ['next'], 'A deliberate left swipe advances exactly once.');
  assert.equal(left.down.defaultPrevented, false, 'Do not claim the browser gesture at pointerdown.');
  assert.equal(left.move.defaultPrevented, true);
  h.emit('pointerup', { clientX: 80, clientY: 125 });
  assert.deepEqual(h.calls, ['next'], 'A duplicate release cannot navigate again.');
  swipe(h, 'right'); assert.deepEqual(h.calls, ['next', 'previous']);
  finish(h);
}
for (const [name, points] of [
  ['tiny motion', [[300, 120], [306, 122], [307, 123]]],
  ['diagonal motion', [[300, 80], [220, 160], [150, 230]]],
  ['vertical motion turning horizontal', [[300, 40], [305, 160], [50, 170]]],
]) {
  const h = setup(), [start, middle, end] = points;
  const down = h.begin({ clientX: start[0], clientY: start[1] });
  const move = h.emit('pointermove', { clientX: middle[0], clientY: middle[1] });
  const up = h.emit('pointerup', { clientX: end[0], clientY: end[1] });
  assert.deepEqual(h.calls, [], `${name} is not a horizontal navigation intent.`);
  assert.ok([down, move, up].every(value => !value.defaultPrevented), `${name} preserves native scrolling/tapping.`);
  finish(h);
}
for (const pointerType of ['mouse', 'pen']) {
  const h = setup(); swipe(h, 'left', { pointerType });
  assert.deepEqual(h.calls, [], 'This touchscreen feature does not become generic pointer dragging.'); finish(h);
}
for (const [options, direction] of [[{ enabled: false }, 'left'], [{ canNext: false }, 'left'], [{ canPrevious: false }, 'right']]) {
  const h = setup(options); swipe(h, direction);
  assert.deepEqual(h.calls, [], 'Swipes preserve disabled navigation directions and surfaces.'); finish(h);
}
{
  const h = setup(); h.begin();
  h.emit('pointermove', { pointerId: 99, clientX: 50 }); h.emit('pointerup', { pointerId: 99, clientX: 50 });
  assert.deepEqual(h.calls, [], 'An unrelated pointer cannot finish the tracked touch.');
  h.emit('pointermove', { clientX: 80 }); h.emit('pointerup', { clientX: 80 });
  assert.deepEqual(h.calls, ['next']); finish(h);
}
{
  const h = setup(), outside = new FakeElement(h.document);
  h.begin(); h.emit('pointermove', { clientX: 200 });
  h.emit('pointerdown', { pointerId: 2, isPrimary: false, target: outside });
  h.emit('pointermove', { clientX: 80 }); h.emit('pointerup', { clientX: 80 });
  assert.deepEqual(h.calls, [], 'A second finger outside the surface cancels the first swipe.');
  h.begin({ pointerId: 3 }); h.emit('pointermove', { pointerId: 3, clientX: 80 }); h.emit('pointerup', { pointerId: 3, clientX: 80 });
  assert.deepEqual(h.calls, [], 'Do not rearm while another finger remains down.');
  h.emit('pointerup', { pointerId: 2, isPrimary: false, target: outside });
  swipe(h, 'left', { pointerId: 4 }); assert.deepEqual(h.calls, ['next'], 'A new swipe works after all fingers lift.'); finish(h);
}
for (const cancellation of ['pointercancel', 'lostpointercapture']) {
  const h = setup(); h.begin(); h.emit('pointermove', { clientX: 180 });
  h.emit(cancellation); h.emit('pointerup', { clientX: 80 });
  assert.deepEqual(h.calls, [], `${cancellation} cannot complete navigation.`);
  swipe(h, 'right', { pointerId: 2 }); assert.deepEqual(h.calls, ['previous'], `${cancellation} cleanup permits the next gesture.`); finish(h);
}
for (const change of ['resetKey', 'enabled', 'reset']) {
  const h = setup(); h.begin(); h.emit('pointermove', { clientX: 180 });
  if (change === 'resetKey') h.options.resetKey = 'changed';
  else if (change === 'enabled') h.options.enabled = false;
  else h.controller.reset();
  h.emit('pointerup', { clientX: 80 });
  assert.deepEqual(h.calls, [], `${change} cancels an in-flight candidate.`);
  h.options.enabled = true; swipe(h, 'left', { pointerId: 2 }); assert.deepEqual(h.calls, ['next']); finish(h);
}
for (const cancellation of ['media replacement/reset', 'lost pointer capture']) {
  const h = setup(); h.begin();
  const move = h.emit('pointermove', { clientX: 80, clientY: 125 });
  assert.equal(move.defaultPrevented, true, 'The controller already claimed horizontal intent before cancellation.');
  if (cancellation === 'media replacement/reset') { h.options.resetKey = 'replacement-media'; h.controller.reset(); }
  else h.emit('lostpointercapture');
  h.emit('pointerup', { clientX: 80, clientY: 125 });
  assert.deepEqual(h.calls, [], `${cancellation} cancels navigation after a horizontal claim.`);
  const replacement = new FakeElement(h.document, 'img', {}, h.surface);
  const ghost = h.make('click', { target: replacement }); h.controller.onClickCapture(ghost);
  assert.equal(ghost.defaultPrevented, true, `${cancellation} cannot turn the claimed drag's release into a tap on replacement media.`);
  const keyboard = h.make('click', { detail: 0, target: replacement }); h.controller.onClickCapture(keyboard);
  assert.equal(keyboard.defaultPrevented, false, 'Cancellation does not disable keyboard activation.');
  let accidentalOpens = 0;
  const openReplacement = () => accidentalOpens++;
  h.document.addEventListener('click', openReplacement);
  h.emit('click', { target: replacement });
  assert.equal(accidentalOpens, 0, 'The retained document guard also blocks the native replacement-image/fullscreen activation.');
  h.document.removeEventListener('click', openReplacement); finish(h);
}
{
  const h = setup(); h.document.defaultView.visualViewport.scale = 2;
  swipe(h); assert.deepEqual(h.calls, [], 'A zoomed browser owns touch panning.');
  h.document.defaultView.visualViewport.scale = 1; h.begin({ pointerId: 2 });
  h.document.defaultView.visualViewport.dispatchEvent(new Event('resize'));
  h.emit('pointerup', { pointerId: 2, clientX: 80 });
  assert.deepEqual(h.calls, [], 'A viewport/pinch change cancels an existing gesture.');
  swipe(h, 'right', { pointerId: 3 }); assert.deepEqual(h.calls, ['previous']); finish(h);
}
{
  const h = setup(); h.begin(); h.emit('gesturestart'); h.emit('pointerup', { clientX: 80 });
  assert.deepEqual(h.calls, [], 'A native pinch gesture never advances a picture.'); finish(h);
}
for (const [tag, attrs] of [
  ['button', { class: 'vote-button' }], ['a', { href: '/guide' }], ['input', { type: 'range' }],
  ['textarea', {}], ['select', {}], ['label', {}], ['form', {}], ['summary', {}],
  ['div', { role: 'button' }], ['div', { role: 'link' }], ['div', { role: 'slider' }],
  ['div', { contenteditable: 'true' }], ['div', { 'data-swipe-ignore': '' }], ['audio', { controls: '' }],
]) {
  const h = setup(), control = new FakeElement(h.document, tag, attrs, h.surface), icon = new FakeElement(h.document, 'span', {}, control);
  const down = h.begin({ target: icon });
  h.emit('pointermove', { clientX: 80, target: icon }); h.emit('pointerup', { clientX: 80, target: icon });
  assert.deepEqual(h.calls, [], `A ${tag} control (including its nested icon) cannot start navigation.`);
  assert.equal(down.defaultPrevented, false); finish(h);
}
{
  const h = setup({}, 'button'); swipe(h);
  assert.deepEqual(h.calls, [], 'A button is excluded by default.'); finish(h);
}
{
  const h = setup({ allowRootButton: true }, 'button'); swipe(h);
  assert.deepEqual(h.calls, ['next'], 'Only the dedicated root image-opening button may opt into swiping.');
  const nested = new FakeElement(h.document, 'a', { href: '/elsewhere' }, h.surface);
  swipe(h, 'left', { pointerId: 2, target: nested });
  assert.deepEqual(h.calls, ['next'], 'The root-button exception never enables a nested link/control.'); finish(h);
}
{
  const h = setup({ protectNativeVideo: true }), video = new FakeElement(h.document, 'video', { controls: '' }, h.surface);
  h.begin({ target: video, clientY: 295 }); h.emit('pointermove', { target: video, clientX: 80, clientY: 295 }); h.emit('pointerup', { target: video, clientX: 80, clientY: 295 });
  assert.deepEqual(h.calls, [], 'The native video control strip owns its touch gestures.');
  swipe(h, 'left', { pointerId: 2, target: video }); assert.deepEqual(h.calls, ['next'], 'The upper video picture remains swipeable.'); finish(h);
}
{
  const h = setup();
  h.options.onNext = () => { h.calls.push('next'); h.options.resetKey = 'next-picture'; h.controller.reset(); };
  swipe(h);
  const keyboard = h.make('click', { detail: 0 }); h.controller.onClickCapture(keyboard);
  assert.equal(keyboard.defaultPrevented, false, 'Keyboard/programmatic activation remains available during the click guard.');
  const ghost = h.make('click'); h.controller.onClickCapture(ghost);
  assert.equal(ghost.defaultPrevented, true, 'The compatibility click is blocked even when navigation synchronously changed resetKey/reset the candidate.');
  assert.equal(ghost.immediateStopped, true);
  let accidentalActions = 0;
  const unsafe = () => accidentalActions++;
  h.document.addEventListener('click', unsafe);
  const vote = new FakeElement(h.document, 'button', { class: 'vote-button' }, h.surface);
  h.emit('click', { target: vote });
  assert.equal(accidentalActions, 0, 'The native document capture guard blocks a ghost vote/fullscreen/image click before bubble handlers.');
  h.begin({ pointerId: 2, clientX: 200 }); h.emit('pointerup', { pointerId: 2, clientX: 200 });
  const fresh = h.emit('click', { target: vote });
  assert.equal(fresh.defaultPrevented, false); assert.equal(accidentalActions, 1, 'A fresh physical tap is not swallowed by the prior swipe.');
  h.document.removeEventListener('click', unsafe); finish(h);
}
{
  const h = setup(); swipe(h); h.controller.destroy();
  const ghost = h.emit('click'); assert.equal(ghost.defaultPrevented, true, 'An unmount/destroy during navigation retains the bounded ghost-click guard.');
  h.timer.advance(1000);
  const later = h.emit('click'); assert.equal(later.defaultPrevented, false, 'The temporary guard expires instead of disabling later interactions.'); finish(h);
}
{
  const h = setup(); h.begin(); h.emit('pointermove', { clientX: 180 }); h.controller.destroy();
  h.emit('pointerup', { clientX: 80 }); assert.deepEqual(h.calls, [], 'Unmounting midgesture prevents a late release callback.'); finish(h);
}
{
  // Execute the real hook through persistent ref/effect slots, not a copy of its
  // handlers. The navigation callback commits a new key and runs its real effect
  // before the browser's compatibility click reaches the newly rendered props.
  const document = new FakeDocument(), surface = new FakeElement(document, 'button'), image = new FakeElement(document, 'img', {}, surface), timer = clock();
  const slots = [], effects = [], pending = [], controllers = [];
  let cursor = 0, resetCalls = 0, key = 0, next = 0, props;
  const react = {
    useRef(value) { const index = cursor++; return slots[index] ??= { current: value }; },
    useEffect(effect, dependencies) {
      const index = cursor++, old = effects[index];
      if (!old || old.dependencies.length !== dependencies.length || dependencies.some((value, item) => !Object.is(value, old.dependencies[item]))) {
        effects[index] = { dependencies: [...dependencies], cleanup: old?.cleanup };
        pending.push({ index, effect });
      }
    },
  };
  const module = { exports: {} };
  const compiled = ts.transpileModule(readFileSync(new URL('../app/use-horizontal-swipe.ts', import.meta.url), 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 } }).outputText;
  new Function('require', 'module', 'exports', compiled)(name => {
    if (name === 'react') return react;
    if (name === '../lib/horizontal-swipe') return { createHorizontalSwipeController(getOptions) {
      const controller = createHorizontalSwipeController(getOptions, timer), reset = controller.reset;
      controller.reset = () => { resetCalls++; reset(); }; controllers.push(controller); return controller;
    } };
    throw new Error(`Unexpected hook dependency: ${name}`);
  }, module, module.exports);
  const hook = module.exports.default;
  function flushEffects() {
    for (const job of pending.splice(0)) { effects[job.index].cleanup?.(); effects[job.index].cleanup = job.effect(); }
  }
  function render() {
    cursor = 0;
    props = hook({ allowRootButton: true, resetKey: key, onPrevious() {}, onNext() { next++; key++; render(); flushEffects(); } });
  }
  render(); flushEffects();
  assert.equal(props.style.touchAction, 'pan-y pinch-zoom', 'The actual hook leaves vertical pan and pinch to the browser.');
  const down = event('pointerdown', { target: image, clientX: 300, clientY: 120 }); document.dispatchEvent(down);
  props.onPointerDownCapture({ nativeEvent: down, currentTarget: surface });
  document.dispatchEvent(event('pointermove', { target: image, clientX: 80, clientY: 125 }));
  document.dispatchEvent(event('pointerup', { target: image, clientX: 80, clientY: 125 }));
  assert.equal(next, 1); assert.equal(key, 1); assert.equal(controllers.length, 1, 'The rerender retains the same controller/ref.');
  assert.equal(resetCalls, 2, 'Both the mount and navigation-key reset effects actually executed.');
  const ghost = event('click', { target: image }); props.onClickCapture(ghost);
  assert.equal(ghost.defaultPrevented, true, 'The real hook still blocks the ghost enlarge click after its navigation rerender/reset effect.');
  const keyboard = event('click', { detail: 0, target: image }); props.onClickCapture(keyboard);
  assert.equal(keyboard.defaultPrevented, false, 'The freshly rendered hook keeps keyboard activation available.');
  const freshDown = event('pointerdown', { pointerId: 2, target: image, clientX: 200, clientY: 120 }); document.dispatchEvent(freshDown);
  props.onPointerDownCapture({ nativeEvent: freshDown, currentTarget: surface });
  document.dispatchEvent(event('pointerup', { pointerId: 2, target: image, clientX: 200, clientY: 120 }));
  const freshClick = event('click', { target: image }); props.onClickCapture(freshClick);
  assert.equal(freshClick.defaultPrevented, false, 'A new real tap can still enlarge the current image.');
  for (const effect of effects) effect?.cleanup?.(); timer.advance(1000);
  for (const type of ['pointerdown', 'pointermove', 'pointerup', 'pointercancel', 'lostpointercapture', 'gesturestart', 'click']) assert.equal(document.count(type), 0, 'The actual hook cleanup releases native listeners.');
  assert.equal(timer.count(), 0);
}
console.log('PASS: real native swipe controller and hook cover touch intent, scrolling, controls/video/zoom, outside multitouch, cancellation/reset cleanup, disabled states and tap-after-rerender ghost-click suppression. No browser/network.');
