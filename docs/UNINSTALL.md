# Uninstall Instructions

Read this document before installing any test package.

## Local-Folder Probe

The current probe is a folder copied into the documented personal skill
directory. It has no installer, service, registry, or external dependency.

### Windows

Delete only this exact folder:

```text
%USERPROFILE%\.copilot\skills\act-skills-for-scout-probe\
```

Use File Explorer or remove the directory through a reviewed local command.
Then start a **new** Scout conversation and verify that asking for the probe no
longer activates it.

### macOS

Delete only this exact folder:

```text
~/.copilot/skills/act-skills-for-scout-probe/
```

Use Finder or remove the directory through a reviewed local command. Then start
a **new** Scout conversation and verify non-discovery.

## Future Local Package

A future production package will be removed by its named folder under the same
skills root. Removal must move the target to a timestamped local backup first,
then verify non-discovery in a new conversation. Do not delete unrelated skill
folders.

## Future Plugin Mall Package

No Plugin Mall package exists today. If a future package is published through
Copilot CLI, uninstall it with the exact published package name:

```text
copilot plugin uninstall <package-name>@<marketplace-name>
```

Only remove a marketplace registration when no other installed package depends
on it:

```text
copilot plugin marketplace remove <marketplace-name>
```

Do not use these commands during the local-folder probe. The probe does not
install Copilot CLI, register a marketplace, or create an installed plugin.
