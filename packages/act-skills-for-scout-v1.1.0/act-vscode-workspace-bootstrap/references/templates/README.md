# Workspace and DevOps Template Provenance

The `.vscode` templates are the profile-neutral canonical assets from
`C:\Development\Alex_Scout_Integration\.vscode` as of 2026-08-26.

The `.vscode` files configure only Markdown preview styling. The GitHub and Azure
DevOps templates are generic, static scaffolding authored for this package.
They do not enable Scout skill, prompt, agent, instruction, MCP, extension,
workspace-trust, credential, or branch-policy discovery.

`azure-pipelines.yml.template` is deliberately not an active pipeline. A target
project must supply its own reviewed build, test, package, and deployment
commands before it can become `azure-pipelines.yml`.
