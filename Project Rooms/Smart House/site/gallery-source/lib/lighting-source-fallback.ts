import seedData from './lighting-source-seed.json' with { type: 'json' };
import { validateProjection } from './lighting-source-model';

/** Generated from the verified source; used only before the public API is available. */
export const LIGHTING_SEED_SNAPSHOT = validateProjection(seedData);
