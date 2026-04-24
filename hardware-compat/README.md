# AurionOS Hardware Compatibility Foundation

Alpha v0.1 ships a local scanner that reports hardware facts without making driver changes.

The scanner is intentionally read-only:

- CPU and memory summary
- PCI and USB devices when tools are available
- block devices
- Secure Boot state when `mokutil` is available

Future work can add a compatibility database and AI explanations, but third-party drivers must use Ubuntu's existing MOK enrollment workflow.

