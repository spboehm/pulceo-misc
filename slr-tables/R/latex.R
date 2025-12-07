ReplaceSymbol <- function(symbol) {
  switch(symbol,
         "y" = "\\\\ding{51}",
         "n" = "\\\\ding{55}",
  )
}

CreateLaTeXTable <- function(dataframe) {
  # kbl_fn_footnote_as_chunk = TRUE
  # kbl_fn_threeparttable = TRUE
  # kbl_fn_general_title = ""
  #
  # sPropsKblCaption <- "Obtained Static Node Properties"
  #
  # sPropsKbl <- kbl(sPropsMutated, "latex", escape = FALSE, caption = sPropsKblCaption, booktabs = TRUE) %>%
  #   kable_styling(latex_options = "scale_down") %>%
  #   footnote(., general = c("C: Cloud, F: Fog, E: Edge, G: Gateway, CPU: Central Processing Unit, Mem: Memory, Disk: Storage, Net: Network"), general_title = kbl_fn_general_title, footnote_as_chunk = kbl_fn_footnote_as_chunk, threeparttable = kbl_fn_threeparttable)

  # save_kable(sPropsKbl, "latex/nodes-static-properties.tex")
}

SaveLatexTable <- function(data, caption, label, filename, position = "tb", table_env = 'table') {
  latex_table <- kbl(data, "latex", escape = FALSE, caption = caption, booktabs = TRUE, linesep="", vline="", label = label, position = position, digits = 3, table.env = table_env) %>% 
    kable_styling(latex_options="scale_down")
  save_kable(latex_table, paste("latex", filename, sep = "/"))
}

SaveMultiRowLatexTable <- function(data, caption, label, filename, position = "tb", table_env = 'table', multi_column, align = NULL) {
  latex_table <- kbl(data, "latex", escape = FALSE, caption = caption, booktabs = TRUE, linesep="", vline="", label = label, position = position, digits = 3, table.env = table_env, align = align) %>% 
    collapse_rows(columns = multi_column, valign = "middle", latex_hline = "major") %>% 
    kable_styling(latex_options="scale_down")

  save_kable(latex_table, paste("latex", filename, sep = "/"))
}

SaveMultiColLatexTable <- function(summary, caption, label, filename, colnames, header, position = "t") {
  latex_table <- kbl(data, "latex", escape = FALSE, caption = caption, booktabs = TRUE, linesep="", vline="", label = label, col.names=colnames, position = position, digits = 3) %>%
    kable_styling(full_width = TRUE) %>% 
    add_header_above(header)
  
  save_kable(latex_table, paste("latex", filename, sep = "/"))
}