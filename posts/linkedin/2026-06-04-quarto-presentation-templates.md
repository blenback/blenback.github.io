If you work in research you know the format problem: some audiences want a live HTML deck, others need a PowerPoint file. Maintaining two separate slide sets for the same talk is tedious and error-prone.

Quarto solves this with multi-format output - list both `revealjs` and `pptx` in your document's `format:` block and a single `quarto render` produces both from the same source.

For the DML group I took this further and built a custom Quarto extension for our RevealJS presentations. It packages a brand file (colours, fonts), a custom title slide via a Pandoc template partial, and two interactive JavaScript diagram components injected after the body - a clickable service pillar ring and a tiered support overview. Both components hook into Reveal's slide navigation to reset cleanly when you move through the deck.

The PPTX side uses a `.potx` reference template so the PowerPoint output picks up the same branding. The translation from HTML to PPTX isn't perfect for complex layouts, but for standard content it produces something on-brand rather than the bare Quarto default.

Both templates are open and available in the DML templates repository: https://github.com/iat-dml/templates

#Quarto #RStats #OpenScience #ReproducibleResearch #PresentationDesign
