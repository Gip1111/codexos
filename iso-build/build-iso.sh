#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO_BUILD_DIR="$PROJECT_ROOT/iso-build"
CACHE_DIR="${AURION_CACHE_DIR:-$ISO_BUILD_DIR/cache}"
WORK_DIR="${AURION_WORK_DIR:-$ISO_BUILD_DIR/work}"
OUTPUT_DIR="$ISO_BUILD_DIR/output"
LOG_DIR="$ISO_BUILD_DIR/logs"

IMAGE_NAME="aurion-os-0.1-alpha-amd64.iso"
OUT_ISO="$OUTPUT_DIR/$IMAGE_NAME"
VOLUME_ID="${AURION_VOLUME_ID:-AurionOS 0.1 amd64}"
LUBUNTU_RELEASE_URL="${LUBUNTU_RELEASE_URL:-https://cdimage.ubuntu.com/lubuntu/releases/noble/release}"

if [ "$(id -u)" -eq 0 ]; then
  SUDO=()
else
  SUDO=(sudo)
fi

log() {
  printf '[aurion-build] %s\n' "$*" >&2
}

fail() {
  printf '[aurion-build] ERROR: %s\n' "$*" >&2
  exit 1
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

  if [ -e "$target_abs" ]; then
    "${SUDO[@]}" rm -rf --one-file-system "$target_abs"
  fi
}

record_secure_boot_hashes() {
  local root="$1"
  local output="$2"
  : > "$output"

  {
    [ -d "$root/EFI" ] && find "$root/EFI" -type f
    [ -d "$root/boot/grub" ] && find "$root/boot/grub" -maxdepth 2 -type f \( -name 'efi.img' -o -name 'eltorito.img' -o -name 'boot_hybrid.img' \)
    [ -d "$root/casper" ] && find "$root/casper" -maxdepth 1 -type f \( -name 'vmlinuz*' -o -name 'initrd*' \)
  } | sort | while IFS= read -r file; do
    [ -n "$file" ] && sha256sum "$file"
  done | sed "s#  $root/#  #" > "$output"
}

require_builder_tools() {
  local missing=()
  local tool

  for tool in awk basename chmod curl diff du find grep install mksquashfs realpath rsvg-convert rsync sed sha256sum sort stat tee unsquashfs xargs xorriso; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      missing+=("$tool")
    fi
  done

  if [ "${#missing[@]}" -gt 0 ]; then
    fail "Missing required builder tools: ${missing[*]}"
  fi
}

download_base_iso() {
  mkdir -p "$CACHE_DIR"

  if [ -n "${LUBUNTU_ISO_URL:-}" ]; then
    local iso_url="$LUBUNTU_ISO_URL"
    local iso_name
    iso_name="$(basename "$iso_url")"
    [ -n "$iso_name" ] || fail "Could not determine ISO name from LUBUNTU_ISO_URL"

    log "Using explicit Lubuntu ISO URL: $iso_url"
    if [ ! -s "$CACHE_DIR/$iso_name" ]; then
      curl -fL --retry 5 --retry-delay 5 -o "$CACHE_DIR/$iso_name" "$iso_url"
    fi

    if [ -n "${LUBUNTU_ISO_SHA256:-}" ]; then
      (cd "$CACHE_DIR" && printf '%s *%s\n' "$LUBUNTU_ISO_SHA256" "$iso_name" | sha256sum -c -) >&2
    else
      log "No LUBUNTU_ISO_SHA256 was provided for explicit ISO URL; skipping checksum verification."
    fi

    printf '%s\n' "$CACHE_DIR/$iso_name"
    return
  fi

  local sums="$CACHE_DIR/SHA256SUMS"
  log "Resolving Lubuntu 24.04 LTS desktop ISO from $LUBUNTU_RELEASE_URL"
  curl -fL --retry 5 --retry-delay 5 -o "$sums" "$LUBUNTU_RELEASE_URL/SHA256SUMS"

  local iso_name
  iso_name="$(
    awk '/lubuntu-24\.04(\.[0-9]+)?-desktop-amd64\.iso$/ && !/\.zsync$/ { name=$2; sub(/^\*/, "", name); print name }' "$sums" \
      | sort -V \
      | tail -n 1
  )"

  [ -n "$iso_name" ] || fail "Could not find a Lubuntu 24.04 desktop amd64 ISO in SHA256SUMS"

  local selected="$CACHE_DIR/SHA256SUMS.selected"
  awk -v iso="$iso_name" '{ name=$2; sub(/^\*/, "", name); if (name == iso) print $0 }' "$sums" > "$selected"
  [ -s "$selected" ] || fail "Could not select checksum for $iso_name"

  if [ ! -s "$CACHE_DIR/$iso_name" ]; then
    log "Downloading $iso_name"
    curl -fL --retry 5 --retry-delay 5 -o "$CACHE_DIR/$iso_name" "$LUBUNTU_RELEASE_URL/$iso_name"
  else
    log "Using cached $iso_name"
  fi

  log "Verifying base ISO checksum"
  (cd "$CACHE_DIR" && sha256sum -c "$selected") >&2
  printf '%s\n' "$CACHE_DIR/$iso_name"
}

