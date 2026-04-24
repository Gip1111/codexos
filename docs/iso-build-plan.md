# AurionOS Alpha ISO Build Plan

## Revised architecture summary

Base choice: Lubuntu 24.04 LTS desktop amd64. It keeps the Ubuntu 24.04 package base, provides a light LXQt desktop, and is close enough to the future Qt/QML direction for a credible first alpha.

ISO strategy: remaster the official Lubuntu 24.04 desktop ISO in GitHub Actions. The build downloads the current official Noble release ISO, verifies it with `SHA256SUMS`, extracts the ISO, unsquashes the live filesystem, applies AurionOS files, rebuilds only the squashfs, and writes a new ISO.

Secure Boot strategy: preserve the signed Ubuntu boot chain. The build does not replace shim, signed GRUB, the signed Ubuntu kernel, or the live initrd. It hashes critical boot files before and after branding and fails if they change.

Live session strategy: ship an `AurionOS` LXQt session entry and live-session branding. LXQt remains the default stable desktop foundation for v0.1. The future labwc/Qt shell is represented by lightweight command placeholders.

Installer strategy: keep the Lubuntu Calamares installer. Only safe desktop launcher text is rebranded where present. No custom installer is attempted in v0.1.

Branding strategy: set AurionOS release identity, issue text, MOTD, wallpaper, application launchers, session metadata, ISO menu text, and docs. Plymouth theme files are included but not enabled because enabling them would require boot/initrd changes that are not worth the alpha risk.

AI strategy: include a provider-agnostic mock assistant command. The later default local provider target is Ollama with `phi4-mini`. Cloud AI remains disabled by default and must be opt-in.

Hardware strategy: include a read-only hardware scanner and diagnostics command. No DKMS, proprietary modules, or driver mutation is performed in the live ISO.

GitHub Actions strategy: build on `ubuntu-24.04`, free disk space, install ISO tools, run the build script, clearly fail if the expected ISO is absent, upload the ISO artifact, and upload logs even on failure.

## Must do today

- Build from Lubuntu 24.04 LTS desktop amd64.
- Preserve signed boot files and fail if critical boot hashes change.
- Produce `iso-build/output/aurion-os-0.1-alpha-amd64.iso`.
- Upload artifact as `aurion-os-alpha-iso`.
- Add visible AurionOS branding, wallpaper, session entry, release files, and docs.
- Keep Calamares installer stable.
- Include build logs as an artifact.

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
ai-services/
hardware-compat/
diagnostics/
docs/
```

Important payload files:

- `distro/wallpapers/aurionos-alpha.svg`
- `distro/session/aurionos-lxqt.desktop`
- `distro/session/scripts/aurion-apply-live-branding`
- `ai-services/aurion-assistant`
- `hardware-compat/aurion-hw-scan`
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
- Replace shell placeholders with Qt6/QML prototypes.
- Add VM smoke testing in CI with QEMU once the ISO artifact is reliably produced.

## Defer

- Custom compositor.
- Full custom installer.
- App store.
- Full settings app.
- Complete file manager.
- Automatic rollback.
- Driver intelligence database.
- Ollama model download inside the ISO.

## Unsafe for alpha

- Replacing shim or signed GRUB.
- Replacing the stock Ubuntu signed kernel.
- Rebuilding boot images without a tested Secure Boot signing plan.
- Adding DKMS or proprietary kernel modules to the live image.
- Removing Snap aggressively before base install behavior is known.
- Replacing Calamares for v0.1.
