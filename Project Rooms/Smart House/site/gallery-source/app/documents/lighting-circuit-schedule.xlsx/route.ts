import { env } from 'cloudflare:workers';
import { readLightingSnapshot, type LightingEnvironment } from '../../../worker/lighting-source';
import { generateLightingPublicWorkbook } from '../../../lib/lighting-public-workbook';
export const dynamic = 'force-dynamic';
export async function GET(request: Request) {
  let snapshot;
  try { snapshot = await readLightingSnapshot(env as LightingEnvironment); }
  catch { return new Response('My current lighting workbook is temporarily unavailable. Please try again.', { status: 503, headers: { 'Content-Type': 'text/plain; charset=utf-8', 'Cache-Control': 'no-store' } }); }
  const headers = { 'Content-Type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'Content-Disposition': 'attachment; filename="pondster-lighting-circuit-schedule.xlsx"', 'Cache-Control': 'public, max-age=30, must-revalidate', ETag: `"${snapshot.revision}"`, 'X-Content-Type-Options': 'nosniff', 'X-Lighting-Revision': snapshot.revision };
  if (request.headers.get('if-none-match') === headers.ETag) return new Response(null, { status: 304, headers });
  const bytes = generateLightingPublicWorkbook(snapshot), body = new ArrayBuffer(bytes.byteLength);
  new Uint8Array(body).set(bytes);
  return new Response(body, { headers });
}
