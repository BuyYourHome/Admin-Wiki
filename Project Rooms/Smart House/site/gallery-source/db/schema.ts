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

// Private text history with a browser opt-out. No public reader or audio storage.
export const pondsterVisitors = sqliteTable('pondster_visitors', {
  id:text('id').primaryKey(), firstName:text('first_name'),
  consentAt:integer('consent_at').notNull(), introducedAt:integer('introduced_at'),
  createdAt:integer('created_at').notNull().default(0),
  savingEnabled:integer('saving_enabled').notNull().default(1),
  preferenceBasis:text('preference_basis').notNull().default('legacy_opt_in'),
  expiresAt:integer('expires_at').notNull(),
}, table=>[index('pondster_visitors_expiry').on(table.expiresAt),index('pondster_visitors_created').on(table.createdAt)]);
export const pondsterConversations = sqliteTable('pondster_conversations', {
  id:text('id').primaryKey(), visitorId:text('visitor_id').notNull(), mode:text('mode').notNull(),
  startedAt:integer('started_at').notNull(), endedAt:integer('ended_at'), expiresAt:integer('expires_at').notNull(),
},table=>[index('pondster_conversations_visitor').on(table.visitorId,table.startedAt),index('pondster_conversations_expiry').on(table.expiresAt)]);
export const pondsterConversationEvents = sqliteTable('pondster_conversation_events', {
  conversationId:text('conversation_id').notNull(), eventId:text('event_id').notNull(),
  sequence:integer('sequence').notNull(), role:text('role').notNull(), text:text('text').notNull(),
  startMs:integer('start_ms'), endMs:integer('end_ms'), createdAt:integer('created_at').notNull(), expiresAt:integer('expires_at').notNull(),
},table=>[primaryKey({columns:[table.conversationId,table.eventId]}),index('pondster_events_expiry').on(table.expiresAt)]);
