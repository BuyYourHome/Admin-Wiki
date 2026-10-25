CREATE TABLE `voice_sessions` (
	`request_id` text PRIMARY KEY NOT NULL,
	`visitor_key` text NOT NULL,
	`provider_id` text,
	`created_at` integer NOT NULL,
	`expires_at` integer NOT NULL,
	`state` text NOT NULL,
	`usage_seconds` integer DEFAULT 0 NOT NULL,
	`final_usage_confirmed` integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE INDEX `voice_sessions_created` ON `voice_sessions` (`created_at`);--> statement-breakpoint
CREATE INDEX `voice_sessions_visitor_created` ON `voice_sessions` (`visitor_key`,`created_at`);--> statement-breakpoint
CREATE INDEX `voice_sessions_state` ON `voice_sessions` (`state`);