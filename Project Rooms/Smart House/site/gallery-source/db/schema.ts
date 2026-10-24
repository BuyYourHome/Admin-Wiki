import { sqliteTable, text, integer, primaryKey } from 'drizzle-orm/sqlite-core';

export const designVotes = sqliteTable('design_votes', {
  room: text('room').notNull(),
  voterKey: text('voter_key').notNull(),
  designId: text('design_id').notNull(),
  updatedAt: integer('updated_at').notNull()
}, table => [primaryKey({ columns: [table.room, table.voterKey] })]);
