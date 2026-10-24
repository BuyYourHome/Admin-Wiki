CREATE TABLE `design_votes` (
	`room` text NOT NULL,
	`voter_key` text NOT NULL,
	`design_id` text NOT NULL,
	`updated_at` integer NOT NULL,
	PRIMARY KEY(`room`, `voter_key`)
);
