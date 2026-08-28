---
name: act-vscode-workspace-bootstrap
description: Adds approved merge-safe GitHub, Azure DevOps, editor, and Scout .vscode scaffolding to a selected workspace. Use when a user wants to bootstrap a repository or workspace without overwriting existing configuration.
---

1. Ask for the target repository or workspace path if it is not explicit.
2. Inspect the target's Git remote, root files, `.vscode/`, `.github/`, and
   `.azuredevops/` directories. Identify existing `azure-pipelines.yml`,
   `.editorconfig`, and `.gitignore`.
3. Read the canonical templates in `references/templates/`. Select only the
   GitHub, Azure DevOps, and editor artifacts that match the target and the
   user's stated needs.
4. Before writing, show the user a table of every target path and whether it will
   be created, merged, left unchanged, or needs a conflict decision. Obtain
   explicit approval for the reviewed plan.
5. Create missing `.editorconfig` and `.gitignore` from their templates. For
   existing files, preserve all existing content and append only missing
   ACT-marked blocks after user approval. Never remove or reorder existing lines.
6. Create a missing `.github/PULL_REQUEST_TEMPLATE.md` and/or
   `.azuredevops/pull_request_template.md` from the matching template. If either
   exists, preserve it and offer to append only the missing checklist sections
   under an ACT-marked heading.
7. Use `azure-pipelines.yml.template` only after the user supplies the build,
   test, package, and deployment expectations. Never create an active
   `azure-pipelines.yml` containing guessed commands. If an active pipeline
   exists, preserve it and propose a minimal reviewed patch rather than replacing
   it.
8. Read `references/templates/.vscode/settings.json` and
   `references/templates/.vscode/markdown-light.css`. Create `.vscode/` when
   absent. If `settings.json` exists and is valid JSON, preserve all settings and
   add `.vscode/markdown-light.css` to `markdown.styles` only when missing. If
   the stylesheet differs from the canonical template, do not overwrite it
   without explicit approval.
9. Do not add Scout skill, prompt, agent, instruction, MCP, extension,
   workspace-trust, credential, or branch-policy configuration. Do not modify
   files outside the approved target paths.
10. After the approved change, report the paths changed, content merged, and
    conflicts intentionally preserved. Do not claim CI or Markdown preview is
    validated unless it was actually run or opened.
