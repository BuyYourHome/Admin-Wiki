/** Geometry only: a deliberate gallery change may reveal its label and first visual. */
export type GalleryScrollGeometry = {
  headingTop: number; headingBottom: number; visualTop: number | null;
  headerBottom: number; viewportHeight: number; scrollY: number;
};

export function getGalleryScrollTop(value: GalleryScrollGeometry): number | null {
  const { headingTop, headingBottom, visualTop, headerBottom, viewportHeight, scrollY } = value;
  if (![headingTop, headingBottom, headerBottom, viewportHeight, scrollY].every(Number.isFinite)
    || (visualTop !== null && !Number.isFinite(visualTop)) || viewportHeight <= 0) return null;
  const top = Math.max(0, headerBottom) + 12, bottom = viewportHeight - 12;
  if (top >= bottom) return null;
  const available = bottom - top, headingHeight = Math.max(0, headingBottom - headingTop);
  const headingFits = headingHeight <= available;
  const visualFits = visualTop !== null && visualTop >= headingTop && visualTop - headingTop + 48 <= available;
  const headingVisible = headingTop >= top - 2 && headingTop < bottom - 24
    && (!headingFits || headingBottom <= bottom + 2);
  const visualVisible = !visualFits || visualTop! + 48 <= bottom + 2;
  if (headingVisible && visualVisible) return null;
  const destination = Math.max(0, scrollY + headingTop - top);
  return Math.abs(destination - scrollY) <= 2 ? null : destination;
}
