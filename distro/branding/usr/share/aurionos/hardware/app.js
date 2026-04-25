const devices = [
  {
    title: "GPU",
    detail: "Rileva Intel, AMD e NVIDIA senza cambiare driver nella live.",
    state: "read-only",
    warn: false,
    action: "hardware-scan"
  },
  {
    title: "Wi-Fi",
    detail: "Mostra chipset e note driver. Utile per problemi di connessione.",
    state: "verifica",
    warn: false,
    action: "hardware-scan"
  },
  {
    title: "Secure Boot",
    detail: "Controlla lo stato con mokutil quando disponibile.",
    state: "preservato",
    warn: false,
    action: "diagnostics-report"
  },
  {
    title: "Audio",
    detail: "Base per futuri controlli PipeWire/PulseAudio.",
    state: "alpha",
    warn: true,
    action: "diagnostics-report"
  },
  {
    title: "Storage",
    detail: "Controlla spazio e tipo filesystem senza modifiche.",
    state: "safe",
    warn: false,
    action: "status-report"
  },
  {
    title: "Rollback",
    detail: "Mostra la base snapshot prevista per il sistema installato.",
    state: "planned",
    warn: true,
    action: "backup"
  }
];

const known = [
  ["Intel iGPU", "supportato dal kernel", "Driver i915 upstream."],
  ["NVIDIA GK208M", "nouveau live, proprietario dopo MOK", "Nessun modulo proprietario nella live."],
  ["Qualcomm Atheros AR9485", "supportato dal kernel", "Famiglia ath9k."],
  ["Realtek RTL8111", "supportato dal kernel", "Percorso r8169 comune."]
];

const grid = document.querySelector("#device-grid");
const list = document.querySelector("#compat-list");

function openAction(action) {
  window.location.href = `aurion-action://${encodeURIComponent(action)}`;
}

devices.forEach((item) => {
  const card = document.createElement("button");
  card.type = "button";
  card.className = "device-card";
  card.innerHTML = `
    <span class="badge${item.warn ? " warn" : ""}">${item.state}</span>
    <strong>${item.title}</strong>
    <p>${item.detail}</p>
  `;
  card.addEventListener("click", () => openAction(item.action));
  grid.appendChild(card);
});

known.forEach(([name, state, note]) => {
  const item = document.createElement("article");
  item.className = "compat-item";
  item.innerHTML = `
    <div>
      <strong>${name}</strong>
      <p>${note}</p>
    </div>
    <span>${state}</span>
  `;
  list.appendChild(item);
});

document.querySelectorAll("[data-action]").forEach((button) => {
  button.addEventListener("click", () => openAction(button.dataset.action));
});
