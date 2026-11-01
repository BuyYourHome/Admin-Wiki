'use client';

import { useEffect, useRef, type HTMLAttributes } from 'react';
import { createHorizontalSwipeController, type HorizontalSwipeOptions } from '../lib/horizontal-swipe';

/** Spread on the image/media surface, keeping the navigation controls outside it. */
export default function useHorizontalSwipe<T extends HTMLElement>(options: HorizontalSwipeOptions): HTMLAttributes<T> {
  const latest = useRef(options);
  latest.current = options;
  const controller = useRef<ReturnType<typeof createHorizontalSwipeController> | null>(null);
  if (!controller.current) controller.current = createHorizontalSwipeController(() => latest.current);
  useEffect(() => { controller.current?.reset(); }, [options.resetKey, options.enabled]);
  useEffect(() => () => controller.current?.destroy(), []);
  return {
    style: { touchAction: 'pan-y pinch-zoom' },
    onPointerDownCapture: event => controller.current?.onPointerDown(event.nativeEvent, event.currentTarget),
    onClickCapture: event => controller.current?.onClickCapture(event),
  };
}
