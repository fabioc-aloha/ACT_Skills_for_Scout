---
name: act-office-native-authoring
description: Creates native Word, PowerPoint, or Excel artifacts through available Scout Co-create capabilities, using approved source material as a semantic brief rather than converting Markdown.
---

# Office Native Authoring

Use this skill when the user needs a polished Word document, PowerPoint
presentation, or Excel workbook built from approved Markdown, notes, data, or
other source material, especially when direct Markdown conversion would be
technically correct but visually generic.

## Outcome

Use available Scout Co-create Office capabilities to author a native Office
artifact from scratch. Treat source material as a semantic content model, not as
a file to convert. Preserve the source unless the user explicitly asks to edit
it.

1. Read the complete approved source. Identify its hierarchy, facts, tables,
   lists, citations, calculations, decisions, audience, and deliberate section
   boundaries.
2. Select the format that fits the requested outcome: `.docx` for structured
   narrative content, `.pptx` for a concise presentation narrative, or `.xlsx`
   for a data, calculation, planning, or tracking model. Ask only when the
   outcome does not establish a suitable format.
3. Create a compact content model before authoring. Preserve source meaning
   while adapting it to native Office conventions; never map Markdown syntax
   directly to Office elements.
4. Use the host's native Office artifact-creation capability. Specify the
   format, audience, source-derived content and structure, visual intent,
   tables, calculations, charts, citations, and quality constraints. Do not
   invent source facts, metadata, labels, or identifiers.
5. For a requested change to a cloud artifact reachable through the active host,
   use its native artifact-editing capability rather than recreating the file.
6. If the required native Office capability is unavailable, explain the
   limitation. Use a local format-specific workflow only when the user
   explicitly requests a local or offline deliverable.

## Format-specific Design

### Word

Use a clear document hierarchy with a title block, headings, concise
paragraphs, readable lists, well-proportioned tables, limited callouts, and
unobtrusive headers and footers. Preserve citations and intentional page
boundaries without introducing arbitrary decoration.

### PowerPoint

Create a focused slide narrative, not a document split across slides. Use
concise titles and native diagrams, charts, images, tables, or speaker notes
when they clarify the message. Give every slide a clear purpose and avoid dense
text-only layouts.

### Excel

Create a usable workbook with meaningful sheet names, structured tables,
correct data types and number formats, formulas for recalculable results, data
validation where needed, and charts only when they support a decision. Do not
hardcode results that should be formulas.

## Completion Standard

Deliver a native Office artifact whose information hierarchy, content accuracy,
and visual design serve the intended audience. State that it was authored
natively from the approved source, rather than converted from Markdown, when
that distinction matters.
