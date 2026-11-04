---
name: nasa-handbook
description: Make printable technical documents in the style of Apollo-era NASA paperwork, typeset with XeLaTeX and drawn with TikZ. A one-page mode models an Apollo Operations Handbook "Systems Data" page (typed running head, numbered paragraphs, Leroy-lettered drawings and schematics, data table, NOTE/CAUTION/WARNING, checklist card, thumb tab, dated footer). A handbook mode makes long documents in the same look, with a cover, revision record, contents, UML-style diagrams, requirements, decision records (ADRs) and appendices, structured after the NASA Systems Engineering Handbook. Use this whenever someone asks for NASA-style, Apollo-style, retro aerospace or "mission manual" documentation. Also use it for a technical explainer, spec sheet, one-pager, system description or design handbook that should look like vintage engineering paperwork, or for "another one of those NASA pages", even if they never say Apollo or handbook.
compatibility: opencode
metadata:
  opencode/slash: "true"
---

# NASA handbook page

This skill makes one-page (or few-page) technical documents that read like a
1969 Apollo Operations Handbook page. Handbook mode (below) makes documents
of any length in the same style. A typed running head sits over numbered
paragraphs, followed by a hero line drawing, a second figure, a data table, a
caution and a crew checklist. The thumb tab and the dated footer finish the
page. It suits real subjects (a codebase, a product, a protocol) and fictional
ones (a portal gun). For real subjects, the page should leave the reader
understanding the technical idea. For fiction, it should be convincing.

Pages are LaTeX documents using the bundled `nasa-handbook` class, compiled
with XeLaTeX; figures are TikZ pictures in millimetre coordinates.

Finished pages ship with the skill. Look at the PNGs before you start;
they are the bar:
- `assets/examples/portal-gun-device.png` (+ `.tex`): a fictional device. It
  has a general arrangement drawing with callouts, dimensions and a section
  view, an electrical schematic, and a deadpan WARNING.
- `assets/examples/espresso-fluid-system.png` (+ `.tex`): a fictional machine
  built on real physics (brewing at lunar-habitat cabin pressure). It has a
  general arrangement with a section view, a fluid and electrical schematic
  with station tags, and a chart.

## Resource paths

Paths here are relative to this skill's directory (the base directory reported
when the skill loads):

- `assets/nasa-handbook.cls`: the class. It sets the page, the fonts, the
  running head, footer and thumb tab (drawn on every page), the numbered
  paragraphs, the figure, table, notice and checklist environments, the TikZ
  drawing styles and the fit check.
- `assets/template.tex`: a skeleton of every block. Start every page from it.
- `assets/handbook-template.tex`: the skeleton for handbook mode. It has a
  cover, revision record, contents, preface, sections with UML-style figures,
  a requirements table, a decision record, procedures and appendices.
- `assets/fonts/`: Routed Gothic (Leroy lettering), Letter Gothic and their
  licences. Copy the folder next to the page.
- `scripts/render.sh`: compiles the page with XeLaTeX, prints the room left
  above the footer, and exits 3 when the page overflows onto an extra page.
- `scripts/check.py`: checks the page count, the page size, black and white
  only, and the fonts. It writes the PNG preview next to the PDF and cuts
  300 dpi half-width tiles for the visual review (`--out DIR` to choose where).
- `references/style-guide.md`: anatomy, space budget, typography, writing
  voice, which figures to draw, drawing taste, pitfalls, variants, and
  handbook mode (§10). Read it
  in full for your first page in a session.
- `references/tikz-parts.md`: copy-paste drawing parts (boxes, drums, wires,
  breakers, switches, talkbacks, callouts, dimensions, section views,
  timelines, sequence and parts strips, valves, pumps, gauges, sensors,
  station tags, charts, and UML-style component, sequence, state and process
  flow diagrams).
- `references/sources.md`: the scanned originals and what each taught.

## Workflow

