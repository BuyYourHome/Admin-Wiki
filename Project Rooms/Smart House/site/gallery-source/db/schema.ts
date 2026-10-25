import { sqliteTable, text, integer, primaryKey, index, uniqueIndex } from 'drizzle-orm/sqlite-core';

export const designVotes = sqliteTable('design_votes', {
  room: text('room').notNull(),
  voterKey: text('voter_key').notNull(),
  designId: text('design_id').notNull(),
  updatedAt: integer('updated_at').notNull()
}, table => [primaryKey({ columns: [table.room, table.voterKey] })]);

export const pageComments = sqliteTable('page_comments', {
  id: text('id').primaryKey(),
  requestId: text('request_id').notNull(),
  page: text('page').notNull(),
  visitorKey: text('visitor_key').notNull(),
  name: text('name').notNull(),
  body: text('body').notNull(),
  createdAt: integer('created_at').notNull()
}, table => [
  uniqueIndex('page_comments_request_id_unique').on(table.requestId),
  index('page_comments_page_created_id').on(table.page, table.createdAt, table.id),
  index('page_comments_visitor_created').on(table.visitorKey, table.createdAt)
]);

export const voiceSessions = sqliteTable('voice_sessions', {
  requestId: text('request_id').primaryKey(),
  visitorKey: text('visitor_key').notNull(),
  providerId: text('provider_id'),
  createdAt: integer('created_at').notNull(),
  expiresAt: integer('expires_at').notNull(),
  state: text('state').notNull(),
  usageSeconds: integer('usage_seconds').notNull().default(0),
  finalUsageConfirmed: integer('final_usage_confirmed').notNull().default(0)
}, table => [
  index('voice_sessions_created').on(table.createdAt),
  index('voice_sessions_visitor_created').on(table.visitorKey, table.createdAt),
  index('voice_sessions_state').on(table.state)
]);
