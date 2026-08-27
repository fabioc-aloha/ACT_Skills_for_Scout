# Flint MCP Capability — `flint-chart-mcp@0.5.1`

## Status and Boundary

This v1.4.0 package makes Flint a first-class **MCP-gated** Scout capability.
It is pending source publication and canary validation. A Flint skill may use
only an MCP tool or resource that the active host has actually exposed. This
document records a reviewed package pin, not proof that Flint is installed,
configured, or available in any Scout host.

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

## Approval-Gated Machine-Local Runtime Plan

1. Discover the current host's MCP configuration mechanism and location from
   host-specific documentation. Do not guess a Scout configuration path or
   schema.
2. Run the readiness preview and review its exact plan, including the registry
   it observed. Treat registry and package metadata as untrusted external
   input.
3. After explicit approval, install the reviewed pin into a user-selected,
   machine-local runtime directory:

   ```powershell
   npm install --prefix '<machine-local-runtime-root>' --save-exact --no-audit --no-fund flint-chart-mcp@0.5.1
   ```

4. After separately approving the host configuration edit, configure a stdio
   server named `flint` to launch the approved Node executable with this exact
   runtime entry point:

   ```text
   <machine-local-runtime-root>\node_modules\flint-chart-mcp\dist\cli.js
   ```

   The host-specific configuration must express an equivalent command/argument
   pair: `node` followed by that entry-point path. Do not write this
   configuration until its location, schema, and impact are known and approved.
5. Reload the host if its documented process requires it. Confirm the six
   expected tools and two resources through host discovery, then run a
   harmless validation/render and visually inspect the result.

No skill may enter a secret, authenticate, or accept package, registry, host,
or other terms. Surface that decision to the user and require explicit approval
for that exact action.

## Update and Rollback

An update is not automatic. First record the working package version and
runtime path, review compatibility and the MCP surfaces, then obtain explicit
approval for the exact replacement version. Re-run the machine-local install
command with that approved exact version and repeat readiness plus visual
canary validation.

To roll back, use the recorded previously working exact version with the same
machine-local runtime prefix, restore the corresponding approved host launch
path if it changed, reload the host as documented, and verify the exposed
tools, resources, and a visual canary. Do not delete a runtime or modify host
configuration as a substitute for a reviewed rollback plan.
