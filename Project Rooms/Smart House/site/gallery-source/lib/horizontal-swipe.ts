export type HorizontalSwipeOptions = {
  onPrevious: () => void;
  onNext: () => void;
  enabled?: boolean;
  canPrevious?: boolean;
  canNext?: boolean;
  resetKey?: unknown;
  /** Only for a dedicated image-opening button, never a navigation/vote control. */
  allowRootButton?: boolean;
  protectNativeVideo?: boolean;
};
type Clock = { now: () => number; setTimer: (callback: () => void, milliseconds: number) => ReturnType<typeof setTimeout>; clearTimer: (timer: ReturnType<typeof setTimeout>) => void };
type Click = { detail: number; preventDefault: () => void; stopPropagation: () => void; stopImmediatePropagation?: () => void; nativeEvent?: { stopImmediatePropagation?: () => void } };
type Gesture = { id: number; x: number; y: number; lastX: number; lastY: number; phase: 'pending' | 'horizontal' | 'vertical'; key: unknown; surface: HTMLElement; captured: boolean };
const controls = 'a,button,input,textarea,select,label,form,summary,[contenteditable]:not([contenteditable="false"]),[role="button"],[role="link"],[role="slider"],[role="checkbox"],[role="radio"],[data-swipe-ignore],audio[controls]';

