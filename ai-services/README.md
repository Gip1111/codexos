# AurionOS AI Services

AurionOS uses a provider-agnostic assistant design.

Alpha v0.1 ships a mock local assistant so ISO boot and install are not blocked by model downloads. The later default local runtime target is Ollama with `phi4-mini`. Cloud AI must remain optional, opt-in, and disabled by default.

Planned provider boundary:

- `aurion-assistant`: user-facing command and later UI bridge
- local provider: Ollama, preferred model `phi4-mini`
- cloud providers: disabled unless the user explicitly enables one
- diagnostics context: hardware scan, logs, package state, rollback state

