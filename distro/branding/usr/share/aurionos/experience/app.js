const actions = [
  {
    id: "email",
    view: "today",
    title: "Leggi email",
    body: "Apri la posta dal browser con un percorso sicuro e veloce.",
    command: "aurion-do email",
    response: "Apro la posta nel browser. Puoi usare Gmail, Outlook o il tuo provider preferito.",
    tags: ["browser", "email"]
  },
  {
    id: "browser",
    view: "today",
    title: "Vai sul web",
    body: "Apri il browser predefinito e inizia una ricerca.",
    command: "aurion-do browser",
    response: "Percorso browser pronto. Nel progetto finale Aurion potra rispettare browser preferito e privacy mode.",
    tags: ["web", "search"]
  },
  {
    id: "install",
    view: "apps",
    title: "Installa programma",
    body: "Apri Store alpha o spiega come gestire deb, flatpakref e AppImage.",
    command: "aurion-do store",
    response: "L'installazione app passa da Aurion Store. In alpha non installo pacchetti in silenzio.",
    tags: ["store", "apps"]
  },
  {
    id: "vlc",
    view: "apps",
    title: "Cerca VLC",
    body: "Esempio di installazione futura Flatpak-first.",
    command: "aurion-do store",
    response: "VLC e altre app saranno installabili da Store. Ora il catalogo e' dimostrativo.",
    tags: ["media", "flatpak"]
  },
  {
    id: "hardware",
    view: "hardware",
    title: "Controlla hardware",
    body: "Classifica GPU, Wi-Fi, audio e rete senza modificare driver.",
    command: "aurion-do hardware",
    response: "Avvio il controllo hardware read-only. Nessun driver viene installato dalla live alpha.",
    tags: ["drivers", "compat"]
  },
  {
    id: "wifi",
    view: "hardware",
    title: "Problema Wi-Fi",
    body: "Raccogli stato rete e dispositivi per diagnosi rapida.",
    command: "aurion-hw-scan",
    response: "Controllo Wi-Fi e rete. Se serve, il report aiuta a capire chip e driver.",
    tags: ["wifi", "network"]
  },
  {
    id: "diagnostics",
    view: "ai",
    title: "Diagnostica",
    body: "Genera un report utile per capire errori e stato del sistema.",
    command: "aurion-do diagnostics",
    response: "Eseguo diagnostica read-only. Puoi condividere l'output per il debug della ISO.",
    tags: ["logs", "repair"]
  },
  {
    id: "rollback",
    view: "ai",
    title: "Rollback",
    body: "Verifica preparazione snapshot e strategia Btrfs futura.",
    command: "aurion-do rollback",
    response: "Controllo snapshot e rollback. In alpha non creo snapshot automatici.",
    tags: ["snapshot", "btrfs"]
  },
  {
    id: "ai",
    view: "ai",
    title: "Stato AI locale",
    body: "Verifica provider Ollama, modello phi4-mini e cloud disabilitato.",
    command: "aurion-ai-status",
    response: "Aurion e' local-first. Cloud AI resta disabilitato finche l'utente non lo abilita.",
    tags: ["ollama", "phi4-mini"]
  }
];

const views = {
  today: {
    eyebrow: "Today",
    title: "Fast actions"
  },
  apps: {
    eyebrow: "Apps",
    title: "Install and launch"
  },
  hardware: {
    eyebrow: "Hardware",
    title: "Compatibility"
  },
  ai: {
    eyebrow: "AI",
    title: "Assistant and recovery"
  }
};

const input = document.querySelector("#task-input");
const run = document.querySelector("#task-run");
const title = document.querySelector("#assistant-title");
const response = document.querySelector("#assistant-response");
const command = document.querySelector("#assistant-command");
const copy = document.querySelector("#copy-command");
const actionGrid = document.querySelector("#action-grid");
const quickActions = document.querySelector("#quick-actions");
const viewPanel = document.querySelector("#view-panel");

function renderActions(view = "today") {
  const selected = actions.filter((item) => item.view === view || view === "today" && ["email", "browser", "install", "hardware"].includes(item.id));
  const config = views[view] || views.today;

  viewPanel.querySelector(".eyebrow").textContent = config.eyebrow;
  viewPanel.querySelector("h2").textContent = config.title;
  actionGrid.innerHTML = "";

  selected.forEach((item) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "action-card";
    button.innerHTML = `
      <strong>${item.title}</strong>
      <p>${item.body}</p>
      <span class="tag-row">${item.tags.map((tag) => `<span class="tag">${tag}</span>`).join("")}</span>
    `;
    button.addEventListener("click", () => selectAction(item));
    actionGrid.appendChild(button);
  });
}

function renderQuickActions() {
  quickActions.innerHTML = "";
  actions.slice(0, 4).forEach((item) => {
    const button = document.createElement("button");
    button.type = "button";
    button.className = "rail-btn";
    button.textContent = item.title;
    button.addEventListener("click", () => selectAction(item));
    quickActions.appendChild(button);
  });
}

function selectAction(item) {
  title.textContent = item.title;
  response.textContent = item.response;
  command.textContent = item.command;
}

function matchTask(value) {
  const query = value.trim().toLowerCase();
  if (!query) return actions[0];

  return actions.find((item) => {
    return item.title.toLowerCase().includes(query)
      || item.body.toLowerCase().includes(query)
      || item.tags.some((tag) => query.includes(tag))
      || query.includes(item.id);
  }) || keywordFallback(query);
}

function keywordFallback(query) {
  if (query.includes("posta") || query.includes("email") || query.includes("mail")) return actions.find((a) => a.id === "email");
  if (query.includes("installa") || query.includes("install") || query.includes("programma")) return actions.find((a) => a.id === "install");
  if (query.includes("wifi") || query.includes("driver") || query.includes("hardware")) return actions.find((a) => a.id === "hardware");
  if (query.includes("errore") || query.includes("diagn")) return actions.find((a) => a.id === "diagnostics");
  if (query.includes("browser") || query.includes("web")) return actions.find((a) => a.id === "browser");
  return {
    title: "Aurion Assistant",
    response: "Posso preparare un percorso sicuro. Per ora apro la shell Experience e il comando task-assist.",
    command: `aurion-task-assist "${query.replace(/"/g, "")}"`,
    tags: ["ai"]
  };
}

run.addEventListener("click", () => selectAction(matchTask(input.value)));
input.addEventListener("keydown", (event) => {
  if (event.key === "Enter") selectAction(matchTask(input.value));
});

copy.addEventListener("click", async () => {
  try {
    await navigator.clipboard.writeText(command.textContent);
    copy.textContent = "Copied";
    setTimeout(() => {
      copy.textContent = "Copy";
    }, 1200);
  } catch {
    copy.textContent = "Select";
    setTimeout(() => {
      copy.textContent = "Copy";
    }, 1200);
  }
});

document.querySelectorAll(".rail-btn[data-view]").forEach((button) => {
  button.addEventListener("click", () => {
    document.querySelectorAll(".rail-btn[data-view]").forEach((item) => item.classList.remove("is-active"));
    button.classList.add("is-active");
    renderActions(button.dataset.view);
  });
});

document.querySelectorAll("[data-task]").forEach((button) => {
  button.addEventListener("click", () => {
    input.value = button.dataset.task;
    selectAction(matchTask(button.dataset.task));
  });
});

renderQuickActions();
renderActions();
selectAction(actions[0]);
