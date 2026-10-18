# Pond Street hosting and domain

Wes reported buying `Pondstr.com` from GoDaddy and instructed Smart House to host it through ChatGPT on 2026-10-18. This supersedes the earlier local-only scope for hosting and connecting this purchased domain. No further purchase or live-device work is authorized.

## Hosting configuration

- Provider: ChatGPT Sites.
- Project ID: `appgprj_6ad4d98e08708191858cab113814704e`.
- Hosted URL: https://pondstr.coolnewt4097.chatgpt.site
- Audience: owner-private; no public-audience change requested or made.
- Initial publication succeeded: 2026-10-18T14:43:26Z.
- Site source commit: `f01a688c6167555dfc0474bbdbd43d043b99695d` in the separate Sites source repository. This is not an Admin Wiki commit.
- Saved version: `appgprj_6ad4d98e08708191858cab113814704e~appgver_0176b707d1688191be325f28960f58a6`.
- Deployment: `appgdep_6ad4dafedea88191934ecd974a287155`.
- Canonical linkage: `site/.openai/hosting.json`.
- Publication checkout: ignored `site/.hosting-work/`. Publish only the standalone static page, CSS, JavaScript, and the four approved exterior concepts; never the wiki, private records, credentials, or source inventories.

## Pondstr.com connection

Custom-domain ID: `appgdom_6ad4db25251c819184c11d38ed7bcbbe`. Sites returned `pending` with SSL `initializing`. Domain setup is not complete.

Exact DNS records returned by Sites on 2026-10-18:

| Type | GoDaddy name | Value |
| --- | --- | --- |
| A | `@` | `162.159.143.30` |
| A | `@` | `172.66.3.26` |
| TXT | `_openai-site-verification` | `openai-site-verification=WB9VsheBIO-J-yOL-iKeCQMeKm8ZHV7xsjywZ4udlfE` |
| TXT | `_cf-custom-hostname` | `5322fd4e-ef21-4c01-80ca-51a38a42160f` |

These are domain-verification DNS values intended for public DNS, not account credentials. No `www` hostname has been added. Do not substitute the subdomain CNAME target for the apex A records.

## Remaining work

The signed-in GoDaddy Chrome session's DNS management page reports **No domains match 'pondstr.com'**. The account's domain search also showed Pondstr.com as available/added in its purchase search. That is not proof of purchase failure, but it does not establish that this account owns the domain. No DNS records were changed. Wes was asked to locate the correct purchasing account or confirm order status.

When the owning account/domain appears: inspect the existing records, preserve mail and unrelated services, apply only the exact required records, then refresh this existing custom-domain ID and verify DNS, SSL, and website routing. Reuse the existing Sites project and domain record; do not recreate either. Do not claim the purchased domain works before verification.

## Windows publication notes

The official `site-workflow.mjs` helper uploaded and packaged the source. Its process required Git Bash and bundled Node on PATH, `TAR_OPTIONS=--force-local` for the Windows archive path, and a process-only `safe.directory` entry restricted to the newly created `.hosting-work` checkout because sandbox-created files had a different Windows owner. No global Git trust configuration was changed. Source credentials stayed in session memory and were passed through hidden stdin; none were written to Git or ordinary files.
