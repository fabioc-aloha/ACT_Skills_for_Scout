# ACT Skills for Scout

![ACT Skills for Scout banner](assets/act-skills-scout-banner.svg)

Install a user-global bundle of 27 ACT skills and a curated MCP profile catalog
for Microsoft Scout on Windows. Applied skill installations automatically enable
Scout's Copilot CLI skill discovery bridge.

## Prerequisites

- Microsoft Scout
- OneDrive signed in for the user
- Node.js, npm, and `npx` available on `PATH`

## Install on Your Primary Machine

Clone this repository, open PowerShell at the repository root, then preview the
operation:

```powershell
.\scripts\Install-ActSkillsForScout.ps1 -Publish
```

Apply the installation:

```powershell
.\scripts\Install-ActSkillsForScout.ps1 -Publish -Apply
```

This publishes the bundle to
`%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout`, creates user-global
skill junctions under `%USERPROFILE%\.copilot\skills`, and publishes the
MCP profile catalog. It also registers Flint, Fabric docs, Azure DevOps
read-only for `GlobalCustomerExperience`, Azure Kusto read-only, and YouTube;
Fabric RTI is registered only when its validated non-production allow-list is
present. Restart Scout when the command completes.

Every applied skill installation enables Scout's **Load Copilot CLI skills**
setting so the user-global junctions are visible in the Skills UI. The
installer validates `%USERPROFILE%\.scout\m-settings.json`, creates a
timestamped backup before changing that setting, and preserves it on uninstall.

Before any installation changes, the script requires confirmation that the
built-in `/excalidraw` skill was disabled in Scout because it can interfere with
the Mermaid and Illustrator skills. For an intentional unattended install, pass
`-ExcalidrawDisabled` to attest that this was already done.

## Automatic MCP Profiles

Applied skill installation automatically registers the five reviewed profiles:
Flint, Fabric docs, Azure DevOps read-only, Azure Kusto read-only, and
YouTube. Use the profile installer only to preview, remove, or explicitly
manage a profile:

```powershell
.\Install-ActMcpProfile.ps1 -Profile flint
.\Install-ActMcpProfile.ps1 -Profile flint -Apply -Confirm:$false
```

Fabric RTI is the exception: it is registered only when
`%USERPROFILE%\.scout\mcp-env\fabric-rti.env` explicitly disables unknown
services and lists approved non-production Kusto services. See
[`docs/MCP-CATALOG.md`](docs/MCP-CATALOG.md) for all prerequisites and canaries.

## Install or Update on Another Machine

Wait for OneDrive to synchronize, then run:

```powershell
Set-Location "$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout"
.\Install-ActSkillsForScout.ps1 -Apply
```

The command creates missing skill links and preserves matching links. Install
or update MCP profiles independently after a synchronized update, then restart
Scout.

## Update the Publishing Machine

Pull the new repository version and rerun the complete publishing command:

```powershell
git pull
.\scripts\Install-ActSkillsForScout.ps1 -Publish -Apply
```

## Uninstall

From the synced OneDrive bundle folder, preview removal:

```powershell
.\Uninstall-ActSkillsForScout.ps1
```

Then apply it:

```powershell
.\Uninstall-ActSkillsForScout.ps1 -Apply -Confirm:$false
```

This removes only ACT skill junctions that point to this bundle. It preserves
the OneDrive library, Copilot CLI skill-loading preference, and every MCP
registration; remove MCP profiles separately with `Uninstall-ActMcpProfile.ps1`.

## Included Capabilities

The bundle provides reasoning, planning, review, documentation, safety,
continuity, browser-safety, native Office authoring, and Flint chart/theme
skills. Its MCP catalog automatically installs Flint, Fabric docs, Azure DevOps
read-only, Azure Kusto read-only, and YouTube; Fabric RTI remains conditional
on its non-production allow-list.
