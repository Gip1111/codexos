# AurionOS AI Services

AurionOS uses a provider-agnostic assistant design.

Alpha v0.1 ships a mock local assistant so ISO boot and install are not blocked by model downloads. It also includes an optional local bridge that uses Ollama with `phi4-mini` only when the user has installed Ollama and pulled the model. Cloud AI must remain optional, opt-in, and disabled by default.

Planned provider boundary:

- `aurion-assistant`: user-facing command and later UI bridge
- `aurion-do`: safe alpha action runner for common desktop tasks
- `aurion-task-assist`: rule-based alpha task router for common desktop actions
- `aurion-ai-service`: optional local Ollama bridge with rule-based fallback
- `aurion-ai-setup`: status and guided setup for the local model path
- local provider: Ollama, preferred model `phi4-mini`
- cloud providers: disabled unless the user explicitly enables one
- diagnostics context: hardware scan, logs, package state, rollback state
