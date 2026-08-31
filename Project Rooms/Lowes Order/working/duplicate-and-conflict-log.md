# Duplicate And Conflict Log

| Item | Status | Notes |
| --- | --- | --- |
| Lowe's order sources | one source reviewed | Josh Kennedy's 2026-07-27 `Lowe's order` email was reviewed from the Email Monitor handoff. |
| Purchase authority | watch | Do not place or submit an order unless Wes explicitly approves the specific order action. |
| Cart fill versus checkout | no conflict identified | Filling a cart from email through Chrome is allowed; checkout, payment, delivery scheduling, and substitutions remain approval-gated. |
| Josh Kennedy 2026-07-27 quantities | superseded by new rule | Source email gave item numbers but no quantities. Wes later instructed Lowes Order to assume quantity `1` when no quantity is given, so future matching cart fills should not treat missing quantity alone as a blocker. |
| Josh Kennedy 2026-07-27 cart reprocess | no conflict identified | Cart was filled with one each of the four confirmed item-number matches after Wes changed the missing-quantity rule. |
| Bathroom Fixtures 2026-08-29 rough-in cart | no conflict identified | The preexisting Moen `S3102` cart line matched the requested model and quantity, so it was preserved and counted toward the requested package instead of duplicated. |
| Bathroom Fixtures 2026-08-31 complete cart | partial blocker | Existing unrelated Plytanium plywood quantity `8` was preserved. All requested Bathroom Fixtures models except Moen `S3102` were added or verified at exact requested quantities. Moen `S3102` was not added because Lowe's showed item #4057306 / model `S3102` as out of stock for ZIP `27511`; no substitution was made. |
| Bathroom Fixtures 2026-08-31 wand restore correction | needs Wes | Wes believed one wand-related component had been deleted, but the live cart was missing multiple selected baseline lines. Both wand-related candidates, `Delta 51584-PR` and `Delta 50570-SS-PR`, were missing along with seven other selected lines. No additions were made because the missing line was not unique. |
