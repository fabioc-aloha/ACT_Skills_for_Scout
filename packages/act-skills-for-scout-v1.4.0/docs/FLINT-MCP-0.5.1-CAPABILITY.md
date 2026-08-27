# Flint MCP Capability — `flint-chart-mcp@0.5.1`

## Status and Boundary

This v1.4.0 package makes Flint a first-class **MCP-gated** Scout capability.
Source-machine publication and its active-host visual canary passed on
2026-08-27. A Flint skill may use only an MCP tool or resource that the active
host has actually exposed. This document records a reviewed package pin, not
proof that Flint is installed, configured, or available in every Scout host.

The version-pinned runtime contract is:

| Surface | Reviewed names |
| --- | --- |
| Package | `flint-chart-mcp@0.5.1` |
| Tools | `render_chart`, `compile_chart`, `validate_chart`, `list_chart_types`, `list_themes`, `create_chart_view` |
| Resources | `flint://agent-skill`, `flint://theme-skill` |

Load the available version-matched resource before relying on exact Flint
grammar. Do not vendor or infer grammar, tool arguments, chart types, semantic
types, or ThemeSpec keys from this document.

## Capability Limits

| Backend | Output and support boundary |
| --- | --- |
| Vega-Lite | SVG or PNG; supports ThemeSpec and `create_chart_view` where the host supports MCP Apps. |
| ECharts | SVG or PNG; ignores ThemeSpec. |
| Chart.js | PNG only; does not support ThemeSpec or `create_chart_view`. |

`validate_chart` establishes runtime validity and may report warnings, but it
does not establish visual quality. Every delivery chart requires visual
inspection of a rendered artifact or a supported interactive view. Keep data
semantics and analytical choices separate from the visual theme.

## Readiness Preview

Run the package-only, non-mutating preview from this package root:

```powershell
.\scripts\Test-FlintReadiness.ps1 -RuntimeRoot '<machine-local-runtime-root>' `
  -AvailableMcpTool '<tool observed through host-specific discovery>'
```

The preview checks Node and npm availability, npm's configured registry, the
local runtime package state, and the supplied observed tool names. It neither
downloads packages nor writes files or MCP configuration. If no observed tool
names are supplied, it reports MCP tool availability as unverified rather than
guessing a Scout configuration location.

## Approval-Gated Scout Registration

1. Run the published `Install-ActSkillsForScout.ps1` without parameters to
   inspect its exact change. It targets the reviewed Scout user configuration
   and creates no file or configuration change in preview mode.
2. After explicit approval, run it with `-Apply`. It first backs up the
   configuration, then adds only the reviewed `flint` entry. It refuses a
   differing existing entry.
3. The entry launches `npx -y flint-chart-mcp@0.5.1
   --disable-file-reference`; `npx` resolves the exact package on first server
   launch rather than installing a global binary.
4. Restart Scout, confirm the six expected tools through host discovery, then
   run a harmless validation/render and visually inspect the result.

No skill may enter a secret, authenticate, or accept package, registry, host,
or other terms. Surface that decision to the user and require explicit approval
for that exact action.

## Update and Rollback

An update is not automatic. First record the working package version, review
compatibility and the MCP surfaces, then obtain explicit approval for the exact
replacement version. Update the installer and registration as one reviewed
change, then repeat readiness plus visual canary validation.

To unregister Flint, use the published
`Uninstall-ActSkillsForScout.ps1 -Apply` script. It backs up the configuration
and refuses to remove a differently configured entry. Restart Scout and
confirm the server is disconnected. Do not delete a runtime or modify host
configuration as a substitute for a reviewed rollback plan.
