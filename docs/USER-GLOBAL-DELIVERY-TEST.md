# User-Global OneDrive Delivery Test

## Goal

Validate a low-friction delivery path in which one versioned ACT skill package is
published to the user's OneDrive library, then discovered by Scout on every
machine without any repository- or workspace-specific setup.

## Boundaries

- The GitHub repository is the source of truth.
- OneDrive distributes the published personal library; it is not a Git working
  copy and contains no `.git` directory.
- Each machine has one user-level bootstrap step to create named junctions under
  `%USERPROFILE%\.copilot\skills`.
- The bootstrap does not install skills into a repository, workspace, Scout's
  custom-skill inventory, a plugin, or a marketplace.
- Native Scout import and cloud sync are outside this delivery path.

## Original v0.1.0 Test

The procedure and result below are the original three-skill v0.1.0 delivery
test. The v0.3.0 workspace-bootstrap addition requires a new publication and
fresh-conversation invocation record.

## Publish on One Machine

From the cloned repository, publish the current package and enable it on the
source machine:

```powershell
.\scripts\Install-ActSkillsForScout.ps1 -Publish
```

This creates the following OneDrive-synchronized library:

```text
%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout\
  Install-ActSkillsForScout.ps1
  Uninstall-ActSkillsForScout.ps1
  library-manifest.json
  skills\
    act-constellation-curation\
    act-critical-review\
    act-session-closeout\
```

The source installer updates only direct skill folders already managed by this
library. It does not remove obsolete folders or junctions.

## Bootstrap on Each Machine

After OneDrive finishes synchronizing, open PowerShell in the synced library and
run:

```powershell
.\Install-ActSkillsForScout.ps1
```

The bootstrap creates these named junctions only if no conflicting path exists:

```text
%USERPROFILE%\.copilot\skills\act-constellation-curation\
%USERPROFILE%\.copilot\skills\act-critical-review\
%USERPROFILE%\.copilot\skills\act-session-closeout\
```

Start a new Scout conversation and invoke each expected request from
[`PACKAGE-IMPORT-TEST-2026-08-26.md`](PACKAGE-IMPORT-TEST-2026-08-26.md).

## Acceptance Criteria

1. Publishing creates a OneDrive library with all three direct skill folders and
   the library manifest.
2. The bootstrap creates only junctions under the user-global Scout skills root.
3. A new Scout conversation discovers each installed skill from that root.
4. A second machine receives the library through OneDrive, runs the bootstrap
   once, and discovers the same skills without cloning this repository or
   configuring any project.
5. Updating a source package, republishing with `-Force`, and allowing OneDrive
   to synchronize changes the files visible through existing junctions.

## Current Result

On 2026-08-26, the v0.1.0 library was published on the source Windows machine
under `%OneDrive%\Documents\ScoutSkills\ACT_Skills_for_Scout`. OneDrive
replicated it to a second machine, where the synced bootstrap created the three
expected user-global junctions. Both machines showed:

```text
act-constellation-curation
act-critical-review
act-session-closeout
```

This passes library propagation and per-machine bootstrap. It does not yet prove
that a fresh Scout conversation invokes every installed skill, nor that a
republished update arrives through already-created junctions.

## v0.2.0 Source-Machine Result

On 2026-08-26, v0.2.0 was published to the OneDrive library and created the
fourth source-machine junction:

```text
act-vscode-workspace-bootstrap
```

The published manifest contains all four direct skill folders. The v0.2.0
library must still synchronize to the second machine, where the installer must
be rerun once to create its fourth junction. A fresh Scout conversation must
then validate discovery and user-approved workspace bootstrap behavior.

## v0.3.0 Pending Result

Version 0.3.0 extends the workspace bootstrap skill with merge-safe GitHub and
Azure DevOps templates. It must be published, installed on each machine, and
validated in a fresh Scout conversation before it can be claimed as available.

## Removal

From the synced OneDrive library, run:

```powershell
.\Uninstall-ActSkillsForScout.ps1
```

The removal script deletes only junctions whose target exactly matches this
library. It never removes the OneDrive source folders or a conflicting existing
skill path.
