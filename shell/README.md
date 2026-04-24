# AurionOS Shell Foundation

AurionOS Alpha v0.1 keeps the Lubuntu LXQt session as the stable live desktop and ships early graphical shell surfaces.

The intended path is:

- labwc based experimental session after the first ISO proves boot and install flow
- Qt6/QML top bar, dock, launcher, and AI sidebar
- stable LXQt fallback until the Aurion shell can survive real live media testing

Current alpha commands:

- `aurion-shell`
- `aurion-launcher`
- `aurion-ai-sidebar`
- `aurion-topbar`
- `aurion-dock`

These open a local offline HTML shell at `/usr/share/aurionos/shell/index.html`. It is not the final shell, but it gives the ISO a real graphical Launcher, AI Sidebar, Dock concept, Control Center surface, and app/hardware task flow without adding risky compositor dependencies.
