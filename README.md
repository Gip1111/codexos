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
- AurionOS wallpaper placeholder
- AurionOS LXQt session entry
- Mock AI assistant foundation
- Hardware scanner CLI
- Diagnostics CLI
- Rollback status placeholder
- Build logs artifact

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

