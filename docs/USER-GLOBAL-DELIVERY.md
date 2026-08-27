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
        | Publish-ActSkillsLibrary.ps1
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

## Published Library

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
```

Each folder directly beneath `skills\` must contain a `SKILL.md`. This direct
folder shape is the contract consumed by the bootstrap and exposed to Scout.

## Publish

On the machine that maintains the repository, update the source package and
publish it:

```powershell
Set-Location C:\Development\ACT_Skills_for_Scout
.\scripts\Publish-ActSkillsLibrary.ps1
```

For an existing published library, update its managed skill folders:

```powershell
.\scripts\Publish-ActSkillsLibrary.ps1 -Force
```

The publisher copies only direct skill folders and the two bootstrap scripts.
It does not modify `~\.copilot\skills`, Scout settings, a project, a workspace,
or native Scout custom skills.

## Install on a Machine

After OneDrive synchronizes the library, run this once on that machine from the
synced library:

```powershell
Set-Location "$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout"
.\Install-ActSkillsForScout.ps1
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

## Updates

1. Update and commit the source package in the GitHub repository.
2. Run `Publish-ActSkillsLibrary.ps1 -Force` on the publishing machine.
3. Wait for OneDrive synchronization to complete on the other machines.
4. Start a new Scout conversation where necessary.

Existing junctions already point at the synchronized folders, so no reinstall
is needed for an in-place update.

## Removal

On a configured machine, run:

```powershell
Set-Location "$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout"
.\Uninstall-ActSkillsForScout.ps1
```

The removal script deletes only junctions that point to this exact library. It
does not remove a conflicting directory, an unrelated junction, or the OneDrive
library itself.

## Scope and Evidence

This mechanism has passed OneDrive propagation and one-time bootstrap across two
Windows machines for the three v0.1.0 skills. It is independent of Scout's
native custom-skill lifecycle, whose stale-state behavior makes it unsuitable as
the installation source of truth.

Remaining validation is to invoke each skill in a new Scout conversation and to
verify that a published update is visible through the existing junctions on the
second machine. macOS support has not been evaluated.