install_doc_payload() {
  local rootfs="$1"
  local doc_dir="$rootfs/usr/share/doc/aurionos"

  "${SUDO[@]}" install -d -m 0755 "$doc_dir"
  "${SUDO[@]}" install -m 0644 "$PROJECT_ROOT/README.md" "$doc_dir/README.md"
  "${SUDO[@]}" install -m 0644 "$PROJECT_ROOT/docs/alpha-scope.md" "$doc_dir/alpha-scope.md"
  "${SUDO[@]}" install -m 0644 "$PROJECT_ROOT/docs/final-project-foundations.md" "$doc_dir/final-project-foundations.md"
  "${SUDO[@]}" install -m 0644 "$PROJECT_ROOT/docs/iso-build-plan.md" "$doc_dir/iso-build-plan.md"
  "${SUDO[@]}" install -m 0644 "$PROJECT_ROOT/docs/secure-boot-strategy.md" "$doc_dir/secure-boot-strategy.md"
  "${SUDO[@]}" install -m 0644 "$PROJECT_ROOT/docs/testing-guide.md" "$doc_dir/testing-guide.md"
  "${SUDO[@]}" install -m 0644 "$PROJECT_ROOT/docs/visual-design.md" "$doc_dir/visual-design.md"
}

install_tool_payload() {
  local rootfs="$1"

  if [ -d "$PROJECT_ROOT/distro/branding/usr" ]; then
    "${SUDO[@]}" rsync -a "$PROJECT_ROOT/distro/branding/usr/" "$rootfs/usr/"
  fi

  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/ai-services/aurion-assistant" "$rootfs/usr/local/bin/aurion-assistant"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/ai-services/aurion-ai-status" "$rootfs/usr/local/bin/aurion-ai-status"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/ai-services/aurion-task-assist" "$rootfs/usr/local/bin/aurion-task-assist"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/app-installer/aurion-appimage-integrate" "$rootfs/usr/local/bin/aurion-appimage-integrate"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/app-installer/aurion-install" "$rootfs/usr/local/bin/aurion-install"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/app-store/aurion-store" "$rootfs/usr/local/bin/aurion-store"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/control-center/aurion-control" "$rootfs/usr/local/bin/aurion-control"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/experience/aurion-experience" "$rootfs/usr/local/bin/aurion-experience"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/hub/aurion-hub" "$rootfs/usr/local/bin/aurion-hub"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/hardware-compat/aurion-hw-scan" "$rootfs/usr/local/bin/aurion-hw-scan"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/hardware-compat/aurion-hardware-center" "$rootfs/usr/local/bin/aurion-hardware-center"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/diagnostics/aurion-channel" "$rootfs/usr/local/bin/aurion-channel"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/diagnostics/aurion-diagnostics" "$rootfs/usr/local/bin/aurion-diagnostics"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/diagnostics/aurion-rollback-status" "$rootfs/usr/local/bin/aurion-rollback-status"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/diagnostics/aurion-status" "$rootfs/usr/local/bin/aurion-status"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/rollback/aurion-snapshot-plan" "$rootfs/usr/local/bin/aurion-snapshot-plan"

  if compgen -G "$PROJECT_ROOT/shell/bin/*" > /dev/null; then
    for tool in "$PROJECT_ROOT"/shell/bin/*; do
      [ -f "$tool" ] || continue
      "${SUDO[@]}" install -Dm0755 "$tool" "$rootfs/usr/local/bin/$(basename "$tool")"
    done
  fi

}

install_home_file() {
  local source="$1"
  local home="$2"
  local relative_target="$3"
  local mode="${4:-0644}"

  [ -f "$source" ] || fail "Missing home branding source: $source"
  "${SUDO[@]}" install -Dm"$mode" "$source" "$home/$relative_target"
}

install_visual_profile_to_home() {
  local home="$1"
  local lxqt_source="$PROJECT_ROOT/distro/session/lxqt"
  local launcher_source="$PROJECT_ROOT/distro/session/desktop"

  install_home_file "$lxqt_source/pcmanfm-qt-settings.conf" "$home" ".config/pcmanfm-qt/lxqt/settings.conf"
  install_home_file "$lxqt_source/lxqt.conf" "$home" ".config/lxqt/lxqt.conf"
  install_home_file "$lxqt_source/panel.conf" "$home" ".config/lxqt/panel.conf"
  install_home_file "$lxqt_source/session.conf" "$home" ".config/lxqt/session.conf"
  install_home_file "$lxqt_source/globalkeyshortcuts.conf" "$home" ".config/lxqt/globalkeyshortcuts.conf"
  install_home_file "$PROJECT_ROOT/distro/session/openbox/lxqt-rc.xml" "$home" ".config/openbox/lxqt-rc.xml"

  if compgen -G "$launcher_source/*.desktop" > /dev/null; then
    for launcher in "$launcher_source"/*.desktop; do
      [ -f "$launcher" ] || continue
      install_home_file "$launcher" "$home" "Desktop/$(basename "$launcher")" 0755
    done
  fi
}

apply_home_branding() {
  local rootfs="$1"

  install_visual_profile_to_home "$rootfs/etc/skel"

  if compgen -G "$rootfs/home/*" > /dev/null; then
    for home in "$rootfs"/home/*; do
      [ -d "$home" ] || continue
      install_visual_profile_to_home "$home"
      local owner
      owner="$(${SUDO[@]} stat -c '%u:%g' "$home")"
      "${SUDO[@]}" chown -R "$owner" "$home/.config"
      [ ! -d "$home/Desktop" ] || "${SUDO[@]}" chown -R "$owner" "$home/Desktop"
    done
  fi
}

apply_session_selection() {
  local rootfs="$1"
  local session_source="$PROJECT_ROOT/distro/session/aurionos-lxqt.desktop"

  "${SUDO[@]}" install -Dm0644 "$session_source" "$rootfs/usr/share/xsessions/aurionos-lxqt.desktop"
  "${SUDO[@]}" install -Dm0644 "$session_source" "$rootfs/usr/share/xsessions/AurionOS.desktop"
  "${SUDO[@]}" install -Dm0644 "$session_source" "$rootfs/usr/share/xsessions/Lubuntu.desktop"
  "${SUDO[@]}" install -Dm0644 "$session_source" "$rootfs/usr/share/xsessions/lubuntu.desktop"
  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/session/profile/aurionos-session.sh" "$rootfs/etc/profile.d/aurionos-session.sh"

  for session_file in \
    "$rootfs/etc/sddm.conf" \
    "$rootfs"/etc/sddm.conf.d/*.conf \
    "$rootfs"/var/lib/AccountsService/users/*; do
    [ -f "$session_file" ] || continue
    "${SUDO[@]}" sed -i \
      -e 's/^Session=.*/Session=aurionos-lxqt.desktop/' \
      -e 's/^XSession=.*/XSession=aurionos-lxqt/' \
      "$session_file"
  done
}

