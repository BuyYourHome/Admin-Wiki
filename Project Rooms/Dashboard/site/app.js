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
  const state = { group: "All", query: "", view: "grid", selected: null, selectedRoom: null, selectedMode: "", selectedManagerTaskId: "", selectedInvoiceEntryProject: "", managerTaskUpdatePending: false, sopGroup: "All", visibleSopEntries: [], invoiceEntryRequestResult: null, showInvoiceEntryRequestText: false, bridgeTestState: null, bridgeTestLoaded: false, bridgeTestLoading: false, bridgeTestSubmitting: false, deletionRequestState: null, deletionRequestLoadedRoomName: "", deletionRequestLoading: false, deletionRequestSubmitting: false, deletionRequestQueryPending: null };
  const el = id => document.getElementById(id);
  const initials = name => name.split(/\s+/).filter(Boolean).slice(0, 2).map(word => word[0]).join("").toUpperCase();
  const attentionLabel = attention => attention?.type === "approval-needed" ? "Approval needed" : "Confirmation needed";
  const isExternalHref = href => /^[a-z][a-z0-9+.-]*:/i.test(href || "");
  const getModeAction = (roomName, modeName) => modeActions?.[roomName]?.[modeName] || null;
  const getModePanel = (roomName, modeName) => modePanels?.[roomName]?.[modeName] || null;
  const controlAvailable = availability => availability !== "local-only" || dashboardContext.clientAccess === "local";
  const canEditManagerTasks = () => dashboardContext.hostMode === "local-full" && dashboardContext.clientAccess === "local" && !dashboardContext.readOnly;
  const canPrepareBridgeTest = () => dashboardContext.hostMode === "local-full" && dashboardContext.clientAccess === "local" && !dashboardContext.readOnly;
  const canPrepareDeletionRequest = () => Boolean(
    dashboardContext.allowDeletionRequestWrites ??
    (dashboardContext.hostMode === "local-full" && dashboardContext.clientAccess === "local" && !dashboardContext.readOnly)
  );
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
  const getInvoiceEntryProjects = room => Array.isArray(room?.invoiceEntryProjects) ? room.invoiceEntryProjects.slice() : [];
  const getManagerTaskDisplayId = taskId => {
    const match = String(taskId || "").match(/-(\d{3})$/);
    return match ? match[1] : String(taskId || "");
  };
  function syncSelectedInvoiceEntryProject(room) {
    const projects = getInvoiceEntryProjects(room);
    if (!projects.length) {
      state.selectedInvoiceEntryProject = "";
      return null;
    }
    if (!projects.some(project => project.project === state.selectedInvoiceEntryProject)) {
      state.selectedInvoiceEntryProject = projects[0].project;
    }
    return projects.find(project => project.project === state.selectedInvoiceEntryProject) || projects[0];
  }
  function buildInvoiceEntryReconcileRequest(project) {
    if (!project?.project) {
      return "";
    }
    return [
      "Invoice Entry mode: Reconcile",
      "Requester: Wes",
      `Project/property: ${project.project}`,
      `Workbook hint: ${project.workbookPath}`,
      "Requested action: Run Reconcile for this exact project/property. This Dashboard request is the authorization to evaluate existing Review!tblInvoiceReview rows even when invoiceEntryReviewRequest is FALSE or blank.",
      "Source: Dashboard mode panel Invoice Entry -> Reconcile"
    ].join("\n");
  }
  const buildInvoiceEntryTaskHref = taskId => taskId ? `codex://threads/${taskId}` : "";
  function getInvoiceEntryRequestResult(room) {
    if (room?.name !== "Invoice Entry") {
      return null;
    }
    const result = state.invoiceEntryRequestResult;
    return result?.roomName === room.name ? result : null;
  }
  function shouldShowInvoiceEntryRequestText(result) {
    return Boolean(result?.requestText) && (state.showInvoiceEntryRequestText || result.copyFailed);
  }
  function copyTextareaContent(textarea, { preserveSelectionOnFailure = false } = {}) {
    if (!textarea) {
      return false;
    }
    const activeElement = document.activeElement;
    textarea.focus();
    textarea.select();
    textarea.setSelectionRange(0, textarea.value.length);
    let copied = false;
    try {
      copied = Boolean(document.execCommand && document.execCommand("copy"));
    } catch {
      copied = false;
    }
    if (copied || !preserveSelectionOnFailure) {
      if (activeElement && activeElement !== textarea && typeof activeElement.focus === "function") {
        activeElement.focus();
      }
    }
    return copied;
  }
  function legacyCopyText(text) {
    const activeElement = document.activeElement;
    const textarea = document.createElement("textarea");
    textarea.value = text;
    textarea.setAttribute("readonly", "");
    textarea.setAttribute("aria-hidden", "true");
    textarea.style.position = "fixed";
    textarea.style.top = "-1000px";
    textarea.style.left = "-1000px";
    textarea.style.opacity = "0";
    document.body.append(textarea);
    textarea.focus();
    textarea.select();
    textarea.setSelectionRange(0, textarea.value.length);
    let copied = false;
    try {
      copied = Boolean(document.execCommand && document.execCommand("copy"));
    } catch {
      copied = false;
    } finally {
      textarea.remove();
      if (activeElement && typeof activeElement.focus === "function") {
        activeElement.focus();
      }
    }
    return copied;
  }
  async function copyTextToClipboard(text) {
    if (!text) {
      return false;
    }
    if (window.isSecureContext && navigator.clipboard?.writeText) {
      try {
        await navigator.clipboard.writeText(text);
        return true;
      } catch {
      }
    }
    return legacyCopyText(text);
  }
  function openInvoiceEntryTask(taskId) {
    const href = buildInvoiceEntryTaskHref(taskId);
    if (!href) {
      return false;
    }
    try {
      window.location.assign(href);
      return true;
    } catch {
      try {
        const anchor = document.createElement("a");
        anchor.href = href;
        anchor.style.display = "none";
        document.body.append(anchor);
        anchor.click();
        anchor.remove();
        return true;
      } catch {
        return false;
      }
    }
  }
  function renderReconcileDialog() {
    const dialog = el("reconcileDialog");
    const result = state.invoiceEntryRequestResult;
    if (!dialog || !result) {
      return;
    }
    el("reconcileDialogProject").textContent = result.project || "-";
    el("reconcileRequestText").value = result.requestText || "";
    el("reconcileDialogSummary").textContent = result.statusText || "Request prepared.";
    el("reconcileDialogState").textContent = result.copied
      ? "The request text was copied automatically. Paste it into the Invoice Entry Codex task."
      : "If the request was not copied automatically, use Copy request text or copy the text manually.";
    if (!dialog.open) {
      dialog.showModal();
    }
  }
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
  async function loadBridgeTestState({ force = false } = {}) {
    if (state.bridgeTestLoading || (!force && state.bridgeTestLoaded)) {
      return;
    }
    state.bridgeTestLoading = true;
    renderModePanel(state.selectedRoom, getModePanel(state.selectedRoom?.name, state.selectedMode));
    try {
      const response = await fetch("__dashboard-bridge-test", { headers: { Accept: "application/json" } });
      const result = await response.json().catch(() => ({}));
      if (!response.ok || result.ok !== true) {
        throw new Error(result.message || `Bridge test status load failed (${response.status}).`);
      }
      state.bridgeTestState = result.state || null;
      state.bridgeTestLoaded = true;
    } catch (error) {
      state.bridgeTestLoaded = false;
      el("detailModeState").textContent = `Bridge test status load failed: ${error.message}`;
    } finally {
      state.bridgeTestLoading = false;
      if (state.selectedRoom?.name === "Dashboard" && state.selectedMode === "Bridge Test") {
        renderModePanel(state.selectedRoom, getModePanel(state.selectedRoom?.name, state.selectedMode));
      }
    }
  }
  async function prepareBridgeTestRequest() {
    if (!canPrepareBridgeTest()) {
      el("detailModeState").textContent = "Bridge test preparation is available only from the full local Dashboard host.";
      return;
    }
    state.bridgeTestSubmitting = true;
    renderModePanel(state.selectedRoom, getModePanel(state.selectedRoom?.name, state.selectedMode));
    try {
      const response = await fetch("__dashboard-bridge-test", {
        method: "POST",
        headers: { Accept: "application/json" }
      });
      const result = await response.json().catch(() => ({}));
      if (!response.ok || result.ok !== true) {
        throw new Error(result.message || `Bridge test preparation failed (${response.status}).`);
      }
      state.bridgeTestState = result.state || null;
      state.bridgeTestLoaded = true;
      el("detailModeState").textContent = result.message || "Dashboard bridge test request is recorded.";
    } catch (error) {
      el("detailModeState").textContent = `Bridge test preparation failed: ${error.message}`;
    } finally {
      state.bridgeTestSubmitting = false;
      renderModePanel(state.selectedRoom, getModePanel(state.selectedRoom?.name, state.selectedMode));
    }
  }
  function getLatestDeletionRequest(requests, roomName) {
    if (!roomName) {
      return null;
    }
    return [...requests]
      .filter(request => request?.projectRoom?.name === roomName)
      .sort((left, right) => (Date.parse(right.createdAt || "") || 0) - (Date.parse(left.createdAt || "") || 0))[0] || null;
  }
  function getDeletionRequestResult(room) {
    if (!room) {
      return null;
    }
    return state.deletionRequestLoadedRoomName === room.name ? state.deletionRequestState : null;
  }
  function buildDeletionRequestPlan(room) {
    const taskState = room.taskId
      ? "Task/chat is documented, but Codex currently exposes archiving rather than task deletion. Do not substitute archive for deletion without Wes's separate authorization."
      : "No task/chat id is documented, so no task deletion is included in the proposed scope.";
    const skillState = room.skill
      ? (room.skillState === "available" ? `Matching skill included: ${room.skillPath}` : `Matching skill ${room.skillPath || room.skill} is not available for verified deletion.`)
      : "No matching skill is documented, so no skill deletion is included in the proposed scope.";
    return {
      roomName: room.name,
      roomPath: `C:\\Codex\\Wiki Files\\Project Rooms\\${room.name}`,
      dashboardEntry: "Derived from the Project Room folder and removed by the next Dashboard refresh only after authorized folder deletion.",
      matchingSkill: room.skill ? { name: room.skill, path: room.skillPath || null, state: room.skillState } : null,
      associatedTask: room.taskId ? { id: room.taskId, state: "unavailable: no task-delete capability exposed" } : null,
      requestedAction: "Review this Project Room deletion request and return accepted, done, blocked, needs Wes, or rejected as wrong room. Do not delete, archive, rename, or standardize anything unless separately authorized under the owning workflow.",
      confirmation: `One explicit Dashboard confirmation for ${room.name}; Dashboard executed no deletion.`,
      limits: [
        "Do not delete, archive, hide, rename, move, edit a registry, alter an automation, or change an installed skill from the Dashboard interface.",
        "Do not extend the scope beyond the selected Project Room, its documented matching skill, and its documented task/chat.",
        "If any included resource is unresolved or unavailable, stop without partial deletion and report the blocker to Wes.",
        "Dashboard self-protection rule: do not delete Dashboard from its own interface."
      ],
      summaryText: `${taskState} ${skillState} Dashboard created no deletion and no archive.`
    };
  }
  function renderDeletionRequestSummary(room) {
    const summary = el("deleteRequestStatusSummary");
    if (!summary) {
      return;
    }
    if (!room) {
      summary.textContent = "No deletion request recorded for this room.";
      return;
    }
    if (state.deletionRequestLoading && state.deletionRequestQueryPending === room.name) {
      summary.textContent = "Loading the latest deletion request status...";
      return;
    }
    const request = getDeletionRequestResult(room);
    if (!request) {
      summary.textContent = canPrepareDeletionRequest()
        ? "No deletion request recorded for this room."
        : "No deletion request recorded for this room. Remote LAN views can review existing requests only.";
      return;
    }
    summary.textContent = `Latest deletion request: ${request.status}. Request id ${request.requestId}.`;
  }
  function renderDeleteDialogStatus(room) {
    const request = getDeletionRequestResult(room);
    const statusBox = el("deleteRequestStatusBox");
    const requestBox = el("preparedRequest");
    const requestButton = el("prepareDeleteButton");
    const refreshButton = el("refreshDeleteRequestButton");
    if (!statusBox || !requestBox || !requestButton || !refreshButton) {
      return;
    }

    const isDashboardRoom = room?.name === "Dashboard";
    const canCreate = canPrepareDeletionRequest() && !isDashboardRoom;
    requestButton.disabled = state.deletionRequestSubmitting || !room || !canCreate;
    refreshButton.disabled = state.deletionRequestLoading || !room;

    if (isDashboardRoom) {
      el("deletePlanState").textContent = "Dashboard self-protection: Dashboard cannot delete itself from its own interface. Use a separate explicitly authorized Admin workflow.";
    } else if (!canPrepareDeletionRequest()) {
      el("deletePlanState").textContent = "Deletion request creation is available only on WesStudio itself. Remote LAN views can still review an existing request status.";
    }

    if (!request) {
      statusBox.hidden = true;
      if (!room) {
        requestBox.hidden = true;
        return;
      }
      const plan = buildDeletionRequestPlan(room);
      el("deleteRequestText").value = JSON.stringify({
        request_type: "project-room-deletion-request",
        source_pr: "Dashboard",
        target_pr: "Create PR",
        project_room: {
          name: plan.roomName,
          path: plan.roomPath
        },
        matching_skill: plan.matchingSkill,
        associated_task: plan.associatedTask,
        limits: plan.limits
      }, null, 2);
      requestBox.hidden = false;
      if (!isDashboardRoom && canPrepareDeletionRequest()) {
        el("deletePlanState").textContent = `${plan.summaryText} Create deletion request to record the handoff for Create PR.`;
      }
      return;
    }

    statusBox.hidden = false;
    requestBox.hidden = false;
    el("deleteRequestStatusText").value = [
      `REQUEST ID: ${request.requestId}`,
      `TARGET PR: ${request.targetPr}`,
      `TARGET TASK: ${request.targetThreadId}`,
      `CREATED: ${request.createdAt}`,
      `DELIVERY ATTEMPT: ${request.deliveryAttemptedAt || "-"}`,
      `STATUS: ${request.status}`,
      `RETURNED: ${request.returnedAt || "-"}`,
      `MESSAGE: ${request.message || "-"}`
    ].join("\n");
    el("deleteRequestStatusNote").textContent = "Transport note: Dashboard records the request in the shared action-request store. The active Dashboard Codex task performs the actual task-message send and writes the returned status back here.";
    el("deleteRequestText").value = JSON.stringify(request, null, 2);
    el("deletePlanState").textContent = request.message || `Current deletion request status: ${request.status}.`;
  }
  async function loadDeletionRequestState(room, { force = false } = {}) {
    if (!room?.name) {
      return;
    }
    if (state.deletionRequestLoading || (!force && state.deletionRequestLoadedRoomName === room.name)) {
      return;
    }
    state.deletionRequestLoading = true;
    state.deletionRequestQueryPending = room.name;
    renderDeletionRequestSummary(room);
    if (el("deleteDialog")?.open) {
      renderDeleteDialogStatus(room);
    }
    try {
      const response = await fetch("__dashboard-deletion-request", { headers: { Accept: "application/json" } });
      const result = await response.json().catch(() => ({}));
      if (!response.ok || result.ok !== true) {
        throw new Error(result.message || `Deletion request status load failed (${response.status}).`);
      }
      state.deletionRequestState = getLatestDeletionRequest(Array.isArray(result.requests) ? result.requests : [], room.name);
      state.deletionRequestLoadedRoomName = room.name;
    } catch (error) {
      state.deletionRequestLoadedRoomName = "";
      if (state.selectedRoom?.name === room.name) {
        el("detailModeState").textContent = `Deletion request status load failed: ${error.message}`;
      }
    } finally {
      state.deletionRequestLoading = false;
      state.deletionRequestQueryPending = null;
      if (state.selectedRoom?.name === room.name) {
        renderDeletionRequestSummary(room);
      }
      if (el("deleteDialog")?.open && state.selectedRoom?.name === room.name) {
        renderDeleteDialogStatus(room);
      }
    }
  }
  async function createDeletionRequest(room) {
    if (!room) {
      return;
    }
    if (room.name === "Dashboard") {
      el("deletePlanState").textContent = "Dashboard self-protection: Dashboard cannot delete itself from its own interface.";
      return;
    }
    if (!canPrepareDeletionRequest()) {
      el("deletePlanState").textContent = "Deletion request creation is available only on WesStudio itself.";
      return;
    }

    const plan = buildDeletionRequestPlan(room);
    state.deletionRequestSubmitting = true;
    renderDeleteDialogStatus(room);
    try {
      const response = await fetch("__dashboard-deletion-request", {
        method: "POST",
        headers: { "Content-Type": "application/json", Accept: "application/json" },
        body: JSON.stringify(plan)
      });
      const result = await response.json().catch(() => ({}));
      if (!response.ok || result.ok !== true) {
        throw new Error(result.message || `Deletion request creation failed (${response.status}).`);
      }
      state.deletionRequestState = result.state || null;
      state.deletionRequestLoadedRoomName = room.name;
      el("deletePlanState").textContent = result.message || `Dashboard deletion request created for ${room.name}.`;
      renderDeletionRequestSummary(room);
    } catch (error) {
      el("deletePlanState").textContent = `Deletion request creation failed: ${error.message}`;
    } finally {
      state.deletionRequestSubmitting = false;
      renderDeleteDialogStatus(room);
    }
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
  async function openInvoiceEntryReconcileRequest(room, project) {
    if (!room?.taskId) {
      el("detailModeState").textContent = "Invoice Entry does not have a documented task id, so Dashboard cannot open its request interface.";
      return;
    }
    if (!project?.project) {
      el("detailModeState").textContent = "Select an active project before preparing an Invoice Entry Reconcile request.";
      return;
    }
    const requestText = buildInvoiceEntryReconcileRequest(project);
    state.invoiceEntryRequestResult = {
      roomName: room.name,
      project: project.project,
      workbookPath: project.workbookPath || "",
      requestText,
      copied: false,
      opened: false,
      copyFailed: false,
      openFailed: false,
      attemptedAt: new Date().toLocaleString(),
      statusText: "Preparing request..."
    };
    state.showInvoiceEntryRequestText = false;
    el("detailModeState").textContent = `Preparing the Reconcile request for ${project.project}...`;
    renderModePanel(room, getModePanel(room.name, "Reconcile"));
    try {
      const copied = await copyTextToClipboard(requestText);
      const opened = openInvoiceEntryTask(room.taskId);
      state.invoiceEntryRequestResult = {
        ...state.invoiceEntryRequestResult,
        copied,
        opened,
        copyFailed: !copied,
        openFailed: !opened,
        statusText: copied && opened
          ? "Request copied. Invoice Entry opened."
          : copied
            ? "Request copied. Invoice Entry did not open automatically."
            : opened
              ? "Invoice Entry opened. Request was not copied automatically."
              : "Request prepared, but copy/open did not complete automatically."
      };
      state.showInvoiceEntryRequestText = !copied;
      renderModePanel(room, getModePanel(room.name, "Reconcile"));
      if (copied && opened) {
        el("detailModeState").textContent = `Reconcile is prepared for ${project.project}. Paste the copied request into the opened Invoice Entry task.`;
        return;
      }
      if (copied) {
        el("detailModeState").textContent = `Reconcile is prepared for ${project.project}. The request was copied; open Invoice Entry and paste it there.`;
        return;
      }
      if (opened) {
        el("detailModeState").textContent = `Invoice Entry opened for ${project.project}. The request text is shown below because automatic copy did not complete.`;
        return;
      }
      el("detailModeState").textContent = `Reconcile is prepared for ${project.project}, but the browser did not open Invoice Entry or copy the text automatically. The request text is shown below for manual copy.`;
    } catch (error) {
      state.invoiceEntryRequestResult = {
        ...state.invoiceEntryRequestResult,
        copyFailed: true,
        statusText: `Reconcile preparation hit a browser error: ${error.message}`
      };
      state.showInvoiceEntryRequestText = true;
      renderModePanel(room, getModePanel(room.name, "Reconcile"));
      el("detailModeState").textContent = `Reconcile preparation failed for ${project.project}: ${error.message}`;
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
    state.selectedInvoiceEntryProject = "";
    state.invoiceEntryRequestResult = null;
    state.showInvoiceEntryRequestText = false;
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
    el("deleteActionSummary").textContent = "Shows the exact deletion scope and can record a Create PR deletion request. Dashboard itself does not delete anything.";
    el("deleteRequestStatusSummary").textContent = "No deletion request recorded for this room.";
    el("requestDeleteButton").disabled = true;
    el("requestDeleteButton").title = "Select a Project Room first.";
    renderSopViewer(null);
    syncSelectedCardHighlight();
  }

  function syncSelectedCardHighlight() {
    document.querySelectorAll(".room-card").forEach(card => {
      card.classList.toggle("selected", card.dataset.roomName === state.selected);
    });
  }

  function selectRoom(room) {
    state.selected = room.name;
    state.selectedRoom = room;
    state.selectedMode = "";
    state.selectedManagerTaskId = "";
    state.selectedInvoiceEntryProject = "";
    state.invoiceEntryRequestResult = null;
    state.showInvoiceEntryRequestText = false;
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
      ? "Shows the exact deletion scope and can record a Create PR deletion request. Dashboard does not delete anything."
      : "Deletion workflow preview is disabled in the LAN read-only host view.";
    el("deleteActionSummary").textContent = "Shows the exact deletion scope and can record a Create PR deletion request. Dashboard itself does not delete anything.";
    renderDeletionRequestSummary(room);
    loadDeletionRequestState(room);
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
    syncSelectedCardHighlight();
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
        ? "Deletion workflow preview remains available on the host machine. Dashboard still does not delete anything here."
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
    renderDeleteDialogStatus(room);
    if (state.deletionRequestLoadedRoomName !== room.name) {
      loadDeletionRequestState(room);
    }
    el("deleteDialog").showModal();
    el("prepareDeleteButton").focus();
  }

  function prepareDeleteRequest() {
    const room = state.selectedRoom;
    if (!room) return;
    createDeletionRequest(room);
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
    const selectedInvoiceEntryProject = room?.name === "Invoice Entry" ? syncSelectedInvoiceEntryProject(room) : null;
    const latestInvoiceEntryRequest = getInvoiceEntryRequestResult(room);
    const selectedManagerTask = room?.name === "Manager" ? syncSelectedManagerTask(room) : null;
    if (room?.name === "Dashboard" && state.selectedMode === "Bridge Test" && !state.bridgeTestLoaded && !state.bridgeTestLoading) {
      loadBridgeTestState();
    }

    const controlElements = (Array.isArray(panel.controls) ? panel.controls : []).map(control => {
      if (control.type === "project-select") {
        const card = document.createElement("div");
        card.className = "mode-panel-card";
        const label = document.createElement("strong");
        label.textContent = control.label || "What Property";
        const note = document.createElement("p");
        const projects = getInvoiceEntryProjects(room);
        note.textContent = projects.length
          ? "Active projects come from Invoice Entry's canonical workbook register."
          : (control.emptyText || "No current active projects were found.");
        const select = document.createElement("select");
        select.className = "mode-panel-select";
        select.disabled = !projects.length;
        select.replaceChildren(...projects.map(project => {
          const option = document.createElement("option");
          option.value = project.project;
          option.textContent = project.project;
          option.selected = project.project === state.selectedInvoiceEntryProject;
          return option;
        }));
        select.addEventListener("change", event => {
          state.selectedInvoiceEntryProject = event.target.value || "";
          state.invoiceEntryRequestResult = null;
          state.showInvoiceEntryRequestText = false;
          renderModePanel(room, panel);
        });
        card.append(label, note, select);
        if (selectedInvoiceEntryProject?.workbookPath) {
          const pathNote = document.createElement("p");
          pathNote.className = "manager-task-meta";
          pathNote.textContent = `Workbook hint: ${selectedInvoiceEntryProject.workbookPath}`;
          card.append(pathNote);
        }
        return card;
      }

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
            title.textContent = `${getManagerTaskDisplayId(task.taskId)} - ${task.task}`;
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
          ? (selectedManagerTask ? `Selected task: ${getManagerTaskDisplayId(selectedManagerTask.taskId)}` : "Select an open Manager task to change its status.")
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

      if (control.type === "invoice-entry-reconcile-request") {
        const card = document.createElement("div");
        card.className = "mode-panel-card";
        const label = document.createElement("strong");
        label.textContent = control.label || "Reconcile";
        const note = document.createElement("p");
        const available = controlAvailable(control.availability || "local-only");
        note.textContent = available
          ? (selectedInvoiceEntryProject
            ? `Prepare the exact Reconcile request for ${selectedInvoiceEntryProject.project}, then paste it into the Invoice Entry Codex task.`
            : "Select an active project before preparing the Reconcile request.")
          : (control.description || "This control is available only on the host machine.");
        card.append(label, note);
        if (!available) {
          card.classList.add("disabled");
          return card;
        }
        const requestText = buildInvoiceEntryReconcileRequest(selectedInvoiceEntryProject);
        const actionRow = document.createElement("div");
        actionRow.className = "reconcile-status-actions";
        const runButton = document.createElement("button");
        runButton.type = "button";
        runButton.className = "primary-button";
        runButton.textContent = control.label || "Reconcile";
        runButton.disabled = !selectedInvoiceEntryProject;
        runButton.addEventListener("click", () => openInvoiceEntryReconcileRequest(room, selectedInvoiceEntryProject));
        actionRow.append(runButton);
        if (requestText || latestInvoiceEntryRequest?.requestText) {
          const toggleButton = document.createElement("button");
          toggleButton.type = "button";
          toggleButton.className = "secondary-button";
          toggleButton.textContent = state.showInvoiceEntryRequestText ? "Hide request text" : "Show request text";
          toggleButton.addEventListener("click", () => {
            state.showInvoiceEntryRequestText = !state.showInvoiceEntryRequestText;
            renderModePanel(room, panel);
          });
          actionRow.append(toggleButton);
        }
        card.append(actionRow);
        let statusCard = null;
        if (latestInvoiceEntryRequest) {
          statusCard = document.createElement("div");
          statusCard.className = "mode-panel-card reconcile-status-card";
          const statusLabel = document.createElement("strong");
          statusLabel.textContent = "Latest Reconcile action";
          const statusSummary = document.createElement("p");
          statusSummary.textContent = latestInvoiceEntryRequest.statusText
            ? `${latestInvoiceEntryRequest.statusText} Tried ${latestInvoiceEntryRequest.attemptedAt}.`
            : `${latestInvoiceEntryRequest.copied ? "Request copied." : "Request not copied automatically."} ${latestInvoiceEntryRequest.opened ? "Invoice Entry opened." : "Invoice Entry did not open automatically."} Tried ${latestInvoiceEntryRequest.attemptedAt}.`;
          const projectRow = document.createElement("p");
          projectRow.className = "reconcile-status-row";
          const projectLabel = document.createElement("strong");
          projectLabel.textContent = "Project:";
          projectRow.append(projectLabel, document.createTextNode(` ${latestInvoiceEntryRequest.project}`));
          const workbookRow = document.createElement("p");
          workbookRow.className = "reconcile-status-row";
          const workbookLabel = document.createElement("strong");
          workbookLabel.textContent = "Workbook hint:";
          workbookRow.append(workbookLabel, document.createTextNode(` ${latestInvoiceEntryRequest.workbookPath || "No workbook hint recorded."}`));
          const nextStepRow = document.createElement("p");
          nextStepRow.className = "reconcile-status-row";
          const nextStepLabel = document.createElement("strong");
          nextStepLabel.textContent = "Next step:";
          nextStepRow.append(nextStepLabel, document.createTextNode(` ${latestInvoiceEntryRequest.copied ? "Go to the Invoice Entry Codex task and paste the copied request." : "Use Show request text below, then paste it into the Invoice Entry Codex task."}`));
          const statusActions = document.createElement("div");
          statusActions.className = "reconcile-status-actions";
          const copyButton = document.createElement("button");
          copyButton.type = "button";
          copyButton.className = "secondary-button";
          copyButton.textContent = "Copy request text";
          copyButton.addEventListener("click", async () => {
            const copiedAgain = await copyTextToClipboard(latestInvoiceEntryRequest.requestText);
            state.invoiceEntryRequestResult = {
              ...latestInvoiceEntryRequest,
              copied: copiedAgain || latestInvoiceEntryRequest.copied,
              copyFailed: !(copiedAgain || latestInvoiceEntryRequest.copied),
              statusText: copiedAgain
                ? "Request copied."
                : latestInvoiceEntryRequest.statusText || "Copy did not complete automatically."
            };
            state.showInvoiceEntryRequestText = !copiedAgain;
            el("detailModeState").textContent = copiedAgain
              ? `Copied the Reconcile request for ${latestInvoiceEntryRequest.project}. Paste it into the Invoice Entry task.`
              : `Copy failed in this browser. The request text is shown below for manual copy for ${latestInvoiceEntryRequest.project}.`;
            renderModePanel(room, panel);
          });
          const openButton = document.createElement("button");
          openButton.type = "button";
          openButton.className = "secondary-button";
          openButton.textContent = "Open Invoice Entry task";
          openButton.addEventListener("click", () => {
            const openedAgain = openInvoiceEntryTask(room.taskId);
            state.invoiceEntryRequestResult = {
              ...latestInvoiceEntryRequest,
              opened: openedAgain || latestInvoiceEntryRequest.opened,
              openFailed: !(openedAgain || latestInvoiceEntryRequest.opened),
              statusText: openedAgain
                ? "Invoice Entry opened."
                : latestInvoiceEntryRequest.statusText || "Invoice Entry did not open automatically."
            };
            el("detailModeState").textContent = openedAgain
              ? `Opened Invoice Entry for ${latestInvoiceEntryRequest.project}. Paste the Reconcile request there.`
              : `The browser blocked the Invoice Entry task window for ${latestInvoiceEntryRequest.project}.`;
            renderModePanel(room, panel);
          });
          statusActions.append(copyButton, openButton);
          statusCard.append(statusLabel, statusSummary, projectRow, workbookRow, nextStepRow, statusActions);
        }
        if (statusCard) {
          card.append(statusCard);
        }
        const visibleRequestText = latestInvoiceEntryRequest?.requestText || requestText;
        if (shouldShowInvoiceEntryRequestText(latestInvoiceEntryRequest || { requestText: visibleRequestText })) {
          const requestPreview = document.createElement("pre");
          requestPreview.className = "mode-panel-template";
          requestPreview.textContent = visibleRequestText || "Select an active project to prepare the Invoice Entry Reconcile request.";
          const requestNote = document.createElement("p");
          requestNote.className = "reconcile-request-note";
          requestNote.textContent = latestInvoiceEntryRequest?.copyFailed
            ? "Automatic copy did not complete. Use this exact text for manual copy."
            : "This is the exact text you paste into the Invoice Entry Codex task.";
          card.append(requestPreview, requestNote);
        }
        return card;
      }

      if (control.type === "dashboard-bridge-test") {
        const card = document.createElement("div");
        card.className = "mode-panel-card";
        const label = document.createElement("strong");
        label.textContent = control.label || "Prepare bridge test request";
        const note = document.createElement("p");
        const available = canPrepareBridgeTest();
        note.textContent = available
          ? "Record one bridge-test request for Create PR on the local Dashboard host, then watch the returned status here."
          : (control.description || "Bridge test preparation is available only from the full local Dashboard host.");
        card.append(label, note);

        const actionRow = document.createElement("div");
        actionRow.className = "reconcile-status-actions";
        if (available) {
          const prepareButton = document.createElement("button");
          prepareButton.type = "button";
          prepareButton.className = "primary-button";
          prepareButton.textContent = state.bridgeTestSubmitting
            ? "Saving..."
            : (state.bridgeTestState ? "Reuse current request" : (control.label || "Prepare bridge test request"));
          prepareButton.disabled = state.bridgeTestSubmitting || state.bridgeTestLoading;
          prepareButton.addEventListener("click", prepareBridgeTestRequest);
          actionRow.append(prepareButton);
        }
        const refreshButton = document.createElement("button");
        refreshButton.type = "button";
        refreshButton.className = "secondary-button";
        refreshButton.textContent = state.bridgeTestLoading ? "Refreshing..." : "Refresh status";
        refreshButton.disabled = state.bridgeTestLoading || state.bridgeTestSubmitting;
        refreshButton.addEventListener("click", () => loadBridgeTestState({ force: true }));
        actionRow.append(refreshButton);
        card.append(actionRow);

        const statusCard = document.createElement("div");
        statusCard.className = "mode-panel-card reconcile-status-card";
        const statusLabel = document.createElement("strong");
        statusLabel.textContent = "Current bridge test status";
        const statusSummary = document.createElement("p");
        if (state.bridgeTestLoading && !state.bridgeTestState) {
          statusSummary.textContent = "Loading the recorded bridge request state...";
        } else if (!state.bridgeTestState) {
          statusSummary.textContent = "No Dashboard bridge-test request is recorded yet.";
        } else {
          statusSummary.textContent = state.bridgeTestState.message || `Current state: ${state.bridgeTestState.status}.`;
        }
        statusCard.append(statusLabel, statusSummary);

        if (state.bridgeTestState) {
          const addRow = (rowLabel, value) => {
            const row = document.createElement("p");
            row.className = "reconcile-status-row";
            const rowLabelElement = document.createElement("strong");
            rowLabelElement.textContent = rowLabel;
            row.append(rowLabelElement, document.createTextNode(` ${value || "-"}`));
            statusCard.append(row);
          };
          addRow("Request id:", state.bridgeTestState.requestId);
          addRow("Target PR:", state.bridgeTestState.targetPr);
          addRow("Target task:", state.bridgeTestState.targetThreadId);
          addRow("Created:", state.bridgeTestState.createdAt);
          addRow("Delivery attempt:", state.bridgeTestState.deliveryAttemptedAt);
          addRow("Status:", state.bridgeTestState.status);
          addRow("Returned:", state.bridgeTestState.returnedAt);
          addRow("Message:", state.bridgeTestState.message);
          const noteRow = document.createElement("p");
          noteRow.className = "reconcile-request-note";
          noteRow.textContent = "Transport note: Dashboard records the request in the shared action-request store. The active Dashboard Codex task performs the actual task-message send and writes the returned status back to this record.";
          statusCard.append(noteRow);
        }

        card.append(statusCard);
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
    if (state.query.trim() && visible.length === 1 && state.selected !== visible[0].name) {
      selectRoom(visible[0]);
      return;
    }
    const grid = el("roomGrid");
    grid.className = `room-grid${state.view === "list" ? " list" : ""}`;
    grid.replaceChildren(...visible.map(room => {
      const card = document.createElement("button");
      card.type = "button";
      card.dataset.roomName = room.name;
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
    const nextQuery = event.target.value;
    if (nextQuery === state.query) {
      return;
    }
    state.query = nextQuery;
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
  el("refreshDeleteRequestButton").addEventListener("click", () => {
    if (state.selectedRoom) {
      loadDeletionRequestState(state.selectedRoom, { force: true });
    }
  });
  el("reconcileCopyButton").addEventListener("click", async () => {
    const result = state.invoiceEntryRequestResult;
    if (!result?.requestText) return;
    const copied = await copyTextToClipboard(result.requestText);
    state.invoiceEntryRequestResult = {
      ...result,
      copied: copied || result.copied,
      statusText: copied ? "Request copied." : (result.statusText || "Copy did not complete automatically.")
    };
    el("detailModeState").textContent = copied
      ? `Copied the Reconcile request for ${result.project}. Paste it into the Invoice Entry task.`
      : `Copy failed in this browser. Select the request text and copy it manually for ${result.project}.`;
    renderModePanel(state.selectedRoom, getModePanel(state.selectedRoom?.name, state.selectedMode));
    renderReconcileDialog();
  });
  el("reconcileOpenTaskButton").addEventListener("click", () => {
    const result = state.invoiceEntryRequestResult;
    if (!result || !state.selectedRoom?.taskId) return;
    const opened = openInvoiceEntryTask(state.selectedRoom.taskId);
    state.invoiceEntryRequestResult = {
      ...result,
      opened: opened || result.opened,
      statusText: opened ? "Invoice Entry opened." : (result.statusText || "Invoice Entry did not open automatically.")
    };
    el("detailModeState").textContent = opened
      ? `Opened Invoice Entry for ${result.project}. Paste the Reconcile request there.`
      : `The browser blocked the Invoice Entry task window for ${result.project}.`;
    renderModePanel(state.selectedRoom, getModePanel(state.selectedRoom?.name, state.selectedMode));
    renderReconcileDialog();
  });
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
