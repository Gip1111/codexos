# AurionOS Shell Foundation

AurionOS Alpha v0.1 keeps the Lubuntu LXQt session as the stable live desktop and ships early graphical shell surfaces.

The intended path is:

- stable LXQt fallback until the Aurion shell can survive real live media testing
- native PyQt alpha layer for the first complete DE blocks
- Qt6/QML top bar, dock, launcher, and AI sidebar after packaging hardening
- labwc based experimental session after the native layer is proven

Current alpha commands:

- `aurion-de-shell --mode desktop`
- `aurion-shell`
- `aurion-qml-surface`
- `aurion-launcher`
- `aurion-ai-sidebar`
- `aurion-topbar`
- `aurion-dock`

`aurion-launcher`, `aurion-topbar`, and `aurion-dock` now open native PyQt alpha components. `aurion-qml-surface` remains a secondary bridge at `/usr/share/aurionos/qml/AurionShell.qml`; local offline HTML remains the final fallback.

`AurionOS LabWC Preview` is also shipped as an experimental Wayland session entry. It is not the default session and falls back to LXQt if `labwc` is unavailable.