apply_installer_branding() {
  local rootfs="$1"
  local paths=()

  [ -d "$rootfs/etc/calamares" ] && paths+=("$rootfs/etc/calamares")
  [ -d "$rootfs/usr/share/calamares" ] && paths+=("$rootfs/usr/share/calamares")
  [ -d "$rootfs/usr/share/applications" ] && paths+=("$rootfs/usr/share/applications")
  [ -d "$rootfs/etc/skel" ] && paths+=("$rootfs/etc/skel")
  [ -d "$rootfs/home" ] && paths+=("$rootfs/home")

  [ "${#paths[@]}" -gt 0 ] || return 0

  log "Applying safe text rebranding for Calamares and installer launchers"
  while IFS= read -r -d '' file; do
    "${SUDO[@]}" sed -i \
      -e 's/Try or Install Lubuntu/Try or Install AurionOS/g' \
      -e 's/Try Lubuntu without installing/Try AurionOS without installing/g' \
      -e 's/Install Lubuntu/Install AurionOS/g' \
      -e 's/Welcome to Lubuntu/Welcome to AurionOS/g' \
      -e 's/Lubuntu/AurionOS/g' \
      "$file"
  done < <("${SUDO[@]}" grep -IlZ -E 'Lubuntu|Install Lubuntu|Try or Install Lubuntu' "${paths[@]}" 2>/dev/null || true)
}

