CREATE TABLE `pondster_visitor_name_events` (
	`id` text PRIMARY KEY NOT NULL,
	`request_id` text NOT NULL,
	`visitor_id` text NOT NULL,
	`conversation_id` text,
	`previous_first_name` text,
	`first_name` text NOT NULL,
	`source` text NOT NULL,
	`created_at` integer NOT NULL,
	`expires_at` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `pondster_name_events_visitor_request` ON `pondster_visitor_name_events` (`visitor_id`,`request_id`);--> statement-breakpoint
CREATE INDEX `pondster_name_events_visitor_created` ON `pondster_visitor_name_events` (`visitor_id`,`created_at`);--> statement-breakpoint
CREATE INDEX `pondster_name_events_conversation_created` ON `pondster_visitor_name_events` (`conversation_id`,`created_at`);--> statement-breakpoint
CREATE INDEX `pondster_name_events_expiry` ON `pondster_visitor_name_events` (`expires_at`);--> statement-breakpoint
ALTER TABLE `pondster_conversations` ADD `remembered_first_name` text;--> statement-breakpoint
ALTER TABLE `pondster_conversations` ADD `first_self_reported_name` text;--> statement-breakpoint
ALTER TABLE `pondster_conversations` ADD `first_self_reported_at` integer;