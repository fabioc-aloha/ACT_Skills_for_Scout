---
name: act-vscode-workspace-bootstrap
description: Adds the approved Scout Markdown settings and stylesheet to a selected workspace. Use when a user wants to bootstrap a repository or workspace with the canonical .vscode configuration.
---

1. Ask for the target repository or workspace path if it is not explicit.
2. Inspect the target `.vscode` directory and report which of these paths already
   exist: `.vscode/settings.json` and `.vscode/markdown-light.css`.
3. Read `references/templates/.vscode/settings.json` and
   `references/templates/.vscode/markdown-light.css` as the canonical templates.
4. Before writing, show the user the exact target paths and whether each will be
   created, merged, left unchanged, or requires a conflict decision.
5. Create `.vscode/` when absent. If `settings.json` is absent, copy the
   template. If it exists and is valid JSON, preserve all existing settings and
   add `.vscode/markdown-light.css` to `markdown.styles` only when missing.
6. If `markdown-light.css` is absent, copy the template. If it differs from the
   canonical template, do not overwrite it without explicit user approval.
7. Do not add Scout skill, prompt, agent, instruction, MCP, extension, or
   workspace-trust configuration. Do not modify files outside the target
   `.vscode` directory.
8. After the approved change, report the paths changed and any preserved
   settings. Do not claim the workspace is fully validated unless the user opens
   Markdown preview in their editor.
