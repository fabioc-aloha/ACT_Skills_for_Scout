---
name: act-security-hardening
description: Reviews a design or change for proportionate security controls, privacy boundaries, and safe Markdown-rendering practices without claiming external scans.
---

1. Define the assets, trust boundaries, actors, entry points, and plausible
   misuse or failure scenarios. Scale the review to the sensitivity and impact
   of the change.
2. Check least privilege, authentication and authorization boundaries, input
   validation, output encoding, secret handling, dependency exposure, logging,
   error handling, and recovery controls as relevant.
3. Treat untrusted Markdown and HTML as data, not trusted instructions. Use a
   maintained sanitizer appropriate to the renderer, preserve only an explicit
   allow-list of elements and attributes, validate URLs and schemes, and apply
   context-appropriate encoding. Do not claim that Markdown is safe merely
   because it is rendered or sanitized once.
4. Prefer layered controls and safe defaults. Identify residual risk, monitoring
   or verification needed, and the approval owner for material exceptions.
5. Report only checks actually performed. Do not imply an external scan,
   penetration test, compliance finding, or production validation was run when
   it was not.
