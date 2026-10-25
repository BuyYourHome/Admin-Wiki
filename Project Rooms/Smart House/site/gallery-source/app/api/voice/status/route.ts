import { env } from 'cloudflare:workers';
import { voiceStatus } from '../../../../worker/pondster-live';

export const dynamic = 'force-dynamic';
export function GET(request: Request) { return voiceStatus(request, env); }
