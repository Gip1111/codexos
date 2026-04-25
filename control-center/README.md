# AurionOS Control Center Foundation

The alpha control center opens `aurion-settings` when a desktop session is available and keeps a terminal-safe launcher through `aurion-control --cli`. It groups the OS features expected in the final product:

- system status
- hardware compatibility
- AI provider status
- app installation foundation
- diagnostics
- rollback status

The final implementation should become a packaged Qt6/QML application. The alpha command is intentionally fallback-safe so it can ship in the live ISO without adding package risk.
