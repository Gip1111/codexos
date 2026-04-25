# AurionOS

AurionOS Alpha Fast Track v0.1 is a directly bootable and installable Linux ISO based on Lubuntu 24.04 LTS.

The alpha goal is a credible first ISO, not a finished distribution. Ubuntu/Lubuntu remains the technical base while the visible experience starts moving toward AurionOS.

## Current build target

- Runner: GitHub Actions `ubuntu-24.04`
- Workflow: `.github/workflows/build-iso.yml`
- Artifact: `aurion-os-alpha-iso`
- ISO path: `iso-build/output/aurion-os-0.1-alpha-amd64.iso`
- Base: official Lubuntu 24.04 LTS desktop amd64 ISO

## What v0.1 includes

- Bootable and installable Lubuntu 24.04 LTS based ISO
- Ubuntu signed boot chain preserved
- AurionOS release identity
- AurionOS wallpaper
- AurionOS LXQt session entry
- AurionOS visual profile for LXQt with branded theme, top bar, bottom dock, window theme, icons, desktop shortcuts, and keyboard shortcuts
- Experimental AurionOS LabWC Preview Wayland session with automatic fallback to the stable LXQt session if `labwc` is not installed
- Native PyQt Aurion Experience command center as the first task-oriented desktop home
- Integrated native desktop pages for Store, Hardware, Diagnostics, AI, and Control; QML/Firefox/HTML are fallback paths
- Clickable home actions through the local `aurion-action://` dispatcher for browser, email, files, terminal, installer, AI setup, diagnostics, and rollback
- Guarded LXQt session starter, Xsession guard, and live-session watchdog to recover the desktop if panel or wallpaper modules do not autostart
- Welcome page and first-run live branding hook
- Aurion Shell graphical alpha surface with Launcher, AI Sidebar, Dock concept, app flow, hardware flow, and control flow
- Native PyQt Aurion Experience home surface that avoids browser chrome, plus QML shell bridge, runtime metadata, and HTML fallback
- Aurion Experience graphical alpha shell with task-oriented AI surface
- Aurion Hub generated local HTML system overview
- Aurion Control Center alpha command
- Mock AI assistant foundation
- Safe task runner for email, browser, Store, hardware, diagnostics, AI, and rollback actions
- Task assistant for email, browser, app install, hardware and diagnostics flows
- Ollama/phi4-mini provider metadata, status command, optional local service bridge, and setup helper
- Hardware scanner CLI
- Hardware Center graphical alpha surface plus read-only classification database
- Aurion Diagnostics graphical alpha surface plus CLI report
- Aurion Store graphical alpha catalog and command
- Aurion Install handler foundation for `.deb`, `.flatpakref`, and AppImage flows
- AppImage user launcher integration command
- Diagnostics CLI
- Snapshot planner for future rollback strategy
- Rollback status placeholder
- Release channel metadata
- Build logs artifact

## Live alpha commands

```bash
aurion-status
aurion-shell
aurion-native-home
aurion-qml-surface
aurion-qml-surface --page experience
aurion-launcher
aurion-ai-sidebar
aurion-do email
aurion-do store
aurion-do hardware
aurion-experience
aurion-hub
aurion-action aurion-action://browser
aurion-webapp-open --path /usr/share/aurionos/experience/index.html
aurion-desktop-check
aurion-control
aurion-task-assist "read email"
aurion-hardware-center
aurion-ai-status
aurion-ai-status-gui
aurion-ai-service "check wifi"
aurion-ai-setup --status
aurion-ai-setup --install-ollama
aurion-store
aurion-store --cli
aurion-install --explain
aurion-snapshot-plan
aurion-diagnostics
aurion-diagnostics --cli
aurion-hw-scan
aurion-channel
aurion-rollback-status
aurion-startlabwc --check
```

The guarded session path is `aurion-startlxqt`, with `aurion-session-guard` also launched from `/etc/X11/Xsession.d`. If a live boot shows only a mouse cursor, the ISO is failing the session acceptance test: the expected desktop is wallpaper, top bar, dock, desktop shortcuts, and the native Aurion Experience command surface. The build verifier checks that the guarded starter, first-run launcher, Xsession guard, watchdog, LXQt profile, native PyQt runtime, QML fallback metadata, and PCManFM-Qt wallpaper configuration are present in the ISO.

## Build from GitHub Actions

From Windows, you do not need to install Ubuntu locally.

1. Push the repository to GitHub on branch `main`.
2. Open `Actions`.
3. Run `Build AurionOS Alpha ISO`.
4. Download the `aurion-os-alpha-iso` artifact.

The workflow frees runner disk space, installs ISO tooling, downloads and verifies the Lubuntu base ISO, remasters it, and uploads the resulting ISO.

## Secure Boot policy

AurionOS v0.1 preserves Ubuntu's signed Secure Boot flow. The build does not replace shim, signed GRUB, the Ubuntu signed kernel, or the live initrd. The build script hashes critical boot files before and after branding and fails if they change.

## Documentation

- `docs/iso-build-plan.md`
- `docs/secure-boot-strategy.md`
- `docs/alpha-scope.md`
- `docs/testing-guide.md`
- `docs/final-project-foundations.md`
- `docs/visual-design.md`
- `docs/aurionos-home-target.svg`
- `docs/aurionos-home-preview.png`
