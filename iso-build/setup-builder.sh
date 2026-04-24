#!/usr/bin/env bash
set -Eeuo pipefail

if [ "$(id -u)" -eq 0 ]; then
  SUDO=()
else
  SUDO=(sudo)
fi

export DEBIAN_FRONTEND=noninteractive

"${SUDO[@]}" apt-get update
"${SUDO[@]}" apt-get install -y --no-install-recommends \
  ca-certificates \
  coreutils \
  curl \
  dpkg-dev \
  file \
  findutils \
  gawk \
  gnupg \
  grep \
  jq \
  librsvg2-bin \
  p7zip-full \
  rsync \
  sed \
  squashfs-tools \
  syslinux-utils \
  util-linux \
  xorriso

xorriso -version || true
mksquashfs -version || true
