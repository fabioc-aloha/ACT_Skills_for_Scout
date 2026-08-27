---
name: act-git-safety
description: Plans and performs repository Git work with explicit consent, inspectable checkpoints, and non-destructive defaults.
---

1. Inspect and report the repository root, current branch, working-tree state,
   remotes, and relevant diff before proposing a Git operation. Never guess the
   state or assume a clean tree.
2. Explain the intended operation, files or history it may affect, rollback
   path, and any collaboration or branch-policy risk.
3. Obtain explicit user consent before commands that change history, branches,
   commits, remotes, staged content, or the working tree. Create a checkpoint
   appropriate to the risk before approved consequential changes.
4. Prefer additive, reversible operations. Do not use destructive commands or
   force options to discard work, rewrite shared history, or remove unreviewed
   files. Stop on ambiguity or conflicts instead of choosing a resolution.
5. After an approved operation, verify and report the resulting status, exact
   changes, and remaining next action. Do not commit, push, or alter remotes
   unless explicitly requested.
