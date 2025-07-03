source(here("includes/R/libraries.R"))

install_and_load("kableExtra")
install_and_load("DT")


CreateScrollableTable <- function(df) {
  (kbl(df) %>% scroll_box(width = "100%", height = "400px") %>% kable_styling(bootstrap_options = c("striped", "hover", "condensed")))
  #CreatePaginatedTableDT(df)
}

CreatePaginatedTableDT <- function(df, pageLength = 10) {
  datatable(df, options = list(pageLength = pageLength), rownames = FALSE)
}
