export type VoteCount = { id: string; votes: number };
export type VisibleVoteResults = { scores: Record<string, number>; total: number; selected: string | null };

/** Hide retired choices from public results without modifying stored preferences. */
export function visibleVotes(rows: readonly VoteCount[], selected: string | null, activeDesignIds: readonly string[]): VisibleVoteResults {
  const active = new Set(activeDesignIds);
  const visible = rows.filter(row => active.has(row.id));
  return {
    scores: Object.fromEntries(visible.map(row => [row.id, row.votes])),
    total: visible.reduce((total, row) => total + row.votes, 0),
    selected: selected !== null && active.has(selected) ? selected : null
  };
}