apply_branding() {
  local iso_root="$1"
  local rootfs="$2"

  log "Applying AurionOS branding to live filesystem"

  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/branding/os-release" "$rootfs/usr/lib/os-release"
  "${SUDO[@]}" ln -sfn ../usr/lib/os-release "$rootfs/etc/os-release"
  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/branding/lsb-release" "$rootfs/etc/lsb-release"
  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/branding/issue" "$rootfs/etc/issue"
  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/branding/issue.net" "$rootfs/etc/issue.net"
  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/branding/motd" "$rootfs/etc/motd"
  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/branding/aurionos-release" "$rootfs/etc/aurionos-release"

  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/session/autostart/aurion-live-branding.desktop" "$rootfs/etc/xdg/autostart/aurion-live-branding.desktop"
  "${SUDO[@]}" install -Dm0755 "$PROJECT_ROOT/distro/session/scripts/aurion-apply-live-branding" "$rootfs/usr/local/bin/aurion-apply-live-branding"

  "${SUDO[@]}" install -Dm0644 "$PROJECT_ROOT/distro/wallpapers/aurionos-alpha.svg" "$rootfs/usr/share/backgrounds/aurionos/aurionos-alpha.svg"
  rsvg-convert -w 1920 -h 1080 "$PROJECT_ROOT/distro/wallpapers/aurionos-alpha.svg" -o "$WORK_DIR/aurionos-alpha.png"
  "${SUDO[@]}" install -Dm0644 "$WORK_DIR/aurionos-alpha.png" "$rootfs/usr/share/backgrounds/aurionos/aurionos-alpha.png"

  "${SUDO[@]}" install -d -m 0755 "$rootfs/usr/share/plymouth/themes/aurionos"
  "${SUDO[@]}" rsync -a "$PROJECT_ROOT/distro/plymouth/" "$rootfs/usr/share/plymouth/themes/aurionos/"

  install_tool_payload "$rootfs"
  install_doc_payload "$rootfs"
  apply_home_branding "$rootfs"
  apply_session_selection "$rootfs"
  apply_installer_branding "$rootfs"

  log "Applying safe ISO-level text branding"
  mkdir -p "$iso_root/.disk"
  printf 'AurionOS Alpha Fast Track v0.1 amd64 - Lubuntu 24.04 LTS base\n' > "$iso_root/.disk/info"

  if [ -f "$iso_root/README.diskdefines" ]; then
    sed -i 's/Lubuntu/AurionOS/g; s/Ubuntu/AurionOS/g' "$iso_root/README.diskdefines"
  fi

  for grub_cfg in "$iso_root/boot/grub/grub.cfg" "$iso_root/boot/grub/loopback.cfg"; do
    if [ -f "$grub_cfg" ]; then
      sed -i \
        -e 's/Try or Install Lubuntu/Try or Install AurionOS/g' \
        -e 's/Try Lubuntu without installing/Try AurionOS without installing/g' \
        -e 's/Install Lubuntu/Install AurionOS/g' \
        -e 's/Lubuntu/AurionOS/g' \
        "$grub_cfg"
    fi
  done
}

run_hooks() {
  local rootfs="$1"
  local iso_root="$2"
  local hook_dir="$ISO_BUILD_DIR/hooks"

  [ -d "$hook_dir" ] || return 0

  while IFS= read -r -d '' hook; do
    log "Running hook $(basename "$hook")"
    AURION_ROOTFS="$rootfs" \
    AURION_ISO_ROOT="$iso_root" \
    AURION_PROJECT_ROOT="$PROJECT_ROOT" \
    bash "$hook"
  done < <(find "$hook_dir" -maxdepth 1 -type f -name '*.sh' -print0 | sort -z)
}

rebuild_squashfs() {
  local iso_root="$1"
  local rootfs="$2"
  local squashfs="$iso_root/casper/filesystem.squashfs"

  [ -f "$squashfs" ] || fail "Missing expected squashfs at $squashfs"

  log "Rebuilding live filesystem squashfs"
  rm -f "$squashfs"
  "${SUDO[@]}" mksquashfs "$rootfs" "$squashfs" -noappend -comp xz -Xbcj x86 -b 1M | tee "$LOG_DIR/mksquashfs.log"
  "${SUDO[@]}" chown "$(id -u):$(id -g)" "$squashfs"

  "${SUDO[@]}" du -sx --block-size=1 "$rootfs" | awk '{ print $1 }' > "$iso_root/casper/filesystem.size"
}

