import { env } from 'cloudflare:workers';
import { publicLightingResponse, type LightingEnvironment } from '../../../worker/lighting-source';
export const dynamic = 'force-dynamic';
export async function GET(request: Request) { return publicLightingResponse(request, env as LightingEnvironment); }
