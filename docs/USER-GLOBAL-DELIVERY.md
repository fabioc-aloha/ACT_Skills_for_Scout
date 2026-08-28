# User-Global Skill Delivery

## Purpose

Deliver ACT skills once per Microsoft 365 user without installing them into each
repository or workspace. Every Scout conversation on a configured Windows
machine uses the same user-global skills.

## Architecture

```text
GitHub repository
  Versioned source package
        |
        | Install-ActSkillsForScout.ps1 -Publish -Apply
        v
OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout\
  Synced personal library
        |
        | Install-ActSkillsForScout.ps1 -Apply (once per machine)
        v
%USERPROFILE%\.copilot\skills\
  Named Windows junctions to each direct skill folder
        |
        v
New Scout conversations on that machine
```

The GitHub repository is the source of truth. The OneDrive library is a
published, syncable copy, not a Git working tree. The local Scout skill root
contains only junctions, so it does not contain a second independent copy of
the skills.

## v1.12.0 Production Package

`v1.12.0` is the publisher default. Its 27 direct skill folders include
`act-office-native-authoring`, which creates native Word, PowerPoint, and Excel
artifacts from approved source material using Scout Co-create capabilities
rather than Markdown conversion. It also publishes a separate reviewed MCP
profile catalog. The library shape is:

The standard library path is:

```text
%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout\
```

It contains:

```text
Install-ActSkillsForScout.ps1
Uninstall-ActSkillsForScout.ps1
Install-ActMcpProfile.ps1
Uninstall-ActMcpProfile.ps1
Test-ActMcpCatalog.ps1
MCP-CATALOG.md
FABRIC-SYNAPSE-EVIDENCE.md
library-manifest.json
mcp-catalog\
skills\
  act-constellation-curation\
  act-critical-review\
  act-session-closeout\
  act-meditation-continuity\
  act-vscode-workspace-bootstrap\
  act-skill-library-update\
  act-critical-thinking\
  act-problem-framing\
  act-implementation-planning\
  act-systematic-debugging\
  act-test-driven-development\
  act-security-hardening\
  act-git-safety\
  act-documentation-hygiene\
  act-writing-craft\
  act-status-reporting\
  act-responsible-ai-review\
  act-library-health-audit\
  act-content-currency-audit\
  act-skill-inventory-report\
  act-feasibility-spike\
  act-browser-safety\
  act-project-capability-authoring\
  act-office-native-authoring\
  act-flint-readiness\
  act-flint-chart\
  act-flint-theme\
```

Each folder directly beneath `skills\` must contain a `SKILL.md`. This direct
folder shape is the contract consumed by the bootstrap and exposed to Scout.

## Source Machine Install and Update

On the machine that maintains the repository, publish the current package and
enable its user-global junctions with one command:

```powershell
Set-Location C:\Development\ACT_Skills_for_Scout
.\scripts\Install-ActSkillsForScout.ps1 -Publish -Apply
```

`-Publish -Apply` invokes
`Publish-ActScoutBundleToOneDrive.ps1`, updates the managed OneDrive library,
creates or confirms the source machine's junctions, and publishes the MCP
profile catalog. It also enables Scout's **Load Copilot CLI skills** setting,
which exposes `%USERPROFILE%\.copilot\skills` in the Skills UI, and
automatically registers the five reviewed MCP profiles: Flint, Fabric docs,
Azure DevOps read-only, Azure Kusto read-only, and YouTube. The installer
requires valid Scout settings JSON and creates a timestamped backup before
changing that preference. Without `-Apply`, the script only previews the bundle
operation.

Before making changes, the installer asks the operator to disable Scout's
built-in `/excalidraw` skill, which can interfere with the Mermaid and
Illustrator skills. Disable it in Scout before entering `Y`; use
`-ExcalidrawDisabled` only to attest to that prerequisite for a deliberate
unattended install.

## Install on a Machine

After OneDrive synchronizes the library, run this once on that machine from the
synced library:

```powershell
Set-Location "$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout"
.\Install-ActSkillsForScout.ps1 -Apply
```

The bootstrap creates a named junction for each published skill:

```text
%USERPROFILE%\.copilot\skills\act-constellation-curation\
%USERPROFILE%\.copilot\skills\act-critical-review\
%USERPROFILE%\.copilot\skills\act-session-closeout\
```

It refuses to replace an existing directory or a junction with a different
target. Resolve that conflict deliberately rather than overwriting it.

Restart Scout after installation. The installer enables
`loadCopilotCliSkills` so the junctioned ACT skills appear in the Skills UI; do
not import duplicate copies through the UI.

## MCP Profile Registration

The ACT installer registers Flint, Fabric docs, Azure DevOps read-only for
`GlobalCustomerExperience`, Azure Kusto read-only, and YouTube automatically.
Preview or independently manage a specific profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint
```

