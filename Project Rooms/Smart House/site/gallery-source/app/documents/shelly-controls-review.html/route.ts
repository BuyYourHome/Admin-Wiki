import { env } from 'cloudflare:workers';
import { readLightingSnapshot, type LightingEnvironment } from '../../../worker/lighting-source';
import { renderLightingReview } from '../../../lib/lighting-review-html';
export const dynamic = 'force-dynamic';
export async function GET(request: Request) {
  let snapshot;
  try { snapshot = await readLightingSnapshot(env as LightingEnvironment); }
  catch { return new Response('My current lighting review is temporarily unavailable. Please try again.', { status: 503, headers: { 'Content-Type': 'text/plain; charset=utf-8', 'Cache-Control': 'no-store' } }); }
  const headers = { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'public, max-age=30, must-revalidate', ETag: `"${snapshot.revision}"`, 'X-Content-Type-Options': 'nosniff', 'X-Lighting-Revision': snapshot.revision, 'Content-Security-Policy': "default-src 'none'; style-src 'unsafe-inline'; base-uri 'none'; frame-ancestors 'self'" };
  return request.headers.get('if-none-match') === headers.ETag ? new Response(null, { status: 304, headers }) : new Response(renderLightingReview(snapshot), { headers });
}
