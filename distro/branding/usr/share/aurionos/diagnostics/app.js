const checks = [
  {
    title: "Boot mode",
    body: "UEFI o legacy BIOS, utile per verificare il percorso di avvio.",
    state: "report",
    warn: false,
    action: "diagnostics-report"
  },
  {
    title: "Secure Boot",
    body: "Legge mokutil quando disponibile senza cambiare chiavi o bootloader.",
    state: "safe",
    warn: false,
    action: "diagnostics-report"
  },
  {
    title: "Sessione desktop",
    body: "Controlla variabili LXQt/Aurion e presenza dei componenti sessione.",
    state: "live",
    warn: false,
    action: "status-report"
  },
  {
    title: "Installer",
    body: "Verifica che Calamares sia disponibile nella live.",
    state: "installabile",
    warn: false,
    action: "diagnostics-report"
  },
  {
    title: "Disco",
    body: "Mostra spazio e filesystem senza montaggi o modifiche rischiose.",
    state: "read-only",
    warn: false,
    action: "diagnostics-report"
  },
  {
    title: "Errori recenti",
    body: "Raccoglie le ultime righe journalctl di priorita errore.",
    state: "debug",
    warn: true,
    action: "diagnostics-report"
  }
];

const grid = document.querySelector("#check-grid");

function openAction(action) {
  window.location.href = `aurion-action://${encodeURIComponent(action)}`;
}

checks.forEach((item) => {
  const button = document.createElement("button");
  button.type = "button";
  button.className = "check-card";
  button.innerHTML = `
    <span class="status${item.warn ? " warn" : ""}">${item.state}</span>
    <strong>${item.title}</strong>
    <p>${item.body}</p>
  `;
  button.addEventListener("click", () => openAction(item.action));
  grid.appendChild(button);
});

document.querySelectorAll("[data-action]").forEach((button) => {
  button.addEventListener("click", () => openAction(button.dataset.action));
});
