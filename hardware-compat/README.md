# AurionOS Hardware Compatibility Foundation

Alpha v0.1 ships a graphical Hardware Center and a local scanner that report hardware facts without making driver changes.

The scanner is intentionally read-only:

- CPU and memory summary
- PCI and USB devices when tools are available
- block devices
- Secure Boot state when `mokutil` is available

`aurion-hardware-center` opens the graphical surface on the desktop. Use `aurion-hardware-center --cli` for terminal classification and `aurion-hw-scan` for raw facts.

Future work can expand the compatibility database and AI explanations, but third-party drivers must use Ubuntu's existing MOK enrollment workflow.
