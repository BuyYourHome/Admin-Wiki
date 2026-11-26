import { sqliteTable, text, integer, primaryKey, index, uniqueIndex } from 'drizzle-orm/sqlite-core';
import { sql } from 'drizzle-orm';

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
  rememberedFirstName:text('remembered_first_name'),
  firstSelfReportedName:text('first_self_reported_name'), firstSelfReportedAt:integer('first_self_reported_at'),
},table=>[index('pondster_conversations_visitor').on(table.visitorId,table.startedAt),index('pondster_conversations_expiry').on(table.expiresAt)]);
// Self-reported names are private labels, never verified identities or owner authority.
export const pondsterVisitorNameEvents = sqliteTable('pondster_visitor_name_events', {
  id:text('id').primaryKey(), requestId:text('request_id').notNull(), visitorId:text('visitor_id').notNull(),
  conversationId:text('conversation_id'), previousFirstName:text('previous_first_name'), firstName:text('first_name').notNull(),
  source:text('source').notNull(), createdAt:integer('created_at').notNull(), expiresAt:integer('expires_at').notNull(),
},table=>[
  uniqueIndex('pondster_name_events_visitor_request').on(table.visitorId,table.requestId),
  index('pondster_name_events_visitor_created').on(table.visitorId,table.createdAt),
  index('pondster_name_events_conversation_created').on(table.conversationId,table.createdAt),
  index('pondster_name_events_expiry').on(table.expiresAt),
]);
export const pondsterConversationEvents = sqliteTable('pondster_conversation_events', {
  conversationId:text('conversation_id').notNull(), eventId:text('event_id').notNull(),
  sequence:integer('sequence').notNull(), role:text('role').notNull(), text:text('text').notNull(),
  startMs:integer('start_ms'), endMs:integer('end_ms'), createdAt:integer('created_at').notNull(), expiresAt:integer('expires_at').notNull(),
},table=>[primaryKey({columns:[table.conversationId,table.eventId]}),index('pondster_events_expiry').on(table.expiresAt)]);

// Private immutable text-email revisions. No sender credentials or audio.
export const pondsterConversationEmails = sqliteTable('pondster_conversation_emails', {
  id:text('id').primaryKey(), conversationId:text('conversation_id').notNull(),
  maxSequence:integer('max_sequence').notNull(), bodyHash:text('body_hash').notNull(),
  subject:text('subject').notNull(), sender:text('sender').notNull(), recipient:text('recipient').notNull(),
  state:text('state').notNull(), isUpdate:integer('is_update').notNull(),
  chunkCount:integer('chunk_count').notNull(), bodyCharacters:integer('body_characters').notNull(),
  sourceLastAt:integer('source_last_at').notNull(), createdAt:integer('created_at').notNull(), expiresAt:integer('expires_at').notNull(),
  attemptToken:text('attempt_token'), attemptStartedAt:integer('attempt_started_at'),
  attemptCount:integer('attempt_count').notNull().default(0), lastErrorCode:text('last_error_code'),
  sentMessageId:text('sent_message_id'), sentAt:integer('sent_at'),
},table=>[
  uniqueIndex('pondster_email_revision').on(table.conversationId,table.maxSequence,table.bodyHash),
  uniqueIndex('pondster_email_one_pending').on(table.conversationId).where(sql`${table.state} IN ('ready','attempting','ambiguous')`),
  index('pondster_email_state_created').on(table.state,table.createdAt),
  index('pondster_email_expiry').on(table.expiresAt),
]);
export const pondsterConversationEmailChunks = sqliteTable('pondster_conversation_email_chunks', {
  emailId:text('email_id').notNull(), chunkIndex:integer('chunk_index').notNull(), body:text('body').notNull(), expiresAt:integer('expires_at').notNull(),
},table=>[primaryKey({columns:[table.emailId,table.chunkIndex]}),index('pondster_email_chunks_expiry').on(table.expiresAt)]);

// One atomic, sanitized public lighting revision; source identity/revision remain server-only.
export const lightingSourcePublication = sqliteTable('lighting_source_publication', {
  id: text('id').primaryKey(),
  revision: text('revision').notNull(), publicJson: text('public_json').notNull(),
  sourceDriveId: text('source_drive_id').notNull(), sourceItemId: text('source_item_id').notNull(),
  sourceEtag: text('source_etag').notNull(), sourceModifiedAt: text('source_modified_at'),
  publishedAt: text('published_at').notNull(), lastCheckedAt: text('last_checked_at').notNull(),
  lastSuccessAt: text('last_success_at').notNull(), syncStatus: text('sync_status').notNull(),
  lastErrorCode: text('last_error_code'),
});
