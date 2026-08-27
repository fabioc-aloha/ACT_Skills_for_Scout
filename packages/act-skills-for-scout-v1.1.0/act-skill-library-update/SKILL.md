---
name: act-skill-library-update
description: Updates the current machine's linked ACT skills from the synced OneDrive library. Use when the user says "update skills", "refresh ACT skills", or asks to enable newly published ACT skills on this machine.
---

1. Verify that `$env:OneDrive` is available and that this installer exists:
   `$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout\Install-ActSkillsForScout.ps1`.
   If either is absent, explain that OneDrive must finish syncing before skills
   can be updated.
2. Read `library-manifest.json` from the same OneDrive library and report its
   `packageVersion` and skill list. Inspect the matching paths under
   `$HOME\.copilot\skills` to identify which skills are already linked and which
   published skills need a junction.
3. Preview this exact command and the expected linked paths:

   ```powershell
   & "$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout\Install-ActSkillsForScout.ps1"
   ```

   State that it may create only missing named junctions under
   `$HOME\.copilot\skills`, will preserve existing matching junctions, and will
   stop rather than replace a conflicting local path.
4. Ask for explicit confirmation after showing the preview. Do not execute the
   command until the user confirms.
5. After confirmation, run the command exactly as previewed. Do not add
   `-Publish`, do not edit the OneDrive library, and do not remove any skill.
6. Report the installer output and the resulting linked skill names. Tell the
   user to start a new Scout conversation to use newly linked skills.
7. Do not modify a repository, workspace, Scout setting, native custom-skill
   inventory, plugin, marketplace, or cloud-sync configuration.
