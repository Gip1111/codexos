# AurionOS Alpha ISO Build Plan

## Revised architecture summary

Base choice: Lubuntu 24.04 LTS desktop amd64. It keeps the Ubuntu 24.04 package base, provides a light LXQt desktop, and is close enough to the future Qt/QML direction for a credible first alpha.

ISO strategy: remaster the official Lubuntu 24.04 desktop ISO in GitHub Actions. The build downloads the current official Noble release ISO, verifies it with `SHA256SUMS`, extracts the ISO, unsquashes the live filesystem, applies AurionOS files, rebuilds only the squashfs, and writes a new ISO.

Secure Boot strategy: preserve the signed Ubuntu boot chain. The build does not replace shim, signed GRUB, the signed Ubuntu kernel, or the live initrd. It hashes critical boot files before and after branding and fails if they change.

Live session strategy: ship an `AurionOS` LXQt session entry, live-session branding, a guarded `aurion-startlxqt` wrapper, an Xsession guard, a session watchdog, a custom LXQt visual profile, top bar, bottom dock, desktop shortcuts, keyboard shortcuts, and local graphical Aurion Shell/Experience surfaces. LXQt remains the stable desktop foundation for v0.1. The future labwc/Qt shell is represented by safe HTML alpha surfaces and command entry points.

Installer strategy: keep the Lubuntu Calamares installer. Safe text rebranding is applied where present. No custom installer is attempted in v0.1.

Branding strategy: set AurionOS release identity, issue text, MOTD, wallpaper, application launchers, session metadata, LXQt theme, Openbox theme, Aurion icons, ISO menu text, welcome page, and docs. Plymouth theme files are included but not enabled because enabling them would require boot/initrd changes that are not worth the alpha risk.

AI strategy: include a provider-agnostic mock assistant, safe task runner, AI provider metadata, and `aurion-ai-status`. The later default local provider target is Ollama with `phi4-mini`. Cloud AI remains disabled by default and must be opt-in.

Hardware strategy: include a read-only hardware scanner, diagnostics command, Hardware Center alpha command, and a small JSON classification database. No DKMS, proprietary modules, or driver mutation is performed in the live ISO.

App strategy: include an Aurion Store alpha command and catalog. It is list-only in v0.1 and documents the Flatpak-first, Snap-optional, `.deb`, `.flatpakref`, and AppImage integration path.

Control Center strategy: include `aurion-control`, a terminal-safe grouping surface for status, hardware, AI, app catalog, diagnostics, and rollback. Final target is Qt6/QML.

Hub strategy: include `aurion-hub`, a generated local HTML overview that gives the alpha a graphical system surface without adding new live ISO package dependencies. Final target is a Qt6/QML application.

Experience strategy: include `aurion-experience`, a local graphical task shell that becomes the default visible first-run surface. It combines AI task routing, app install paths, browser/email actions, hardware checks, and recovery status in one place without adding runtime package risk.

Shell strategy: include `aurion-shell`, `aurion-launcher`, `aurion-ai-sidebar`, `aurion-topbar`, and `aurion-dock`. These open the local offline Aurion Shell alpha page so the ISO has a visible Launcher, AI Sidebar, Dock concept, app workflow, hardware workflow, and control workflow before the native Qt6/QML shell exists.

GitHub Actions strategy: build on `ubuntu-24.04`, free disk space, install ISO tools, run the build script, clearly fail if the expected ISO is absent, upload the ISO artifact, and upload logs even on failure.

## Must do today

- Build from Lubuntu 24.04 LTS desktop amd64.
- Preserve signed boot files and fail if critical boot hashes change.
- Produce `iso-build/output/aurion-os-0.1-alpha-amd64.iso`.
- Upload artifact as `aurion-os-alpha-iso`.
- Add visible AurionOS branding, wallpaper, session entry, release files, welcome, and docs.
- Add the AurionOS LXQt visual profile so the live desktop no longer looks like stock Lubuntu.
- Add a guarded LXQt session starter, Xsession guard, and session watchdog so a missing autostart module does not leave the user at a cursor-only desktop.
- Keep Calamares installer stable.
- Include build logs as an artifact.
- Include alpha foundations for Control Center, AI provider, Hardware Center, Store, diagnostics, and release channel.
- Include alpha foundations for app install handling, AppImage integration, Hub report, and snapshot planning.
- Include the graphical Aurion Experience shell and task assistant routing for common desktop work.
- Include the graphical Aurion Shell surface for launcher, AI sidebar, dock, apps, hardware, and control center flows.
- Include first-boot desktop affordances for email/browser, app install, hardware checks, diagnostics, and AI status.

## Repository structure

```text
.github/workflows/build-iso.yml
iso-build/
iso-build/build-iso.sh
iso-build/setup-builder.sh
iso-build/hooks/
iso-build/output/
distro/
distro/branding/
distro/wallpapers/
distro/plymouth/
distro/session/
shell/
shell/bin/
control-center/
ai-services/
hardware-compat/
app-store/
app-installer/
hub/
rollback/
diagnostics/
docs/
```

Important payload files:

- `distro/wallpapers/aurionos-alpha.svg`
- `distro/session/aurionos-lxqt.desktop`
- `distro/session/scripts/aurion-apply-live-branding`
- `distro/session/scripts/aurion-startlxqt`
- `distro/session/scripts/aurion-session-guard`
- `distro/session/scripts/aurion-session-watchdog`
- `distro/session/xsession/80aurionos-session-guard`
- `distro/session/autostart/aurion-session-watchdog.desktop`
- `distro/branding/usr/share/aurionos/welcome/index.html`
- `control-center/aurion-control`
- `ai-services/aurion-assistant`
- `ai-services/aurion-ai-status`
- `hardware-compat/aurion-hw-scan`
- `hardware-compat/aurion-hardware-center`
- `app-store/aurion-store`
- `app-installer/aurion-install`
- `app-installer/aurion-appimage-integrate`
- `hub/aurion-hub`
- `experience/aurion-experience`
- `ai-services/aurion-task-assist`
- `rollback/aurion-snapshot-plan`
- `diagnostics/aurion-status`
- `diagnostics/aurion-diagnostics`
- `diagnostics/aurion-rollback-status`

## Build dependency package list

Installed by `iso-build/setup-builder.sh` on the `ubuntu-24.04` runner:

```text
ca-certificates
coreutils
curl
dpkg-dev
file
findutils
gawk
gnupg
grep
jq
librsvg2-bin
p7zip-full
rsync
sed
squashfs-tools
syslinux-utils
util-linux
xorriso
```

## Should do if stable

- Improve Calamares branding after verifying the exact Lubuntu 24.04 Calamares branding layout.
- Add an experimental labwc session package only after the remaster build is green.
- Replace shell/control/store/hardware placeholders with Qt6/QML prototypes.
- Add VM smoke testing in CI with QEMU once the ISO artifact is reliably produced.

## Defer

- Custom compositor.
- Full custom installer.
- Production app store and package installation.
- Full settings app.
- Complete file manager.
- Automatic rollback.
- Large hardware/driver intelligence database.
- Ollama model download inside the ISO.

## Unsafe for alpha

- Replacing shim or signed GRUB.
- Replacing the stock Ubuntu signed kernel.
- Rebuilding boot images without a tested Secure Boot signing plan.
- Adding DKMS or proprietary kernel modules to the live image.
- Removing Snap aggressively before base install behavior is known.
- Replacing Calamares for v0.1.
