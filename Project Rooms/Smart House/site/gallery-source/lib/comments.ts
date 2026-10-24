export const commentPages = ['design', 'explore', 'view', 'own', 'built-by'] as const;
export type CommentPage = typeof commentPages[number];
export type PublicComment = { id: string; page: string; name: string; body: string; createdAt: number };
export const COMMENT_PAGE_SIZE = 20;
export const COMMENT_COOLDOWN_MS = 30_000;
export const COMMENT_DAILY_LIMIT = 20;
export const COMMENT_DAY_MS = 86_400_000;

export function isCommentPage(page: unknown): page is CommentPage {
  return typeof page === 'string' && (commentPages as readonly string[]).includes(page);
}

export function validateComment(input: unknown) {
  if (!input || typeof input !== 'object' || Array.isArray(input)) return { error: 'Invalid comment.' } as const;
  const draft = input as Record<string, unknown>;
  if (!isCommentPage(draft.page)) return { error: 'Choose an available page.' } as const;
  if (typeof draft.requestId !== 'string' || !/^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/i.test(draft.requestId)) return { error: 'Please refresh the page before commenting.' } as const;
  if (draft.website !== undefined && (typeof draft.website !== 'string' || draft.website.trim())) return { error: 'Your comment could not be accepted.' } as const;
  if (draft.name !== undefined && typeof draft.name !== 'string') return { error: 'Use a name of up to 60 characters.' } as const;
  const name = (draft.name as string | undefined)?.trim() || 'Guest';
  if (name.length > 60 || /[\r\n\u0000-\u001f\u007f]/.test(name)) return { error: 'Use a name of up to 60 characters.' } as const;
  if (typeof draft.body !== 'string') return { error: 'Write a comment of 1 to 1,000 characters.' } as const;
  const body = draft.body.replace(/\r\n?/g, '\n').trim();
  if (!body.length || body.length > 1000 || /[\u0000-\u0008\u000b\u000c\u000e-\u001f\u007f]/.test(body)) return { error: 'Write a comment of 1 to 1,000 characters.' } as const;
  return { value: { page: draft.page, name, body, requestId: draft.requestId.toLowerCase() } } as const;
}

export function commentCursor(comment: Pick<PublicComment, 'id' | 'createdAt'>) {
  return `${comment.createdAt}.${comment.id}`;
}

export function parseCommentCursor(value: string) {
  const match = /^(\d{1,16})\.([a-f0-9]{32})$/.exec(value);
  if (!match) return null;
  const createdAt = Number(match[1]);
  return Number.isSafeInteger(createdAt) && createdAt > 0 ? { createdAt, id: match[2] } : null;
}
