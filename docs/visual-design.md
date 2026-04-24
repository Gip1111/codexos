# AurionOS Visual Direction

AurionOS must not look like stock Lubuntu. The alpha visual profile is intentionally bold but still safe for a live ISO.

## Alpha implementation

- AurionOS wallpaper.
- Aurion Experience as the first visible graphical surface.
- LXQt theme `aurionos-alpha`.
- Dark top bar with Aurion menu.
- Bottom dock with Experience, browser, file manager, terminal, installer.
- Openbox theme `AurionOS`.
- Branded hicolor SVG icons for AurionOS, Experience, Assistant, Store, Hardware, and Snapshot.
- Desktop shortcuts for Experience, Store, and installer.
- Keyboard shortcuts:
  - `Super+Space`: Aurion Experience
  - `Super+A`: Aurion Assistant
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
- `/etc/skel/.config/lxqt/`
- `/etc/skel/.config/openbox/lxqt-rc.xml`
- `/etc/skel/Desktop/`
