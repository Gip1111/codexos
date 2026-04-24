# Secure Boot Strategy

AurionOS Alpha Fast Track v0.1 preserves Ubuntu's signed Secure Boot chain from the Lubuntu 24.04 LTS base ISO.

## Preserved components

The build must not replace:

- `EFI/` bootloader files from the base ISO
- `boot/grub/efi.img` and related boot images
- `casper/vmlinuz*`
- `casper/initrd*`
- shim-signed
- grub-efi-amd64-signed
- the Ubuntu signed kernel

The build script records SHA256 hashes for critical boot files before and after modifications. If any of those hashes change, the build fails.

## Allowed alpha branding

Allowed:

- Live filesystem branding inside `filesystem.squashfs`
- OS release metadata
- Wallpaper and session files
- Application launchers
- Documentation
- Safe GRUB menu text changes

Not enabled in v0.1:

- Custom signed shim
- Custom signed GRUB
- Custom kernel
- Custom initrd generation
- Active custom Plymouth in initrd

## Third-party drivers

AurionOS must use Ubuntu's existing MOK enrollment workflow for third-party modules later. Alpha v0.1 does not install DKMS or proprietary kernel modules into the live environment.

## Acceptance check

For alpha acceptance, test on a standard amd64 UEFI machine or VM:

- Secure Boot enabled where supported
- ISO boots to live session
- Installer launches
- Installed system boots

Passing this does not mean AurionOS owns a custom Secure Boot chain. It means the alpha preserved Ubuntu's signed chain.