regenerate_md5sums() {
  local iso_root="$1"

  log "Regenerating md5sum.txt"
  (
    cd "$iso_root"
    find . -type f \
      ! -path './md5sum.txt' \
      ! -path './boot.catalog' \
      -print0 \
      | sort -z \
      | xargs -0 md5sum
  ) > "$iso_root/md5sum.txt"
}

write_iso() {
  local base_iso="$1"
  local iso_root="$2"
  local tmp_iso="$OUTPUT_DIR/$IMAGE_NAME.tmp"

  log "Writing final ISO to $OUT_ISO"
  rm -f "$OUT_ISO"
  rm -f "$tmp_iso"

  local xorriso_log="$LOG_DIR/xorriso-write.log"
  xorriso \
    -indev "$base_iso" \
    -outdev "$OUT_ISO" \
    -overwrite on \
    -boot_image any replay \
    -volid "$VOLUME_ID" \
    -map "$iso_root/casper/filesystem.squashfs" /casper/filesystem.squashfs \
    -map "$iso_root/casper/filesystem.size" /casper/filesystem.size \
    -map "$iso_root/md5sum.txt" /md5sum.txt \
    -map "$iso_root/.disk/info" /.disk/info \
    2>&1 | tee "$xorriso_log"

  if [ -f "$iso_root/README.diskdefines" ]; then
    rm -f "$tmp_iso"
    xorriso \
      -indev "$OUT_ISO" \
      -outdev "$tmp_iso" \
      -overwrite on \
      -boot_image any replay \
      -map "$iso_root/README.diskdefines" /README.diskdefines \
      2>&1 | tee -a "$xorriso_log"
    mv "$tmp_iso" "$OUT_ISO"
  fi

  for grub_cfg in "$iso_root/boot/grub/grub.cfg" "$iso_root/boot/grub/loopback.cfg"; do
    [ -f "$grub_cfg" ] || continue
    local iso_path="/${grub_cfg#"$iso_root"/}"
    rm -f "$tmp_iso"
    xorriso \
      -indev "$OUT_ISO" \
      -outdev "$tmp_iso" \
      -overwrite on \
      -boot_image any replay \
      -map "$grub_cfg" "$iso_path" \
      2>&1 | tee -a "$xorriso_log"
    mv "$tmp_iso" "$OUT_ISO"
  done

  [ -s "$OUT_ISO" ] || fail "ISO was not produced at $OUT_ISO"
  sha256sum "$OUT_ISO" > "$OUT_ISO.sha256"
  ls -lh "$OUT_ISO" "$OUT_ISO.sha256"
}

main() {
  require_builder_tools

  mkdir -p "$CACHE_DIR" "$OUTPUT_DIR" "$LOG_DIR"
  safe_rm_dir "$WORK_DIR"
  mkdir -p "$WORK_DIR"

  local base_iso
  base_iso="$(download_base_iso)"
  [ -s "$base_iso" ] || fail "Base ISO does not exist: $base_iso"

  local iso_root="$WORK_DIR/iso-root"
  local rootfs="$WORK_DIR/rootfs"

  log "Extracting ISO contents"
  mkdir -p "$iso_root"
  xorriso -osirrox on -indev "$base_iso" -extract / "$iso_root" 2>&1 | tee "$LOG_DIR/xorriso-extract.log"
  chmod -R u+w "$iso_root"

  record_secure_boot_hashes "$iso_root" "$LOG_DIR/secure-boot-hashes.before"

  log "Extracting live filesystem"
  "${SUDO[@]}" unsquashfs -d "$rootfs" "$iso_root/casper/filesystem.squashfs" 2>&1 | tee "$LOG_DIR/unsquashfs.log"

  apply_branding "$iso_root" "$rootfs"
  run_hooks "$rootfs" "$iso_root"
  rebuild_squashfs "$iso_root" "$rootfs"

  record_secure_boot_hashes "$iso_root" "$LOG_DIR/secure-boot-hashes.after"
  if ! diff -u "$LOG_DIR/secure-boot-hashes.before" "$LOG_DIR/secure-boot-hashes.after" > "$LOG_DIR/secure-boot-hashes.diff"; then
    cat "$LOG_DIR/secure-boot-hashes.diff" >&2
    fail "Secure Boot critical files changed unexpectedly"
  fi
  log "Secure Boot critical file hashes are unchanged"

  regenerate_md5sums "$iso_root"
  write_iso "$base_iso" "$iso_root"

  log "Build complete: $OUT_ISO"
}

main "$@"
