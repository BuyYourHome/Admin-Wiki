CREATE TABLE `page_comments` (
	`id` text PRIMARY KEY NOT NULL,
	`request_id` text NOT NULL,
	`page` text NOT NULL,
	`visitor_key` text NOT NULL,
	`name` text NOT NULL,
	`body` text NOT NULL,
	`created_at` integer NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `page_comments_request_id_unique` ON `page_comments` (`request_id`);--> statement-breakpoint
CREATE INDEX `page_comments_page_created_id` ON `page_comments` (`page`,`created_at`,`id`);--> statement-breakpoint
CREATE INDEX `page_comments_visitor_created` ON `page_comments` (`visitor_key`,`created_at`);