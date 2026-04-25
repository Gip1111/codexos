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
  require_file_in_squashfs usr/share/xsessions/aurionos-native.desktop
  require_file_in_squashfs usr/share/wayland-sessions/aurionos-labwc.desktop
  require_file_in_squashfs etc/xdg/autostart/aurion-live-branding.desktop
  require_file_in_squashfs etc/xdg/autostart/aurion-first-run.desktop
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
  require_file_in_squashfs usr/share/aurionos/qml/AurionExperience.qml
  require_file_in_squashfs usr/share/aurionos/qml/runtime.conf
  require_file_in_squashfs usr/share/aurionos/shell/index.html
  require_file_in_squashfs usr/share/aurionos/shell/styles.css
  require_file_in_squashfs usr/share/aurionos/shell/app.js
  require_file_in_squashfs usr/share/aurionos/ai/providers/ollama-phi4-mini.json
  require_file_in_squashfs usr/share/aurionos/ai/tasks/alpha-tasks.json
  require_file_in_squashfs usr/share/aurionos/hardware/alpha-hardware.json
  require_file_in_squashfs usr/share/aurionos/store/alpha-catalog.json
  require_file_in_squashfs usr/share/aurionos/release/channel.conf
  require_file_in_squashfs usr/share/doc/aurionos/final-project-foundations.md
  require_file_in_squashfs usr/share/doc/aurionos/desktop-environment.md
  require_file_in_squashfs usr/share/doc/aurionos/desktop-packaging.md
  require_file_in_squashfs usr/share/doc/aurionos/iso-build-plan.md
  require_file_in_squashfs usr/share/doc/aurionos/visual-design.md
  require_file_in_squashfs usr/share/applications/aurion-desktop-shell.desktop
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
  require_file_in_squashfs usr/share/applications/aurion-settings.desktop
  require_file_in_squashfs usr/share/applications/aurion-notifications.desktop
  require_file_in_squashfs usr/share/applications/aurion-login-preview.desktop
  require_file_in_squashfs usr/share/applications/mimeapps.list
  require_file_in_squashfs etc/xdg/mimeapps.list
  require_file_in_squashfs usr/share/applications/aurion-experience.desktop
  require_file_in_squashfs usr/share/applications/aurion-install.desktop
  require_file_in_squashfs usr/share/applications/aurion-snapshot-plan.desktop
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-browser.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-files.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-terminal.svg
  require_file_in_squashfs usr/share/icons/hicolor/scalable/apps/aurion-installer.svg
  require_file_in_squashfs usr/share/sddm/themes/aurionos-alpha/Main.qml
  require_file_in_squashfs usr/share/sddm/themes/aurionos-alpha/theme.conf
  require_file_in_squashfs usr/share/sddm/themes/aurionos-alpha/metadata.desktop

  require_executable_in_squashfs usr/local/bin/aurion-status
  require_executable_in_squashfs usr/local/bin/aurion-apply-live-branding
  require_executable_in_squashfs usr/local/bin/aurion-first-run
  require_executable_in_squashfs usr/local/bin/aurion-session-guard
  require_executable_in_squashfs usr/local/bin/aurion-session-watchdog
  require_executable_in_squashfs usr/local/bin/aurion-startlxqt
  require_executable_in_squashfs usr/local/bin/aurion-startlabwc
  require_executable_in_squashfs usr/local/bin/aurion-startdesktop
  require_executable_in_squashfs usr/local/bin/aurion-window-manager
  require_executable_in_squashfs usr/local/bin/aurion-control
  require_executable_in_squashfs usr/local/bin/aurion-action
  require_executable_in_squashfs usr/local/bin/aurion-de-shell
  require_executable_in_squashfs usr/local/bin/aurion-native-home
  require_executable_in_squashfs usr/local/bin/aurion-settings
  require_executable_in_squashfs usr/local/bin/aurion-files
  require_executable_in_squashfs usr/local/bin/aurion-notifications
  require_executable_in_squashfs usr/local/bin/aurion-notify
  require_executable_in_squashfs usr/local/bin/aurion-login-preview
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
  require_executable_in_squashfs usr/local/bin/aurion-desktop-check
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

  cat_squashfs_file usr/share/xsessions/aurionos-native.desktop > "$WORK_DIR/aurionos-native.desktop"
  grep -Fq 'Exec=/usr/local/bin/aurion-startdesktop' "$WORK_DIR/aurionos-native.desktop" \
    || fail "AurionOS Native Preview session does not use aurion-startdesktop"

  cat_squashfs_file usr/local/bin/aurion-startlabwc > "$WORK_DIR/aurion-startlabwc"
  grep -Fq 'falling back to stable LXQt session' "$WORK_DIR/aurion-startlabwc" \
    || fail "AurionOS LabWC preview does not keep the safe LXQt fallback"

  cat_squashfs_file usr/share/aurionos/qml/AurionShell.qml > "$WORK_DIR/aurion-qml-shell.qml"
  grep -Fq 'ApplicationWindow' "$WORK_DIR/aurion-qml-shell.qml" \
    || fail "Aurion QML shell prototype is missing an ApplicationWindow"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-qml-shell.qml" \
    || fail "Aurion QML shell prototype does not route through aurion-action links"

  cat_squashfs_file usr/share/aurionos/qml/AurionExperience.qml > "$WORK_DIR/aurion-qml-experience.qml"
  grep -Fq 'Aurion Experience' "$WORK_DIR/aurion-qml-experience.qml" \
    || fail "Aurion QML Experience surface is missing its branded title"
  grep -Fq 'FramelessWindowHint' "$WORK_DIR/aurion-qml-experience.qml" \
    || fail "Aurion QML Experience should avoid browser window chrome"
  grep -Fq 'Ciao! Sono' "$WORK_DIR/aurion-qml-experience.qml" \
    || fail "Aurion QML Experience does not contain the home greeting"
  grep -Fq 'activePage' "$WORK_DIR/aurion-qml-experience.qml" \
    || fail "Aurion QML Experience does not switch internal pages"
  grep -Fq 'storePage' "$WORK_DIR/aurion-qml-experience.qml" \
    || fail "Aurion QML Experience does not include the native Store page"
  grep -Fq 'hardwarePage' "$WORK_DIR/aurion-qml-experience.qml" \
    || fail "Aurion QML Experience does not include the native Hardware page"
  grep -Fq 'diagnosticsPage' "$WORK_DIR/aurion-qml-experience.qml" \
    || fail "Aurion QML Experience does not include the native Diagnostics page"
  grep -Fq 'ai-install-ollama' "$WORK_DIR/aurion-qml-experience.qml" \
    || fail "Aurion QML Experience does not expose the optional local AI runtime flow"

  cat_squashfs_file usr/share/aurionos/qml/runtime.conf > "$WORK_DIR/qml-runtime.conf"
  grep -Fq 'AURION_NATIVE_UI=pyqt5' "$WORK_DIR/qml-runtime.conf" \
    || fail "Aurion native PyQt desktop metadata is missing"
  grep -Fq 'AURION_NATIVE_RUNNER=' "$WORK_DIR/qml-runtime.conf" \
    || fail "Aurion native runtime metadata does not record a runner"
  grep -Fq 'AURION_QML_RUNNER=' "$WORK_DIR/qml-runtime.conf" \
    || fail "Aurion QML runtime metadata does not record a runner"

  cat_squashfs_file usr/local/bin/aurion-first-run > "$WORK_DIR/aurion-first-run"
  grep -Fq 'aurion-experience' "$WORK_DIR/aurion-first-run" \
    || fail "Aurion first-run should open the native Experience surface before HTML fallback"

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
  grep -Fq 'aurion-native-home --page experience' "$WORK_DIR/aurion-experience-bin" \
    || fail "Aurion Experience does not prefer the native PyQt home surface"
  grep -Fq 'aurion-webapp-open' "$WORK_DIR/aurion-experience-bin" \
    || fail "Aurion Experience does not use the Snap-safe webapp opener"
  grep -Fq 'aurion-qml-surface --page experience' "$WORK_DIR/aurion-experience-bin" \
    || fail "Aurion Experience does not prefer the native QML home surface"

  cat_squashfs_file usr/local/bin/aurion-webapp-open > "$WORK_DIR/aurion-webapp-open"
  grep -Fq 'AurionOSWeb' "$WORK_DIR/aurion-webapp-open" \
    || fail "Aurion webapp opener does not materialize surfaces in a user-visible home path"

  cat_squashfs_file usr/local/bin/aurion-native-home > "$WORK_DIR/aurion-native-home"
  grep -Fq 'from PyQt5 import QtCore, QtGui, QtWidgets' "$WORK_DIR/aurion-native-home" \
    || fail "Aurion native home is not implemented as a PyQt desktop app"
  grep -Fq 'def build_store_page' "$WORK_DIR/aurion-native-home" \
    || fail "Aurion native home does not include the integrated Store page"
  grep -Fq 'def build_hardware_page' "$WORK_DIR/aurion-native-home" \
    || fail "Aurion native home does not include the integrated Hardware page"
  grep -Fq 'def build_diagnostics_page' "$WORK_DIR/aurion-native-home" \
    || fail "Aurion native home does not include the integrated Diagnostics page"

  cat_squashfs_file usr/local/bin/aurion-de-shell > "$WORK_DIR/aurion-de-shell"
  grep -Fq 'class TopBar' "$WORK_DIR/aurion-de-shell" \
    || fail "Aurion DE shell does not implement the native topbar"
  grep -Fq 'class Dock' "$WORK_DIR/aurion-de-shell" \
    || fail "Aurion DE shell does not implement the native dock"
  grep -Fq 'class Launcher' "$WORK_DIR/aurion-de-shell" \
    || fail "Aurion DE shell does not implement the native launcher"
  grep -Fq 'class Settings' "$WORK_DIR/aurion-de-shell" \
    || fail "Aurion DE shell does not implement settings"
  grep -Fq 'class Files' "$WORK_DIR/aurion-de-shell" \
    || fail "Aurion DE shell does not implement the file manager"
  grep -Fq 'class Notifications' "$WORK_DIR/aurion-de-shell" \
    || fail "Aurion DE shell does not implement notifications"
  grep -Fq 'class LoginPreview' "$WORK_DIR/aurion-de-shell" \
    || fail "Aurion DE shell does not implement the login preview"

  cat_squashfs_file usr/local/bin/aurion-startdesktop > "$WORK_DIR/aurion-startdesktop"
  grep -Fq 'aurion-de-shell --mode topbar' "$WORK_DIR/aurion-startdesktop" \
    || fail "Aurion native session does not start the native topbar"
  grep -Fq 'aurion-de-shell --mode dock' "$WORK_DIR/aurion-startdesktop" \
    || fail "Aurion native session does not start the native dock"

  cat_squashfs_file usr/local/bin/aurion-window-manager > "$WORK_DIR/aurion-window-manager"
  grep -Fq 'openbox' "$WORK_DIR/aurion-window-manager" \
    || fail "Aurion window manager bridge does not keep the Openbox fallback"

  cat_squashfs_file usr/share/aurionos/store/app.js > "$WORK_DIR/aurion-store.js"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-store.js" \
    || fail "Aurion Store does not expose clickable action links"
  cat_squashfs_file usr/local/bin/aurion-store > "$WORK_DIR/aurion-store-bin"
  grep -Fq 'aurion-native-home --page store' "$WORK_DIR/aurion-store-bin" \
    || fail "Aurion Store does not prefer the native integrated page"

  cat_squashfs_file usr/share/aurionos/hardware/app.js > "$WORK_DIR/aurion-hardware.js"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-hardware.js" \
    || fail "Aurion Hardware Center does not expose clickable action links"
  cat_squashfs_file usr/local/bin/aurion-hardware-center > "$WORK_DIR/aurion-hardware-bin"
  grep -Fq 'aurion-native-home --page hardware' "$WORK_DIR/aurion-hardware-bin" \
    || fail "Aurion Hardware Center does not prefer the native integrated page"

  cat_squashfs_file usr/share/aurionos/diagnostics/app.js > "$WORK_DIR/aurion-diagnostics.js"
  grep -Fq 'aurion-action://' "$WORK_DIR/aurion-diagnostics.js" \
    || fail "Aurion Diagnostics does not expose clickable action links"
  cat_squashfs_file usr/local/bin/aurion-diagnostics > "$WORK_DIR/aurion-diagnostics-bin"
  grep -Fq 'aurion-native-home --page diagnostics' "$WORK_DIR/aurion-diagnostics-bin" \
    || fail "Aurion Diagnostics does not prefer the native integrated page"

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

  cat_squashfs_file usr/local/bin/aurion-ai-setup > "$WORK_DIR/aurion-ai-setup"
  grep -Fq -- '--install-ollama' "$WORK_DIR/aurion-ai-setup" \
    || fail "Aurion AI setup does not expose the optional local Ollama install flow"

  cat_squashfs_file usr/local/bin/aurion-action > "$WORK_DIR/aurion-action"
  grep -Fq 'ai-install-ollama' "$WORK_DIR/aurion-action" \
    || fail "Aurion action dispatcher does not route the optional Ollama install flow"
  grep -Fq 'desktop-check' "$WORK_DIR/aurion-action" \
    || fail "Aurion action dispatcher does not route desktop integration diagnostics"

  cat_squashfs_file usr/share/aurionos/ai/tasks/alpha-tasks.json > "$WORK_DIR/ai-tasks.json"
  grep -Fq '"primary_command": "aurion-do email"' "$WORK_DIR/ai-tasks.json" \
    || fail "AI task metadata does not route email through aurion-do"

  log "ISO content verification passed"
}

main "$@"
