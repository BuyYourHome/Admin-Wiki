(() => {
  const rooms = Array.isArray(window.PROJECT_ROOMS) ? window.PROJECT_ROOMS : [];
  const groupOrder = ["Intake & Coordination", "Document Intake", "Accounting & Project Data", "Real Estate Transactions", "Legal & Entity", "Publishing & Public Work", "Systems & Maintenance", "Other"];
  const state = { group: "All", query: "", view: "grid", selected: null };
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
    el("detailName").textContent = room.name;
    el("detailPurpose").textContent = room.purpose;
    el("detailGroup").textContent = room.group;
    el("detailStatus").textContent = room.status;
    el("detailSkill").textContent = room.skill || "No matching skill recorded";
    const actions = Array.isArray(room.quickActions) ? room.quickActions : [];
    el("detailActionList").replaceChildren(...actions.map(action => {
      const link = document.createElement("a");
      link.className = "quick-action-link";
      link.href = action.href;
      link.textContent = action.label;
      return link;
    }));
    el("detailActions").hidden = actions.length === 0;
    el("detailLink").href = room.readmeUrl;
    el("detailLink").hidden = false;
    renderCards();
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
  document.querySelectorAll(".view-button").forEach(button => button.addEventListener("click", () => {
    state.view = button.dataset.view;
    document.querySelectorAll(".view-button").forEach(item => item.classList.toggle("active", item === button));
    renderCards();
  }));
  render();
  if (rooms.length) selectRoom(rooms[0]);
})();