Apply only that profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint -Apply -Confirm:$false
```

The catalog contains production, controlled-pilot, managed-availability, and
deferred profiles. Every applied profile creates a timestamped configuration
backup and refuses to replace a differing entry. Fabric RTI is applied only
when its environment file disables unknown services and defines an explicit
non-production Kusto allow-list. Restart Scout, then run each profile's
recorded harmless canary. See [`MCP-CATALOG.md`](MCP-CATALOG.md) for the
reviewed server contracts, prerequisites, and safety boundaries.

To remove a reviewed profile, first inspect the rollback preview and then run
it explicitly:

```powershell
.\Uninstall-ActMcpProfile.ps1 -Profile flint
.\Uninstall-ActMcpProfile.ps1 -Profile flint -Apply -Confirm:$false
```

## Updates

1. Update and commit the source package in the GitHub repository.
2. Run `Install-ActSkillsForScout.ps1 -Publish -Apply` on the publishing machine.
3. Wait for OneDrive synchronization to complete on the other machines.
4. Start a new Scout conversation where necessary.

Existing junctions already point at the synchronized folders, so no reinstall
is needed for an in-place update.

## Removal

On a configured machine, run:

```powershell
Set-Location "$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout"
.\Uninstall-ActSkillsForScout.ps1 -Apply
```

The removal script deletes only junctions that point to this exact library. It
does not remove a conflicting directory, an unrelated junction, the OneDrive
library, the Copilot CLI skill-loading preference, or any MCP registration.
Remove MCP profiles independently.

## Current Source-Machine Validation

On 2026-08-28, the published v1.10.0 library and its 14-record MCP catalog
passed local validation. The following catalog profiles are registered in the
active Scout installation and passed their harmless post-restart canaries:

| Profile | Verified boundary | Canary |
| --- | --- | --- |
| `flint` | Pinned chart server with local file references disabled. | `validate_chart` using inline data. |
| `fabric-docs-ro` | `Microsoft.Fabric.Mcp` 1.4.0 through the Windows ARM64 `fabmcp.cmd` launcher, docs namespace only, read-only, and no tenant access. | `docs` with `learn=true`. |
| `azure-devops-ro` | Pinned `@azure-devops/mcp@2.9.0` for `GlobalCustomerExperience`, with the catalog's host-level read-only tool allow-list. | `core_list_projects`. |
| `azure-kusto-ro` | Pinned `@azure/mcp@3.0.0-beta.38` in read-only Kusto namespace mode. | `kusto` with `learn=true`. |
| `youtube-mcp-tools` | Source-pinned, locally built public YouTube research server without configured API or direct-provider credentials. | `youtube_quota_status`. |

`fabric-rti-ro` remains unregistered. It requires an explicit non-production
Kusto service allow-list and this machine cannot currently retrieve its pinned
PyPI package because of a TLS handshake failure.

On 2026-08-28, the v1.11.0 installer was also tested against an isolated Scout
settings file. It enabled `loadCopilotCliSkills` with one timestamped backup,
preserved the enabled setting on a repeat install without creating another
backup, and rejected malformed settings JSON before creating a skill junction.

On 2026-08-28, the v1.12.0 installer was tested against isolated Scout settings
and MCP configuration. It registered all five automatic profiles, migrated only
the exact catalogued legacy Azure DevOps and YouTube entries to their hardened
allow-lists, made no changes on a repeat install, and rejected an unrecognised
Azure DevOps entry.

## Scope and Evidence

Historical delivery evidence: this mechanism passed OneDrive propagation and
one-time bootstrap across two Windows machines for the three v0.1.0 skills.
v0.3.0 extended `act-vscode-workspace-bootstrap` with merge-safe GitHub and
Azure DevOps scaffolding; v0.4.0 added `act-skill-library-update`, which lets
Scout invoke the synced-library installer after explicit user confirmation.
Each newly added skill still needs one manual installer run per machine to
create its junction. The mechanism is independent of Scout's native
custom-skill lifecycle, whose stale-state behavior makes it unsuitable as the
installation source of truth.

On 2026-08-26, the v0.4.0 updater was manually linked on a second machine and
then successfully invoked in Scout by the request `update skills`. It read the
v0.4.0 manifest, previewed the exact installer command, requested confirmation,
and preserved all five matching junctions.

The historical v1.1.1 publication hardened `act-skill-inventory-report` for
all host-reported scopes. On 2026-08-26, its OneDrive library was published
and all 19 source-machine junctions were confirmed. That record does not
validate v1.4.0. The v1.4.0 package is published on the source machine, its 26
local junctions and published skill payload were verified, and its
host-specific Flint MCP canary passed. Remaining work is fresh-conversation
validation for all skills, manual installation on each target machine, and
second-machine update propagation. macOS support has not been evaluated.
