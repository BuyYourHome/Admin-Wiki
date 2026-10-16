# Smart House planning context

## Authority And Provenance

Preserved 2026-10-16 from Jean's Voice task `019fbe57-fcd9-7c83-be74-e377c7b9c4d0`, planning turns `01a14556-f1a2-7720-b86e-22e194e7d4de` through `01a14565-658f-75f3-88a8-129bef6776e8`. See ../sources/planning-conversation-2026-10-16.md for the relevant voice transcript and written responses.

Wes: “Go ahead and create a project room for smart house. Transfer this whole conversation into that project room and we'll pick up conversations ... and directions there.”

Authoritative setup message: `prmsg-jean-create-pr-smart-house-20261016-001`; SHA-256 `d6004534bd65ad09d08d4371ea02b5a3b0e3e17ee0d56accedc309496aeeb6b6`. This authorizes setup/context preservation only.

## Wes's Desired Outcome

- Property: **908 Pond Street**, being remodeled for sale.
- A full house website/digital twin, not merely a listing or landing page; support BYH now and the new owners later.
- Explain systems to prospective buyers, demonstrate the unfinished house virtually, and support guided in-person demonstrations.
- Components discussed: TVs/screens, speakers, recessed LED lights, HVAC, front door, sensors, and other smart devices.
- Visitors/agents could use cue cards and guided voice interactions to understand features.
- Existing diagrams and smart-component specifications are reportedly in the property's Teams materials and LED lighting work. Exact source paths and installed specifications have not been verified here.
- The house should explain itself to its new owner: manuals, controls, maintenance (including HVAC), troubleshooting, and other approved knowledge.
- Develop inside BYH initially, with documents/structure portable to a property-specific system and eventual buyer ownership.
- Begin minimally, with room for expansion. Wes asked about hosting, a local computer, domain, subscriptions, and transfer; these questions are not purchasing or provisioning approval.

## Architecture Discussed — Proposals, Not Implemented

1. Public layer: property story, photos/plans, progress, features, virtual walkthrough, simulated controls only.
2. Showing layer: time-limited permissions for specifically approved safe scenes (lighting/music/screens; any climate preset needs separate safe limits). No unrestricted device access.
3. Owner layer: authenticated portal for private manuals, maintenance, notifications, and approved controls.
4. Local property-owned hub: integrations, automations, voice, private knowledge, and offline-safe operation. Core controls must not depend on a personal AI subscription or public website.
5. External public hosting with a narrow authenticated bridge if later approved. No public locks, alarms, cameras, unrestricted HVAC, or unrestricted Home Assistant.

## Portable Home Records And Handover

Each system record should identify what it is, where it is, how it works and is safely controlled, installation details, manuals, warranties, vendor, maintenance, troubleshooting, and relevant page/cue card/voice question. AI answers should use approved records and state missing facts.

Separate internal BYH material (costs, negotiations, construction notes, sales strategy) from buyer materials (website source, digital twin, device inventory, diagrams, manuals, warranties, maintenance, automation descriptions, owner knowledge, account inventory/recovery methods, permissions, transfer checklist). Secrets do not belong in Git or ordinary handoffs.

Potential property-specific assets discussed: domain, email, source repository, smart-home service accounts, optional metered AI/API project with spending limits. No accounts, domain, subscription, repository, or hosting have been purchased or created.

## Hosting And AI Discussion — Reverify Before Decisions

Prior assistant responses discussed ChatGPT Sites hosting/custom domains, included hosting on a personal plan, workspace-limited ownership transfer, independent source export/rehosting, and a separate metered API for optional owner-facing AI. These are preserved as historical discussion, not current verified service facts or guarantees. Verify pricing, hosting, export, transfer, authentication, and runtime capabilities before implementation. Do not infer that any provider supports unrestricted transfer at closing.

## Owning Workflows

- Smart House: property-level requirements, experience planning, knowledge structure, portability, and approved future project coordination.
- LED lighting: lighting zones, loads, supplies, controls, compatibility, specifications. Task `01a0b696-05a2-7291-a857-084a6f2bc2eb`; currently not dispatchable.
- Home Assistant: live integrations, permissions, automation/configuration, backups and safe control implementation. Task `01a02e53-5f75-7103-b5e7-17b842547cef`; reverify routing/readiness before handoff.
- Reuse their authoritative references. Reading does not grant write authority. No specialized work or outgoing technical handoff has been executed by this setup.

## Resume Point

Continue planning with Wes in Smart House. Identify exact Teams sources and device list, define the first approved phase and safe demonstration boundaries, then plan the portable package. Obtain explicit implementation authority before building/publishing anything or connecting devices.
