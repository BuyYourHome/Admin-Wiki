import { env } from 'cloudflare:workers';
import { voiceIsAvailable, voiceStatus } from '../../../../worker/pondster-live';
import { voiceProviderStatus } from '../../../../worker/pondster-live-diagnostics';

export const dynamic = 'force-dynamic';
export function GET(request: Request) {
  const base = voiceStatus(request, env);
  if (base.status === 200 && voiceIsAvailable(env) && new URL(request.url).searchParams.get('check') === 'provider') {
    return voiceProviderStatus(base, env.OPENAI_API_KEY!);
  }
  return base;
}
