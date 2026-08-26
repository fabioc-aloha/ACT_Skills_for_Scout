# Local-Folder Discovery Probe

## Goal

Test whether current Scout discovers a harmless Agent Skills-compatible folder
placed in the documented local skill directory. This test does not validate
Plugin Mall, Copilot plugins, cross-device synchronization, updates, or macOS.

## Package Under Test

`probes/local-folder/act-skills-for-scout-probe/SKILL.md`

The probe has one unique natural-language trigger and returns a short text-only
response. It has no tools, scripts, resources, credentials, or file writes.

## Preconditions

1. Record the Scout version, operating system, `loadCopilotCliSkills` state, and
   installed custom-skill inventory.
2. Confirm no existing folder has the probe name.
3. Read [UNINSTALL.md](UNINSTALL.md) and identify the removal path before copying
   the probe.
4. Do not test in a session that began before the package was copied.

## Windows Test

1. Copy the entire `act-skills-for-scout-probe` folder to:

   ```text
   %USERPROFILE%\.copilot\skills\act-skills-for-scout-probe\
   ```

2. Start a new Scout conversation.
3. Ask: `Run the ACT Skills for Scout local folder probe.`
4. Record whether Scout discovers and follows the probe.
5. Remove the folder using [UNINSTALL.md](UNINSTALL.md).
6. Start another new Scout conversation and repeat the request. Scout must no
   longer discover the probe.

## Success Criteria

- The probe is discovered in a new conversation only while the folder exists.
- The probe does not alter files, settings, skills, automations, or cloud state.
- After removal, the same request no longer activates the probe.

## Stop Conditions

Stop and document the result if Scout does not discover the folder, requires an
undocumented setting change, discovers the probe in an existing session, or
leaves a persistent registry or sync record after removal.

## macOS

Repeat the same test on macOS before claiming cross-platform local-folder
support. Do not infer macOS behavior from the Windows result.
