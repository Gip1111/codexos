# Testing Guide

## Trigger the build from Windows

1. Push this repository to GitHub with the default branch named `main`.
2. Open the repository in GitHub.
3. Go to `Actions`.
4. Select `Build AurionOS Alpha ISO`.
5. Choose `Run workflow`.

The workflow also runs on every push to `main`.

## Download the ISO artifact

After the workflow completes:

1. Open the completed workflow run.
2. Scroll to `Artifacts`.
3. Download `aurion-os-alpha-iso`.
4. Extract the artifact zip.
5. The ISO path inside the artifact is:

```text
iso-build/output/aurion-os-0.1-alpha-amd64.iso
```

The build logs are in the separate `aurion-os-alpha-build-logs` artifact.

## First GitHub Actions milestone

For the first run, inspect these points in order:

1. `Install ISO build dependencies` finishes and `setup-builder.log` is uploaded.
2. `Build AurionOS ISO` downloads a Lubuntu 24.04 desktop amd64 ISO and verifies SHA256.
3. The log prints `Secure Boot critical file hashes are unchanged`.
4. `Verify ISO output` prints a SHA256 for `aurion-os-0.1-alpha-amd64.iso`.
5. `Verify ISO contents` confirms AurionOS branding, tools, welcome files, AI metadata, hardware database, and store catalog are present inside the ISO.
6. `aurion-os-alpha-iso` contains both the ISO and `.sha256` file.

If the run fails, download `aurion-os-alpha-build-logs` first. The most useful files are:

- `iso-build/build.log`
- `iso-build/logs/setup-builder.log`
- `iso-build/logs/secure-boot-hashes.diff`
- `iso-build/logs/xorriso-write.log`
- `iso-build/logs/mksquashfs.log`
- `iso-build/logs/verify-iso.log`
- `iso-build/logs/verify-filesystem.list`

## VM test

Recommended first VM settings:

- Firmware: UEFI
- Secure Boot: enabled if the VM platform supports Microsoft/Ubuntu Secure Boot keys
- CPU: 2 cores
- RAM: 4 GB minimum
- Disk: 30 GB
- Graphics: default virtual GPU

Basic VM acceptance:

1. Boot the ISO in UEFI mode.
2. Confirm the live desktop starts.
3. Confirm AurionOS wallpaper or release branding is visible.
4. Confirm the welcome page opens once or is available from `Welcome to AurionOS`.
5. Run `aurion-status`.
6. Run `aurion-hub`.
7. Run `aurion-control` and open each menu option.
8. Run `aurion-install --explain`.
9. Run `aurion-snapshot-plan`.
10. Run `aurion-diagnostics`.
11. Launch the installer.
12. Install to a blank VM disk.
13. Reboot into the installed system.

## USB test

Use a normal image-writing tool from Windows such as Rufus or balenaEtcher.

Recommended Rufus settings:

- Boot selection: downloaded AurionOS ISO
- Partition scheme: GPT
- Target system: UEFI
- File system: keep Rufus default
- Write mode: DD mode if prompted

Hardware acceptance:

1. Enable Secure Boot in firmware if the machine supports it and has enrolled keys.
2. Boot the USB in UEFI mode.
3. Confirm the live environment starts.
4. Confirm the AurionOS wallpaper is visible.
5. Run `aurion-status`.
6. Run `aurion-hw-scan`.
7. Run `aurion-hardware-center`.
8. Run `aurion-ai-status`.
9. Run `aurion-store`.
10. Run `aurion-hub`.
11. Run `aurion-install --explain`.
12. Run `aurion-snapshot-plan`.
13. Launch the installer and confirm the visible installer branding says AurionOS where safe.
14. Do not install to a real disk unless the target disk can be erased.

## Real hardware retest after platform foundation additions

Run:

```bash
cat /etc/os-release
cat /etc/aurionos-release
aurion-status
aurion-hub
aurion-channel
aurion-control
aurion-ai-status
aurion-hardware-center
aurion-store
aurion-install --explain
aurion-snapshot-plan
aurion-diagnostics
aurion-hw-scan
```

Expected improvements:

- `aurion-status` shows all AurionOS foundation tools as `[ok]`.
- `aurion-hub` opens or generates a local HTML overview report.
- `aurion-control` opens a grouped alpha control surface.
- `aurion-ai-status` shows Ollama/phi4-mini metadata and confirms cloud AI is disabled by default.
- `aurion-hardware-center` uses the alpha hardware database where it matches known devices.
- `aurion-store` lists the alpha catalog without installing packages.
- `aurion-install --explain` describes `.deb`, `.flatpakref`, and AppImage handling.
- `aurion-snapshot-plan` reports rollback readiness without changing disks.
- Terminal session variables report AurionOS instead of Lubuntu where the live shell allows it.
- Calamares visible strings should be rebranded from Lubuntu to AurionOS where text replacement is safe.
- Secure Boot may still report disabled if the PC firmware is in Setup Mode; that is a firmware state, not an ISO branding failure.

## Known alpha limits

- The assistant is mocked and does not download Ollama or `phi4-mini`.
- The labwc/Qt shell is not active.
- Plymouth branding is included but not enabled.
- Driver installation and DKMS are not part of v0.1.
- Aurion Store is catalog-only and does not install packages yet.
