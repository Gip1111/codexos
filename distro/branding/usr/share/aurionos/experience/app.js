const iconBase = "../../icons/hicolor/scalable/apps/";

const quickActions = [
  {
    id: "email",
    action: "email",
    icon: "aurion-browser.svg",
    title: "Leggi email",
    body: "Apri il tuo client di posta",
    command: "aurion-action://email"
  },
  {
    id: "install",
    action: "store",
    icon: "aurion-store.svg",
    title: "Installa app",
    body: "Trova e installa nuove applicazioni",
    command: "aurion-action://store"
  },
  {
    id: "wifi",
    action: "wifi",
    icon: "aurion-hardware.svg",
    title: "Controlla Wi-Fi",
    body: "Verifica lo stato della connessione",
    command: "aurion-action://wifi"
  },
  {
    id: "diagnostics",
    action: "diagnostics",
    icon: "aurion-terminal.svg",
    title: "Diagnosi",
    body: "Controlla lo stato del sistema",
    command: "aurion-action://diagnostics"
  }
];

const viewMessages = {
  overview: "Panoramica pronta: azioni rapide, AI locale, stato sistema e suggerimenti.",
  system: "Apro il riepilogo sistema e diagnostica.",
  network: "Apro controllo rete e hardware Wi-Fi.",
  security: "Apro controlli sicurezza e rollback.",
  software: "Apro Aurion Store alpha.",
  services: "Apro strumenti di servizio dal terminale.",
  settings: "Apro il centro di controllo Aurion."
};

const taskInput = document.querySelector("#task-input");
const taskRun = document.querySelector("#task-run");
const quickGrid = document.querySelector("#quick-grid");
const activityList = document.querySelector("#activity-list");

function addActivity(title) {
  const item = document.createElement("li");
  item.innerHTML = `<span></span><strong>${title}</strong><em>adesso</em>`;
  activityList.prepend(item);
  while (activityList.children.length > 4) {
    activityList.lastElementChild.remove();
  }
}

function actionUrl(action) {
  return `aurion-action://${encodeURIComponent(action)}`;
}

function runAction(action, label) {
  addActivity(`${label}: ${actionUrl(action)}`);
  window.location.href = actionUrl(action);
}

function routeTask(text) {
  const query = text.trim().toLowerCase();
  if (!query) return quickActions[0];

  if (query.includes("mail") || query.includes("posta") || query.includes("email")) return quickActions[0];
  if (query.includes("install") || query.includes("app") || query.includes("programma") || query.includes("store")) return quickActions[1];
  if (query.includes("wifi") || query.includes("rete") || query.includes("driver")) return quickActions[2];
  if (query.includes("diagn") || query.includes("errore") || query.includes("stato") || query.includes("disco")) return quickActions[3];
  if (query.includes("browser") || query.includes("web")) {
    return { title: "Browser", action: "browser", command: actionUrl("browser") };
  }
  if (query.includes("file") || query.includes("cartella")) {
    return { title: "Files", action: "files", command: actionUrl("files") };
  }
  if (query.includes("terminal")) {
    return { title: "Terminal", action: "terminal", command: actionUrl("terminal") };
  }

  return {
    title: "Aurion Assistant",
    action: query.replace(/[^a-z0-9-]+/g, "-").replace(/^-|-$/g, "") || "assistant",
    command: actionUrl("ai")
  };
}

function selectAction(action) {
  taskInput.value = action.title;
  taskRun.textContent = "OK";
  runAction(action.action, action.title);
  setTimeout(() => {
    taskRun.textContent = "Go";
  }, 900);
}

quickActions.forEach((action) => {
  const button = document.createElement("button");
  button.type = "button";
  button.className = "quick-card";
  button.dataset.action = action.action;
  button.innerHTML = `
    <span class="quick-icon"><img src="${iconBase}${action.icon}" alt=""></span>
    <strong>${action.title}</strong>
    <p>${action.body}</p>
  `;
  button.addEventListener("click", () => selectAction(action));
  quickGrid.appendChild(button);
});

taskRun.addEventListener("click", () => selectAction(routeTask(taskInput.value)));
taskInput.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    selectAction(routeTask(taskInput.value));
  }
});

document.querySelectorAll("[data-action]:not(.quick-card)").forEach((button) => {
  button.addEventListener("click", () => {
    runAction(button.dataset.action, button.textContent.trim() || button.dataset.action);
  });
});

document.querySelectorAll(".nav-item").forEach((button) => {
  button.addEventListener("click", () => {
    document.querySelectorAll(".nav-item").forEach((item) => item.classList.remove("is-active"));
    button.classList.add("is-active");
    addActivity(viewMessages[button.dataset.view] || "Vista Aurion aggiornata.");
  });
});
