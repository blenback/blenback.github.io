# Presentations Management

This directory uses a YAML-based system to manage presentation content and automatically generate Quarto `.qmd` files.

## How it works

1. **presentations.yaml**: Fetched from the [profi repository](https://github.com/blenback/profi) via `fetch-assets.R` during the pre-render step
2. **create_presentation_qmds.R**: R script that reads the YAML and generates `.qmd` files directly in the `presentations/` directory
3. Individual presentation QMD files: Named using the `folder` field value (e.g., `2024_20_6_WBF.qmd`) or custom `filename` if specified

## File structure

- Presentations YAML is managed in the `profi` repository
- QMD files are auto-generated locally (not tracked in git)
- Both scripts run automatically as pre-render steps in `_quarto.yml`

## Adding a new presentation

Edit `presentations.yaml` in the [profi repository](https://github.com/blenback/profi) and add a new entry:

```yaml
- id: unique-identifier-2025
  title: "Presentation Title"
  description: "Brief description of the presentation"
  author: "Author Name(s) as string"
  authors:
    - Author Name 1
    - Author Name 2
  date: "YYYY-MM-DD"
  event: "Event Name"
  location: "City, Country"
  image: "/assets/image_filename.png"
  image-height: "12000px"  # Optional
  image-alt: "Alt text"     # Optional
  categories:
    - Category 1
    - Category 2
  preload-iframes: true     # Optional, if using iframes
  citation:                 # Optional
    url: "https://doi.org/..."
  draft: true               # Optional, to mark as draft
  
  # CV fields (for curriculum vitae integration)
  cv_date: "Mon. YYYY"      # Abbreviated date format for CV
  cv_event: "Event Name"    # Event name for CV
  cv_location: "Location"   # Location for CV
  cv_type: ""               # Type field for CV (usually empty)
  cv_url: "https://..."     # URL for CV entry
  
  content: |
    Your presentation description and any additional content here.
    Can include Markdown formatting, links, images, etc.
    
    You can add multiple paragraphs.
  
  # For PDF embeds
  embed_type: "pdf"
  embed_path: "/assets/presentation.pdf"
  
  # OR for iframe embeds (e.g., Microsoft Office, websites)
  embed_type: "iframe"
  embed_url: "https://..."
  embed_width: "476px"      # Optional
  embed_height: "288px"     # Optional
  frameborder: "0"          # Optional
  
  # Optional: Extra images to display
  extra_images:
    - path: "/assets/photo1.jpg"
      alt: "Photo description"
      align: "center"
  
  folder: "YYYY_DD_MM_EventName"  # Required: used as the QMD filename
  filename: "custom-name.qmd"      # Optional: override the auto-generated filename
```

**Note:** The `folder` field is required and determines the QMD filename (e.g., `2024_20_6_WBF.qmd`). Use the optional `filename` field only when you need multiple presentations with different names (e.g., multiple presentations at the same conference).

## Regenerating QMD files

QMD files are automatically regenerated during Quarto's pre-render step. To manually regenerate:

```r
source("create_presentation_qmds.R")
```

## Notes

- The `folder` field is required and used as the base filename for the QMD
- The `filename` field is optional - only use it when you need custom naming (e.g., multiple presentations from the same event)
- QMD files are generated directly in the `presentations/` directory
- The script will overwrite existing QMD files when regenerated
- Keep PDF files and images in the `/assets/` directory with descriptive names

## Embed Types

### PDF Embed
For PDF presentations stored in `/assets/`:
```yaml
embed_type: "pdf"
embed_path: "/assets/2024_presentation.pdf"
```

### Generic Iframe
For websites or other iframe content:
```yaml
embed_type: "iframe"
embed_url: "https://example.com/presentation"
```

### Microsoft Office Embed
For OneDrive-hosted PowerPoint presentations:
```yaml
embed_type: "iframe"
embed_url: "https://1drv.ms/p/s!..."
embed_width: "476px"
embed_height: "288px"
```
