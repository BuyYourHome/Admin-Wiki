(() => {
  const rooms = Array.isArray(window.PROJECT_ROOMS) ? window.PROJECT_ROOMS : [];
  const groupDefinitions = Array.isArray(window.PROJECT_ROOM_GROUPS) ? window.PROJECT_ROOM_GROUPS : [];
  const dashboardActions = window.DASHBOARD_ACTIONS || {};
  const dashboardContext = window.DASHBOARD_CONTEXT || {
    hostMode: "local-full",
    clientAccess: "local",
    readOnly: false,
    allowAskJean: true,
    allowHostActions: true
  };
  const groupOrder = groupDefinitions.map(group => group.name);
  const state = { group: "All", query: "", view: "grid", selected: null, selectedRoom: null, sopGroup: "All", visibleSopEntries: [] };
  const el = id => document.getElementById(id);
  const initials = name => name.split(/\s+/).filter(Boolean).slice(0, 2).map(word => word[0]).join("").toUpperCase();
  const attentionLabel = attention => attention?.type === "approval-needed" ? "Approval needed" : "Confirmation needed";
  const isExternalHref = href => /^[a-z][a-z0-9+.-]*:/i.test(href || "");
  const filteredRooms = () => {
    const query = state.query.trim().toLowerCase();
    return rooms.filter(room => {
      const groupMatch = state.group === "All" || room.group === state.group;
      const haystack = [room.name, room.purpose, room.status, room.skill, room.group].join(" ").toLowerCase();
      return groupMatch && (!query || haystack.includes(query));
    });
  };
  async function refreshDashboard() {
    if (!dashboardContext.allowHostActions) {
      el("refreshStatus").textContent = "Refresh is disabled in this read-only Dashboard host view.";
      return;
    }
    const button = el("refreshDashboardButton");
    const status = el("refreshStatus");
    button.disabled = true;
    status.textContent = "Refreshing local Project Room data...";
    try {
      const response = await fetch("__dashboard-refresh", { method: "POST", headers: { Accept: "application/json" } });
      const result = await response.json().catch(() => ({}));
      if (!response.ok || result.ok !== true) throw new Error(result.message || `Local refresh failed (${response.status}).`);
      sessionStorage.setItem("dashboardRefreshStatus", result.message || "Local Project Room data refreshed.");
      window.location.reload();
    } catch (error) {
      status.textContent = `Refresh unavailable: ${error.message}. Start Dashboard with its local launch tool, then try again.`;
      button.disabled = false;
    }
  }
  function renderFilters() {
    const groups = groupOrder.filter(group => rooms.some(room => room.group === group));
    el("filters").replaceChildren(...["All", ...groups].map(group => {
      const button = document.createElement("button");
      button.type = "button";
      button.className = `filter-button${state.group === group ? " active" : ""}`;
      button.textContent = group;
      button.addEventListener("click", () => { state.group = group; render(); });
      return button;
    }));
  }
  function getVisibleSopEntries(room) {
    const entries = Array.isArray(room?.sopEntries) ? room.sopEntries : [];
    return entries.filter(entry => state.sopGroup === "All" || entry.category === state.sopGroup);
  }

  function renderSopViewer(room) {
    const sopEntries = Array.isArray(room?.sopEntries) ? room.sopEntries : [];
    const sopViewer = el("detailSopViewer");
    sopViewer.hidden = room?.name !== "SOPs";
    if (room?.name !== "SOPs") {
      state.visibleSopEntries = [];
      return;
    }

    const categories = [...new Set(sopEntries.map(entry => entry.category).filter(Boolean))];
    const groupSelect = el("detailSopGroupSelect");
    groupSelect.replaceChildren(...["All", ...categories].map(group => {
      const option = document.createElement("option");
      option.value = group;
      option.textContent = group;
      return option;
    }));
    if (!["All", ...categories].includes(state.sopGroup)) {
      state.sopGroup = "All";
    }
    groupSelect.value = state.sopGroup;
    groupSelect.disabled = sopEntries.length === 0;

    const visibleEntries = getVisibleSopEntries(room);
    state.visibleSopEntries = visibleEntries;
    const prompt = document.createElement("option");
    prompt.value = "";
    prompt.textContent = visibleEntries.length ? "Select a documented SOP page" : "No documented SOP pages match this group";
    prompt.selected = true;
    el("detailSopSelect").replaceChildren(prompt, ...visibleEntries.map((entry, index) => {
      const option = document.createElement("option");
      option.value = String(index);
      option.textContent = entry.label;
      return option;
    }));
    el("detailSopSelect").disabled = visibleEntries.length === 0;
    el("detailSopOpen").removeAttribute("href");
    el("detailSopOpen").classList.add("disabled");
    el("detailSopOpen").setAttribute("aria-disabled", "true");
    el("detailSopState").textContent = visibleEntries.length
      ? "Only canonical clean SOP pages are shown. Choose a group to narrow the list."
      : "No documented SOP Markdown pages are available for the selected group.";
  }

  function selectRoom(room) {
    state.selected = room.name;
    state.selectedRoom = room;
    el("detailName").textContent = room.name;
    el("detailPurpose").textContent = room.purpose;
    el("detailGroupSelect").replaceChildren(...groupDefinitions.map(group => {
      const option = document.createElement("option");
      option.value = group.name;
      option.textContent = group.name;
      return option;
    }));
    el("detailGroupSelect").value = room.group;
    el("detailGroupBasis").textContent = room.groupBasis || "No group basis recorded.";
    el("detailGroupState").textContent = "Current documented assignment. Changes are preview only and are not saved.";
    el("detailStatus").textContent = room.status;
    el("detailSkill").textContent = room.skill || "No matching skill recorded";
    const modes = Array.isArray(room.modes) ? room.modes : [];
    const modePrompt = document.createElement("option");
    modePrompt.value = "";
    modePrompt.textContent = modes.length ? "Select a documented mode" : "No documented modes found";
    modePrompt.selected = true;
    el("detailModeSelect").replaceChildren(modePrompt, ...modes.map(mode => {
      const option = document.createElement("option");
      option.value = mode;
      option.textContent = mode;
      return option;
    }));
    el("detailModeSelect").disabled = modes.length === 0;
    el("detailModeState").textContent = modes.length ? "Selection is for interface review only; it does not activate a mode." : "No canonical documented modes were found in this room's README or matching skill.";
    state.sopGroup = "All";
    renderSopViewer(room);
    const actions = [
      { label: "Open Project Room README", href: room.readmeUrl },
      ...(Array.isArray(room.quickActions) ? room.quickActions : [])
    ].filter(action => !dashboardContext.readOnly || !isExternalHref(action.href));
    const actionElements = actions.map(action => {
      const link = document.createElement("a");
      link.className = "quick-action-link";
      link.href = action.href;
      link.target = "_blank";
      link.rel = "noopener";
      link.textContent = action.label;
      return link;
    });
    if (actions.length < 2) {
      const slot = document.createElement("button");
      slot.type = "button";
      slot.className = "quick-action-slot";
      slot.disabled = true;
      slot.textContent = "Future action available";
      slot.title = "No action has been assigned to this slot.";
      actionElements.push(slot);
    }
    el("detailActionList").replaceChildren(...actionElements);
    const attention = room.attention;
    const existingAttention = document.getElementById("detailAttention");
    if (attention) {
      existingAttention.hidden = false;
      existingAttention.className = `detail-attention ${attention.type}`;
      existingAttention.textContent = `${attentionLabel(attention)}: ${attention.reason}`;
      existingAttention.title = `Source: ${attention.source}${attention.updatedAt ? `; updated ${attention.updatedAt}` : ""}`;
    } else if (dashboardContext.readOnly) {
      existingAttention.hidden = false;
      existingAttention.className = "detail-attention read-only-note";
      existingAttention.textContent = dashboardContext.clientAccess === "remote"
        ? "Read-only LAN view: host-only actions are disabled for remote clients."
        : "LAN host mode: read-only document view. Use WesStudio local Dashboard tools for refresh or host changes.";
      existingAttention.title = "This Dashboard host serves read-only LAN access only.";
    } else {
      existingAttention.hidden = true;
      existingAttention.textContent = "";
    }
    renderCards();
  }

  function applyDashboardContext() {
    const askJean = el("askJeanButton");
    if (!dashboardContext.allowAskJean) {
      askJean.removeAttribute("href");
      askJean.classList.add("disabled");
      askJean.setAttribute("aria-disabled", "true");
      askJean.title = "Ask Jean is available only on the host machine.";
    }

    if (!dashboardContext.allowHostActions) {
      const refreshButton = el("refreshDashboardButton");
      refreshButton.disabled = true;
      refreshButton.title = "Refresh is disabled in the LAN read-only host view.";
      const deleteButton = el("requestDeleteButton");
      deleteButton.disabled = true;
      deleteButton.title = "Deletion workflow preview is disabled in the LAN read-only host view.";
      if (!el("refreshStatus").textContent) {
        el("refreshStatus").textContent = dashboardContext.clientAccess === "remote"
          ? "Read-only LAN view. Refresh, deletion review, and host-only links are disabled."
          : "LAN host mode is running. Use the local Dashboard launch tools on WesStudio for refresh and host changes.";
      }
    }
  }

  function openDeleteRequest() {
    const room = state.selectedRoom;
    if (!room) return;
    el("deleteRoomName").textContent = room.name;
    const scope = [
      { label: "Project Room folder", value: `C:\\Codex\\Wiki Files\\Project Rooms\\${room.name}`, state: "included" },
      { label: "Dashboard card", value: "Removed automatically after the Project Room folder is removed and Dashboard is refreshed.", state: "derived" },
      room.skill
        ? { label: "Matching skill", value: room.skillState === "available" ? room.skillPath : `${room.skillPath || room.skill} (source not available)`, state: room.skillState === "available" ? "included" : "unresolved" }
        : { label: "Matching skill", value: "No matching skill is documented. No skill deletion is proposed.", state: "not-applicable" },
      room.taskId
        ? { label: "Associated task/chat", value: `${room.taskId} (task deletion capability is not currently available)`, state: "unresolved" }
        : { label: "Associated task/chat", value: "No task/chat id is documented. No task deletion is proposed.", state: "not-applicable" }
    ];
    el("deleteScopeList").replaceChildren(...scope.map(item => {
      const entry = document.createElement("li");
      entry.className = `scope-${item.state}`;
      const label = document.createElement("strong");
      label.textContent = item.label;
      const value = document.createElement("span");
      value.textContent = item.value;
      entry.append(label, value);
      return entry;
    }));
    el("preparedRequest").hidden = true;
    el("downloadDeleteRecordButton").hidden = true;
    el("deleteDialog").showModal();
    el("prepareDeleteButton").focus();
  }

  function prepareDeleteRequest() {
    const room = state.selectedRoom;
    if (!room) return;
    const taskState = room.taskId
      ? "BLOCKED: A task/chat is documented, but Codex currently exposes archiving rather than task deletion. Do not substitute archive for deletion without Wes's separate authorization."
      : "No task/chat id is documented, so no task deletion is included in the proposed scope.";
    const skillState = room.skill
      ? (room.skillState === "available" ? `Matching skill included: ${room.skillPath}` : `BLOCKED: Matching skill ${room.skillPath || room.skill} is not available for verified deletion.`)
      : "No matching skill is documented, so no skill deletion is included in the proposed scope.";
    const plan = {
      record_type: "dashboard-project-room-deletion-plan",
      created_at: new Date().toISOString(),
      confirmation: `One explicit Dashboard confirmation for ${room.name}; no deletion was executed by this interface.`,
      project_room: { name: room.name, path: `C:\\Codex\\Wiki Files\\Project Rooms\\${room.name}` },
      dashboard_entry: "Derived from the Project Room folder and removed by the next Dashboard refresh only after authorized folder deletion.",
      matching_skill: room.skill ? { name: room.skill, path: room.skillPath || null, state: room.skillState } : null,
      associated_task: room.taskId ? { id: room.taskId, state: "unavailable: no task-delete capability exposed" } : null,
      limits: [
        "Do not delete, archive, hide, rename, move, edit a registry, alter an automation, or change an installed skill from this interface.",
        "Do not extend the scope beyond the selected Project Room, its documented matching skill, and its documented task/chat.",
        "Before any future execution, append this plan and final results to C:\\Codex\\Wiki Files\\Project Rooms\\Dashboard\\working\\project-room-deletion-log.md outside the selected Project Room.",
        "If any included resource is unresolved or unavailable, stop without partial deletion and report the blocker to Wes."
      ],
      execution_state: "planned only; no deletion executed"
    };
    state.deletionPlan = plan;
    el("deleteRequestText").value = JSON.stringify(plan, null, 2);
    el("deletePlanState").textContent = `${taskState} ${skillState} This plan is an auditable preview only; no resource was altered.`;
    el("preparedRequest").hidden = false;
    el("downloadDeleteRecordButton").hidden = false;
  }

  function downloadDeleteRecord() {
    if (!state.deletionPlan) return;
    const content = `${JSON.stringify(state.deletionPlan, null, 2)}\n`;
    const href = URL.createObjectURL(new Blob([content], { type: "application/json" }));
    const link = document.createElement("a");
    link.href = href;
    link.download = `dashboard-deletion-plan-${state.deletionPlan.project_room.name.replace(/[^a-z0-9]+/gi, "-").replace(/^-|-$/g, "").toLowerCase()}.json`;
    link.click();
    URL.revokeObjectURL(href);
  }
  function renderCards() {
    const visible = filteredRooms();
    const grid = el("roomGrid");
    grid.className = `room-grid${state.view === "list" ? " list" : ""}`;
    grid.replaceChildren(...visible.map(room => {
      const card = document.createElement("button");
      card.type = "button";
      card.className = `room-card${state.selected === room.name ? " selected" : ""}`;
      card.innerHTML = `<div class="card-top"><span class="room-mark">${initials(room.name)}</span><div class="card-heading"><h3></h3></div></div><p></p><div class="card-meta"><span class="status-dot"></span><span></span></div>`;
      card.querySelector("h3").textContent = room.name;
      if (room.attention) {
        const badge = document.createElement("span");
        badge.className = `attention-badge ${room.attention.type}`;
        badge.textContent = attentionLabel(room.attention);
        badge.title = `${room.attention.reason} Source: ${room.attention.source}${room.attention.updatedAt ? `; updated ${room.attention.updatedAt}` : ""}`;
        card.querySelector(".card-heading").prepend(badge);
      }
      card.querySelector("p").textContent = room.purpose;
      card.querySelector(".status-dot").textContent = room.status;
      card.querySelector(".card-meta span:last-child").textContent = room.skill || "No skill";
      card.addEventListener("click", () => selectRoom(room));
      return card;
    }));
    el("resultCount").textContent = `${visible.length} ${visible.length === 1 ? "room" : "rooms"}`;
    el("resultsTitle").textContent = state.group === "All" ? "All Project Rooms" : state.group;
    el("emptyState").hidden = visible.length !== 0;
  }
  function render() { renderFilters(); renderCards(); }
  el("roomCount").textContent = rooms.length;
  el("activeCount").textContent = rooms.filter(room => room.status.toLowerCase().includes("active")).length;
  el("skillCount").textContent = rooms.filter(room => room.skill).length;
  el("groupCount").textContent = new Set(rooms.map(room => room.group)).size;
  el("updatedAt").textContent = window.PROJECT_ROOMS_UPDATED ? `Index refreshed ${window.PROJECT_ROOMS_UPDATED}` : "Local index";
  const priorRefreshStatus = sessionStorage.getItem("dashboardRefreshStatus");
  if (priorRefreshStatus) {
    el("refreshStatus").textContent = priorRefreshStatus;
    sessionStorage.removeItem("dashboardRefreshStatus");
  }
  applyDashboardContext();
  el("searchInput").addEventListener("input", event => { state.query = event.target.value; renderCards(); });
  el("askJeanButton").href = dashboardActions.jeansVoice?.href || "#";
  el("refreshDashboardButton").addEventListener("click", refreshDashboard);
  el("requestDeleteButton").addEventListener("click", openDeleteRequest);
  el("prepareDeleteButton").addEventListener("click", prepareDeleteRequest);
  el("downloadDeleteRecordButton").addEventListener("click", downloadDeleteRecord);
  el("detailModeSelect").addEventListener("change", event => {
    el("detailModeState").textContent = event.target.value ? `Selected for interface review: ${event.target.value}. No mode was activated.` : "Selection does not activate a mode.";
  });
  el("detailSopSelect").addEventListener("change", event => {
    const entry = state.visibleSopEntries?.[Number(event.target.value)];
    const viewer = el("detailSopOpen");
    if (entry?.href) {
      viewer.href = entry.href;
      viewer.classList.remove("disabled");
      viewer.setAttribute("aria-disabled", "false");
      el("detailSopState").textContent = "Opens the canonical clean SOP page in a separate browser tab or window.";
    } else if (entry) {
      viewer.removeAttribute("href");
      viewer.classList.add("disabled");
      viewer.setAttribute("aria-disabled", "true");
      el("detailSopState").textContent = "This index entry has no matching clean SOP page yet, so there is nothing safe to open.";
    }
  });
  el("detailSopGroupSelect").addEventListener("change", event => {
    state.sopGroup = event.target.value || "All";
    if (state.selectedRoom?.name === "SOPs") {
      renderSopViewer(state.selectedRoom);
    }
  });
  el("detailGroupSelect").addEventListener("change", event => {
    const preview = groupDefinitions.find(group => group.name === event.target.value);
    el("detailGroupBasis").textContent = preview?.basis || "No group basis recorded.";
    el("detailGroupState").textContent = `Preview only. ${state.selectedRoom?.name || "This room"} remains assigned to ${state.selectedRoom?.group || "its documented group"}.`;
  });
  document.querySelectorAll(".view-button").forEach(button => button.addEventListener("click", () => {
    state.view = button.dataset.view;
    document.querySelectorAll(".view-button").forEach(item => item.classList.toggle("active", item === button));
    renderCards();
  }));
  render();
  if (rooms.length) selectRoom(rooms[0]);
})();
