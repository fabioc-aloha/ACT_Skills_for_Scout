# v1.3.0 Provenance and Adaptation

## Method

This is a curated Scout-native package, not a source-tree copy. The source
paths below were read as evidence only. Each target skill is a portable,
standalone `SKILL.md` with no scripts, MCP configuration, credentials, external
calls, or source-repository assumptions. Source references were not copied
unless they were already part of the retained v0.4.0 package contract.

| Scout-native skill | Evidence source paths | Adaptation |
| --- | --- | --- |
| `act-constellation-curation` | `Alex_ACT_Steward\.github\skills\append-and-review\SKILL.md`; `Alex_ACT_Steward\.github\skills\promotion-criterion\SKILL.md` | Retains v0.4.0 curation flow; adds general, reversible evidence and review safeguards without Mall or fleet telemetry. |
| `act-critical-review` | `Alex_ACT_Steward\.github\skills\epistemic-integrity-audit\SKILL.md`; `Alex_ACT_Steward\.github\skills\semantic-qa\SKILL.md`; `Alex_ACT_Core\.github\skills\adversarial-review\SKILL.md`; `Alex_ACT_Core\.github\skills\deep-review\SKILL.md`; `Alex_ACT_Core\.github\skills\code-review\SKILL.md` | Retains v0.4.0 decision review and adds portable epistemic, semantic, adversarial, deep, and implementation checks. |
| `act-session-closeout` | Retained v0.4.0 package `act-session-closeout\SKILL.md` and `references\handoff-checklist.md` | Preserved portable closeout contract and checklist. |
| `act-meditation-continuity` | `Alex_ACT_Core\.github\skills\meditation\SKILL.md`; retained `act-session-closeout\SKILL.md` and `references\handoff-checklist.md` | Adapts signal-only meditation into Scout-native continuity: current-state evidence, approval-first merged handoffs, recurrence-gated reuse, and evidence-based postmortems without automatic writes, memory, publication, or cross-machine sharing. |
| `act-vscode-workspace-bootstrap` | Retained v0.4.0 package `act-vscode-workspace-bootstrap\SKILL.md` and `references\templates\` | Preserved merge-safe, approval-first templates and no-guessed-pipeline rule. |
| `act-skill-library-update` | Retained v0.4.0 package `act-skill-library-update\SKILL.md` | Preserved explicit-confirmation synced-OneDrive installer flow. |
| `act-critical-thinking` | `Alex_ACT_Core\.github\skills\critical-thinking\SKILL.md`; `anti-hallucination\SKILL.md`; `act-tenets\SKILL.md` | Condenses evidence, alternatives, bias, falsifiability, and calibrated conclusions. |
| `act-problem-framing` | `Alex_ACT_Core\.github\skills\problem-framing-audit\SKILL.md` | Converts framing audit principles into portable problem-definition guidance. |
| `act-implementation-planning` | `Alex_ACT_Core\.github\skills\plan\SKILL.md`; `risk-analysis\SKILL.md` | Generalizes planning and risk treatment; does not force files or writes. |
| `act-systematic-debugging` | `Alex_ACT_Core\.github\skills\systematic-debugging\SKILL.md` | Retains evidence-led reproduction, hypothesis testing, root-cause tracing, and verification without source references. |
| `act-test-driven-development` | `Alex_ACT_Core\.github\skills\test-driven-development\SKILL.md` | Retains behavior-first testing without forced deletion or automatic writes. |
| `act-security-hardening` | `Alex_ACT_Core\.github\skills\security-and-hardening\SKILL.md`; `markdown-sanitization-chain\SKILL.md` | Generalizes hardening and safe rendering principles; makes no external-scanning claim. |
| `act-git-safety` | `Alex_ACT_Core\.github\skills\git-workflow\SKILL.md` | Centers explicit consent, checkpoints, inspectability, and non-destructive defaults. |
| `act-documentation-hygiene` | `Alex_ACT_Core\.github\skills\doc-hygiene\SKILL.md`; `lint-clean-markdown\SKILL.md` | Applies hygiene and Markdown quality while deferring to repository conventions. |
| `act-writing-craft` | `Alex_ACT_Core\.github\skills\communication-craft\SKILL.md`; `big-idea\SKILL.md`; `humanizer\SKILL.md` | Combines clarity and reader value while preserving voice and grounding claims. |
| `act-status-reporting` | `Alex_ACT_Core\.github\skills\status-reporting\SKILL.md` | Makes status reporting explicitly evidence-bounded and access-neutral. |
| `act-responsible-ai-review` | `Alex_ACT_Core\.github\skills\ethical-reasoning\SKILL.md` | Adapts stakeholder, privacy, responsibility, transparency, and reversibility review. |
| `act-library-health-audit` | `Alex_ACT_Steward\.github\skills\brain-audit\SKILL.md` | Strips source scripts, ownership assumptions, and output writes; produces findings and proposals only. |
| `act-content-currency-audit` | `Alex_ACT_Steward\.github\skills\currency-audit\SKILL.md` | Retains evidence-led currency assessment with proposal-first changes. |
| `act-skill-inventory-report` | User-specified Scout inventory reporting contract | Uses the host API as authoritative, adds totals for every returned scope, and only enriches host-reported ACT rows with the optional local library manifest. |
| `act-feasibility-spike` | `Alex_ACT_Core\.github\skills\spike\SKILL.md` | Reframes feasibility investigation as optional, disposable, research-first experimentation with approval before any write or execution and evidence-based verdicts. |
| `act-browser-safety` | `Alex_ACT_Core\.github\skills\browser-tools\SKILL.md` | Retains only capability-conditional interaction and privacy, secret-handling, consent, and untrusted-content safeguards; no browser implementation claims are carried over. |
| `act-project-capability-authoring` | `Alex_ACT_Core\.github\skills\project-capability-authoring\SKILL.md` | Generalizes evidence of recurrence, prior-art review, smallest placement, preview, approval, contract, and focused validation without automatic artifact or memory writes. |

## Exclusions

The following source skills are excluded from this payload: `brain-compiler`,
`fleet-status`, `mall-curation`, `manage-scout-copilot-skill-bridge`,
`bootstrap-core`, `bootstrap-project`, `terminal-command-safety`,
`proactive-awareness`, `platform-awareness`, and `surface-continuity`.

All plugin, runtime, platform, browser, MCP, tool-bound, source-script, and
source-ownership artifacts are also excluded. Source runtime, tool, and
version claims are expressly excluded. In particular, no content was
sourced from `Alex_ACT_Steward\_github_backup` or any archive.
