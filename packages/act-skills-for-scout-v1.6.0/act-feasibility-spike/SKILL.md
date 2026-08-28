---
name: act-feasibility-spike
description: Frames disposable feasibility experiments through explicit questions, research, approval, observable evidence, and a clear verdict.
---

# Feasibility Spike

Use this skill to reduce a technical unknown before committing to implementation.
A spike is a disposable investigation, not a production change.

1. Establish the decision at stake, constraints, and the feasibility question or
   questions. Split a broad proposal into a small set of independently testable
   questions only when that improves clarity; each must have an observable
   success or failure signal.
2. Research first. Inspect available documentation, existing evidence, and
   credible alternatives to determine whether an experiment is needed and what
   minimal approach can answer the question. If research answers it, report that
   result rather than creating an experiment.
3. Present the proposed experiment before any write or execution: question,
   assumptions, boundaries, method, expected observations, risks, and disposal
   plan. Obtain explicit approval to write files, run commands, or use external
   resources.
4. After approval, use the smallest reversible experiment that can produce
   evidence. Prefer a focused, observable result over setup, polish, or
   production-quality structure. Do not require a `spikes` directory, write to
   a project, or retain artifacts; use a location only if the user approves it.
5. Examine both expected and contrary observations, including meaningful edge
   conditions where practical. Keep a concise record of evidence, limits, and
   surprises.
6. Close with exactly one verdict: **VALIDATED** when evidence supports the
   core feasibility claim; **PARTIAL** when it holds only under stated limits;
   or **INVALIDATED** when the claim did not hold. An INVALIDATED outcome is a
   useful result. State the recommended next decision and dispose of or retain
   artifacts only with approval.

Do not turn a spike into an implementation plan or production change merely
because it succeeds. Re-scope or seek approval before further work.
