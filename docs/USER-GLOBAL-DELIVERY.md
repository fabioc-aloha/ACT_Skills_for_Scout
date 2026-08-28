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

## v1.7.0 Production Package

`v1.7.0` is the publisher default. Its 27 direct skill folders include
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
profile catalog. Without `-Apply`, the script only previews the bundle
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

Open a new Scout conversation after installation. Do not enable
`loadCopilotCliSkills` or import these folders into the native Scout Skills UI
for this delivery path.

## MCP Profile Registration

MCP profiles are installed separately from the skill bundle. Preview a specific
profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint
```

Apply only that profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint -Apply -Confirm:$false
```

The catalog contains production, controlled-pilot, managed-availability, and
deferred profiles. Every applied profile creates a timestamped configuration
backup and refuses to replace a differing entry. Restart Scout, then run that
profile's recorded harmless canary. See [`MCP-CATALOG.md`](MCP-CATALOG.md) for
the reviewed server contracts, prerequisites, and safety boundaries.

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
library, or any MCP registration. Remove MCP profiles independently.

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
