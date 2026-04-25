const iconBase = "../../icons/hicolor/scalable/apps/";

const apps = [
  {
    name: "Firefox",
    category: "browser",
    source: "Snap oggi, Flatpak-ready",
    icon: "aurion-browser.svg",
    body: "Navigazione web e accesso a Gmail, Outlook e servizi online.",
    action: "browser"
  },
  {
    name: "LibreOffice",
    category: "office",
    source: "Ubuntu deb o Flatpak",
    icon: "aurion-files.svg",
    body: "Documenti, fogli di calcolo e presentazioni senza configurazione complessa.",
    action: "install-libreoffice"
  },
  {
    name: "VLC Media Player",
    category: "media",
    source: "Flatpak target",
    icon: "aurion-store.svg",
    body: "Lettore multimediale universale. In alpha apre il flusso guidato.",
    action: "install-vlc"
  },
  {
    name: "OBS Studio",
    category: "media",
    source: "Flatpak target",
    icon: "aurion-store.svg",
    body: "Registrazione schermo e streaming con profili pronti per creator.",
    action: "install-obs"
  },
  {
    name: "GIMP",
    category: "creative",
    source: "Flatpak target",
    icon: "aurion-files.svg",
    body: "Editing immagini e grafica raster, installazione guidata in futuro.",
    action: "install-gimp"
  },
  {
    name: "Visual Studio Code",
    category: "development",
    source: "deb o Flatpak",
    icon: "aurion-terminal.svg",
    body: "Ambiente sviluppo con revisione sorgente prima di installare pacchetti esterni.",
    action: "install-code"
  },
  {
    name: "Thunderbird",
    category: "office",
    source: "Snap o Flatpak",
    icon: "aurion-browser.svg",
    body: "Client email locale per chi non vuole usare webmail nel browser.",
    action: "install-thunderbird"
  },
  {
    name: "Bitwarden",
    category: "security",
    source: "Flatpak target",
    icon: "aurion-assistant.svg",
    body: "Password manager con installazione esplicita e confermata dall'utente.",
    action: "install-bitwarden"
  }
];

const catalog = document.querySelector("#catalog");
const search = document.querySelector("#search");
const filterButtons = [...document.querySelectorAll("[data-filter]")];
let activeFilter = "all";

function actionUrl(action) {
  return `aurion-action://${encodeURIComponent(action)}`;
}

function openAction(action) {
  window.location.href = actionUrl(action);
}

function render() {
  const query = search.value.trim().toLowerCase();
  catalog.innerHTML = "";

  apps
    .filter((app) => activeFilter === "all" || app.category === activeFilter)
    .filter((app) => !query || `${app.name} ${app.category} ${app.body}`.toLowerCase().includes(query))
    .forEach((app) => {
      const card = document.createElement("article");
      card.className = "app-card";
      card.innerHTML = `
        <img src="${iconBase}${app.icon}" alt="">
        <div>
          <h3>${app.name}</h3>
          <p>${app.body}</p>
          <div class="meta">
            <span>${app.category}</span>
            <span>${app.source}</span>
          </div>
        </div>
        <div class="actions">
          <button class="secondary" type="button" data-action="ai">Chiedi info</button>
          <button type="button" data-action="${app.action}">Installa</button>
        </div>
      `;
      card.querySelectorAll("[data-action]").forEach((button) => {
        button.addEventListener("click", () => openAction(button.dataset.action));
      });
      catalog.appendChild(card);
    });
}

filterButtons.forEach((button) => {
  button.addEventListener("click", () => {
    activeFilter = button.dataset.filter;
    filterButtons.forEach((item) => item.classList.toggle("is-active", item === button));
    render();
  });
});

document.querySelectorAll("button[data-action]").forEach((button) => {
  button.addEventListener("click", () => openAction(button.dataset.action));
});

search.addEventListener("input", render);
render();
