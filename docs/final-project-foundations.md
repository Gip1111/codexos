# Final-Project Foundations

AurionOS Alpha Fast Track remains a safe ISO remaster, but it now carries the first concrete foundations for the final distribution.

## Desktop and Shell

Current alpha:

- LXQt session remains the stable live desktop.
- `AurionOS LabWC Preview` is available as an experimental Wayland session entry and falls back to LXQt if `labwc` is not installed.
- `AurionOS Native Preview` is available as an experimental X session entry that starts the Aurion window-manager bridge, native topbar, native dock, and native home surface.
- `aurion-window-manager` reports/starts the current labwc/openbox bridge while preserving Openbox fallback.
- `aurion-de-shell` implements native alpha TopBar, Dock, Launcher, Settings, Files, Notifications, Login Preview, and a Desktop Environment hub.
- `aurion-settings`, `aurion-files`, `aurion-notifications`, `aurion-notify`, and `aurion-login-preview` are first-class commands, not browser pages.
- An SDDM theme is installed at `/usr/share/sddm/themes/aurionos-alpha` but is not forced as the live login default yet.
- Packaging metadata for future `.deb` split packages lives under `packaging/aurion-desktop-environment/`.
- AurionOS session metadata and environment branding are applied.
- `aurionos-alpha` LXQt theme, `AurionOS` Openbox theme, top bar, bottom dock, branded icons, desktop shortcuts, and keyboard shortcuts replace the stock Lubuntu desktop feel.
- `aurion-startlxqt`, `aurion-session-guard`, and `aurion-session-watchdog` guard the live session against a cursor-only desktop by restoring missing LXQt panel, desktop, runner, notification, policy kit, power, and shortcut modules.
- `aurion-native-home` is the primary desktop home. It is a native PyQt app, so the normal path no longer depends on Firefox or the QML scene runner.
- `aurion-qml-surface` remains as the secondary Qt/QML bridge and falls back to the stable HTML surfaces when needed.
- `aurion-experience` now opens the native PyQt home surface to avoid browser chrome and Firefox Snap file limitations.
- Store, Hardware, Diagnostics, AI, and Control are integrated as internal native pages rather than separate browser pages.
- `aurion-desktop-check` validates native runtime metadata, QML fallback metadata, first-run routing, desktop launchers, and fallback paths from the live session.
- `aurion-shell`, `aurion-launcher`, `aurion-ai-sidebar`, `aurion-topbar`, and `aurion-dock` now prefer the QML bridge and keep the HTML surfaces as fallback.
- `aurion-experience` provides the first graphical task-oriented shell surface.
- `aurion-hub` generates a local HTML overview report.
- `aurion-control` groups the first system surfaces.
- The shell commands remain alpha foundations, not native compositor components.

Final target:

- Qt6/QML shell components.
- labwc-based early compositor/session path hardened enough to become selectable by default later.
- Packaged Qt6/QML TopBar, Dock, Launcher, AI Sidebar, notifications, power/network controls.

## AI Layer

Current alpha:

- `aurion-assistant` is a mock assistant.
- `aurion-ai-service` can use local Ollama with `phi4-mini` when the user has installed and pulled the model.
- `aurion-ai-setup` explains the optional local setup path, can install Ollama only after confirmation, and can pull the model only after confirmation.
- `aurion-do` provides a safe action runner for common tasks without silent installs, driver changes, or cloud AI.
- `aurion-task-assist` routes common natural-language tasks to safe local actions.
- `aurion-ai-status` reports provider readiness.
- `/usr/share/aurionos/ai/providers/ollama-phi4-mini.json` defines the local-first provider target.
- Cloud AI is disabled by default.

Final target:

- Ollama runtime enable/install flow.
- Preferred local model: `phi4-mini`.
- AI diagnostics explanations using local system context.
- Optional cloud providers only after explicit user opt-in.

## Hardware Compatibility

Current alpha:

- `aurion-hw-scan` provides raw read-only hardware facts.
- `aurion-hardware-center` opens a graphical alpha surface and keeps `--cli` for raw classification from an alpha JSON database.
- No drivers are installed or changed.

Final target:

- Larger hardware database.
- Driver recommendation UI.
- Ubuntu/MOK-compatible proprietary driver flow when needed.
- AI explanations over hardware state and logs.

## App Installation

Current alpha:

- `aurion-store` opens a graphical alpha catalog and keeps `--cli` for terminal testing.
- It does not install packages.
- `aurion-install --explain` documents handler behavior.
- `aurion-appimage-integrate` can integrate an AppImage into the current user's launcher.
- The architecture is Flatpak-first, Snap optional, with future `.deb`, `.flatpakref`, and AppImage flows.

Final target:

- Graphical one-click installs.
- AppImage integration after first run.
- Normal users should not need a terminal for app installation.

## Rollback

Current alpha:

- `aurion-rollback-status` reports current filesystem state.
- `aurion-snapshot-plan` reports Btrfs/Snapper/Timeshift readiness without changing disks.
- No automatic snapshots are created.

Final target:

- Btrfs install profile.
- Snapshot before risky updates.
- Graphical rollback from settings/recovery.

## Release Engineering

Current alpha:

- GitHub Actions builds the ISO.
- Build logs and ISO artifacts are uploaded.
- `/usr/share/aurionos/release/channel.conf` records channel metadata.

Final target:

- Automated VM smoke boot.
- Signed release checksums.
- Release notes generation.
- Stable alpha/beta/stable channel policy.

## Security Boundary

The alpha continues to preserve Ubuntu signed boot components. None of these foundations replace shim, GRUB, kernel, initrd, or add DKMS/proprietary modules to the live ISO.