/** One touch gesture; native vertical scrolling and pinch zoom retain browser ownership. */
export function createHorizontalSwipeController(getOptions: () => HorizontalSwipeOptions, clock: Clock = { now: Date.now, setTimer: setTimeout, clearTimer: clearTimeout }) {
  let gesture: Gesture | null = null, document: Document | null = null;
  let draggedDocument: Document | null = null;
  const touches = new Set<number>();
  let blocked = false;
  let clickDocument: Document | null = null, clickUntil = 0, clickTimer: ReturnType<typeof setTimeout> | undefined;
  const zoomed = (surface: HTMLElement) => Math.abs((surface.ownerDocument.defaultView?.visualViewport?.scale ?? 1) - 1) > .01;
  function cancelGesture() {
    const current = gesture; gesture = null;
    if (current?.captured) { try { current.surface.releasePointerCapture(current.id); } catch { /* Capture may already be gone. */ } }
  }
  function clearClickGuard() {
    clickDocument?.removeEventListener('click', guardClick, true);
    clickDocument?.removeEventListener('pointerdown', clearClickGuard, true);
    if (clickTimer !== undefined) clock.clearTimer(clickTimer);
    clickDocument = null; clickTimer = undefined; clickUntil = 0;
  }
  function onClickCapture(event: Click) {
    if (event.detail === 0 || !clickUntil || clock.now() > clickUntil) return;
    event.preventDefault(); event.stopPropagation();
    event.stopImmediatePropagation?.(); event.nativeEvent?.stopImmediatePropagation?.();
  }
  function guardClick(event: Event) { onClickCapture(event as MouseEvent); }
  function armClickGuard(owner: Document) {
    clearClickGuard(); clickDocument = owner; clickUntil = clock.now() + 700;
    owner.addEventListener('click', guardClick, true);
    // A fresh physical interaction is a new tap, not the prior drag's compatibility click.
    owner.addEventListener('pointerdown', clearClickGuard, true);
    clickTimer = clock.setTimer(clearClickGuard, 700);
  }
  function cleanup() {
    if (!document) return;
    document.removeEventListener('pointerdown', otherTouch, true);
    document.removeEventListener('pointermove', move, true);
    document.removeEventListener('pointerup', up, true);
    document.removeEventListener('pointercancel', cancelPointer, true);
    document.removeEventListener('lostpointercapture', lostCapture, true);
    document.removeEventListener('gesturestart', pinch, true);
    document.defaultView?.visualViewport?.removeEventListener('resize', pinch);
    document = null;
  }
  function pinch() { blocked = true; cancelGesture(); }
  function otherTouch(event: Event) {
    const pointer = event as PointerEvent;
    if (pointer.pointerType !== 'touch') return;
    touches.add(pointer.pointerId);
    if (touches.size > 1) { blocked = true; cancelGesture(); }
  }
  function update(event: PointerEvent) {
    const current = gesture, options = getOptions();
    if (!current || current.id !== event.pointerId) return;
    if (blocked || options.enabled === false || !Object.is(current.key, options.resetKey) || zoomed(current.surface)) { cancelGesture(); return; }
    current.lastX = event.clientX; current.lastY = event.clientY;
    const x = Math.abs(event.clientX - current.x), y = Math.abs(event.clientY - current.y);
    if (current.phase === 'pending' && Math.max(x, y) >= 12) {
      if (y > x * 1.15) current.phase = 'vertical';
      else if (x > y * 1.4) {
        current.phase = 'horizontal';
        draggedDocument = current.surface.ownerDocument;
        if (event.type !== 'pointerup') { try { current.surface.setPointerCapture(current.id); current.captured = true; } catch { /* Document listeners still observe release. */ } }
      }
    }
    if (current.phase === 'horizontal' && event.cancelable) event.preventDefault();
  }
  function move(event: Event) { update(event as PointerEvent); }
  function finishPointer(pointer: PointerEvent) {
    touches.delete(pointer.pointerId);
    if (!touches.size) { cancelGesture(); draggedDocument = null; blocked = false; cleanup(); }
  }
  function guardDraggedRelease(pointer: PointerEvent) {
    if (draggedDocument && touches.size === 1 && touches.has(pointer.pointerId)) {
      armClickGuard(draggedDocument); draggedDocument = null;
    }
  }
  function up(event: Event) {
    const pointer = event as PointerEvent;
    update(pointer);
    guardDraggedRelease(pointer); // Also protects a drag canceled by a media/reset change.
    const current = gesture;
    if (current?.id === pointer.pointerId && current.phase === 'horizontal' && !blocked) {
      const dx = current.lastX - current.x, dy = current.lastY - current.y;
      const threshold = Math.max(44, Math.min(80, current.surface.getBoundingClientRect().width * .12));
      const options = getOptions();
      cancelGesture();
      // The release guard is armed before callbacks can render or unmount this surface.
      if (Math.abs(dx) >= threshold && Math.abs(dx) > Math.abs(dy) * 1.4) {
        if (dx < 0 && options.canNext !== false) options.onNext();
        if (dx > 0 && options.canPrevious !== false) options.onPrevious();
      }
    }
    finishPointer(pointer);
  }
  function cancelPointer(event: Event) {
    const pointer = event as PointerEvent;
    guardDraggedRelease(pointer);
    if (gesture?.id === pointer.pointerId) cancelGesture();
    finishPointer(pointer);
  }
  function lostCapture(event: Event) { if (gesture?.id === (event as PointerEvent).pointerId) cancelGesture(); }
  function onPointerDown(event: PointerEvent, surface: HTMLElement) {
    const options = getOptions();
    if (event.pointerType !== 'touch' || !event.isPrimary || event.button !== 0 || options.enabled === false || touches.size || zoomed(surface)) return;
    const target = event.target as Element | null;
    const control = target?.closest?.(controls);
    if (control && !(options.allowRootButton && control === surface && surface.tagName === 'BUTTON')) return;
    const video = target?.closest?.('video[controls]') as HTMLVideoElement | null;
    if (video && options.protectNativeVideo !== false) {
      const rect = video.getBoundingClientRect();
      if (event.clientY >= rect.bottom - Math.min(72, Math.max(44, rect.height * .22))) return;
    }
    clearClickGuard(); draggedDocument = null; document = surface.ownerDocument; touches.add(event.pointerId); blocked = false;
    gesture = { id: event.pointerId, x: event.clientX, y: event.clientY, lastX: event.clientX, lastY: event.clientY, phase: 'pending', key: options.resetKey, surface, captured: false };
    document.addEventListener('pointerdown', otherTouch, true);
    document.addEventListener('pointermove', move, { capture: true, passive: false });
    document.addEventListener('pointerup', up, true);
    document.addEventListener('pointercancel', cancelPointer, true);
    document.addEventListener('lostpointercapture', lostCapture, true);
    document.addEventListener('gesturestart', pinch, true);
    document.defaultView?.visualViewport?.addEventListener('resize', pinch);
  }
  return { onPointerDown, onClickCapture, reset: cancelGesture, destroy() { cancelGesture(); if (draggedDocument) armClickGuard(draggedDocument); draggedDocument = null; touches.clear(); blocked = false; cleanup(); } };
}
