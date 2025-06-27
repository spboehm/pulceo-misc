source(here("includes/R/libraries.R"))

install_and_load("kableExtra")

CreateScrollableTable <- function(df) {
  (kbl(df) %>% scroll_box(width = "100%", height = "400px") %>% kable_styling(bootstrap_options = c("striped", "hover", "condensed")))
}
