#!/usr/bin/env Rscript

cat("Fetching publication data from GitHub...\n")

# Ensure publications directory exists
if (!dir.exists("publications")) {
  dir.create("publications")
}

# Define files to download
files <- list(
  "publications/publications.yaml" = "https://raw.githubusercontent.com/blenback/profi/main/publications.yaml",
  "publications/theses.yaml" = "https://raw.githubusercontent.com/blenback/profi/main/theses.yaml",
  "publications/student_theses.yaml" = "https://raw.githubusercontent.com/blenback/profi/main/student_theses.yaml",
  "publications/other_outputs.yaml" = "https://raw.githubusercontent.com/blenback/profi/main/other_outputs.yaml"
)

# Download each file
for (filepath in names(files)) {
  url <- files[[filepath]]
  tryCatch(
    {
      download.file(url, filepath, quiet = TRUE, mode = "wb")
      cat("Downloaded", basename(filepath), "\n")
    },
    error = function(e) {
      cat(
        "Error downloading",
        basename(filepath),
        ":",
        conditionMessage(e),
        "\n"
      )
    }
  )
}

cat("\nAll publication data files updated successfully!\n")
