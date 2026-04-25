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
5. `Verify ISO contents` confirms AurionOS branding, guarded session startup, LXQt profile, LabWC preview entry, native QML Experience pages, QML runtime metadata, wallpaper settings, tools, first-run launcher, AI metadata, graphical Store, graphical Hardware Center, graphical Diagnostics, hardware database, and store catalog are present inside the ISO.
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
3. Confirm the session does not stop at a cursor-only screen.
4. Confirm AurionOS wallpaper or release branding is visible.
5. Confirm the top panel says Aurion and the bottom dock shows Launcher, Aurion Experience, browser, file manager, Store, and installer.
6. Confirm desktop shortcuts exist for Aurion Launcher, Aurion Experience, Aurion Store, and Install AurionOS.
7. Confirm the Aurion Experience command surface opens automatically on the first live login and visually matches `docs/aurionos-home-target.svg` in direction: dark desktop, central command center, AI/status right panel, and bottom dock.
8. Confirm the preferred home is a native QML Aurion window without Firefox address/tab chrome. If Firefox opens, that means the fallback path was used; run `aurion-desktop-check` and inspect `/tmp/aurion-qml-surface.log`.
9. Confirm there is no duplicate `Install Lubuntu` desktop shortcut.
10. Click Browser, Files, Terminal, Store, Installer, and AI Assistant in the Aurion dock and confirm each opens the matching app or alpha surface.
11. Click Leggi email, Installa app, Controlla Wi-Fi, Diagnosi, Dettagli sistema, and an app Install button. Store, Hardware, Diagnostics, AI, and Control should switch inside the native Aurion window; external OS actions should route through `aurion-action://`.
12. Press `Super+Space` and confirm Aurion Launcher opens.
13. Press `Super+A` and confirm Aurion AI Sidebar opens.
14. Run `aurion-status`.
15. Run `aurion-webapp-open --path /usr/share/aurionos/experience/index.html` and confirm it prints a path under `AurionOSWeb`.
16. Run `aurion-shell`.
17. Run `aurion-qml-surface --page experience` and confirm the native QML Aurion home opens.
18. Run `aurion-qml-surface --page desktop` and confirm either the QML shell bridge opens or the HTML shell fallback opens.
19. Run `aurion-launcher`.
20. Run `aurion-ai-sidebar`.
21. Run `aurion-experience`.
22. Run `aurion-action aurion-action://browser`.
23. Run `aurion-task-assist "read email"`.
24. Run `aurion-hub`.
25. Run `aurion-control` and confirm the graphical control surface opens.
26. Run `aurion-control --cli` and open each terminal menu option.
27. Run `aurion-store` and confirm the graphical Store opens.
28. Run `aurion-hardware-center` and confirm the graphical Hardware Center opens.
29. Run `aurion-diagnostics` and confirm the graphical Diagnostics surface opens.
30. Run `aurion-ai-status-gui`.
31. Run `aurion-ai-service "check wifi"` and confirm it uses Ollama if ready or falls back to the safe task router.
32. Run `aurion-ai-setup --status`.
33. Run `aurion-ai-setup --install-ollama` and cancel at the confirmation prompt unless you intentionally want to install local AI.
34. Run `aurion-desktop-check`.
35. Run `aurion-startlabwc --check`; do not switch the real acceptance session away from LXQt for v0.1.
36. Run `aurion-install --explain`.
37. Run `aurion-snapshot-plan`.
38. Run `aurion-diagnostics --cli`.
39. Launch the installer.
40. Install to a blank VM disk.
41. Reboot into the installed system.

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
4. Confirm the session does not stop at a cursor-only screen.
5. Confirm the AurionOS wallpaper is visible.
6. Confirm the AurionOS top bar, bottom dock, app icons, and desktop shortcuts are visible.
7. Press `Super+Space` and confirm the Launcher opens.
8. Press `Super+A` and confirm the AI Sidebar opens.
9. Run `aurion-status`.
10. Run `aurion-shell`.
11. Run `aurion-qml-surface --page desktop`.
12. Run `aurion-hw-scan`.
13. Run `aurion-hardware-center`.
14. Run `aurion-ai-status`.
15. Run `aurion-ai-status-gui`.
16. Run `aurion-ai-setup --status`.
17. Run `aurion-ai-service "check wifi"`.
18. Run `aurion-store`.
19. Run `aurion-experience`.
20. Run `aurion-task-assist "install vlc"`.
21. Run `aurion-hub`.
22. Run `aurion-control --cli`.
23. Run `aurion-install --explain`.
24. Run `aurion-snapshot-plan`.
25. Launch the installer and confirm the visible installer branding says AurionOS where safe.
26. Do not install to a real disk unless the target disk can be erased.

