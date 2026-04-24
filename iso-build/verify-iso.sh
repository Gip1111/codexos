#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO_BUILD_DIR="$PROJECT_ROOT/iso-build"
OUTPUT_DIR="$ISO_BUILD_DIR/output"
LOG_DIR="$ISO_BUILD_DIR/logs"
WORK_DIR="${AURION_VERIFY_WORK_DIR:-$ISO_BUILD_DIR/verify-work}"
ISO="${1:-$OUTPUT_DIR/aurion-os-0.1-alpha-amd64.iso}"

log() {
  printf '[aurion-verify] %s\n' "$*" >&2
}

fail() {
  printf '[aurion-verify] ERROR: %s\n' "$*" >&2
  exit 1
}

require_tools() {
  local missing=()
  local tool

  for tool in awk cat cp grep mkdir realpath rm sed sort unsquashfs xorriso; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      missing+=("$tool")
    fi
  done

  if [ "${#missing[@]}" -gt 0 ]; then
    fail "Missing required verification tools: ${missing[*]}"
  fi
}

safe_rm_dir() {
  local target="$1"
  local base_abs target_abs
  base_abs="$(realpath -m "$ISO_BUILD_DIR")"
  target_abs="$(realpath -m "$target")"

  case "$target_abs" in
    "$base_abs"/*) ;;
    *) fail "Refusing to remove path outside iso-build: $target_abs" ;;
  esac

  rm -rf "$target_abs"
}

extract_iso_path() {
  local iso_path="$1"
  local dest="$2"

  log "Extracting $iso_path"
  xorriso -osirrox on -indev "$ISO" -extract "$iso_path" "$dest" >/dev/null 2>&1 \
    || fail "Missing expected ISO path: $iso_path"
}

require_file_in_squashfs() {
  local path="$1"

  if ! grep -Eq "squashfs-root/${path}($| -> )" "$WORK_DIR/filesystem.list"; then
    fail "Missing expected live filesystem path: /$path"
  fi
}

require_executable_in_squashfs() {
  local path="$1"

  if ! grep -Eq "^-rwx[^[:space:]]+[[:space:]].*squashfs-root/${path}$" "$WORK_DIR/filesystem.list"; then
    fail "Expected executable bit on live filesystem path: /$path"
  fi
}

cat_squashfs_file() {
  local path="$1"

  unsquashfs -cat "$WORK_DIR/filesystem.squashfs" "$path" 2>/dev/null \
    || unsquashfs -cat "$WORK_DIR/filesystem.squashfs" "squashfs-root/$path" 2>/dev/null
}

main() {
  require_tools
  [ -s "$ISO" ] || fail "ISO not found or empty: $ISO"

  mkdir -p "$LOG_DIR"
  safe_rm_dir "$WORK_DIR"
  mkdir -p "$WORK_DIR"

  extract_iso_path /casper/filesystem.squashfs "$WORK_DIR/filesystem.squashfs"
  extract_iso_path /casper/vmlinuz "$WORK_DIR/vmlinuz"
  extract_iso_path /casper/initrd "$WORK_DIR/initrd"
  extract_iso_path /EFI "$WORK_DIR/EFI"
  extract_iso_path /boot/grub/grub.cfg "$WORK_DIR/grub.cfg"
  extract_iso_path /.disk/info "$WORK_DIR/disk-info"

  log "Listing live filesystem"
  unsquashfs -ll "$WORK_DIR/filesystem.squashfs" | sort > "$WORK_DIR/filesystem.list"
  cp "$WORK_DIR/filesystem.list" "$LOG_DIR/verify-filesystem.list"

  grep -Fq "AurionOS Alpha Fast Track v0.1" "$WORK_DIR/disk-info" \
    || fail "ISO .disk/info does not contain AurionOS alpha branding"
  grep -Fq "AurionOS" "$WORK_DIR/grub.cfg" \
    || fail "GRUB menu does not contain AurionOS branding"

  require_file_in_squashfs usr/lib/os-release
  require_file_in_squashfs etc/aurionos-release
  require_file_in_squashfs usr/share/backgrounds/aurionos/aurionos-alpha.png
  require_file_in_squashfs usr/share/xsessions/aurionos-lxqt.desktop
  require_file_in_squashfs usr/share/lxqt/themes/aurionos-alpha/lxqt-panel.qss
  require_file_in_squashfs usr/share/lxqt/themes/aurionos-alpha/lxqt-runner.qss
  require_file_in_squashfs usr/share/lxqt/themes/aurionos-alpha/lxqt-notificationd.qss
  require_file_in_squashfs usr/share/themes/AurionOS/openbox-3/themerc
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurionos.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-experience.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-assistant.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-store.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-hardware.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-snapshot.svg
  require_file_in_squashfs etc/skel/.config/lxqt/lxqt.conf
  require_file_in_squashfs etc/skel/.config/lxqt/panel.conf
  require_file_in_squashfs etc/skel/.config/lxqt/session.conf
  require_file_in_squashfs etc/skel/.config/lxqt/globalkeyshortcuts.conf
  require_file_in_squashfs etc/skel/.config/openbox/lxqt-rc.xml
  require_file_in_squashfs etc/skel/Desktop/aurion-experience.desktop
  require_file_in_squashfs etc/skel/Desktop/aurion-store.desktop
  require_file_in_squashfs etc/skel/Desktop/aurion-installer.desktop
  require_file_in_squashfs usr/share/aurionos/welcome/index.html
  require_file_in_squashfs usr/share/aurionos/experience/index.html
  require_file_in_squashfs usr/share/aurionos/experience/styles.css
  require_file_in_squashfs usr/share/aurionos/experience/app.js
  require_file_in_squashfs usr/share/aurionos/shell/index.html
  require_file_in_squashfs usr/share/aurionos/shell/styles.css
  require_file_in_squashfs usr/share/aurionos/shell/app.js
  require_file_in_squashfs usr/share/aurionos/ai/providers/ollama-phi4-mini.json
  require_file_in_squashfs usr/share/aurionos/ai/tasks/alpha-tasks.json
  require_file_in_squashfs usr/share/aurionos/hardware/alpha-hardware.json
  require_file_in_squashfs usr/share/aurionos/store/alpha-catalog.json
  require_file_in_squashfs usr/share/aurionos/release/channel.conf
  require_file_in_squashfs usr/share/doc/aurionos/final-project-foundations.md
  require_file_in_squashfs usr/share/doc/aurionos/iso-build-plan.md
  require_file_in_squashfs usr/share/doc/aurionos/visual-design.md
  require_file_in_squashfs usr/share/applications/aurion-hub.desktop
  require_file_in_squashfs usr/share/applications/aurion-shell.desktop
  require_file_in_squashfs usr/share/applications/aurion-launcher.desktop
  require_file_in_squashfs usr/share/applications/aurion-ai-sidebar.desktop
  require_file_in_squashfs usr/share/applications/aurion-experience.desktop
  require_file_in_squashfs usr/share/applications/aurion-install.desktop
  require_file_in_squashfs usr/share/applications/aurion-snapshot-plan.desktop

  require_executable_in_squashfs usr/local/bin/aurion-status
  require_executable_in_squashfs usr/local/bin/aurion-control
  require_executable_in_squashfs usr/local/bin/aurion-shell
  require_executable_in_squashfs usr/local/bin/aurion-launcher
  require_executable_in_squashfs usr/local/bin/aurion-ai-sidebar
  require_executable_in_squashfs usr/local/bin/aurion-topbar
  require_executable_in_squashfs usr/local/bin/aurion-dock
  require_executable_in_squashfs usr/local/bin/aurion-experience
  require_executable_in_squashfs usr/local/bin/aurion-hub
  require_executable_in_squashfs usr/local/bin/aurion-ai-status
  require_executable_in_squashfs usr/local/bin/aurion-do
  require_executable_in_squashfs usr/local/bin/aurion-task-assist
  require_executable_in_squashfs usr/local/bin/aurion-install
  require_executable_in_squashfs usr/local/bin/aurion-appimage-integrate
  require_executable_in_squashfs usr/local/bin/aurion-hardware-center
  require_executable_in_squashfs usr/local/bin/aurion-store
  require_executable_in_squashfs usr/local/bin/aurion-snapshot-plan
  require_executable_in_squashfs usr/local/bin/aurion-channel
  require_executable_in_squashfs usr/local/bin/aurion-diagnostics
  require_executable_in_squashfs usr/local/bin/aurion-hw-scan
  require_executable_in_squashfs usr/local/bin/aurion-assistant
  require_executable_in_squashfs etc/skel/Desktop/aurion-launcher.desktop
  require_executable_in_squashfs etc/skel/Desktop/aurion-experience.desktop
  require_executable_in_squashfs etc/skel/Desktop/aurion-store.desktop
  require_executable_in_squashfs etc/skel/Desktop/aurion-installer.desktop

  cat_squashfs_file usr/lib/os-release > "$WORK_DIR/os-release"
  grep -Fq 'PRETTY_NAME="AurionOS Alpha Fast Track v0.1"' "$WORK_DIR/os-release" \
    || fail "Live filesystem os-release does not contain AurionOS identity"

  cat_squashfs_file usr/share/aurionos/ai/providers/ollama-phi4-mini.json > "$WORK_DIR/ai-provider.json"
  grep -Fq '"default_model": "phi4-mini"' "$WORK_DIR/ai-provider.json" \
    || fail "AI provider metadata does not declare phi4-mini"
  grep -Fq '"cloud_fallback_enabled_by_default": false' "$WORK_DIR/ai-provider.json" \
    || fail "AI provider metadata does not keep cloud AI disabled by default"

  cat_squashfs_file usr/share/aurionos/ai/tasks/alpha-tasks.json > "$WORK_DIR/ai-tasks.json"
  grep -Fq '"primary_command": "aurion-do email"' "$WORK_DIR/ai-tasks.json" \
    || fail "AI task metadata does not route email through aurion-do"

  log "ISO content verification passed"
}

main "$@"
