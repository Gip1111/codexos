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
- Welcome page and first-run live branding hook
- Aurion Experience graphical alpha shell with task-oriented AI surface
- Aurion Hub generated local HTML system overview
- Aurion Control Center alpha command
- Mock AI assistant foundation
- Task assistant for email, browser, app install, hardware and diagnostics flows
- Ollama/phi4-mini provider metadata and status command
- Hardware scanner CLI
- Hardware Center alpha classification database
- Aurion Store alpha catalog and command
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
aurion-experience
aurion-hub
aurion-control
aurion-task-assist "read email"
aurion-hardware-center
aurion-ai-status
aurion-store
aurion-install --explain
aurion-snapshot-plan
aurion-diagnostics
aurion-hw-scan
aurion-channel
aurion-rollback-status
```

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
