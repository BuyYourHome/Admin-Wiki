(() => {
  const rooms = Array.isArray(window.PROJECT_ROOMS) ? window.PROJECT_ROOMS : [];
  const groupDefinitions = Array.isArray(window.PROJECT_ROOM_GROUPS) ? window.PROJECT_ROOM_GROUPS : [];
  const groupOrder = groupDefinitions.map(group => group.name);
  const state = { group: "All", query: "", view: "grid", selected: null, selectedRoom: null };
  const el = id => document.getElementById(id);
  const initials = name => name.split(/\s+/).filter(Boolean).slice(0, 2).map(word => word[0]).join("").toUpperCase();
  const filteredRooms = () => {
    const query = state.query.trim().toLowerCase();
    return rooms.filter(room => {
      const groupMatch = state.group === "All" || room.group === state.group;
      const haystack = [room.name, room.purpose, room.status, room.skill, room.group].join(" ").toLowerCase();
      return groupMatch && (!query || haystack.includes(query));
    });
  };
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
    const actions = [
      { label: "Open Project Room README", href: room.readmeUrl },
      ...(Array.isArray(room.quickActions) ? room.quickActions : [])
    ];
    el("detailActionList").replaceChildren(...actions.map(action => {
      const link = document.createElement("a");
      link.className = "quick-action-link";
      link.href = action.href;
      link.textContent = action.label;
      return link;
    }));
    renderCards();
  }

  function openDeleteRequest() {
    const room = state.selectedRoom;
    if (!room) return;
    el("deleteRoomName").textContent = room.name;
    el("deleteConfirmationName").textContent = room.name;
    el("deleteConfirmationInput").value = "";
    el("prepareDeleteButton").disabled = true;
    el("preparedRequest").hidden = true;
    el("copyDeleteRequestButton").hidden = true;
    el("copyDeleteRequestButton").textContent = "Copy request";
    el("deleteDialog").showModal();
    el("deleteConfirmationInput").focus();
  }

  function prepareDeleteRequest() {
    const room = state.selectedRoom;
    if (!room || el("deleteConfirmationInput").value !== room.name) return;
    const skill = room.skill ? `C:\\Codex\\Wiki Files\\skills\\${room.skill}` : "No matching skill recorded";
    el("deleteRequestText").value = [
      "Request to consider deleting an existing Project Room.",
      "",
      `Existing Project Room: ${room.name}`,
      `Existing path: C:\\Codex\\Wiki Files\\Project Rooms\\${room.name}`,
      `Matching skill path: ${skill}`,
      "",
      "Do not delete, archive, rename, move, edit registry entries, alter automations, or change a task yet.",
      "Route this request to the appropriate owning workflow. Identify every affected Project Room path, skill, registry entry, automation, installed skill, and task title. Then ask Wes the exact required authorization question before taking action."
    ].join("\n");
    el("preparedRequest").hidden = false;
    el("copyDeleteRequestButton").hidden = false;
  }

  async function copyDeleteRequest() {
    const text = el("deleteRequestText").value;
    try {
      await navigator.clipboard.writeText(text);
      el("copyDeleteRequestButton").textContent = "Copied";
    } catch {
      el("deleteRequestText").select();
      el("copyDeleteRequestButton").textContent = "Select and copy";
    }
  }
  function renderCards() {
    const visible = filteredRooms();
    const grid = el("roomGrid");
    grid.className = `room-grid${state.view === "list" ? " list" : ""}`;
    grid.replaceChildren(...visible.map(room => {
      const card = document.createElement("button");
      card.type = "button";
      card.className = `room-card${state.selected === room.name ? " selected" : ""}`;
      card.innerHTML = `<div class="card-top"><span class="room-mark">${initials(room.name)}</span><h3></h3></div><p></p><div class="card-meta"><span class="status-dot"></span><span></span></div>`;
      card.querySelector("h3").textContent = room.name;
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
  el("searchInput").addEventListener("input", event => { state.query = event.target.value; renderCards(); });
  el("requestDeleteButton").addEventListener("click", openDeleteRequest);
  el("deleteConfirmationInput").addEventListener("input", event => {
    el("prepareDeleteButton").disabled = !state.selectedRoom || event.target.value !== state.selectedRoom.name;
  });
  el("prepareDeleteButton").addEventListener("click", prepareDeleteRequest);
  el("copyDeleteRequestButton").addEventListener("click", copyDeleteRequest);
  el("detailModeSelect").addEventListener("change", event => {
    el("detailModeState").textContent = event.target.value ? `Selected for interface review: ${event.target.value}. No mode was activated.` : "Selection does not activate a mode.";
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
