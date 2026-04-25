# AurionOS Alpha Fast Track v0.1 Scope

## Included

- Bootable amd64 live ISO
- Installable Lubuntu 24.04 LTS base
- Ubuntu signed boot chain preserved
- AurionOS release identity
- AurionOS wallpaper
- AurionOS LXQt session entry
- AurionOS LXQt visual profile with branded panel theme, dark top bar, bottom dock, Openbox theme, icon set, desktop shortcuts, and keyboard shortcuts
- AurionOS LabWC Preview session entry with safe LXQt fallback when `labwc` is not installed
- AurionOS Native Preview session entry with native topbar, dock, home surface, and Openbox fallback
- Aurion window-manager bridge
- Native Aurion TopBar alpha
- Native Aurion Dock alpha
- Native Aurion Launcher alpha
- Native Aurion Settings alpha
- Native Aurion Files alpha
- Native Aurion Notifications alpha
- Aurion SDDM login theme preview
- Aurion desktop packaging manifest
- Guarded LXQt starter, Xsession guard, and session watchdog to recover panel, desktop, runner, notifications, policy kit, power management, and global shortcut modules if LXQt autostart is incomplete
- Welcome page and first-run live branding hook
- Aurion Shell graphical alpha surface with Launcher, AI Sidebar, Dock concept, app flow, hardware flow, and control flow
- Native PyQt Aurion Experience home surface, plus Qt/QML shell bridge and HTML fallback
- Integrated native Store, Hardware, Diagnostics, AI, and Control pages inside Aurion Experience
- Aurion Experience graphical alpha shell styled as the first desktop home/command center
- Clickable Aurion Experience actions for browser, email, file manager, terminal, Store, installer, AI assistant, hardware checks, diagnostics, and rollback through the local `aurion-action://` handler
- Aurion Hub generated local HTML report
- Branded live environment defaults
- Safer installer text rebranding where present
- Aurion Control Center alpha command
- Mock AI assistant
- Safe task runner for email, browser, Store, hardware, diagnostics, AI, and rollback actions
- Task assistant routing for browser, email, app install, hardware, diagnostics, and rollback tasks
- Ollama/phi4-mini provider metadata, AI status command, optional local service bridge, and setup helper
- Hardware scanner CLI
- Hardware Center graphical alpha surface and alpha classification database
- Diagnostics graphical alpha surface and CLI report
- One-command `aurion-status` live validation helper
- Aurion Store graphical alpha catalog and command
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

- AI responses when Ollama/phi4-mini is not installed locally
- AI natural language handling beyond the optional local Ollama bridge and rule-based task routing
- Hardware compatibility explanations beyond the small alpha database and static GUI
- Native Qt6/QML TopBar, Dock, Launcher, and AI Sidebar behavior beyond the PyQt command center, QML bridge, and LXQt alpha panels
- Rollback automation
- Real app installation from Aurion Store
- Full trusted package verification and GUI confirmation flow

## Incomplete

- Final logo, animation system, and complete visual identity
- Active custom Plymouth boot splash
- labwc installed and enabled as a complete daily-driver session
- Complete Qt6/QML shell package beyond the alpha PyQt command center
- Full Calamares theme replacement
- Production Qt6/QML replacements for Store, Hardware Center, Diagnostics, and AI setup
- Bundled Ollama runtime or unattended model manager
- Production App Store backend and installers
- Btrfs snapshot automation
- Making the Native Preview session the default before real-hardware soak testing
- Full notification daemon replacement with DBus ownership
- Full compositor replacement beyond labwc/openbox bridge

## App installation direction

The alpha now includes an Aurion Store graphical catalog, but it does not install packages yet. The target architecture is:

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
6. Install and harden labwc only after the preview session is proven safe.
7. Replace the QML bridge with packaged Qt6/QML applications and a full shell runtime.
8. Harden the optional Ollama install/enable flow for `phi4-mini`.

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
- Stable session remains LXQt unless the user explicitly chooses LabWC Preview.
- Installer launches.
- Installed system boots.
- `aurion-status`, `aurion-control`, `aurion-hardware-center`, `aurion-ai-status`, `aurion-ai-service`, `aurion-ai-setup`, and `aurion-store` run in the live session.
- `aurion-shell`, `aurion-launcher`, `aurion-ai-sidebar`, `aurion-experience`, `aurion-hub`, `aurion-install --explain`, and `aurion-snapshot-plan` run in the live session.
- CI verifies the built ISO contains required AurionOS tools, metadata, welcome page, and catalogs.
- Build logs are available.
- Docs explain what works and what is deferred.
