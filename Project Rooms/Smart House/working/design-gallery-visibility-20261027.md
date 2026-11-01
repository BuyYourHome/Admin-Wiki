# Design gallery visibility — 2026-10-27

Wes reported that choosing another Design gallery updates it below the visible screen, leaving the change unclear until he scrolls. He asked for solutions, then explicitly instructed “Implement this feature when you are ready.” The selected solution is to bring the chosen gallery into view below the fixed header and retain the clear active-button highlight.

Only deliberate gallery changes should request scrolling. Initial page rendering, vote/result refreshes and selecting the same room must not cause a jump. Measure the current header at the time of scrolling so wrapped navigation and voice status are accounted for. Skip an unnecessary scroll when the heading and beginning of the selected visual are already visible. Respect reduced-motion preferences and retain native button focus. No full-screen gallery or new dialog is introduced.

The gallery's existing dark selected-button treatment and pressed state remain. A named gallery region and button control relationship clarify the selected content. Public catalog IDs, voting records, media selection and menu order remain unchanged.

Focused tests execute the actual selection handler and deferred effect with layout/timer doubles. They passed for desktop/phone header heights, final-layout measurement, visible-content no-op, reduced motion, first-visual visibility, stale request cancellation, navigation cleanup, unchanged saving guards, preserved native focus and no initial/vote-refresh replay. Existing Contact/navigation checks passed. Independent source review passed; current CSS does not impose smooth scrolling on the reduced-motion auto path. No real browser interaction is inferred from these tests.

Exact source/publication identifiers and final build checks are in [[Project Rooms/Smart House/working/hosting-and-domain]].
