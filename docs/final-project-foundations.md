# Final-Project Foundations

AurionOS Alpha Fast Track remains a safe ISO remaster, but it now carries the first concrete foundations for the final distribution.

## Desktop and Shell

Current alpha:

- LXQt session remains the stable live desktop.
- AurionOS session metadata and environment branding are applied.
- `aurionos-alpha` LXQt theme, `AurionOS` Openbox theme, top bar, bottom dock, branded icons, desktop shortcuts, and keyboard shortcuts replace the stock Lubuntu desktop feel.
- `aurion-experience` provides the first graphical task-oriented shell surface.
- `aurion-hub` generates a local HTML overview report.
- `aurion-control` groups the first system surfaces.
- Shell placeholders remain in `shell/bin/`.

Final target:

- Qt6/QML shell components.
- labwc-based early compositor/session path.
- TopBar, Dock, Launcher, AI Sidebar, notifications, power/network controls.

## AI Layer

Current alpha:

- `aurion-assistant` is a mock assistant.
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
- `aurion-hardware-center` adds basic classification from an alpha JSON database.
- No drivers are installed or changed.

Final target:

- Larger hardware database.
- Driver recommendation UI.
- Ubuntu/MOK-compatible proprietary driver flow when needed.
- AI explanations over hardware state and logs.

## App Installation

Current alpha:

- `aurion-store` lists an alpha catalog.
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
