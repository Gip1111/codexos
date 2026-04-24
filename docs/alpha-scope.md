# AurionOS Alpha Fast Track v0.1 Scope

## Included

- Bootable amd64 live ISO
- Installable Lubuntu 24.04 LTS base
- Ubuntu signed boot chain preserved
- AurionOS release identity
- AurionOS wallpaper placeholder
- AurionOS LXQt session entry
- Branded live environment defaults
- Safer installer text rebranding where present
- Mock AI assistant
- Hardware scanner CLI
- Diagnostics CLI
- One-command `aurion-status` live validation helper
- Rollback status placeholder
- GitHub Actions build workflow
- Build logs artifact

## Mocked

- AI responses
- Hardware compatibility explanations
- Shell TopBar, Dock, Launcher, and AI Sidebar behavior
- Rollback automation
- App store and one-click installer

## Incomplete

- Final logo and visual system
- Active custom Plymouth boot splash
- labwc Aurion session
- Qt6/QML shell
- Full Calamares theme replacement
- Graphical hardware compatibility center
- Ollama runtime integration
- App store
- Btrfs snapshot automation

## App installation direction

The alpha does not build the Aurion Store yet. The target architecture is:

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
7. Replace placeholders with Qt6/QML shell prototypes.

## Acceptance criteria

AurionOS Alpha Fast Track v0.1 is accepted only when:

- GitHub Actions completes successfully.
- `aurion-os-alpha-iso` artifact is produced.
- `iso-build/output/aurion-os-0.1-alpha-amd64.iso` exists in the artifact.
- ISO boots in UEFI mode.
- ISO preserves Ubuntu Secure Boot compatibility.
- Live session starts.
- AurionOS branding is visible.
- Installer launches.
- Installed system boots.
- Build logs are available.
- Docs explain what works and what is deferred.
