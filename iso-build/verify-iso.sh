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
  require_file_in_squashfs usr/share/wayland-sessions/aurionos-labwc.desktop
  require_file_in_squashfs etc/xdg/autostart/aurion-live-branding.desktop
  require_file_in_squashfs etc/xdg/autostart/aurion-session-guard.desktop
  require_file_in_squashfs etc/xdg/autostart/aurion-session-watchdog.desktop
  require_file_in_squashfs etc/X11/Xsession.d/80aurionos-session-guard
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
  require_file_in_squashfs usr/share/aurionos/store/index.html
  require_file_in_squashfs usr/share/aurionos/store/styles.css
  require_file_in_squashfs usr/share/aurionos/store/app.js
  require_file_in_squashfs usr/share/aurionos/hardware/index.html
  require_file_in_squashfs usr/share/aurionos/hardware/styles.css
  require_file_in_squashfs usr/share/aurionos/hardware/app.js
  require_file_in_squashfs usr/share/aurionos/diagnostics/index.html
  require_file_in_squashfs usr/share/aurionos/diagnostics/styles.css
  require_file_in_squashfs usr/share/aurionos/diagnostics/app.js
  require_file_in_squashfs usr/share/aurionos/labwc/autostart
  require_file_in_squashfs usr/share/aurionos/labwc/environment
  require_file_in_squashfs usr/share/aurionos/labwc/menu.xml
  require_file_in_squashfs usr/share/aurionos/labwc/rc.xml
  require_file_in_squashfs usr/share/aurionos/qml/AurionShell.qml
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
  require_file_in_squashfs usr/share/applications/aurion-browser.desktop
  require_file_in_squashfs usr/share/applications/aurion-files.desktop
  require_file_in_squashfs usr/share/applications/aurion-terminal.desktop
  require_file_in_squashfs usr/share/applications/aurion-installer.desktop
  require_file_in_squashfs usr/share/applications/aurion-ai-sidebar.desktop
  require_file_in_squashfs usr/share/applications/aurion-ai-setup.desktop
  require_file_in_squashfs usr/share/applications/aurion-action-handler.desktop
  require_file_in_squashfs usr/share/applications/mimeapps.list
  require_file_in_squashfs etc/xdg/mimeapps.list
  require_file_in_squashfs usr/share/applications/aurion-experience.desktop
  require_file_in_squashfs usr/share/applications/aurion-install.desktop
  require_file_in_squashfs usr/share/applications/aurion-snapshot-plan.desktop
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-browser.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-files.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-terminal.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-installer.svg

  require_executable_in_squashfs usr/local/bin/aurion-status
  require_executable_in_squashfs usr/local/bin/aurion-apply-live-branding
  require_executable_in_squashfs usr/local/bin/aurion-session-guard
  require_executable_in_squashfs usr/local/bin/aurion-session-watchdog
  require_executable_in_squashfs usr/local/bin/aurion-startlxqt
  require_executable_in_squashfs usr/local/bin/aurion-startlabwc
  require_executable_in_squashfs usr/local/bin/aurion-control
  require_executable_in_squashfs usr/local/bin/aurion-action
  require_executable_in_squashfs usr/local/bin/aurion-webapp-open
  require_executable_in_squashfs usr/local/bin/aurion-shell
  require_executable_in_squashfs usr/local/bin/aurion-qml-surface
  require_executable_in_squashfs usr/local/bin/aurion-launcher
  require_executable_in_squashfs usr/local/bin/aurion-ai-sidebar
  require_executable_in_squashfs usr/local/bin/aurion-topbar
  require_executable_in_squashfs usr/local/bin/aurion-dock
  require_executable_in_squashfs usr/local/bin/aurion-experience
  require_executable_in_squashfs usr/local/bin/aurion-hub
  require_executable_in_squashfs usr/local/bin/aurion-ai-status
  require_executable_in_squashfs usr/local/bin/aurion-ai-status-gui
  require_executable_in_squashfs usr/local/bin/aurion-ai-service
  require_executable_in_squashfs usr/local/bin/aurion-ai-setup
  require_executable_in_squashfs usr/local/bin/aurion-do
  require_executable_in_squashfs usr/local/bin/aurion-task-assist
  require_executable_in_squashfs usr/local/bin/aurion-install
  require_executable_in_squashfs usr/local/bin/aurion-appimage-integrate
  require_executable_in_squashfs usr/local/bin/aurion-hardware-center
  require_executable_in_squashfs usr/local/bin/aurion-hardware-gui
  require_executable_in_squashfs usr/local/bin/aurion-store
  require_executable_in_squashfs usr/local/bin/aurion-store-gui
  require_executable_in_squashfs usr/local/bin/aurion-snapshot-plan
  require_executable_in_squashfs usr/local/bin/aurion-channel
  require_executable_in_squashfs usr/local/bin/aurion-diagnostics
  require_executable_in_squashfs usr/local/bin/aurion-diagnostics-gui
  require_executable_in_squashfs usr/local/bin/aurion-hw-scan
  require_executable_in_squashfs usr/local/bin/aurion-assistant
  require_executable_in_squashfs etc/skel/Desktop/aurion-launcher.desktop
  require_executable_in_squashfs etc/skel/Desktop/aurion-experience.desktop
  require_executable_in_squashfs etc/skel/Desktop/aurion-store.desktop
  require_executable_in_squashfs etc/skel/Desktop/aurion-installer.desktop

  cat_squashfs_file usr/lib/os-release > "$WORK_DIR/os-release"
  grep -Fq 'PRETTY_NAME="AurionOS Alpha Fast Track v0.1"' "$WORK_DIR/os-release" \
    || fail "Live filesystem os-release does not contain AurionOS identity"

  cat_squashfs_file usr/share/xsessions/aurionos-lxqt.desktop > "$WORK_DIR/aurionos-lxqt.desktop"
  grep -Fq 'Exec=/usr/local/bin/aurion-startlxqt' "$WORK_DIR/aurionos-lxqt.desktop" \
    || fail "AurionOS session does not use the guarded LXQt starter"
  grep -Fq 'DesktopNames=LXQt;AurionOS;' "$WORK_DIR/aurionos-lxqt.desktop" \
    || fail "AurionOS session does not keep LXQt in DesktopNames"

  cat_squashfs_file usr/share/wayland-sessions/aurionos-labwc.desktop > "$WORK_DIR/aurionos-labwc.desktop"
  grep -Fq 'Exec=/usr/local/bin/aurion-startlabwc' "$WORK_DIR/aurionos-labwc.desktop" \
    || fail "AurionOS LabWC preview session does not use aurion-startlabwc"

  cat_squashfs_file usr/local/bin/aurion-startlabwc > "$WORK_DIR/aurion-startlabwc"
  grep -Fq 'falling back to stable LXQt session' "$WORK_DIR/aurion-startlabwc" \
    || fail "AurionOS LabWC preview does not keep the safe LXQt fallback"

  cat_squashfs_file usr/share/aurionos/qml/AurionShell.qml > "$WORK_DIR/aurion-qml-shell.qml"
  grep -Fq 'ApplicationWindow' "$WORK_DIR/aurion-qml-shell.qml" \
    || fail "Aurion QML shell prototype is missing an ApplicationWindow"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-qml-shell.qml" \
    || fail "Aurion QML shell prototype does not route through aurion-action links"

  cat_squashfs_file etc/X11/Xsession.d/80aurionos-session-guard > "$WORK_DIR/xsession-guard"
  grep -Fq 'aurion-session-guard' "$WORK_DIR/xsession-guard" \
    || fail "Xsession guard does not launch AurionOS session recovery"

  cat_squashfs_file etc/skel/.config/lxqt/session.conf > "$WORK_DIR/session.conf"
  if grep -Fq '__userfile__=true' "$WORK_DIR/session.conf"; then
    fail "LXQt session.conf must not be a complete user override in the live profile"
  fi
  grep -Fq 'window_manager=openbox' "$WORK_DIR/session.conf" \
    || fail "LXQt session.conf does not declare openbox as the window manager"
  grep -Fq 'lxqt-panel=true' "$WORK_DIR/session.conf" \
    || fail "LXQt session.conf does not keep the panel module enabled"
  grep -Fq 'pcmanfm-desktop=true' "$WORK_DIR/session.conf" \
    || fail "LXQt session.conf does not keep the desktop module enabled"

  cat_squashfs_file etc/skel/.config/lxqt/panel.conf > "$WORK_DIR/panel.conf"
  grep -Fq 'aurion-browser.desktop' "$WORK_DIR/panel.conf" \
    || fail "LXQt dock does not use the Aurion browser launcher"
  grep -Fq 'aurion-files.desktop' "$WORK_DIR/panel.conf" \
    || fail "LXQt dock does not use the Aurion files launcher"
  grep -Fq 'aurion-terminal.desktop' "$WORK_DIR/panel.conf" \
    || fail "LXQt dock does not use the Aurion terminal launcher"
  grep -Fq 'aurion-installer.desktop' "$WORK_DIR/panel.conf" \
    || fail "LXQt dock does not use the Aurion installer launcher"

  cat_squashfs_file etc/skel/.config/pcmanfm-qt/lxqt/settings.conf > "$WORK_DIR/pcmanfm-qt-settings.conf"
  grep -Fq '[*]' "$WORK_DIR/pcmanfm-qt-settings.conf" \
    || fail "PCManFM-Qt settings do not include the default desktop section"
  grep -Fq 'Wallpaper=/usr/share/backgrounds/aurionos/aurionos-alpha.png' "$WORK_DIR/pcmanfm-qt-settings.conf" \
    || fail "PCManFM-Qt settings do not point to the AurionOS wallpaper"

  cat_squashfs_file usr/share/aurionos/experience/index.html > "$WORK_DIR/aurion-experience.html"
  grep -Fq 'Aurion Experience' "$WORK_DIR/aurion-experience.html" \
    || fail "Aurion Experience home surface is missing"
  grep -Fq 'Ciao! Sono' "$WORK_DIR/aurion-experience.html" \
    || fail "Aurion Experience does not contain the new home greeting"
  cat_squashfs_file usr/share/aurionos/experience/app.js > "$WORK_DIR/aurion-experience.js"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-experience.js" \
    || fail "Aurion Experience does not expose clickable action links"

  cat_squashfs_file usr/local/bin/aurion-experience > "$WORK_DIR/aurion-experience-bin"
  grep -Fq 'aurion-webapp-open' "$WORK_DIR/aurion-experience-bin" \
    || fail "Aurion Experience does not use the Snap-safe webapp opener"

  cat_squashfs_file usr/local/bin/aurion-webapp-open > "$WORK_DIR/aurion-webapp-open"
  grep -Fq 'AurionOSWeb' "$WORK_DIR/aurion-webapp-open" \
    || fail "Aurion webapp opener does not materialize surfaces in a user-visible home path"

  cat_squashfs_file usr/share/aurionos/store/app.js > "$WORK_DIR/aurion-store.js"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-store.js" \
    || fail "Aurion Store does not expose clickable action links"

  cat_squashfs_file usr/share/aurionos/hardware/app.js > "$WORK_DIR/aurion-hardware.js"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-hardware.js" \
    || fail "Aurion Hardware Center does not expose clickable action links"

  cat_squashfs_file usr/share/aurionos/diagnostics/app.js > "$WORK_DIR/aurion-diagnostics.js"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-diagnostics.js" \
    || fail "Aurion Diagnostics does not expose clickable action links"

  cat_squashfs_file etc/xdg/mimeapps.list > "$WORK_DIR/mimeapps.list"
  grep -Fq 'x-scheme-handler/aurion-action=aurion-action-handler.desktop' "$WORK_DIR/mimeapps.list" \
    || fail "Aurion action URL handler is not registered"

  cat_squashfs_file usr/share/aurionos/ai/providers/ollama-phi4-mini.json > "$WORK_DIR/ai-provider.json"
  grep -Fq '"default_model": "phi4-mini"' "$WORK_DIR/ai-provider.json" \
    || fail "AI provider metadata does not declare phi4-mini"
  grep -Fq '"cloud_fallback_enabled_by_default": false' "$WORK_DIR/ai-provider.json" \
    || fail "AI provider metadata does not keep cloud AI disabled by default"

  cat_squashfs_file usr/local/bin/aurion-ai-service > "$WORK_DIR/aurion-ai-service"
  grep -Fq 'ollama run "$model"' "$WORK_DIR/aurion-ai-service" \
    || fail "Aurion AI service does not use the local Ollama model path"
  grep -Fq 'fallback "$query"' "$WORK_DIR/aurion-ai-service" \
    || fail "Aurion AI service does not keep the safe alpha fallback"

  cat_squashfs_file usr/share/aurionos/ai/tasks/alpha-tasks.json > "$WORK_DIR/ai-tasks.json"
  grep -Fq '"primary_command": "aurion-do email"' "$WORK_DIR/ai-tasks.json" \
    || fail "AI task metadata does not route email through aurion-do"

  log "ISO content verification passed"
}

main "$@"
