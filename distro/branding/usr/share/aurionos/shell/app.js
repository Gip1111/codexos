const apps = [
  {
    title: "Aurion Experience",
    detail: "Task-oriented desktop start surface",
    command: "aurion-experience",
    tags: ["desktop", "start", "ai"]
  },
  {
    title: "Read email",
    detail: "Open webmail in the browser",
    command: "aurion-do email",
    tags: ["email", "mail", "browser"]
  },
  {
    title: "Install an app",
    detail: "Open the Store alpha and installer guidance",
    command: "aurion-store",
    tags: ["install", "app", "store", "vlc"]
  },
  {
    title: "Hardware Center",
    detail: "Check compatibility without changing drivers",
    command: "aurion-hardware-center",
    tags: ["wifi", "gpu", "driver", "hardware"]
  },
  {
    title: "Diagnostics",
    detail: "Collect a read-only system report",
    command: "aurion-diagnostics",
    tags: ["diagnostics", "error", "repair"]
  },
  {
    title: "Rollback plan",
    detail: "Check snapshot readiness",
    command: "aurion-do rollback",
    tags: ["rollback", "snapshot", "recovery"]
  }
];

const controls = [
  ["System status", "aurion-status"],
  ["AI provider", "aurion-ai-setup --status"],
  ["App install model", "aurion-install --explain"],
  ["Hardware scan", "aurion-hw-scan"],
  ["Release channel", "aurion-channel"],
  ["Rollback status", "aurion-rollback-status"]
];

const responses = [
  {
    match: ["email", "mail", "posta"],
    title: "Read email",
    text: "Open the browser to webmail. The final assistant can remember the preferred provider after user consent.",
    command: "aurion-do email"
  },
  {
    match: ["install", "app", "vlc", "programma"],
    title: "Install an app",
    text: "Use Aurion Store first. The alpha is catalog-only and will not install silently.",
    command: "aurion-store"
  },
  {
    match: ["wifi", "driver", "gpu", "hardware"],
    title: "Check hardware",
    text: "Run read-only hardware classification and diagnostics. No driver changes are made.",
    command: "aurion-hardware-center"
  },
  {
    match: ["error", "diagn", "problema", "fix"],
    title: "Diagnostics",
    text: "Collect release, boot, disk and recent error information for debugging.",
    command: "aurion-diagnostics"
  }
];

const panels = [...document.querySelectorAll("[data-view-panel]")];
const navButtons = [...document.querySelectorAll("[data-view]")];
const search = document.querySelector("#search");
const task = document.querySelector("#task");
const ask = document.querySelector("#ask");
const assistantTitle = document.querySelector("#assistant-title");
const assistantText = document.querySelector("#assistant-text");
const assistantCommand = document.querySelector("#assistant-command");
const appGrid = document.querySelector("#app-grid");
const dockList = document.querySelector("#dock-list");
const controlList = document.querySelector("#control-list");

function setView(view) {
  const known = panels.some((panel) => panel.dataset.viewPanel === view);
  if (!known) view = "desktop";
  panels.forEach((panel) => {
    panel.classList.toggle("hidden", panel.dataset.viewPanel !== view);
  });
  navButtons.forEach((button) => {
    button.classList.toggle("is-active", button.dataset.view === view);
  });
  location.hash = view;
}

function showAssistant(result) {
  assistantTitle.textContent = result.title;
  assistantText.textContent = result.text;
  assistantCommand.textContent = result.command;
  setView("assistant");
}

function resolveTask(value) {
  const query = value.trim().toLowerCase();
  if (!query) {
    return {
      title: "Ready to help",
      text: "Type a task or choose an action. The alpha returns safe commands.",
      command: "aurion-status"
    };
  }
  return responses.find((item) => item.match.some((key) => query.includes(key))) || {
    title: "Aurion Assistant",
    text: "This alpha routes common tasks through safe local tools. More natural language handling will come with Ollama and phi4-mini.",
    command: `aurion-task-assist "${query.replace(/"/g, "")}"`
  };
}

function renderApps(filter = "") {
  const query = filter.trim().toLowerCase();
  appGrid.innerHTML = "";
  apps
    .filter((item) => !query || item.title.toLowerCase().includes(query) || item.tags.some((tag) => tag.includes(query) || query.includes(tag)))
    .forEach((item) => {
      const button = document.createElement("button");
      button.type = "button";
      button.className = "app-card";
      button.innerHTML = `<strong>${item.title}</strong><span>${item.detail}</span><code>${item.command}</code>`;
      button.addEventListener("click", () => showAssistant({
        title: item.title,
        text: item.detail,
        command: item.command
      }));
      appGrid.appendChild(button);
    });
}

function renderDockList() {
  dockList.innerHTML = "";
  apps.slice(0, 5).forEach((item) => {
    const button = document.createElement("button");
    button.type = "button";
    button.textContent = item.title;
    button.addEventListener("click", () => showAssistant({
      title: item.title,
      text: item.detail,
      command: item.command
    }));
    dockList.appendChild(button);
  });
}

function renderControls() {
  controlList.innerHTML = "";
  controls.forEach(([title, command]) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "control-card";
    button.innerHTML = `<strong>${title}</strong><span>${command}</span>`;
    button.addEventListener("click", () => showAssistant({
      title,
      text: "Open this alpha control from terminal or Aurion Experience.",
      command
    }));
    controlList.appendChild(button);
  });
}

navButtons.forEach((button) => {
  button.addEventListener("click", () => {
    setView(button.dataset.view);
  });
});

document.querySelectorAll("[data-command]").forEach((button) => {
  button.addEventListener("click", () => {
    showAssistant({
      title: button.title || "Action",
      text: "This is the safe command associated with the dock action.",
      command: button.dataset.command
    });
  });
});

search.addEventListener("input", () => {
  renderApps(search.value);
  setView("launcher");
});

ask.addEventListener("click", () => showAssistant(resolveTask(task.value)));
task.addEventListener("keydown", (event) => {
  if (event.key === "Enter") showAssistant(resolveTask(task.value));
});

renderApps();
renderDockList();
renderControls();
setView((location.hash || "#desktop").slice(1));
