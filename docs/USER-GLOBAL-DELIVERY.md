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
        | Install-ActSkillsForScout.ps1 -Publish
        v
OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout\
  Synced personal library
        |
        | Install-ActSkillsForScout.ps1 (once per machine)
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

## v1.4.0 Source-Machine Publication and Flint MCP Canary

`v1.4.0` is the publisher default. Its 26 direct skill folders are published to
the source user's OneDrive library, and the Flint MCP canary passed on that
machine. Fresh-conversation coverage for all skills and second-machine
validation remain pending. The library shape is:

The standard library path is:

```text
%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout\
```

It contains:

```text
Install-ActSkillsForScout.ps1
Uninstall-ActSkillsForScout.ps1
library-manifest.json
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

`-Publish -Apply` updates the managed OneDrive library, creates or confirms the
source machine's junctions, and registers Flint. Without `-Apply`, the script
only previews the bundle operation.

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

## Flint MCP Registration

Flint is installed with the skill bundle. Preview the complete operation:

```powershell
.\Install-ActSkillsForScout.ps1
```

Apply the complete operation:

```powershell
.\Install-ActSkillsForScout.ps1 -Apply -Confirm:$false
```

The entry launches `npx -y flint-chart-mcp@0.5.1
--disable-file-reference`. `npx` resolves the pinned package on first server
launch; the installer does not create a global npm installation. It creates a
timestamped backup, refuses to replace any differing `flint` entry, and does
not expose local file references. Restart Scout, then confirm the Flint tools
and run a harmless visual canary.

To remove only the reviewed entry, first inspect the rollback preview and then
run it explicitly:

```powershell
.\Uninstall-ActSkillsForScout.ps1
.\Uninstall-ActSkillsForScout.ps1 -Apply -Confirm:$false
```

## Updates

1. Update and commit the source package in the GitHub repository.
2. Run `Install-ActSkillsForScout.ps1 -Publish` on the publishing machine.
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
does not remove a conflicting directory, an unrelated junction, or the OneDrive
library itself.

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
