CREATE TABLE `pondster_conversation_events` (
	`conversation_id` text NOT NULL,
	`event_id` text NOT NULL,
	`sequence` integer NOT NULL,
	`role` text NOT NULL,
	`text` text NOT NULL,
	`start_ms` integer,
	`end_ms` integer,
	`created_at` integer NOT NULL,
	`expires_at` integer NOT NULL,
	PRIMARY KEY(`conversation_id`, `event_id`)
);
--> statement-breakpoint
CREATE INDEX `pondster_events_expiry` ON `pondster_conversation_events` (`expires_at`);--> statement-breakpoint
CREATE TABLE `pondster_conversations` (
	`id` text PRIMARY KEY NOT NULL,
	`visitor_id` text NOT NULL,
	`mode` text NOT NULL,
	`started_at` integer NOT NULL,
	`ended_at` integer,
	`expires_at` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `pondster_conversations_visitor` ON `pondster_conversations` (`visitor_id`,`started_at`);--> statement-breakpoint
CREATE INDEX `pondster_conversations_expiry` ON `pondster_conversations` (`expires_at`);--> statement-breakpoint
CREATE TABLE `pondster_visitors` (
	`id` text PRIMARY KEY NOT NULL,
	`first_name` text,
	`consent_at` integer NOT NULL,
	`introduced_at` integer,
	`expires_at` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `pondster_visitors_expiry` ON `pondster_visitors` (`expires_at`);