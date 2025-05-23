source(here("includes/R/libraries.R"))

install_and_load("kableExtra")
install_and_load("here")

SaveLatexTable <- function(summary, caption, label, filename, position = "t") {
  latex_table <- kbl(summary, "latex", escape = FALSE, caption = caption, booktabs = TRUE, linesep = "", vline = "", label = label, position = position, digits = 2) %>% kable_styling(full_width = TRUE)
  save_kable(latex_table, here(paste("latex", SUBFOLDER, filename, sep = "/")))
}

SaveMultiColLatexTable <- function(summary, caption, label, filename, colnames, header, position = "t") {
  latex_table <- kbl(summary, "latex", escape = FALSE, caption = caption, booktabs = TRUE, linesep = "", vline = "", label = label, col.names = colnames, position = position, digits = 2) %>%
    kable_styling(full_width = TRUE) %>%
    add_header_above(header)

  save_kable(latex_table, here(paste("latex", SUBFOLDER, filename, sep = "/")))
}