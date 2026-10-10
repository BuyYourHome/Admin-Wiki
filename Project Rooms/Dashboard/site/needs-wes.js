(() => {
  const byId = id => document.getElementById(id);
  const status = byId("wesAttentionStatus");
  const refresh = byId("wesAttentionRefresh");
  const text = (tag, value, className) => {
    const node = document.createElement(tag);
    node.textContent = value;
    if (className) node.className = className;
    return node;
  };

  function renderGroups(target, items, decisions) {
    target.replaceChildren();
    const groups = new Map();
    items.forEach(item => {
      const room = item.destinationRoom || "Unassigned";
      if (!groups.has(room)) groups.set(room, []);
      groups.get(room).push(item);
    });
    [...groups.keys()].sort().forEach(room => {
      const section = document.createElement("details");
      section.open = room === "Email Monitor" && decisions;
      section.append(text("summary", `${room} (${groups.get(room).length})`));
      groups.get(room).forEach(item => {
        const row = document.createElement("article");
        row.className = "wes-request";
        row.append(text("h4", item.reference || item.messageId));
        row.append(text("p", `${item.state} | ${item.destinationMachine || "Machine unverified"} | Updated ${item.updatedAt || "unknown"}`, "wes-request-meta"));
        row.append(text("p", item.exactDecision || item.blocker || "Decision details unavailable."));
        row.append(text("p", item.nextAction || "Owning Project Room review required."));
        if (decisions) {
          const review = document.createElement("button");
          review.type = "button";
          review.textContent = "Review request";
          const detail = document.createElement("div");
          detail.hidden = true;
          detail.append(text("p", "Awaiting confirmation in the owning chat. No approval or send has been recorded."));
          const prompt = `Review central request ${item.messageId} in ${room} on ${item.destinationMachine || "its registered machine"}. Verify the current record and whether it is already resolved. Show the exact action, sender/recipients and attachment when applicable, and ask me a specific YES/NO question only if approval is genuinely required. Do not send, retry, or approve anything from this review request.`;
          const field = document.createElement("textarea");
          field.readOnly = true;
          field.value = prompt;
          field.setAttribute("aria-label", `Review request for ${item.messageId}`);
          detail.append(field);
          const copy = document.createElement("button");
          copy.type = "button";
          copy.textContent = "Copy review request";
          const outcome = text("p", "");
          outcome.setAttribute("role", "status");
          copy.addEventListener("click", async () => {
            try {
              await navigator.clipboard.writeText(prompt);
              outcome.textContent = `Copied. Awaiting review in ${room} on ${item.destinationMachine || "its registered machine"}.`;
            } catch {
              field.focus();
              field.select();
              outcome.textContent = "Clipboard unavailable. Request text selected; nothing was submitted.";
            }
          });
          detail.append(copy, outcome);
          review.setAttribute("aria-expanded", "false");
          review.addEventListener("click", () => {
            detail.hidden = !detail.hidden;
            review.setAttribute("aria-expanded", String(!detail.hidden));
          });
          row.append(review, detail);
        }
        section.append(row);
      });
      target.append(section);
    });
    if (!items.length) target.append(text("p", decisions ? "No pending decisions in the returned attention records." : "No blockers in the returned attention records."));
  }

  async function load() {
    refresh.disabled = true;
    status.textContent = "Checking current attention records...";
    byId("wesAttentionGroups").replaceChildren();
    byId("wesSystemGroups").replaceChildren();
    try {
      const response = await fetch("__dashboard-transaction-attention", { cache: "no-store", headers: { Accept: "application/json" } });
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      const data = await response.json();
      if (data.ok !== true || !Array.isArray(data.items)) throw new Error("Invalid attention response");
      const decisions = data.items.filter(item => item.classification === "wes-decision");
      const blockers = data.items.filter(item => item.classification !== "wes-decision");
      renderGroups(byId("wesAttentionGroups"), decisions, true);
      renderGroups(byId("wesSystemGroups"), blockers, false);
      byId("wesSystemSummary").textContent = `System and workflow blockers (${blockers.length})`;
      status.textContent = `${decisions.length} records marked Needs Wes | Snapshot ${data.generatedAtUtc || "time unavailable"}`;
    } catch (error) {
      status.textContent = `Requests unavailable: ${error.message}. Queue status is unknown, not empty.`;
      byId("wesSystemSummary").textContent = "System and workflow blockers (unavailable)";
    } finally {
      refresh.disabled = false;
    }
  }
  refresh.addEventListener("click", load);
  load();
})();
