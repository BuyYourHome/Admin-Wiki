import { env } from 'cloudflare:workers';
import { voiceAdmissionStatus, voiceIsAvailable } from '../../../../worker/pondster-live';
import { voiceProviderStatus } from '../../../../worker/pondster-live-diagnostics';

export const dynamic = 'force-dynamic';
export async function GET(request: Request) {
  const base = await voiceAdmissionStatus(request, env);
  if (base.status === 200 && voiceIsAvailable(env) && new URL(request.url).searchParams.get('check') === 'provider') {
    const admission = await base.clone().json() as { available?: boolean };
    if (admission.available === true) return voiceProviderStatus(base, env.OPENAI_API_KEY!);
  }
  return base;
}
