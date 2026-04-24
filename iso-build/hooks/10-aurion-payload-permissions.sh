#!/usr/bin/env bash
set -euo pipefail

rootfs="${AURION_ROOTFS:?AURION_ROOTFS is required}"

if [ -d "$rootfs/usr/local/bin" ]; then
  find "$rootfs/usr/local/bin" -maxdepth 1 -type f -name 'aurion-*' -exec chmod 0755 {} \;
fi
