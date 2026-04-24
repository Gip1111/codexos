# AurionOS ISO Build Hooks

Optional executable `*.sh` files in this directory run after the AurionOS alpha payload is copied into the extracted live filesystem and before the squashfs is rebuilt.

Hooks receive:

- `AURION_ROOTFS`: extracted live filesystem root
- `AURION_ISO_ROOT`: extracted ISO filesystem root
- `AURION_PROJECT_ROOT`: repository root

Do not modify `EFI/`, signed GRUB EFI binaries, `casper/vmlinuz*`, or `casper/initrd*` from a hook. The build script hashes those paths and fails if they change.