1. **Understand the subject and find its one idea.** This is the sentence the
   reader must leave with ("the coffee brews at sea-level pressure in a sealed
   circuit"). For a real system, read its spec or README and the code. Grep
   every number you intend to print (limits, sizes, intervals, retries, key
   bindings, UI strings) and prefer the code when docs disagree. For fiction,
   invent a consistent specification first: name, what it does, five to eight
   numbers with units, its controls and its one dangerous failure mode.

2. **Plan the page on paper before drawing.** Decide the blocks in the order
   they appear: intro (3 lines), hero figure, functional description
   (4 lines), one underlined mechanism (2 lines), secondary figure (with
   optional DETAIL insets), data table (6–8 rows), one notice, a checklist
   (6–7 steps). Pick figure types from the table in style guide §5. Write the
   text now; it is short, and writing it shows what the figures must explain.

3. **Set up the folder.** Use the folder the user names. Otherwise use a new
   folder in the current project or working directory.
   ```sh
   mkdir -p <out> && cp <skill>/assets/template.tex <out>/<name>.tex && cp <skill>/assets/nasa-handbook.cls <out>/ && cp -R <skill>/assets/fonts <out>/fonts
   ```
   The folder then compiles on its own with `xelatex <name>.tex`.

4. **Fill the template.** Set the page metadata in `\nhsetup` (keys: `doc`,
   `title`, `part`, `section`, `subsection`, `subsystem`, `tab`, `tab top` in
   mm, `mission`, `basic date`, `change date`; brace any value) and replace
   every `[BRACKETED]` placeholder. A figure is
   `\begin{nhfigure}[top y]{height}{number}{caption}{code}`: the box spans
   y from `top y` (default 0) to `top y + height`. Draw the figures from `tikz-parts.md` parts in
   millimetre coordinates (origin top left, y down, 180 wide). Use the class's
   styles (`o`, `w`, `wa`, `ld`, `dim`, `box`, `lbl`…) instead of ad-hoc line
   widths or arrow tips. Don't add colours, logos or texture.

5. **Render and fit.** Run `sh <skill>/scripts/render.sh <out>/<name>.tex`
   (add the page count as a second argument for multi-page sections). The
   `fit:` line reports the space left above the footer; aim for 4–10 mm. It
   exits 3 on overflow. Then cut words or a table row, not type size. In the
   lower band, trim whichever column is taller (style guide §2). On a LaTeX
   error it prints the error from the log.

6. **Check and look.** Run
   `uv run --no-project --with pymupdf python <skill>/scripts/check.py <out>/<name>.pdf --out <out>/tiles`
   (add `--pages N` for multi-page sections). It must report the expected
   page count and black and white only. Then open the preview
   `<out>/<name>.png` and every tile it lists, and look for:
   - a line or leader crossing or touching text (keep 0.6 mm clear)
   - labels touching each other or a box edge
   - a dimension value sitting on its line
   - a clipped word, or a part drawn outside its figure
   - a pattern used with two meanings
   - an arrow pointing at the wrong thing

   Fix them, then repeat steps 5 and 6. Most of the quality comes from this
   loop; expect three to six passes.

7. **Deliver.** Give the PDF as the print file and the PNG as the preview, and
   show it if you have a preview tool. The `.tex` with the class and fonts
   beside it is the editable source. Say what the page explains. For real
   subjects, list the files you checked the numbers against. Mention anything
   deliberately simplified.

## Handbook mode

Use handbook mode when the subject needs more than a page or two: a system
description, a design document, a best-practices handbook. The look is the
same. Only the length and the structure change. Read style guide §10 first.

1. **Outline the document before drawing.** Start with 1. INTRODUCTION and
   2. DOCUMENTS. Then give one section to each part of the subject (for
   example system overview, design solution, operations). Put abbreviations
   and the glossary in appendices. Under each section, list the numbered
   paragraphs and the figure each paragraph introduces.
2. **Set up** as in step 3 below, but copy `handbook-template.tex`.
3. **Write to KSC-DF-107.** Use *shall* only for verifiable requirements. Give
   every requirement a rationale and a verification method. Introduce each
   figure and table in the text before it appears. Order notices as warning,
   caution, note.
4. **Draw complex systems UML-style**, with parts from `tikz-parts.md`: a
   component diagram for structure, a sequence diagram for the key exchange, a
   state machine for modes and a process flow for procedures.
5. **Record the non-obvious choices** as `nhdecision` records (ADR form:
   status, context, options with a trade matrix, decision, rationale,
   consequences). For real subjects, the reasons must come from the repo's
   history or docs. Don't invent them.
6. **Render and check**: `render.sh` runs XeLaTeX twice so the contents fill
   in, and prints `fit: handbook, N pages`. Run `check.py … --pages 0`, then
   look at every page and its tiles as in step 6 below.

## What makes it look right

These are the calls that separate a convincing page from a costume.
`style-guide.md` has the full reasoning.

- **Structure over texture.** The genre is carried by the running head,
  numbered paragraphs, figure codes, change bar, thumb tab and dated footer.
  Leave out coffee stains, noise, rotated stamps and NASA insignia.
- **Three typefaces, three jobs.** Letter-spaced serif typewriter text for
  prose. Leroy caps for everything inside a drawing. Letter Gothic only on the
  checklist card. All caps is the genre here, not a style mistake.
- **One idea, two figures.** The hero figure draws the one idea; the secondary
  shows how it behaves over time or in detail. Everything else supports them.
- **Flat, exact voice.** Third person, present tense, numbers with units,
  controls in caps as placarded, UI strings quoted exactly.
- **Text is never crossed by a line.** Leaders start just outside their label
  and end on the part. Move a label rather than shrink it.
- **Drafting-sized details.** Line weights from 0.16 to 0.5 mm, arrowheads
  about 2 mm long, labels 2.05 to 2.5 mm. The class's styles already encode
  this; use them instead of ad-hoc strokes.
- **Pure black on pure white.** Differentiate with hatching and dotted
  outlines. Printers turn any tint or grey into dots.
- **Truth first on real subjects.** A precise-looking page with a wrong number
  is worse than one row fewer.

## Variants

US Letter (`\documentclass[letter]{nasa-handbook}`), multi-page sections,
controls-and-displays pages, engineering drawing sheets, Technical Note covers
and the 1975 Helvetica look are all covered in style guide §9; handbook mode
is §10. The page
structure, the drawing rules and the check loop stay the same.

## Requirements

- XeLaTeX from TeX Live 2021 or later (MacTeX on macOS), with `fontspec`,
  `pgf`/TikZ (3.1.6 or later, for `patterns.meta`), `tabularx` and
  `geometry`. All are in a full TeX Live install.
- `uv` (or a Python with `pymupdf`), for `check.py`.
- Iowan Old Style ships with macOS. Elsewhere the body falls back to TeX Gyre
  Pagella, and Helvetica Neue (for the flagged "1" in drawing labels) falls
  back to TeX Gyre Heros. Both ship with TeX Live.
