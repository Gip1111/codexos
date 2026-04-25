# Final-Project Foundations

AurionOS Alpha Fast Track remains a safe ISO remaster, but it now carries the first concrete foundations for the final distribution.

## Desktop and Shell

Current alpha:

- LXQt session remains the stable live desktop.
- `AurionOS LabWC Preview` is available as an experimental Wayland session entry and falls back to LXQt if `labwc` is not installed.
- AurionOS session metadata and environment branding are applied.
- `aurionos-alpha` LXQt theme, `AurionOS` Openbox theme, top bar, bottom dock, branded icons, desktop shortcuts, and keyboard shortcuts replace the stock Lubuntu desktop feel.
- `aurion-startlxqt`, `aurion-session-guard`, and `aurion-session-watchdog` guard the live session against a cursor-only desktop by restoring missing LXQt panel, desktop, runner, notification, policy kit, power, and shortcut modules.
- `aurion-qml-surface` adds the first Qt/QML bridge for the future native shell and falls back to the stable HTML surfaces when no QML runtime is available.
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
- `aurion-ai-setup` explains the optional local setup path and can pull the model only after confirmation.
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
