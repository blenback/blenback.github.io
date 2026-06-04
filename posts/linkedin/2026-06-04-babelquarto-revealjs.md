Quarto's RevealJS format is great for presentations - but if you work in more than one language, babelquarto's multilingual rendering support hasn't covered slide decks. I've submitted a pull request to change that.

The PR adds RevealJS support to babelquarto, the rOpenSci package for multilingual Quarto output. Two new functions: `quarto_multilingual_presentation()` scaffolds a project using the package's existing file-suffix convention (e.g. `slides.qmd` + `slides.de.qmd`), and `render_presentation()` renders it - injecting a language-switch pill into every slide via HTML post-processing.

The implementation delegates to the existing website rendering pipeline rather than duplicating logic. The pill sits outside the `.reveal` container to avoid CSS transform conflicts, and draws its label from `_quarto.yml` - consistent with how babelquarto handles language naming for books and websites.

If multilingual presentations are something you work with, feedback and testing is welcome. PR at: https://github.com/ropensci-review-tools/babelquarto/pull/128

#RStats #Quarto #OpenScience #ReproducibleResearch #rOpenSci
