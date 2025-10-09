# common.R

# constants
PRS_LOG_DIRECTORY <- "../prs-worker-logs"

# functions
install_and_load <- function(pkg, mirror = "https://cloud.r-project.org") {
  # Set default CRAN mirror and silent options
  options(repos = c(CRAN = mirror))
  options(install.packages.check.source = "no")
  options(ask = FALSE)

  # Install if missing
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing '%s'...", pkg))
    install.packages(pkg, dependencies = TRUE, quiet = TRUE)
  }

  # Load package quietly
  suppressPackageStartupMessages(
    library(pkg, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
  )
}