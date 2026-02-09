```markdown
Repo for my personal website: [https://blenback.github.io/](https://blenback.github.io/) created with [Quarto](https://quarto.org/). 

## Content Management

### Publications
Publications are managed via YAML files in the `publications/` directory and fetched from the [profi repository](https://github.com/blenback/profi) using `fetch-assets.R`.

### Presentations
Presentations are managed through a YAML-based system:
- Presentation metadata is stored in `presentations.yaml` in the [profi repository](https://github.com/blenback/profi)
- `fetch-assets.R` fetches the YAML file during pre-render
- `create_presentation_qmds.R` generates individual `.qmd` files directly in the `presentations/` directory
- See `presentations/README.md` for detailed documentation

Both scripts run automatically as pre-render steps defined in `_quarto.yml`.

``` 
