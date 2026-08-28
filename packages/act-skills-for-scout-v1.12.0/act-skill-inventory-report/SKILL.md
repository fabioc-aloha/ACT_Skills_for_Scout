---
name: act-skill-inventory-report
description: Generates a current skill-inventory report from the live Scout host. Use when a user asks to list skills, inventory skills, or report the current ACT skill library.
---

1. Call `m_list_skills`; treat its returned skill name, ID, scope, enabled state,
   and description as authoritative. Do not infer or add host inventory entries.
2. State the total host-reported skill count in one short sentence before the
   table. Include disabled skills returned by the host.
3. Present exactly one GitHub-flavored Markdown table with the columns `Skill`,
   `Scope`, `Enabled`, `ID`, `Description`, `Source/Version`, and `Last update`.
   Display Global skills first, then Bundled skills, then any other host-reported
   scopes alphabetically. Sort names alphabetically within every scope. Add a
   total row after every displayed scope, including Local, and a final `All
   skills` row whose Description gives the scope counts.
4. When the host reports a Global ACT skill, optionally read
   `$env:OneDrive\Documents\ScoutSkills\ACT_Skills_for_Scout\library-manifest.json`.
   If available, use its `packageVersion` for `Source/Version` and its
   `publishedAt` for `Last update`. If unavailable, use `Not exposed`.
5. For bundled skills, use `Host bundled` for `Source/Version`. For every other
   host-reported skill that is not a Global ACT skill, use `Not exposed`.
   Use `Not exposed` for `Last update` unless the host itself returned a
   timestamp. Do not label a Local skill with an inferred origin or creation
   time.
6. Keep each description concise but faithful to the live host inventory. Do not
   infer, fabricate, or reuse stale timestamps or descriptions.
7. If the optional ACT manifest is available but `m_list_skills` reports no
   matching Global ACT rows, state that visibility gap in one short sentence
   after the table, including the manifest version and its number of listed
   skills. Do not add manifest-only skills to the table.
8. Do not run an installer, create or remove links, update skills, write to a
   repository, modify settings, or access user data beyond the host inventory
   and optional ACT manifest.
