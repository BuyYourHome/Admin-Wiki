(() => {
  const rooms = Array.isArray(window.PROJECT_ROOMS) ? window.PROJECT_ROOMS : [];
  const groupDefinitions = Array.isArray(window.PROJECT_ROOM_GROUPS) ? window.PROJECT_ROOM_GROUPS : [];
  const dashboardActions = window.DASHBOARD_ACTIONS || {};
  const modeActions = dashboardActions.modeActions || {};
  const modePanels = dashboardActions.modePanels || {};
  const dashboardContext = window.DASHBOARD_CONTEXT || {
    hostMode: "local-full",
    clientAccess: "local",
    readOnly: false,
    allowAskJean: true,
    allowHostActions: true
  };
  const groupOrder = groupDefinitions.map(group => group.name);
  const state = { group: "All", query: "", view: "grid", selected: null, selectedRoom: null, selectedMode: "", selectedManagerTaskId: "", managerTaskUpdatePending: false, sopGroup: "All", visibleSopEntries: [] };
  const el = id => document.getElementById(id);
  const initials = name => name.split(/\s+/).filter(Boolean).slice(0, 2).map(word => word[0]).join("").toUpperCase();
  const attentionLabel = attention => attention?.type === "approval-needed" ? "Approval needed" : "Confirmation needed";
  const isExternalHref = href => /^[a-z][a-z0-9+.-]*:/i.test(href || "");
  const getModeAction = (roomName, modeName) => modeActions?.[roomName]?.[modeName] || null;
  const getModePanel = (roomName, modeName) => modePanels?.[roomName]?.[modeName] || null;
  const controlAvailable = availability => availability !== "local-only" || dashboardContext.clientAccess === "local";
  const canEditManagerTasks = () => dashboardContext.hostMode === "local-full" && dashboardContext.clientAccess === "local" && !dashboardContext.readOnly;
  const managerPriorityRank = { Critical: 0, High: 1, Normal: 2, Low: 3 };
  const managerStatuses = ["New", "Delivered", "Acknowledged", "In Progress", "Waiting", "Completed", "Cancelled"];
  const managerOpenStatuses = new Set(managerStatuses.filter(status => !["Completed", "Cancelled"].includes(status)));
  const deletionPreviewAllowed = () => !dashboardContext.readOnly || dashboardContext.clientAccess === "local";
  const parseTime = value => {
    const timestamp = Date.parse(value || "");
    return Number.isNaN(timestamp) ? null : timestamp;
  };
  const filteredRooms = () => {
    const query = state.query.trim().toLowerCase();
    return rooms.filter(room => {
      const groupMatch = state.group === "All" || room.group === state.group;
      const haystack = [room.name, room.purpose, room.status, room.skill, room.group].join(" ").toLowerCase();
      return groupMatch && (!query || haystack.includes(query));
    });
  };
  const getManagerTasks = room => Array.isArray(room?.managerTasks) ? room.managerTasks.slice() : [];
  const getOpenManagerTasks = room => getManagerTasks(room)
    .filter(task => managerOpenStatuses.has(task.status))
    .sort((left, right) => {
      const priorityDelta = (managerPriorityRank[left.priority] ?? 99) - (managerPriorityRank[right.priority] ?? 99);
      if (priorityDelta !== 0) return priorityDelta;
      const leftDue = parseTime(left.due);
      const rightDue = parseTime(right.due);
      if (leftDue !== rightDue) {
        if (leftDue === null) return 1;
        if (rightDue === null) return -1;
        return leftDue - rightDue;
      }
      const leftUpdated = parseTime(left.lastUpdated) ?? 0;
      const rightUpdated = parseTime(right.lastUpdated) ?? 0;
      return rightUpdated - leftUpdated;
    });
  const findRoom = roomName => rooms.find(room => room.name === roomName) || null;
  function syncSelectedManagerTask(room) {
    const openTasks = getOpenManagerTasks(room);
    if (!openTasks.length) {
      state.selectedManagerTaskId = "";
      return null;
    }
    if (!openTasks.some(task => task.taskId === state.selectedManagerTaskId)) {
      state.selectedManagerTaskId = openTasks[0].taskId;
    }
    return openTasks.find(task => task.taskId === state.selectedManagerTaskId) || openTasks[0];
  }
  async function updateManagerTaskStatus(taskId, status) {
    if (!canEditManagerTasks()) {
      el("detailModeState").textContent = "Manager task status changes are available only from the full local Dashboard.";
      return;
    }
    state.managerTaskUpdatePending = true;
    renderModePanel(state.selectedRoom, getModePanel(state.selectedRoom?.name, state.selectedMode));
    try {
      const response = await fetch("__dashboard-manager-task-status", {
        method: "POST",
        headers: { "Content-Type": "application/json", Accept: "application/json" },
        body: JSON.stringify({ taskId, status })
      });
      const result = await response.json().catch(() => ({}));
      if (!response.ok || result.ok !== true) throw new Error(result.message || `Manager task update failed (${response.status}).`);
      const applyUpdate = room => {
        if (!room || !Array.isArray(room.managerTasks)) return;
        room.managerTasks = room.managerTasks.map(task => task.taskId === taskId
          ? { ...task, status: result.status, lastUpdated: result.lastUpdated }
          : task);
      };
      applyUpdate(findRoom("Manager"));
      applyUpdate(state.selectedRoom);
      el("refreshStatus").textContent = result.message || `Manager task ${taskId} updated.`;
      el("detailModeState").textContent = `Manager task ${taskId} updated to ${result.status}.`;
    } catch (error) {
      el("detailModeState").textContent = `Manager task update failed: ${error.message}`;
    } finally {
      state.managerTaskUpdatePending = false;
      renderModePanel(state.selectedRoom, getModePanel(state.selectedRoom?.name, state.selectedMode));
    }
  }
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

  function clearSelection() {
    state.selected = null;
    state.selectedRoom = null;
    state.selectedMode = "";
    state.selectedManagerTaskId = "";
    state.sopGroup = "All";
    state.visibleSopEntries = [];
    el("detailPanel").hidden = true;
    el("detailName").textContent = "Choose a room";
    el("detailPurpose").textContent = "Select a Project Room to see its responsibility, status, skill, and canonical path.";
    el("detailAttention").hidden = true;
    el("detailAttention").textContent = "";
    el("detailModeSelect").replaceChildren();
    el("detailModeSelect").disabled = true;
    el("detailModeState").textContent = "Choose a Project Room first.";
    el("detailModePanel").hidden = true;
    el("detailModePanelTitle").textContent = "Mode panel";
    el("detailModePanelIntro").textContent = "";
    el("detailModePanelControls").replaceChildren();
    el("detailActionList").replaceChildren();
    el("detailGroupSelect").replaceChildren();
    el("detailGroupSelect").disabled = true;
    el("detailGroupBasis").textContent = "-";
    el("detailGroupState").textContent = "Current documented assignment. Changes are preview only.";
    el("detailStatus").textContent = "-";
    el("detailSkill").textContent = "-";
    el("requestDeleteButton").disabled = true;
    el("requestDeleteButton").title = "Select a Project Room first.";
    renderSopViewer(null);
  }

  function selectRoom(room) {
    state.selected = room.name;
    state.selectedRoom = room;
    state.selectedMode = "";
    state.selectedManagerTaskId = "";
    el("detailPanel").hidden = false;
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
    el("detailModeState").textContent = modes.length
      ? "Selecting a documented mode can either load a mode-specific helper panel or run its keyed Dashboard action."
      : "No canonical documented modes were found in this room's README or matching skill.";
    renderModePanel(null, null);
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
    el("detailGroupSelect").disabled = false;
    el("requestDeleteButton").disabled = !deletionPreviewAllowed();
    el("requestDeleteButton").title = deletionPreviewAllowed()
      ? "Shows the exact deletion scope and asks for one explicit confirmation. This local interface does not delete anything yet."
      : "Deletion workflow preview is disabled in the LAN read-only host view.";
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
      deleteButton.disabled = !deletionPreviewAllowed();
      deleteButton.title = deletionPreviewAllowed()
        ? "Deletion workflow preview remains available on the host machine. No deletion is executed here."
        : "Deletion workflow preview is disabled in the LAN read-only host view.";
      if (!el("refreshStatus").textContent) {
        el("refreshStatus").textContent = dashboardContext.clientAccess === "remote"
          ? "Read-only LAN view. Refresh, deletion review, and host-only links are disabled."
          : "LAN host mode is running. Refresh stays disabled here, but local deletion preview remains available on WesStudio.";
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

  function renderModePanel(room, panel) {
    const section = el("detailModePanel");
    if (!panel) {
      section.hidden = true;
      el("detailModePanelTitle").textContent = "Mode panel";
      el("detailModePanelIntro").textContent = "";
      el("detailModePanelControls").replaceChildren();
      return;
    }

    section.hidden = false;
    el("detailModePanelTitle").textContent = panel.title || "Mode panel";
    el("detailModePanelIntro").textContent = panel.intro || "";
    const selectedManagerTask = room?.name === "Manager" ? syncSelectedManagerTask(room) : null;

    const controlElements = (Array.isArray(panel.controls) ? panel.controls : []).map(control => {
      if (control.type === "task-list") {
        const card = document.createElement("div");
        card.className = "mode-panel-card task-list-card";
        const label = document.createElement("strong");
        label.textContent = control.label || "Tasks";
        const helper = document.createElement("p");
        const openTasks = getOpenManagerTasks(room);
        helper.textContent = openTasks.length
          ? `${openTasks.length} open Manager ${openTasks.length === 1 ? "task is" : "tasks are"} currently recorded.`
          : (control.emptyText || "No open tasks are currently recorded.");
        const list = document.createElement("div");
        list.className = "manager-task-list";
        if (!openTasks.length) {
          const empty = document.createElement("p");
          empty.className = "manager-task-empty";
          empty.textContent = control.emptyText || "No open tasks are currently recorded.";
          list.append(empty);
        } else {
          openTasks.forEach(task => {
            const button = document.createElement("button");
            button.type = "button";
            button.className = `manager-task-item${task.taskId === state.selectedManagerTaskId ? " selected" : ""}`;
            button.addEventListener("click", () => {
              state.selectedManagerTaskId = task.taskId;
              renderModePanel(room, panel);
            });
            const title = document.createElement("span");
            title.className = "manager-task-title";
            title.textContent = `${task.taskId} - ${task.task}`;
            const meta = document.createElement("span");
            meta.className = "manager-task-meta";
            const dueText = task.due ? `Due ${task.due}` : "No due date";
            meta.textContent = `${task.priority} | ${task.status} | ${dueText}`;
            button.append(title, meta);
            list.append(button);
          });
        }
        card.append(label, helper, list);
        return card;
      }

      if (control.type === "task-status-editor") {
        const card = document.createElement("div");
        card.className = "mode-panel-card task-editor-card";
        const label = document.createElement("strong");
        label.textContent = control.label || "Update task";
        const note = document.createElement("p");
        const available = canEditManagerTasks();
        note.textContent = available
          ? (selectedManagerTask ? `Selected task: ${selectedManagerTask.taskId}` : "Select an open Manager task to change its status.")
          : (control.description || "This control is available only from the full local Dashboard.");
        card.append(label, note);
        if (!available) {
          card.classList.add("disabled");
          return card;
        }
        if (!selectedManagerTask) {
          return card;
        }
        const summary = document.createElement("p");
        summary.className = "manager-task-summary";
        summary.textContent = selectedManagerTask.task;
        const editor = document.createElement("div");
        editor.className = "manager-task-editor";
        const select = document.createElement("select");
        select.id = "managerTaskStatusSelect";
        managerStatuses.forEach(status => {
          const option = document.createElement("option");
          option.value = status;
          option.textContent = status;
          option.selected = selectedManagerTask.status === status;
          select.append(option);
        });
        select.disabled = state.managerTaskUpdatePending;
        const button = document.createElement("button");
        button.type = "button";
        button.className = "primary-button";
        button.textContent = state.managerTaskUpdatePending ? "Saving..." : "Save status";
        button.disabled = state.managerTaskUpdatePending;
        button.addEventListener("click", () => updateManagerTaskStatus(selectedManagerTask.taskId, select.value));
        editor.append(select, button);
        card.append(summary, editor);
        return card;
      }

      if (control.type === "open-url") {
        const link = document.createElement("a");
        const available = controlAvailable(control.availability || "local-only");
        link.className = `quick-action-link mode-panel-link${available ? "" : " disabled"}`;
        link.textContent = control.label || "Open";
        if (available && control.href) {
          link.href = control.href;
          link.target = "_blank";
          link.rel = "noopener";
          link.title = control.description || "";
        } else {
          link.removeAttribute("href");
          link.setAttribute("aria-disabled", "true");
          link.title = control.description || "This control is available only on the host machine.";
        }
        return link;
      }

      if (control.type === "template") {
        const card = document.createElement("div");
        card.className = "mode-panel-card";
        const label = document.createElement("strong");
        label.textContent = control.label || "Template";
        const template = document.createElement("pre");
        template.className = "mode-panel-template";
        template.textContent = control.text || "";
        card.append(label, template);
        return card;
      }

      const card = document.createElement("div");
      card.className = "mode-panel-card";
      const label = document.createElement("strong");
      label.textContent = control.label || "Note";
      const text = document.createElement("p");
      text.textContent = control.text || "";
      card.append(label, text);
      return card;
    });

    el("detailModePanelControls").replaceChildren(...controlElements);
  }

  function invokeModeAction(room, modeName) {
    const action = getModeAction(room?.name, modeName);
    if (!action) {
      el("detailModeState").textContent = `No Dashboard action is keyed for ${modeName}.`;
      return;
    }
    if ((action.type || "open-url") !== "open-url") {
      el("detailModeState").textContent = `Mode action ${action.type} is not supported by this Dashboard yet.`;
      return;
    }
    if (!action.href) {
      el("detailModeState").textContent = `Mode action for ${modeName} is missing its target.`;
      return;
    }
    if (dashboardContext.readOnly && isExternalHref(action.href)) {
      el("detailModeState").textContent = `Mode action for ${modeName} is disabled in the read-only LAN view because it targets an external location.`;
      return;
    }
    const openedWindow = window.open(action.href, action.target || "_blank", "noopener");
    if (openedWindow) {
      openedWindow.opener = null;
      el("detailModeState").textContent = action.label || `Opened ${modeName}.`;
      return;
    }
    el("detailModeState").textContent = `${action.label || modeName} was triggered, but the browser blocked the new tab or window.`;
  }

  function renderCards() {
    const visible = filteredRooms();
    if (state.selected && !visible.some(room => room.name === state.selected)) {
      clearSelection();
    }
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
  function syncSearchQuery(event) {
    state.query = event.target.value;
    renderCards();
  }
  applyDashboardContext();
  ["input", "search", "change", "keyup"].forEach(eventName => {
    el("searchInput").addEventListener(eventName, syncSearchQuery);
  });
  el("askJeanButton").href = dashboardActions.jeansVoice?.href || "#";
  el("refreshDashboardButton").addEventListener("click", refreshDashboard);
  el("requestDeleteButton").addEventListener("click", openDeleteRequest);
  el("prepareDeleteButton").addEventListener("click", prepareDeleteRequest);
  el("downloadDeleteRecordButton").addEventListener("click", downloadDeleteRecord);
  el("detailModeSelect").addEventListener("change", event => {
    const selectedMode = event.target.value;
    if (!selectedMode) {
      state.selectedMode = "";
      renderModePanel(null, null);
      el("detailModeState").textContent = state.selectedRoom
        ? "Selecting a documented mode can either load a mode-specific helper panel or run its keyed Dashboard action."
        : "Choose a Project Room first.";
      return;
    }
    state.selectedMode = selectedMode;
    const panel = getModePanel(state.selectedRoom?.name, selectedMode);
    if (panel) {
      renderModePanel(state.selectedRoom, panel);
      el("detailModeState").textContent = panel.stateText || `${selectedMode} helper panel loaded.`;
      return;
    }
    renderModePanel(null, null);
    invokeModeAction(state.selectedRoom, selectedMode);
    state.selectedMode = "";
    event.target.value = "";
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
  clearSelection();
  render();
})();
