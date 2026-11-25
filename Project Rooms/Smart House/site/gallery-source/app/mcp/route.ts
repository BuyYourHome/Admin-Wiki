import { env } from 'cloudflare:workers';
import { handleLightingMcp, type LightingEnvironment } from '../../worker/lighting-source';
export const dynamic = 'force-dynamic';
export async function POST(request: Request) { return handleLightingMcp(request, env as LightingEnvironment); }
export async function GET(request: Request) { return handleLightingMcp(request, env as LightingEnvironment); }
