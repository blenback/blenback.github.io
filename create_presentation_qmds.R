#!/usr/bin/env Rscript

cat("Creating presentation QMD files from YAML...\n")

# Load required packages
if (!require("yaml", quietly = TRUE)) {
  install.packages("yaml", repos = "https://cloud.r-project.org")
  library(yaml)
}

# Read the presentations YAML file
presentations_file <- "presentations/presentations.yaml"
if (!file.exists(presentations_file)) {
  stop("presentations.yaml file not found at: ", presentations_file)
}

presentations <- yaml::read_yaml(presentations_file)

cat("Found", length(presentations), "presentations\n")

# Function to create QMD file from presentation data
create_qmd_file <- function(pres) {
  # Use filename if provided, otherwise use folder name as filename
  filename <- if (!is.null(pres$filename)) {
    pres$filename
  } else {
    paste0(pres$folder, ".qmd")
  }

  # Create the full path - directly in presentations directory
  output_file <- file.path("presentations", filename)

  # Start building the YAML frontmatter
  yaml_parts <- list()
  yaml_parts$title <- pres$title

  if (!is.null(pres$description)) {
    yaml_parts$description <- pres$description
  }

  # Handle author/authors
  if (!is.null(pres$authors) && length(pres$authors) > 0) {
    yaml_parts$author <- pres$authors
  } else if (!is.null(pres$author)) {
    yaml_parts$author <- pres$author
  }

  if (!is.null(pres$event)) {
    yaml_parts$event <- pres$event
  }

  if (!is.null(pres$location)) {
    yaml_parts$location <- pres$location
  }

  if (!is.null(pres$date)) {
    yaml_parts$date <- pres$date
  }

  if (!is.null(pres$image)) {
    yaml_parts$image <- pres$image
  }

  if (!is.null(pres$`image-height`)) {
    yaml_parts$`image-height` <- pres$`image-height`
  }

  if (!is.null(pres$`image-alt`)) {
    yaml_parts$`image-alt` <- pres$`image-alt`
  }

  if (!is.null(pres$citation)) {
    yaml_parts$citation <- pres$citation
  }

  if (!is.null(pres$categories)) {
    yaml_parts$categories <- pres$categories
  }

  if (!is.null(pres$`preload-iframes`)) {
    yaml_parts$`preload-iframes` <- pres$`preload-iframes`
  }

  if (!is.null(pres$draft)) {
    yaml_parts$draft <- pres$draft
  }

  # Convert to YAML string with handlers to ensure booleans are true/false not yes/no
  yaml_handlers <- list(
    logical = function(x) {
      result <- ifelse(x, "true", "false")
      class(result) <- "verbatim"
      return(result)
    }
  )

  yaml_string <- yaml::as.yaml(
    yaml_parts,
    indent = 2,
    indent.mapping.sequence = TRUE,
    handlers = yaml_handlers
  )

  # Build the content section
  content_parts <- c()

  # Add main content if exists
  if (!is.null(pres$content)) {
    content_parts <- c(content_parts, pres$content)
  }

  # Add extra images if they exist
  if (!is.null(pres$extra_images)) {
    for (img in pres$extra_images) {
      img_line <- sprintf("![]( %s)", img$path)
      if (!is.null(img$alt)) {
        img_line <- sprintf("![]( %s){fig-alt=\"%s\"", img$path, img$alt)
        if (!is.null(img$align)) {
          img_line <- paste0(img_line, sprintf(" fig-align=\"%s\"}", img$align))
        } else {
          img_line <- paste0(img_line, "}")
        }
      }
      content_parts <- c(content_parts, "", img_line, "")
    }
  }

  # Add embed code
  if (!is.null(pres$embed_type)) {
    if (pres$embed_type == "pdf") {
      embed_path <- pres$embed_path
      embed_code <- sprintf(
        '\n```{=html}\n<div class="embed-container">\n  <p align="center"><iframe src="%s" style="border: 0.5px" ></iframe\n  /p>\n</div>\n```',
        embed_path
      )
      content_parts <- c(content_parts, embed_code)
    } else if (pres$embed_type == "iframe") {
      width <- if (!is.null(pres$embed_width)) pres$embed_width else "100%"
      height <- if (!is.null(pres$embed_height)) pres$embed_height else "600px"
      frameborder <- if (!is.null(pres$frameborder)) pres$frameborder else "0"

      if (
        !is.null(pres$embed_url) && grepl("^https://1drv.ms", pres$embed_url)
      ) {
        # Microsoft Office embed
        embed_code <- sprintf(
          '\n```{=html}\n<div class="embed-container">\n  <p align="center"><iframe src="%s" width="%s" height="%s" frameborder="%s">This is an embedded <a target="_blank" href="https://office.com">Microsoft Office</a> presentation, powered by <a target="_blank" href="https://office.com/webapps">Office</a>.</iframe>\n  </p>\n</div>\n```',
          pres$embed_url,
          width,
          height,
          frameborder
        )
      } else {
        # Generic iframe embed
        embed_code <- sprintf(
          '\n```{=html}\n<div class="embed-container">\n  <p align="center"><iframe src="%s" style="border: 0.5px" ></iframe\n  /p>\n</div>\n```',
          pres$embed_url
        )
      }
      content_parts <- c(content_parts, embed_code)
    }
  }

  # Combine everything
  full_content <- paste(
    "---",
    yaml_string,
    "---",
    "",
    paste(content_parts, collapse = "\n"),
    sep = "\n"
  )

  # Write to file
  writeLines(full_content, output_file)
  cat("Created:", output_file, "\n")
}

# Generate QMD files for all presentations
for (pres in presentations) {
  tryCatch(
    {
      create_qmd_file(pres)
    },
    error = function(e) {
      cat(
        "Error creating QMD for",
        pres$id,
        ":",
        conditionMessage(e),
        "\n"
      )
    }
  )
}

cat("\nAll presentation QMD files created successfully!\n")
