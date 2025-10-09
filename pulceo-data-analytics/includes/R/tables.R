source(here("includes/R/libraries.R"))

install_and_load("kableExtra")
install_and_load("DT")
install_and_load("tidyverse")


CreateScrollableTable <- function(df, removeCols = NULL) {
  if (!is.null(removeCols)) {
    df <- select(df, -all_of(removeCols))
  }
  CreatePaginatedTableDT(df)
}

CreatePaginatedTableDT <- function(df, pageLength = 10) {
  datatable(df, options = list(pageLength = pageLength), rownames = FALSE)
}