## Real hardware retest after platform foundation additions

Run:

```bash
cat /etc/os-release
cat /etc/aurionos-release
aurion-status
aurion-session-guard
aurion-shell
aurion-qml-surface --page desktop
aurion-qml-surface --page experience
aurion-webapp-open --path /usr/share/aurionos/experience/index.html
aurion-launcher
aurion-ai-sidebar
aurion-do email
aurion-do store
aurion-do hardware
aurion-experience
aurion-task-assist "read email"
aurion-task-assist "install vlc"
aurion-hub
aurion-channel
aurion-control
aurion-control --cli
aurion-ai-status
aurion-ai-status-gui
aurion-ai-service "controlla wifi"
aurion-ai-setup --status
aurion-ai-setup --install-ollama
aurion-desktop-check
aurion-hardware-center
aurion-hardware-center --cli
aurion-store
aurion-store --cli
aurion-install --explain
aurion-snapshot-plan
aurion-diagnostics
aurion-diagnostics --cli
aurion-hw-scan
aurion-session-watchdog --once
aurion-startlabwc --check
```

Expected improvements:

- `aurion-status` shows all AurionOS foundation tools as `[ok]`.
- `aurion-session-guard` exits cleanly when it has already run for the session.
- `aurion-session-watchdog --once` exits without errors and does not create duplicate LXQt modules.
- `aurion-shell`, `aurion-launcher`, and `aurion-ai-sidebar` open the graphical shell alpha surface.
- `aurion-qml-surface --page experience`, `--page store`, `--page hardware`, `--page diagnostics`, and `--page ai` open the native QML command center without browser chrome; fallback uses the stable HTML surface.
- `aurion-webapp-open` materializes web surfaces under `~/AurionOSWeb` so Firefox Snap can load them on the live desktop.
- `aurion-do email`, `aurion-do store`, `aurion-do hardware`, and `aurion-do diagnostics` route common tasks through safe alpha tools.
- `aurion-experience` opens the graphical alpha shell.
- The LXQt theme is `aurionos-alpha`, Openbox theme is `AurionOS`, and desktop shortcuts use Aurion icons.
- `aurion-task-assist` maps email/browser/install/hardware/diagnostics tasks to safe actions.
- `aurion-hub` opens or generates a local HTML overview report.
- `aurion-control` opens a grouped alpha control surface.
- `aurion-ai-status` shows Ollama/phi4-mini metadata and confirms cloud AI is disabled by default.
- `aurion-ai-service` uses local Ollama only if available and falls back safely otherwise.
- `aurion-ai-setup --status` reports the optional local AI readiness without installing anything; `--install-ollama` asks for confirmation before downloading the optional local runtime.
- `aurion-desktop-check` reports QML runtime metadata, first-run routing, launcher paths, and HTML fallback status.
- `aurion-hardware-center` opens the graphical Hardware Center; `--cli` uses the alpha hardware database where it matches known devices.
- `aurion-store` opens the graphical Store; `--cli` lists the alpha catalog without installing packages.
- `aurion-diagnostics` opens the graphical Diagnostics surface; `--cli` prints the read-only report.
- `aurion-startlabwc` exists as a fallback-safe preview launcher; LXQt remains the default accepted live session.
- `aurion-install --explain` describes `.deb`, `.flatpakref`, and AppImage handling.
- `aurion-snapshot-plan` reports rollback readiness without changing disks.
- Terminal session variables report AurionOS instead of Lubuntu where the live shell allows it.
- Calamares visible strings should be rebranded from Lubuntu to AurionOS where text replacement is safe.
- Secure Boot may still report disabled if the PC firmware is in Setup Mode; that is a firmware state, not an ISO branding failure.

## Known alpha limits

- The assistant falls back to mocked/rule-based behavior unless the user has installed Ollama and pulled `phi4-mini`.
- The labwc/Qt shell is not active.
- LabWC Preview is not the default session and may fall back to LXQt if `labwc` is not installed.
- The QML command center depends on a QML runtime; without it, AurionOS intentionally uses the HTML graphical fallbacks.
- Plymouth branding is included but not enabled.
- Driver installation and DKMS are not part of v0.1.
- Aurion Store is graphical but catalog-only and does not install packages yet.
