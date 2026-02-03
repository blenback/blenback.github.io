#!/usr/bin/env Rscript

cat("Fetching assets from GitHub...\n")

# Load required packages
if (!require("httr", quietly = TRUE)) {
  install.packages("httr", repos = "https://cloud.r-project.org")
  library(httr)
}
if (!require("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite", repos = "https://cloud.r-project.org")
  library(jsonlite)
}

# Ensure publications directory exists
if (!dir.exists("publications")) {
  dir.create("publications")
}

# Ensure assets directory exists at the base of the repo
if (!dir.exists("assets")) {
  dir.create("assets")
}

# GitHub repository information
repo_owner <- "blenback"
repo_name <- "profi"
branch <- "main"

# Add timestamp to bypass GitHub's CDN cache
cache_buster <- format(Sys.time(), "%Y%m%d%H%M%S")

# Define YAML files to download
files <- list(
  "publications/publications.yaml" = sprintf(
    "https://raw.githubusercontent.com/blenback/profi/main/publications.yaml?cache=%s",
    cache_buster
  ),
  "publications/theses.yaml" = sprintf(
    "https://raw.githubusercontent.com/blenback/profi/main/theses.yaml?cache=%s",
    cache_buster
  ),
  "publications/student_theses.yaml" = sprintf(
    "https://raw.githubusercontent.com/blenback/profi/main/student_theses.yaml?cache=%s",
    cache_buster
  ),
  "publications/other_outputs.yaml" = sprintf(
    "https://raw.githubusercontent.com/blenback/profi/main/other_outputs.yaml?cache=%s",
    cache_buster
  )
)

# Download each YAML file
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

# Download all files from the assets folder using GitHub API
cat("\nDownloading assets folder...\n")
assets_api_url <- sprintf(
  "https://api.github.com/repos/%s/%s/contents/assets?ref=%s",
  repo_owner,
  repo_name,
  branch
)

tryCatch(
  {
    # Get list of files in the assets folder
    response <- GET(assets_api_url)

    if (status_code(response) == 200) {
      assets_list <- fromJSON(content(response, "text", encoding = "UTF-8"))

      # Download each file to the base assets directory
      for (i in seq_len(nrow(assets_list))) {
        if (assets_list$type[i] == "file") {
          file_name <- assets_list$name[i]
          download_url <- assets_list$download_url[i]
          local_path <- file.path("assets", file_name)

          tryCatch(
            {
              download.file(download_url, local_path, quiet = TRUE, mode = "wb")
              cat("Downloaded asset:", file_name, "\n")
            },
            error = function(e) {
              cat(
                "Error downloading",
                file_name,
                ":",
                conditionMessage(e),
                "\n"
              )
            }
          )
        }
      }
    } else {
      cat(
        "Warning: Could not access assets folder (HTTP",
        status_code(response),
        ")\n"
      )
      cat("Assets folder may not exist yet in the source repository.\n")
    }
  },
  error = function(e) {
    cat("Error accessing GitHub API:", conditionMessage(e), "\n")
    cat("Assets were not downloaded.\n")
  }
)

cat("\nAll YAML content files and assets updated successfully!\n")
