ALTER TABLE `pondster_visitors` ADD `created_at` integer DEFAULT 0 NOT NULL;--> statement-breakpoint
ALTER TABLE `pondster_visitors` ADD `saving_enabled` integer DEFAULT 1 NOT NULL;--> statement-breakpoint
ALTER TABLE `pondster_visitors` ADD `preference_basis` text DEFAULT 'legacy_opt_in' NOT NULL;--> statement-breakpoint
CREATE INDEX `pondster_visitors_created` ON `pondster_visitors` (`created_at`);