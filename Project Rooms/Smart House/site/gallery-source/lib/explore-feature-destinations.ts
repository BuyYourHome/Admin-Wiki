import { parsePondsterDestination, type PondsterDestination } from './pondster-destinations';

/** Owner-approved defaults; change one entry here when its destination changes. */
export const EXPLORE_FEATURE_DESTINATIONS = {
  'hot-water': { menu: 'Explore', section: 'room', room: 'kitchen' },
  'presence': { menu: 'Explore', section: 'room', room: 'media-center' },
  'bath-and-shower': { menu: 'Design', room: 'hall-bath' },
  // Temporary authorized subject match. No precise Living Room TV-surveillance
  // image is available; replace this gallery target when that image is supplied.
  'exterior-awareness': { menu: 'Design', room: 'media-center' },
  'voice-feature': { menu: 'Contact', section: 'voice' },
  'lighting-plans': { menu: 'Explore', section: 'lighting' },
  'sound-screens': { menu: 'Own', section: 'audio' },
  'climate': { menu: 'Contact', section: 'hvac' },
  'design-participation': { menu: 'Design', section: 'gallery' },
  'owner-experience': { menu: 'Own', section: 'handover' },
} as const satisfies Record<string, PondsterDestination>;

export type ExploreFeatureId = keyof typeof EXPLORE_FEATURE_DESTINATIONS;

/** Only application-owned destinations can leave this map; unknown IDs do nothing. */
export function getExploreFeatureDestination(sectionId: string): PondsterDestination | null {
  if (!Object.prototype.hasOwnProperty.call(EXPLORE_FEATURE_DESTINATIONS, sectionId)) return null;
  return parsePondsterDestination(EXPLORE_FEATURE_DESTINATIONS[sectionId as ExploreFeatureId]);
}
