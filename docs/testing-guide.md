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
5. `aurion-os-alpha-iso` contains both the ISO and `.sha256` file.

If the run fails, download `aurion-os-alpha-build-logs` first. The most useful files are:

- `iso-build/build.log`
- `iso-build/logs/setup-builder.log`
- `iso-build/logs/secure-boot-hashes.diff`
- `iso-build/logs/xorriso-write.log`
- `iso-build/logs/mksquashfs.log`

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
4. Open the application menu and launch `Aurion Assistant`.
5. Run `aurion-diagnostics`.
6. Launch the installer.
7. Install to a blank VM disk.
8. Reboot into the installed system.

## USB test

Use a normal image-writing tool from Windows such as Rufus or balenaEtcher.

Recommended Rufus settings:

- Boot selection: downloaded AurionOS ISO
- Partition scheme: GPT
- Target system: UEFI
- File system: keep Rufus default
- Write mode: DD mode if prompted

Hardware acceptance:

1. Enable Secure Boot in firmware.
2. Boot the USB in UEFI mode.
3. Confirm the live environment starts.
4. Run `aurion-hw-scan`.
5. Launch the installer.

## Known alpha limits

- The assistant is mocked and does not download Ollama or `phi4-mini`.
- The labwc/Qt shell is not active.
- Plymouth branding is included but not enabled.
- Driver installation and DKMS are not part of v0.1.
- App store and graphical package flows are deferred.
