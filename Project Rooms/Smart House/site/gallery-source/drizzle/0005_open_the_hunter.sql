CREATE TABLE `lighting_source_publication` (
	`id` text PRIMARY KEY NOT NULL,
	`revision` text NOT NULL,
	`public_json` text NOT NULL,
	`source_drive_id` text NOT NULL,
	`source_item_id` text NOT NULL,
	`source_etag` text NOT NULL,
	`source_modified_at` text,
	`published_at` text NOT NULL,
	`last_checked_at` text NOT NULL,
	`last_success_at` text NOT NULL,
	`sync_status` text NOT NULL,
	`last_error_code` text
);
