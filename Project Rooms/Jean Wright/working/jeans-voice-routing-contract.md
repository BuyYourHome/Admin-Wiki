# Jean's Voice Routing Contract

## Purpose

`Jean's Voice` is Wes's voice interface to the existing Jean Wright / Office Assistant task. It is not a separate Project Room, a substitute Jean, or an independent owner of Buy Your Home work.

## Active Tasks

- Voice interface task: `019fbe57-fcd9-7c83-be74-e377c7b9c4d0`
- Jean Wright task: `019e8e54-f8c3-7233-88dd-e1dffd79c9a6`

Do not create a new Jean Wright task, worker task, or replacement voice task for ordinary requests. An older task with the same title does not replace the active task id above.

## Voice-To-Jean Handoff

When Wes makes a business, administrative, Project Room, status, research, drafting, sending, file, or workflow request in Jean's Voice:

1. Send the request immediately to the existing Jean Wright task with `send_message_to_thread`.
2. Preserve Wes's words as closely as practical. Include relevant transcript text, attachment paths, links, and source references without silently changing the requested action.
3. Assign a stable id: `jeans-voice-YYYYMMDD-<short-topic>-vN`.
4. State that the source was Jean's Voice and that the instruction is a direct Wes voice instruction.
5. Do not perform the business task in Jean's Voice and do not create a separate worker task. Jean Wright owns interpretation, authorization checks, execution, and dispatch to specialized Project Rooms.
6. Treat voice instructions with the same authority and safety limits as instructions typed by Wes. Voice does not bypass confirmation, email, financial, legal, deletion, purchase, connector, or Project Room ownership rules.

Voice-interface questions such as whether the microphone is active, how to end the voice session, or whether speech was heard may be answered locally when no Jean work is requested.

## Jean-To-Voice Return

Jean Wright should return one of these statuses to the active Jean's Voice task:

- `accepted` - Jean owns or has routed the request and work is continuing;
- `done` - the requested work is complete, including required delivery verification;
- `blocked` - work cannot proceed and the blocker is identified;
- `needs Wes` - a decision, clarification, approval, source, credential, or connector action is required.

The return must include the same voice handoff id and a concise response suitable for spoken delivery. Jean's Voice should speak or display Jean's returned result and must not claim completion before receiving it.

## Clarification And Interruption

- If the transcript is materially ambiguous, route the exact ambiguity to Jean instead of guessing.
- If Wes corrects or cancels a request, immediately send the correction with the same handoff id and a new version number when the requested action changed.
- If the user says `stop`, `pause`, `wait`, `do not proceed`, or equivalent while a routed action is active, forward that instruction immediately to Jean. A voice-session stop does not itself cancel already routed work unless Wes says to stop the work.
- Do not duplicate a handoff because Jean has not yet returned. Ask Jean for status using the existing handoff id.

## Availability Boundary

This contract enables routing while the Codex app, the active Jean's Voice task, and task-messaging tools are available. It does not make the microphone continuously available, start or end voice sessions remotely, or guarantee operation when the host computer or Codex app is offline.
