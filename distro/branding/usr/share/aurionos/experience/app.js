const quickActions = [
  {
    id: "email",
    icon: "M",
    title: "Leggi email",
    body: "Apri il tuo client di posta",
    command: "aurion-do email",
    response: "Apro la posta in modo sicuro. In alpha il percorso passa dal browser predefinito."
  },
  {
    id: "install",
    icon: "D",
    title: "Installa app",
    body: "Trova e installa nuove applicazioni",
    command: "aurion-do store",
    response: "Apro Aurion Store alpha. Le installazioni reali restano esplicite e confermate dall'utente."
  },
  {
    id: "wifi",
    icon: "W",
    title: "Controlla Wi-Fi",
    body: "Verifica lo stato della connessione",
    command: "aurion-do hardware",
    response: "Controllo rete e hardware Wi-Fi senza modificare driver o impostazioni."
  },
  {
    id: "diagnostics",
    icon: "P",
    title: "Diagnosi",
    body: "Controlla lo stato del sistema",
    command: "aurion-do diagnostics",
    response: "Preparo diagnostica read-only per capire stato del sistema, log e componenti principali."
  }
];

const viewMessages = {
  overview: "Panoramica pronta: azioni rapide, AI locale, stato sistema e suggerimenti.",
  system: "Sistema: CPU, RAM, disco, temperatura e diagnostica saranno unificati qui.",
  network: "Rete: Wi-Fi, connessione e chip di rete verranno spiegati con linguaggio semplice.",
  security: "Sicurezza: Secure Boot, privacy AI e aggiornamenti devono essere chiari all'utente.",
  software: "Software: Store, Flatpak, deb e AppImage convergeranno in un flusso guidato.",
  services: "Servizi: backup, sincronizzazione e automazioni saranno controllabili da qui.",
  settings: "Impostazioni: il target e' un pannello moderno senza terminale per l'utente normale."
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

function routeTask(text) {
  const query = text.trim().toLowerCase();
  if (!query) return quickActions[0];

  if (query.includes("mail") || query.includes("posta") || query.includes("email")) return quickActions[0];
  if (query.includes("install") || query.includes("app") || query.includes("programma") || query.includes("store")) return quickActions[1];
  if (query.includes("wifi") || query.includes("rete") || query.includes("driver")) return quickActions[2];
  if (query.includes("diagn") || query.includes("errore") || query.includes("stato")) return quickActions[3];

  return {
    title: "Aurion Assistant",
    command: `aurion-task-assist "${query.replace(/"/g, "")}"`,
    response: "Creo un percorso guidato locale. In alpha la richiesta viene mappata a comandi sicuri."
  };
}

function selectAction(action) {
  taskInput.value = action.title;
  addActivity(`${action.title}: ${action.command}`);
  taskRun.textContent = "OK";
  setTimeout(() => {
    taskRun.textContent = "Go";
  }, 900);
}

quickActions.forEach((action) => {
  const button = document.createElement("button");
  button.type = "button";
  button.className = "quick-card";
  button.innerHTML = `
    <span class="quick-icon" data-letter="${action.icon}"></span>
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

document.querySelectorAll("[data-task]").forEach((button) => {
  button.addEventListener("click", () => {
    const action = routeTask(button.dataset.task);
    selectAction(action);
  });
});

document.querySelectorAll(".nav-item").forEach((button) => {
  button.addEventListener("click", () => {
    document.querySelectorAll(".nav-item").forEach((item) => item.classList.remove("is-active"));
    button.classList.add("is-active");
    addActivity(viewMessages[button.dataset.view] || "Vista Aurion aggiornata.");
  });
});
