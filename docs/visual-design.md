# AurionOS Visual Direction

AurionOS must not look like stock Lubuntu. The alpha visual profile is intentionally bold but still safe for a live ISO.

## Alpha implementation

- AurionOS wallpaper.
- Aurion Experience as the first visible graphical surface.
- LXQt theme `aurionos-alpha`.
- Dark top bar with Aurion menu.
- Bottom dock with Launcher, Experience, browser, file manager, Store, installer.
- Openbox theme `AurionOS`.
- Branded hicolor SVG icons for AurionOS, Experience, Assistant, Store, Hardware, and Snapshot.
- Desktop shortcuts for Launcher, Experience, Store, and installer.
- Local Aurion Shell surface with Launcher, AI Sidebar, app install flow, hardware flow, and control flow.
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

## Future native shell

The alpha uses LXQt configuration and local HTML surfaces. The target is a Qt6/QML shell with:

- native top bar
- native dock
- native launcher
- AI sidebar
- settings/control center
- app store
- hardware center

## Files

- `/usr/share/lxqt/themes/aurionos-alpha/`
- `/usr/share/themes/AurionOS/openbox-3/themerc`
- `/usr/share/icons/hicolor/scalable/apps/aurion*.svg`
- `/usr/share/aurionos/shell/`
- `/etc/skel/.config/lxqt/`
- `/etc/skel/.config/openbox/lxqt-rc.xml`
- `/etc/skel/Desktop/`
