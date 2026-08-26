# Local-Folder Probe Report

**Date**: 2026-08-26
**Platform**: Windows 11 Enterprise Insider Preview
**Scout version**: 1.0.73
**Probe package**: `probes/local-folder/act-skills-for-scout-probe/SKILL.md`

## Result

The request `Run the ACT Skills for Scout local folder probe.` returned the
required response:

```text
ACT Skills for Scout local-folder probe discovered.
```

The probe folder was present at:

```text
C:\Users\fabioc\.copilot\skills\act-skills-for-scout-probe\
```

Its only file was `SKILL.md`. The package has no tools, scripts, resources,
credentials, external calls, or file-writing behavior.

## Baseline

- The current local custom-skill inventory did not list
  `act-skills-for-scout-probe`.
- `loadCopilotCliSkills` was not enabled or changed.
- No Scout settings, automations, cloud state, marketplace registrations, or
  source files were changed by this probe.

## Removal Test

The probe folder was deleted:

```text
C:\Users\fabioc\.copilot\skills\act-skills-for-scout-probe\
```

In a separate new Scout conversation, the same request did not run the removed
probe. Instead, it returned:

```text
Probe blocked: the ACT Scout skill bridge found no installed source for the
first allowlisted skill:

C:\Users\fabioc\.copilot\installed-plugins\alex-mall\alex-act-core\.github\skills\act-tenets\SKILL.md
```

The expected plugin source directory was absent, `loadCopilotCliSkills` remained
disabled, and no local folders or Scout configuration were changed by that
session.

## Conclusion

Windows local-folder discovery passed. The removal/non-discovery test is
**inconclusive**: the folder was absent, but an unexpected ACT bridge intercepted
the follow-up request. Do not claim a clean removal lifecycle until that bridge
behavior is independently traced and the test is repeated in a clean Scout
session.

## Scope and Remaining Verification

This result does not validate Plugin Mall delivery, Copilot plugins,
synchronization, updates, UI management, or macOS.
