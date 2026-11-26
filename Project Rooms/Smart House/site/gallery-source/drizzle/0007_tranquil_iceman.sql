CREATE TABLE `pondster_conversation_email_chunks` (
	`email_id` text NOT NULL,
	`chunk_index` integer NOT NULL,
	`body` text NOT NULL,
	`expires_at` integer NOT NULL,
	PRIMARY KEY(`email_id`, `chunk_index`)
);
--> statement-breakpoint
CREATE INDEX `pondster_email_chunks_expiry` ON `pondster_conversation_email_chunks` (`expires_at`);--> statement-breakpoint
CREATE TABLE `pondster_conversation_emails` (
	`id` text PRIMARY KEY NOT NULL,
	`conversation_id` text NOT NULL,
	`max_sequence` integer NOT NULL,
	`body_hash` text NOT NULL,
	`subject` text NOT NULL,
	`sender` text NOT NULL,
	`recipient` text NOT NULL,
	`state` text NOT NULL,
	`is_update` integer NOT NULL,
	`chunk_count` integer NOT NULL,
	`body_characters` integer NOT NULL,
	`source_last_at` integer NOT NULL,
	`created_at` integer NOT NULL,
	`expires_at` integer NOT NULL,
	`attempt_token` text,
	`attempt_started_at` integer,
	`attempt_count` integer DEFAULT 0 NOT NULL,
	`last_error_code` text,
	`sent_message_id` text,
	`sent_at` integer
);
--> statement-breakpoint
CREATE UNIQUE INDEX `pondster_email_revision` ON `pondster_conversation_emails` (`conversation_id`,`max_sequence`,`body_hash`);--> statement-breakpoint
CREATE UNIQUE INDEX `pondster_email_one_pending` ON `pondster_conversation_emails` (`conversation_id`) WHERE "pondster_conversation_emails"."state" IN ('ready','attempting','ambiguous');--> statement-breakpoint
CREATE INDEX `pondster_email_state_created` ON `pondster_conversation_emails` (`state`,`created_at`);--> statement-breakpoint
CREATE INDEX `pondster_email_expiry` ON `pondster_conversation_emails` (`expires_at`);