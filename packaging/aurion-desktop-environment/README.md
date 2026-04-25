# Aurion Desktop Environment Packaging Manifest

This is the first packaging split for the AurionOS desktop layer. The alpha ISO
still installs files directly during remastering, but the manifest defines the
future `.deb` package boundaries.

Packages:

- `aurion-desktop-environment`: meta package depending on the shell pieces.
- `aurion-shell`: native shell hub, topbar, dock, launcher.
- `aurion-settings`: control center and settings surfaces.
- `aurion-files`: file manager shell.
- `aurion-notifications`: notification center and notifier bridge.
- `aurion-session`: session entries and startup scripts.
- `aurion-sddm-theme`: login theme assets.
