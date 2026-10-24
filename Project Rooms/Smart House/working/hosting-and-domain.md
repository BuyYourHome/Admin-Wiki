# Pond Street hosting and domain

Wes reported buying `Pondstr.com` from GoDaddy and instructed Smart House to host it through ChatGPT on 2026-10-18. This supersedes the earlier local-only scope for hosting and connecting this purchased domain. No further purchase or live-device work is authorized.

## Hosting configuration

- Provider: ChatGPT Sites.
- Project ID: `appgprj_6ad4d98e08708191858cab113814704e`.
- Hosted URL: https://pondstr.coolnewt4097.chatgpt.site
- Audience: public, authorized by Wes in this chat on 2026-10-23. Visitors do not need to sign in. The owner retains editing access.
- Initial publication succeeded: 2026-10-18T14:43:26Z.
- Site source commit: `f01a688c6167555dfc0474bbdbd43d043b99695d` in the separate Sites source repository. This is not an Admin Wiki commit.
- Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_0176b707d1688191be325f28960f58a6`.
- Deployment: `appgdep_6ad4dafedea88191934ecd974a287155`.
- Canonical linkage: `site/.openai/hosting.json`.
- Publication checkout: ignored `site/.hosting-work/`. Publish only the standalone static page, CSS, JavaScript, and the four approved exterior concepts; never the wiki, private records, credentials, or source inventories.

## Pondstr.com connection

Custom-domain ID: `appgdom_6ad4db25251c819184c11d38ed7bcbbe`. GoDaddy DNS is configured and publicly verified. At 2026-10-18T15:00:28Z Sites confirmed overall status `active`, provider routing `active`, and SSL `active`. The custom domain is connected at https://pondstr.com .

Exact DNS records returned by Sites on 2026-10-18:

| Type | GoDaddy name | Value |
| --- | --- | --- |
| A | `@` | `162.159.143.30` |
| A | `@` | `172.66.3.26` |
| TXT | `_openai-site-verification` | `openai-site-verification=WB9VsheBIO-J-yOL-iKeCQMeKm8ZHV7xsjywZ4udlfE` |
| TXT | `_cf-custom-hostname` | `5322fd4e-ef21-4c01-80ca-51a38a42160f` |

These are domain-verification DNS values intended for public DNS, not account credentials. No `www` hostname has been added. Do not substitute the subdomain CNAME target for the apex A records.

## Remaining work

Wes completed the domain purchase and asked Smart House to retry. GoDaddy's receipt confirmed `pondstr.com` registration, and its domain DNS editor then became available. The prior missing-domain blocker is resolved.

On 2026-10-18 Smart House replaced the parked apex A record with `162.159.143.30`, added the second required A address `172.66.3.26`, and added the two exact TXT verification records above. All four were read back in GoDaddy after its successful-save notices. Nameservers, SOA, existing `www` and `_domainconnect` CNAMEs, and `_dmarc` were preserved. GoDaddy displayed 600-second TTL for both A records and one hour for the new TXT records.

Public resolver `1.1.1.1` independently returned both correct A addresses and both exact TXT values. At 2026-10-18T14:57:40Z Sites reported provider routing `active` but SSL `pending_validation`. A normal HTTPS check failed to establish SSL; no certificate checks were bypassed.

Completion: the subsequent Sites refresh confirmed active domain routing and certificate. A normal HTTPS request completed certificate validation and received HTTP 401, consistent with owner-private access. Browser verification at https://pondstr.com displayed **Log in to access** and **Continue with ChatGPT**. The sign-in link reached OpenAI login; no credentials were entered. Signed-out delivery of the private site's access page is verified; a fresh owner login inside this browser was not completed. No public-audience change was made. Reuse the existing Sites project and domain record for future changes.

## Windows publication notes

The official `site-workflow.mjs` helper uploaded and packaged the source. Its process required Git Bash and bundled Node on PATH, `TAR_OPTIONS=--force-local` for the Windows archive path, and a process-only `safe.directory` entry restricted to the newly created `.hosting-work` checkout because sandbox-created files had a different Windows owner. No global Git trust configuration was changed. Source credentials stayed in session memory and were passed through hidden stdin; none were written to Git or ordinary files.

## Public access — 2026-10-23

Wes requested removal of the website login requirement so the public can access it easily. The existing Sites project's access mode was changed from owner-only custom access to `public` through the Sites connector. The connector confirmed policy revision 2. An HTTPS request without cookies or authentication to https://pondstr.com/ returned HTTP 200, the expected Pond Street page, and no login gate. This changes visitor access to the existing concept website only; it does not provide device controls, owner records, or editing access. No source rebuild or DNS change was needed.
