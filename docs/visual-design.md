# AurionOS Visual Direction

AurionOS must not look like stock Lubuntu. The alpha visual profile is intentionally bold but still safe for a live ISO.

## Alpha implementation

- Dark AurionOS wallpaper with teal/gold motion lines, no large centered Lubuntu-style identity block.
- Aurion Experience as the first visible graphical home surface.
- Home target preview: `docs/aurionos-home-target.svg`.
- Rendered current preview: `docs/aurionos-home-preview.png`.
- LXQt theme `aurionos-alpha`.
- Dark top bar with Aurion menu, workspace controls, and system status.
- Bottom dock with Experience, browser, file manager, terminal, Store, installer, and AI Assistant.
- Home buttons and dock entries use real icon assets and route through the local `aurion-action://` handler.
- Aurion Store, Hardware Center, and Diagnostics now open graphical offline surfaces instead of only terminal output.
- Web surfaces are opened through `aurion-webapp-open`, which copies them into `~/AurionOSWeb` first so Firefox Snap can render them on real live media.
- Openbox theme `AurionOS`.
- Branded hicolor SVG icons for AurionOS, Experience, Assistant, Store, Hardware, and Snapshot.
- Desktop shortcuts for Launcher, Experience, Store, and installer.
- Local Aurion Shell surface with Launcher, AI Sidebar, app install flow, hardware flow, and control flow.
- Qt/QML shell bridge at `/usr/share/aurionos/qml/AurionShell.qml` for the native desktop direction.
- Keyboard shortcuts:
  - `Super+Space`: Aurion Launcher
  - `Super+E`: Aurion Experience
  - `Super+A`: Aurion AI Sidebar
  - `Super+S`: Aurion Store
  - `Super+H`: Hardware Center

## Product goal

The final desktop should feel direct and task-oriented:

- type or click what you want to do
- AI suggests the safest action
- app install does not require a terminal
- hardware and diagnostics are understandable
- advanced actions require confirmation
- the first screen should look like an Aurion desktop, not a Lubuntu remaster

## Future native shell

The alpha uses LXQt configuration, a QML bridge, and local HTML fallbacks. The target is a packaged Qt6/QML shell with:

- native top bar
- native dock
- native launcher
- AI sidebar
- settings/control center
- app store
- hardware center
- diagnostics

## Experimental LabWC Session

`AurionOS LabWC Preview` is installed as a non-default Wayland session entry. It is intentionally fallback-safe: if `labwc` is not present, `aurion-startlabwc` returns to the stable LXQt session instead of leaving the user at a broken desktop.

## Files

- `/usr/share/lxqt/themes/aurionos-alpha/`
- `/usr/share/themes/AurionOS/openbox-3/themerc`
- `/usr/share/icons/hicolor/scalable/apps/aurion*.svg`
- `/usr/share/aurionos/shell/`
- `/usr/share/aurionos/experience/`
- `/etc/skel/.config/lxqt/`
- `/etc/skel/.config/openbox/lxqt-rc.xml`
- `/etc/skel/Desktop/`
