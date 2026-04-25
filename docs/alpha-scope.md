# AurionOS Alpha Fast Track v0.1 Scope

## Included

- Bootable amd64 live ISO
- Installable Lubuntu 24.04 LTS base
- Ubuntu signed boot chain preserved
- AurionOS release identity
- AurionOS wallpaper
- AurionOS LXQt session entry
- AurionOS LXQt visual profile with branded panel theme, dark top bar, bottom dock, Openbox theme, icon set, desktop shortcuts, and keyboard shortcuts
- Guarded LXQt starter, Xsession guard, and session watchdog to recover panel, desktop, runner, notifications, policy kit, power management, and global shortcut modules if LXQt autostart is incomplete
- Welcome page and first-run live branding hook
- Aurion Shell graphical alpha surface with Launcher, AI Sidebar, Dock concept, app flow, hardware flow, and control flow
- Aurion Experience graphical alpha shell styled as the first desktop home/command center
- Clickable Aurion Experience actions for browser, email, file manager, terminal, Store, installer, AI assistant, hardware checks, diagnostics, and rollback through the local `aurion-action://` handler
- Aurion Hub generated local HTML report
- Branded live environment defaults
- Safer installer text rebranding where present
- Aurion Control Center alpha command
- Mock AI assistant
- Safe task runner for email, browser, Store, hardware, diagnostics, AI, and rollback actions
- Task assistant routing for browser, email, app install, hardware, diagnostics, and rollback tasks
- Ollama/phi4-mini provider metadata and AI status command
- Hardware scanner CLI
- Hardware Center alpha classification database
- Diagnostics CLI
- One-command `aurion-status` live validation helper
- Aurion Store alpha catalog and command
- Aurion Install handler foundation
- AppImage user launcher integration flow
- Release channel metadata
- Snapshot planner for rollback readiness
- Rollback status placeholder
- GitHub Actions build workflow
- Build logs artifact
- CI ISO content verification for required AurionOS payload files
- CI ISO content verification for the guarded live session, LXQt module defaults, and PCManFM-Qt wallpaper settings

## Mocked

- AI responses
- AI natural language handling beyond rule-based task routing
- Hardware compatibility explanations beyond the small alpha database
- Native Qt6/QML TopBar, Dock, Launcher, and AI Sidebar behavior beyond the HTML/LXQt alpha surfaces
- Rollback automation
- Real app installation from Aurion Store
- Full trusted package verification and GUI confirmation flow

## Incomplete

- Final logo, animation system, and complete visual identity
- Active custom Plymouth boot splash
- labwc Aurion session
- Qt6/QML shell
- Full Calamares theme replacement
- Graphical hardware compatibility center
- Ollama runtime integration
- Production App Store backend and installers
- Btrfs snapshot automation

## App installation direction

The alpha now includes an Aurion Store catalog command, but it does not install packages yet. The target architecture is:

- Flatpak-first graphical app installation.
- Snap remains optional for the MVP and is not aggressively removed in v0.1.
- Graphical `.deb` install flow for trusted local packages.
- Graphical `.flatpakref` install flow through the store or handler.
- AppImage flow: run once, offer integration, add launcher entry.
- No terminal required for normal app installation.

## Next milestones

1. Produce and boot the ISO from GitHub Actions.
2. Verify UEFI and Secure Boot boot paths.
3. Verify live session branding.
4. Verify installer launch and installed-system boot.
5. Add QEMU smoke test automation.
6. Add a labwc experimental session.
7. Replace Control Center, Store, Hardware Center, and AI status commands with Qt6/QML applications.
8. Add optional Ollama install/enable flow for `phi4-mini`.

## Acceptance criteria

AurionOS Alpha Fast Track v0.1 is accepted only when:

- GitHub Actions completes successfully.
- `aurion-os-alpha-iso` artifact is produced.
- `iso-build/output/aurion-os-0.1-alpha-amd64.iso` exists in the artifact.
- ISO boots in UEFI mode.
- ISO preserves Ubuntu Secure Boot compatibility.
- Live session starts.
- AurionOS branding is visible.
- AurionOS top bar, bottom dock, desktop shortcuts, icons, and Experience command center are visible.
- Installer launches.
- Installed system boots.
- `aurion-status`, `aurion-control`, `aurion-hardware-center`, `aurion-ai-status`, and `aurion-store` run in the live session.
- `aurion-shell`, `aurion-launcher`, `aurion-ai-sidebar`, `aurion-experience`, `aurion-hub`, `aurion-install --explain`, and `aurion-snapshot-plan` run in the live session.
- CI verifies the built ISO contains required AurionOS tools, metadata, welcome page, and catalogs.
- Build logs are available.
- Docs explain what works and what is deferred.
