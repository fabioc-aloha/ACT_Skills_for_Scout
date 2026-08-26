# ACT Skills for Scout

Experimental package and compatibility testbed for delivering Artificial Critical
Thinking skills to Microsoft Scout.

## Status

**Not publishable. Not a Plugin Mall package.**

This repository exists to validate whether a portable Agent Skills package can be
discovered by Scout through its documented local-skill folder, and to determine
whether a future Copilot plugin/Mall distribution path can be Scout-compatible.

### Current Evidence

Windows local-folder discovery passed on Scout 1.0.73: the probe was discovered
from `~/.copilot/skills` in a new conversation, while
`loadCopilotCliSkills` remained disabled. The probe did not appear in the
in-app custom-skill inventory. Removal/non-discovery, updates, rollback, UI
management, macOS, cross-device behavior, Copilot plugins, and Plugin Mall
remain unvalidated.

## Repository Layout

| Path | Purpose |
| --- | --- |
| `packages/` | Future versioned ACT Skills for Scout packages. |
| `probes/local-folder/` | Harmless disposable package used to test local Scout discovery. |
| `docs/TEST-PLAN.md` | Required evidence and stop conditions for the probe. |
| `docs/PROBE-REPORT-2026-08-26.md` | Windows discovery result and remaining validation work. |
| `docs/UNINSTALL.md` | Removal instructions for every planned delivery path. |

## Safety Rules

- Do not install a Copilot plugin, register a marketplace, enable
  `loadCopilotCliSkills`, or modify Scout settings from this repository.
- The first probe contains no scripts, references, assets, MCP configuration,
  credentials, external calls, or filesystem writes.
- The probe must be removed after each test. A folder listing is not evidence of
  Scout discovery; validate in a new Scout conversation.
- A future production package must remain an Agent Skills-compatible folder with
  `SKILL.md` as its portable contract.

See [the test plan](docs/TEST-PLAN.md) before any test and
[uninstall instructions](docs/UNINSTALL.md) before installing anything.
